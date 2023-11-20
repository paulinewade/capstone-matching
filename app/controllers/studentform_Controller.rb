class StudentformController < ApplicationController
  def index
    user_id = session[:user_id]
    user = User.find_by(user_id: user_id)
    if user
      @first_name = user.first_name
      @last_name = user.last_name
      @email = user.email
    else
      flash[:error] = "Please login with Google account to fill out the form."
      redirect_to root_path
    end

    student = Student.find_by(student_id: user_id)
    if student
      @cid = student.course_id
      @uin = student.uin
      @gender = student.gender
      @nation = student.nationality
      @auth = student.work_auth
      @sign = student.contract_sign
      @ethn = EthnicityValue.where(student_id: student.student_id)
    else
      @ethn = []
    end

    today = Date.today
    current_year = today.year
    semester = ""
    if today.month >= 8 || today.month < 1
      semester = "Fall #{current_year}"
    elsif today.month >= 1 && today.month <= 5
      semester = "Spring #{current_year}"
    else
      semester = "Summer #{current_year}"
    end

    @courses = Course.where(semester: semester)
    @projects = Project.where(semester: semester)
    @ethnicity = Ethnicity.all
    @genders = Rails.application.config.student_status_constants['gender']
    @work_auth = Rails.application.config.student_status_constants['work_auth']
    @contract_sign = Rails.application.config.student_status_constants['contract_sign']
    @nationality = Rails.application.config.student_status_constants['nationality']
    config = Config.first
    @min_number = config.min_number
    @max_number = config.max_number
    @form_open = config.form_open
    @form_close = config.form_close
    @scores_entities = ScoresEntity.where(project_id: @projects.pluck(:project_id), student_id: user_id)
    @project_ranks = {}
    @scores_entities.each do |scores_entity|
      @project_ranks[scores_entity.project_id] = scores_entity.pref
    end
  end

  def create
    # Extract form parameters
    email = params[:email]
    first_name = params[:first_name]
    last_name = params[:last_name]
    uin = params[:uin]
    gender = params[:gender]
    course_id = params[:course_id]
    work_auth = params[:work_auth]
    contract_sign = params[:contract_sign]
    nationality = params[:nationality]
    ethnicities = params[:ethnicity]
    project_ranks = params[:project_rank]

    config = Config.first
    @min_number = config.min_number
    @max_number = config.max_number
    @form_open = config.form_open
    @form_close = config.form_close

    # #form isn't open
    if DateTime.now < @form_open || DateTime.now > @form_close
      flash[:error] = "Form is not currently open, please submit during the specified window."
      redirect_to studentform_path
      return
    end

    if uin.to_s.length != 9
      flash[:error] = "Invalid UIN, make sure your UIN is 9 digits."
      redirect_to studentform_path
      return
    end

    #if any fields are left blank (some are required, but don't have it set as required on their entry field)
    if gender.blank? ||course_id.blank? || work_auth.blank? || contract_sign.blank? || nationality.blank? || ethnicities.empty?
      flash[:error] = "Please fill in all fields in 'Student Information' before submitting."
      redirect_to studentform_path
      return
    end

    non_blank_ranks = project_ranks.to_unsafe_h.reject { |_, value| value.blank? }
    #they rank between min and max projects
    unless non_blank_ranks.size.between?(@min_number, @max_number)
      flash[:error] = "Must rank between #{@min_number} and #{@max_number} (inclusive) projects."
      redirect_to studentform_path
      return
    end

    #make sure that they dont have 2 of the same rank
    if non_blank_ranks.values.group_by { |rank| rank.to_i }.any? { |_, ranks| ranks.length > 1 }
      flash[:error] = "Duplicate ranks found for different projects. Please ensure each project has a unique rank."
      redirect_to studentform_path
      return
    end

    #make sure that the ranks they don't skip any values
    if (1..non_blank_ranks.size).to_a != non_blank_ranks.values.map(&:to_i).sort
      flash[:error] = "Invalid rank sequence. Please ensure ranks are consecutive without skipping any numbers."
      redirect_to studentform_path
      return
    end

    if email.end_with?("tamu.edu")
      existing_user = User.find_by(email: email)
      #update in case user wants to change first/last name
      existing_user.update(first_name: first_name, last_name: last_name, role: "student")
    else
      flash[:error] = "Not a valid tamu.edu email address. Please Google login with a tamu email."
      redirect_to root_path
      return
    end

    # Create a student record associated with the user
    id = existing_user.user_id
    
    #remove all old associated data since we are overriding everything anyways
    existing_student = Student.find_by(student_id: id)
    if existing_student
      existing_student.destroy
    end

    student = Student.new(
      student_id: id,
      course_id: course_id, # you need to extract course_id from the form parameters
      gender: gender,
      uin: uin,
      nationality: nationality, # extract other parameters as needed
      work_auth: work_auth,
      contract_sign: contract_sign,
      resume: "After resume parsing"
    )

    if student.save
      student_id = student.student_id
      #add_multiple ethncities
      ethnicities.each do |ethnicity|
        EthnicityValue.create(student_id: student_id, ethnicity_name: ethnicity)
      end

      #add additional attributes later if needed
      resume_attribute = ScoresAttribute.where("feature LIKE ?", "%Resume%").first
      time_stamp_attribute = ScoresAttribute.where("feature LIKE ?", "%Time%").first
      pref_attribute = ScoresAttribute.where("feature LIKE ?", "%Preference%").first

      resume_attribute_id = resume_attribute.attribute_id if resume_attribute.present?
      time_stamp_attribute_id = time_stamp_attribute.attribute_id if time_stamp_attribute.present?
      pref_attribute_id = pref_attribute.attribute_id if pref_attribute.present?


      #calculate timestamp score based on time submitted relative to the open and close time of the form
      time_range = (@form_close - @form_open).to_f
      time_elapsed = DateTime.now.to_f - @form_open.to_f
      time_score = 1 - time_elapsed/time_range
      rounded_time_score = (time_score * 100).round(2)
      pref_decrease = 1.0/@max_number.to_f

      non_blank_ranks.each do |project_id, pref|
        entity = ScoresEntity.create(student_id: student_id, project_id: project_id, pref: pref)
        scores_id = entity.scores_id

        #pref_score is 1 - ranking*(1/max_number) - we want rank 1 to be a full score which is why we subtract 1
        pref_score = (1.0 - (pref.to_i-1)*pref_decrease) * 100
        
        #caluclate resume score (call helper method to compare student resume to project description here)
        resume_score = 100

        #add each score to DB under the scores_entity that it belongs to (student project pairing)
        ScoresValue.create(scores_id: scores_id, attribute_id: time_stamp_attribute_id, feature_score: rounded_time_score)
        ScoresValue.create(scores_id: scores_id, attribute_id: pref_attribute_id, feature_score: pref_score)
        ScoresValue.create(scores_id: scores_id, attribute_id: resume_attribute_id, feature_score: resume_score)
      end
      flash[:success] = "Registration Successful!"
    else
      flash[:error] = "Failed to save student information."
    end

    redirect_to studentform_path
  end
end
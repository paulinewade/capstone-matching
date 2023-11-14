class StudentformController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    user_id = session[:user_id]
    user = User.find_by(user_id: user_id)
    if user
      @first_name = user.first_name
      @last_name = user.last_name
      @email = user.email
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
    @project_ranks = {}
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
    # if DateTime.now < @form_open || DateTime.now > @form_close
    #   flash[:error] = "Form is not currently open, please submit during the specified window."
    #   redirect_to studentform_path
    #   return
    # end

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
    unless non_blank_ranks.size.between?(@min_number, @max_number)
      flash[:error] = "Must rank between #{@min_number} and #{@max_number} (inclusive) projects."
      redirect_to studentform_path
      return
    end

    if non_blank_ranks.values.group_by { |rank| rank.to_i }.any? { |_, ranks| ranks.length > 1 }
      flash[:error] = "Duplicate ranks found for different projects. Please ensure each project has a unique rank."
      redirect_to studentform_path
      return
    end

    if (1..non_blank_ranks.size).to_a != non_blank_ranks.values.map(&:to_i).sort
      flash[:error] = "Invalid rank sequence. Please ensure ranks are consecutive without skipping any numbers."
      redirect_to studentform_path
      return
    end

    if email.end_with?("tamu.edu")
      existing_student = User.find_by(email: email)

      if existing_student
        new_student = existing_student
      else
        # Create a new student
        new_student = User.new(email: email, first_name: first_name, last_name: last_name, role: "student")
        if !new_student.save
          flash[:error] = "Cannot register this user, try signing in using your tamu Google account."
        end
      end
    else
      flash[:error] = "Not a valid tamu.edu email address."
    end

    
    # Create a student record associated with the user
    id = new_student.user_id
    
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
      ethnicities.each do |ethnicity|
        EthnicityValue.create(student_id: student_id, ethnicity_name: ethnicity)
      end
      flash[:success] = "Registration Successful!"
    else
      flash[:error] = "Failed to save student information."
    end

    redirect_to studentform_path
  end
end
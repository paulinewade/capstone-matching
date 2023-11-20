require 'pdf/reader'
require 'tf-idf-similarity'
require 'matrix'


class StudentformController < ApplicationController
  def index
    # remove dev_mode in prod
    user_id = ''
    if params[:dev_mode] == 'yes'
      user_id = 101
    else
      user_id = session[:user_id]
    end
    
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
    parsed_resume = params[:parsed_resume].to_s
    
    config = Config.first
    @min_number = config.min_number
    @max_number = config.max_number
    @form_open = config.form_open
    @form_close = config.form_close

    user = User.find_by(email: email) 
    if user && user.role != 'student'
      flash[:error] = "Cannot submit the student form if not a student"
      redirect_to studentform_path
      return
    end
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
      resume: parsed_resume
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
        # classify resume
        # need to change to upload_resume(project_description, parsed_resume)
        similarity_score = upload_resume(parsed_resume, project_id)
        # flash[:most_similar_job_description] = @most_similar_job_description
        # flash[:similarity_score] = @similarity_score
        resume_score = (similarity_score * 100).round(2)
        puts "RESUME SCORE RESUME SCORE RESUME SCORE = " + resume_score.to_s

        #add each score to DB under the scores_entity that it belongs to (student project pairing) THIS ADDS NEW SCORES. WHAT IF WE NEED TO REPLACE SCORES
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

  def upload_resume(resume_, project_id_)
    resume = resume_.to_s
    project_id = project_id_.to_i

    
    @project_data = Project.where(project_id: project_id_).pluck(:project_id, :description)
    @project_ids = @project_data.map { |project_id, description| project_id }
    @descriptions = @project_data.map { |project_id, description| description }
    puts "course descriptions: " + @descriptions.join(separator = ",")
    @resume_text = resume

    similarity_scores = classify(@resume_text, @descriptions) # same length as project_ids and descriptions
    puts "similarity_scores: " + similarity_scores.join(separator = ",")

    
    index_of_project_id = @project_ids.index(project_id) # get the index of the project_id that we are getting the match score for
    
    match_score = similarity_scores[index_of_project_id]
    
    puts "match_score: " + match_score.to_s

    
    return match_score
  end
  
  private
  
  # Function to remove stop words from a string
  def remove_stop_words(input_string, stop_words)
    words = input_string.split
    filtered_words = words.reject { |word| stop_words.include?(word.downcase) }
    filtered_string = filtered_words.join(' ')
    return filtered_string
  end

  
  def classify(resume_text, descriptions)
    
    stop_words = [
      "a", "about", "above", "after", "all", "also", "am", "an", "and", "any",
      "are", "as", "at", "be", "because", "been", "before", "being", "between",
      "both", "but", "by", "can", "did", "do", "each", "for", "from", "has",
      "have", "he", "her", "here", "him", "his", "how", "i", "if", "in", "is",
      "it", "its", "just", "like", "me", "my", "of", "on", "or", "our", "she",
      "so", "some", "that", "the", "their", "them", "then", "there", "these",
      "they", "this", "to", "was", "we", "were", "what", "when", "where",
      "which", "who", "will", "with", "you", "your"
    ]
    
    corpus = []
    
    if descriptions.nil? || descriptions.empty?
      puts 'no job descriptions detected for course_id'
      return ['no job descriptions detected for course_id', 0]
    else
      job_descriptions = descriptions
    end

    
    job_descriptions.length.times do |i|
      cleaned = job_descriptions[i].downcase.gsub(/[^a-z\s]/, '')
      simplified = remove_stop_words(job_descriptions[i], stop_words)
      corpus[i] = TfIdfSimilarity::Document.new(simplified)
    end
    
    resumeidx = corpus.length # last index of corpus
    
    # Process the resume and calculate TF-IDF scores
    resume = resume_text
    corpus[resumeidx] = TfIdfSimilarity::Document.new(remove_stop_words(resume.downcase.gsub(/[^a-z\s]/, ''), stop_words))

    model = TfIdfSimilarity::TfIdfModel.new(corpus)
    
    matrix = model.similarity_matrix
    
    similarity_scores = []
    
    # Calculate the cosine similarity between the resume and job descriptions
    (corpus.length - 1).times do |i|
      similarity_scores[i] = matrix[model.document_index(corpus[resumeidx]), model.document_index(corpus[i])]
    end 
    
    return similarity_scores
    
    # Set a threshold for similarity to classify as a match
    # threshold = 0.0
    
    # Find the best match
    # best_match_index = similarity_scores.each_with_index.max[1]
    
    # # Check if the best match is above the threshold
    # if similarity_scores[best_match_index] > threshold
    #   puts "The resume is a match for the job description: #{job_descriptions[best_match_index]}"
    #   return[ job_descriptions[best_match_index], similarity_scores[best_match_index] ]
    # else
    #   puts "No suitable job description found for the resume."
    #   return ["No suitable job description found for the resume.", similarity_scores[best_match_index]]
    # end
    return "done"
  end
end
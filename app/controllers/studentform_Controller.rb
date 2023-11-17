require 'pdf/reader'
require 'tf-idf-similarity'
require 'matrix'


class StudentformController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @courses = Course.all
  end

  def create
    # Extract form parameters
    email = params[:email]
    first_name = params[:first_name]
    last_name = params[:last_name]
    uin = params[:uin]
    gender = params[:gender]
    course_id = params[:course_id]
    ethnicities = params[:ethnicity]
    parsed_resume = params[:parsed_resume].to_s


    if email.end_with?("tamu.edu")
      existing_student = User.find_by(email: email)

      if existing_student
        flash[:error] = "You are already registered using this email."
      else
        # Create a new student
        new_student = User.new(email: email, first_name: first_name, last_name: last_name, role: "student")

        # Save the student to get an ID and use that ID for the student record
        if new_student.save
          # Create a student record associated with the user
          id = new_student.user_id
          student = Student.new(
            student_id: id,
            course_id: course_id, # you need to extract course_id from the form parameters
            gender: gender,
            uin: uin,
            nationality: params[:nationality], # extract other parameters as needed
            work_auth: params[:work_authorization],
            contract_sign: "No",
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
        else
          flash[:error] = "Failed to save user information."
        end
      end
    else
      flash[:error] = "Not a valid tamu.edu email address."
    end
    
    classification = upload_resume(course_id, parsed_resume)
    
    @most_similar_job_description = classification[0]
    @similarity_score = classification[1]
    flash[:most_similar_job_description] = @most_similar_job_description
    flash[:similarity_score] = @similarity_score

    redirect_to "/studentform"
  end
  
  def upload_resume(course_id_, resume_)
    
    course_id = course_id_.to_i
    puts "course_id: " + course_id.to_s
    resume = resume_.to_s
    puts "resume: " + resume 
    
    @descriptions = Project.where(course_id: course_id).pluck(:description)
    puts "course description: " + @descriptions.join(separator = ",")
    @resume_text = resume

    # You can print the extracted text or use it for further processing
    # puts "Extracted Resume Text:"
    # puts @resume_text
    # flash[:resume_text] = @resume_text
    classification = classify(@resume_text, @descriptions)
    
    return classification
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
    
    # Set a threshold for similarity to classify as a match
    threshold = 0.0
    
    # Find the best match
    best_match_index = similarity_scores.each_with_index.max[1]
    
    # Check if the best match is above the threshold
    if similarity_scores[best_match_index] > threshold
      puts "The resume is a match for the job description: #{job_descriptions[best_match_index]}"
      return[ job_descriptions[best_match_index], similarity_scores[best_match_index] ]
    else
      puts "No suitable job description found for the resume."
      return ["No suitable job description found for the resume.", similarity_scores[best_match_index]]
    end
    return "done"
  end
end

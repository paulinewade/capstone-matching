# app/controllers/dev_test_controller.rb

require 'pdf/reader'
# require 'nokogiri'
require 'tf-idf-similarity'
# require 'gensim'
# require 'cosine_similarity'
require 'matrix'



class DevTestController < ApplicationController
  skip_before_action :verify_authenticity_token  # bypass csrf: fix this

  def index
    # ...
  end

  def upload_resume
    
    course_id = params[:course_id].to_i
    # course_id = 101
    puts "course_id: " + course_id.to_s
    
    resume = params[:resume].to_s
    puts "resume: " + resume 
    
    @descriptions = Project.where(course_id: course_id).pluck(:description)
    puts "course description: " + @descriptions.join(separator = ",")
    @resume_text = resume

    # You can print the extracted text or use it for further processing
    # puts "Extracted Resume Text:"
    # puts @resume_text
    flash[:resume_text] = @resume_text
    classification = classify(@resume_text, @descriptions)
    
    @most_similar_job_description = classification[0]
    @similarity_score = classification[1]
    flash[:most_similar_job_description] = @most_similar_job_description
    flash[:similarity_score] = @similarity_score
    
    

    redirect_to '/devtest'  # You can redirect back to the test page
    # render 'index'  # Render the 'index' view after resume processing

  end

  private

  def parse_pdf_resume(file)
    resume_text = ""

    PDF::Reader.open(file) do |reader|
      reader.pages.each do |page|
        resume_text << page.text
      end
    end

    return resume_text
  end
  
  # Function to remove stop words from a string
  def remove_stop_words(input_string, stop_words)
    words = input_string.split
    filtered_words = words.reject { |word| stop_words.include?(word.downcase) }
    filtered_string = filtered_words.join(' ')
    return filtered_string
  end
  
  # it's better to use the id of the project, but this is a hotfix
  def store_score(most_similar_job_description, similarity_score)
    # fill here
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

    
    # # Sample job descriptions and a resume
    # job_descriptions = [
    #   "We are looking for a software engineer with expertise in Ruby and Ruby on Rails.",
    #   "Seeking a front-end developer experienced in JavaScript and React.",
    #   "We need a data scientist skilled in Python and machine learning.", 
    #   "Seeking a back-end engineer equipped with knowledge in JavaScript and React."
    # ]
    
    corpus = []
    job_descriptions = descriptions

    
    job_descriptions.length.times do |i|
      cleaned = job_descriptions[i].downcase.gsub(/[^a-z\s]/, '')
      simplified = remove_stop_words(job_descriptions[i], stop_words)
      corpus[i] = TfIdfSimilarity::Document.new(simplified)
    end
    # puts "text: " + descriptions.join(separator = ",")
    # job_descriptions = descriptions
    
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

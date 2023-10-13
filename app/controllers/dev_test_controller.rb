# app/controllers/dev_test_controller.rb

require 'pdf/reader'

class DevTestController < ApplicationController
  def index
    # ...
  end

  def upload_resume
    if params[:resume].present? && params[:resume].content_type == 'application/pdf'
      uploaded_resume = params[:resume].tempfile
      @resume_text = parse_pdf_resume(uploaded_resume)

      # You can print the extracted text or use it for further processing
      puts "Extracted Resume Text:"
      puts @resume_text
      flash[:resume_text] = @resume_text

    else
      flash[:error] = "Please upload a valid PDF resume."
    end
    
    

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
  
  
end

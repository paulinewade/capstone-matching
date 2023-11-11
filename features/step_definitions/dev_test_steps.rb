# File: features/step_definitions/upload_resume_steps.rb

# Step definition for navigating to the development test page
Given("I am on the development test page") do
  visit '/devtest' # Replace with the actual URL of your development test page
end

# Step definition for filling in the Course ID field
When("I fill in the Course ID field with {string}") do |course_id|
  fill_in 'course_id', with: course_id
end

# Step definition for uploading a valid PDF resume
And("I upload a valid PDF resume") do
  attach_file('resume', File.absolute_path('valid_resume.pdf')) # Replace with the path to a valid PDF file
end

# Step definition for submitting the form
And("I submit the form") do
  click_button 'Submit' # Replace 'Submit' with the actual label of your submit button
  # Optionally add a small delay to allow for the submission process to finish
  sleep 3
end

# Step definition for verifying the extracted text from the resume
Then("I should see the extracted text from the resume") do
  extracted_text = find('#resume_text').text # Replace '#resume_text' with the actual CSS selector for the extracted text area
  # Add expectations to validate the extracted text content
  expect(extracted_text).not_to be_empty
end

# Step definition for verifying the classification result
And("I should see a classification result based on the resume content") do
  job_description = find('#job_description').text # Replace '#job_description' with the actual CSS selector for job description
  similarity_score = find('#similarity_score').text # Replace '#similarity_score' with the actual CSS selector for similarity score
  # Add expectations to validate the presence of job description and similarity score
  expect(job_description).not_to be_empty
  expect(similarity_score).not_to be_empty
end

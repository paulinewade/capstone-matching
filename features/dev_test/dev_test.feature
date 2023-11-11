# File: features/upload_resume.feature

Feature: Uploading a PDF Resume

  Scenario: Uploading a valid PDF resume with a course ID
    Given I am on the development test page
    When I fill in the Course ID field with "101"
    And I upload a valid PDF resume
    And I submit the form
    # Then I should see the extracted text from the resume
    # And I should see a classification result based on the resume content
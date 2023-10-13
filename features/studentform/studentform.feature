Feature: Student Form
  As a prospective student
  I want to register with a tamu.edu email
  So that I can submit the form

  Scenario: Valid tamu.edu email registration
    When I visit the registration page
    And I fill in "Email" with "john.doe@tamu.edu"
    And I fill in "First Name" with "John"
    And I fill in "Last Name" with "Doe"


  Scenario: Existing email registration
    Given a student with email "existing.prof@tamu.edu" exists
    When I visit the registration page
    And I fill in "Email" with "existing.prof@tamu.edu"
    And I fill in "First Name" with "Jane"
    And I fill in "Last Name" with "Smith"
    

  Scenario: Invalid email registration
    When I visit the registration page
    And I fill in "Email" with "invalid.email@example.com"
    And I fill in "First Name" with "Invalid"
    And I fill in "Last Name" with "User"


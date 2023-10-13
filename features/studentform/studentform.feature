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

  Scenario: Successful Registration
    Given I am on the student registration page
    When I fill in "Email" with "john.doe@tamu.edu"
    And I fill in "first_name" with "John"
    And I fill in "last_name" with "Doe"
    And I fill in "UIN" with "123456789"
    And I press "Submit"
    Then I should see "Registration Successful!"

  Scenario: Registration Failure
    Given I am on the student registration page
    When I fill in "Email" with "john.doe@gmail.com"
    And I fill in "first_name" with "John"
    And I fill in "last_name" with "Doe"
    And I fill in "UIN" with "123456789"
    And I press "Submit"
    Then I should see "Not a valid tamu.edu email address."


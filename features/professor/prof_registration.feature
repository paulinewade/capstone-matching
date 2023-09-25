Feature: Professor Registration
  As a prospective professor
  I want to register with a tamu.edu email
  So that I can request admin approval

  Scenario: Valid tamu.edu email registration
    When I visit the registration page
    And I fill in "Email" with "john.doe@tamu.edu"
    And I fill in "First Name" with "John"
    And I fill in "Last Name" with "Doe"
    And I press "Register"
    Then I should see "Registration Successful! Please wait for admin approval."

  Scenario: Existing email registration
    Given a professor with email "existing.prof@tamu.edu" exists
    When I visit the registration page
    And I fill in "Email" with "existing.prof@tamu.edu"
    And I fill in "First Name" with "Jane"
    And I fill in "Last Name" with "Smith"
    And I press "Register"
    Then I should see "You are already registered using this email. Please wait for the admin to approve your registration or login if you are already approved."

  Scenario: Invalid email registration
    When I visit the registration page
    And I fill in "Email" with "invalid.email@example.com"
    And I fill in "First Name" with "Invalid"
    And I fill in "Last Name" with "User"
    And I press "Register"
    Then I should see "Not a valid tamu.edu email address."


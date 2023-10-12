Feature: Student Authentication

  Scenario: Successful Google OAuth2 Login
    Given I am on the student registration page
    Then I should see the Google OAuth2 login button
    When I click the Google OAuth2 login button
    Then I should be redirected to the Google Sign In Page
    Then I should be signed in as a student and redirected to Student Form page

  Scenario: Unauthorized Google OAuth2 Login
    Given I am on the student registration page
    Then I should see the Google OAuth2 login button
    When I click the Google OAuth2 login button
    Then I try to sign in with non-TAMU email credentials
    And I should see an error page with message access blocked and I should be redirected to the student registration page

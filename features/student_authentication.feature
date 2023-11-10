Feature: Student Authentication

  Scenario: Successful Google OAuth2 Login
    Given I am on the landing page
    Then I should see the Login with Google button
    When I click the Login with Google button
    Then I should be redirected to the Google Sign In Page
    Then I should be signed in as a student and redirected to Student Form page

  Scenario: Unauthorized Google OAuth2 Login
    Given I am on the landing page
    Then I should see the Login with Google button
    When I click the Login with Google button
    Then I try to sign in with non-TAMU email credentials
    And I should see an error page with message access blocked and I should be redirected to the student sign in page

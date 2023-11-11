Feature: Capstone Matching System
  Scenario: User visits the homepage
    When the user goes to the homepage
    Then they should see "Welcome to the Capstone Matching System"
    And they should see "Find the perfect capstone project or team for your academic journey."
    And they should see a "Login" button
    And they should see a "Professor Registration" button

  Scenario: User visits the homepage and clicks on the "Professor Registration" button
    When the user goes to the homepage
    Then they should see a "Professor Registration" button
    When the user clicks the "Professor Registration" button
    Then they should be redirected to the professor registration page

  Scenario: User visits the footer
    When the user goes to the homepage
    And the user scrolls to the footer
    Then they should see the copyright information "© 2023 Capstone Matching System"

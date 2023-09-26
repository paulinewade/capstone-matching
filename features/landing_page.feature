Feature: Capstone Matching System
  Scenario: User visits the homepage
    When the user goes to the homepage
    Then they should see "Welcome to the Capstone Matching System"
    And they should see "Find the perfect capstone project or team for your academic journey."
    And they should see a "Student" button
    And they should see a "Professor" button

  Scenario: User visits the homepage and clicks on the "Student" button
    When the user goes to the homepage
    Then they should see a "Student" button
    When the user clicks the "Student" button
    Then they should be redirected to the student registration page

  Scenario: User visits the homepage and clicks on the "Professor" button
    When the user goes to the homepage
    Then they should see a "Professor" button
    When the user clicks the "Professor" button
    Then they should be redirected to the professor registration page

  Scenario: User visits the footer
    When the user goes to the homepage
    And the user scrolls to the footer
    Then they should see the copyright information "© 2023 Capstone Matching System"

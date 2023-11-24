
Feature: Project Preferences
  As a professor
  I want to submit project preferences
  So that I am alloted the preferred projects

  Scenario: Professor navigates to the project preferences page
    Given the professor is logged in
    When the professor is on the professor Landing page
    Then the professor should see the "Project Preferences" link
    When the professor clicks the "Project Preferences" link
    Then the professor should be on the "Project Preferences" page
    Then the professor should see "Project Preferences" title
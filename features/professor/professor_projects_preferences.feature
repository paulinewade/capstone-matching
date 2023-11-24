
Feature: Project Preferences
  As a professor
  I want to submit project preferences
  So that I am alloted the preferred projects

  Background: 

  Given a professor exists with this information:
  | email                | first_name | last_name | role   | verified | admin | 
  | professor@tamu.edu    | John       | Doe       | professor| true | false|
   Given there are the following projects:
      | name           | description              | sponsor    | semester   |
      | Project 1      | Description for Project 1| Sponsor 1  | Fall 2023 |
      | Project 2      | Description for Project 2| Sponsor 2  | Fall 2023   |

  Scenario: Professor navigates to the project preferences page
    Given I am logged in as a professor
    When I am on the professor landing page
    Then I should see the "Project Preferences" link
    When I click the "Project Preferences" link
    Then I should be on the "Project Preferences" page

  Scenario: Successful submission of preferences
    Given I am on the "Project Preferences" page
    And I fill in a valid ranking of the projects
    When I press "Submit"
    Then I should see "Project Preferences saved successfully!"

  Scenario: Invalid submission of preferences (ranking 2 of the same)
    Given I am on the "Project Preferences" page
    And I fill in the same ranks for different projects
    When I press "Submit"
    Then I should see "Duplicate ranks found for different projects. Please ensure each project has a unique rank."

  Scenario: Invalid submission of preferences (invalid rank sequence/skipping values)
    Given I am on the "Project Preferences" page
    And I do not provide a valid rank sequence for the projects
    When I press "Submit"
    Then I should see "Invalid rank sequence. Please ensure ranks are consecutive without skipping any numbers."



    
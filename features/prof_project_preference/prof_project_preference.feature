Feature: Manage Professor Preferences for Projects

  As an admin
  So that I can manage the view given professor preference 
  I want to be able to update the professor assigned to a professor and delete them.

  Background:
    Given the following professors exist:
      | email               | first_name | last_name| semester      |course_number | section | semester   | admin_approved | admin |
      | professor1@tamu.edu | Jim       | Doe      | Fall 2023    | 600          | 601     | Fall 2023  | Yes            | Yes   |
      | professor2@tamu.edu | Jane       | Smith    | Fall 2023      | 629          | 602     | Spring 2023| No             | No    |
      | professor3@tamu.edu | Alice      | Johnson  | Fall 2023            | 642          | 603     | Fall 2023  | No             | No    |

    Given the following projects exist:
      | name       | sponsor        | description                 | info_url                       | semester |
      | Project 1  | Sponsor 1      | Description of Project 1    | https://project1.com       | Fall 2023 |


  Scenario: View Professor Project Preferences
    When I visit the professor preferences page
    Then I should see the project names
    And I should see a filter option

  Scenario: Filter Professor Preferences by Project
    When I visit the professor preferences page
    And I filter by a specific project
    Then I should see preferences for that project

  Scenario: Delete Selected Professors from Project
    When I visit the professor preferences page
    And there are selected professors for deletion
    Then I should see the updated preferences
    
  Scenario: Check Warnings on Professor Preference Page
    When  I visit the professor preferences page
    And I click on "Assign"
    Then I should see "Invalid professor or action."

  Scenario: Check Warnings on Professor Preference Page 2
    When  I visit the professor preferences page
    And I click on "Delete"
    Then I should see "No professors selected for deletion."

  Scenario: Assign Professor to Project
    When I visit the professor preferences page
    And I select a professor to assign to a project
    And I click on "Assign"
    Then I should see the professors name next to the project they are assigned to

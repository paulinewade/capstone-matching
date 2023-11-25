Feature: Manage Professor Preferences for Projects

  As an admin
  So that I can manage the view given professor preference 
  I want to be able to update the professor assigned to a professor and delete them.

  Background:
    Given the following projects exist:
      | name       | sponsor        | description                 | info_url                       | semester |
      | Project 1  | Sponsor 1      | Description of Project 1    | https://project1.com       | Fall 2022 |
      | Project 2  | Sponsor 2      | Description of Project 2    | https://project2.com       | Fall 2023 |
      | Project 3  | Sponsor 3      | Description of Project 3    | https://project3.com       | Fall 2024 |


  Scenario: View Professor Project Preferences
    When I visit the professor preferences page
    Then I should see the project names
    And I should see a filter option

  Scenario: Filter Professor Preferences by Project
    When I visit the professor preferences page
    And I filter by a specific project
    Then I should see preferences for that project

  Scenario: Delete Selected Professors from Project
    And there are selected professors for deletion
    When I visit the professor preferences page
    Then I should see the updated preferences
Feature: Project Index Page
  As a professor
  I want to filter and view the list of projects
  So that I can find and access project details

  Background:
    Given the following projects exist:
      | name       | sponsor        | description                 | info_url                       | semester |
      | Project 1  | Sponsor 1      | Description of Project 1    | https://project1.com       | Fall 2022 |

  Scenario: Editing a Project
    Given I am on the projects page
    When I click "Edit"
    And I fill in "Name" with "Updated Project Name"
    And I click "Update"
    And I should see "Updated Project Name"

  Scenario: Deleting a Project
    Given I am on the projects page
    When I click "Delete"
    Then I should see "Project was successfully deleted"
    And I should not see "Project 1"
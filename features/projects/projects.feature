# features/projects.feature

Feature: Project Index Page
  As a professor
  I want to filter and view the list of projects
  So that I can find and access project details

  Background:
    Given the following projects exist:
    | Name       | Sponsor        | Description                 | Link                       | Semester |
    | Project 1  | Sponsor 1      | Description of Project 1    | https://project1.com       | Fall 2022 |
    | Project 2  | Sponsor 2      | Description of Project 2    | https://project2.com       | Spring 2023 |
    | Project 3  | Sponsor 1      | Description of Project 3    | https://project3.com       | Summer 2022 |

  Scenario: Filtering projects by semester
    Given I am on the projects page
    When I select "All Semesters" from "Semester"
    Then I should see "Project 1"
    And I should see "Project 2"
    And I should see "Project 3"
    When I select "Fall 2022" from "Semester"
    And I click the "Filter" button
    Then I should see "Project 1"
    And I should not see "Project 3"
    And I should not see "Project 2"
    When I select "Summer 2022" from "Semester"
    And I click the "Filter" button
    Then I should see "Project 3"
    And I should not see "Project 1"
    And I should not see "Project 2"

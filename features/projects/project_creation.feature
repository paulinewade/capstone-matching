# features/project_creation.feature

Feature: Project Creation
  As a user
  I want to be able to create a new project
  So that I can add project details

  Scenario: Creating a new project
    Given I am on the new project page
    When I select "Fall 2023" from "Semester"
    And I fill in "Name" with "My Project"
    And I fill in "Sponsor" with "Sponsor Name"
    And I fill in "Description" with "This is a test project"
    And I fill in "Link" with "https://example.com"
    And I press "Create Project"
    Then I should see "Project was successfully created"
    And I should be on the home page

  Scenario: Creating a new project with an empty field
    Given I am on the new project page
    When I select "Fall 2023" from "Semester"
    And I fill in "Name" with ""
    And I fill in "Sponsor" with "Sponsor Name"
    And I fill in "Description" with "This is a test project"
    And I fill in "Link" with "https://example.com"
    And I press "Create Project"
    Then I should see "Name can't be blank"
Feature: Professor landing page
    As a professor
    I want to be able to create a new project
    So that I can add project details

Scenario: Add Projects
    Given I am on the professor landing page
    When I click "Add Projects"
    Then I should see "Project Registration"

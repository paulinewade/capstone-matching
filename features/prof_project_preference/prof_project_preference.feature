Feature: Manage Professor Preferences for Projects

  Scenario: View Professor Project Preferences
    When I visit the professor preferences page
    Then I should see the project names
    And I should see a filter option

  Scenario: Filter Professor Preferences by Project
    Given there are projects with preferences
    When I visit the professor preferences page
    And I filter by a specific project
    Then I should see preferences for that project

  Scenario: Assign Professor to Project
    Given there are projects with preferences
    And there are available professors
    When I visit the professor preferences page
    And I assign a professor to a project
    Then I should see the updated preferences

  Scenario: Delete Selected Professors from Project
    Given there are projects with preferences
    And there are selected professors for deletion
    When I visit the professor preferences page
    And I delete selected professors
    Then I should see the updated preferences


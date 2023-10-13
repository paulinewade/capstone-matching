Feature: Adding a New Section

Background:
    Given I am on the professor landing page

Scenario: Adding a new section
    When I click "Add Section"
    And I fill in "Section Name" with "New Section Name"
    And I click "Add Section"
    Then I should see "Section added successfully"
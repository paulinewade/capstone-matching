Feature: Lock/Unlock Student Form

  Scenario: Lock all student forms
    Given I am on the lock or unlock form page
    When I check the Lock or Unlock Student Forms for all students checkbox
    And I click the Save button
    Then all student forms should be "locked"

  Scenario: Unlock all student forms
    Given I am on the lock or unlock form page
    When I uncheck the Lock or Unlock Student Forms for all students checkbox
    And I click the "Save" button
    Then all student forms should be "unlocked"

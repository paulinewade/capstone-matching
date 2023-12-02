Feature: Change Weights Page
  As an admin user
  I want to check the "Change Weights Page"
  So that I can ensure that the feature weights are displayed correctly

  Background:
   Given the following score attributes exist:
    | feature | feature_weight | attribute_id |
    | Test1        | 0.5            | 1           |
    | Test2        | 0.25           | 2           |
    | Test3        | 0.25           | 3           |

  Scenario: Display Change Weights Page
    When I visit the change weights page
    Then I should see "Change Feature Weights"
    And I should see "Test1"
    And I should see "Test2"
    And I should see "Test3"
    And I should see percentage input fields
    And I should see a "Save Changes" button

  Scenario: Verify Pre-filled Feature Weights
    When I visit the change weights page
    Then I should see the following pre-filled feature weights
      | 50.0 |
      | 25.0  |
      | 25.0  |

  Scenario: Verify Feature Weight Change
    When I visit the change weights page
    And I fill in "35" for "Test1" at index 0
    And I fill in "25" for "Test2" at index 1
    And I fill in "40" for "Test3" at index 2
    And I press "Save Changes"
    Then I should see "Feature weights updated successfully."
    And I should see "35"
    And I should see "25"
    And I should see "40"

    Scenario: Verify Feature Weight Change Bad Path
    When I visit the change weights page
    And I fill in "1000" for "Resume Weight" at index 0
    And I fill in "500" for "Student Preference Weight" at index 1
    And I fill in "500" for "Submit Time Weight" at index 2
    And I press "Save Changes"
    Then I should see "Weights do not add up to 100%, try again."



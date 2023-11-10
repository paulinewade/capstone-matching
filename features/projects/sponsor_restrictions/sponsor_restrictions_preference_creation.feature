Feature: Sponsor Restrictions Creation
  As a user
  I want to be able to create new sponsor restrictions for a project
  So that I can specify restrictions for sponsors

  Background:
    Given the following projects exist:
      | name       | sponsor        | description                 | info_url                       | semester |
      | Project 1  | Sponsor 1      | Description of Project 1    | https://project1.com       | Fall 2022 |
    And the following sponsor restrictions exist:
      | project_name | restriction_type | restriction_val |
      | Project 1    | Gender            | Female          |

    And the following sponsor preferences exist:
      | project_name | preference_type | preference_val | bonus_amount |
      | Project 1    | Gender            | Female          | 30.0      |

  Scenario: Creating a new sponsor restriction
    When I am on the edit project page of "Project 1"
    And I click on "Add_Sponsor_Restriction"
    And I fill in "Restriction type" with "Gender"
    And I fill in "Restriction val" with "Female"
    And I press "Save Sponsor Restriction"
    Then I should see "Sponsor Restriction was successfully created"
    And I should be on the edit project page
    And I should see "Type: Gender" in the "sponsor_restrictions_div"
    And I should see "Value: Female" in the "sponsor_restrictions_div"

  Scenario: Creating a new sponsor preference
    When I am on the edit project page of "Project 1"
    And I click on "Add_Sponsor_Preference"
    And I fill in "Preference type" with "Gender"
    And I fill in "Preference val" with "Female"
    And I fill in "Bonus amount" with "30.0"
    And I press "Save Sponsor Preference"
    Then I should see "Sponsor Preferences was successfully created"
    And I should be on the edit project page
    And I should see "Type: Gender" in the "sponsor_preferences_div"
    And I should see "Value: Female" in the "sponsor_preferences_div"
    And I should see "Bonus Amount: 30.0" in the "sponsor_preferences_div"

  Scenario: Editing an existing sponsor restriction
    When I am on the edit project page of "Project 1"
    And I click on "Edit" next to the sponsor restriction "Gender: Female"
    And I fill in "Restriction val" with "Male"
    And I press "Update"
    Then I should see "Sponsor Restriction was successfully updated"
    And I should be on the edit project page
    And I should see "Type: Gender" in the "sponsor_restrictions_div"
    And I should see "Value: Male" in the "sponsor_restrictions_div"

  Scenario: Editing an existing sponsor preference
    When I am on the edit project page of "Project 1"
    And I click on "Edit" next to the sponsor preference "Gender: Female"
    And I fill in "Preference val" with "Male"
    And I press "Update"
    Then I should see "Sponsor preference updated successfully."
    And I should be on the edit project page
    And I should see "Type: Gender" in the "sponsor_preferences_div"
    And I should see "Value: Male" in the "sponsor_preferences_div"

  Scenario: Deleting an existing sponsor restriction
    When I am on the edit project page of "Project 1"
    And I click on "Delete" next to the sponsor restriction "Gender: Female"
    Then I should see "Sponsor Restriction was successfully deleted"
    And I should be on the edit project page
    And I should not see "Type: Gender" in the "sponsor_restrictions_div"
    And I should not see "Value: Male" in the "sponsor_restrictions_div"

  Scenario: Deleting an existing sponsor preference
    When I am on the edit project page of "Project 1"
    And I click on "Delete" next to the sponsor preference "Gender: Female"
    Then I should see "Sponsor preference deleted."
    And I should be on the edit project page
    And I should not see "Type: Gender" in the "sponsor_preferences_div"
    And I should not see "Value: Male" in the "sponsor_preferences_div"

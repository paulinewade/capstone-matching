# features/manage_professors.feature

Feature: Manage Professors and Admins Page
  As an admin user
  I want to manage professors and admins
  So that I can update their information and roles

  Background:
    Given the following professors exist:
        | email               | first_name | last_name| semester      |course_number | section | semester   | admin_approved | admin |
        | professor1@tamu.edu | John       | Doe      | Spring 2023    | 600          | 601     | Fall 2023  | Yes            | Yes   |
        | professor2@tamu.edu | Jane       | Smith    | Fall 2022      | 629          | 602     | Spring 2023| No             | No    |
        | professor3@tamu.edu | Alice      | Johnson  | N/A            | 642          | 603     | Fall 2023  | No             | No    |

  Scenario: View the Manage Professors and Admins page
    When I visit the Manage Professors page
    Then I should see "Manage Professors and Admins"

  Scenario: Update professor's information and roles
    When I visit the Manage Professors page
    And I update "professor1@tamu.edu" admin status to "No"
    And I press "Save Changes"
    Then I should see "Changes Saved."
    And I should see "professor1@tamu.edu" with admin status "No"

  Scenario: Delete a professor
    When I visit the Manage Professors page
    And I check the "Delete?" checkbox for "professor2@tamu.edu"
    And I click the "Save Changes" button
    Then I should see "Changes Saved."
    And I should not see "professor2@tamu.edu"

  Scenario: Add a professor
    When I visit the Manage Professors page
    And I press "Add Professor"
    And I fill in "Email" with "john.doe@tamu.edu"
    And I fill in "First Name" with "John"
    And I fill in "Last Name" with "Doe"
    And I check the "Admin" checkbox
    And I press "Submit"
    Then I should see "Professor added."
    And I should see "john.doe@tamu.edu" with admin status "Yes"

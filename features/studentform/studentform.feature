Feature: Student Form
  As a prospective student
  I want to register with a tamu.edu email
  So that I can submit the form

  Background:
    Given the following courses exist:
        | course_number | section | semester   | professor_id |
        | 670           | 600     | Fall 2023  |              |
        | 670           | 601     | Fall 2023  |              |
        | 606           | 602     | Spring 2024|              |

    
    Given the following ethnicities exist:
        | ethnicity_name |
        | White           |
        | Black           |
        | Asian           |
        | Hispanic        |

    Given there are the following projects:
      | name           | description              | sponsor    | semester   |
      | Project 1      | Description for Project 1| Sponsor 1  | Fall 2023 |
      | Project 2      | Description for Project 2| Sponsor 2  | Fall 2023   |
    
    Given a student exists with this information:
    | email                | first_name | last_name | role   | course_id | gender | nationality | contract_sign | work_auth | ethnicity | uin |
    | student@tamu.edu    | John       | Doe       | student| 1         | Male   | American     | NDA Only       | US Citizen| White     | 123456789 |

  Scenario: Successful Registration
    Given I am on the student registration page
    And I fill in valid information
    And I check the terms box
    And I press "Submit"
    Then I should see "Registration Successful!"

  Scenario: Registration Failure
    Given I am on the student registration page
    And I fill in an invalid UIN
    And I check the terms box
    And I press "Submit"
    Then I should see "Invalid UIN, make sure your UIN is 9 digits."

  Scenario: Student form is not open
    Given I am on the student registration page
    And the form is not open
    And I fill in valid information
    And I check the terms box
    And I press "Submit"
    Then I should see "Form is not currently open, please submit during the specified window."

  Scenario: Wrong Ranks for project
    Given I am on the student registration page
    When I fill in the wrong number of projects
    And I check the terms box
    And I press "Submit"
    Then I should see "Must rank between 50 and 100 (inclusive) projects."

  Scenario: Duplicate ranks for projects
    Given I am on the student registration page
    And I rank duplicate projects
    And I check the terms box
    And I press "Submit"
    Then I should see "Duplicate ranks found for different projects. Please ensure each project has a unique rank."

  Scenario: Skip ranks on project
    Given I am on the student registration page
    And I skip a project ranking
    And I check the terms box
    And I press "Submit"
    Then I should see "Invalid rank sequence. Please ensure ranks are consecutive without skipping any numbers."



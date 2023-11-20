Feature: Manage Students Page
    As an admin user
    I want to view and remove students
    So that I can manage the students that are in the course


    Background:
      Given the following courses exist:
        | course_number | section | semester   | professor_id |
        | 670           | 600     | Fall 2023  |              |
        | 670           | 601     | Fall 2023  |              |
        | 606           | 602     | Spring 2024|              |
     

     Given a student exists with this information:
    | email                | first_name | last_name | role   | course_id | gender | nationality | contract_sign | work_auth | ethnicity | uin |
    | student@tamu.edu    | John       | Doe       | student| 1         | Male   | American     | NDA Only       | US Citizen| White     | 123456789 |
    | student2@tamu.edu    | John2       | Doe2       | student| 2         | Male   | American     | NDA Only       | US Citizen| White     | 987654321 |

     Scenario: View All
        Given I am on the manage students page
        And I don't select a course
        And I press "Filter"
        Then I should see all students
    
    Scenario: View Students from course
        Given I am on the manage students page
        And I select a valid course
        And I press "Filter"
        Then I should see only students from that course
    
    Scenario: Delete Students with selected students
        Given I am on the manage students page
        And I check the delete box on the row of one of the students
        And I press "Delete Students"
        Then I should not see the student I deleted

    Scenario: Delete Students without selected students
        Given I am on the manage students page
        And I do not check the checkbox
        And I press "Delete Students"
        Then I should see "No Students Selected."

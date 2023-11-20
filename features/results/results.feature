Feature: Results Page
  As an admin or professor
  I want to view how well students match with projects
  So that I can make an educated decision on what project to assign them to
  
  Background: 
    Given the following courses exist:
    | course_number | section | semester   | professor_id |
    | 670           | 600     | Fall 2023  |              |
    | 670           | 601     | Fall 2023  |              |
    | 606           | 602     | Spring 2024|              |

    Given the following projects exist:
      | name       | sponsor        | description                 | info_url                       | semester |
      | Project 1  | Sponsor 1      | Description of Project 1    | https://project1.com       | Fall 2023 |
      | Project 2  | Sponsor 2      | Description of Project 2    | https://project2.com       | Fall 2023 |

    Given a student exists with this information:
    | email                | first_name | last_name | role   | course_id | gender | nationality | contract_sign | work_auth | ethnicity | uin |
    | student@tamu.edu    | John       | Doe       | student| 1         | Male   | American     | NDA Only       | US Citizen| White     | 123456789 |
    | student2@tamu.edu    | John2       | Doe2       | student| 2         | Male   | American     | NDA Only       | US Citizen| White     | 987654321 |

    Given the following scores entities exist:
    |student_id | project_id | pref |
    |1 | 1 | 1 |
    |1 | 2 | 2 |
    | 2 | 1 | 2|
    | 2 | 2 | 1 |

    Given the following score attributes exist:
    | feature | feature_weight | attribute_id |
    | Test1        | 0.5            | 1           |
    | Test2        | 0.25           | 2           |
    | Test3        | 0.25           | 3           |

    Given the following scores values exist:
    |scores_id | attribute_id | feature_score |
    |1 | 1 | 50 |
    |1 | 2 | 75 |
    |1 | 3 | 100 |
    |2 | 1 | 50 |
    |2 | 2 | 75 |
    |2 | 3 | 100 |

    Scenario: View all students that match with project
        Given I am on the results page
        And I select a project and semester
        And I press "Filter"
        Then I should see the students that match with the project
        And I should see a breakdown of their scores

    Scenario: View all students that match with project in course
        Given I am on the results page
        And I select a project and semester
        And I select a course
        And I press "Filter"
        Then I should see the students that match with the project in that course
        And I should see a breakdown of their scores
    
    Scenario: Export results
        Given I am on the results page
        And I select a project and semester
        And I press "Filter"
        When I press the "Download" button
        Then I should I get a file with all of the data from the table
        
        



    
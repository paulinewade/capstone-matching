Feature: Manage Courses Functionality
	As an admin
	So that I can manage the existing courses
	I want to be able to update the professor assigned to a course and add and delete courses
	
	Scenario: Filtering Courses by Semester
		Given I am on the Manage Courses page
		When I select "Spring 2024" from the "Semester" dropdown
		And I click the "Filter" button
		Then I should see only courses from the "Spring 2024" semester in the table

	Scenario: Editing Course Assignments
		Given I am on the Manage Courses page
		When I select a different professor for a course
		And I click the "Save Changes" button
		And I should see a success messages

	Scenario: Adding a New Course
		Given I am on the Manage Courses page
		And I fill in the required information for a new course
		And I click the "Add Course" button
		Then a new course should be added
		And I should see a success message for addition
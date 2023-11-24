Given('I am on the Manage Courses page') do
	visit '/manageCourses'
end

When('I select {string} from the {string} dropdown') do |option, dropdown_label|
  dropdown = find('label', text: dropdown_label).find(:xpath, '..').find('select')
  select option, from: dropdown['id'] || dropdown_label
end

Then('I should see only courses from the {string} semester in the table') do |string|
	expect(page).to have_content(string)
end

When("I select a different professor for a course") do
  # Assuming there's a dropdown with the ID 'course_assignments' for selecting professors
  # and each course has a unique ID for identification
  all('select[name^="course_assignments"]').each do |dropdown|
    # Select a different professor for each course
    dropdown.select('New Professor')
  end
  # If there's a button to trigger the changes, you might want to click it
  click_button 'Save Changes'
end

Then('I should see a success messages') do
  expect(page).to have_content('Changes Saved.')
end


When('I select one or more courses to delete') do
  checkbox = page.find("input[type='checkbox'][name='delete_course[]'][value='1']")
  checkbox.check
end




Then('the selected courses should be deleted') do
	pending # Write code here that turns the phrase above into concrete actions
end

When('I click on the {string} button') do |string|
  click_button(string)
end

When('I fill in the required information for a new course') do
  # Assuming you have specific IDs for your form fields
  fill_in 'course_number', with: '12345'  # Replace '12345' with the actual course number
  select 'Spring 2023', from: 'semester_add'  # Replace 'Spring 2023' with the actual semester
  fill_in 'section', with: '42524'  # Replace 'A' with the actual section
end


Then('a new course should be added') do
  # Assuming you have the necessary data to identify the newly added course
  new_course_number = '12345'  # Replace '12345' with the actual course number

  # Retrieve the newly added course from the database
  new_course = Course.find_by(course_number: new_course_number)

  # Verify that the new course is present in the database
  expect(new_course).to be_present
end

Then('I should see a success message for addition') do
  expect(page).to have_text("Course added successfully.")
end

When('I leave some required information blank') do

  fill_in 'course_number', with: ''  # Replace '12345' with the actual course number
  select 'Spring 2023', from: 'semester_add'  # Replace 'Spring 2023' with the actual semester
  fill_in 'section', with: '42524'  # Replace 'A' with the actual section
end
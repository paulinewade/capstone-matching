When('I visit the professor preferences page') do
  visit viewProfProjectPreferences_path
end

Then('I should see the project names') do
  project1 = Project.first
  expect(page).to have_content(project1.name)
end

Then('I should see a filter option') do
  expect(page).to have_select('Project')
end

When('I filter by a specific project') do
  select 'Project 1', from: 'project'
  click_button 'Filter' 
end


Then('I should see preferences for that project') do
  expect(page).to have_content('Professor Name')
  expect(page).to have_content('Preference Rank')
  expect(page).to have_content('Delete')
end


Given('there are available professors') do
  # Assuming you have a Professor model associated with a User model
  @professor1 = create_professor(first_name: 'Professor', last_name: 'A', role: 'professor', email: 'e@gmail.com')
  @professor2 = create_professor(first_name: 'Professor', last_name: 'B', role: 'professor', email: 'e1@gmail.com')
  # Add more professors as needed
end

def create_professor(attributes)
  user_attributes = attributes.slice(:first_name, :last_name, :role, :email)
  user = User.create!(user_attributes)

  professor_attributes = attributes.except(:first_name, :last_name, :role, :email).merge(user: user)
  Professor.create!(professor_attributes)
end

When('I assign a professor to a project') do
  # Replace these with the actual values or selectors based on your UI
  select 'Project 1', from: 'Project'  # Select the project
  select 'Professor A', from: 'professor_id'  # Select the professor
  fill_in 'Rank', with: '1'  # Enter the rank

  click_button 'Assign Professor'  # Assuming there's a button to submit the form

end


Given('there are selected professors for deletion') do
  # Assuming Professor model has_many ProfessorPreferences
  professor = User.create(first_name: 'John', last_name: 'Doe', role: 'professor', email: 't@gmail.com')
  project = Project.create(name: 'Test Project')
  ProfessorPreference.create(professor_id: professor.user_id, project_id: project.project_id, pref: 1)

  # Mark the professor for deletion
  @professors_for_deletion = [professor]
end


When('I delete selected professors') do
  @professors_for_deletion.each do |professor|
    check professor.id
  end

  click_button 'Delete Selected Professors'  # Assuming there's a button to submit the form
end

Then('I should see the updated preferences') do
  # Add assertions to check that the deleted professors are not present in the HTML
  @professors_for_deletion.each do |professor|
    expect(page).not_to have_content("#{professor.first_name} #{professor.last_name}")
    # Add more assertions based on your HTML structure
  end
end
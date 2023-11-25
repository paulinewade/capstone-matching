When('I visit the professor preferences page') do
  visit viewProfProjectPreferences_path
end

Then('I should see the project names') do
  @project1 = Project.first
  expect(page).to have_content(@project1.name)
end

Then('I should see a filter option') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I filter by a specific project') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see preferences for that project') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('there are available professors') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I assign a professor to a project') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see the updated preferences') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('there are selected professors for deletion') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I delete selected professors') do
  pending # Write code here that turns the phrase above into concrete actions
end

# features/step_definitions/projects_steps.rb

Given("the following projects exist:") do |table|
  table.hashes.each do |row|
    Project.create!(row)
  end
end

# features/step_definitions/sponsor_restrictions_steps.rb

Given("the following sponsor restrictions exist:") do |table|
  table.hashes.each do |restriction_data|
    project_name = restriction_data['project_name']
    project = Project.find_by(name: project_name)

    SponsorRestriction.create!(
      project: project,
      restriction_type: restriction_data['restriction_type'],
      restriction_val: restriction_data['restriction_val']
    )
  end
end

Given("the following sponsor preferences exist:") do |table|
  table.hashes.each do |preference_data|
    project_name = preference_data['project_name']
    project = Project.find_by(name: project_name)

    SponsorPreference.create!(
      project: project,
      preference_type: preference_data['preference_type'],
      preference_val: preference_data['preference_val'],
      bonus_amount: preference_data['bonus_amount']
    )
  end
end


Given("I am on the projects page") do
  visit projects_path
end

Then("I should not see {string}") do |content|
  expect(page).not_to have_content(content)
end

When("I select {string} from {string}") do |option, field|
  select(option, from: field, match: :first)
end

When("I click the {string} button") do |button_text|
  click_button(button_text)
end

When("I confirm the deletion") do
  page.driver.browser.switch_to.alert.accept
end
# features/step_definitions/projects_steps.rb

Given("the following projects exist:") do |table|
  table.hashes.each do |row|
    Project.create!(row)
  end
end

Given("I am on the projects page") do
  visit projects_path
end

Then("I should not see {string}") do |content|
  expect(page).not_to have_content(content)
end

When("I select {string} from {string}") do |option, field|
  select(option, from: field)
end

When("I click the {string} button") do |button_text|
  click_button(button_text)
end

When("I confirm the deletion") do
  page.driver.browser.switch_to.alert.accept
end
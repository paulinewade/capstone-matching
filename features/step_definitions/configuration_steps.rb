Given("the admin is logged in") do
  visit adminlanding_path
end

When("the admin is on the Admin Landing page") do
  expect(page).to have_current_path(adminlanding_path)
end

Then("the admin should see the {string} link") do |button_name|
  expect(page).to have_link(button_name)
end

When("the admin clicks the {string} link") do |button_name|
  expect(page).to have_link(button_name)
  click_link(button_name)
end

Then("the admin should be on the {string} page") do |page_name|
  visit configuration_path
  expect(page).to have_current_path(configuration_path)
end

Then("the admin should see {string} title") do |title|
  expect(page).to have_content(title)
end

Given(/^I am on the configuration page$/) do
  visit configuration_path
end

When(/^I update the configuration$/) do
  @config = Config.first_or_initialize
  fill_in 'form_open', with: '2022-01-01 00:00:00'
  fill_in 'form_close', with: '2022-12-31 23:59:59'
  fill_in 'min_number', with: '1'
  fill_in 'max_number', with: '10'
  click_button 'Save'
end

Then(/^I should see a success message$/) do
  expect(page).to have_content 'Changes made successfully'
end

When("I visit the StudentForm page") do
  visit '/studentform'
end

Given(/^a student with email "(.*?)" exists$/) do |email|
  User.create(email: email, first_name: "Test", last_name: "User")
end

Given("I am on the student registration page") do
  visit '/studentform'
end

Then /^I should see "Registration Successful!" on the student registration page$/ do
  expect(page).to have_content("Registration Successful!")
end
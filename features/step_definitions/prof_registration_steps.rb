When("I visit the registration page") do
  visit '/profregistration'
end

Given(/^a professor with email "(.*?)" exists$/) do |email|
  Professor.create(email: email, first_name: "Test", last_name: "User")
end



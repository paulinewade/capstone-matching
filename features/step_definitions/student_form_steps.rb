When("I visit the StudentForm page") do
  visit '/StudentForm'
end

Given(/^a student with email "(.*?)" exists$/) do |email|
  Professor.create(email: email, first_name: "Test", last_name: "User")
end



When("I visit the registration page") do
  visit '/profregistration'
end

Given(/^a professor with email "(.*?)" exists$/) do |email|
  user = User.create(email: email, first_name: "Test", last_name: "User", role: "professor")
  Professor.create(professor_id: user.user_id)
end



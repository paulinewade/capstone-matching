# features/step_definitions/project_landing_steps.rb

Given("I am on the professor landing page") do
    visit profLanding_path
end
  
When("I click {string}") do |button|
    save_and_open_page
    click_on button
end
  
# Then("I should see {string}") do |content|
#     expect(page).to have_content(content)
# end

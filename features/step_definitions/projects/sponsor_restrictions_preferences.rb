When("I am on the edit project page of {string}") do |project_name|
  @project =  Project.find_by(name: project_name)
  visit edit_project_path(@project)
end

When("I click on {string}") do |link_text|
  click_on link_text, match: :first
end

Then("I should be on the edit project page") do
  expect(page).to have_current_path(edit_project_path(@project))
end

Then("I should see {string} in the {string}") do |restriction_text, div|
  within("#" + div) do
    expect(page).to have_content(restriction_text)
  end
end

Then("I should not see {string} in the {string}") do |restriction_text, div|
  within("#" + div) do
    expect(page).to have_no_content(restriction_text)
  end
end

When("I click on {string} next to the sponsor restriction {string}") do |action, restriction_text|
  within("#sponsor_restrictions_div") do
      click_link_or_button action
  end
end

When("I click on {string} next to the sponsor preference {string}") do |action, restriction_text|
  within("#sponsor_preferences_div") do
    click_link_or_button action
  end
end
Given("the professor is logged in") do
    visit profLanding_path
end

When("the professor is on the professor Landing page") do
    expect(page).to have_current_path(profLanding_path)
end

Then("the professor should see the {string} link") do |button_name|
    expect(page).to have_link(button_name)
end

When("the professor clicks the {string} link") do |button_name|
    expect(page).to have_link(button_name)
    click_link(button_name)
end

Then("the professor should be on the {string} page") do |page_name|
    visit prof_projects_ranking_path
    expect(page).to have_current_path(prof_projects_ranking_path)
end

Then("the professor should see {string} title") do |title|
    expect(page).to have_content(title)
end

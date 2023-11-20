Then("the admin should see the {string} button") do |button_text|
    expect(page).to have_button(button_text)
end

When("the admin clicks the {string} button") do |button_name|
    click_button(button_name)
end

Then("the admin should see {string}") do |title|
    expect(page).to have_content(title)
end

When("the admin should be redirected to the Admin Landing page") do
    visit adminlanding_path
    expect(page).to have_current_path(adminlanding_path)
end

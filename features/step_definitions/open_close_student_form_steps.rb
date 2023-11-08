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
  visit open_close_student_form_path
  expect(page).to have_current_path(open_close_student_form_path)
end

Then("the admin should see {string} title") do |title|
  expect(page).to have_content(title)
end

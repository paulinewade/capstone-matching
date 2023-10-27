Given("I am on the lock or unlock form page") do
  visit lock_unlock_form_path
end

When("I check the Lock or Unlock Student Forms for all students checkbox") do
  check("Lock/Unlock Student Forms for all students")
  checkbox_status = find_field("Lock/Unlock Student Forms for all students").checked?
  expect(checkbox_status).to eq(true)
end

When('I uncheck the Lock or Unlock Student Forms for all students checkbox') do
  uncheck("Lock/Unlock Student Forms for all students")
  checkbox_status = find_field("Lock/Unlock Student Forms for all students").checked?
  expect(checkbox_status).to eq(false)
end

When("I click the Save button") do
  find_button("Save").click
end

Then("all student forms should be {string}") do |status|
  if status == "locked"
    check("Lock/Unlock Student Forms for all students")
    checkbox_status = find_field("Lock/Unlock Student Forms for all students").checked?
    expect(checkbox_status).to eq(true)
  elsif status == "unlocked"
    uncheck("Lock/Unlock Student Forms for all students")
    checkbox_status = find_field("Lock/Unlock Student Forms for all students").checked?
    expect(checkbox_status).to eq(false)
  end
end

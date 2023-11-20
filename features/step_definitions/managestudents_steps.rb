Given("I am on the manage students page") do
    visit "/managestudents"
  end

  Given("I don't select a course") do
    #not needed
  end
  
  Then("I should see all students") do
    expect(page).to have_content(123456789)
    expect(page).to have_content(987654321)
  end
  
  Given("I select a valid course") do
    select "CSCE 670-600-Fall 2023", from: "course_id"
  end
  
  Then("I should see only students from that course") do
    expect(page).to have_content(123456789)
    expect(page).not_to have_content(987654321)
  end

  Given('I check the delete box on the row of one of the students') do
    checkbox_selector = "tr:contains('123456789') input[type='checkbox']"
    checkbox = find(checkbox_selector)

    # Check the checkbox
    checkbox.check
  end
  
  Then('I should not see the student I deleted') do
    expect(page).not_to have_content(123456789)
  end

  Given('I do not check the checkbox') do
    #not needed
  end
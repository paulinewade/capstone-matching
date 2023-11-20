Given('the following scores entities exist:') do |table|
    table.hashes.each do |entity_params|
        ScoresEntity.create(entity_params)
    end
  end
  
  Given('the following scores values exist:') do |table|
    table.hashes.each do |value_params|
        ScoresValue.create(value_params)
    end
  end

  Given('I am on the results page') do
    visit '/view_results'
  end
  
  Given('I select a project and semester') do
    @selected_project = 'Project 1'
    @selected_semester = 'Fall 2023'
    @selected_course = ''
    select 'Fall 2023', from: 'semester'
    select 'Project 1', from: 'project'
  end
  
  Then('I should see the students that match with the project') do
    puts page.text
    expect(page).to have_content('John Doe')
    expect(page).to have_content('John2 Doe2')
  end
  
  Given('I select a course') do
    select 'CSCE 670-600-Fall 2023', from: 'course'
  end
  
  Then('I should see the students that match with the project in that course') do
    expect(page).to have_content('John Doe')
    expect(page).not_to have_content('John2 Doe2')
  end

  Then('I should see a breakdown of their scores') do
    expect(page).to have_content('Test1:')
    expect(page).to have_content('Test2:')
    expect(page).to have_content('Test3:')
  end

  When('I press the {string} button') do |string|
    visit results_export_path(semester: @selected_semester, project: @selected_project, course: @selected_course)
  end
  
  Then('I should I get a file with all of the data from the table') do
    expect(page.response_headers['Content-Disposition']).to include("attachment; filename=\"Fall 2023_Project 1-#{DateTime.now.strftime("%d%m%Y%H%M")}.csv\"")
  end
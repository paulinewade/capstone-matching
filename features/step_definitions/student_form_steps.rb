Given("the following courses exist:") do |table|
  # Convert the table to an array of hashes
  courses_data = table.hashes
  # Create courses in the database
  courses_data.each do |course_data|
    course = Course.create(course_data)
  end
end

Given("the following ethnicities exist:") do |table|
  # Iterate through the table and create Ethnicity records
  table.hashes.each do |ethnicity_params|
    Ethnicity.create(ethnicity_params)
  end
end


Given("a student exists with this information:") do |table|
  table.hashes.each do |student_info|
    course = Course.find(student_info['course_id']) # Assuming you have a Course model
    @user = User.create(email: student_info['email'], first_name: student_info['first_name'], last_name: student_info['last_name'], role: student_info['role'])
    student = Student.create(
      student_id: @user.user_id,
      course: course,
      gender: student_info['gender'],
      nationality: student_info['nationality'],
      contract_sign: student_info['contract_sign'],
      work_auth: student_info['work_auth'],
      uin: student_info['uin']
    )
    ethnicity = EthnicityValue.create(student_id: student.student_id, ethnicity_name: student_info['ethnicity'])
  end
end


Given("I am on the student registration page") do
  visit '/studentform'
end

Given("there are the following projects:") do |table|
  table.hashes.each do |project_params|
    Project.create(project_params)
  end
end

Given('I fill in valid information') do
  fill_in 'TAMU Email Address', with: 'johndoe@tamu.edu'
  fill_in 'Last Name', with: 'Doe'
  fill_in 'First Name', with: 'John'
  fill_in 'UIN', with: '123454321'
  select 'American', from: 'nationality'
  select 'US Citizen', from: 'work_auth'
  select 'Ok with Any Agreements', from: 'contract_sign'
  select 'White', from: 'ethnicity[]'
  select 'CSCE 670-600-Fall 2023', from: 'course_id'
  find('input[type=radio][name=gender][value="Male"]').click
  find('.rank-input[data-project-id="1"]').set('1') 
end

Given('I check the terms box') do
  check 'By checking this box, you are agreeing to having your information stored and used by CSCE capstone professors to help match you with a capstone project.'
end

Given('I fill in an invalid UIN') do
  fill_in 'UIN', with: '1234'
end

Given('the form is not open') do
  config = Config.first
  config.update(
    form_open: Date.yesterday,
    form_close: Date.yesterday
  )
end

Given('I fill in the wrong number of projects') do
  config = Config.first
  config.update(
    min_number: 50,
    max_number: 100
  )
  fill_in 'TAMU Email Address', with: 'johndoe@tamu.edu'
  fill_in 'Last Name', with: 'Doe'
  fill_in 'First Name', with: 'John'
  fill_in 'UIN', with: '123454321'
  select 'American', from: 'nationality'
  select 'US Citizen', from: 'work_auth'
  select 'Ok with Any Agreements', from: 'contract_sign'
  select 'White', from: 'ethnicity[]'
  select 'CSCE 670-600-Fall 2023', from: 'course_id'
  find('input[type=radio][name=gender][value="Male"]').click
  find('.rank-input[data-project-id="1"]').set('1') 
end

Given('I rank duplicate projects') do
  fill_in 'TAMU Email Address', with: 'johndoe@tamu.edu'
  fill_in 'Last Name', with: 'Doe'
  fill_in 'First Name', with: 'John'
  fill_in 'UIN', with: '123454321'
  select 'American', from: 'nationality'
  select 'US Citizen', from: 'work_auth'
  select 'Ok with Any Agreements', from: 'contract_sign'
  select 'White', from: 'ethnicity[]'
  select 'CSCE 670-600-Fall 2023', from: 'course_id'
  find('input[type=radio][name=gender][value="Male"]').click
  find('.rank-input[data-project-id="1"]').set('1')
  find('.rank-input[data-project-id="2"]').set('1')  
end

Given('I skip a project ranking') do
  fill_in 'TAMU Email Address', with: 'johndoe@tamu.edu'
  fill_in 'Last Name', with: 'Doe'
  fill_in 'First Name', with: 'John'
  fill_in 'UIN', with: '123454321'
  select 'American', from: 'nationality'
  select 'US Citizen', from: 'work_auth'
  select 'Ok with Any Agreements', from: 'contract_sign'
  select 'White', from: 'ethnicity[]'
  select 'CSCE 670-600-Fall 2023', from: 'course_id'
  find('input[type=radio][name=gender][value="Male"]').click
  find('.rank-input[data-project-id="1"]').set('1')
  find('.rank-input[data-project-id="2"]').set('3')  
end


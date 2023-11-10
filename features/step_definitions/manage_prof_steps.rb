Given('the following professors exist:') do |professors_table|
    professors_table.hashes.each do |professor_params|
      email = professor_params['email']
      first_name = professor_params['first_name']
      last_name = professor_params['last_name']
      semester = professor_params['semester']
      course_number = professor_params['course_number']
      section = professor_params['section']
      admin_approved = professor_params['admin_approved']
      admin = professor_params['admin']

      if admin_approved == "Yes"
        verified = true
      else
        verified = false
      end

      if admin == "Yes"
        user = User.create(first_name: first_name, last_name: last_name, role: 'admin', email: email )
        professor = Professor.create(professor_id: user.user_id, verified: verified, admin: true)
        course = Course.create(course_number: course_number, section: section, semester: semester, professor_id: professor.professor_id)
      else
        user = User.create(first_name: first_name, last_name: last_name, role: 'professor', email: email )
        professor = Professor.create(professor_id: user.user_id, verified: verified, admin: false)
        course = Course.create(course_number: course_number, section: section, semester: semester, professor_id: professor.professor_id)
      end
    end
  end
  
  def parse_array_value(value)
    if value == 'N/A'
      nil
    else
      value.split(', ').map { |v| v.gsub(/\[|\]/, '') }
    end
  end
  
  
  When('I visit the Manage Professors page') do
    visit '/manageprof'
  end

  When('I update {string} admin status to {string}') do |email, admin_status|
    select(admin_status, from: "admin[#{email}]")
  end
  
  Then('I should see {string} with admin status {string}') do |email, admin_status|
    row = page.find('table tr', text: email)
    expect(row).to have_content(admin_status)
  end
  
  When('I check the {string} checkbox for {string}') do |checkbox_name, email|
    checkbox = page.find("input[type='checkbox'][name='delete_professor_emails[]'][value='#{email}']")
    checkbox.check
  end

  When('I check the {string} checkbox') do |string|
    find('#admin').check
  end
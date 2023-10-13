Given('the following professors exist:') do |professors_table|
    professors_table.hashes.each do |professor_params|
      professor_params['semester'] = parse_array_value(professor_params['semester'])
      professor_params['section'] = parse_array_value(professor_params['section'])
  
      professor = Professor.find_by(email: professor_params['email'])
      if professor
        professor.update(professor_params)
      else
        Professor.create!(professor_params)
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
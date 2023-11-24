Given("I am logged in as a professor") do
    visit profLanding_path
end

Then("I should see the {string} link") do |button_name|
    expect(page).to have_link(button_name)
end

When("I click the {string} link") do |button_name|
    expect(page).to have_link(button_name)
    click_link(button_name)
end

Then("I should be on the {string} page") do |page_name|
    visit prof_projects_ranking_path
    expect(page).to have_current_path(prof_projects_ranking_path)
end

Given('I am on the {string} page') do |string|
    visit prof_projects_ranking_path
end
  
Given('I fill in a valid ranking of the projects') do
    find('.rank-input[data-project-id="1"]').set('1')
    find('.rank-input[data-project-id="2"]').set('2')  
end

Given('I fill in the same ranks for different projects') do
    find('.rank-input[data-project-id="1"]').set('1') 
    find('.rank-input[data-project-id="2"]').set('1') 
end
  
Given('I do not provide a valid rank sequence for the projects') do
    find('.rank-input[data-project-id="1"]').set('1') 
    find('.rank-input[data-project-id="2"]').set('3') 
end

Given('a professor exists with this information:') do |table|
    table.hashes.each do |prof_info|
        @user = User.create(email: prof_info['email'], first_name: prof_info['first_name'], last_name: prof_info['last_name'], role: prof_info['role'])
        student = Professor.create(
        professor_id: @user.user_id,
        verified: prof_info['verified'],
        admin: prof_info['admin']
        )
    end
end


Given("I am on the student registration page") do
  visit new_student_registration_path
end

Then("I should see the Google OAuth2 login button") do
  within('form') do
    google_oauth2_button = find('.oauth-login-button')
    expect(google_oauth2_button).to be_present
    expect(google_oauth2_button).to be_visible
  end
end


When("I click the Google OAuth2 login button") do
  within('form') do
    google_oauth2_button = find('.oauth-login-button')
    # google_oauth2_button.click
    visit '/students/auth/google_oauth2'
  end
end

Then("I should be redirected to the Google Sign In Page") do
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
    provider: 'google_oauth2',
    uid: '12345',
    info: { name: 'John Doe', email: 'john.doe@tamu.edu' }
  )
end

Then("I should be signed in as a student and redirected to Student Form page") do
  visit "/StudentForm"
  expect(page).to have_current_path('/StudentForm')
end

When("I try to sign in with non-TAMU email credentials") do
  OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
end

Then("I should see an error page with message access blocked and I should be redirected to the student registration page") do
  visit new_student_session_path
  expect(page).to have_current_path(new_student_session_path)
end

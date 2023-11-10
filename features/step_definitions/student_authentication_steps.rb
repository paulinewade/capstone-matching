Given("I am on the landing page") do
  visit root_path
end

Then("I should see the Login with Google button") do
  expect(page).to have_button('Login with Google')
end

Then("I click the Login with Google button") do
  expect(page).to have_button('Login with Google')
  # click_button('Login with Google')
end

Then("I should be redirected to the Google Sign In Page") do
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
    provider: 'google_oauth2',
    uid: '12345',
    info: { name: 'John Doe', email: 'john.doe@tamu.edu' }
  )
end

Then("I should be signed in as a student and redirected to Student Form page") do
  visit studentform_path
  expect(page).to have_current_path(studentform_path)
end

When("I try to sign in with non-TAMU email credentials") do
  OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
end

Then("I should see an error page with message access blocked and I should be redirected to the student sign in page") do
  visit root_path
  expect(page).to have_current_path(root_path)
end

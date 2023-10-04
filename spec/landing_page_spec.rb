require 'rails_helper'

RSpec.describe "Capstone Matching System Landing Page", type: :feature do
  before(:each) do
    visit root_path
  end

  it "displays the system name and description" do
    expect(page).to have_content("Welcome to the Capstone Matching System")
    expect(page).to have_content("Find the perfect capstone project or team for your academic journey.")
  end

  it "contains 'Student' and 'Professor' buttons" do
    expect(page).to have_button("Student")
    expect(page).to have_button("Professor")
  end

  it "redirects to the student registration page when 'Student' button is clicked" do
    click_button("Student")
    visit new_student_registration_path
    expect(page).to have_current_path(new_student_registration_path)
  end

  it "redirects to the professor registration page when 'Professor' button is clicked" do
    click_button("Professor")
    visit profregistration_path
    expect(page).to have_current_path(profregistration_path)
  end

  it "displays the copyright information in the footer" do
    expect(page).to have_content("© 2023 Capstone Matching System")
  end

end

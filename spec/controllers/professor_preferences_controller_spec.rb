# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfessorPreferencesController, type: :controller do
  describe 'when trying to submit the professor preferences form' do
    let!(:user) do
        User.create(user_id: '10', first_name: 'prof_fn', last_name: 'prof_ln', role: 'professor', email: 'profmail@tamu.edu')
    end
    
    let!(:professor) do
        Professor.create(professor_id: '10', verified: 'true', admin: 'false')
    end

    let!(:course1) do
        Course.create(course_id: 1, course_number: 606, section: 600, semester: 'Fall 2023')
    end

    let!(:course2) do
        Course.create(course_id: 2, course_number: 606, section: 601, semester: 'Fall 2023')
    end

    let!(:project1) do
        Project.create(project_id: '10',
        name: 'Example Project 10',
        description: 'Example Description 10',
        sponsor: 'Example Sponsor 10',
        course_id: 1,
        info_url: 'www.tamu.edu',
        semester: 'Fall 2023')
    end

    let!(:project2) do
        Project.create(project_id: '11',
        name: 'Example Project 11',
        description: 'Example Description 11',
        sponsor: 'Example Sponsor 11',
        course_id: 2,
        info_url: 'www.tamu.edu',
        semester: 'Fall 2023')
    end

    it 'updates project preferences for the professor' do
        #   post :save_rankings, params: { id: professor.id, preferences: { project1.project_id => 1, project2.project_id => 2 } }
        session[:user_id] = user.user_id
        post :save_rankings, params: { project_rank: { project1.project_id => 1, project2.project_id => 2 } }

        expect(ProfessorPreference.find_by(professor: professor, project: project1).pref).to eq(1)
        expect(ProfessorPreference.find_by(professor: professor, project: project2).pref).to eq(2)
    end

    it 'redirects to profLanding when form is submitted' do
        session[:user_id] = user.user_id
        post :save_rankings, params: { project_rank: { project1.project_id => 1, project2.project_id => 2 } }
        expect(response).to redirect_to profLanding_path
    end

    it 'shows a flash success when form is submitted' do
        session[:user_id] = user.user_id
        post :save_rankings, params: { project_rank: { project1.project_id => 1, project2.project_id => 2 } }
        expect(flash[:success]).to eq('Project Preferences saved successfully!')
    end
  end
end
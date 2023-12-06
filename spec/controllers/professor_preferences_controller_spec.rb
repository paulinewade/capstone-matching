# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ProfessorPreferencesController, type: :controller do
    describe '#index' do
        let(:user) { create(:user) } # You may need to adjust this based on your User model and factory
        before do
            # Assuming your controller requires authentication, you may need to sign in the user
            session[:user_id] = user.user_id
            create(:config)
        end

        it 'assigns the correct instance variables' do
            # You may need to adjust the following based on your actual model and factory names
            project = create(:project, semester: 'Fall 2023') 
            professor = create(:professor, professor_id: user.user_id)
            professor_preference = create(:professor_preference, project: project, professor_id: professor.professor_id)

            get :index

            expect(assigns(:projects)).to eq([project])
            expect(assigns(:preference_entities)).to eq([professor_preference])
            expect(assigns(:project_ranks)).to eq({ project.id => professor_preference.pref })
        end

        it 'renders the index template' do
            get :index
            expect(response).to render_template(:index)
        end
    end
    
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

        it 'redirects to the form again when form is submitted' do
            session[:user_id] = user.user_id
            post :save_rankings, params: { project_rank: { project1.project_id => 1, project2.project_id => 2 } }
            expect(response).to redirect_to prof_projects_ranking_path
        end

        it 'shows a flash success when form is submitted' do
            session[:user_id] = user.user_id
            post :save_rankings, params: { project_rank: { project1.project_id => 1, project2.project_id => 2 } }
            expect(flash[:success]).to eq('Project Preferences saved successfully!')
        end

        it 'shows error message when multiple projects are given same preference' do
            session[:user_id] = user.user_id
            post :save_rankings, params: { project_rank: { project1.project_id => 1, project2.project_id => 1 } }
            expect(flash[:error]).to eq('Duplicate ranks found for different projects. Please ensure each project has a unique rank.')
        end

        it 'shows error message when ranks are skipped' do
            session[:user_id] = user.user_id
            post :save_rankings, params: { project_rank: { project1.project_id => 1, project2.project_id => 3 } }
            expect(flash[:error]).to eq('Invalid rank sequence. Please ensure ranks are consecutive without skipping any numbers.')
        end

        it 'updates the project ranks when the form is resubmitted' do
            session[:user_id] = user.user_id
            post :save_rankings, params: { project_rank: { project1.project_id => 1, project2.project_id => 2 } }
            post :save_rankings, params: { project_rank: { project1.project_id => 2, project2.project_id => 1 } }
            expect(ProfessorPreference.find_by(professor: professor, project: project1).pref).to eq(2)
            expect(ProfessorPreference.find_by(professor: professor, project: project2).pref).to eq(1)
        end
    end
end
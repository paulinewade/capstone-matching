# spec/controllers/view_prof_project_preferences_controller_spec.rb

require 'rails_helper'

RSpec.describe ViewProfProjectPreferencesController, type: :controller do
  describe 'GET #index' do
    it 'assigns project names, selected project, projects, and professor preferences' do

      get :index
      expect(assigns(:project_names)).not_to be_nil
      expect(assigns(:selected_project)).to be_nil
      expect(assigns(:projects)).not_to be_nil
      expect(assigns(:professor_preferences)).not_to be_nil
      expect(response).to render_template(:index)
    end

    it 'assigns projects based on the selected project' do

      get :index, params: { project: 'YourSelectedProject' }
      expect(assigns(:selected_project)).to eq('YourSelectedProject')
      expect(assigns(:projects)).not_to be_nil
    end
  end

  describe 'POST #update_professor_preferences' do

    it 'assigns flash success when assigning a professor' do

      post :update_professor_preferences, params: { project_id: '1', professor_id: '2', commit_type: 'Assign', rank: '3' }
      expect(flash[:success]).to eq('Professor assigned successfully.')
      expect(response).to redirect_to(view_prof_project_preferences_path)
    end

    it 'assigns flash success when deleting professors' do

      post :update_professor_preferences, params: { project_id: '1', professor_ids: ['2', '3'], commit_type: 'Delete' }
      expect(flash[:success]).to eq('Selected professors deleted successfully.')
      expect(response).to redirect_to(view_prof_project_preferences_path)
    end
  end

  # describe 'POST #update_professor_preferences' do

  #   it 'assigns flash success when updating an existing professor preference' do
  #     project = Project.new(name: 'Test Project')
  #     professor = User.new(first_name: 'John', last_name: 'Doe')
  #     existing_preference = ProfessorPreference.create(project: project.project_id, professor: professor.user_id, pref: 1)

  #     post :update_professor_preferences, params: { project_id: project.project_id, professor_id: professor.user_id, commit_type: 'Assign', rank: '2' }
      
  #     expect(flash[:success]).to eq(nil)
  #     expect(response).to redirect_to(view_prof_project_preferences_path)
  #   end
  # end

end

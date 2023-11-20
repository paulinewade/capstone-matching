# spec/controllers/projects_controller_spec.rb

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new project' do
        project_params = { name: 'New Project', semester: '2024', sponsor: 'Sponsor', description: 'Description', link: 'Link'}
        
        count = Project.count
        post :create, params: { project: project_params }
        
        expect(Project.count).to eq(count + 1)
        expect(response).to redirect_to('/projects')
        expect(flash[:notice]).to eq('Project was successfully created')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new project' do
        project_params = { name: 'name', sponsor: 'Sponsor', description: 'Description', link: 'Link'}

        expect {
          post :create, params: { project: project_params }
        }.not_to change(Project, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #index' do
    it 'assigns all unique semesters to @semesters' do
      create(:project, semester: 'Spring')
      create(:project, semester: 'Fall')
      
      get :index

      expect(assigns(:semesters)).to eq(['Spring', 'Fall'])
    end

    it 'assigns projects filtered by selected semester to @projects' do
      spring_project = create(:project, semester: 'Spring')
      fall_project = create(:project, semester: 'Fall')

      get :index, params: { semester: 'Spring' }

      expect(assigns(:selected_semester)).to eq('Spring')
      expect(assigns(:projects)).to eq([spring_project])
    end

    it 'assigns all projects to @projects when no semester is selected' do
      spring_project = create(:project, semester: 'Spring')
      fall_project = create(:project, semester: 'Fall')

      get :index

      expect(assigns(:selected_semester)).to be_nil
      expect(assigns(:projects)).to eq([spring_project, fall_project])
    end
  end

  describe 'GET #new' do
    it 'assigns semesters, a new project, and restrictions' do
      get :new
      expect(assigns(:semesters).length).to eq(9)
      expect(assigns(:project)).to be_a_new(Project)
      expect(assigns(:restrictions)).to eq({
        'gender' => STUDENT_STATUS_CONSTANTS['gender'],
        'work_auth' => STUDENT_STATUS_CONSTANTS['work_auth'],
        'contract_sign' => STUDENT_STATUS_CONSTANTS['contract_sign'],
        'nationality' => STUDENT_STATUS_CONSTANTS['nationality']
      })
    end

    it 'builds sponsor preferences and restrictions for the new project' do
      get :new

      expect(assigns(:project).sponsor_preferences.length).to eq(2)
      expect(assigns(:project).sponsor_restrictions.length).to eq(2)
    end
  end

  describe 'PATCH #update' do
    let(:project) { create(:project) }

    context 'with valid params' do
      let(:valid_params) do
        { title: 'Updated Title', description: 'Updated Description' }
      end

      it 'updates the project and redirects to projects_path' do
        patch :update, params: { id: project.id, project: valid_params }

        expect(assigns(:project)).to eq(project)
        expect(flash[:notice]).to eq('Project was successfully updated')
        expect(response).to redirect_to(projects_path)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        { name: '', description: 'Updated Description' } # Invalid because title is blank
      end

      it 'renders the edit template with unprocessable_entity status' do
        patch :update, params: { id: project.id, project: invalid_params }

        expect(assigns(:project)).to eq(project)
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:project) { create(:project) }

    context 'when project exists' do
      it 'deletes the project' do
        expect do
          delete :destroy, params: { id: project.project_id }
        end.to change(Project, :count).by(-1)

        expect(flash[:notice]).to eq 'Project was successfully deleted'
        expect(response).to redirect_to(projects_path)
      end
    end
  end

end

# spec/controllers/projects_controller_spec.rb

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new project' do
        project_params = { Name: 'New Project', Semester: '2024', Sponsor: 'Sponsor', Description: 'Description', Link: 'Link' }

        count = Project.count
        print(count)
        expect {
          post "create", params: { project: project_params }
        }.to change(Project, :count).by(1)

        expect(response).to redirect_to('/projects')
        expect(flash[:notice]).to eq('Project was successfully created.')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new project' do
        project_params = { name: '', sponsor: 'Sponsor', description: 'Description', link: 'Link' }

        expect {
          post :create, params: { project: project_params }
        }.not_to change(Project, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end
end

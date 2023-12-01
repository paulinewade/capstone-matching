require 'rails_helper'

RSpec.describe ViewProfProjectPreferencesController, type: :controller do
  let(:project) { create(:project) }
  let(:course) { create(:course) }

  describe 'GET #index' do
    it 'assigns project names, selected project, professor preferences, and courses by semester' do
      get :index
      expect(assigns(:project_names)).not_to be_nil
      expect(assigns(:selected_project)).to be_nil
      expect(assigns(:professor_preferences)).not_to be_nil
      expect(assigns(:courses_by_semester)).not_to be_nil
    end
  end

  describe 'POST #update_professor_preferences' do
    context 'when assigning a professor to a project' do
      it 'assigns the professor to the project and redirects with success message' do
        post :update_professor_preferences, params: { project_id: project.id, course_id: course.id, commit_type: 'Assign' }
        project.reload
        expect(project.course_id).to eq(course.id)
        expect(flash[:success]).to be_present
        expect(response).to redirect_to(view_prof_project_preferences_path)
      end
    end

    context 'when deleting selected professors' do
      it 'deletes selected professors and redirects with success message' do
        professor_preference = create(:professor_preference, project_id: project.id)
        post :update_professor_preferences, params: { project_id: project.id, professor_ids: [professor_preference.professor_id], commit_type: 'Delete' }
        expect(ProfessorPreference.exists?(professor_preference.id)).to be_falsey
        expect(flash[:success]).to be_present
        expect(response).to redirect_to(view_prof_project_preferences_path)
      end
    end

    context 'when invalid project or action' do
      it 'sets an error flash message and redirects' do
        post :update_professor_preferences, params: { project_id: nil, commit_type: 'InvalidAction' }
        expect(flash[:error]).to be_present
        expect(response).to redirect_to(view_prof_project_preferences_path)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe SponsorPreferencesController, type: :controller do
  let(:project) { create(:project) }
  let(:sponsor_preference) { create(:sponsor_preference, project: project) }

  describe 'POST #create' do
    it 'creates a new sponsor preference' do
      post :create, params: { project_id: project.id, sponsor_preference: attributes_for(:sponsor_preference) }

      expect(response).to redirect_to(edit_project_path(project))
      expect(flash[:notice]).to eq 'Sponsor Preferences was successfully created'
    end

    it 'handles invalid parameters' do
      post :create, params: { project_id: project.id, sponsor_preference: { invalid_param: 'value' } }

      expect(response).to redirect_to(new_project_sponsor_preference_path(project))
      expect(flash[:error]).to_not be_nil
    end
  end

  describe 'GET #edit' do
    it 'renders the edit template' do
      get :edit, params: { project_id: project.id, id: sponsor_preference.id }

      expect(response).to render_template(:edit)
      expect(assigns(:sponsor_preference)).to eq(sponsor_preference)
      expect(assigns(:restrictions)).to_not be_nil
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new, params: { project_id: project.id }

      expect(response).to render_template(:new)
      expect(assigns(:sponsor_preference)).to be_a_new(SponsorPreference)
      expect(assigns(:restrictions)).to_not be_nil
    end
  end

  describe 'PATCH #update' do
    it 'updates the sponsor preference' do
      patch :update, params: { project_id: project.id, id: sponsor_preference.id, sponsor_preference: { updated_param: 'value' } }

      expect(response).to redirect_to(edit_project_path(project))
      expect(flash[:notice]).to eq 'Sponsor preference updated successfully.'
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the sponsor preference' do
      delete :destroy, params: { project_id: project.id, id: sponsor_preference.id }

      expect(response).to redirect_to(edit_project_path(project))
      expect(flash[:notice]).to eq 'Sponsor preference deleted.'
      expect(SponsorPreference.exists?(sponsor_preference.id)).to be_falsey
    end
  end
end

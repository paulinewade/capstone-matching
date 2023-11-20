require 'rails_helper'

RSpec.describe SponsorRestrictionsController, type: :controller do
  let(:project) { create(:project) }
  let(:sponsor_restriction) { create(:sponsor_restriction, project: project) }

  describe 'POST #create' do
    it 'creates a new sponsor restriction' do
      post :create, params: { project_id: project.id, sponsor_restriction: attributes_for(:sponsor_restriction) }

      expect(response).to redirect_to(edit_project_path(project))
      expect(flash[:notice]).to eq 'Sponsor Restriction was successfully created'
    end

    it 'handles invalid parameters' do
      post :create, params: { project_id: project.id, sponsor_restriction: { invalid_param: 'value' } }

      expect(response).to redirect_to(new_project_sponsor_restriction_path(project))
      expect(flash[:error]).to_not be_nil
    end
  end

  describe 'GET #edit' do
    it 'renders the edit template' do
      get :edit, params: { project_id: project.id, id: sponsor_restriction.id }

      expect(response).to render_template(:edit)
      expect(assigns(:sponsor_restriction)).to eq(sponsor_restriction)
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new, params: { project_id: project.id }

      expect(response).to render_template(:new)
      expect(assigns(:sponsor_restriction)).to be_a_new(SponsorRestriction)
    end
  end

  describe 'PATCH #update' do
    let(:other_project) {create(:project)}
    it 'updates the sponsor restriction' do
      patch :update, params: { project_id: project.id, id: sponsor_restriction.id, sponsor_restriction: { updated_param: 'value' } }

      expect(response).to redirect_to(edit_project_path(project))
      expect(flash[:notice]).to eq 'Sponsor Restriction was successfully updated'
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the sponsor restriction' do
      delete :destroy, params: { project_id: project.id, id: sponsor_restriction.id }

      expect(response).to redirect_to(edit_project_path(project))
      expect(flash[:notice]).to eq 'Sponsor Restriction was successfully deleted'
      expect(SponsorRestriction.exists?(sponsor_restriction.id)).to be_falsey
    end
  end
end

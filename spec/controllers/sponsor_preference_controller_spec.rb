# spec/controllers/sponsor_preferences_controller_spec.rb

require 'rails_helper'

RSpec.describe SponsorPreferencesController, type: :controller do
  let(:valid_params) { { project_id: 1, sponsor_preference: { preference_type: 'gender', preference_val: 'Male', bonus_amount: 10.0 } } }
  let(:invalid_params) { { project_id: 1, sponsor_preference: { preference_type: '', preference_val: '' } } }

  describe 'GET #new' do
    let!(:project1) do
      Project.create(project_id: '1',
                     name: 'Example Project 10',
                     description: 'Example Description 10',
                     sponsor: 'Example Sponsor 10',
                     info_url: 'www.tamu.edu',
                     semester: 'Fall 2023')
    end
    it 'assigns a new sponsor preference as @sponsor_preference' do
      get :new, params: { project_id: 1 }
      expect(assigns(:sponsor_preference)).to be_a_new(SponsorPreference)
    end
  end

  describe 'POST #create' do
    let!(:project1) do
      Project.create(project_id: '1',
                     name: 'Example Project 10',
                     description: 'Example Description 10',
                     sponsor: 'Example Sponsor 10',
                     info_url: 'www.tamu.edu',
                     semester: 'Fall 2023')
    end
    context 'with valid parameters' do
      it 'creates a new sponsor preference' do
        expect {
          post :create, params: valid_params
        }.to change(SponsorPreference, :count).by(1)
      end

      it 'redirects to the edit project path' do
        post :create, params: valid_params
        expect(response).to redirect_to(edit_project_path(assigns(:project)))
      end
    end

    context 'with invalid parameters' do
      it 'does not save the new sponsor preference' do
        expect {
          post :create, params: invalid_params
        }.to_not change(SponsorPreference, :count)
      end

      it 're-renders the new method' do
        post :create, params: invalid_params
        expect(response).to redirect_to(new_project_sponsor_preference_path(assigns(:project)))
      end
    end
  end
end

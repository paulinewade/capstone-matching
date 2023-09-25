require 'rails_helper'

RSpec.describe ProfregistrationController, type: :controller do
  describe 'POST #create' do
    context 'with a valid tamu.edu email address' do
      let(:valid_params) do
        {
          email: 'valid_email@tamu.edu',
          first_name: 'John',
          last_name: 'Doe'
        }
      end

      it 'creates a new professor' do
        expect {
          post :create, params: valid_params
        }.to change(Professor, :count).by(1)
      end

      it 'sets a success flash message' do
        post :create, params: valid_params
        expect(flash[:success]).to be_present
      end
    end

    context 'with an invalid email address' do
      let(:invalid_params) do
        {
          email: 'invalid_email@example.com',
          first_name: 'Jane',
          last_name: 'Smith'
        }
      end

      it 'does not create a new professor' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Professor, :count)
      end

      it 'sets an error flash message' do
        post :create, params: invalid_params
        expect(flash[:error]).to be_present
      end
    end

    context 'with an email address already registered' do
      let!(:existing_professor) do
        FactoryBot.create(:professor, email: 'existing_email@tamu.edu')
      end

      let(:existing_params) do
        {
          email: 'existing_email@tamu.edu',
          first_name: 'Mike',
          last_name: 'Johnson'
        }
      end

      it 'does not create a new professor' do
        expect {
          post :create, params: existing_params
        }.not_to change(Professor, :count)
      end

      it 'sets an error flash message' do
        post :create, params: existing_params
        expect(flash[:error]).to be_present
      end
    end
  end
end

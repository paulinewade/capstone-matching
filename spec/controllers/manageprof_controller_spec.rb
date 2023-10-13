require 'rails_helper'

RSpec.describe ManageprofController, type: :controller do

    describe 'GET #index' do
        it 'assigns @professors with all professors' do
            professor1 = FactoryBot.create(:professor, email: 'prof1@tamu.edu')
            professor2 = FactoryBot.create(:professor, email: 'prof2@tamu.edu')
            professor3 = FactoryBot.create(:professor, email: 'prof3@tamu.edu')

            get :index
            expect(response).to have_http_status(:success)
            expect(assigns(:professors)).to contain_exactly(professor1, professor2, professor3)
        end
    end     

    describe 'POST #add_professor' do
      context 'with a valid tamu.edu email address' do
        let(:valid_params) do
          {
            email: 'valid_email@tamu.edu',
            first_name: 'John',
            last_name: 'Doe',
            admin: 'on'
          }
        end
        let(:noadmin_params) do
            {
              email: 'valid_email@tamu.edu',
              first_name: 'John',
              last_name: 'Doe',
              admin: 'off'
            }
        end
  
        it 'creates a new professor' do
          expect {
            post :add_professor, params: valid_params
          }.to change(Professor, :count).by(1)
        end
  
        it 'sets a success flash message' do
          post :add_professor, params: valid_params
          expect(flash[:success]).to be_present
        end

        it 'accepts non-admins' do
            expect {
                post :add_professor, params: noadmin_params
            }.to change(Professor, :count).by(1)
        end
  
      context 'with an invalid email address' do
        let(:invalid_params) do
          {
            email: 'invalid_email@example.com',
            first_name: 'Jane',
            last_name: 'Smith',
            admin: 'on'
          }
        end
  
        it 'does not create a new professor' do
          expect {
            post :add_professor, params: invalid_params
          }.not_to change(Professor, :count)
        end
  
        it 'sets an error flash message' do
          post :add_professor, params: invalid_params
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
            last_name: 'Johnson',
            admin: 'on'
          }
        end
  
        it 'does not create a new professor' do
          expect {
            post :add_professor, params: existing_params
          }.not_to change(Professor, :count)
        end
  
        it 'sets an error flash message' do
          post :add_professor, params: existing_params
          expect(flash[:error]).to be_present
        end
      end
    end
    end
  
    describe 'POST save_change' do
        let(:admin_params) do
            {
                "admin_approved":{"example@tamu.edu":"Yes"},
                "admin":{"example@tamu.edu":"Yes"}
            }
        end
        let(:delete_params) do
            {
                "admin_approved":{"example@tamu.edu":"Yes"},
                "admin":{"example@tamu.edu":"Yes"},
                "delete_professor_emails":["example@tamu.edu"]
            }
        end
        
        let!(:example_professor) do
                    FactoryBot.create(:professor)
        end
        it 'updates values when admin_approved or admin params are present' do
          post :save_change, params: admin_params
          expect(response).to redirect_to(manageprof_path)
          expect(flash[:success]).to eq("Changes saved.")
        end
    
        it 'deletes professors when delete_professor_emails param is present' do
          post :save_change, params: delete_params
          expect(response).to redirect_to(manageprof_path)
          expect(flash[:success]).to eq("Changes saved.")
        end

        it 'updates admin_approved attribute for professors' do
            patch :save_change, params: admin_params
            example_professor.reload
            expect(example_professor.admin_approved).to be(true)
        end
        
        it 'updates admin attribute for professors' do
            patch :save_change, params: admin_params
            example_professor.reload
            expect(example_professor.admin).to be(true)
        end

      end
  end
  


require 'rails_helper'
require 'pdf/reader'

RSpec.describe DevTestController, type: :controller do
    describe 'POST #upload_resume' do
      context 'with valid parameters' do
        let(:valid_params) { { course_id: 101, resume: 'Seeking a front-end developer experienced in JavaScript and React' } }
  
        it 'redirects to devtest page' do
          post :upload_resume, params: valid_params
          expect(response).to redirect_to('/devtest')
        end
  
        it 'sets flash messages' do
          post :upload_resume, params: valid_params
          expect(flash[:resume_text]).to eq('Seeking a front-end developer experienced in JavaScript and React')
          # Add expectations for other flash messages if needed
        end
      end
    end
end

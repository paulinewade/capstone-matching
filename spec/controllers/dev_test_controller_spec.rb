require 'rails_helper'
require 'pdf/reader'

RSpec.describe DevTestController, type: :controller do
    describe 'POST #upload_resume' do
        context 'with a valid PDF resume' do
            it 'parses the uploaded PDF resume' do
                # Reference the valid PDF resume in your fixtures
                valid_pdf_path = Rails.root.join('spec', 'fixtures', 'files', 'valid_resume.pdf')

                post :upload_resume, params: { resume: fixture_file_upload(valid_pdf_path, 'application/pdf') }

                expect(flash[:resume_text]).not_to be_nil
            end
        end
    end

    context 'with an invalid file format' do
      let(:invalid_file) { fixture_file_upload('invalid_file.txt', 'text/plain') }

      it 'shows an error flash message' do
        post :upload_resume, params: { resume: invalid_file }
        expect(flash[:error]).to eq('Please upload a valid PDF resume.')
      end
    end
end

require 'rails_helper'

RSpec.describe Students::SessionsController, type: :controller do
  describe '#after_sign_out_path_for' do
    it 'redirects to the new student session path after sign out' do
      controller = Students::SessionsController.new
      request = ActionDispatch::TestRequest.create
      host = 'example.com'  # Set the host here
      request.host = host
      controller.request = request

      result = controller.after_sign_out_path_for(:user)
      expect(result).to eq(new_student_session_path)
    end
  end
end

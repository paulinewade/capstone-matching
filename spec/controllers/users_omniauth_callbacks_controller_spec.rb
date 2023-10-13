require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  include Devise::Test::ControllerHelpers

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user] # Use the actual Devise mapping for users
    # Your OmniAuth configuration and request setup
  end

  describe 'GET #google_oauth2' do
    context 'when a student is found or created' do
      before do
        OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
          provider: 'google_oauth2',
          uid: '12345',
          info: { name: 'John Doe', email: 'john.doe@tamu.edu' }
        )
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
      end

      it 'signs in the user and redirects to Student Form page' do
        get :google_oauth2
        expect(response).to redirect_to('/StudentForm')
        expect(flash[:success]).to eq(I18n.t('devise.omniauth_callbacks.success', kind: 'Google'))
      end
    end

    context 'when a user is not found or authorized' do
      let(:invalid_credentials) { :invalid_credentials }

      before do
        OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
      end

      it 'redirects to the user sign-in page with an error message' do
        get :google_oauth2
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to include('Invalid credentials received.')
      end
    end
  end

  describe 'after_omniauth_failure_path_for' do
    it 'redirects to the new user session path' do
      controller = Users::OmniauthCallbacksController.new

      # Create a new ActionDispatch::Request object and set the host within the env hash
      request = ActionDispatch::Request.new(Rack::MockRequest.env_for('http://example.com'))
      request.env['HTTP_HOST'] = 'example.com'
      controller.request = request

      path = controller.send(:after_omniauth_failure_path_for, nil)
      expect(path).to eq('/users/sign_in')  # Replace with the actual path
    end
  end
end

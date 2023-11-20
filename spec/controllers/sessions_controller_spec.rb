require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#google_auth' do
    context 'when user logs in with tamu.edu email' do
      before do
        OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(
          info: { first_name: 'John', last_name: 'Doe', email: 'johndoe@tamu.edu' }
        )
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
        get :google_auth
      end

      it 'redirects to studentform_path if user is a student' do
        expect(response).to redirect_to(studentform_path)
      end

      it 'redirects to profLanding_path if user is a professor' do
        user = User.create(email: 'professor@tamu.edu', first_name: 'John', last_name: 'Doe', role: 'professor')
        prof_user = Professor.create(professor_id: user.user_id, verified: true, admin: false)
        auth_hash = request.env['omniauth.auth']
        auth_hash['info']['email'] = user.email
        get :google_auth
        expect(response).to redirect_to(profLanding_path)
      end

      it 'redirects to adminlanding_path if user is an admin' do
        user = User.create(email: 'admin@tamu.edu', first_name: 'John', last_name: 'Doe', role: 'admin')
        auth_hash = request.env['omniauth.auth']
        auth_hash['info']['email'] = user.email
        get :google_auth
        expect(response).to redirect_to(adminlanding_path)
      end

      it 'logs in user if user exists' do
        user = User.create(email: 'student@tamu.edu', first_name: 'John', last_name: 'Doe', role: 'student')
        auth_hash = request.env['omniauth.auth']
        auth_hash['info']['email'] = user.email
        get :google_auth
        expect(session[:user_id]).to eq(user.user_id)
      end

      it 'logs out user' do
        get :destroy
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when user logs in with non-tamu.edu email' do
      before do
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
        request.env['omniauth.auth']['info']['email'] = 'user@example.com'
        get :google_auth
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets flash error message' do
        expect(flash[:error]).to eq('Must login with tamu.edu email.')
      end
    end

    context 'when user creation fails' do
      before do
        allow_any_instance_of(User).to receive(:valid?).and_return(false)
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
        get :google_auth
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets flash error message' do
        expect(flash[:error]).to eq('Must login with tamu.edu email.')
      end
    end

    context 'when user is of unknown type' do
      it 'handles unknown role and redirects to root_path with an error message' do
        unknown_user = User.create(
          email: 'unknown_user@tamu.edu',
          first_name: 'Unknown',
          last_name: 'User',
          role: 'unknown_role'
        )
        OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(
          info: { first_name: 'Unknown', last_name: 'User', email: 'unknown_user@tamu.edu' }
        )
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google]

        auth_hash = request.env['omniauth.auth']
        auth_hash['info']['email'] = unknown_user.email
        get :google_auth
        expect(response).to redirect_to(root_path)
        expect(session[:user_id]).to be_nil
        expect(flash[:error]).to eq('Error logging in, please contact the admin.')
      end
    end
  end
end

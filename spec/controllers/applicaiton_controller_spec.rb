require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#authorize_admin_or_prof' do
    context 'when user is an admin' do
      it 'does not redirect' do
        user = create(:user, role: 'admin')
        session[:user_id] = user.id

        controller.authorize_admin_or_prof

        expect(response).to have_http_status(:ok)
        expect(response).to_not redirect_to(root_path)
      end
    end

    context 'when user is a professor' do
      it 'does not redirect' do
        user = create(:user, role: 'professor')
        session[:user_id] = user.id

        controller.authorize_admin_or_prof

        expect(response).to have_http_status(:ok)
        expect(response).to_not redirect_to(root_path)
      end
    end
  end

  describe '#authorize_admin' do
    context 'when user is an admin' do
      it 'does not redirect' do
        user = create(:user, role: 'admin')
        session[:user_id] = user.id

        controller.authorize_admin

        expect(response).to have_http_status(:ok)
        expect(response).to_not redirect_to(root_path)
      end
    end

  end
end



     



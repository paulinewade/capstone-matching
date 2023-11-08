require 'rails_helper'

RSpec.describe AdminlandingController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET #lock_unlock_student_form' do
    it 'returns a successful response' do
      get :lock_unlock_student_form
      expect(response).to have_http_status(:success)
    end

    it 'renders the lock_unlock_student_form template' do
      get :lock_unlock_student_form
      expect(response).to render_template('lock_unlock_student_form')
    end
  end

  describe 'POST #update_lock_unlock_student_form' do
    it 'returns a successful response' do
      post :update_lock_unlock_student_form, params: { form_close: Time.now, form_open: Time.now }
      expect(response).to have_http_status(:found)
    end

    it 'renders the update_lock_unlock_student_form template' do
      post :update_lock_unlock_student_form, params: { form_close: Time.now, form_open: Time.now }
      expect(response).to redirect_to(lock_unlock_student_form_path)
    end
  end
end

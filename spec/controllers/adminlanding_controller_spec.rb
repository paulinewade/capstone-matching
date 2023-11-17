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

  describe 'GET #configuration' do
    it 'returns a successful response' do
      get :configuration
      expect(response).to have_http_status(:success)
    end

    it 'renders the configuration template' do
      get :configuration
      expect(response).to render_template('configuration')
    end
  end

  describe 'POST #update_configuration' do
    it 'returns a successful response' do
      post :update_configuration, params: { form_close: Time.now, form_open: Time.now, min_number: 1, max_number: 10 }
      expect(response).to have_http_status(:found)
    end

    it 'renders the update_configuration template' do
      post :update_configuration, params: { form_close: Time.now, form_open: Time.now, min_number: 1, max_number: 10 }
      expect(response).to redirect_to(configuration_path)
    end
  end
end

require 'rails_helper'

RSpec.describe ChangeweightsController, type: :controller do
  describe 'GET #index' do
    it 'assigns all score attributes to @score_attributes' do
      get :index
      expect(assigns(:score_attributes)).to eq(ScoresAttribute.all)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'POST #save_weights' do
    context 'with valid feature_weights that sum to 100%' do
      it 'updates feature weights and redirects to changeweights_path with success message' do
        ScoresAttribute.create(
          attribute_id: 1,
          feature: 'Feature 1',
          feature_weight: 0.1
        )
        ScoresAttribute.create(
          attribute_id: 2,
          feature: 'Feature 2',
          feature_weight: 0.2
        )
        post :save_weights, params: { feature_weights: ['50', '50'] }
        expect(response).to redirect_to(changeweights_path)
        expect(flash[:success]).to eq("Feature weights updated successfully.")
      end
    end

    context 'with invalid feature_weights' do
      let(:invalid_feature_weights) { ['40', '30', '25'] }

      it 'does not update feature weights and redirects to changeweights_path with error message' do
        post :save_weights, params: { feature_weights: invalid_feature_weights }
        expect(response).to redirect_to(changeweights_path)
        expect(flash[:error]).to eq("Weights do not add up to 100%, try again.")
      end
    end

    context 'with no feature_weights provided' do
      it 'redirects to changeweights_path with error message' do
        post :save_weights, params: { feature_weights: [] }
        expect(response).to redirect_to(changeweights_path)
        expect(flash[:error]).to eq("No feature weights to save.")
      end
    end
  end
end


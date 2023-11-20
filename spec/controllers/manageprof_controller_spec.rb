require 'rails_helper'

RSpec.describe ManageprofController, type: :controller do
  describe 'GET #index' do
    it 'assigns all professors to @professors' do
      get :index
      expect(assigns(:professors)).to eq(User.includes(:professor => :courses).where.not(professors: { professor_id: nil }))
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'POST #save_change' do
    context 'when admin approval or admin parameter is present' do
      it 'calls update_values method' do
        allow(subject).to receive(:update_values)
        post :save_change, params: { verified: true }
        expect(subject).to have_received(:update_values)
      end
    end

    context 'when delete_professor_emails parameter is present' do
      it 'calls delete_professor method' do
        allow(subject).to receive(:delete_professor)
        post :save_change, params: { delete_professor_emails: ['professor@example.com'] }
        expect(subject).to have_received(:delete_professor)
      end
    end

    it 'redirects to index with success message' do
      post :save_change
      expect(response).to render_template('index')
      expect(flash[:success]).to eq('Changes Saved.')
    end
  end

  describe 'POST #delete_professor' do
    it 'deletes professors with given emails' do
      professor = User.create(email: 'delete_email@tamu.edu', first_name: 'John', last_name: 'Fake', role: 'professor')
      Professor.create(professor_id: professor.user_id)
      post :save_change, params: { delete_professor_emails: [professor.email] }
      expect(User.find_by(email: professor.email)).to be_nil
    end
  end

  describe 'POST #add_professor' do
    context 'with valid tamu.edu email' do
      it 'adds a professor and redirects to index with success message' do
        post :add_professor, params: { email: 'newprof@tamu.edu', first_name: 'New', last_name: 'Professor' }
        expect(response).to render_template('index')
        expect(flash[:success]).to eq('Professor added.')
      end
    end

    context 'with existing professor email' do
      it 'does not add professor and sets error message' do
        professor = User.create(email: "duplicate_email@tamu.edu", first_name: 'Duplicate', last_name: 'Professor', role: 'professor')
        post :add_professor, params: { email: professor.email, first_name: 'Duplicate', last_name: 'Professor' }
        expect(response).to render_template('index')
        expect(flash[:error]).to eq('Professor already registered.')
      end
    end

    context 'with invalid tamu.edu email' do
      it 'does not add professor and sets error message' do
        post :add_professor, params: { email: 'invalid@example.com', first_name: 'Invalid', last_name: 'Professor' }
        expect(response).to render_template('index')
        expect(flash[:error]).to eq('Not a valid tamu.edu email address.')
      end
    end
  end

  describe 'update_values' do

    context 'with verified parameters' do
      it 'updates professor verification status' do
        user = User.create(email: 'test2@example.com', first_name: 'John', last_name: 'Doe', role: 'admin')
        professor = Professor.create(professor_id: user.user_id, verified: false, admin: true)
        post :save_change, params: { verified: {user.email => 'Yes'} }
        professor.reload
        expect(professor.verified).to be true
      end
    end
  
    context 'with admin parameters' do
      it 'updates professor and user roles' do
        user1 = User.create(email: 'test3@example.com', first_name: 'John', last_name: 'Doe', role: 'professor')
        professor = Professor.create(professor_id: user1.user_id, verified: true, admin: false)
        post :save_change, params: { admin: {user1.email => 'Yes'} }
        user1.reload
        professor.reload
        expect(user1.role).to eq('admin')
        expect(professor.admin).to be true
      end
    end
  end
end

  


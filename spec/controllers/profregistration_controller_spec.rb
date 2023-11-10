# spec/controllers/profregistration_controller_spec.rb

require 'rails_helper'

RSpec.describe ProfregistrationController, type: :controller do
  describe 'GET #index' do
    it 'assigns courses without professors to @courses' do
      course_without_professor = Course.create(course_number: 1, section: 1, semester: "Fall 2023")
      user = User.create(email: 'test123@tamu.edu', first_name: 't', last_name: 't', role: 'professor')
      professor = Professor.create(professor_id: user.user_id)
      course = Course.create(professor_id: professor.professor_id, course_number: 2, section: 2, semester: "Fall 2023") # Course with a professor

      get :index
      expect(assigns(:courses)).to eq([course_without_professor])
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      course = Course.create(course_number: 1, section: 1, semester: "Fall 2023")
      {
        email: 'professor@tamu.edu',
        first_name: 'John',
        last_name: 'Doe',
        course_ids: [course.course_id]
      }
    end

    context 'with valid parameters' do
      it 'creates a new professor registration' do
        post :create, params: { **valid_params }

        expect(response).to render_template(:index)

        expect(User.find_by(email: valid_params[:email])).to be_present
        expect(User.find_by(email: valid_params[:email]).role).to eq('professor')

        new_professor = User.find_by(email: valid_params[:email]).professor
        expect(new_professor).to be_present
        expect(new_professor.verified).to be false
        expect(new_professor.admin).to be false

        expect(Course.find(valid_params[:course_ids].first).professor).to eq(new_professor)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new professor registration' do
        # Modify params to make it invalid, for example, by using an invalid email
        invalid_params = valid_params.merge(email: 'invalid_email')

        post :create, params: { **invalid_params }

        expect(response).to render_template(:index)
        expect(flash[:error]).to be_present
        expect(User.find_by(email: invalid_params[:email])).to be_nil
      end
    end
  end
end


# spec/controllers/manage_courses_controller_spec.rb
require 'rails_helper'

RSpec.describe ManageCoursesController, type: :controller do
  describe 'GET #index' do
    it 'assigns @course, @semesters, @professors_for_select, and @courses' do
      get :index
      expect(assigns(:course)).to_not be_nil
      expect(assigns(:semesters)).to_not be_nil
      expect(assigns(:professors_for_select)).to_not be_nil
      expect(assigns(:courses)).to_not be_nil
      expect(response).to render_template :index
    end

    it 'assigns @courses based on selected semester' do
      semester = 'Spring 2023'
      get :index, params: { semester: semester }
      expect(assigns(:courses)).to eq(Course.where(semester: semester))
    end
  end

  describe 'POST #edit_courses' do
    it 'updates professor assignments and deletes courses' do
      # Implement this test based on your specific scenario
    end

    it 'redirects to manageCourses_path' do
      post :edit_courses
      expect(response).to redirect_to(manageCourses_path)
    end

    it 'sets a success flash message' do
      post :edit_courses
      expect(flash[:success]).to eq('Changes Saved.')
    end
  end
end

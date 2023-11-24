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
end

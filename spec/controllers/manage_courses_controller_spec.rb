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

  describe '#edit_courses' do
    it 'updates professor assignments and redirects to manageCourses_path' do
      # Assuming you have a valid course and professor in your database
      course = create(:course)
      professor = create(:professor)
      
      post :edit_courses, params: { course_assignments: { course.id => professor.id } }
      
      expect(course.reload.professor_id).to eq(professor.id)
      expect(flash[:success]).to eq("Changes Saved.")
      expect(response).to redirect_to(manageCourses_path)
    end

    it 'deletes courses and redirects to manageCourses_path' do
      # Assuming you have a valid course in your database
      course = create(:course)

      post :edit_courses, params: { delete_course: [course.id] }

      expect(Course.exists?(course.id)).to be_falsey
      expect(flash[:success]).to eq("Changes Saved.")
      expect(response).to redirect_to(manageCourses_path)
    end
  end

  describe '#add_course' do
    it 'adds a course successfully and redirects to manageCourses_path' do
      professor = create(:professor)
      post :add_course, params: { course_number: 'CS101', section: 123, semester_add: 'Spring 2023', professor_id: professor.professor_id }

      expect(flash[:success]).to eq("Course added successfully.")
      expect(response).to redirect_to(manageCourses_path)
    end

    it 'renders index template if course creation fails' do
      post :add_course, params: { course_number: '', section: 'A', semester_add: 'Spring', professor_id: 1 }

      expect(response).to render_template(:index)
    end
  end
end

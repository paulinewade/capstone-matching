# spec/controllers/managestudents_controller_spec.rb

require 'rails_helper'

RSpec.describe ManagestudentsController, type: :controller do
  describe '#index' do
    it 'assigns students and courses' do
      course1 = Course.create(course_number: 123, section: 456, semester: 'Fall 2023')
      student_user1 = User.create(email: 'studentemail@tamu.edu', first_name: 'ex', last_name: 'ex', role: 'student')
      student1 = Student.create( student_id: student_user1.user_id ,course_id: course1.course_id, gender: 'Male', nationality: 'American', work_auth: 'Citizen', contract_sign: 'all', uin: 12)
      ethnicity1 = Ethnicity.create(ethnicity_name: 'Example')
      ethnicity_values = EthnicityValue.create(student_id: student1.student_id, ethnicity_name: 'Example')
      get :index

      expect(assigns(:students)).to eq([student_user1])
      expect(assigns(:courses)).to eq([course1])
      expect(assigns(:ethnicity_names_by_student)).to eq({ student1.student_id => [ethnicity1.ethnicity_name] })
      expect(response).to render_template(:index)
    end
  end

  describe '#delete_students' do
    context 'when no students selected' do
      it 'sets flash error and renders index' do
        post :delete_students, params: { delete_students_emails: [] }

        expect(flash[:error]).to eq("No Students Selected.")
        expect(response).to render_template(:index)
      end
    end

    context 'when students are selected for deletion' do
      it 'deletes students and sets flash success' do
        # Mocking the database queries
        allow(User).to receive(:find_by).and_return(double('User', destroy: true))

        post :delete_students, params: { delete_students_emails: ['student@example.com'] }

        expect(flash[:success]).to eq("Students Deleted Sucessfully")
        expect(response).to render_template(:index)
      end
    end
  end

  describe '#filter_students' do
    before do
      @course1 = Course.create(course_number: 123, section: 456, semester: 'Fall 2023')
      @course2 = Course.create(course_number: 123, section: 456, semester: 'Fall 2024')
      @student_user1 = User.create(email: 'studentemail@tamu.edu', first_name: 'ex', last_name: 'ex', role: 'student')
      @student_user2 = User.create(email: 'studentemail2@tamu.edu', first_name: 'ex', last_name: 'ex', role: 'student')
      @student1 = Student.create( student_id: @student_user1.user_id ,course_id: @course1.course_id, gender: 'Male', nationality: 'American', work_auth: 'Citizen', contract_sign: 'all', uin: 12)
      @student2 = Student.create( student_id: @student_user2.user_id , course_id: @course2.course_id, gender: 'Male', nationality: 'American', work_auth: 'Citizen', contract_sign: 'all', uin: 123)
    end
    it 'filters students and sets flash success' do
      post :filter_students, params: { course_id: @course1.course_id }

      expect(assigns(:students).count).to eq(1)
      expect(assigns(:courses)).to eq([@course1, @course2])
      expect(flash[:success]).to eq("Filtered Successfully")
      expect(response).to render_template(:index)
    end

    it 'shows all students when no course is selected' do
      post :filter_students, params: {course_id: nil}

      expect(assigns(:students).count).to eq(2)
      expect(flash[:success]).to eq("Filtered Successfully")
      expect(response).to render_template(:index)
    end
  end
end

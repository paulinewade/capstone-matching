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

  describe 'GET #lock_unlock_form' do
    it 'returns a successful response' do
      get :lock_unlock_form
      expect(response).to have_http_status(:success)
    end

    it 'renders the lock_unlock_form template' do
      get :lock_unlock_form
      expect(response).to render_template('lock_unlock_form')
    end
  end

  describe 'POST #lock_unlock' do
    it 'updates the student lock state' do
      student = Student.create(student_id: 10, class_id: 100, uin: 12345, form_locked: false)
      post :lock_unlock, params: { uin: student.uin, student: { form_locked: true } }
      expect(student.reload.form_locked).to eq(true)
    end

    it 'redirects to the lock_unlock_form_path' do
      student = Student.create(student_id: 10, class_id: 100, uin: 12345, form_locked: false)
      post :lock_unlock, params: { uin: student.uin, student: { form_locked: true } }
      expect(response).to redirect_to(lock_unlock_form_path)
    end

    it 'sets flash[:notice] when successful' do
      student = Student.create(student_id: 10, class_id: 100, uin: 12345, form_locked: false)
      post :lock_unlock, params: { uin: student.uin, student: { form_locked: true } }
      expect(flash[:notice]).to eq('Student lock state updated successfully')
    end

    it 'sets flash[:alert] when unsuccessful' do
      allow_any_instance_of(Student).to receive(:update).and_return(false)
      student = Student.create(student_id: 10, class_id: 100, uin: 12345, form_locked: false)
      post :lock_unlock, params: { uin: student.uin, student: { form_locked: true } }
      expect(flash[:alert]).to eq('Error updating student lock state')
    end
  end

  describe 'POST #lock_unlock_all_students' do
    # it 'updates all students lock state' do
    #   student1 = Student.create(student_id: 15, class_id: 100, uin: 12345, form_locked: false)
    #   student2 = Student.create(student_id: 11, class_id: 100, uin: 12346, form_locked: false)

    #   post :lock_unlock_all_students, params: { student: { form_locked: true } }

    #   expect(student1.reload.form_locked).to eq(true)
    #   expect(student2.reload.form_locked).to eq(true)
    # end

    it 'redirects to the lock_unlock_form_path' do
      student1 = Student.create(student_id: 15, class_id: 100, uin: 12345, form_locked: false)
      student2 = Student.create(student_id: 11, class_id: 100, uin: 12346, form_locked: false)

      post :lock_unlock_all_students, params: { student: { form_locked: true } }

      expect(response).to redirect_to(lock_unlock_form_path)
    end

    it 'sets flash[:notice] when successful' do
      student1 = Student.create(student_id: 15, class_id: 100, uin: 12345, form_locked: false)
      student2 = Student.create(student_id: 11, class_id: 100, uin: 12346, form_locked: false)

      post :lock_unlock_all_students, params: { student: { form_locked: true } }

      expect(flash[:notice]).to eq('All students lock state updated successfully')
    end

    it 'sets flash[:alert] when unsuccessful' do
      allow(Student).to receive(:update_all).and_return(false)

      post :lock_unlock_all_students, params: { student: { form_locked: true } }

      expect(flash[:alert]).to eq('Error updating all students lock state')
    end
  end
end

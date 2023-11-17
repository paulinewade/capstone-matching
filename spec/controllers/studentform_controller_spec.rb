require 'rails_helper'

RSpec.describe StudentformController, type: :controller do
    describe '#index' do
      context 'when user is logged in' do
        it 'assigns variables and renders the index template' do
          config = create(:config)
          user = create(:user) # Assuming you have FactoryBot set up
          student = create(:student, user: user) # Assuming associations are set up in your factories
  
          session[:user_id] = user.user_id
  
          get :index
  
          expect(assigns(:first_name)).to eq(user.first_name)
          expect(assigns(:last_name)).to eq(user.last_name)
          expect(assigns(:email)).to eq(user.email)
          expect(assigns(:cid)).to eq(student.course_id)
          expect(assigns(:uin)).to eq(student.uin)
          expect(assigns(:gender)).to eq(student.gender)
          expect(assigns(:nation)).to eq(student.nationality)
          expect(assigns(:auth)).to eq(student.work_auth)
          expect(assigns(:sign)).to eq(student.contract_sign)
          expect(assigns(:ethn)).to eq(EthnicityValue.where(student_id: student.student_id))
          expect(assigns(:courses)).to eq(Course.where(semester: 'Fall 2023')) # Adjust the pattern based on your actual semester format
          expect(assigns(:projects)).to eq(Project.where(semester: 'Fall 2023' )) # Adjust the pattern based on your actual semester format
          # Add more expectations for other variables as needed
          expect(response).to render_template(:index)
        end
      end
  
      context 'when user is not logged in' do
        it 'redirects to root_path with an error message' do
          config = create(:config)
          get :index
  
          expect(flash[:error]).to eq('Please login with Google account to fill out the form.')
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe '#create' do
    let(:config) { create(:config) }
    let(:project) { create(:project) }
    let(:course) {create(:course)}
    context 'when form is open' do
      before do
        allow(Config).to receive(:first).and_return(config)
      end

      it 'creates a new student and associated records' do
        expect do
          User.create(email: 'test_test@tamu.edu', first_name: 'J', last_name: 'D', role: 'student')
          post :create, params: {
            email: 'test_test@tamu.edu',
            first_name: 'John',
            last_name: 'Doe',
            uin: '123456789',
            gender: 'Male',
            course_id: course.course_id,
            work_auth: 'Citizen',
            contract_sign: 'all',
            nationality: 'American',
            ethnicity: ['Asian'],
            project_rank: { project.project_id => '1' } # Adjust based on your project structure
          }
        end.to change(Student, :count).by(1)

        expect(response).to redirect_to(studentform_path)
        expect(flash[:success]).to eq('Registration Successful!')
      end

      it 'handles invalid UIN' do
        post :create, params: {
          email: 'test@example.com',
          first_name: 'John',
          last_name: 'Doe',
          uin: 'invalid',
          gender: 'Male',
          course_id: project.course_id,
          work_auth: 'Citizen',
          contract_sign: 'all',
          nationality: 'American',
          ethnicity: ['Asian'],
          project_rank: { project.project_id => '1' }
        }

        expect(response).to redirect_to(studentform_path)
        expect(flash[:error]).to eq('Invalid UIN, make sure your UIN is 9 digits.')
      end

      # Add more test cases for other validations and scenarios

      it 'handles duplicate project ranks' do
        projects = create_list(:project, 2)
        post :create, params: {
          email: 'test@example.com',
          first_name: 'John',
          last_name: 'Doe',
          uin: '123456789',
          gender: 'Male',
          course_id: course.course_id,
          work_auth: 'Citizen',
          contract_sign: 'all',
          nationality: 'American',
          ethnicity: ['Asian'],
          project_rank: { project.project_id => '1', projects[0].project_id => '1' }
        }

        expect(response).to redirect_to(studentform_path)
        expect(flash[:error]).to eq('Duplicate ranks found for different projects. Please ensure each project has a unique rank.')
      end

      it 'redirects to studentform_path with an error message' do
        post :create, params: {
          email: 'test@example.com',
          first_name: 'John',
          last_name: 'Doe',
          uin: '123456789',
          gender: '', # Set gender to blank
          course_id: '1',
          work_auth: 'Citizen',
          contract_sign: 'all',
          nationality: 'American',
          ethnicity: ['Asian'],
          project_rank: { 'project_id' => '1' }
        }

        expect(response).to redirect_to(studentform_path)
        expect(flash[:error]).to eq("Please fill in all fields in 'Student Information' before submitting.")
      end

      it 'handles invalid rank sequences' do
        projects = create_list(:project, 2)
        post :create, params: {
          email: 'test@example.com',
          first_name: 'John',
          last_name: 'Doe',
          uin: '123456789',
          gender: 'Male',
          course_id: course.course_id,
          work_auth: 'Citizen',
          contract_sign: 'all',
          nationality: 'American',
          ethnicity: ['Asian'],
          project_rank: { project.project_id => '1', projects[0].project_id => '3' }
        }

        expect(response).to redirect_to(studentform_path)
        expect(flash[:error]).to eq('Invalid rank sequence. Please ensure ranks are consecutive without skipping any numbers.')
      end

      it 'handles not enough or too many ranked projects' do
        post :create, params: {
          email: 'test@example.com',
          first_name: 'John',
          last_name: 'Doe',
          uin: '123456789',
          gender: 'Male',
          course_id: course.course_id,
          work_auth: 'Citizen',
          contract_sign: 'all',
          nationality: 'American',
          ethnicity: ['Asian'],
          project_rank: {1=>''}
        }

        expect(response).to redirect_to(studentform_path)
        min_number = config.min_number
        max_number = config.max_number
        expect(flash[:error]).to eq("Must rank between #{min_number} and #{max_number} (inclusive) projects.")
      end
    end

    context 'when form is closed' do
      before do
        allow(Config).to receive(:first).and_return(config)
        config.update(form_open: DateTime.now - 2.days, form_close: DateTime.now - 1.day)
      end

      it 'handles closed form' do
        post :create, params: {
          email: 'test@example.com',
          first_name: 'John',
          last_name: 'Doe',
          uin: '123456789',
          gender: 'Male',
          course_id: project.course_id,
          work_auth: 'Citizen',
          contract_sign: 'all',
          nationality: 'American',
          ethnicity: ['Asian'],
          project_rank: { project.project_id => '1' }
        }

        expect(response).to redirect_to(studentform_path)
        expect(flash[:error]).to eq('Form is not currently open, please submit during the specified window.')
      end
    end
  end
end
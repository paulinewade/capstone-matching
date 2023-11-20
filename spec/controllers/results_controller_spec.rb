require 'rails_helper'

RSpec.describe ResultsController, type: :controller do
    describe '#evaluate_scores' do
        it 'calculates total score and split scores' do
            scores_attribute = create(:scores_attribute, feature: 'Test Feature', feature_weight: 0.5)
            scores_value = create(:scores_value, attribute_id: scores_attribute.attribute_id, feature_score: 10)
            scores_values = [scores_value]

            total_score, split_scores = subject.evaluate_scores(scores_values)

            expect(total_score).to eq(5)
            expect(split_scores.first).to have_key('feature_name')
            expect(split_scores.first).to have_key('feature_score')
        end
    end

    describe '#check_restrictions' do
        it 'returns a list of restrictions that match the student' do
            project = create(:project)
            user = create(:user)
            student = create(:student, :male, user: user)
            sponsor_restriction = create(:sponsor_restriction, project: project, restriction_type: 'gender', restriction_val: 'Male')

            restriction_list = subject.check_restrictions(project, student)

            expect(restriction_list).to be_an(Array)
            expect(restriction_list.length).to eq(1)
        end
    end

    describe '#check_preference' do
        it 'returns total preference score and a list of preferences that match the student' do
            project = create(:project)
            user = create(:user)
            student = create(:student, :female, user: user)
            sponsor_preference = create(:sponsor_preference, project: project, preference_type: 'gender', preference_val: 'Female', bonus_amount: 10)

            preference_total, preference_list = subject.check_preference(project, student)

            expect(preference_total).to eq(10)
            expect(preference_list).to be_an(Array)
            expect(preference_list.length).to eq(1)
        end
    end

    describe '#index' do
        let!(:project1) { create(:project, name: 'Project1', semester: 'Spring') }
        let!(:project2) { create(:project, name: 'Project2', semester: 'Fall') }
        let!(:scores_entity1) { create(:scores_entity, project: project1) }
        let!(:scores_entity2) { create(:scores_entity, project: project2) }

        context 'when parameters are present' do
            it 'assigns semesters, projects, courses, and results' do
                course1 = scores_entity1.student.course
                course2 = scores_entity2.student.course
                get :index, params: { semester: 'Spring', project: 'Project1', course: course1.course_id}
                expect(assigns(:semesters)).to eq(['Spring', 'Fall'])
                expect(assigns(:projects)).to eq(['Project1', 'Project2'])
                expect(assigns(:courses)).to eq([course1, course2])
                expect(assigns(:selected_semester)).to eq('Spring')
                expect(assigns(:selected_project)).to eq('Project1')
                expect(assigns(:selected_course).to_s).to eq(course1.course_id.to_s)
                expect(assigns(:results)).to be_present
            end
        end

        context 'when project and semester do not match' do
            it 'sets flash error message' do
                get :index, params: { semester: 'Fall', project: 'Project1' }

                expect(flash[:error]).to eq("Project and Semester Doesn't Match")
            end
        end
    end

    describe '#export' do
        let(:user) { create(:user) }
        let(:student) { create(:student, user: user) }
        let(:project) { create(:project, name: 'Test Project', semester: 'Spring') }
        let(:scores_entity) { create(:scores_entity, project: project, student: student) }
        let(:scores_attribute) { create(:scores_attribute) }
        let(:scores_value) { create(:scores_value, scores_entity: scores_entity, scores_attribute: scores_attribute) }    
        context 'when valid parameters are present' do
            it 'returns a CSV file' do
                scores_value.scores_entity
                course_id = student.course.course_id
                get :export, params: { semester: 'Spring', project: project.name, course: course_id, format: :csv }

                expect(response.content_type).to eq 'text/csv'
                expect(response.headers['Content-Disposition']).to include('Spring_Test Project')

                csv_data = CSV.parse(response.body, headers: true)
                # Add more specific expectations based on the structure of your CSV
                expect(csv_data.headers).to eq(['Student_name', 'feature name', 'Total_Scores'])
            end
        end

        context 'when invalid parameters are present' do
            it 'sets a flash error message' do
                get :export, params: { semester: 'Fall', project: 'Test Project', course: '', format: :csv }

                expect(flash[:error]).to eq "Project and Semester Doesn't Match"
            end
        end
    end
end

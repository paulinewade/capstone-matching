# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb

ProjectNew.create(
  project_id: 1,
  project_name: 'Project 1',
  description: 'We are looking for a software engineer with expertise in Ruby and Ruby on Rails.',
  sponsor: 'Sponsor 1',
  class_id: 1
)

ProjectNew.create(
  project_id: 2,
  project_name: 'Project 2',
  description: 'Seeking a front-end developer experienced in JavaScript and React.',
  sponsor: 'Sponsor 2',
  class_id: 2
)

ProjectNew.create(
  project_id: 3,
  project_name: 'Project 3',
  description: 'We need a data scientist skilled in Python and machine learning.',
  sponsor: 'Sponsor 3',
  class_id: 1
)

ProjectNew.create(
  project_id: 4,
  project_name: 'Project 4',
  description: 'Seeking a back-end engineer equipped with knowledge in JavaScript and React.',
  sponsor: 'Sponsor 4',
  class_id: 2
)

# db/seeds/scores_attributes_seeds.rb

# Seed data for the "scores_attributes" table
form_open_datetime = DateTime.new(2023, 11, 6, 9, 0) # Example date and time
form_close_datetime = DateTime.new(2023, 11, 6, 17, 0) # Example date and time
config = Config.create(min_number: 5, max_number: 10, form_open: form_open_datetime , form_close:form_close_datetime )

student_user = User.create(first_name: "student", last_name: "example", role: "student", email: "studentemail@tamu.edu")
prof_user = User.create(first_name: "professor", last_name: "example", role: "professor", email: "profemail@tamu.edu")
admin_user  = User.create(first_name: "admin", last_name: "example", role: "admin", email: "adminemail@tamu.edu")

prof = Professor.create(professor_id: prof_user.user_id, verified: true, admin: false)
admin = Professor.create(professor_id: admin_user.user_id, verified: true, admin: true)

course = Course.create(course_number: 606, section: 600, semester: "Fall 2023", professor_id: prof.professor_id)
course2 = Course.create(course_number: 606, section: 601, semester: "Fall 2023", professor_id: admin.professor_id)
course3 = Course.create(course_number: 606, section: 602, semester: "Fall 2023")


ethnicities = [
  "White",
  "Black or African American",
  "Native American or Alaska Native",
  "Asian",
  "Native Hawaiian or Other Pacific Islander",
  "Other"
]

ethnicities.each do |ethnicity|
  Ethnicity.find_or_create_by(ethnicity_name: ethnicity)
end


student = Student.create(student_id: student_user.user_id, course_id: course.course_id, gender: "Male", nationality: "American", work_auth: "Citizen", contract_sign: "All", resume: "Nodejs, Javascript, Java, Python")
ethnicity_value1 = EthnicityValue.create(student_id: student.student_id, ethnicity_name: "White")
ethnicity_value2 = EthnicityValue.create(student_id: student.student_id, ethnicity_name: "Black or African American")

project = Project.create(name: "Example Project", description: "Example Description", sponsor: "Example Sponsor", course_id: course.course_id, info_url: "www.tamu.edu", semester: "Fall 2023")
project = Project.create(name: "Example Project2", description: "Example Description2", sponsor: "Example Sponsor2", semester: "Spring 2024")

attribute1 = ScoresAttribute.create(feature: "Resume/Skills Match Score", feature_weight: 0.5)
attribute2 = ScoresAttribute.create(feature: "Preference Match Score", feature_weight: 0.25)
attribute3 = ScoresAttribute.create(feature: "Time Submitted Score", feature_weight: 0.25)

scores_entity = ScoresEntity.create(student_id: student.student_id, project_id: project.project_id, pref: 1)

scores_value1 = ScoresValue.create(scores_id: scores_entity.scores_id, attribute_id: attribute1.attribute_id, feature_score: 50)
scores_value2 = ScoresValue.create(scores_id: scores_entity.scores_id, attribute_id: attribute2.attribute_id, feature_score: 100)
scores_value3 = ScoresValue.create(scores_id: scores_entity.scores_id, attribute_id: attribute3.attribute_id, feature_score: 75)

professor_pref = ProfessorPreference.create(project_id: project.project_id, professor_id: prof.professor_id, pref: 1)

restriction = SponsorRestriction.create(restriction_type: "gender", restriction_val: "Male", project_id: project.project_id)
preference = SponsorPreference.create(project_id: project.project_id, preference_type: "gender", preference_val: "Non-Binary", bonus_amount: 10)


# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb
# Seed data for the "scores_attributes" table
profwade = User.create(email: 'paulinewade@tamu.edu', first_name: 'Pauline', last_name: 'Wade', role: 'admin')
adminwade = Professor.create(professor_id: profwade.user_id, verified: true, admin: true)

form_open_datetime = DateTime.new(2023, 11, 6, 9, 0) # Example date and time
form_close_datetime = DateTime.new(2023, 12, 6, 17, 0) # Example date and time
fall_sem_month = 8
spring_sem_month = 1
summer_sem_month = 6
fall_sem_day = 15
spring_sem_day = 20
summer_sem_day = 1

config = Config.create(min_number: 2, max_number: 10, form_open: form_open_datetime , form_close:form_close_datetime, fall_semester_month: fall_sem_month , fall_semester_day: fall_sem_day, spring_semester_month: spring_sem_month , 
spring_semester_day: spring_sem_day, summer_semester_month: summer_sem_month, summer_semester_day: summer_sem_day)

ethnicities = [
  "White",
  "Black or African American",
  "Native American or Alaska Native",
  "Asian",
  "Hispanic or Latino",
  "Native Hawaiian or Other Pacific Islander",
  "Other"
]

ethnicities.each do |ethnicity|
  Ethnicity.find_or_create_by(ethnicity_name: ethnicity)
end

attribute1 = ScoresAttribute.create(feature: "Resume/Skills Match Score", feature_weight: 0.5)
attribute2 = ScoresAttribute.create(feature: "Student Preference Match Score", feature_weight: 0.25)
attribute3 = ScoresAttribute.create(feature: "Time Submitted Score", feature_weight: 0.25)



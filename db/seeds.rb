# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# db/seeds/scores_attributes_seeds.rb

# Seed data for the "scores_attributes" table
scores_attributes_data = [
  { attribute_id: 1, feature_name: 'Resume Weight', feature_weight: 0.5 },
  { attribute_id: 2, feature_name: 'Student Preference Weight', feature_weight: 0.25 },
  { attribute_id: 3, feature_name: 'Submit Time Weight', feature_weight: 0.25 },
  # Add more seed data as needed
]

# Create records in the "scores_attributes" table
scores_attributes_data.each do |data|
  ScoresAttribute.create(data)
end

Course.create(course_id: 429, section_number: 602, professor_id: nil, semester: "Fall 2023")
Course.create(course_id: 429, section_number: 601, professor_id: nil, semester: "Spring 2023")
Course.create(course_id: 429, section_number: 600, professor_id: nil, semester: "Fall 2023")



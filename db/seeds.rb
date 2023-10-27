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

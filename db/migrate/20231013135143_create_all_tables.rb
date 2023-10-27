class CreateAllTables < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :user_id
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :role
      t.timestamps
    end

    create_table :professors do |t|
      t.integer :professor_id
      t.boolean :admin
      t.boolean :verified
      t.timestamps
    end

    create_table :students_new do |t|
      t.integer :student_id
      t.integer :course_id
      t.integer :section_number
      t.integer :uin
      t.timestamps
    end

    create_table :projects_new do |t|
      t.integer :project_id
      t.string :project_name
      t.string :description
      t.string :sponsor
      t.integer :course_id
      t.integer :section_number
      t.timestamps
    end

    create_table :courses do |t|
      t.integer :course_id
      t.integer :professor_id
      t.string :semester
      t.timestamps
    end

    create_table :scores_entities_new do |t|
      t.integer :scores_id
      t.integer :student_id
      t.integer :project_id
      t.timestamps
    end

    create_table :scores_attributes do |t|
      t.integer :attribute_id
      t.string :feature_name
      t.float :feature_weight
      t.timestamps
    end

    create_table :scores_values_new do |t|
      t.integer :scores_id
      t.integer :attribute_id
      t.float :feature_score
      t.timestamps
    end
  end
end

class NewSchema < ActiveRecord::Migration[7.0]
  def change
    create_table :globals, id: false, primary_key: :global_id do |t|
      t.integer :global_id
      t.integer :min_number, default: 0, null: false
      t.boolean :lock, default: false, null: false
    end

    create_table :users, id: false, primary_key: :user_id do |t|
      t.integer :user_id, null: false, unique: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :role, null: false
      t.string :email, null: false, unique: true
    end

    create_table :professors, id: false, primary_key: :professor_id do |t|
      t.integer :professor_id, null: false, unique: true
      t.boolean :verified, null: false, default: false
      t.boolean :admin, null: false, default: false
    end
    add_foreign_key :professors, :users, column: :professor_id

    create_table :courses, id: false, primary_key: [:course_id, :section, :semester]  do |t|
      t.integer :course_id, null: false
      t.integer :section, null: false
      t.string :semester, null: false
      t.integer :professor_id
    end
    add_foreign_key :courses, :professors, column: :professor_id
    
    create_table :students, id: false, primary_key: [:student_id, :course_id, :section, :semester] do |t|
      t.integer :student_id, null: false
      t.integer :course_id, null: false
      t.integer :section, null: false
      t.string :semester, null: false
      t.string :gender, null: false
      t.string :nationality, null: false
      t.string :work_auth, null: false
      t.string :resume
      t.timestamps
    end
    add_foreign_key :students, :users, column: :student_id
    add_foreign_key :students, :courses, column: :course_id
    add_foreign_key :students, :courses, column: :section
    add_foreign_key :students, :courses, column: :semester

    #keeps track of each possible ethnicity
    create_table :ethnicities, id: false, primary_key: :ethnicity_name do |t|
      t.string :ethnicity_name, null: false, unique: true
    end

    #so students cant have multiple ethnicities listed
    create_table :ethnicity_values, id: false, primary_key: [:student_id, :ethnicity_name] do |t|
      t.integer :student_id, null: false
      t.string :ethnicity_name, null: false
    end
    add_foreign_key :ethnicity_values, :students, column: :student_id
    add_foreign_key :ethnicity_values, :ethnicities, column: :ethnicity_name

    create_table :projects, id: false, primary_key: :project_id do |t|
      t.integer :project_id, null: false, unique: true
      t.string :name, null: false
      t.string :description, null: false
      t.string :sponsor, null: false
      t.string :course_id
      t.string :section
      t.string :semester
      t.string :info_url
    end
    add_foreign_key :projects, :courses, column: :course_id
    add_foreign_key :projects, :courses, column: :section
    add_foreign_key :projects, :courses, column: :semester
    
    create_table :professor_preferences,id: false, primary_key: [:professor_id, :project_id] do |t|
      t.integer :professor_id, null: false
      t.integer :project_id, null: false
      t.integer :pref, null: false
    end
    add_foreign_key :professor_preferences, :professors, column: :professor_id
    add_foreign_key :professor_preferences, :projects, column: :project_id


    create_table :scores_entities, id: false, primary_key: :scores_id do |t|
      t.integer :scores_id, null: false, unique: true
      t.integer :student_id, null:false
      t.integer :project_id, null:false
    end
    add_foreign_key :scores_entities, :students, column: :student_id
    add_foreign_key :scores_entities, :projects, column: :project_id
    
    create_table :scores_attributes, id: false, primary_key: :attribute_id do |t|
      t.integer :attribute_id, null: false, unique: true
      t.string :feature, null: false
      t.float :feature_weight, null: false, default: 0.0
    end

    create_table :scores_values, id: false, primary_key: [:scores_id, :attribute_id] do |t|
      t.integer :scores_id, null: false
      t.integer :attribute_id, null: false
      t.float :feature_score, null: false, default: 0.0
    end
    add_foreign_key :scores_values, :scores_attributes, column: :attribute_id
    add_foreign_key :scores_values, :scores_entities, column: :scores_id

    create_table :sponsor_restrictions, id: false, primary_key: :restriction_id do |t|
      t.integer :restriction_id, null: false, unique: true
      t.string :restriction_type, null: false #will be one of the columns on student table
      t.string :restriction_val, null: false #select values that cannot appear, if student has one of these values then they will not be allowed on the project
      t.integer :project_id, null: false
    end
    add_foreign_key :sponsor_restrictions, :projects, column: :project_id
    

    create_table :sponsor_preferences, id: false, primary_key: :preference_id do |t|
      t.integer :preference_id, null: false, unique: true
      t.string :preference_type, null: false, unique: true #will be one of the columns on student table
      t.string :preference_val, null: false, unique: true #values that they prefer - ie US citizen for work authorization, all other types will not be allowed on project
      t.integer :project_id, null: false
    end
    add_foreign_key :sponsor_preferences, :projects, column: :project_id
end

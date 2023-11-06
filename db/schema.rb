# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_11_03_013524) do
  create_table "configs", primary_key: "config_id", force: :cascade do |t|
    t.integer "min_number", default: 0, null: false
    t.integer "max_number", default: 1, null: false
    t.boolean "lock", default: false, null: false
  end

  create_table "courses", primary_key: "course_id", force: :cascade do |t|
    t.integer "course_number", null: false
    t.integer "section", null: false
    t.string "semester", null: false
    t.integer "professor_id"
    t.index ["course_number", "section", "semester"], name: "index_courses_on_course_number_and_section_and_semester", unique: true
  end

  create_table "ethnicities", primary_key: "ethnicity_name", id: :string, force: :cascade do |t|
  end

  create_table "ethnicity_values", primary_key: "ethnicity_value_id", force: :cascade do |t|
    t.integer "student_id", null: false
    t.string "ethnicity_name", null: false
    t.index ["student_id", "ethnicity_name"], name: "index_ethnicity_values_on_student_id_and_ethnicity_name", unique: true
  end

  create_table "professor_preferences", primary_key: "professor_preference_id", force: :cascade do |t|
    t.integer "professor_id", null: false
    t.integer "project_id", null: false
    t.integer "pref", null: false
    t.index ["professor_id", "project_id"], name: "index_professor_preferences_on_professor_id_and_project_id", unique: true
  end

  create_table "professors", primary_key: "professor_id", force: :cascade do |t|
    t.boolean "verified", default: false, null: false
    t.boolean "admin", default: false, null: false
  end

  create_table "projects", primary_key: "project_id", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.string "sponsor", null: false
    t.integer "course_id"
    t.string "info_url"
  end

  create_table "scores_attributes", primary_key: "attribute_id", force: :cascade do |t|
    t.string "feature", null: false
    t.float "feature_weight", default: 0.0, null: false
  end

  create_table "scores_entities", primary_key: "scores_id", force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "project_id", null: false
    t.integer "pref", null: false
    t.index ["student_id", "project_id", "pref"], name: "index_scores_entities_on_student_id_and_project_id_and_pref", unique: true
  end

  create_table "scores_values", primary_key: "scores_value_id", force: :cascade do |t|
    t.integer "scores_id", null: false
    t.integer "attribute_id", null: false
    t.float "feature_score", default: 0.0, null: false
    t.index ["scores_id", "attribute_id"], name: "index_scores_values_on_scores_id_and_attribute_id", unique: true
  end

  create_table "sponsor_preferences", primary_key: "preference_id", force: :cascade do |t|
    t.string "preference_type", null: false
    t.string "preference_val", null: false
    t.integer "project_id", null: false
    t.float "bonus_amount", default: 0.0, null: false
  end

  create_table "sponsor_restrictions", primary_key: "restriction_id", force: :cascade do |t|
    t.string "restriction_type", null: false
    t.string "restriction_val", null: false
    t.integer "project_id", null: false
  end

  create_table "students", primary_key: "student_id", force: :cascade do |t|
    t.integer "course_id", null: false
    t.string "gender", null: false
    t.string "nationality", null: false
    t.string "work_auth", null: false
    t.string "contract_sign", null: false
    t.string "resume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", primary_key: "user_id", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "role", null: false
    t.string "email", null: false
  end

  add_foreign_key "courses", "professors", primary_key: "professor_id", on_delete: :nullify
  add_foreign_key "ethnicity_values", "ethnicities", column: "ethnicity_name", primary_key: "ethnicity_name", on_delete: :cascade
  add_foreign_key "ethnicity_values", "students", primary_key: "student_id", on_delete: :cascade
  add_foreign_key "professor_preferences", "professors", primary_key: "professor_id", on_delete: :cascade
  add_foreign_key "professor_preferences", "projects", primary_key: "project_id", on_delete: :cascade
  add_foreign_key "professors", "users", column: "professor_id", primary_key: "user_id", on_delete: :cascade
  add_foreign_key "projects", "courses", primary_key: "course_id", on_delete: :nullify
  add_foreign_key "scores_entities", "projects", primary_key: "project_id", on_delete: :cascade
  add_foreign_key "scores_entities", "students", primary_key: "student_id", on_delete: :cascade
  add_foreign_key "scores_values", "scores_attributes", column: "attribute_id", primary_key: "attribute_id", on_delete: :cascade
  add_foreign_key "scores_values", "scores_entities", column: "scores_id", primary_key: "scores_id", on_delete: :cascade
  add_foreign_key "sponsor_preferences", "projects", primary_key: "project_id", on_delete: :cascade
  add_foreign_key "sponsor_restrictions", "projects", primary_key: "project_id", on_delete: :cascade
  add_foreign_key "students", "courses", primary_key: "course_id", on_delete: :cascade
  add_foreign_key "students", "users", column: "student_id", primary_key: "user_id", on_delete: :cascade
end

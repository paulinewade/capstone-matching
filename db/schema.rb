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

ActiveRecord::Schema[7.0].define(version: 2023_10_27_041511) do
  create_table "courses", force: :cascade do |t|
    t.integer "course_id"
    t.integer "professor_id"
    t.string "semester"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "section_number"
    t.index ["course_id", "section_number"], name: "index_courses_on_course_id_and_section_number", unique: true
  end

  create_table "professors", force: :cascade do |t|
    t.boolean "admin"
    t.boolean "verified"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_professors_on_user_id"
  end

  create_table "projects_new", force: :cascade do |t|
    t.integer "project_id"
    t.string "project_name"
    t.string "description"
    t.string "sponsor"
    t.integer "course_id"
    t.integer "section_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scores_attributes", force: :cascade do |t|
    t.integer "attribute_id"
    t.string "feature_name"
    t.float "feature_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scores_entities_new", force: :cascade do |t|
    t.integer "scores_id"
    t.integer "student_id"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scores_values_new", force: :cascade do |t|
    t.integer "scores_id"
    t.integer "attribute_id"
    t.float "feature_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students_new", force: :cascade do |t|
    t.integer "student_id"
    t.integer "course_id"
    t.integer "section_number"
    t.integer "uin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "user_id"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
  end

  add_foreign_key "professors", "users"
end

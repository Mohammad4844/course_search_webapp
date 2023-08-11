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

ActiveRecord::Schema[7.0].define(version: 2023_08_10_050442) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "days", ["M", "T", "W", "R", "F", "S", "U", "N/A"]
  create_enum "terms", ["Fall", "Winter", "Summer"]

  create_table "attributes", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "course_attribute", id: :serial, force: :cascade do |t|
    t.integer "course_id"
    t.integer "attribute_id"
  end

  create_table "courses", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.integer "department_id"
    t.string "code", limit: 10
    t.integer "credits"
  end

  create_table "departments", id: :serial, force: :cascade do |t|
    t.string "code", limit: 255
  end

  create_table "instructors", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "meeting_instructor", id: :serial, force: :cascade do |t|
    t.integer "meeting_id"
    t.integer "instructor_id"
  end

  create_table "meetings", id: :serial, force: :cascade do |t|
    t.integer "offering_id"
    t.time "start_time"
    t.time "end_time"
    t.enum "day", enum_type: "days"
    t.string "location", limit: 255
    t.string "type", limit: 255
  end

  create_table "offerings", id: :serial, force: :cascade do |t|
    t.integer "course_id"
    t.integer "year"
    t.enum "term", enum_type: "terms"
    t.string "crn", limit: 6
    t.string "location_type", limit: 255
    t.string "delivery_type", limit: 255
  end

  add_foreign_key "course_attribute", "attributes", name: "course_attribute_attribute_id_fkey"
  add_foreign_key "course_attribute", "courses", name: "course_attribute_course_id_fkey"
  add_foreign_key "courses", "departments", name: "courses_department_id_fkey"
  add_foreign_key "meeting_instructor", "instructors", name: "meeting_instructor_instructor_id_fkey"
  add_foreign_key "meeting_instructor", "meetings", name: "meeting_instructor_meeting_id_fkey"
  add_foreign_key "meetings", "offerings", name: "meetings_offering_id_fkey"
  add_foreign_key "offerings", "courses", name: "offerings_course_id_fkey"
end

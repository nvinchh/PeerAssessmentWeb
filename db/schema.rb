# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170131004754) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 255,   null: false
    t.string   "resource_type", limit: 255,   null: false
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "actor_participants", id: false, force: :cascade do |t|
    t.string "actor_id",       limit: 20, null: false
    t.string "participant_id", limit: 20, null: false
  end

  add_index "actor_participants", ["participant_id"], name: "actor_participant_participant_id_idx", using: :btree

  create_table "actors", force: :cascade do |t|
    t.string "role", limit: 63
  end

  create_table "answers", force: :cascade do |t|
    t.string   "assessor_actor_id",    limit: 20
    t.string   "assessee_actor_id",    limit: 20
    t.string   "assessee_artifact_id", limit: 20
    t.string   "criterion_id",         limit: 20
    t.integer  "evaluation_mode_id",   limit: 4
    t.text     "comment",              limit: 4294967295
    t.text     "comment2",             limit: 4294967295
    t.integer  "rank",                 limit: 4
    t.float    "score",                limit: 24
    t.string   "create_in_task_id",    limit: 20
    t.datetime "submitted_at"
  end

  add_index "answers", ["assessee_actor_id"], name: "answer_actor_assessee_actor_id_idx", using: :btree
  add_index "answers", ["assessee_artifact_id"], name: "answer_artifact_assessee_artifact_id_idx", using: :btree
  add_index "answers", ["assessor_actor_id"], name: "answer_actor_assessor_actor_id_idx", using: :btree
  add_index "answers", ["create_in_task_id"], name: "answer_task_create_in_task_id_idx", using: :btree
  add_index "answers", ["criterion_id"], name: "answer_criterion_criterion_id_idx", using: :btree
  add_index "answers", ["evaluation_mode_id"], name: "answer_eval_mode_evaluation_mode_id_idx", using: :btree

  create_table "artifacts", force: :cascade do |t|
    t.text   "content",              limit: 4294967295
    t.text   "elaboration",          limit: 4294967295
    t.string "submitted_in_task_id", limit: 20
    t.string "context_case",         limit: 255
  end

  add_index "artifacts", ["submitted_in_task_id"], name: "artifact_task_submitted_in_task_idx", using: :btree

  create_table "criteria", force: :cascade do |t|
    t.text   "title",       limit: 4294967295
    t.text   "description", limit: 4294967295
    t.string "type",        limit: 63
    t.float  "min_score",   limit: 24
    t.float  "max_score",   limit: 24
    t.float  "weight",      limit: 24
  end

  create_table "eval_modes", force: :cascade do |t|
    t.string "description", limit: 255
  end

  create_table "items", id: false, force: :cascade do |t|
    t.string "id",           limit: 20
    t.text   "content",      limit: 4294967295
    t.string "reference_id", limit: 20
    t.string "type",         limit: 63
  end

  create_table "participants", force: :cascade do |t|
    t.string "app_name", limit: 255
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "task_type",          limit: 63
    t.text     "task_description",   limit: 65535
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "assignment_title",   limit: 255
    t.string   "course_title",       limit: 255
    t.string   "organization_title", limit: 255
    t.string   "owner_name",         limit: 255
    t.string   "cip_level1_code",    limit: 255
    t.string   "cip_level2_code",    limit: 255
    t.string   "cip_level3_code",    limit: 255
    t.string   "app_name",           limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "actor_participants", "actors", name: "actor_participant_actor_id"
  add_foreign_key "actor_participants", "participants", name: "actor_participant_participant_id"
  add_foreign_key "answers", "actors", column: "assessee_actor_id", name: "answer_actor_assessee_actor_id"
  add_foreign_key "answers", "actors", column: "assessor_actor_id", name: "answer_actor_assessor_actor_id"
  add_foreign_key "answers", "artifacts", column: "assessee_artifact_id", name: "answer_artifact_assessee_artifact_id"
  add_foreign_key "answers", "criteria", column: "criterion_id", name: "answer_criterion_criterion_id"
  add_foreign_key "answers", "eval_modes", column: "evaluation_mode_id", name: "answer_eval_mode_evaluation_mode_id"
  add_foreign_key "answers", "tasks", column: "create_in_task_id", name: "answer_task_create_in_task_id"
  add_foreign_key "artifacts", "tasks", column: "submitted_in_task_id", name: "artifact_task_submitted_in_task"
end

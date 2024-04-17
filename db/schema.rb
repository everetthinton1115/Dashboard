# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_03_130029) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "about_categories", force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "about_paragraphs", force: :cascade do |t|
    t.integer "about_category_id"
    t.string "title"
    t.text "text"
    t.string "icon"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["about_category_id"], name: "index_about_paragraphs_on_about_category_id"
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "ads", force: :cascade do |t|
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "expiration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "region_id"
    t.integer "user_id"
    t.string "charge_id"
    t.string "card_token"
    t.string "url"
    t.string "approval_state", default: "new"
    t.index ["region_id"], name: "index_ads_on_region_id"
    t.index ["user_id"], name: "index_ads_on_user_id"
  end

  create_table "alliances", force: :cascade do |t|
    t.string "contact_email"
    t.string "name"
    t.text "description"
    t.integer "region_id"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.text "website_url"
    t.text "facebook_url"
    t.text "twitter_url"
    t.text "gplus_url"
    t.integer "area_of_interest_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "approval_state", default: "new"
    t.string "verification_doc_file_name"
    t.string "verification_doc_content_type"
    t.bigint "verification_doc_file_size"
    t.datetime "verification_doc_updated_at"
    t.integer "campaign_coordinator_id"
    t.index ["area_of_interest_id"], name: "index_alliances_on_area_of_interest_id"
    t.index ["region_id"], name: "index_alliances_on_region_id"
  end

  create_table "areas_of_interest", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "interest_type"
  end

  create_table "attendance_levels", force: :cascade do |t|
    t.integer "event_id"
    t.string "name"
    t.integer "total_available"
    t.integer "cost"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "attendees", force: :cascade do |t|
    t.integer "event_id"
    t.integer "user_id"
    t.integer "attendance_level_id"
    t.string "email"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "paid", default: false
    t.string "charge_id"
    t.string "card_token"
    t.integer "inviting_id"
  end

  create_table "campaign_categories", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaign_categorizations", force: :cascade do |t|
    t.integer "campaign_id"
    t.integer "campaign_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "campaign_check_in_histories", force: :cascade do |t|
    t.integer "campaign_id"
    t.integer "user_id"
    t.boolean "checked_in"
    t.datetime "last_checked_in"
    t.string "tokens"
    t.string "total_hours"
  end

  create_table "campaign_coordinators", force: :cascade do |t|
    t.string "campaign_id"
    t.string "integer"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "campaign_donations", force: :cascade do |t|
    t.string "email"
    t.integer "user_id"
    t.integer "campaign_id"
    t.string "card_token"
    t.string "charge_id"
    t.decimal "donation_amount", precision: 15, scale: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "message"
    t.string "first_name"
    t.string "last_name"
    t.float "charity_amount"
    t.float "charity_coordinator_amount"
    t.string "status"
    t.string "symbol"
    t.integer "campaign_coordinator_id"
    t.integer "charity_id"
    t.index ["campaign_id"], name: "index_campaign_donations_on_campaign_id"
    t.index ["user_id"], name: "index_campaign_donations_on_user_id"
  end

  create_table "campaign_winners", force: :cascade do |t|
    t.integer "votes"
    t.integer "campaign_id"
    t.integer "user_id"
    t.date "winnig_month"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "user_id"
    t.text "goal_amount"
    t.decimal "total_amount", precision: 15, scale: 8
    t.date "expiration_date"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.string "workflow_state", default: "open"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "campaign_category_id"
    t.string "category"
    t.string "video_link"
    t.boolean "approved"
    t.integer "region_id"
    t.integer "time_length"
    t.string "address_city"
    t.string "address_state"
    t.string "address_country"
    t.string "address_zip"
    t.integer "campaign_coordinator_id"
    t.text "good_goal_amount", default: "0.0"
    t.float "total_good_amount", default: 0.0
    t.index ["approved", "workflow_state"], name: "index_campaigns_on_approved_and_workflow_state"
    t.index ["campaign_category_id"], name: "index_campaigns_on_campaign_category_id"
    t.index ["user_id"], name: "index_campaigns_on_user_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "customer_id"
    t.string "card_token"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["active"], name: "index_categories_on_active"
    t.index ["ancestry"], name: "index_categories_on_ancestry"
  end

  create_table "chamber_donations", force: :cascade do |t|
    t.string "email"
    t.string "card_token"
    t.string "charge_id"
    t.integer "donation_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "message"
  end

  create_table "charitable_donations", force: :cascade do |t|
    t.string "email"
    t.integer "user_id"
    t.string "card_token"
    t.string "charge_id"
    t.integer "donation_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "message"
    t.string "first_name"
    t.string "last_name"
    t.integer "charity_id"
    t.string "charity_type"
    t.index ["charity_type", "charity_id"], name: "index_charitable_donations_on_charity_type_and_charity_id"
    t.index ["user_id"], name: "index_charitable_donations_on_user_id"
  end

  create_table "charities_coordinators", force: :cascade do |t|
    t.integer "charitable_id"
    t.string "charitable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "charleston_master_members", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "date_added"
    t.datetime "last_changed"
  end

  create_table "church_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "churches", force: :cascade do |t|
    t.string "contact_email"
    t.string "name"
    t.text "description"
    t.integer "region_id"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.text "website_url"
    t.text "facebook_url"
    t.text "twitter_url"
    t.text "gplus_url"
    t.integer "church_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "approval_state", default: "new"
    t.index ["church_category_id"], name: "index_churches_on_church_category_id"
    t.index ["region_id"], name: "index_churches_on_region_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.string "content"
    t.integer "commentable_id"
    t.string "commentable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "donations", force: :cascade do |t|
    t.string "request_id"
    t.string "donation_amount"
    t.string "sender_address"
    t.string "receiver_address"
    t.string "transaction_request_id"
    t.string "transaction_request_status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "start"
    t.datetime "end"
    t.integer "region_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "approved", default: false
    t.integer "user_id"
    t.string "registration_url"
    t.index ["region_id", "start", "approved"], name: "index_events_on_region_id_and_start_and_approved"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "campaign_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "imageable_type"
    t.bigint "imageable_id"
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id"
  end

  create_table "invites", force: :cascade do |t|
    t.string "sender_email"
    t.string "receiver_email"
    t.string "subject"
    t.string "body"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.string "referral_code"
  end

  create_table "job_leads", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "profession_title"
    t.bigint "user_id"
    t.string "resume_file_name"
    t.string "resume_content_type"
    t.bigint "resume_file_size"
    t.datetime "resume_updated_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_job_leads_on_user_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "category_id"
    t.integer "first_matchable_id"
    t.string "first_matchable_type"
    t.integer "second_matchable_id"
    t.string "second_matchable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "first_matchable_acceptance"
    t.boolean "second_matchable_acceptance"
    t.string "workflow_state"
    t.index ["category_id"], name: "index_matches_on_category_id"
    t.index ["first_matchable_type", "first_matchable_id"], name: "index_matches_on_first_matchable_type_and_first_matchable_id"
    t.index ["second_matchable_type", "second_matchable_id"], name: "index_matches_on_second_matchable_type_and_second_matchable_id"
    t.index ["workflow_state"], name: "index_matches_on_workflow_state"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "receiver_id"
    t.string "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "need_contributions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "need_id"
    t.integer "campaign_id"
    t.string "status"
    t.string "drop_off_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "needs", force: :cascade do |t|
    t.integer "user_id"
    t.integer "category_id"
    t.integer "location_id"
    t.string "title"
    t.text "description"
    t.string "location_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "workflow_state", default: "open"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.string "organization_type"
    t.integer "campaign_id"
    t.index ["campaign_id"], name: "index_needs_on_campaign_id"
    t.index ["category_id"], name: "index_needs_on_category_id"
    t.index ["created_at"], name: "index_needs_on_created_at"
    t.index ["location_id"], name: "index_needs_on_location_id"
    t.index ["user_id"], name: "index_needs_on_user_id"
    t.index ["workflow_state"], name: "index_needs_on_workflow_state"
  end

  create_table "news_letter_members", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "date_added"
    t.datetime "last_changed"
  end

  create_table "nfts", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.string "description"
    t.bigint "campaign_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.integer "user_id"
    t.index ["campaign_id"], name: "index_nfts_on_campaign_id"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.integer "amount"
    t.integer "user_id"
    t.string "charge_id"
    t.string "card_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "pending_donations", force: :cascade do |t|
    t.string "authorization_token"
    t.string "symbol"
    t.string "address"
    t.float "amount"
    t.boolean "payment_success", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "product_categories", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "product_categorizations", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "product_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_category_id"], name: "index_product_categorizations_on_product_category_id"
    t.index ["product_id"], name: "index_product_categorizations_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "user_id"
    t.integer "price"
    t.integer "region_id"
    t.string "address_city"
    t.string "address_state"
    t.string "address_country"
    t.string "address_zip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.string "lonlat"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "requests", force: :cascade do |t|
    t.integer "user_id"
    t.integer "need_id"
    t.integer "resource_id"
    t.string "workflow_state"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["need_id"], name: "index_requests_on_need_id"
    t.index ["resource_id"], name: "index_requests_on_resource_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
    t.index ["workflow_state"], name: "index_requests_on_workflow_state"
  end

  create_table "resources", force: :cascade do |t|
    t.integer "user_id"
    t.integer "category_id"
    t.integer "location_id"
    t.string "title"
    t.text "description"
    t.string "location_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "workflow_state", default: "open"
    t.string "resourceful_type"
    t.integer "resourceful_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.decimal "value", precision: 10
    t.integer "quantity", default: 1, null: false
    t.integer "quantity_claimed", default: 0, null: false
    t.integer "need_id"
    t.text "contact_email"
    t.datetime "drop_off_date"
    t.boolean "requires_delivery", default: false
    t.index ["category_id"], name: "index_resources_on_category_id"
    t.index ["need_id"], name: "index_resources_on_need_id"
    t.index ["user_id"], name: "index_resources_on_user_id"
  end

  create_table "rich_rich_files", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "rich_file_file_name"
    t.string "rich_file_content_type"
    t.integer "rich_file_file_size"
    t.datetime "rich_file_updated_at"
    t.string "owner_type"
    t.integer "owner_id"
    t.text "uri_cache"
    t.string "simplified_type", default: "file"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "user_id"
    t.string "subscription_id"
    t.string "customer_id"
    t.string "plan_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tool_box_events", force: :cascade do |t|
    t.string "title"
    t.string "category"
    t.string "link"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tool_box_resources", force: :cascade do |t|
    t.string "title"
    t.string "category"
    t.string "link"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "document_file_name"
    t.string "document_content_type"
    t.bigint "document_file_size"
    t.datetime "document_updated_at"
  end

  create_table "user_areas_of_interest", force: :cascade do |t|
    t.integer "user_id"
    t.integer "area_of_interest_id"
    t.index ["user_id", "area_of_interest_id"], name: "index_user_areas_of_interest_on_user_id_and_area_of_interest_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "name"
    t.string "address_line1"
    t.string "address_line2"
    t.string "address_city"
    t.string "address_state"
    t.string "address_country"
    t.string "address_zip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "location_id"
    t.integer "alliance_id"
    t.integer "church_id"
    t.datetime "expiration"
    t.integer "region_id"
    t.string "stripe_user_id"
    t.string "stripe_refresh_token"
    t.string "stripe_access_token"
    t.boolean "shipping_label_printed", default: false
    t.string "referral_code"
    t.string "profile_file_name"
    t.string "profile_content_type"
    t.bigint "profile_file_size"
    t.datetime "profile_updated_at"
    t.float "lat"
    t.float "lng"
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "wallet_password"
    t.string "identification_photo_file_name"
    t.string "identification_photo_content_type"
    t.bigint "identification_photo_file_size"
    t.datetime "identification_photo_updated_at"
    t.string "license_photo_file_name"
    t.string "license_photo_content_type"
    t.bigint "license_photo_file_size"
    t.datetime "license_photo_updated_at"
    t.string "authorization_token"
    t.string "bitcoin_address"
    t.string "commit_good_address"
    t.string "ethereum_address"
    t.index ["alliance_id"], name: "index_users_on_alliance_id"
    t.index ["church_id"], name: "index_users_on_church_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["location_id"], name: "index_users_on_location_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_campaigns", force: :cascade do |t|
    t.integer "user_id"
    t.integer "campaign_id"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "volunteer_appliers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "volunteer_id"
    t.integer "campaign_id"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "number_of_hours"
  end

  create_table "volunteer_campaigns", force: :cascade do |t|
    t.integer "volunteer_id"
    t.integer "campaign_id"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "volunteer_contributions", force: :cascade do |t|
    t.datetime "sign_in"
    t.datetime "sign_out"
    t.integer "volunteer_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "volunteers", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "campaign_id"
    t.integer "hours"
    t.integer "number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "votes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "voteable_id"
    t.string "voteable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "wallets", force: :cascade do |t|
    t.integer "user_id"
    t.string "meta_address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "product_categorizations", "product_categories"
  add_foreign_key "product_categorizations", "products"
end

create extension if not exists "pg_cron" with schema "pg_catalog";

create extension if not exists "postgis" with schema "public";

create extension if not exists "vector" with schema "public";

-- Enable pg_net extension for HTTP requests
create extension if not exists "pg_net" with schema "extensions";

-- Create supabase_functions schema if it doesn't exist
create schema if not exists "supabase_functions";

-- Create http_request wrapper function in supabase_functions schema
create or replace function supabase_functions.http_request(
  url text,
  method text default 'GET',
  headers jsonb default '{}'::jsonb,
  params jsonb default '{}'::jsonb,
  timeout_milliseconds integer default 5000
)
returns bigint
language plpgsql
security definer
as $$
declare
  request_id bigint;
begin
  select net.http_request(
    url := url,
    method := method::net.http_method,
    headers := headers,
    body := params::text::bytea,
    timeout_milliseconds := timeout_milliseconds
  ) into request_id;
  
  return request_id;
end;
$$;

create sequence "public"."beauty_booking_number_seq";

create sequence "public"."hotel_booking_number_seq";

create sequence "public"."preorder_number_seq";


  create table "public"."admin_activity_logs" (
    "id" uuid not null default gen_random_uuid(),
    "admin_id" uuid,
    "action_type" text not null,
    "action_subtype" text,
    "target_table" text,
    "target_id" uuid,
    "target_name" text,
    "old_values" jsonb,
    "new_values" jsonb,
    "action_details" text not null,
    "ip_address" inet,
    "user_agent" text,
    "session_id" text,
    "request_id" text,
    "success" boolean default true,
    "error_message" text,
    "execution_time_ms" integer,
    "affected_rows" integer,
    "additional_data" jsonb,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."admin_activity_logs" enable row level security;


  create table "public"."admin_export_logs" (
    "id" uuid not null default gen_random_uuid(),
    "admin_id" uuid,
    "export_type" text not null,
    "target_table" text,
    "filters_applied" jsonb,
    "date_range" jsonb,
    "file_name" text,
    "file_size_bytes" integer,
    "record_count" integer,
    "ip_address" inet,
    "user_agent" text,
    "session_id" text,
    "export_success" boolean default true,
    "error_message" text,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."admin_login_logs" (
    "id" uuid not null default gen_random_uuid(),
    "admin_id" uuid,
    "login_method" text not null default 'google'::text,
    "ip_address" inet,
    "user_agent" text,
    "session_id" text,
    "login_success" boolean default true,
    "failure_reason" text,
    "login_at" timestamp with time zone default now(),
    "logout_at" timestamp with time zone,
    "session_duration_minutes" integer
      );



  create table "public"."admin_system_config_logs" (
    "id" uuid not null default gen_random_uuid(),
    "admin_id" uuid,
    "config_type" text not null,
    "config_key" text not null,
    "old_value" jsonb,
    "new_value" jsonb,
    "change_reason" text,
    "ip_address" inet,
    "user_agent" text,
    "session_id" text,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."admin_view_logs" (
    "id" uuid not null default gen_random_uuid(),
    "admin_id" uuid,
    "view_type" text not null,
    "target_table" text,
    "target_id" uuid,
    "filters_applied" jsonb,
    "search_terms" text,
    "sort_by" text,
    "page_number" integer,
    "items_per_page" integer,
    "total_items" integer,
    "ip_address" inet,
    "user_agent" text,
    "session_id" text,
    "view_duration_ms" integer,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."ads" (
    "id" uuid not null default gen_random_uuid(),
    "name" character varying(255) not null,
    "content" text,
    "image_url" text,
    "store_id" uuid,
    "product_id" uuid,
    "target_url" text,
    "start_date" timestamp with time zone default now(),
    "end_date" timestamp with time zone,
    "is_active" boolean default true,
    "priority" integer default 0,
    "click_count" integer default 0,
    "view_count" integer default 0,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."ads" enable row level security;


  create table "public"."ads_floating" (
    "id" uuid not null default gen_random_uuid(),
    "name" character varying(255) not null,
    "content" text,
    "image_url" text,
    "store_id" uuid,
    "product_id" uuid,
    "target_url" text,
    "start_date" timestamp with time zone default now(),
    "end_date" timestamp with time zone,
    "is_active" boolean default true,
    "priority" integer default 0,
    "click_count" integer default 0,
    "view_count" integer default 0,
    "position" text default 'bottom-right'::text,
    "size" integer default 60,
    "show_close_button" boolean default true,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."ads_floating" enable row level security;


  create table "public"."ads_hotel" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "content" text,
    "image_url" text,
    "hotel_id" uuid,
    "room_id" uuid,
    "target_url" text,
    "start_date" timestamp with time zone default now(),
    "end_date" timestamp with time zone,
    "is_active" boolean default true,
    "priority" integer default 0,
    "click_count" integer default 0,
    "view_count" integer default 0,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."app_store_versions" (
    "id" uuid not null default gen_random_uuid(),
    "platform" character varying(20) not null,
    "version_code" integer not null,
    "version_name" character varying(20) not null,
    "min_required_version" integer not null,
    "force_update" boolean default false,
    "update_message" text,
    "download_url" text,
    "is_active" boolean default true,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."app_store_versions" enable row level security;


  create table "public"."app_versions" (
    "id" uuid not null default gen_random_uuid(),
    "platform" character varying(20) not null,
    "version_code" integer not null,
    "version_name" character varying(50) not null,
    "min_required_version" integer not null,
    "force_update" boolean default false,
    "update_message" text,
    "download_url" text,
    "is_active" boolean default true,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."available_jobs_for_workers" (
    "job_posting_id" uuid not null,
    "job_number" text not null,
    "title" text not null,
    "description" text,
    "job_price" numeric(10,2) not null,
    "category_id" uuid,
    "category_name" text,
    "employer_address" text not null,
    "employer_latitude" numeric(10,8),
    "employer_longitude" numeric(11,8),
    "distance_km" numeric(5,2),
    "employer_name" text,
    "employer_phone" text,
    "employer_line_id" text,
    "special_instructions" text,
    "estimated_completion_time" timestamp with time zone,
    "payment_method" text default 'cash'::text,
    "payment_status" text default 'pending'::text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."beauty_booking_status_history" (
    "id" uuid not null default gen_random_uuid(),
    "booking_id" uuid,
    "status" text not null,
    "changed_by" text not null,
    "notes" text,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."beauty_bookings" (
    "id" uuid not null default gen_random_uuid(),
    "booking_number" text not null,
    "customer_name" text not null,
    "customer_email" text not null,
    "customer_phone" text not null,
    "customer_line_id" text,
    "salon_id" uuid,
    "service_id" uuid,
    "staff_id" uuid,
    "booking_date" date not null,
    "booking_time" time without time zone not null,
    "duration_minutes" integer not null,
    "customer_count" integer default 1,
    "total_amount" numeric(10,2) not null,
    "payment_method" text default 'cash'::text,
    "payment_status" text default 'pending'::text,
    "booking_status" text default 'pending'::text,
    "special_requests" text,
    "cancellation_reason" text,
    "cancelled_at" timestamp with time zone,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."beauty_bookings" enable row level security;


  create table "public"."beauty_notifications" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid,
    "salon_id" uuid,
    "booking_id" uuid,
    "notification_type" text not null,
    "title" text not null,
    "message" text not null,
    "is_read" boolean default false,
    "data" jsonb default '{}'::jsonb,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."beauty_notifications" enable row level security;


  create table "public"."beauty_owner_accounts" (
    "id" uuid not null default gen_random_uuid(),
    "email" text not null,
    "password_hash" text not null,
    "salon_id" uuid,
    "is_active" boolean default true,
    "last_login_at" timestamp with time zone,
    "login_count" integer default 0,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."beauty_reviews" (
    "id" uuid not null default gen_random_uuid(),
    "booking_id" uuid,
    "customer_name" text not null,
    "customer_email" text not null,
    "salon_id" uuid,
    "service_id" uuid,
    "staff_id" uuid,
    "rating" integer not null,
    "review_text" text,
    "review_images" jsonb default '[]'::jsonb,
    "is_anonymous" boolean default false,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."beauty_reviews" enable row level security;


  create table "public"."beauty_salons" (
    "id" uuid not null default gen_random_uuid(),
    "owner_id" uuid not null,
    "owner_name" text not null,
    "owner_email" text not null,
    "owner_phone" text not null,
    "salon_name" text not null,
    "description" text,
    "address" text not null,
    "phone" text,
    "email" text,
    "website" text,
    "latitude" numeric(10,8),
    "longitude" numeric(11,8),
    "opening_hours" jsonb default '{}'::jsonb,
    "holidays" jsonb default '[]'::jsonb,
    "amenities" jsonb default '{}'::jsonb,
    "images" jsonb default '[]'::jsonb,
    "policies" jsonb default '{}'::jsonb,
    "verification_documents" jsonb default '[]'::jsonb,
    "is_active" boolean default true,
    "is_verified" boolean default false,
    "verification_status" text default 'pending'::text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."beauty_salons" enable row level security;


  create table "public"."beauty_schedules" (
    "id" uuid not null default gen_random_uuid(),
    "salon_id" uuid,
    "staff_id" uuid,
    "date" date not null,
    "time_slot" time without time zone not null,
    "duration_minutes" integer not null,
    "is_available" boolean default true,
    "max_customers" integer default 1,
    "booked_customers" integer default 0,
    "is_holiday" boolean default false,
    "notes" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."beauty_schedules" enable row level security;


  create table "public"."beauty_services" (
    "id" uuid not null default gen_random_uuid(),
    "salon_id" uuid,
    "service_name" text not null,
    "description" text,
    "category" text not null,
    "duration_minutes" integer not null,
    "price" numeric(10,2) not null,
    "images" jsonb default '[]'::jsonb,
    "is_active" boolean default true,
    "requires_advance_booking" boolean default true,
    "max_customers_per_slot" integer default 1,
    "min_age" integer default 0,
    "is_featured" boolean default false,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."beauty_services" enable row level security;


  create table "public"."beauty_staff" (
    "id" uuid not null default gen_random_uuid(),
    "salon_id" uuid,
    "user_id" uuid,
    "full_name" text not null,
    "phone" text not null,
    "email" text,
    "avatar_url" text,
    "specialties" jsonb default '[]'::jsonb,
    "experience_years" integer default 0,
    "working_hours" jsonb default '{}'::jsonb,
    "is_active" boolean default true,
    "is_verified" boolean default false,
    "rating" numeric(3,2) default 0,
    "total_bookings" integer default 0,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."beauty_staff" enable row level security;


  create table "public"."cancellation_requests" (
    "id" uuid not null default gen_random_uuid(),
    "assignment_id" uuid,
    "rider_id" uuid,
    "order_id" uuid,
    "reason" text not null,
    "description" text,
    "evidence_images" text[],
    "emergency_level" text not null,
    "status" text not null default 'pending'::text,
    "reviewed_by" uuid,
    "reviewed_at" timestamp with time zone,
    "review_notes" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."cancellation_requests" enable row level security;


  create table "public"."chat_messages" (
    "id" uuid not null default gen_random_uuid(),
    "order_id" uuid not null,
    "sender_type" text not null,
    "sender_id" uuid not null,
    "message" text not null,
    "message_type" text default 'text'::text,
    "is_read" boolean default false,
    "sender_fcm_token" text,
    "recipient_fcm_token" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."chat_messages" enable row level security;


  create table "public"."community_comment_likes" (
    "id" uuid not null default gen_random_uuid(),
    "comment_id" uuid not null,
    "user_id" uuid not null,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."community_comments" (
    "id" uuid not null default gen_random_uuid(),
    "post_id" uuid not null,
    "user_id" uuid not null,
    "parent_comment_id" uuid,
    "content" text not null,
    "image_file_path" text,
    "image_file_name" text,
    "image_file_size" bigint,
    "image_mime_type" text,
    "is_active" boolean default true,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."community_post_images" (
    "id" uuid not null default gen_random_uuid(),
    "post_id" uuid not null,
    "file_path" text not null,
    "image_order" integer not null default 1,
    "file_name" text,
    "file_size" bigint,
    "mime_type" text,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."community_post_likes" (
    "id" uuid not null default gen_random_uuid(),
    "post_id" uuid not null,
    "user_id" uuid not null,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."community_posts" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null,
    "post_type" text not null,
    "content" text,
    "location_name" text,
    "latitude" double precision,
    "longitude" double precision,
    "is_active" boolean default true,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."delivery_fee_config_v2" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "description" text,
    "is_active" boolean not null default true,
    "is_default" boolean not null default false,
    "minimum_order_amount" numeric(10,2) default 0,
    "free_delivery_threshold" numeric(10,2) default 0,
    "peak_hour_multiplier" numeric(3,2) default 1.0,
    "peak_hour_start" time without time zone default '17:00:00'::time without time zone,
    "peak_hour_end" time without time zone default '20:00:00'::time without time zone,
    "max_delivery_distance" numeric(5,2) default 10.0,
    "created_by" uuid,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."delivery_fee_history" (
    "id" uuid not null default gen_random_uuid(),
    "setting_id" uuid,
    "old_base_fee" numeric(10,2),
    "new_base_fee" numeric(10,2),
    "old_distance_fee_per_km" numeric(10,2),
    "new_distance_fee_per_km" numeric(10,2),
    "old_free_delivery_threshold" numeric(10,2),
    "new_free_delivery_threshold" numeric(10,2),
    "reason" text,
    "changed_by" uuid,
    "changed_at" timestamp with time zone default now()
      );



  create table "public"."delivery_fee_settings" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "description" text,
    "base_fee" numeric(10,2) not null default 30,
    "distance_fee_per_km" numeric(10,2) default 5,
    "max_delivery_distance" integer default 10,
    "minimum_order_amount" numeric(10,2) default 0,
    "free_delivery_threshold" numeric(10,2) default 0,
    "peak_hour_multiplier" numeric(3,2) default 1.0,
    "peak_hour_start" time without time zone default '18:00:00'::time without time zone,
    "peak_hour_end" time without time zone default '20:00:00'::time without time zone,
    "is_active" boolean default true,
    "is_default" boolean default false,
    "created_by" uuid,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."delivery_fee_tiers" (
    "id" uuid not null default gen_random_uuid(),
    "config_id" uuid not null,
    "min_distance" numeric(5,2) not null default 0,
    "max_distance" numeric(5,2),
    "fee" numeric(10,2) not null,
    "sort_order" integer not null default 0,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."delivery_notes" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null,
    "note_title" text not null,
    "note_content" text not null,
    "is_favorite" boolean default false,
    "usage_count" integer default 0,
    "last_used_at" timestamp with time zone,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."delivery_notes" enable row level security;


  create table "public"."delivery_window_allocations" (
    "id" uuid not null default gen_random_uuid(),
    "delivery_date" date not null,
    "delivery_window_id" uuid,
    "max_orders" integer not null,
    "current_orders" integer default 0,
    "status" text default 'open'::text
      );


alter table "public"."delivery_window_allocations" enable row level security;


  create table "public"."delivery_windows" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "start_time" time without time zone not null,
    "end_time" time without time zone not null,
    "max_orders" integer default 50,
    "fee_adjustment" numeric(10,2) default 0,
    "is_active" boolean default true,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."delivery_windows" enable row level security;


  create table "public"."discount_code_usage" (
    "id" uuid not null default gen_random_uuid(),
    "discount_code_id" uuid not null,
    "user_id" uuid not null,
    "order_id" uuid not null,
    "used_at" timestamp with time zone default now()
      );


alter table "public"."discount_code_usage" enable row level security;


  create table "public"."discount_codes" (
    "id" uuid not null default gen_random_uuid(),
    "code" text not null,
    "name" text not null,
    "description" text,
    "discount_type" text not null,
    "discount_value" numeric(10,2) not null,
    "minimum_order_amount" numeric(10,2) default 0,
    "maximum_discount_amount" numeric(10,2),
    "usage_limit" integer,
    "used_count" integer default 0,
    "is_active" boolean default true,
    "valid_from" timestamp with time zone not null,
    "valid_until" timestamp with time zone not null,
    "applicable_stores" uuid[],
    "applicable_products" uuid[],
    "created_by" uuid,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."discount_codes" enable row level security;


  create table "public"."document_verification_history" (
    "id" uuid not null default gen_random_uuid(),
    "document_id" uuid,
    "rider_id" uuid,
    "action" text not null,
    "verified_by" uuid,
    "notes" text,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."document_verification_history" enable row level security;


  create table "public"."documents" (
    "id" uuid not null default gen_random_uuid(),
    "content" text,
    "embedding" public.vector(3072),
    "metadata" jsonb default '{}'::jsonb
      );



  create table "public"."fcm_store" (
    "id" uuid not null default gen_random_uuid(),
    "store_id" uuid not null,
    "user_id" uuid not null,
    "fcm_token" text not null,
    "device_name" character varying(255),
    "platform" character varying(20) not null,
    "app_version" character varying(20),
    "is_active" boolean default true,
    "last_used_at" timestamp with time zone default now(),
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."hotel_booking_status_history" (
    "id" uuid not null default gen_random_uuid(),
    "booking_id" uuid,
    "status" text not null,
    "changed_by" text not null,
    "notes" text,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."hotel_bookings" (
    "id" uuid not null default gen_random_uuid(),
    "booking_number" text not null,
    "customer_name" text not null,
    "customer_email" text not null,
    "customer_phone" text not null,
    "customer_line_id" text,
    "hotel_id" uuid,
    "room_id" uuid,
    "check_in_date" date,
    "check_out_date" date,
    "total_nights" integer,
    "check_in_time" time without time zone,
    "check_out_time" time without time zone,
    "total_hours" integer,
    "booking_type" text default 'daily'::text,
    "guests_count" integer not null,
    "total_amount" numeric(10,2) not null,
    "deposit_amount" numeric(10,2) default 0,
    "payment_method" text default 'cash'::text,
    "payment_status" text default 'pending'::text,
    "booking_status" text default 'pending'::text,
    "guests" jsonb default '[]'::jsonb,
    "extras" jsonb default '[]'::jsonb,
    "notes" jsonb default '[]'::jsonb,
    "payment_info" jsonb default '{}'::jsonb,
    "special_requests" text,
    "cancellation_reason" text,
    "cancelled_at" timestamp with time zone,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."hotel_hourly_availability" (
    "id" uuid not null default gen_random_uuid(),
    "room_id" uuid,
    "date" date not null,
    "hour_00" boolean default true,
    "hour_01" boolean default true,
    "hour_02" boolean default true,
    "hour_03" boolean default true,
    "hour_04" boolean default true,
    "hour_05" boolean default true,
    "hour_06" boolean default true,
    "hour_07" boolean default true,
    "hour_08" boolean default true,
    "hour_09" boolean default true,
    "hour_10" boolean default true,
    "hour_11" boolean default true,
    "hour_12" boolean default true,
    "hour_13" boolean default true,
    "hour_14" boolean default true,
    "hour_15" boolean default true,
    "hour_16" boolean default true,
    "hour_17" boolean default true,
    "hour_18" boolean default true,
    "hour_19" boolean default true,
    "hour_20" boolean default true,
    "hour_21" boolean default true,
    "hour_22" boolean default true,
    "hour_23" boolean default true,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."hotel_notifications" (
    "id" uuid not null default gen_random_uuid(),
    "hotel_id" uuid,
    "booking_id" uuid,
    "notification_type" text not null,
    "title" text not null,
    "message" text not null,
    "is_read" boolean default false,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."hotel_owner_accounts" (
    "id" uuid not null default gen_random_uuid(),
    "email" text not null,
    "password_hash" text not null,
    "hotel_id" uuid,
    "is_active" boolean default true,
    "last_login_at" timestamp with time zone,
    "login_count" integer default 0,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."hotel_properties" (
    "id" uuid not null default gen_random_uuid(),
    "owner_id" uuid not null,
    "owner_name" text not null,
    "owner_email" text not null,
    "owner_phone" text not null,
    "hotel_name" text not null,
    "description" text,
    "address" text not null,
    "hotel_phone" text,
    "hotel_email" text,
    "website" text,
    "latitude" numeric(10,8),
    "longitude" numeric(11,8),
    "star_rating" integer,
    "price_range" text,
    "hotel_size" text,
    "max_rooms" integer default 100,
    "total_rooms" integer default 0,
    "amenities" jsonb default '{}'::jsonb,
    "images" jsonb default '[]'::jsonb,
    "policies" jsonb default '{}'::jsonb,
    "verification_documents" jsonb default '[]'::jsonb,
    "is_active" boolean default true,
    "is_verified" boolean default false,
    "verification_status" text default 'pending'::text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."hotel_reviews" (
    "id" uuid not null default gen_random_uuid(),
    "booking_id" uuid,
    "customer_name" text not null,
    "customer_email" text not null,
    "hotel_id" uuid,
    "rating" integer not null,
    "review_text" text,
    "review_images" jsonb default '[]'::jsonb,
    "is_anonymous" boolean default false,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."hotel_room_availability" (
    "id" uuid not null default gen_random_uuid(),
    "room_id" uuid,
    "date" date not null,
    "is_available" boolean default true,
    "reason" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."hotel_room_types" (
    "id" uuid not null default gen_random_uuid(),
    "hotel_id" uuid,
    "type_name" text not null,
    "booking_mode" text not null,
    "daily_price" numeric(10,2),
    "hourly_price" numeric(10,2),
    "hourly_minimum_hours" integer default 2,
    "hourly_maximum_hours" integer default 24,
    "capacity" integer not null,
    "amenities" jsonb default '{}'::jsonb,
    "pricing_rules" jsonb default '[]'::jsonb,
    "seasonal_rates" jsonb default '[]'::jsonb,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."hotel_rooms" (
    "id" uuid not null default gen_random_uuid(),
    "hotel_id" uuid,
    "room_type_id" uuid,
    "room_type" text not null,
    "room_number" text,
    "floor_number" integer,
    "price_per_night" numeric(10,2) not null,
    "hourly_price" numeric(10,2),
    "capacity" integer not null,
    "size_sqm" numeric(5,2),
    "amenities" jsonb default '{}'::jsonb,
    "images" jsonb default '[]'::jsonb,
    "maintenance_history" jsonb default '[]'::jsonb,
    "cleaning_schedule" jsonb default '[]'::jsonb,
    "supports_hourly" boolean default false,
    "hourly_minimum_hours" integer default 2,
    "hourly_maximum_hours" integer default 24,
    "is_available" boolean default true,
    "room_status" text default 'available'::text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."job_assignments" (
    "id" uuid not null default gen_random_uuid(),
    "job_posting_id" uuid not null,
    "worker_id" uuid not null,
    "status" text not null default 'assigned'::text,
    "assigned_at" timestamp with time zone default now(),
    "started_at" timestamp with time zone,
    "completed_at" timestamp with time zone,
    "cancelled_at" timestamp with time zone,
    "cancellation_reason" text,
    "cancelled_by" uuid,
    "rating_by_employer" numeric(3,2),
    "rating_by_worker" numeric(3,2),
    "review_by_employer" text,
    "review_by_worker" text,
    "job_price" numeric(10,2),
    "platform_fee_amount" numeric(10,2),
    "fee_percentage_used" numeric(5,2),
    "credit_amount" numeric(10,2),
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "work_image_url" text
      );



  create table "public"."job_categories" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "description" text,
    "icon_url" text,
    "is_active" boolean not null default true,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."job_company_bank_accounts" (
    "id" uuid not null default gen_random_uuid(),
    "account_name" text not null,
    "account_number" text not null,
    "bank_name" text not null,
    "qr_code_image_url" text,
    "account_image_url" text,
    "is_active" boolean not null default true,
    "display_order" integer default 0,
    "notes" text,
    "created_by" uuid,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."job_completion_approvals" (
    "id" uuid not null default gen_random_uuid(),
    "job_posting_id" uuid not null,
    "job_assignment_id" uuid,
    "worker_id" uuid not null,
    "employer_id" uuid not null,
    "job_number" text not null,
    "job_title" text,
    "job_price" numeric(10,2) not null,
    "platform_fee_amount" numeric(10,2) not null default 0,
    "credit_amount" numeric(10,2) not null,
    "approval_status" text not null default 'pending'::text,
    "approved_by" uuid,
    "approved_at" timestamp with time zone,
    "credit_transferred" boolean not null default false,
    "credit_transferred_at" timestamp with time zone,
    "transfer_reference" text,
    "transfer_slip_url" text,
    "notes" text,
    "rejection_reason" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "work_image_url" text
      );



  create table "public"."job_fee_settings" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "description" text,
    "fee_percentage" numeric(5,2) not null,
    "minimum_fee" numeric(10,2) default 0,
    "maximum_fee" numeric(10,2),
    "is_active" boolean not null default true,
    "is_default" boolean not null default false,
    "effective_from" timestamp with time zone default now(),
    "effective_to" timestamp with time zone,
    "created_by" uuid,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."job_postings" (
    "id" uuid not null default gen_random_uuid(),
    "job_number" text not null,
    "employer_id" uuid,
    "category_id" uuid,
    "worker_id" uuid,
    "title" text not null,
    "description" text,
    "job_price" numeric(10,2) not null,
    "status" text not null default 'pending'::text,
    "employer_address" text not null,
    "employer_latitude" numeric(10,8),
    "employer_longitude" numeric(11,8),
    "distance_km" numeric(5,2),
    "payment_method" text default 'cash'::text,
    "payment_status" text default 'pending'::text,
    "estimated_completion_time" timestamp with time zone,
    "actual_completion_time" timestamp with time zone,
    "special_instructions" text,
    "employer_name" text,
    "employer_phone" text,
    "employer_email" text,
    "employer_line_id" text,
    "bank_account_number" text,
    "bank_account_name" text,
    "bank_name" text,
    "qr_code_url" text,
    "transfer_amount" numeric(10,2),
    "transfer_reference" text,
    "transfer_slip_url" text,
    "transfer_confirmed_at" timestamp with time zone,
    "transfer_confirmed_by" uuid,
    "cancellation_reason" text,
    "cancelled_by" uuid,
    "cancelled_at" timestamp with time zone,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "work_image_url" text
      );



  create table "public"."job_worker_credit_ledger" (
    "id" uuid not null default gen_random_uuid(),
    "worker_id" uuid not null,
    "job_assignment_id" uuid,
    "transaction_type" text not null,
    "amount" numeric(10,2) not null,
    "balance_after" numeric(10,2) not null,
    "reason_code" text not null,
    "description" text,
    "metadata" jsonb default '{}'::jsonb,
    "payment_method" text,
    "bank_account_number" text,
    "bank_account_name" text,
    "bank_name" text,
    "transfer_reference" text,
    "transfer_slip_url" text,
    "withdrawal_status" text,
    "processed_by" uuid,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."job_worker_credits" (
    "id" uuid not null default gen_random_uuid(),
    "worker_id" uuid not null,
    "available_balance" numeric(10,2) not null default 0,
    "pending_balance" numeric(10,2) not null default 0,
    "total_earned" numeric(10,2) not null default 0,
    "last_transaction_at" timestamp with time zone,
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."job_worker_fcm_tokens" (
    "id" uuid not null default gen_random_uuid(),
    "worker_id" uuid not null,
    "fcm_token" text not null,
    "device_type" text not null default 'mobile'::text,
    "is_active" boolean not null default true,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."job_worker_withdrawals" (
    "id" uuid not null default gen_random_uuid(),
    "worker_id" uuid not null,
    "amount" numeric(10,2) not null,
    "status" text not null default 'pending'::text,
    "bank_account_number" text not null,
    "bank_account_name" text not null,
    "bank_name" text not null,
    "requested_at" timestamp with time zone default now(),
    "processed_at" timestamp with time zone,
    "processed_by" uuid,
    "rejection_reason" text,
    "transfer_reference" text,
    "transfer_slip_url" text,
    "notes" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."job_workers" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null,
    "bio" text,
    "skills" text[] default '{}'::text[],
    "current_location" point,
    "is_available" boolean not null default true,
    "is_active" boolean not null default true,
    "total_jobs" integer not null default 0,
    "total_earnings" numeric(10,2) not null default 0,
    "rating" numeric(3,2) not null default 0,
    "total_ratings" integer not null default 0,
    "credit_balance" numeric(10,2) not null default 0,
    "minimum_withdrawal_amount" numeric(10,2) not null default 100,
    "bank_account_name" text,
    "bank_account_number" text,
    "bank_name" text,
    "qr_code_url" text,
    "documents_verified" boolean not null default false,
    "verified_by" uuid,
    "verified_at" timestamp with time zone,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."loyalty_point_ledger" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null,
    "order_id" uuid,
    "transaction_type" text not null,
    "points_change" integer not null,
    "reason_code" text not null,
    "description" text,
    "metadata" jsonb default '{}'::jsonb,
    "expires_at" timestamp with time zone,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."loyalty_point_rules" (
    "id" uuid not null default gen_random_uuid(),
    "rule_code" text not null,
    "description" text,
    "trigger_event" text not null,
    "points_awarded" integer not null,
    "is_active" boolean default true,
    "conditions" jsonb default '{}'::jsonb,
    "effective_from" timestamp with time zone default now(),
    "effective_to" timestamp with time zone,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."loyalty_redemption_rules" (
    "id" uuid not null default gen_random_uuid(),
    "rule_code" text not null,
    "description" text,
    "points_required" integer not null,
    "reward_type" text not null,
    "reward_value" numeric(10,2) not null,
    "metadata" jsonb default '{}'::jsonb,
    "is_active" boolean default true,
    "max_uses_per_user" integer,
    "effective_from" timestamp with time zone default now(),
    "effective_to" timestamp with time zone,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."loyalty_tasks" (
    "id" uuid not null default gen_random_uuid(),
    "task_code" text not null,
    "title" text not null,
    "description" text,
    "task_type" text not null,
    "icon_name" text,
    "points_reward" integer not null,
    "max_progress" integer not null default 1,
    "reset_frequency" text,
    "trigger_event" text,
    "conditions" jsonb default '{}'::jsonb,
    "is_active" boolean default true,
    "display_order" integer default 0,
    "effective_from" timestamp with time zone default now(),
    "effective_to" timestamp with time zone,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."new_order_for_riders" (
    "order_id" uuid not null,
    "store_name" text not null,
    "delivery_fee" numeric(10,2) default 0,
    "status" text not null
      );



  create table "public"."notification_logs" (
    "id" uuid not null default gen_random_uuid(),
    "order_id" uuid,
    "trigger_type" text not null,
    "notification_data" jsonb,
    "response_status" integer,
    "response_body" text,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."notification_logs" enable row level security;


  create table "public"."notifications" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid,
    "title" text not null,
    "message" text not null,
    "type" text not null,
    "data" jsonb,
    "is_read" boolean default false,
    "read_at" timestamp with time zone,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."order_checklist_photos" (
    "id" uuid not null default gen_random_uuid(),
    "preorder_order_id" uuid,
    "store_id" uuid,
    "photo_type" text not null,
    "url" text not null,
    "uploaded_by" uuid,
    "uploaded_at" timestamp with time zone default now()
      );


alter table "public"."order_checklist_photos" enable row level security;


  create table "public"."order_deposits" (
    "id" uuid not null default gen_random_uuid(),
    "preorder_order_id" uuid,
    "required_amount" numeric(10,2) not null,
    "paid_amount" numeric(10,2) default 0,
    "payment_method" text default 'bank_transfer'::text,
    "payment_status" text default 'pending'::text,
    "proof_url" text,
    "deposit_reference" text,
    "verified_by" uuid,
    "created_at" timestamp with time zone default now(),
    "verified_at" timestamp with time zone
      );


alter table "public"."order_deposits" enable row level security;


  create table "public"."order_discounts" (
    "id" uuid not null default gen_random_uuid(),
    "order_id" uuid not null,
    "discount_code_id" uuid not null,
    "discount_amount" numeric(10,2) not null,
    "applied_at" timestamp with time zone default now(),
    "applied_by" uuid
      );


alter table "public"."order_discounts" enable row level security;


  create table "public"."order_item_options" (
    "id" uuid not null default gen_random_uuid(),
    "order_item_id" uuid,
    "option_id" uuid,
    "option_name" text not null,
    "selected_value_id" uuid,
    "selected_value_name" text not null,
    "price_adjustment" numeric(10,2) default 0,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."order_items" (
    "id" uuid not null default gen_random_uuid(),
    "order_id" uuid,
    "product_id" uuid,
    "product_name" text not null,
    "product_price" numeric(10,2) not null,
    "quantity" integer not null,
    "total_price" numeric(10,2) not null,
    "special_instructions" text,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."order_reviews" (
    "id" uuid not null default gen_random_uuid(),
    "order_id" uuid not null,
    "customer_id" uuid not null,
    "store_id" uuid not null,
    "rating" numeric(3,2) not null,
    "review_text" text,
    "review_images" text[],
    "is_anonymous" boolean default false,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."order_rider_locations" (
    "id" uuid not null default gen_random_uuid(),
    "order_id" uuid not null,
    "rider_id" uuid not null,
    "latitude" numeric(10,8) not null,
    "longitude" numeric(11,8) not null,
    "recorded_at" timestamp with time zone not null default now()
      );



  create table "public"."order_status_history" (
    "id" uuid not null default gen_random_uuid(),
    "order_id" uuid,
    "status" text not null,
    "updated_by" uuid,
    "cancellation_reason" text,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."order_status_history" enable row level security;


  create table "public"."orders" (
    "id" uuid not null default gen_random_uuid(),
    "order_number" text not null,
    "customer_id" uuid,
    "store_id" uuid,
    "rider_id" uuid,
    "status" text not null default 'pending'::text,
    "total_amount" numeric(10,2) not null,
    "subtotal" numeric(10,2) not null,
    "delivery_fee" numeric(10,2) default 0,
    "calculated_delivery_fee" numeric(10,2) default 0,
    "distance_km" numeric(5,2),
    "tax_amount" numeric(10,2) default 0,
    "discount_amount" numeric(10,2) default 0,
    "delivery_address" text not null,
    "delivery_latitude" numeric(10,8),
    "delivery_longitude" numeric(11,8),
    "delivery_line_id" text,
    "estimated_delivery_time" timestamp with time zone,
    "actual_delivery_time" timestamp with time zone,
    "payment_method" text default 'cash'::text,
    "payment_status" text default 'pending'::text,
    "bank_account_number" text,
    "bank_account_name" text,
    "qr_code_url" text,
    "transfer_amount" numeric(10,2),
    "transfer_reference" text,
    "transfer_slip_url" text,
    "transfer_confirmed_at" timestamp with time zone,
    "transfer_confirmed_by" uuid,
    "special_instructions" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "bank_name" text,
    "cancellation_reason" text,
    "cancelled_by" uuid,
    "cancelled_at" timestamp with time zone,
    "customer_name" text,
    "customer_phone" text,
    "customer_email" text,
    "customer_line_id" text,
    "discount_code_id" uuid,
    "discount_code" text,
    "discount_description" text,
    "rider_latitude" numeric(10,8),
    "rider_longitude" numeric(11,8),
    "rider_location_captured_at" timestamp with time zone
      );



  create table "public"."payment_history" (
    "id" uuid not null default gen_random_uuid(),
    "order_id" uuid,
    "payment_method" text not null,
    "amount" numeric(10,2) not null,
    "status" text not null,
    "action" text not null,
    "notes" text,
    "processed_by" uuid,
    "processed_at" timestamp with time zone default now(),
    "created_at" timestamp with time zone default now()
      );


alter table "public"."payment_history" enable row level security;


  create table "public"."preorder_delivery_fee_config" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "description" text,
    "base_fee" numeric(10,2) not null default 10,
    "tier_json" jsonb not null,
    "max_delivery_distance" numeric(5,2) default 10,
    "free_delivery_threshold" numeric(10,2) default 0,
    "peak_hour_multiplier" numeric(5,2) default 1,
    "peak_hour_start" time without time zone default '17:00:00'::time without time zone,
    "peak_hour_end" time without time zone default '20:00:00'::time without time zone,
    "is_active" boolean default true,
    "is_default" boolean default true,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."preorder_items" (
    "id" uuid not null default gen_random_uuid(),
    "preorder_order_id" uuid,
    "product_id" uuid,
    "product_name_snapshot" text not null,
    "store_id" uuid,
    "store_name_snapshot" text not null,
    "base_price" numeric(10,2) not null,
    "custom_price" numeric(10,2) not null,
    "qty" integer not null default 1,
    "unit" text default 'ชิ้น'::text,
    "subtotal" numeric(10,2) not null,
    "notes" text,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."preorder_items" enable row level security;


  create table "public"."preorder_orders" (
    "id" uuid not null default gen_random_uuid(),
    "preorder_number" text not null,
    "customer_id" uuid,
    "scheduled_delivery_date" date not null,
    "delivery_window_id" uuid,
    "delivery_address" text not null,
    "delivery_latitude" numeric(10,8),
    "delivery_longitude" numeric(11,8),
    "distance_km" numeric(5,2),
    "subtotal" numeric(10,2) not null,
    "delivery_fee" numeric(10,2) default 0,
    "total_amount" numeric(10,2) not null,
    "required_deposit" numeric(10,2) not null,
    "deposit_status" text default 'pending'::text,
    "deposit_paid_at" timestamp with time zone,
    "balance_collection_method" text default 'on_delivery'::text,
    "balance_fee" numeric(10,2) default 0,
    "status" text default 'pending_deposit'::text,
    "notes" text,
    "base_order_id" uuid,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."preorder_orders" enable row level security;


  create table "public"."preorder_settings" (
    "id" uuid not null default gen_random_uuid(),
    "store_id" uuid,
    "cutoff_time" time without time zone default '20:00:00'::time without time zone,
    "default_deposit_regular" numeric(10,2) default 70,
    "default_deposit_bulk" numeric(10,2) default 100,
    "default_deposit_far" numeric(10,2) default 150,
    "cod_surcharge" numeric(10,2) default 20,
    "require_deposit" boolean default true,
    "is_active" boolean default true,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "deposit_rate_percent" numeric(5,2) default 30
      );


alter table "public"."preorder_settings" enable row level security;


  create table "public"."product_option_values" (
    "id" uuid not null default gen_random_uuid(),
    "option_id" uuid,
    "name" text not null,
    "price_adjustment" numeric(10,2) default 0,
    "is_default" boolean default false,
    "is_available" boolean default true,
    "display_order" integer default 0,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."product_options" (
    "id" uuid not null default gen_random_uuid(),
    "product_id" uuid,
    "name" text not null,
    "description" text,
    "is_required" boolean default false,
    "min_selections" integer default 1,
    "max_selections" integer default 1,
    "display_order" integer default 0,
    "is_active" boolean default true,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."products" (
    "id" uuid not null default gen_random_uuid(),
    "store_id" uuid,
    "name" text not null,
    "description" text,
    "price" numeric(10,2) not null,
    "original_price" numeric(10,2),
    "image_url" text,
    "category" text,
    "subcategory" text,
    "stock_quantity" integer default 0,
    "is_available" boolean default true,
    "is_featured" boolean default false,
    "preparation_time" integer default 15,
    "allergens" text[],
    "nutritional_info" jsonb,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."products" enable row level security;


  create table "public"."rider_assignments" (
    "id" uuid not null default gen_random_uuid(),
    "rider_id" uuid,
    "order_id" uuid,
    "status" text not null default 'assigned'::text,
    "assigned_at" timestamp with time zone default now(),
    "picked_up_at" timestamp with time zone,
    "started_delivery_at" timestamp with time zone,
    "completed_at" timestamp with time zone,
    "cancelled_at" timestamp with time zone,
    "cancellation_reason" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "delivered_at" timestamp with time zone
      );



  create table "public"."rider_documents" (
    "id" uuid not null default gen_random_uuid(),
    "rider_id" uuid,
    "document_type" text not null,
    "file_url" text not null,
    "file_name" text,
    "file_size" integer,
    "mime_type" text,
    "uploaded_at" timestamp with time zone default now(),
    "verified" boolean default false,
    "verified_by" uuid,
    "verified_at" timestamp with time zone,
    "verification_notes" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."rider_documents" enable row level security;


  create table "public"."rider_fcm_tokens" (
    "id" uuid not null default gen_random_uuid(),
    "rider_id" uuid not null,
    "fcm_token" text not null,
    "device_type" text default 'mobile'::text,
    "is_active" boolean default true,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."rider_fcm_tokens" enable row level security;


  create table "public"."rider_order_bookings" (
    "id" uuid not null default gen_random_uuid(),
    "rider_id" uuid not null,
    "order_id" uuid not null,
    "status" text not null default 'booked'::text,
    "priority" integer default 1,
    "booked_at" timestamp with time zone default now(),
    "assigned_at" timestamp with time zone,
    "cancelled_at" timestamp with time zone,
    "expires_at" timestamp with time zone not null,
    "cancellation_reason" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."rider_reviews" (
    "id" uuid not null default gen_random_uuid(),
    "order_id" uuid not null,
    "customer_id" uuid not null,
    "rider_id" uuid not null,
    "rating" numeric(3,2) not null,
    "review_text" text,
    "review_images" text[],
    "is_anonymous" boolean default false,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."rider_reviews" enable row level security;


  create table "public"."riders" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid,
    "vehicle_type" text not null,
    "license_plate" text,
    "vehicle_model" text,
    "vehicle_color" text,
    "current_location" point,
    "is_available" boolean default true,
    "total_deliveries" integer default 0,
    "total_earnings" numeric(10,2) default 0,
    "rating" numeric(3,2) default 0,
    "total_ratings" integer default 0,
    "driver_license_number" text,
    "driver_license_expiry" date,
    "driver_license_type" text,
    "car_tax_expiry" date,
    "insurance_expiry" date,
    "insurance_company" text,
    "documents_verified" boolean default false,
    "verified_by" uuid,
    "verified_at" timestamp with time zone,
    "verification_notes" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "emergency_contact" text,
    "emergency_phone" text,
    "vehicle_brand" text,
    "is_active" boolean default true,
    "bank_account_name" text,
    "bank_account_number" text,
    "bank_name" text,
    "qr_code_url" text
      );



  create table "public"."store_active_orders" (
    "id" uuid not null default gen_random_uuid(),
    "order_number" text not null,
    "customer_id" uuid,
    "store_id" uuid,
    "rider_id" uuid,
    "status" text not null default 'pending'::text,
    "total_amount" numeric(10,2) not null,
    "subtotal" numeric(10,2) not null,
    "delivery_fee" numeric(10,2) default 0,
    "calculated_delivery_fee" numeric(10,2) default 0,
    "distance_km" numeric(5,2),
    "tax_amount" numeric(10,2) default 0,
    "discount_amount" numeric(10,2) default 0,
    "delivery_address" text not null,
    "delivery_latitude" numeric(10,8),
    "delivery_longitude" numeric(11,8),
    "delivery_line_id" text,
    "estimated_delivery_time" timestamp with time zone,
    "actual_delivery_time" timestamp with time zone,
    "payment_method" text default 'cash'::text,
    "payment_status" text default 'pending'::text,
    "bank_account_number" text,
    "bank_account_name" text,
    "qr_code_url" text,
    "transfer_amount" numeric(10,2),
    "transfer_reference" text,
    "transfer_slip_url" text,
    "transfer_confirmed_at" timestamp with time zone,
    "transfer_confirmed_by" uuid,
    "special_instructions" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "bank_name" text,
    "cancellation_reason" text,
    "cancelled_by" uuid,
    "cancelled_at" timestamp with time zone,
    "customer_name" text,
    "customer_phone" text,
    "customer_email" text,
    "customer_line_id" text,
    "discount_code_id" uuid,
    "discount_code" text,
    "discount_description" text,
    "rider_latitude" numeric(10,8),
    "rider_longitude" numeric(11,8),
    "rider_location_captured_at" timestamp with time zone,
    "last_notification_sent_at" timestamp with time zone,
    "notification_retry_count" integer not null default 0,
    "zone_id" uuid
      );



  create table "public"."store_bank_accounts" (
    "id" uuid not null default gen_random_uuid(),
    "store_id" uuid,
    "bank_name" text not null,
    "account_number" text not null,
    "account_name" text not null,
    "account_type" text not null,
    "qr_code_url" text,
    "is_active" boolean default true,
    "is_default" boolean default false,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."store_bank_accounts" enable row level security;


  create table "public"."store_cancellation_requests" (
    "id" uuid not null default gen_random_uuid(),
    "order_id" uuid,
    "store_id" uuid,
    "reason" text not null,
    "description" text,
    "evidence_images" text[],
    "cancellation_type" text not null,
    "status" text not null default 'pending'::text,
    "reviewed_by" uuid,
    "reviewed_at" timestamp with time zone,
    "review_notes" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."store_cancellation_requests" enable row level security;


  create table "public"."store_categories" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "description" text,
    "icon_url" text,
    "is_active" boolean default true,
    "display_order" integer default 0,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."store_reports" (
    "id" uuid not null default gen_random_uuid(),
    "store_id" uuid,
    "reporter_id" uuid,
    "report_type" text not null,
    "title" text not null,
    "description" text not null,
    "evidence_images" text[],
    "severity_level" text not null,
    "status" text not null default 'pending'::text,
    "admin_notes" text,
    "handled_by" uuid,
    "handled_at" timestamp with time zone,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."store_suspension_history" (
    "id" uuid not null default gen_random_uuid(),
    "store_id" uuid,
    "action" text not null,
    "reason" text not null,
    "admin_notes" text,
    "suspended_by" uuid,
    "suspended_at" timestamp with time zone default now(),
    "unsuspended_at" timestamp with time zone,
    "unsuspended_by" uuid,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."stores" (
    "id" uuid not null default gen_random_uuid(),
    "owner_id" uuid,
    "name" text not null,
    "description" text,
    "address" text not null,
    "phone" text,
    "email" text,
    "opening_hours" jsonb,
    "is_active" boolean default true,
    "is_open" boolean default true,
    "is_suspended" boolean default false,
    "suspension_reason" text,
    "suspended_by" uuid,
    "suspended_at" timestamp with time zone,
    "auto_accept_orders" boolean default false,
    "logo_url" text,
    "banner_url" text,
    "latitude" numeric(10,8),
    "longitude" numeric(11,8),
    "delivery_radius" integer default 5000,
    "minimum_order" numeric(10,2) default 0,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "store_type_id" uuid,
    "line_id" text,
    "minimum_order_amount" numeric,
    "phone_number" text,
    "is_auto_open" boolean default false,
    "location" public.geography(Point,4326),
    "code_store" text
      );



  create table "public"."user_task_progress" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null,
    "task_id" uuid not null,
    "progress" integer not null default 0,
    "max_progress" integer not null,
    "is_completed" boolean default false,
    "completed_at" timestamp with time zone,
    "points_awarded" boolean default false,
    "points_awarded_at" timestamp with time zone,
    "reset_period_start" timestamp with time zone default now(),
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."users" (
    "id" uuid not null default gen_random_uuid(),
    "google_id" text,
    "email" text not null,
    "full_name" text not null,
    "avatar_url" text,
    "phone" text,
    "line_id" text,
    "address" text,
    "role" text not null,
    "is_active" boolean default true,
    "email_verified" boolean default true,
    "phone_verified" boolean default false,
    "google_given_name" text,
    "google_family_name" text,
    "google_locale" text,
    "google_picture" text,
    "google_verified_email" boolean default true,
    "last_login_at" timestamp with time zone,
    "login_count" integer default 0,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "latitude" numeric(10,8),
    "longitude" numeric(11,8),
    "date_of_birth" date,
    "age" integer,
    "fcm_token" text,
    "apple_id" text,
    "apple_given_name" text,
    "apple_family_name" text,
    "apple_verified_email" boolean default true
      );


CREATE UNIQUE INDEX admin_activity_logs_pkey ON public.admin_activity_logs USING btree (id);

CREATE UNIQUE INDEX admin_export_logs_pkey ON public.admin_export_logs USING btree (id);

CREATE UNIQUE INDEX admin_login_logs_pkey ON public.admin_login_logs USING btree (id);

CREATE UNIQUE INDEX admin_system_config_logs_pkey ON public.admin_system_config_logs USING btree (id);

CREATE UNIQUE INDEX admin_view_logs_pkey ON public.admin_view_logs USING btree (id);

CREATE UNIQUE INDEX ads_floating_pkey ON public.ads_floating USING btree (id);

CREATE UNIQUE INDEX ads_hotel_pkey ON public.ads_hotel USING btree (id);

CREATE UNIQUE INDEX ads_pkey ON public.ads USING btree (id);

CREATE UNIQUE INDEX app_store_versions_pkey ON public.app_store_versions USING btree (id);

CREATE UNIQUE INDEX app_store_versions_platform_key ON public.app_store_versions USING btree (platform);

CREATE UNIQUE INDEX app_versions_pkey ON public.app_versions USING btree (id);

CREATE UNIQUE INDEX available_jobs_for_workers_pkey ON public.available_jobs_for_workers USING btree (job_posting_id);

CREATE UNIQUE INDEX beauty_booking_status_history_pkey ON public.beauty_booking_status_history USING btree (id);

CREATE UNIQUE INDEX beauty_bookings_booking_number_key ON public.beauty_bookings USING btree (booking_number);

CREATE UNIQUE INDEX beauty_bookings_pkey ON public.beauty_bookings USING btree (id);

CREATE UNIQUE INDEX beauty_notifications_pkey ON public.beauty_notifications USING btree (id);

CREATE UNIQUE INDEX beauty_owner_accounts_email_key ON public.beauty_owner_accounts USING btree (email);

CREATE UNIQUE INDEX beauty_owner_accounts_pkey ON public.beauty_owner_accounts USING btree (id);

CREATE UNIQUE INDEX beauty_reviews_pkey ON public.beauty_reviews USING btree (id);

CREATE UNIQUE INDEX beauty_salons_pkey ON public.beauty_salons USING btree (id);

CREATE UNIQUE INDEX beauty_schedules_pkey ON public.beauty_schedules USING btree (id);

CREATE UNIQUE INDEX beauty_schedules_salon_staff_date_time_unique ON public.beauty_schedules USING btree (salon_id, staff_id, date, time_slot);

CREATE UNIQUE INDEX beauty_services_pkey ON public.beauty_services USING btree (id);

CREATE UNIQUE INDEX beauty_staff_pkey ON public.beauty_staff USING btree (id);

CREATE UNIQUE INDEX cancellation_requests_pkey ON public.cancellation_requests USING btree (id);

CREATE UNIQUE INDEX chat_messages_pkey ON public.chat_messages USING btree (id);

CREATE UNIQUE INDEX community_comment_likes_pkey ON public.community_comment_likes USING btree (id);

CREATE UNIQUE INDEX community_comment_likes_unique ON public.community_comment_likes USING btree (comment_id, user_id);

CREATE UNIQUE INDEX community_comments_pkey ON public.community_comments USING btree (id);

CREATE UNIQUE INDEX community_post_images_pkey ON public.community_post_images USING btree (id);

CREATE UNIQUE INDEX community_post_likes_pkey ON public.community_post_likes USING btree (id);

CREATE UNIQUE INDEX community_post_likes_unique ON public.community_post_likes USING btree (post_id, user_id);

CREATE UNIQUE INDEX community_posts_pkey ON public.community_posts USING btree (id);

CREATE UNIQUE INDEX delivery_fee_config_v2_pkey ON public.delivery_fee_config_v2 USING btree (id);

CREATE UNIQUE INDEX delivery_fee_history_pkey ON public.delivery_fee_history USING btree (id);

CREATE UNIQUE INDEX delivery_fee_settings_pkey ON public.delivery_fee_settings USING btree (id);

CREATE UNIQUE INDEX delivery_fee_tiers_pkey ON public.delivery_fee_tiers USING btree (id);

CREATE UNIQUE INDEX delivery_notes_pkey ON public.delivery_notes USING btree (id);

CREATE UNIQUE INDEX delivery_window_allocations_delivery_date_delivery_window_i_key ON public.delivery_window_allocations USING btree (delivery_date, delivery_window_id);

CREATE UNIQUE INDEX delivery_window_allocations_pkey ON public.delivery_window_allocations USING btree (id);

CREATE UNIQUE INDEX delivery_windows_pkey ON public.delivery_windows USING btree (id);

CREATE UNIQUE INDEX discount_code_usage_pkey ON public.discount_code_usage USING btree (id);

CREATE UNIQUE INDEX discount_codes_code_key ON public.discount_codes USING btree (code);

CREATE UNIQUE INDEX discount_codes_pkey ON public.discount_codes USING btree (id);

CREATE UNIQUE INDEX document_verification_history_pkey ON public.document_verification_history USING btree (id);

CREATE UNIQUE INDEX documents_pkey ON public.documents USING btree (id);

CREATE UNIQUE INDEX fcm_store_pkey ON public.fcm_store USING btree (id);

CREATE UNIQUE INDEX hotel_booking_status_history_pkey ON public.hotel_booking_status_history USING btree (id);

CREATE UNIQUE INDEX hotel_bookings_booking_number_key ON public.hotel_bookings USING btree (booking_number);

CREATE UNIQUE INDEX hotel_bookings_pkey ON public.hotel_bookings USING btree (id);

CREATE UNIQUE INDEX hotel_hourly_availability_pkey ON public.hotel_hourly_availability USING btree (id);

CREATE UNIQUE INDEX hotel_hourly_availability_room_date_unique ON public.hotel_hourly_availability USING btree (room_id, date);

CREATE UNIQUE INDEX hotel_notifications_pkey ON public.hotel_notifications USING btree (id);

CREATE UNIQUE INDEX hotel_owner_accounts_email_key ON public.hotel_owner_accounts USING btree (email);

CREATE UNIQUE INDEX hotel_owner_accounts_pkey ON public.hotel_owner_accounts USING btree (id);

CREATE UNIQUE INDEX hotel_properties_pkey ON public.hotel_properties USING btree (id);

CREATE UNIQUE INDEX hotel_reviews_pkey ON public.hotel_reviews USING btree (id);

CREATE UNIQUE INDEX hotel_room_availability_pkey ON public.hotel_room_availability USING btree (id);

CREATE UNIQUE INDEX hotel_room_availability_room_date_unique ON public.hotel_room_availability USING btree (room_id, date);

CREATE UNIQUE INDEX hotel_room_types_pkey ON public.hotel_room_types USING btree (id);

CREATE UNIQUE INDEX hotel_rooms_pkey ON public.hotel_rooms USING btree (id);

CREATE INDEX idx_ads_date_range ON public.ads USING btree (start_date, end_date);

CREATE INDEX idx_ads_floating_date_range ON public.ads_floating USING btree (start_date, end_date);

CREATE INDEX idx_ads_floating_is_active ON public.ads_floating USING btree (is_active);

CREATE INDEX idx_ads_floating_priority ON public.ads_floating USING btree (priority DESC);

CREATE INDEX idx_ads_floating_product_id ON public.ads_floating USING btree (product_id);

CREATE INDEX idx_ads_floating_store_id ON public.ads_floating USING btree (store_id);

CREATE INDEX idx_ads_hotel_end_date ON public.ads_hotel USING btree (end_date);

CREATE INDEX idx_ads_hotel_hotel_id ON public.ads_hotel USING btree (hotel_id);

CREATE INDEX idx_ads_hotel_is_active ON public.ads_hotel USING btree (is_active);

CREATE INDEX idx_ads_hotel_priority ON public.ads_hotel USING btree (priority);

CREATE INDEX idx_ads_hotel_room_id ON public.ads_hotel USING btree (room_id);

CREATE INDEX idx_ads_hotel_start_date ON public.ads_hotel USING btree (start_date);

CREATE INDEX idx_ads_is_active ON public.ads USING btree (is_active);

CREATE INDEX idx_ads_priority ON public.ads USING btree (priority DESC);

CREATE INDEX idx_ads_product_id ON public.ads USING btree (product_id);

CREATE INDEX idx_ads_store_id ON public.ads USING btree (store_id);

CREATE INDEX idx_app_store_versions_platform ON public.app_store_versions USING btree (platform) WHERE (is_active = true);

CREATE INDEX idx_app_versions_platform_active ON public.app_versions USING btree (platform, is_active);

CREATE INDEX idx_available_jobs_for_workers_category_id ON public.available_jobs_for_workers USING btree (category_id);

CREATE INDEX idx_available_jobs_for_workers_created_at ON public.available_jobs_for_workers USING btree (created_at DESC);

CREATE INDEX idx_available_jobs_for_workers_job_price ON public.available_jobs_for_workers USING btree (job_price);

CREATE INDEX idx_beauty_booking_status_history_booking_id ON public.beauty_booking_status_history USING btree (booking_id);

CREATE INDEX idx_beauty_booking_status_history_status ON public.beauty_booking_status_history USING btree (status);

CREATE INDEX idx_beauty_bookings_booking_date ON public.beauty_bookings USING btree (booking_date);

CREATE INDEX idx_beauty_bookings_booking_number ON public.beauty_bookings USING btree (booking_number);

CREATE INDEX idx_beauty_bookings_booking_status ON public.beauty_bookings USING btree (booking_status);

CREATE INDEX idx_beauty_bookings_booking_time ON public.beauty_bookings USING btree (booking_time);

CREATE INDEX idx_beauty_bookings_customer_email ON public.beauty_bookings USING btree (customer_email);

CREATE INDEX idx_beauty_bookings_payment_status ON public.beauty_bookings USING btree (payment_status);

CREATE INDEX idx_beauty_bookings_salon_id ON public.beauty_bookings USING btree (salon_id);

CREATE INDEX idx_beauty_bookings_service_id ON public.beauty_bookings USING btree (service_id);

CREATE INDEX idx_beauty_bookings_staff_id ON public.beauty_bookings USING btree (staff_id);

CREATE INDEX idx_beauty_notifications_created_at ON public.beauty_notifications USING btree (created_at);

CREATE INDEX idx_beauty_notifications_is_read ON public.beauty_notifications USING btree (is_read);

CREATE INDEX idx_beauty_notifications_salon_id ON public.beauty_notifications USING btree (salon_id);

CREATE INDEX idx_beauty_notifications_user_id ON public.beauty_notifications USING btree (user_id);

CREATE INDEX idx_beauty_owner_accounts_email ON public.beauty_owner_accounts USING btree (email);

CREATE INDEX idx_beauty_owner_accounts_salon_id ON public.beauty_owner_accounts USING btree (salon_id);

CREATE INDEX idx_beauty_reviews_booking_id ON public.beauty_reviews USING btree (booking_id);

CREATE INDEX idx_beauty_reviews_rating ON public.beauty_reviews USING btree (rating);

CREATE INDEX idx_beauty_reviews_salon_id ON public.beauty_reviews USING btree (salon_id);

CREATE INDEX idx_beauty_reviews_staff_id ON public.beauty_reviews USING btree (staff_id);

CREATE INDEX idx_beauty_salons_is_active ON public.beauty_salons USING btree (is_active);

CREATE INDEX idx_beauty_salons_location ON public.beauty_salons USING btree (latitude, longitude);

CREATE INDEX idx_beauty_salons_owner_id ON public.beauty_salons USING btree (owner_id);

CREATE INDEX idx_beauty_salons_verification_status ON public.beauty_salons USING btree (verification_status);

CREATE INDEX idx_beauty_schedules_date ON public.beauty_schedules USING btree (date);

CREATE INDEX idx_beauty_schedules_is_available ON public.beauty_schedules USING btree (is_available);

CREATE INDEX idx_beauty_schedules_salon_id ON public.beauty_schedules USING btree (salon_id);

CREATE INDEX idx_beauty_schedules_staff_id ON public.beauty_schedules USING btree (staff_id);

CREATE INDEX idx_beauty_schedules_time_slot ON public.beauty_schedules USING btree (time_slot);

CREATE INDEX idx_beauty_services_category ON public.beauty_services USING btree (category);

CREATE INDEX idx_beauty_services_is_active ON public.beauty_services USING btree (is_active);

CREATE INDEX idx_beauty_services_is_featured ON public.beauty_services USING btree (is_featured);

CREATE INDEX idx_beauty_services_salon_id ON public.beauty_services USING btree (salon_id);

CREATE INDEX idx_beauty_staff_is_active ON public.beauty_staff USING btree (is_active);

CREATE INDEX idx_beauty_staff_is_verified ON public.beauty_staff USING btree (is_verified);

CREATE INDEX idx_beauty_staff_salon_id ON public.beauty_staff USING btree (salon_id);

CREATE INDEX idx_beauty_staff_user_id ON public.beauty_staff USING btree (user_id);

CREATE INDEX idx_cancellation_requests_assignment_id ON public.cancellation_requests USING btree (assignment_id);

CREATE INDEX idx_cancellation_requests_created_at ON public.cancellation_requests USING btree (created_at);

CREATE INDEX idx_cancellation_requests_emergency_level ON public.cancellation_requests USING btree (emergency_level);

CREATE INDEX idx_cancellation_requests_order_id ON public.cancellation_requests USING btree (order_id);

CREATE INDEX idx_cancellation_requests_rider_id ON public.cancellation_requests USING btree (rider_id);

CREATE INDEX idx_cancellation_requests_status ON public.cancellation_requests USING btree (status);

CREATE INDEX idx_chat_messages_created_at ON public.chat_messages USING btree (created_at);

CREATE INDEX idx_chat_messages_order_id ON public.chat_messages USING btree (order_id);

CREATE INDEX idx_chat_messages_recipient_fcm ON public.chat_messages USING btree (recipient_fcm_token);

CREATE INDEX idx_chat_messages_sender_fcm ON public.chat_messages USING btree (sender_fcm_token);

CREATE INDEX idx_chat_messages_unread ON public.chat_messages USING btree (order_id, is_read) WHERE (is_read = false);

CREATE INDEX idx_checklist_photos_order ON public.order_checklist_photos USING btree (preorder_order_id);

CREATE INDEX idx_community_comment_likes_comment_id ON public.community_comment_likes USING btree (comment_id);

CREATE INDEX idx_community_comment_likes_user_id ON public.community_comment_likes USING btree (user_id);

CREATE INDEX idx_community_comments_created_at ON public.community_comments USING btree (created_at DESC);

CREATE INDEX idx_community_comments_image_path ON public.community_comments USING btree (image_file_path);

CREATE INDEX idx_community_comments_is_active ON public.community_comments USING btree (is_active);

CREATE INDEX idx_community_comments_parent ON public.community_comments USING btree (parent_comment_id);

CREATE INDEX idx_community_comments_post_id ON public.community_comments USING btree (post_id);

CREATE INDEX idx_community_comments_user_id ON public.community_comments USING btree (user_id);

CREATE INDEX idx_community_post_images_file_path ON public.community_post_images USING btree (file_path);

CREATE INDEX idx_community_post_images_order ON public.community_post_images USING btree (post_id, image_order);

CREATE INDEX idx_community_post_images_post_id ON public.community_post_images USING btree (post_id);

CREATE INDEX idx_community_post_likes_post_id ON public.community_post_likes USING btree (post_id);

CREATE INDEX idx_community_post_likes_user_id ON public.community_post_likes USING btree (user_id);

CREATE INDEX idx_community_posts_created_at ON public.community_posts USING btree (created_at DESC);

CREATE INDEX idx_community_posts_is_active ON public.community_posts USING btree (is_active);

CREATE INDEX idx_community_posts_post_type ON public.community_posts USING btree (post_type);

CREATE INDEX idx_community_posts_user_id ON public.community_posts USING btree (user_id);

CREATE INDEX idx_delivery_fee_config_v2_active ON public.delivery_fee_config_v2 USING btree (is_active, is_default);

CREATE INDEX idx_delivery_fee_history_changed_at ON public.delivery_fee_history USING btree (changed_at);

CREATE INDEX idx_delivery_fee_history_changed_by ON public.delivery_fee_history USING btree (changed_by);

CREATE INDEX idx_delivery_fee_history_setting_id ON public.delivery_fee_history USING btree (setting_id);

CREATE INDEX idx_delivery_fee_settings_created_at ON public.delivery_fee_settings USING btree (created_at);

CREATE INDEX idx_delivery_fee_settings_is_active ON public.delivery_fee_settings USING btree (is_active);

CREATE INDEX idx_delivery_fee_settings_is_default ON public.delivery_fee_settings USING btree (is_default);

CREATE INDEX idx_delivery_fee_tiers_config_id ON public.delivery_fee_tiers USING btree (config_id);

CREATE INDEX idx_delivery_fee_tiers_distance ON public.delivery_fee_tiers USING btree (config_id, min_distance, max_distance);

CREATE INDEX idx_delivery_fee_tiers_sort_order ON public.delivery_fee_tiers USING btree (config_id, sort_order);

CREATE INDEX idx_delivery_notes_last_used ON public.delivery_notes USING btree (user_id, last_used_at DESC);

CREATE INDEX idx_delivery_notes_user_favorite ON public.delivery_notes USING btree (user_id, is_favorite);

CREATE INDEX idx_delivery_notes_user_id ON public.delivery_notes USING btree (user_id);

CREATE INDEX idx_delivery_notes_user_usage ON public.delivery_notes USING btree (user_id, usage_count DESC);

CREATE INDEX idx_deposits_preorder ON public.order_deposits USING btree (preorder_order_id);

CREATE INDEX idx_deposits_status ON public.order_deposits USING btree (payment_status);

CREATE INDEX idx_discount_code_usage_discount_code_id ON public.discount_code_usage USING btree (discount_code_id);

CREATE INDEX idx_discount_code_usage_user_id ON public.discount_code_usage USING btree (user_id);

CREATE INDEX idx_discount_codes_active ON public.discount_codes USING btree (is_active);

CREATE INDEX idx_discount_codes_code ON public.discount_codes USING btree (code);

CREATE INDEX idx_discount_codes_valid_period ON public.discount_codes USING btree (valid_from, valid_until);

CREATE INDEX idx_document_verification_history_action ON public.document_verification_history USING btree (action);

CREATE INDEX idx_document_verification_history_created_at ON public.document_verification_history USING btree (created_at);

CREATE INDEX idx_document_verification_history_document_id ON public.document_verification_history USING btree (document_id);

CREATE INDEX idx_document_verification_history_rider_id ON public.document_verification_history USING btree (rider_id);

CREATE INDEX idx_fcm_store_active ON public.fcm_store USING btree (is_active);

CREATE INDEX idx_fcm_store_created_at ON public.fcm_store USING btree (created_at);

CREATE INDEX idx_fcm_store_fcm_token ON public.fcm_store USING btree (fcm_token);

CREATE INDEX idx_fcm_store_last_used ON public.fcm_store USING btree (last_used_at);

CREATE INDEX idx_fcm_store_store_id ON public.fcm_store USING btree (store_id);

CREATE UNIQUE INDEX idx_fcm_store_unique_token ON public.fcm_store USING btree (fcm_token) WHERE (is_active = true);

CREATE INDEX idx_fcm_store_user_id ON public.fcm_store USING btree (user_id);

CREATE INDEX idx_hotel_booking_status_history_booking_id ON public.hotel_booking_status_history USING btree (booking_id);

CREATE INDEX idx_hotel_booking_status_history_status ON public.hotel_booking_status_history USING btree (status);

CREATE INDEX idx_hotel_bookings_booking_number ON public.hotel_bookings USING btree (booking_number);

CREATE INDEX idx_hotel_bookings_booking_status ON public.hotel_bookings USING btree (booking_status);

CREATE INDEX idx_hotel_bookings_booking_type ON public.hotel_bookings USING btree (booking_type);

CREATE INDEX idx_hotel_bookings_check_in_date ON public.hotel_bookings USING btree (check_in_date);

CREATE INDEX idx_hotel_bookings_check_out_date ON public.hotel_bookings USING btree (check_out_date);

CREATE INDEX idx_hotel_bookings_customer_email ON public.hotel_bookings USING btree (customer_email);

CREATE INDEX idx_hotel_bookings_hotel_id ON public.hotel_bookings USING btree (hotel_id);

CREATE INDEX idx_hotel_bookings_payment_status ON public.hotel_bookings USING btree (payment_status);

CREATE INDEX idx_hotel_bookings_room_id ON public.hotel_bookings USING btree (room_id);

CREATE INDEX idx_hotel_hourly_availability_date ON public.hotel_hourly_availability USING btree (date);

CREATE INDEX idx_hotel_hourly_availability_room_id ON public.hotel_hourly_availability USING btree (room_id);

CREATE INDEX idx_hotel_notifications_created_at ON public.hotel_notifications USING btree (created_at);

CREATE INDEX idx_hotel_notifications_hotel_id ON public.hotel_notifications USING btree (hotel_id);

CREATE INDEX idx_hotel_notifications_is_read ON public.hotel_notifications USING btree (is_read);

CREATE INDEX idx_hotel_owner_accounts_email ON public.hotel_owner_accounts USING btree (email);

CREATE INDEX idx_hotel_owner_accounts_hotel_id ON public.hotel_owner_accounts USING btree (hotel_id);

CREATE INDEX idx_hotel_properties_is_active ON public.hotel_properties USING btree (is_active);

CREATE INDEX idx_hotel_properties_location ON public.hotel_properties USING btree (latitude, longitude);

CREATE INDEX idx_hotel_properties_owner_id ON public.hotel_properties USING btree (owner_id);

CREATE INDEX idx_hotel_properties_verification_status ON public.hotel_properties USING btree (verification_status);

CREATE INDEX idx_hotel_reviews_booking_id ON public.hotel_reviews USING btree (booking_id);

CREATE INDEX idx_hotel_reviews_hotel_id ON public.hotel_reviews USING btree (hotel_id);

CREATE INDEX idx_hotel_reviews_rating ON public.hotel_reviews USING btree (rating);

CREATE INDEX idx_hotel_room_availability_date ON public.hotel_room_availability USING btree (date);

CREATE INDEX idx_hotel_room_availability_is_available ON public.hotel_room_availability USING btree (is_available);

CREATE INDEX idx_hotel_room_availability_room_id ON public.hotel_room_availability USING btree (room_id);

CREATE INDEX idx_hotel_room_types_booking_mode ON public.hotel_room_types USING btree (booking_mode);

CREATE INDEX idx_hotel_room_types_hotel_id ON public.hotel_room_types USING btree (hotel_id);

CREATE INDEX idx_hotel_rooms_hotel_id ON public.hotel_rooms USING btree (hotel_id);

CREATE INDEX idx_hotel_rooms_is_available ON public.hotel_rooms USING btree (is_available);

CREATE INDEX idx_hotel_rooms_room_status ON public.hotel_rooms USING btree (room_status);

CREATE INDEX idx_hotel_rooms_room_type_id ON public.hotel_rooms USING btree (room_type_id);

CREATE INDEX idx_job_assignments_completed_at ON public.job_assignments USING btree (completed_at DESC);

CREATE INDEX idx_job_assignments_job_posting_id ON public.job_assignments USING btree (job_posting_id);

CREATE INDEX idx_job_assignments_status ON public.job_assignments USING btree (status);

CREATE INDEX idx_job_assignments_worker_id ON public.job_assignments USING btree (worker_id);

CREATE INDEX idx_job_categories_is_active ON public.job_categories USING btree (is_active);

CREATE INDEX idx_job_categories_name ON public.job_categories USING btree (name);

CREATE INDEX idx_job_company_bank_accounts_display_order ON public.job_company_bank_accounts USING btree (display_order);

CREATE INDEX idx_job_company_bank_accounts_is_active ON public.job_company_bank_accounts USING btree (is_active);

CREATE INDEX idx_job_completion_approvals_approval_status ON public.job_completion_approvals USING btree (approval_status);

CREATE INDEX idx_job_completion_approvals_created_at ON public.job_completion_approvals USING btree (created_at DESC);

CREATE INDEX idx_job_completion_approvals_credit_transferred ON public.job_completion_approvals USING btree (credit_transferred);

CREATE INDEX idx_job_completion_approvals_employer_id ON public.job_completion_approvals USING btree (employer_id);

CREATE INDEX idx_job_completion_approvals_job_assignment_id ON public.job_completion_approvals USING btree (job_assignment_id);

CREATE INDEX idx_job_completion_approvals_job_posting_id ON public.job_completion_approvals USING btree (job_posting_id);

CREATE INDEX idx_job_completion_approvals_worker_id ON public.job_completion_approvals USING btree (worker_id);

CREATE INDEX idx_job_fee_settings_effective_from ON public.job_fee_settings USING btree (effective_from);

CREATE INDEX idx_job_fee_settings_is_active ON public.job_fee_settings USING btree (is_active);

CREATE INDEX idx_job_fee_settings_is_default ON public.job_fee_settings USING btree (is_default);

CREATE INDEX idx_job_postings_category_id ON public.job_postings USING btree (category_id);

CREATE INDEX idx_job_postings_created_at ON public.job_postings USING btree (created_at DESC);

CREATE INDEX idx_job_postings_employer_id ON public.job_postings USING btree (employer_id);

CREATE INDEX idx_job_postings_status ON public.job_postings USING btree (status);

CREATE INDEX idx_job_postings_worker_id ON public.job_postings USING btree (worker_id);

CREATE INDEX idx_job_worker_credit_ledger_created_at ON public.job_worker_credit_ledger USING btree (created_at DESC);

CREATE INDEX idx_job_worker_credit_ledger_job_assignment_id ON public.job_worker_credit_ledger USING btree (job_assignment_id);

CREATE INDEX idx_job_worker_credit_ledger_transaction_type ON public.job_worker_credit_ledger USING btree (transaction_type);

CREATE INDEX idx_job_worker_credit_ledger_worker_id ON public.job_worker_credit_ledger USING btree (worker_id);

CREATE INDEX idx_job_worker_credits_worker_id ON public.job_worker_credits USING btree (worker_id);

CREATE INDEX idx_job_worker_fcm_tokens_fcm_token ON public.job_worker_fcm_tokens USING btree (fcm_token);

CREATE INDEX idx_job_worker_fcm_tokens_is_active ON public.job_worker_fcm_tokens USING btree (is_active);

CREATE INDEX idx_job_worker_fcm_tokens_worker_id ON public.job_worker_fcm_tokens USING btree (worker_id);

CREATE INDEX idx_job_worker_withdrawals_requested_at ON public.job_worker_withdrawals USING btree (requested_at DESC);

CREATE INDEX idx_job_worker_withdrawals_status ON public.job_worker_withdrawals USING btree (status);

CREATE INDEX idx_job_worker_withdrawals_worker_id ON public.job_worker_withdrawals USING btree (worker_id);

CREATE INDEX idx_job_workers_documents_verified ON public.job_workers USING btree (documents_verified);

CREATE INDEX idx_job_workers_is_active ON public.job_workers USING btree (is_active);

CREATE INDEX idx_job_workers_is_available ON public.job_workers USING btree (is_available);

CREATE INDEX idx_job_workers_user_id ON public.job_workers USING btree (user_id);

CREATE INDEX idx_loyalty_point_ledger_created_at ON public.loyalty_point_ledger USING btree (created_at DESC);

CREATE INDEX idx_loyalty_point_ledger_order_id ON public.loyalty_point_ledger USING btree (order_id);

CREATE INDEX idx_loyalty_point_ledger_user_id ON public.loyalty_point_ledger USING btree (user_id);

CREATE INDEX idx_loyalty_tasks_is_active ON public.loyalty_tasks USING btree (is_active);

CREATE INDEX idx_loyalty_tasks_task_type ON public.loyalty_tasks USING btree (task_type);

CREATE INDEX idx_new_order_for_riders_delivery_fee ON public.new_order_for_riders USING btree (delivery_fee);

CREATE INDEX idx_new_order_for_riders_status ON public.new_order_for_riders USING btree (status);

CREATE INDEX idx_new_order_for_riders_store_name ON public.new_order_for_riders USING btree (store_name);

CREATE INDEX idx_notification_logs_created_at ON public.notification_logs USING btree (created_at);

CREATE INDEX idx_notification_logs_order_id ON public.notification_logs USING btree (order_id);

CREATE INDEX idx_notification_logs_trigger_type ON public.notification_logs USING btree (trigger_type);

CREATE INDEX idx_notifications_created_at ON public.notifications USING btree (created_at);

CREATE INDEX idx_notifications_is_read ON public.notifications USING btree (is_read);

CREATE INDEX idx_notifications_type ON public.notifications USING btree (type);

CREATE INDEX idx_notifications_unread ON public.notifications USING btree (user_id, is_read) WHERE (is_read = false);

CREATE INDEX idx_notifications_user_id ON public.notifications USING btree (user_id);

CREATE INDEX idx_notifications_user_type ON public.notifications USING btree (user_id, type);

CREATE INDEX idx_order_discounts_discount_code_id ON public.order_discounts USING btree (discount_code_id);

CREATE INDEX idx_order_discounts_order_id ON public.order_discounts USING btree (order_id);

CREATE INDEX idx_order_item_options_option_id ON public.order_item_options USING btree (option_id);

CREATE INDEX idx_order_item_options_order_item_id ON public.order_item_options USING btree (order_item_id);

CREATE INDEX idx_order_items_order_id ON public.order_items USING btree (order_id);

CREATE INDEX idx_order_items_product_id ON public.order_items USING btree (product_id);

CREATE INDEX idx_order_reviews_created_at ON public.order_reviews USING btree (created_at);

CREATE INDEX idx_order_reviews_customer_id ON public.order_reviews USING btree (customer_id);

CREATE INDEX idx_order_reviews_order_id ON public.order_reviews USING btree (order_id);

CREATE INDEX idx_order_reviews_rating ON public.order_reviews USING btree (rating);

CREATE INDEX idx_order_reviews_store_id ON public.order_reviews USING btree (store_id);

CREATE INDEX idx_order_rider_locations_order ON public.order_rider_locations USING btree (order_id, recorded_at DESC);

CREATE INDEX idx_order_rider_locations_rider_time ON public.order_rider_locations USING btree (rider_id, recorded_at DESC);

CREATE INDEX idx_order_status_history_created_at ON public.order_status_history USING btree (created_at);

CREATE INDEX idx_order_status_history_order_id ON public.order_status_history USING btree (order_id);

CREATE INDEX idx_orders_bank_name ON public.orders USING btree (bank_name);

CREATE INDEX idx_orders_calculated_delivery_fee ON public.orders USING btree (calculated_delivery_fee);

CREATE INDEX idx_orders_cancellation_reason ON public.orders USING btree (cancellation_reason);

CREATE INDEX idx_orders_cancelled_at ON public.orders USING btree (cancelled_at);

CREATE INDEX idx_orders_cancelled_by ON public.orders USING btree (cancelled_by);

CREATE INDEX idx_orders_created_at ON public.orders USING btree (created_at);

CREATE INDEX idx_orders_customer_email ON public.orders USING btree (customer_email);

CREATE INDEX idx_orders_customer_id ON public.orders USING btree (customer_id);

CREATE INDEX idx_orders_customer_name ON public.orders USING btree (customer_name);

CREATE INDEX idx_orders_customer_phone ON public.orders USING btree (customer_phone);

CREATE INDEX idx_orders_customer_store_active ON public.orders USING btree (customer_id, store_id) WHERE ((status <> 'cancelled'::text) AND (status <> 'rejected'::text));

CREATE INDEX idx_orders_discount_code_id ON public.orders USING btree (discount_code_id);

CREATE INDEX idx_orders_distance_km ON public.orders USING btree (distance_km);

CREATE INDEX idx_orders_order_number ON public.orders USING btree (order_number);

CREATE INDEX idx_orders_payment_method ON public.orders USING btree (payment_method);

CREATE INDEX idx_orders_payment_status ON public.orders USING btree (payment_status);

CREATE INDEX idx_orders_ready_for_delivery ON public.orders USING btree (status, rider_id) WHERE ((status = 'ready'::text) AND (rider_id IS NULL));

CREATE INDEX idx_orders_rider_id ON public.orders USING btree (rider_id);

CREATE INDEX idx_orders_status ON public.orders USING btree (status);

CREATE INDEX idx_orders_status_rider_id ON public.orders USING btree (status, rider_id) WHERE (rider_id IS NULL);

CREATE INDEX idx_orders_store_id ON public.orders USING btree (store_id);

CREATE INDEX idx_orders_transfer_confirmed_at ON public.orders USING btree (transfer_confirmed_at);

CREATE INDEX idx_payment_history_created_at ON public.payment_history USING btree (created_at);

CREATE INDEX idx_payment_history_order_id ON public.payment_history USING btree (order_id);

CREATE INDEX idx_payment_history_payment_method ON public.payment_history USING btree (payment_method);

CREATE INDEX idx_payment_history_status ON public.payment_history USING btree (status);

CREATE INDEX idx_preorder_customer ON public.preorder_orders USING btree (customer_id);

CREATE INDEX idx_preorder_delivery_date ON public.preorder_orders USING btree (scheduled_delivery_date);

CREATE UNIQUE INDEX idx_preorder_fee_default ON public.preorder_delivery_fee_config USING btree (is_default) WHERE (is_default = true);

CREATE INDEX idx_preorder_items_order ON public.preorder_items USING btree (preorder_order_id);

CREATE INDEX idx_preorder_items_store ON public.preorder_items USING btree (store_id);

CREATE INDEX idx_preorder_settings_store ON public.preorder_settings USING btree (store_id);

CREATE INDEX idx_preorder_status ON public.preorder_orders USING btree (status);

CREATE INDEX idx_preorder_window ON public.preorder_orders USING btree (delivery_window_id);

CREATE INDEX idx_product_option_values_display_order ON public.product_option_values USING btree (display_order);

CREATE INDEX idx_product_option_values_is_available ON public.product_option_values USING btree (is_available);

CREATE INDEX idx_product_option_values_option_id ON public.product_option_values USING btree (option_id);

CREATE INDEX idx_product_options_display_order ON public.product_options USING btree (display_order);

CREATE INDEX idx_product_options_is_active ON public.product_options USING btree (is_active);

CREATE INDEX idx_product_options_product_id ON public.product_options USING btree (product_id);

CREATE INDEX idx_products_category ON public.products USING btree (category);

CREATE INDEX idx_products_is_available ON public.products USING btree (is_available);

CREATE INDEX idx_products_store_id ON public.products USING btree (store_id);

CREATE INDEX idx_rider_assignments_active ON public.rider_assignments USING btree (rider_id, status) WHERE (status = ANY (ARRAY['assigned'::text, 'picked_up'::text, 'delivering'::text]));

CREATE INDEX idx_rider_assignments_assigned_at ON public.rider_assignments USING btree (assigned_at);

CREATE INDEX idx_rider_assignments_order_id ON public.rider_assignments USING btree (order_id);

CREATE INDEX idx_rider_assignments_order_status ON public.rider_assignments USING btree (order_id, status);

CREATE INDEX idx_rider_assignments_rider_id ON public.rider_assignments USING btree (rider_id);

CREATE INDEX idx_rider_assignments_rider_status ON public.rider_assignments USING btree (rider_id, status);

CREATE INDEX idx_rider_assignments_status ON public.rider_assignments USING btree (status);

CREATE INDEX idx_rider_documents_document_type ON public.rider_documents USING btree (document_type);

CREATE INDEX idx_rider_documents_rider_id ON public.rider_documents USING btree (rider_id);

CREATE INDEX idx_rider_documents_uploaded_at ON public.rider_documents USING btree (uploaded_at);

CREATE INDEX idx_rider_documents_verified ON public.rider_documents USING btree (verified);

CREATE INDEX idx_rider_fcm_tokens_active ON public.rider_fcm_tokens USING btree (is_active);

CREATE INDEX idx_rider_fcm_tokens_fcm_token ON public.rider_fcm_tokens USING btree (fcm_token);

CREATE INDEX idx_rider_fcm_tokens_rider_id ON public.rider_fcm_tokens USING btree (rider_id);

CREATE INDEX idx_rider_order_bookings_expires_at ON public.rider_order_bookings USING btree (expires_at);

CREATE INDEX idx_rider_order_bookings_order_id ON public.rider_order_bookings USING btree (order_id);

CREATE INDEX idx_rider_order_bookings_priority ON public.rider_order_bookings USING btree (priority);

CREATE INDEX idx_rider_order_bookings_rider_id ON public.rider_order_bookings USING btree (rider_id);

CREATE INDEX idx_rider_order_bookings_status ON public.rider_order_bookings USING btree (status);

CREATE INDEX idx_rider_reviews_created_at ON public.rider_reviews USING btree (created_at);

CREATE INDEX idx_rider_reviews_customer_id ON public.rider_reviews USING btree (customer_id);

CREATE INDEX idx_rider_reviews_order_id ON public.rider_reviews USING btree (order_id);

CREATE INDEX idx_rider_reviews_rating ON public.rider_reviews USING btree (rating);

CREATE INDEX idx_rider_reviews_rider_id ON public.rider_reviews USING btree (rider_id);

CREATE INDEX idx_riders_car_tax_expiry ON public.riders USING btree (car_tax_expiry);

CREATE INDEX idx_riders_current_location ON public.riders USING gist (current_location);

CREATE INDEX idx_riders_documents_verified ON public.riders USING btree (documents_verified);

CREATE INDEX idx_riders_driver_license_expiry ON public.riders USING btree (driver_license_expiry);

CREATE INDEX idx_riders_insurance_expiry ON public.riders USING btree (insurance_expiry);

CREATE INDEX idx_riders_is_available ON public.riders USING btree (is_available);

CREATE INDEX idx_riders_user_id ON public.riders USING btree (user_id);

CREATE INDEX idx_store_active_orders_zone_id ON public.store_active_orders USING btree (zone_id);

CREATE INDEX idx_store_bank_accounts_is_active ON public.store_bank_accounts USING btree (is_active);

CREATE INDEX idx_store_bank_accounts_is_default ON public.store_bank_accounts USING btree (is_default);

CREATE INDEX idx_store_bank_accounts_store_id ON public.store_bank_accounts USING btree (store_id);

CREATE INDEX idx_store_cancellation_requests_cancellation_type ON public.store_cancellation_requests USING btree (cancellation_type);

CREATE INDEX idx_store_cancellation_requests_created_at ON public.store_cancellation_requests USING btree (created_at);

CREATE INDEX idx_store_cancellation_requests_order_id ON public.store_cancellation_requests USING btree (order_id);

CREATE INDEX idx_store_cancellation_requests_status ON public.store_cancellation_requests USING btree (status);

CREATE INDEX idx_store_cancellation_requests_store_id ON public.store_cancellation_requests USING btree (store_id);

CREATE INDEX idx_store_reports_created_at ON public.store_reports USING btree (created_at);

CREATE INDEX idx_store_reports_report_type ON public.store_reports USING btree (report_type);

CREATE INDEX idx_store_reports_reporter_id ON public.store_reports USING btree (reporter_id);

CREATE INDEX idx_store_reports_severity_level ON public.store_reports USING btree (severity_level);

CREATE INDEX idx_store_reports_status ON public.store_reports USING btree (status);

CREATE INDEX idx_store_reports_store_id ON public.store_reports USING btree (store_id);

CREATE INDEX idx_store_suspension_history_action ON public.store_suspension_history USING btree (action);

CREATE INDEX idx_store_suspension_history_store_id ON public.store_suspension_history USING btree (store_id);

CREATE INDEX idx_store_suspension_history_suspended_at ON public.store_suspension_history USING btree (suspended_at);

CREATE INDEX idx_store_suspension_history_suspended_by ON public.store_suspension_history USING btree (suspended_by);

CREATE INDEX idx_stores_code_store ON public.stores USING btree (code_store);

CREATE INDEX idx_stores_is_active ON public.stores USING btree (is_active);

CREATE INDEX idx_stores_is_suspended ON public.stores USING btree (is_suspended);

CREATE INDEX idx_stores_location ON public.stores USING btree (latitude, longitude);

CREATE INDEX idx_stores_owner_id ON public.stores USING btree (owner_id);

CREATE INDEX idx_stores_store_type_id ON public.stores USING btree (store_type_id);

CREATE INDEX idx_stores_suspended_at ON public.stores USING btree (suspended_at);

CREATE INDEX idx_stores_suspended_by ON public.stores USING btree (suspended_by);

CREATE INDEX idx_user_task_progress_reset_period ON public.user_task_progress USING btree (user_id, task_id, reset_period_start);

CREATE INDEX idx_user_task_progress_task_id ON public.user_task_progress USING btree (task_id);

CREATE INDEX idx_user_task_progress_user_id ON public.user_task_progress USING btree (user_id);

CREATE INDEX idx_users_apple_id ON public.users USING btree (apple_id);

CREATE INDEX idx_users_created_at ON public.users USING btree (created_at);

CREATE INDEX idx_users_email ON public.users USING btree (email);

CREATE INDEX idx_users_fcm_token ON public.users USING btree (fcm_token) WHERE (fcm_token IS NOT NULL);

CREATE INDEX idx_users_google_id ON public.users USING btree (google_id);

CREATE INDEX idx_users_has_location ON public.users USING btree (latitude, longitude) WHERE ((latitude IS NOT NULL) AND (longitude IS NOT NULL));

CREATE INDEX idx_users_last_login_at ON public.users USING btree (last_login_at);

CREATE INDEX idx_users_line_id ON public.users USING btree (line_id);

CREATE INDEX idx_users_location ON public.users USING btree (latitude, longitude);

CREATE INDEX idx_users_phone ON public.users USING btree (phone);

CREATE INDEX idx_users_role ON public.users USING btree (role);

CREATE INDEX idx_window_allocations_date ON public.delivery_window_allocations USING btree (delivery_date);

CREATE INDEX idx_window_allocations_window ON public.delivery_window_allocations USING btree (delivery_window_id);

CREATE UNIQUE INDEX job_assignments_pkey ON public.job_assignments USING btree (id);

CREATE UNIQUE INDEX job_categories_name_key ON public.job_categories USING btree (name);

CREATE UNIQUE INDEX job_categories_pkey ON public.job_categories USING btree (id);

CREATE UNIQUE INDEX job_company_bank_accounts_pkey ON public.job_company_bank_accounts USING btree (id);

CREATE UNIQUE INDEX job_completion_approvals_pkey ON public.job_completion_approvals USING btree (id);

CREATE UNIQUE INDEX job_fee_settings_pkey ON public.job_fee_settings USING btree (id);

CREATE UNIQUE INDEX job_postings_job_number_key ON public.job_postings USING btree (job_number);

CREATE UNIQUE INDEX job_postings_pkey ON public.job_postings USING btree (id);

CREATE UNIQUE INDEX job_worker_credit_ledger_pkey ON public.job_worker_credit_ledger USING btree (id);

CREATE UNIQUE INDEX job_worker_credits_pkey ON public.job_worker_credits USING btree (id);

CREATE UNIQUE INDEX job_worker_credits_worker_id_key ON public.job_worker_credits USING btree (worker_id);

CREATE UNIQUE INDEX job_worker_fcm_tokens_pkey ON public.job_worker_fcm_tokens USING btree (id);

CREATE UNIQUE INDEX job_worker_fcm_tokens_worker_id_fcm_token_key ON public.job_worker_fcm_tokens USING btree (worker_id, fcm_token);

CREATE UNIQUE INDEX job_worker_withdrawals_pkey ON public.job_worker_withdrawals USING btree (id);

CREATE UNIQUE INDEX job_workers_pkey ON public.job_workers USING btree (id);

CREATE UNIQUE INDEX job_workers_user_id_key ON public.job_workers USING btree (user_id);

CREATE UNIQUE INDEX loyalty_point_ledger_order_id_reason_code_key ON public.loyalty_point_ledger USING btree (order_id, reason_code);

CREATE UNIQUE INDEX loyalty_point_ledger_pkey ON public.loyalty_point_ledger USING btree (id);

CREATE UNIQUE INDEX loyalty_point_rules_pkey ON public.loyalty_point_rules USING btree (id);

CREATE UNIQUE INDEX loyalty_point_rules_rule_code_key ON public.loyalty_point_rules USING btree (rule_code);

CREATE UNIQUE INDEX loyalty_redemption_rules_pkey ON public.loyalty_redemption_rules USING btree (id);

CREATE UNIQUE INDEX loyalty_redemption_rules_rule_code_key ON public.loyalty_redemption_rules USING btree (rule_code);

CREATE UNIQUE INDEX loyalty_tasks_pkey ON public.loyalty_tasks USING btree (id);

CREATE UNIQUE INDEX loyalty_tasks_task_code_key ON public.loyalty_tasks USING btree (task_code);

CREATE UNIQUE INDEX new_order_for_riders_pkey ON public.new_order_for_riders USING btree (order_id);

CREATE UNIQUE INDEX notification_logs_pkey ON public.notification_logs USING btree (id);

CREATE UNIQUE INDEX notifications_pkey ON public.notifications USING btree (id);

CREATE UNIQUE INDEX order_checklist_photos_pkey ON public.order_checklist_photos USING btree (id);

CREATE UNIQUE INDEX order_deposits_pkey ON public.order_deposits USING btree (id);

CREATE UNIQUE INDEX order_discounts_pkey ON public.order_discounts USING btree (id);

CREATE UNIQUE INDEX order_item_options_pkey ON public.order_item_options USING btree (id);

CREATE UNIQUE INDEX order_items_pkey ON public.order_items USING btree (id);

CREATE UNIQUE INDEX order_reviews_pkey ON public.order_reviews USING btree (id);

CREATE UNIQUE INDEX order_reviews_unique_order ON public.order_reviews USING btree (order_id);

CREATE UNIQUE INDEX order_rider_locations_pkey ON public.order_rider_locations USING btree (id);

CREATE UNIQUE INDEX order_status_history_pkey ON public.order_status_history USING btree (id);

CREATE UNIQUE INDEX orders_order_number_key ON public.orders USING btree (order_number);

CREATE UNIQUE INDEX orders_order_number_unique ON public.orders USING btree (order_number);

CREATE UNIQUE INDEX orders_pkey ON public.orders USING btree (id);

CREATE UNIQUE INDEX payment_history_pkey ON public.payment_history USING btree (id);

CREATE UNIQUE INDEX preorder_delivery_fee_config_pkey ON public.preorder_delivery_fee_config USING btree (id);

CREATE UNIQUE INDEX preorder_items_pkey ON public.preorder_items USING btree (id);

CREATE UNIQUE INDEX preorder_orders_pkey ON public.preorder_orders USING btree (id);

CREATE UNIQUE INDEX preorder_orders_preorder_number_key ON public.preorder_orders USING btree (preorder_number);

CREATE UNIQUE INDEX preorder_settings_pkey ON public.preorder_settings USING btree (id);

CREATE UNIQUE INDEX product_option_values_pkey ON public.product_option_values USING btree (id);

CREATE UNIQUE INDEX product_options_pkey ON public.product_options USING btree (id);

CREATE UNIQUE INDEX products_pkey ON public.products USING btree (id);

CREATE UNIQUE INDEX rider_assignments_pkey ON public.rider_assignments USING btree (id);

CREATE UNIQUE INDEX rider_assignments_rider_id_order_id_key ON public.rider_assignments USING btree (rider_id, order_id);

CREATE UNIQUE INDEX rider_documents_pkey ON public.rider_documents USING btree (id);

CREATE UNIQUE INDEX rider_fcm_tokens_pkey ON public.rider_fcm_tokens USING btree (id);

CREATE UNIQUE INDEX rider_fcm_tokens_rider_id_fcm_token_key ON public.rider_fcm_tokens USING btree (rider_id, fcm_token);

CREATE UNIQUE INDEX rider_order_bookings_pkey ON public.rider_order_bookings USING btree (id);

CREATE UNIQUE INDEX rider_order_bookings_rider_id_order_id_key ON public.rider_order_bookings USING btree (rider_id, order_id);

CREATE UNIQUE INDEX rider_reviews_order_unique ON public.rider_reviews USING btree (order_id);

CREATE UNIQUE INDEX rider_reviews_pkey ON public.rider_reviews USING btree (id);

CREATE UNIQUE INDEX riders_pkey ON public.riders USING btree (id);

CREATE INDEX store_active_orders_bank_name_idx ON public.store_active_orders USING btree (bank_name);

CREATE INDEX store_active_orders_calculated_delivery_fee_idx ON public.store_active_orders USING btree (calculated_delivery_fee);

CREATE INDEX store_active_orders_cancellation_reason_idx ON public.store_active_orders USING btree (cancellation_reason);

CREATE INDEX store_active_orders_cancelled_at_idx ON public.store_active_orders USING btree (cancelled_at);

CREATE INDEX store_active_orders_cancelled_by_idx ON public.store_active_orders USING btree (cancelled_by);

CREATE INDEX store_active_orders_created_at_idx ON public.store_active_orders USING btree (created_at);

CREATE INDEX store_active_orders_customer_email_idx ON public.store_active_orders USING btree (customer_email);

CREATE INDEX store_active_orders_customer_id_idx ON public.store_active_orders USING btree (customer_id);

CREATE INDEX store_active_orders_customer_id_store_id_idx ON public.store_active_orders USING btree (customer_id, store_id) WHERE ((status <> 'cancelled'::text) AND (status <> 'rejected'::text));

CREATE INDEX store_active_orders_customer_name_idx ON public.store_active_orders USING btree (customer_name);

CREATE INDEX store_active_orders_customer_phone_idx ON public.store_active_orders USING btree (customer_phone);

CREATE INDEX store_active_orders_discount_code_id_idx ON public.store_active_orders USING btree (discount_code_id);

CREATE INDEX store_active_orders_distance_km_idx ON public.store_active_orders USING btree (distance_km);

CREATE INDEX store_active_orders_never_notified_idx ON public.store_active_orders USING btree (created_at) WHERE ((status = 'pending'::text) AND (last_notification_sent_at IS NULL));

CREATE INDEX store_active_orders_order_number_idx ON public.store_active_orders USING btree (order_number);

CREATE UNIQUE INDEX store_active_orders_order_number_key ON public.store_active_orders USING btree (order_number);

CREATE UNIQUE INDEX store_active_orders_order_number_key1 ON public.store_active_orders USING btree (order_number);

CREATE INDEX store_active_orders_payment_method_idx ON public.store_active_orders USING btree (payment_method);

CREATE INDEX store_active_orders_payment_status_idx ON public.store_active_orders USING btree (payment_status);

CREATE INDEX store_active_orders_pending_notification_idx ON public.store_active_orders USING btree (last_notification_sent_at, created_at) WHERE (status = 'pending'::text);

CREATE UNIQUE INDEX store_active_orders_pkey ON public.store_active_orders USING btree (id);

CREATE INDEX store_active_orders_rider_id_idx ON public.store_active_orders USING btree (rider_id);

CREATE INDEX store_active_orders_status_idx ON public.store_active_orders USING btree (status);

CREATE INDEX store_active_orders_status_rider_id_idx ON public.store_active_orders USING btree (status, rider_id) WHERE ((status = 'ready'::text) AND (rider_id IS NULL));

CREATE INDEX store_active_orders_status_rider_id_idx1 ON public.store_active_orders USING btree (status, rider_id) WHERE (rider_id IS NULL);

CREATE INDEX store_active_orders_store_id_idx ON public.store_active_orders USING btree (store_id);

CREATE INDEX store_active_orders_transfer_confirmed_at_idx ON public.store_active_orders USING btree (transfer_confirmed_at);

CREATE UNIQUE INDEX store_bank_accounts_pkey ON public.store_bank_accounts USING btree (id);

CREATE UNIQUE INDEX store_cancellation_requests_pkey ON public.store_cancellation_requests USING btree (id);

CREATE UNIQUE INDEX store_categories_pkey ON public.store_categories USING btree (id);

CREATE UNIQUE INDEX store_reports_pkey ON public.store_reports USING btree (id);

CREATE UNIQUE INDEX store_suspension_history_pkey ON public.store_suspension_history USING btree (id);

CREATE UNIQUE INDEX stores_code_store_key ON public.stores USING btree (code_store);

CREATE INDEX stores_location_idx ON public.stores USING gist (location);

CREATE UNIQUE INDEX stores_pkey ON public.stores USING btree (id);

CREATE UNIQUE INDEX user_task_progress_pkey ON public.user_task_progress USING btree (id);

CREATE UNIQUE INDEX user_task_progress_user_id_task_id_reset_period_start_key ON public.user_task_progress USING btree (user_id, task_id, reset_period_start);

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);

CREATE UNIQUE INDEX users_google_id_key ON public.users USING btree (google_id);

CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id);

alter table "public"."admin_activity_logs" add constraint "admin_activity_logs_pkey" PRIMARY KEY using index "admin_activity_logs_pkey";

alter table "public"."admin_export_logs" add constraint "admin_export_logs_pkey" PRIMARY KEY using index "admin_export_logs_pkey";

alter table "public"."admin_login_logs" add constraint "admin_login_logs_pkey" PRIMARY KEY using index "admin_login_logs_pkey";

alter table "public"."admin_system_config_logs" add constraint "admin_system_config_logs_pkey" PRIMARY KEY using index "admin_system_config_logs_pkey";

alter table "public"."admin_view_logs" add constraint "admin_view_logs_pkey" PRIMARY KEY using index "admin_view_logs_pkey";

alter table "public"."ads" add constraint "ads_pkey" PRIMARY KEY using index "ads_pkey";

alter table "public"."ads_floating" add constraint "ads_floating_pkey" PRIMARY KEY using index "ads_floating_pkey";

alter table "public"."ads_hotel" add constraint "ads_hotel_pkey" PRIMARY KEY using index "ads_hotel_pkey";

alter table "public"."app_store_versions" add constraint "app_store_versions_pkey" PRIMARY KEY using index "app_store_versions_pkey";

alter table "public"."app_versions" add constraint "app_versions_pkey" PRIMARY KEY using index "app_versions_pkey";

alter table "public"."available_jobs_for_workers" add constraint "available_jobs_for_workers_pkey" PRIMARY KEY using index "available_jobs_for_workers_pkey";

alter table "public"."beauty_booking_status_history" add constraint "beauty_booking_status_history_pkey" PRIMARY KEY using index "beauty_booking_status_history_pkey";

alter table "public"."beauty_bookings" add constraint "beauty_bookings_pkey" PRIMARY KEY using index "beauty_bookings_pkey";

alter table "public"."beauty_notifications" add constraint "beauty_notifications_pkey" PRIMARY KEY using index "beauty_notifications_pkey";

alter table "public"."beauty_owner_accounts" add constraint "beauty_owner_accounts_pkey" PRIMARY KEY using index "beauty_owner_accounts_pkey";

alter table "public"."beauty_reviews" add constraint "beauty_reviews_pkey" PRIMARY KEY using index "beauty_reviews_pkey";

alter table "public"."beauty_salons" add constraint "beauty_salons_pkey" PRIMARY KEY using index "beauty_salons_pkey";

alter table "public"."beauty_schedules" add constraint "beauty_schedules_pkey" PRIMARY KEY using index "beauty_schedules_pkey";

alter table "public"."beauty_services" add constraint "beauty_services_pkey" PRIMARY KEY using index "beauty_services_pkey";

alter table "public"."beauty_staff" add constraint "beauty_staff_pkey" PRIMARY KEY using index "beauty_staff_pkey";

alter table "public"."cancellation_requests" add constraint "cancellation_requests_pkey" PRIMARY KEY using index "cancellation_requests_pkey";

alter table "public"."chat_messages" add constraint "chat_messages_pkey" PRIMARY KEY using index "chat_messages_pkey";

alter table "public"."community_comment_likes" add constraint "community_comment_likes_pkey" PRIMARY KEY using index "community_comment_likes_pkey";

alter table "public"."community_comments" add constraint "community_comments_pkey" PRIMARY KEY using index "community_comments_pkey";

alter table "public"."community_post_images" add constraint "community_post_images_pkey" PRIMARY KEY using index "community_post_images_pkey";

alter table "public"."community_post_likes" add constraint "community_post_likes_pkey" PRIMARY KEY using index "community_post_likes_pkey";

alter table "public"."community_posts" add constraint "community_posts_pkey" PRIMARY KEY using index "community_posts_pkey";

alter table "public"."delivery_fee_config_v2" add constraint "delivery_fee_config_v2_pkey" PRIMARY KEY using index "delivery_fee_config_v2_pkey";

alter table "public"."delivery_fee_history" add constraint "delivery_fee_history_pkey" PRIMARY KEY using index "delivery_fee_history_pkey";

alter table "public"."delivery_fee_settings" add constraint "delivery_fee_settings_pkey" PRIMARY KEY using index "delivery_fee_settings_pkey";

alter table "public"."delivery_fee_tiers" add constraint "delivery_fee_tiers_pkey" PRIMARY KEY using index "delivery_fee_tiers_pkey";

alter table "public"."delivery_notes" add constraint "delivery_notes_pkey" PRIMARY KEY using index "delivery_notes_pkey";

alter table "public"."delivery_window_allocations" add constraint "delivery_window_allocations_pkey" PRIMARY KEY using index "delivery_window_allocations_pkey";

alter table "public"."delivery_windows" add constraint "delivery_windows_pkey" PRIMARY KEY using index "delivery_windows_pkey";

alter table "public"."discount_code_usage" add constraint "discount_code_usage_pkey" PRIMARY KEY using index "discount_code_usage_pkey";

alter table "public"."discount_codes" add constraint "discount_codes_pkey" PRIMARY KEY using index "discount_codes_pkey";

alter table "public"."document_verification_history" add constraint "document_verification_history_pkey" PRIMARY KEY using index "document_verification_history_pkey";

alter table "public"."documents" add constraint "documents_pkey" PRIMARY KEY using index "documents_pkey";

alter table "public"."fcm_store" add constraint "fcm_store_pkey" PRIMARY KEY using index "fcm_store_pkey";

alter table "public"."hotel_booking_status_history" add constraint "hotel_booking_status_history_pkey" PRIMARY KEY using index "hotel_booking_status_history_pkey";

alter table "public"."hotel_bookings" add constraint "hotel_bookings_pkey" PRIMARY KEY using index "hotel_bookings_pkey";

alter table "public"."hotel_hourly_availability" add constraint "hotel_hourly_availability_pkey" PRIMARY KEY using index "hotel_hourly_availability_pkey";

alter table "public"."hotel_notifications" add constraint "hotel_notifications_pkey" PRIMARY KEY using index "hotel_notifications_pkey";

alter table "public"."hotel_owner_accounts" add constraint "hotel_owner_accounts_pkey" PRIMARY KEY using index "hotel_owner_accounts_pkey";

alter table "public"."hotel_properties" add constraint "hotel_properties_pkey" PRIMARY KEY using index "hotel_properties_pkey";

alter table "public"."hotel_reviews" add constraint "hotel_reviews_pkey" PRIMARY KEY using index "hotel_reviews_pkey";

alter table "public"."hotel_room_availability" add constraint "hotel_room_availability_pkey" PRIMARY KEY using index "hotel_room_availability_pkey";

alter table "public"."hotel_room_types" add constraint "hotel_room_types_pkey" PRIMARY KEY using index "hotel_room_types_pkey";

alter table "public"."hotel_rooms" add constraint "hotel_rooms_pkey" PRIMARY KEY using index "hotel_rooms_pkey";

alter table "public"."job_assignments" add constraint "job_assignments_pkey" PRIMARY KEY using index "job_assignments_pkey";

alter table "public"."job_categories" add constraint "job_categories_pkey" PRIMARY KEY using index "job_categories_pkey";

alter table "public"."job_company_bank_accounts" add constraint "job_company_bank_accounts_pkey" PRIMARY KEY using index "job_company_bank_accounts_pkey";

alter table "public"."job_completion_approvals" add constraint "job_completion_approvals_pkey" PRIMARY KEY using index "job_completion_approvals_pkey";

alter table "public"."job_fee_settings" add constraint "job_fee_settings_pkey" PRIMARY KEY using index "job_fee_settings_pkey";

alter table "public"."job_postings" add constraint "job_postings_pkey" PRIMARY KEY using index "job_postings_pkey";

alter table "public"."job_worker_credit_ledger" add constraint "job_worker_credit_ledger_pkey" PRIMARY KEY using index "job_worker_credit_ledger_pkey";

alter table "public"."job_worker_credits" add constraint "job_worker_credits_pkey" PRIMARY KEY using index "job_worker_credits_pkey";

alter table "public"."job_worker_fcm_tokens" add constraint "job_worker_fcm_tokens_pkey" PRIMARY KEY using index "job_worker_fcm_tokens_pkey";

alter table "public"."job_worker_withdrawals" add constraint "job_worker_withdrawals_pkey" PRIMARY KEY using index "job_worker_withdrawals_pkey";

alter table "public"."job_workers" add constraint "job_workers_pkey" PRIMARY KEY using index "job_workers_pkey";

alter table "public"."loyalty_point_ledger" add constraint "loyalty_point_ledger_pkey" PRIMARY KEY using index "loyalty_point_ledger_pkey";

alter table "public"."loyalty_point_rules" add constraint "loyalty_point_rules_pkey" PRIMARY KEY using index "loyalty_point_rules_pkey";

alter table "public"."loyalty_redemption_rules" add constraint "loyalty_redemption_rules_pkey" PRIMARY KEY using index "loyalty_redemption_rules_pkey";

alter table "public"."loyalty_tasks" add constraint "loyalty_tasks_pkey" PRIMARY KEY using index "loyalty_tasks_pkey";

alter table "public"."new_order_for_riders" add constraint "new_order_for_riders_pkey" PRIMARY KEY using index "new_order_for_riders_pkey";

alter table "public"."notification_logs" add constraint "notification_logs_pkey" PRIMARY KEY using index "notification_logs_pkey";

alter table "public"."notifications" add constraint "notifications_pkey" PRIMARY KEY using index "notifications_pkey";

alter table "public"."order_checklist_photos" add constraint "order_checklist_photos_pkey" PRIMARY KEY using index "order_checklist_photos_pkey";

alter table "public"."order_deposits" add constraint "order_deposits_pkey" PRIMARY KEY using index "order_deposits_pkey";

alter table "public"."order_discounts" add constraint "order_discounts_pkey" PRIMARY KEY using index "order_discounts_pkey";

alter table "public"."order_item_options" add constraint "order_item_options_pkey" PRIMARY KEY using index "order_item_options_pkey";

alter table "public"."order_items" add constraint "order_items_pkey" PRIMARY KEY using index "order_items_pkey";

alter table "public"."order_reviews" add constraint "order_reviews_pkey" PRIMARY KEY using index "order_reviews_pkey";

alter table "public"."order_rider_locations" add constraint "order_rider_locations_pkey" PRIMARY KEY using index "order_rider_locations_pkey";

alter table "public"."order_status_history" add constraint "order_status_history_pkey" PRIMARY KEY using index "order_status_history_pkey";

alter table "public"."orders" add constraint "orders_pkey" PRIMARY KEY using index "orders_pkey";

alter table "public"."payment_history" add constraint "payment_history_pkey" PRIMARY KEY using index "payment_history_pkey";

alter table "public"."preorder_delivery_fee_config" add constraint "preorder_delivery_fee_config_pkey" PRIMARY KEY using index "preorder_delivery_fee_config_pkey";

alter table "public"."preorder_items" add constraint "preorder_items_pkey" PRIMARY KEY using index "preorder_items_pkey";

alter table "public"."preorder_orders" add constraint "preorder_orders_pkey" PRIMARY KEY using index "preorder_orders_pkey";

alter table "public"."preorder_settings" add constraint "preorder_settings_pkey" PRIMARY KEY using index "preorder_settings_pkey";

alter table "public"."product_option_values" add constraint "product_option_values_pkey" PRIMARY KEY using index "product_option_values_pkey";

alter table "public"."product_options" add constraint "product_options_pkey" PRIMARY KEY using index "product_options_pkey";

alter table "public"."products" add constraint "products_pkey" PRIMARY KEY using index "products_pkey";

alter table "public"."rider_assignments" add constraint "rider_assignments_pkey" PRIMARY KEY using index "rider_assignments_pkey";

alter table "public"."rider_documents" add constraint "rider_documents_pkey" PRIMARY KEY using index "rider_documents_pkey";

alter table "public"."rider_fcm_tokens" add constraint "rider_fcm_tokens_pkey" PRIMARY KEY using index "rider_fcm_tokens_pkey";

alter table "public"."rider_order_bookings" add constraint "rider_order_bookings_pkey" PRIMARY KEY using index "rider_order_bookings_pkey";

alter table "public"."rider_reviews" add constraint "rider_reviews_pkey" PRIMARY KEY using index "rider_reviews_pkey";

alter table "public"."riders" add constraint "riders_pkey" PRIMARY KEY using index "riders_pkey";

alter table "public"."store_active_orders" add constraint "store_active_orders_pkey" PRIMARY KEY using index "store_active_orders_pkey";

alter table "public"."store_bank_accounts" add constraint "store_bank_accounts_pkey" PRIMARY KEY using index "store_bank_accounts_pkey";

alter table "public"."store_cancellation_requests" add constraint "store_cancellation_requests_pkey" PRIMARY KEY using index "store_cancellation_requests_pkey";

alter table "public"."store_categories" add constraint "store_categories_pkey" PRIMARY KEY using index "store_categories_pkey";

alter table "public"."store_reports" add constraint "store_reports_pkey" PRIMARY KEY using index "store_reports_pkey";

alter table "public"."store_suspension_history" add constraint "store_suspension_history_pkey" PRIMARY KEY using index "store_suspension_history_pkey";

alter table "public"."stores" add constraint "stores_pkey" PRIMARY KEY using index "stores_pkey";

alter table "public"."user_task_progress" add constraint "user_task_progress_pkey" PRIMARY KEY using index "user_task_progress_pkey";

alter table "public"."users" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";

alter table "public"."admin_activity_logs" add constraint "admin_activity_logs_admin_id_fkey" FOREIGN KEY (admin_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."admin_activity_logs" validate constraint "admin_activity_logs_admin_id_fkey";

alter table "public"."admin_export_logs" add constraint "admin_export_logs_admin_id_fkey" FOREIGN KEY (admin_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."admin_export_logs" validate constraint "admin_export_logs_admin_id_fkey";

alter table "public"."admin_login_logs" add constraint "admin_login_logs_admin_id_fkey" FOREIGN KEY (admin_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."admin_login_logs" validate constraint "admin_login_logs_admin_id_fkey";

alter table "public"."admin_system_config_logs" add constraint "admin_system_config_logs_admin_id_fkey" FOREIGN KEY (admin_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."admin_system_config_logs" validate constraint "admin_system_config_logs_admin_id_fkey";

alter table "public"."admin_view_logs" add constraint "admin_view_logs_admin_id_fkey" FOREIGN KEY (admin_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."admin_view_logs" validate constraint "admin_view_logs_admin_id_fkey";

alter table "public"."ads" add constraint "ads_product_id_fkey" FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE not valid;

alter table "public"."ads" validate constraint "ads_product_id_fkey";

alter table "public"."ads" add constraint "ads_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE not valid;

alter table "public"."ads" validate constraint "ads_store_id_fkey";

alter table "public"."ads_floating" add constraint "ads_floating_product_id_fkey" FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE not valid;

alter table "public"."ads_floating" validate constraint "ads_floating_product_id_fkey";

alter table "public"."ads_floating" add constraint "ads_floating_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE not valid;

alter table "public"."ads_floating" validate constraint "ads_floating_store_id_fkey";

alter table "public"."ads_hotel" add constraint "ads_hotel_hotel_id_fkey" FOREIGN KEY (hotel_id) REFERENCES public.hotel_properties(id) ON DELETE CASCADE not valid;

alter table "public"."ads_hotel" validate constraint "ads_hotel_hotel_id_fkey";

alter table "public"."ads_hotel" add constraint "ads_hotel_room_id_fkey" FOREIGN KEY (room_id) REFERENCES public.hotel_rooms(id) ON DELETE CASCADE not valid;

alter table "public"."ads_hotel" validate constraint "ads_hotel_room_id_fkey";

alter table "public"."app_store_versions" add constraint "app_store_versions_platform_check" CHECK (((platform)::text = ANY ((ARRAY['android'::character varying, 'ios'::character varying])::text[]))) not valid;

alter table "public"."app_store_versions" validate constraint "app_store_versions_platform_check";

alter table "public"."app_store_versions" add constraint "app_store_versions_platform_key" UNIQUE using index "app_store_versions_platform_key";

alter table "public"."app_versions" add constraint "app_versions_platform_check" CHECK (((platform)::text = ANY ((ARRAY['android'::character varying, 'ios'::character varying, 'web'::character varying])::text[]))) not valid;

alter table "public"."app_versions" validate constraint "app_versions_platform_check";

alter table "public"."beauty_booking_status_history" add constraint "beauty_booking_status_history_booking_id_fkey" FOREIGN KEY (booking_id) REFERENCES public.beauty_bookings(id) ON DELETE CASCADE not valid;

alter table "public"."beauty_booking_status_history" validate constraint "beauty_booking_status_history_booking_id_fkey";

alter table "public"."beauty_bookings" add constraint "beauty_bookings_booking_number_key" UNIQUE using index "beauty_bookings_booking_number_key";

alter table "public"."beauty_bookings" add constraint "beauty_bookings_booking_status_check" CHECK ((booking_status = ANY (ARRAY['pending'::text, 'confirmed'::text, 'cancelled'::text, 'completed'::text, 'no_show'::text, 'rescheduled'::text, 'in_progress'::text, 'ready'::text, 'late'::text, 'expired'::text]))) not valid;

alter table "public"."beauty_bookings" validate constraint "beauty_bookings_booking_status_check";

alter table "public"."beauty_bookings" add constraint "beauty_bookings_payment_method_check" CHECK ((payment_method = ANY (ARRAY['cash'::text, 'bank_transfer'::text, 'credit_card'::text]))) not valid;

alter table "public"."beauty_bookings" validate constraint "beauty_bookings_payment_method_check";

alter table "public"."beauty_bookings" add constraint "beauty_bookings_payment_status_check" CHECK ((payment_status = ANY (ARRAY['pending'::text, 'paid'::text, 'failed'::text, 'refunded'::text]))) not valid;

alter table "public"."beauty_bookings" validate constraint "beauty_bookings_payment_status_check";

alter table "public"."beauty_bookings" add constraint "beauty_bookings_salon_id_fkey" FOREIGN KEY (salon_id) REFERENCES public.beauty_salons(id) not valid;

alter table "public"."beauty_bookings" validate constraint "beauty_bookings_salon_id_fkey";

alter table "public"."beauty_bookings" add constraint "beauty_bookings_service_id_fkey" FOREIGN KEY (service_id) REFERENCES public.beauty_services(id) not valid;

alter table "public"."beauty_bookings" validate constraint "beauty_bookings_service_id_fkey";

alter table "public"."beauty_bookings" add constraint "beauty_bookings_staff_id_fkey" FOREIGN KEY (staff_id) REFERENCES public.beauty_staff(id) not valid;

alter table "public"."beauty_bookings" validate constraint "beauty_bookings_staff_id_fkey";

alter table "public"."beauty_notifications" add constraint "beauty_notifications_booking_id_fkey" FOREIGN KEY (booking_id) REFERENCES public.beauty_bookings(id) not valid;

alter table "public"."beauty_notifications" validate constraint "beauty_notifications_booking_id_fkey";

alter table "public"."beauty_notifications" add constraint "beauty_notifications_salon_id_fkey" FOREIGN KEY (salon_id) REFERENCES public.beauty_salons(id) not valid;

alter table "public"."beauty_notifications" validate constraint "beauty_notifications_salon_id_fkey";

alter table "public"."beauty_owner_accounts" add constraint "beauty_owner_accounts_email_key" UNIQUE using index "beauty_owner_accounts_email_key";

alter table "public"."beauty_owner_accounts" add constraint "beauty_owner_accounts_salon_id_fkey" FOREIGN KEY (salon_id) REFERENCES public.beauty_salons(id) not valid;

alter table "public"."beauty_owner_accounts" validate constraint "beauty_owner_accounts_salon_id_fkey";

alter table "public"."beauty_reviews" add constraint "beauty_reviews_booking_id_fkey" FOREIGN KEY (booking_id) REFERENCES public.beauty_bookings(id) ON DELETE CASCADE not valid;

alter table "public"."beauty_reviews" validate constraint "beauty_reviews_booking_id_fkey";

alter table "public"."beauty_reviews" add constraint "beauty_reviews_rating_check" CHECK (((rating >= 1) AND (rating <= 5))) not valid;

alter table "public"."beauty_reviews" validate constraint "beauty_reviews_rating_check";

alter table "public"."beauty_reviews" add constraint "beauty_reviews_salon_id_fkey" FOREIGN KEY (salon_id) REFERENCES public.beauty_salons(id) not valid;

alter table "public"."beauty_reviews" validate constraint "beauty_reviews_salon_id_fkey";

alter table "public"."beauty_reviews" add constraint "beauty_reviews_service_id_fkey" FOREIGN KEY (service_id) REFERENCES public.beauty_services(id) not valid;

alter table "public"."beauty_reviews" validate constraint "beauty_reviews_service_id_fkey";

alter table "public"."beauty_reviews" add constraint "beauty_reviews_staff_id_fkey" FOREIGN KEY (staff_id) REFERENCES public.beauty_staff(id) not valid;

alter table "public"."beauty_reviews" validate constraint "beauty_reviews_staff_id_fkey";

alter table "public"."beauty_salons" add constraint "beauty_salons_verification_status_check" CHECK ((verification_status = ANY (ARRAY['pending'::text, 'verified'::text, 'rejected'::text]))) not valid;

alter table "public"."beauty_salons" validate constraint "beauty_salons_verification_status_check";

alter table "public"."beauty_schedules" add constraint "beauty_schedules_salon_id_fkey" FOREIGN KEY (salon_id) REFERENCES public.beauty_salons(id) ON DELETE CASCADE not valid;

alter table "public"."beauty_schedules" validate constraint "beauty_schedules_salon_id_fkey";

alter table "public"."beauty_schedules" add constraint "beauty_schedules_salon_staff_date_time_unique" UNIQUE using index "beauty_schedules_salon_staff_date_time_unique";

alter table "public"."beauty_schedules" add constraint "beauty_schedules_staff_id_fkey" FOREIGN KEY (staff_id) REFERENCES public.beauty_staff(id) ON DELETE CASCADE not valid;

alter table "public"."beauty_schedules" validate constraint "beauty_schedules_staff_id_fkey";

alter table "public"."beauty_services" add constraint "beauty_services_salon_id_fkey" FOREIGN KEY (salon_id) REFERENCES public.beauty_salons(id) ON DELETE CASCADE not valid;

alter table "public"."beauty_services" validate constraint "beauty_services_salon_id_fkey";

alter table "public"."beauty_staff" add constraint "beauty_staff_salon_id_fkey" FOREIGN KEY (salon_id) REFERENCES public.beauty_salons(id) ON DELETE CASCADE not valid;

alter table "public"."beauty_staff" validate constraint "beauty_staff_salon_id_fkey";

alter table "public"."cancellation_requests" add constraint "cancellation_requests_assignment_id_fkey" FOREIGN KEY (assignment_id) REFERENCES public.rider_assignments(id) ON DELETE CASCADE not valid;

alter table "public"."cancellation_requests" validate constraint "cancellation_requests_assignment_id_fkey";

alter table "public"."cancellation_requests" add constraint "cancellation_requests_emergency_level_check" CHECK ((emergency_level = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text, 'critical'::text]))) not valid;

alter table "public"."cancellation_requests" validate constraint "cancellation_requests_emergency_level_check";

alter table "public"."cancellation_requests" add constraint "cancellation_requests_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE not valid;

alter table "public"."cancellation_requests" validate constraint "cancellation_requests_order_id_fkey";

alter table "public"."cancellation_requests" add constraint "cancellation_requests_reviewed_by_fkey" FOREIGN KEY (reviewed_by) REFERENCES public.users(id) not valid;

alter table "public"."cancellation_requests" validate constraint "cancellation_requests_reviewed_by_fkey";

alter table "public"."cancellation_requests" add constraint "cancellation_requests_rider_id_fkey" FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON DELETE CASCADE not valid;

alter table "public"."cancellation_requests" validate constraint "cancellation_requests_rider_id_fkey";

alter table "public"."cancellation_requests" add constraint "cancellation_requests_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text]))) not valid;

alter table "public"."cancellation_requests" validate constraint "cancellation_requests_status_check";

alter table "public"."chat_messages" add constraint "chat_messages_message_type_check" CHECK ((message_type = ANY (ARRAY['text'::text, 'image'::text, 'location'::text]))) not valid;

alter table "public"."chat_messages" validate constraint "chat_messages_message_type_check";

alter table "public"."chat_messages" add constraint "chat_messages_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE not valid;

alter table "public"."chat_messages" validate constraint "chat_messages_order_id_fkey";

alter table "public"."chat_messages" add constraint "chat_messages_sender_type_check" CHECK ((sender_type = ANY (ARRAY['rider'::text, 'customer'::text]))) not valid;

alter table "public"."chat_messages" validate constraint "chat_messages_sender_type_check";

alter table "public"."community_comment_likes" add constraint "community_comment_likes_comment_id_fkey" FOREIGN KEY (comment_id) REFERENCES public.community_comments(id) ON DELETE CASCADE not valid;

alter table "public"."community_comment_likes" validate constraint "community_comment_likes_comment_id_fkey";

alter table "public"."community_comment_likes" add constraint "community_comment_likes_unique" UNIQUE using index "community_comment_likes_unique";

alter table "public"."community_comment_likes" add constraint "community_comment_likes_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."community_comment_likes" validate constraint "community_comment_likes_user_id_fkey";

alter table "public"."community_comments" add constraint "community_comments_content_check" CHECK (((content IS NOT NULL) AND (content <> ''::text))) not valid;

alter table "public"."community_comments" validate constraint "community_comments_content_check";

alter table "public"."community_comments" add constraint "community_comments_image_path_check" CHECK (((image_file_path IS NULL) OR (image_file_path ~~ 'post-images/%/comment/%'::text))) not valid;

alter table "public"."community_comments" validate constraint "community_comments_image_path_check";

alter table "public"."community_comments" add constraint "community_comments_parent_fkey" FOREIGN KEY (parent_comment_id) REFERENCES public.community_comments(id) ON DELETE CASCADE not valid;

alter table "public"."community_comments" validate constraint "community_comments_parent_fkey";

alter table "public"."community_comments" add constraint "community_comments_post_id_fkey" FOREIGN KEY (post_id) REFERENCES public.community_posts(id) ON DELETE CASCADE not valid;

alter table "public"."community_comments" validate constraint "community_comments_post_id_fkey";

alter table "public"."community_comments" add constraint "community_comments_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."community_comments" validate constraint "community_comments_user_id_fkey";

alter table "public"."community_post_images" add constraint "community_post_images_order_check" CHECK (((image_order >= 1) AND (image_order <= 3))) not valid;

alter table "public"."community_post_images" validate constraint "community_post_images_order_check";

alter table "public"."community_post_images" add constraint "community_post_images_path_check" CHECK (((file_path ~~ 'post-images/%/post/%'::text) OR (file_path ~~ 'https://%'::text) OR (file_path ~~ 'http://%'::text))) not valid;

alter table "public"."community_post_images" validate constraint "community_post_images_path_check";

alter table "public"."community_post_images" add constraint "community_post_images_post_id_fkey" FOREIGN KEY (post_id) REFERENCES public.community_posts(id) ON DELETE CASCADE not valid;

alter table "public"."community_post_images" validate constraint "community_post_images_post_id_fkey";

alter table "public"."community_post_likes" add constraint "community_post_likes_post_id_fkey" FOREIGN KEY (post_id) REFERENCES public.community_posts(id) ON DELETE CASCADE not valid;

alter table "public"."community_post_likes" validate constraint "community_post_likes_post_id_fkey";

alter table "public"."community_post_likes" add constraint "community_post_likes_unique" UNIQUE using index "community_post_likes_unique";

alter table "public"."community_post_likes" add constraint "community_post_likes_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."community_post_likes" validate constraint "community_post_likes_user_id_fkey";

alter table "public"."community_posts" add constraint "community_posts_content_check" CHECK ((((post_type = 'normal'::text) AND (content IS NOT NULL) AND (content <> ''::text)) OR ((post_type = 'checkin'::text) AND (location_name IS NOT NULL) AND (location_name <> ''::text) AND (content IS NOT NULL) AND (content <> ''::text)) OR ((post_type = 'photo'::text) AND (content IS NOT NULL) AND (content <> ''::text)) OR ((post_type = 'job_seeker'::text) AND (content IS NOT NULL) AND (content <> ''::text)) OR ((post_type = 'job_offer'::text) AND (content IS NOT NULL) AND (content <> ''::text)) OR ((post_type = 'find_handyman'::text) AND (content IS NOT NULL) AND (content <> ''::text)) OR ((post_type = 'find_vehicle'::text) AND (content IS NOT NULL) AND (content <> ''::text)) OR ((post_type = 'find_maid'::text) AND (content IS NOT NULL) AND (content <> ''::text)))) not valid;

alter table "public"."community_posts" validate constraint "community_posts_content_check";

alter table "public"."community_posts" add constraint "community_posts_post_type_check" CHECK ((post_type = ANY (ARRAY['normal'::text, 'checkin'::text, 'photo'::text, 'job_seeker'::text, 'job_offer'::text, 'find_handyman'::text, 'find_vehicle'::text, 'find_maid'::text]))) not valid;

alter table "public"."community_posts" validate constraint "community_posts_post_type_check";

alter table "public"."community_posts" add constraint "community_posts_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."community_posts" validate constraint "community_posts_user_id_fkey";

alter table "public"."delivery_fee_history" add constraint "delivery_fee_history_changed_by_fkey" FOREIGN KEY (changed_by) REFERENCES public.users(id) not valid;

alter table "public"."delivery_fee_history" validate constraint "delivery_fee_history_changed_by_fkey";

alter table "public"."delivery_fee_history" add constraint "delivery_fee_history_setting_id_fkey" FOREIGN KEY (setting_id) REFERENCES public.delivery_fee_settings(id) ON DELETE CASCADE not valid;

alter table "public"."delivery_fee_history" validate constraint "delivery_fee_history_setting_id_fkey";

alter table "public"."delivery_fee_settings" add constraint "delivery_fee_settings_created_by_fkey" FOREIGN KEY (created_by) REFERENCES public.users(id) not valid;

alter table "public"."delivery_fee_settings" validate constraint "delivery_fee_settings_created_by_fkey";

alter table "public"."delivery_fee_tiers" add constraint "delivery_fee_tiers_config_id_fkey" FOREIGN KEY (config_id) REFERENCES public.delivery_fee_config_v2(id) ON DELETE CASCADE not valid;

alter table "public"."delivery_fee_tiers" validate constraint "delivery_fee_tiers_config_id_fkey";

alter table "public"."delivery_fee_tiers" add constraint "delivery_fee_tiers_fee_check" CHECK ((fee >= (0)::numeric)) not valid;

alter table "public"."delivery_fee_tiers" validate constraint "delivery_fee_tiers_fee_check";

alter table "public"."delivery_fee_tiers" add constraint "delivery_fee_tiers_max_distance_check" CHECK (((max_distance IS NULL) OR (max_distance >= min_distance))) not valid;

alter table "public"."delivery_fee_tiers" validate constraint "delivery_fee_tiers_max_distance_check";

alter table "public"."delivery_fee_tiers" add constraint "delivery_fee_tiers_min_distance_check" CHECK ((min_distance >= (0)::numeric)) not valid;

alter table "public"."delivery_fee_tiers" validate constraint "delivery_fee_tiers_min_distance_check";

alter table "public"."delivery_notes" add constraint "delivery_notes_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."delivery_notes" validate constraint "delivery_notes_user_id_fkey";

alter table "public"."delivery_window_allocations" add constraint "delivery_window_allocations_delivery_date_delivery_window_i_key" UNIQUE using index "delivery_window_allocations_delivery_date_delivery_window_i_key";

alter table "public"."delivery_window_allocations" add constraint "delivery_window_allocations_delivery_window_id_fkey" FOREIGN KEY (delivery_window_id) REFERENCES public.delivery_windows(id) not valid;

alter table "public"."delivery_window_allocations" validate constraint "delivery_window_allocations_delivery_window_id_fkey";

alter table "public"."delivery_window_allocations" add constraint "status_check" CHECK ((status = ANY (ARRAY['open'::text, 'full'::text, 'closed'::text]))) not valid;

alter table "public"."delivery_window_allocations" validate constraint "status_check";

alter table "public"."discount_code_usage" add constraint "discount_code_usage_discount_code_id_fkey" FOREIGN KEY (discount_code_id) REFERENCES public.discount_codes(id) not valid;

alter table "public"."discount_code_usage" validate constraint "discount_code_usage_discount_code_id_fkey";

alter table "public"."discount_code_usage" add constraint "discount_code_usage_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) not valid;

alter table "public"."discount_code_usage" validate constraint "discount_code_usage_order_id_fkey";

alter table "public"."discount_code_usage" add constraint "discount_code_usage_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) not valid;

alter table "public"."discount_code_usage" validate constraint "discount_code_usage_user_id_fkey";

alter table "public"."discount_codes" add constraint "discount_codes_code_key" UNIQUE using index "discount_codes_code_key";

alter table "public"."discount_codes" add constraint "discount_codes_created_by_fkey" FOREIGN KEY (created_by) REFERENCES auth.users(id) not valid;

alter table "public"."discount_codes" validate constraint "discount_codes_created_by_fkey";

alter table "public"."discount_codes" add constraint "discount_codes_discount_type_check" CHECK ((discount_type = ANY (ARRAY['percentage'::text, 'fixed_amount'::text]))) not valid;

alter table "public"."discount_codes" validate constraint "discount_codes_discount_type_check";

alter table "public"."document_verification_history" add constraint "document_verification_history_action_check" CHECK ((action = ANY (ARRAY['submitted'::text, 'verified'::text, 'rejected'::text, 'expired'::text]))) not valid;

alter table "public"."document_verification_history" validate constraint "document_verification_history_action_check";

alter table "public"."document_verification_history" add constraint "document_verification_history_document_id_fkey" FOREIGN KEY (document_id) REFERENCES public.rider_documents(id) ON DELETE CASCADE not valid;

alter table "public"."document_verification_history" validate constraint "document_verification_history_document_id_fkey";

alter table "public"."document_verification_history" add constraint "document_verification_history_rider_id_fkey" FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON DELETE CASCADE not valid;

alter table "public"."document_verification_history" validate constraint "document_verification_history_rider_id_fkey";

alter table "public"."document_verification_history" add constraint "document_verification_history_verified_by_fkey" FOREIGN KEY (verified_by) REFERENCES public.users(id) not valid;

alter table "public"."document_verification_history" validate constraint "document_verification_history_verified_by_fkey";

alter table "public"."fcm_store" add constraint "fcm_store_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE not valid;

alter table "public"."fcm_store" validate constraint "fcm_store_store_id_fkey";

alter table "public"."fcm_store" add constraint "fcm_store_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."fcm_store" validate constraint "fcm_store_user_id_fkey";

alter table "public"."hotel_booking_status_history" add constraint "hotel_booking_status_history_booking_id_fkey" FOREIGN KEY (booking_id) REFERENCES public.hotel_bookings(id) ON DELETE CASCADE not valid;

alter table "public"."hotel_booking_status_history" validate constraint "hotel_booking_status_history_booking_id_fkey";

alter table "public"."hotel_bookings" add constraint "hotel_bookings_booking_number_key" UNIQUE using index "hotel_bookings_booking_number_key";

alter table "public"."hotel_bookings" add constraint "hotel_bookings_booking_status_check" CHECK ((booking_status = ANY (ARRAY['pending'::text, 'confirmed'::text, 'cancelled'::text, 'completed'::text, 'no_show'::text]))) not valid;

alter table "public"."hotel_bookings" validate constraint "hotel_bookings_booking_status_check";

alter table "public"."hotel_bookings" add constraint "hotel_bookings_booking_type_check" CHECK ((booking_type = ANY (ARRAY['daily'::text, 'hourly'::text]))) not valid;

alter table "public"."hotel_bookings" validate constraint "hotel_bookings_booking_type_check";

alter table "public"."hotel_bookings" add constraint "hotel_bookings_hotel_id_fkey" FOREIGN KEY (hotel_id) REFERENCES public.hotel_properties(id) ON DELETE CASCADE not valid;

alter table "public"."hotel_bookings" validate constraint "hotel_bookings_hotel_id_fkey";

alter table "public"."hotel_bookings" add constraint "hotel_bookings_payment_method_check" CHECK ((payment_method = ANY (ARRAY['cash'::text, 'bank_transfer'::text, 'credit_card'::text]))) not valid;

alter table "public"."hotel_bookings" validate constraint "hotel_bookings_payment_method_check";

alter table "public"."hotel_bookings" add constraint "hotel_bookings_payment_status_check" CHECK ((payment_status = ANY (ARRAY['pending'::text, 'paid'::text, 'failed'::text, 'refunded'::text]))) not valid;

alter table "public"."hotel_bookings" validate constraint "hotel_bookings_payment_status_check";

alter table "public"."hotel_bookings" add constraint "hotel_bookings_room_id_fkey" FOREIGN KEY (room_id) REFERENCES public.hotel_rooms(id) ON DELETE CASCADE not valid;

alter table "public"."hotel_bookings" validate constraint "hotel_bookings_room_id_fkey";

alter table "public"."hotel_hourly_availability" add constraint "hotel_hourly_availability_room_date_unique" UNIQUE using index "hotel_hourly_availability_room_date_unique";

alter table "public"."hotel_hourly_availability" add constraint "hotel_hourly_availability_room_id_fkey" FOREIGN KEY (room_id) REFERENCES public.hotel_rooms(id) ON DELETE CASCADE not valid;

alter table "public"."hotel_hourly_availability" validate constraint "hotel_hourly_availability_room_id_fkey";

alter table "public"."hotel_notifications" add constraint "hotel_notifications_booking_id_fkey" FOREIGN KEY (booking_id) REFERENCES public.hotel_bookings(id) ON DELETE CASCADE not valid;

alter table "public"."hotel_notifications" validate constraint "hotel_notifications_booking_id_fkey";

alter table "public"."hotel_notifications" add constraint "hotel_notifications_hotel_id_fkey" FOREIGN KEY (hotel_id) REFERENCES public.hotel_properties(id) ON DELETE CASCADE not valid;

alter table "public"."hotel_notifications" validate constraint "hotel_notifications_hotel_id_fkey";

alter table "public"."hotel_owner_accounts" add constraint "hotel_owner_accounts_email_key" UNIQUE using index "hotel_owner_accounts_email_key";

alter table "public"."hotel_owner_accounts" add constraint "hotel_owner_accounts_hotel_id_fkey" FOREIGN KEY (hotel_id) REFERENCES public.hotel_properties(id) ON DELETE CASCADE not valid;

alter table "public"."hotel_owner_accounts" validate constraint "hotel_owner_accounts_hotel_id_fkey";

alter table "public"."hotel_properties" add constraint "hotel_properties_hotel_size_check" CHECK ((hotel_size = ANY (ARRAY['small'::text, 'medium'::text, 'large'::text, 'resort'::text]))) not valid;

alter table "public"."hotel_properties" validate constraint "hotel_properties_hotel_size_check";

alter table "public"."hotel_properties" add constraint "hotel_properties_price_range_check" CHECK ((price_range = ANY (ARRAY['budget'::text, 'mid-range'::text, 'luxury'::text]))) not valid;

alter table "public"."hotel_properties" validate constraint "hotel_properties_price_range_check";

alter table "public"."hotel_properties" add constraint "hotel_properties_star_rating_check" CHECK (((star_rating >= 1) AND (star_rating <= 5))) not valid;

alter table "public"."hotel_properties" validate constraint "hotel_properties_star_rating_check";

alter table "public"."hotel_properties" add constraint "hotel_properties_verification_status_check" CHECK ((verification_status = ANY (ARRAY['pending'::text, 'verified'::text, 'rejected'::text]))) not valid;

alter table "public"."hotel_properties" validate constraint "hotel_properties_verification_status_check";

alter table "public"."hotel_reviews" add constraint "hotel_reviews_booking_id_fkey" FOREIGN KEY (booking_id) REFERENCES public.hotel_bookings(id) ON DELETE CASCADE not valid;

alter table "public"."hotel_reviews" validate constraint "hotel_reviews_booking_id_fkey";

alter table "public"."hotel_reviews" add constraint "hotel_reviews_hotel_id_fkey" FOREIGN KEY (hotel_id) REFERENCES public.hotel_properties(id) ON DELETE CASCADE not valid;

alter table "public"."hotel_reviews" validate constraint "hotel_reviews_hotel_id_fkey";

alter table "public"."hotel_reviews" add constraint "hotel_reviews_rating_check" CHECK (((rating >= 1) AND (rating <= 5))) not valid;

alter table "public"."hotel_reviews" validate constraint "hotel_reviews_rating_check";

alter table "public"."hotel_room_availability" add constraint "hotel_room_availability_room_date_unique" UNIQUE using index "hotel_room_availability_room_date_unique";

alter table "public"."hotel_room_availability" add constraint "hotel_room_availability_room_id_fkey" FOREIGN KEY (room_id) REFERENCES public.hotel_rooms(id) ON DELETE CASCADE not valid;

alter table "public"."hotel_room_availability" validate constraint "hotel_room_availability_room_id_fkey";

alter table "public"."hotel_room_types" add constraint "hotel_room_types_booking_mode_check" CHECK ((booking_mode = ANY (ARRAY['daily'::text, 'hourly'::text, 'both'::text]))) not valid;

alter table "public"."hotel_room_types" validate constraint "hotel_room_types_booking_mode_check";

alter table "public"."hotel_room_types" add constraint "hotel_room_types_hotel_id_fkey" FOREIGN KEY (hotel_id) REFERENCES public.hotel_properties(id) ON DELETE CASCADE not valid;

alter table "public"."hotel_room_types" validate constraint "hotel_room_types_hotel_id_fkey";

alter table "public"."hotel_rooms" add constraint "hotel_rooms_hotel_id_fkey" FOREIGN KEY (hotel_id) REFERENCES public.hotel_properties(id) ON DELETE CASCADE not valid;

alter table "public"."hotel_rooms" validate constraint "hotel_rooms_hotel_id_fkey";

alter table "public"."hotel_rooms" add constraint "hotel_rooms_room_status_check" CHECK ((room_status = ANY (ARRAY['available'::text, 'occupied'::text, 'maintenance'::text, 'reserved'::text]))) not valid;

alter table "public"."hotel_rooms" validate constraint "hotel_rooms_room_status_check";

alter table "public"."hotel_rooms" add constraint "hotel_rooms_room_type_id_fkey" FOREIGN KEY (room_type_id) REFERENCES public.hotel_room_types(id) ON DELETE CASCADE not valid;

alter table "public"."hotel_rooms" validate constraint "hotel_rooms_room_type_id_fkey";

alter table "public"."job_assignments" add constraint "job_assignments_cancelled_by_fkey" FOREIGN KEY (cancelled_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."job_assignments" validate constraint "job_assignments_cancelled_by_fkey";

alter table "public"."job_assignments" add constraint "job_assignments_job_posting_id_fkey" FOREIGN KEY (job_posting_id) REFERENCES public.job_postings(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."job_assignments" validate constraint "job_assignments_job_posting_id_fkey";

alter table "public"."job_assignments" add constraint "job_assignments_rating_by_employer_check" CHECK (((rating_by_employer IS NULL) OR ((rating_by_employer >= (0)::numeric) AND (rating_by_employer <= (5)::numeric)))) not valid;

alter table "public"."job_assignments" validate constraint "job_assignments_rating_by_employer_check";

alter table "public"."job_assignments" add constraint "job_assignments_rating_by_worker_check" CHECK (((rating_by_worker IS NULL) OR ((rating_by_worker >= (0)::numeric) AND (rating_by_worker <= (5)::numeric)))) not valid;

alter table "public"."job_assignments" validate constraint "job_assignments_rating_by_worker_check";

alter table "public"."job_assignments" add constraint "job_assignments_status_check" CHECK ((status = ANY (ARRAY['assigned'::text, 'in_progress'::text, 'completed'::text, 'cancelled'::text]))) not valid;

alter table "public"."job_assignments" validate constraint "job_assignments_status_check";

alter table "public"."job_assignments" add constraint "job_assignments_worker_id_fkey" FOREIGN KEY (worker_id) REFERENCES public.job_workers(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."job_assignments" validate constraint "job_assignments_worker_id_fkey";

alter table "public"."job_categories" add constraint "job_categories_name_key" UNIQUE using index "job_categories_name_key";

alter table "public"."job_company_bank_accounts" add constraint "job_company_bank_accounts_created_by_fkey" FOREIGN KEY (created_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."job_company_bank_accounts" validate constraint "job_company_bank_accounts_created_by_fkey";

alter table "public"."job_completion_approvals" add constraint "job_completion_approvals_approval_status_check" CHECK ((approval_status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text]))) not valid;

alter table "public"."job_completion_approvals" validate constraint "job_completion_approvals_approval_status_check";

alter table "public"."job_completion_approvals" add constraint "job_completion_approvals_approved_by_fkey" FOREIGN KEY (approved_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."job_completion_approvals" validate constraint "job_completion_approvals_approved_by_fkey";

alter table "public"."job_completion_approvals" add constraint "job_completion_approvals_credit_amount_check" CHECK ((credit_amount >= (0)::numeric)) not valid;

alter table "public"."job_completion_approvals" validate constraint "job_completion_approvals_credit_amount_check";

alter table "public"."job_completion_approvals" add constraint "job_completion_approvals_employer_id_fkey" FOREIGN KEY (employer_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."job_completion_approvals" validate constraint "job_completion_approvals_employer_id_fkey";

alter table "public"."job_completion_approvals" add constraint "job_completion_approvals_job_assignment_id_fkey" FOREIGN KEY (job_assignment_id) REFERENCES public.job_assignments(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."job_completion_approvals" validate constraint "job_completion_approvals_job_assignment_id_fkey";

alter table "public"."job_completion_approvals" add constraint "job_completion_approvals_job_posting_id_fkey" FOREIGN KEY (job_posting_id) REFERENCES public.job_postings(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."job_completion_approvals" validate constraint "job_completion_approvals_job_posting_id_fkey";

alter table "public"."job_completion_approvals" add constraint "job_completion_approvals_job_price_check" CHECK ((job_price >= (0)::numeric)) not valid;

alter table "public"."job_completion_approvals" validate constraint "job_completion_approvals_job_price_check";

alter table "public"."job_completion_approvals" add constraint "job_completion_approvals_platform_fee_amount_check" CHECK ((platform_fee_amount >= (0)::numeric)) not valid;

alter table "public"."job_completion_approvals" validate constraint "job_completion_approvals_platform_fee_amount_check";

alter table "public"."job_completion_approvals" add constraint "job_completion_approvals_worker_id_fkey" FOREIGN KEY (worker_id) REFERENCES public.job_workers(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."job_completion_approvals" validate constraint "job_completion_approvals_worker_id_fkey";

alter table "public"."job_fee_settings" add constraint "job_fee_settings_created_by_fkey" FOREIGN KEY (created_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."job_fee_settings" validate constraint "job_fee_settings_created_by_fkey";

alter table "public"."job_fee_settings" add constraint "job_fee_settings_fee_percentage_check" CHECK (((fee_percentage >= (0)::numeric) AND (fee_percentage <= (100)::numeric))) not valid;

alter table "public"."job_fee_settings" validate constraint "job_fee_settings_fee_percentage_check";

alter table "public"."job_fee_settings" add constraint "job_fee_settings_maximum_fee_check" CHECK (((maximum_fee IS NULL) OR (maximum_fee >= (0)::numeric))) not valid;

alter table "public"."job_fee_settings" validate constraint "job_fee_settings_maximum_fee_check";

alter table "public"."job_fee_settings" add constraint "job_fee_settings_minimum_fee_check" CHECK ((minimum_fee >= (0)::numeric)) not valid;

alter table "public"."job_fee_settings" validate constraint "job_fee_settings_minimum_fee_check";

alter table "public"."job_postings" add constraint "job_postings_category_id_fkey" FOREIGN KEY (category_id) REFERENCES public.job_categories(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."job_postings" validate constraint "job_postings_category_id_fkey";

alter table "public"."job_postings" add constraint "job_postings_employer_id_fkey" FOREIGN KEY (employer_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."job_postings" validate constraint "job_postings_employer_id_fkey";

alter table "public"."job_postings" add constraint "job_postings_job_number_key" UNIQUE using index "job_postings_job_number_key";

alter table "public"."job_postings" add constraint "job_postings_payment_method_check" CHECK ((payment_method = ANY (ARRAY['cash'::text, 'bank_transfer'::text]))) not valid;

alter table "public"."job_postings" validate constraint "job_postings_payment_method_check";

alter table "public"."job_postings" add constraint "job_postings_payment_status_check" CHECK ((payment_status = ANY (ARRAY['pending'::text, 'paid'::text, 'failed'::text, 'cancelled'::text]))) not valid;

alter table "public"."job_postings" validate constraint "job_postings_payment_status_check";

alter table "public"."job_postings" add constraint "job_postings_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'published'::text, 'assigned'::text, 'in_progress'::text, 'completed'::text, 'cancelled'::text]))) not valid;

alter table "public"."job_postings" validate constraint "job_postings_status_check";

alter table "public"."job_postings" add constraint "job_postings_transfer_confirmed_by_fkey" FOREIGN KEY (transfer_confirmed_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."job_postings" validate constraint "job_postings_transfer_confirmed_by_fkey";

alter table "public"."job_postings" add constraint "job_postings_worker_id_fkey" FOREIGN KEY (worker_id) REFERENCES public.job_workers(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."job_postings" validate constraint "job_postings_worker_id_fkey";

alter table "public"."job_worker_credit_ledger" add constraint "job_worker_credit_ledger_amount_check" CHECK ((amount <> (0)::numeric)) not valid;

alter table "public"."job_worker_credit_ledger" validate constraint "job_worker_credit_ledger_amount_check";

alter table "public"."job_worker_credit_ledger" add constraint "job_worker_credit_ledger_job_assignment_id_fkey" FOREIGN KEY (job_assignment_id) REFERENCES public.job_assignments(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."job_worker_credit_ledger" validate constraint "job_worker_credit_ledger_job_assignment_id_fkey";

alter table "public"."job_worker_credit_ledger" add constraint "job_worker_credit_ledger_processed_by_fkey" FOREIGN KEY (processed_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."job_worker_credit_ledger" validate constraint "job_worker_credit_ledger_processed_by_fkey";

alter table "public"."job_worker_credit_ledger" add constraint "job_worker_credit_ledger_transaction_type_check" CHECK ((transaction_type = ANY (ARRAY['credit'::text, 'debit'::text, 'refund'::text, 'withdrawal'::text, 'fee'::text, 'adjustment'::text]))) not valid;

alter table "public"."job_worker_credit_ledger" validate constraint "job_worker_credit_ledger_transaction_type_check";

alter table "public"."job_worker_credit_ledger" add constraint "job_worker_credit_ledger_withdrawal_status_check" CHECK (((withdrawal_status IS NULL) OR (withdrawal_status = ANY (ARRAY['pending'::text, 'processing'::text, 'completed'::text, 'failed'::text])))) not valid;

alter table "public"."job_worker_credit_ledger" validate constraint "job_worker_credit_ledger_withdrawal_status_check";

alter table "public"."job_worker_credit_ledger" add constraint "job_worker_credit_ledger_worker_id_fkey" FOREIGN KEY (worker_id) REFERENCES public.job_workers(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."job_worker_credit_ledger" validate constraint "job_worker_credit_ledger_worker_id_fkey";

alter table "public"."job_worker_credits" add constraint "job_worker_credits_available_balance_check" CHECK ((available_balance >= (0)::numeric)) not valid;

alter table "public"."job_worker_credits" validate constraint "job_worker_credits_available_balance_check";

alter table "public"."job_worker_credits" add constraint "job_worker_credits_pending_balance_check" CHECK ((pending_balance >= (0)::numeric)) not valid;

alter table "public"."job_worker_credits" validate constraint "job_worker_credits_pending_balance_check";

alter table "public"."job_worker_credits" add constraint "job_worker_credits_total_earned_check" CHECK ((total_earned >= (0)::numeric)) not valid;

alter table "public"."job_worker_credits" validate constraint "job_worker_credits_total_earned_check";

alter table "public"."job_worker_credits" add constraint "job_worker_credits_worker_id_fkey" FOREIGN KEY (worker_id) REFERENCES public.job_workers(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."job_worker_credits" validate constraint "job_worker_credits_worker_id_fkey";

alter table "public"."job_worker_credits" add constraint "job_worker_credits_worker_id_key" UNIQUE using index "job_worker_credits_worker_id_key";

alter table "public"."job_worker_fcm_tokens" add constraint "job_worker_fcm_tokens_device_type_check" CHECK ((device_type = ANY (ARRAY['mobile'::text, 'tablet'::text, 'desktop'::text]))) not valid;

alter table "public"."job_worker_fcm_tokens" validate constraint "job_worker_fcm_tokens_device_type_check";

alter table "public"."job_worker_fcm_tokens" add constraint "job_worker_fcm_tokens_worker_id_fcm_token_key" UNIQUE using index "job_worker_fcm_tokens_worker_id_fcm_token_key";

alter table "public"."job_worker_fcm_tokens" add constraint "job_worker_fcm_tokens_worker_id_fkey" FOREIGN KEY (worker_id) REFERENCES public.job_workers(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."job_worker_fcm_tokens" validate constraint "job_worker_fcm_tokens_worker_id_fkey";

alter table "public"."job_worker_withdrawals" add constraint "job_worker_withdrawals_amount_check" CHECK ((amount > (0)::numeric)) not valid;

alter table "public"."job_worker_withdrawals" validate constraint "job_worker_withdrawals_amount_check";

alter table "public"."job_worker_withdrawals" add constraint "job_worker_withdrawals_processed_by_fkey" FOREIGN KEY (processed_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."job_worker_withdrawals" validate constraint "job_worker_withdrawals_processed_by_fkey";

alter table "public"."job_worker_withdrawals" add constraint "job_worker_withdrawals_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'processing'::text, 'approved'::text, 'rejected'::text, 'failed'::text]))) not valid;

alter table "public"."job_worker_withdrawals" validate constraint "job_worker_withdrawals_status_check";

alter table "public"."job_worker_withdrawals" add constraint "job_worker_withdrawals_worker_id_fkey" FOREIGN KEY (worker_id) REFERENCES public.job_workers(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."job_worker_withdrawals" validate constraint "job_worker_withdrawals_worker_id_fkey";

alter table "public"."job_workers" add constraint "job_workers_minimum_withdrawal_amount_check" CHECK ((minimum_withdrawal_amount >= (0)::numeric)) not valid;

alter table "public"."job_workers" validate constraint "job_workers_minimum_withdrawal_amount_check";

alter table "public"."job_workers" add constraint "job_workers_rating_check" CHECK (((rating >= (0)::numeric) AND (rating <= (5)::numeric))) not valid;

alter table "public"."job_workers" validate constraint "job_workers_rating_check";

alter table "public"."job_workers" add constraint "job_workers_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."job_workers" validate constraint "job_workers_user_id_fkey";

alter table "public"."job_workers" add constraint "job_workers_user_id_key" UNIQUE using index "job_workers_user_id_key";

alter table "public"."job_workers" add constraint "job_workers_verified_by_fkey" FOREIGN KEY (verified_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."job_workers" validate constraint "job_workers_verified_by_fkey";

alter table "public"."loyalty_point_ledger" add constraint "loyalty_point_ledger_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE not valid;

alter table "public"."loyalty_point_ledger" validate constraint "loyalty_point_ledger_order_id_fkey";

alter table "public"."loyalty_point_ledger" add constraint "loyalty_point_ledger_order_id_reason_code_key" UNIQUE using index "loyalty_point_ledger_order_id_reason_code_key";

alter table "public"."loyalty_point_ledger" add constraint "loyalty_point_ledger_points_change_check" CHECK ((points_change <> 0)) not valid;

alter table "public"."loyalty_point_ledger" validate constraint "loyalty_point_ledger_points_change_check";

alter table "public"."loyalty_point_ledger" add constraint "loyalty_point_ledger_transaction_type_check" CHECK ((transaction_type = ANY (ARRAY['earn'::text, 'redeem'::text, 'adjust'::text, 'expire'::text]))) not valid;

alter table "public"."loyalty_point_ledger" validate constraint "loyalty_point_ledger_transaction_type_check";

alter table "public"."loyalty_point_ledger" add constraint "loyalty_point_ledger_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."loyalty_point_ledger" validate constraint "loyalty_point_ledger_user_id_fkey";

alter table "public"."loyalty_point_rules" add constraint "loyalty_point_rules_points_awarded_check" CHECK ((points_awarded > 0)) not valid;

alter table "public"."loyalty_point_rules" validate constraint "loyalty_point_rules_points_awarded_check";

alter table "public"."loyalty_point_rules" add constraint "loyalty_point_rules_rule_code_key" UNIQUE using index "loyalty_point_rules_rule_code_key";

alter table "public"."loyalty_redemption_rules" add constraint "loyalty_redemption_rules_points_required_check" CHECK ((points_required > 0)) not valid;

alter table "public"."loyalty_redemption_rules" validate constraint "loyalty_redemption_rules_points_required_check";

alter table "public"."loyalty_redemption_rules" add constraint "loyalty_redemption_rules_reward_type_check" CHECK ((reward_type = ANY (ARRAY['discount'::text, 'coupon'::text, 'cashback'::text, 'other'::text]))) not valid;

alter table "public"."loyalty_redemption_rules" validate constraint "loyalty_redemption_rules_reward_type_check";

alter table "public"."loyalty_redemption_rules" add constraint "loyalty_redemption_rules_reward_value_check" CHECK ((reward_value >= (0)::numeric)) not valid;

alter table "public"."loyalty_redemption_rules" validate constraint "loyalty_redemption_rules_reward_value_check";

alter table "public"."loyalty_redemption_rules" add constraint "loyalty_redemption_rules_rule_code_key" UNIQUE using index "loyalty_redemption_rules_rule_code_key";

alter table "public"."loyalty_tasks" add constraint "loyalty_tasks_max_progress_check" CHECK ((max_progress > 0)) not valid;

alter table "public"."loyalty_tasks" validate constraint "loyalty_tasks_max_progress_check";

alter table "public"."loyalty_tasks" add constraint "loyalty_tasks_points_reward_check" CHECK ((points_reward > 0)) not valid;

alter table "public"."loyalty_tasks" validate constraint "loyalty_tasks_points_reward_check";

alter table "public"."loyalty_tasks" add constraint "loyalty_tasks_reset_frequency_check" CHECK ((reset_frequency = ANY (ARRAY['daily'::text, 'weekly'::text, 'monthly'::text, 'never'::text]))) not valid;

alter table "public"."loyalty_tasks" validate constraint "loyalty_tasks_reset_frequency_check";

alter table "public"."loyalty_tasks" add constraint "loyalty_tasks_task_code_key" UNIQUE using index "loyalty_tasks_task_code_key";

alter table "public"."loyalty_tasks" add constraint "loyalty_tasks_task_type_check" CHECK ((task_type = ANY (ARRAY['daily'::text, 'weekly'::text, 'special'::text]))) not valid;

alter table "public"."loyalty_tasks" validate constraint "loyalty_tasks_task_type_check";

alter table "public"."notification_logs" add constraint "notification_logs_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) not valid;

alter table "public"."notification_logs" validate constraint "notification_logs_order_id_fkey";

alter table "public"."notifications" add constraint "notifications_type_check" CHECK ((type = ANY (ARRAY['order_update'::text, 'delivery_status'::text, 'payment'::text, 'promotion'::text, 'system'::text]))) not valid;

alter table "public"."notifications" validate constraint "notifications_type_check";

alter table "public"."notifications" add constraint "notifications_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."notifications" validate constraint "notifications_user_id_fkey";

alter table "public"."order_checklist_photos" add constraint "order_checklist_photos_preorder_order_id_fkey" FOREIGN KEY (preorder_order_id) REFERENCES public.preorder_orders(id) ON DELETE CASCADE not valid;

alter table "public"."order_checklist_photos" validate constraint "order_checklist_photos_preorder_order_id_fkey";

alter table "public"."order_checklist_photos" add constraint "order_checklist_photos_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) not valid;

alter table "public"."order_checklist_photos" validate constraint "order_checklist_photos_store_id_fkey";

alter table "public"."order_checklist_photos" add constraint "order_checklist_photos_uploaded_by_fkey" FOREIGN KEY (uploaded_by) REFERENCES public.users(id) not valid;

alter table "public"."order_checklist_photos" validate constraint "order_checklist_photos_uploaded_by_fkey";

alter table "public"."order_checklist_photos" add constraint "photo_type_check" CHECK ((photo_type = ANY (ARRAY['items'::text, 'market_slip'::text]))) not valid;

alter table "public"."order_checklist_photos" validate constraint "photo_type_check";

alter table "public"."order_deposits" add constraint "order_deposits_preorder_order_id_fkey" FOREIGN KEY (preorder_order_id) REFERENCES public.preorder_orders(id) ON DELETE CASCADE not valid;

alter table "public"."order_deposits" validate constraint "order_deposits_preorder_order_id_fkey";

alter table "public"."order_deposits" add constraint "order_deposits_verified_by_fkey" FOREIGN KEY (verified_by) REFERENCES public.users(id) not valid;

alter table "public"."order_deposits" validate constraint "order_deposits_verified_by_fkey";

alter table "public"."order_deposits" add constraint "payment_status_check" CHECK ((payment_status = ANY (ARRAY['pending'::text, 'paid'::text, 'failed'::text, 'refunded'::text]))) not valid;

alter table "public"."order_deposits" validate constraint "payment_status_check";

alter table "public"."order_discounts" add constraint "order_discounts_applied_by_fkey" FOREIGN KEY (applied_by) REFERENCES auth.users(id) not valid;

alter table "public"."order_discounts" validate constraint "order_discounts_applied_by_fkey";

alter table "public"."order_discounts" add constraint "order_discounts_discount_code_id_fkey" FOREIGN KEY (discount_code_id) REFERENCES public.discount_codes(id) not valid;

alter table "public"."order_discounts" validate constraint "order_discounts_discount_code_id_fkey";

alter table "public"."order_discounts" add constraint "order_discounts_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE not valid;

alter table "public"."order_discounts" validate constraint "order_discounts_order_id_fkey";

alter table "public"."order_item_options" add constraint "order_item_options_option_id_fkey" FOREIGN KEY (option_id) REFERENCES public.product_options(id) not valid;

alter table "public"."order_item_options" validate constraint "order_item_options_option_id_fkey";

alter table "public"."order_item_options" add constraint "order_item_options_order_item_id_fkey" FOREIGN KEY (order_item_id) REFERENCES public.order_items(id) ON DELETE CASCADE not valid;

alter table "public"."order_item_options" validate constraint "order_item_options_order_item_id_fkey";

alter table "public"."order_item_options" add constraint "order_item_options_selected_value_id_fkey" FOREIGN KEY (selected_value_id) REFERENCES public.product_option_values(id) not valid;

alter table "public"."order_item_options" validate constraint "order_item_options_selected_value_id_fkey";

alter table "public"."order_items" add constraint "order_items_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE not valid;

alter table "public"."order_items" validate constraint "order_items_order_id_fkey";

alter table "public"."order_items" add constraint "order_items_product_id_fkey" FOREIGN KEY (product_id) REFERENCES public.products(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."order_items" validate constraint "order_items_product_id_fkey";

alter table "public"."order_reviews" add constraint "order_reviews_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."order_reviews" validate constraint "order_reviews_customer_id_fkey";

alter table "public"."order_reviews" add constraint "order_reviews_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE not valid;

alter table "public"."order_reviews" validate constraint "order_reviews_order_id_fkey";

alter table "public"."order_reviews" add constraint "order_reviews_rating_check" CHECK (((rating >= (1)::numeric) AND (rating <= (5)::numeric))) not valid;

alter table "public"."order_reviews" validate constraint "order_reviews_rating_check";

alter table "public"."order_reviews" add constraint "order_reviews_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE not valid;

alter table "public"."order_reviews" validate constraint "order_reviews_store_id_fkey";

alter table "public"."order_reviews" add constraint "order_reviews_unique_order" UNIQUE using index "order_reviews_unique_order";

alter table "public"."order_rider_locations" add constraint "order_rider_locations_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE not valid;

alter table "public"."order_rider_locations" validate constraint "order_rider_locations_order_id_fkey";

alter table "public"."order_rider_locations" add constraint "order_rider_locations_rider_id_fkey" FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON DELETE CASCADE not valid;

alter table "public"."order_rider_locations" validate constraint "order_rider_locations_rider_id_fkey";

alter table "public"."order_status_history" add constraint "order_status_history_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE not valid;

alter table "public"."order_status_history" validate constraint "order_status_history_order_id_fkey";

alter table "public"."order_status_history" add constraint "order_status_history_updated_by_fkey" FOREIGN KEY (updated_by) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."order_status_history" validate constraint "order_status_history_updated_by_fkey";

alter table "public"."orders" add constraint "orders_cancelled_by_fkey" FOREIGN KEY (cancelled_by) REFERENCES public.users(id) not valid;

alter table "public"."orders" validate constraint "orders_cancelled_by_fkey";

alter table "public"."orders" add constraint "orders_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."orders" validate constraint "orders_customer_id_fkey";

alter table "public"."orders" add constraint "orders_discount_code_id_fkey" FOREIGN KEY (discount_code_id) REFERENCES public.discount_codes(id) not valid;

alter table "public"."orders" validate constraint "orders_discount_code_id_fkey";

alter table "public"."orders" add constraint "orders_order_number_key" UNIQUE using index "orders_order_number_key";

alter table "public"."orders" add constraint "orders_order_number_unique" UNIQUE using index "orders_order_number_unique";

alter table "public"."orders" add constraint "orders_payment_method_check" CHECK ((payment_method = ANY (ARRAY['cash'::text, 'bank_transfer'::text]))) not valid;

alter table "public"."orders" validate constraint "orders_payment_method_check";

alter table "public"."orders" add constraint "orders_payment_status_check" CHECK ((payment_status = ANY (ARRAY['pending'::text, 'paid'::text, 'failed'::text, 'cancelled'::text]))) not valid;

alter table "public"."orders" validate constraint "orders_payment_status_check";

alter table "public"."orders" add constraint "orders_rider_id_fkey" FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."orders" validate constraint "orders_rider_id_fkey";

alter table "public"."orders" add constraint "orders_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'accepted'::text, 'preparing'::text, 'ready'::text, 'assigned'::text, 'picked_up'::text, 'delivering'::text, 'delivered'::text, 'cancelled'::text, 'rejected'::text]))) not valid;

alter table "public"."orders" validate constraint "orders_status_check";

alter table "public"."orders" add constraint "orders_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."orders" validate constraint "orders_store_id_fkey";

alter table "public"."orders" add constraint "orders_transfer_confirmed_by_fkey" FOREIGN KEY (transfer_confirmed_by) REFERENCES public.users(id) not valid;

alter table "public"."orders" validate constraint "orders_transfer_confirmed_by_fkey";

alter table "public"."payment_history" add constraint "payment_history_action_check" CHECK ((action = ANY (ARRAY['payment_requested'::text, 'payment_confirmed'::text, 'payment_cancelled'::text, 'payment_collected_by_rider'::text]))) not valid;

alter table "public"."payment_history" validate constraint "payment_history_action_check";

alter table "public"."payment_history" add constraint "payment_history_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE not valid;

alter table "public"."payment_history" validate constraint "payment_history_order_id_fkey";

alter table "public"."payment_history" add constraint "payment_history_processed_by_fkey" FOREIGN KEY (processed_by) REFERENCES public.users(id) not valid;

alter table "public"."payment_history" validate constraint "payment_history_processed_by_fkey";

alter table "public"."preorder_items" add constraint "preorder_items_preorder_order_id_fkey" FOREIGN KEY (preorder_order_id) REFERENCES public.preorder_orders(id) ON DELETE CASCADE not valid;

alter table "public"."preorder_items" validate constraint "preorder_items_preorder_order_id_fkey";

alter table "public"."preorder_items" add constraint "preorder_items_product_id_fkey" FOREIGN KEY (product_id) REFERENCES public.products(id) not valid;

alter table "public"."preorder_items" validate constraint "preorder_items_product_id_fkey";

alter table "public"."preorder_items" add constraint "preorder_items_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) not valid;

alter table "public"."preorder_items" validate constraint "preorder_items_store_id_fkey";

alter table "public"."preorder_orders" add constraint "balance_collection_check" CHECK ((balance_collection_method = ANY (ARRAY['before_delivery'::text, 'on_delivery'::text]))) not valid;

alter table "public"."preorder_orders" validate constraint "balance_collection_check";

alter table "public"."preorder_orders" add constraint "deposit_status_check" CHECK ((deposit_status = ANY (ARRAY['pending'::text, 'paid'::text, 'forfeited'::text, 'refunded'::text]))) not valid;

alter table "public"."preorder_orders" validate constraint "deposit_status_check";

alter table "public"."preorder_orders" add constraint "preorder_orders_base_order_id_fkey" FOREIGN KEY (base_order_id) REFERENCES public.orders(id) not valid;

alter table "public"."preorder_orders" validate constraint "preorder_orders_base_order_id_fkey";

alter table "public"."preorder_orders" add constraint "preorder_orders_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES public.users(id) not valid;

alter table "public"."preorder_orders" validate constraint "preorder_orders_customer_id_fkey";

alter table "public"."preorder_orders" add constraint "preorder_orders_delivery_window_id_fkey" FOREIGN KEY (delivery_window_id) REFERENCES public.delivery_windows(id) not valid;

alter table "public"."preorder_orders" validate constraint "preorder_orders_delivery_window_id_fkey";

alter table "public"."preorder_orders" add constraint "preorder_orders_preorder_number_key" UNIQUE using index "preorder_orders_preorder_number_key";

alter table "public"."preorder_orders" add constraint "status_check" CHECK ((status = ANY (ARRAY['pending_deposit'::text, 'verifying_deposit'::text, 'deposit_confirmed'::text, 'preparing'::text, 'items_ready'::text, 'pending_balance'::text, 'ready_for_delivery'::text, 'delivering'::text, 'delivered'::text, 'cancelled'::text]))) not valid;

alter table "public"."preorder_orders" validate constraint "status_check";

alter table "public"."preorder_settings" add constraint "preorder_settings_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) not valid;

alter table "public"."preorder_settings" validate constraint "preorder_settings_store_id_fkey";

alter table "public"."product_option_values" add constraint "product_option_values_option_id_fkey" FOREIGN KEY (option_id) REFERENCES public.product_options(id) ON DELETE CASCADE not valid;

alter table "public"."product_option_values" validate constraint "product_option_values_option_id_fkey";

alter table "public"."product_options" add constraint "product_options_product_id_fkey" FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE not valid;

alter table "public"."product_options" validate constraint "product_options_product_id_fkey";

alter table "public"."products" add constraint "products_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE not valid;

alter table "public"."products" validate constraint "products_store_id_fkey";

alter table "public"."rider_assignments" add constraint "rider_assignments_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE not valid;

alter table "public"."rider_assignments" validate constraint "rider_assignments_order_id_fkey";

alter table "public"."rider_assignments" add constraint "rider_assignments_rider_id_fkey" FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON DELETE CASCADE not valid;

alter table "public"."rider_assignments" validate constraint "rider_assignments_rider_id_fkey";

alter table "public"."rider_assignments" add constraint "rider_assignments_rider_id_order_id_key" UNIQUE using index "rider_assignments_rider_id_order_id_key";

alter table "public"."rider_assignments" add constraint "rider_assignments_status_check" CHECK ((status = ANY (ARRAY['assigned'::text, 'picked_up'::text, 'delivering'::text, 'delivered'::text, 'cancelled'::text]))) not valid;

alter table "public"."rider_assignments" validate constraint "rider_assignments_status_check";

alter table "public"."rider_documents" add constraint "rider_documents_document_type_check" CHECK ((document_type = ANY (ARRAY['vehicle_photo'::text, 'license_plate'::text, 'driver_license'::text, 'car_tax'::text, 'insurance'::text, 'vehicle_registration'::text, 'id_card'::text, 'rider_application'::text]))) not valid;

alter table "public"."rider_documents" validate constraint "rider_documents_document_type_check";

alter table "public"."rider_documents" add constraint "rider_documents_rider_id_fkey" FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON DELETE CASCADE not valid;

alter table "public"."rider_documents" validate constraint "rider_documents_rider_id_fkey";

alter table "public"."rider_documents" add constraint "rider_documents_verified_by_fkey" FOREIGN KEY (verified_by) REFERENCES public.users(id) not valid;

alter table "public"."rider_documents" validate constraint "rider_documents_verified_by_fkey";

alter table "public"."rider_fcm_tokens" add constraint "rider_fcm_tokens_rider_id_fcm_token_key" UNIQUE using index "rider_fcm_tokens_rider_id_fcm_token_key";

alter table "public"."rider_fcm_tokens" add constraint "rider_fcm_tokens_rider_id_fkey" FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON DELETE CASCADE not valid;

alter table "public"."rider_fcm_tokens" validate constraint "rider_fcm_tokens_rider_id_fkey";

alter table "public"."rider_order_bookings" add constraint "rider_order_bookings_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE not valid;

alter table "public"."rider_order_bookings" validate constraint "rider_order_bookings_order_id_fkey";

alter table "public"."rider_order_bookings" add constraint "rider_order_bookings_rider_id_fkey" FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON DELETE CASCADE not valid;

alter table "public"."rider_order_bookings" validate constraint "rider_order_bookings_rider_id_fkey";

alter table "public"."rider_order_bookings" add constraint "rider_order_bookings_rider_id_order_id_key" UNIQUE using index "rider_order_bookings_rider_id_order_id_key";

alter table "public"."rider_order_bookings" add constraint "rider_order_bookings_status_check" CHECK ((status = ANY (ARRAY['booked'::text, 'assigned'::text, 'cancelled'::text, 'expired'::text]))) not valid;

alter table "public"."rider_order_bookings" validate constraint "rider_order_bookings_status_check";

alter table "public"."rider_reviews" add constraint "rider_reviews_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."rider_reviews" validate constraint "rider_reviews_customer_id_fkey";

alter table "public"."rider_reviews" add constraint "rider_reviews_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE not valid;

alter table "public"."rider_reviews" validate constraint "rider_reviews_order_id_fkey";

alter table "public"."rider_reviews" add constraint "rider_reviews_order_unique" UNIQUE using index "rider_reviews_order_unique";

alter table "public"."rider_reviews" add constraint "rider_reviews_rating_check" CHECK (((rating >= (1)::numeric) AND (rating <= (5)::numeric))) not valid;

alter table "public"."rider_reviews" validate constraint "rider_reviews_rating_check";

alter table "public"."rider_reviews" add constraint "rider_reviews_rider_id_fkey" FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON DELETE CASCADE not valid;

alter table "public"."rider_reviews" validate constraint "rider_reviews_rider_id_fkey";

alter table "public"."riders" add constraint "riders_driver_license_type_check" CHECK ((driver_license_type = ANY (ARRAY['car'::text, 'motorcycle'::text, 'both'::text]))) not valid;

alter table "public"."riders" validate constraint "riders_driver_license_type_check";

alter table "public"."riders" add constraint "riders_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."riders" validate constraint "riders_user_id_fkey";

alter table "public"."riders" add constraint "riders_vehicle_type_check" CHECK ((vehicle_type = ANY (ARRAY['motorcycle'::text, 'car'::text, 'bicycle'::text]))) not valid;

alter table "public"."riders" validate constraint "riders_vehicle_type_check";

alter table "public"."riders" add constraint "riders_verified_by_fkey" FOREIGN KEY (verified_by) REFERENCES public.users(id) not valid;

alter table "public"."riders" validate constraint "riders_verified_by_fkey";

alter table "public"."store_active_orders" add constraint "orders_payment_method_check" CHECK ((payment_method = ANY (ARRAY['cash'::text, 'bank_transfer'::text]))) not valid;

alter table "public"."store_active_orders" validate constraint "orders_payment_method_check";

alter table "public"."store_active_orders" add constraint "orders_payment_status_check" CHECK ((payment_status = ANY (ARRAY['pending'::text, 'paid'::text, 'failed'::text, 'cancelled'::text]))) not valid;

alter table "public"."store_active_orders" validate constraint "orders_payment_status_check";

alter table "public"."store_active_orders" add constraint "orders_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'accepted'::text, 'preparing'::text, 'ready'::text, 'assigned'::text, 'picked_up'::text, 'delivering'::text, 'delivered'::text, 'cancelled'::text, 'rejected'::text]))) not valid;

alter table "public"."store_active_orders" validate constraint "orders_status_check";

alter table "public"."store_active_orders" add constraint "store_active_orders_order_number_key" UNIQUE using index "store_active_orders_order_number_key";

alter table "public"."store_active_orders" add constraint "store_active_orders_order_number_key1" UNIQUE using index "store_active_orders_order_number_key1";

alter table "public"."store_bank_accounts" add constraint "store_bank_accounts_account_type_check" CHECK ((account_type = ANY (ARRAY['savings'::text, 'current'::text]))) not valid;

alter table "public"."store_bank_accounts" validate constraint "store_bank_accounts_account_type_check";

alter table "public"."store_bank_accounts" add constraint "store_bank_accounts_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE not valid;

alter table "public"."store_bank_accounts" validate constraint "store_bank_accounts_store_id_fkey";

alter table "public"."store_cancellation_requests" add constraint "store_cancellation_requests_cancellation_type_check" CHECK ((cancellation_type = ANY (ARRAY['out_of_stock'::text, 'store_closed'::text, 'technical_issue'::text, 'other'::text]))) not valid;

alter table "public"."store_cancellation_requests" validate constraint "store_cancellation_requests_cancellation_type_check";

alter table "public"."store_cancellation_requests" add constraint "store_cancellation_requests_order_id_fkey" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE not valid;

alter table "public"."store_cancellation_requests" validate constraint "store_cancellation_requests_order_id_fkey";

alter table "public"."store_cancellation_requests" add constraint "store_cancellation_requests_reviewed_by_fkey" FOREIGN KEY (reviewed_by) REFERENCES public.users(id) not valid;

alter table "public"."store_cancellation_requests" validate constraint "store_cancellation_requests_reviewed_by_fkey";

alter table "public"."store_cancellation_requests" add constraint "store_cancellation_requests_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text]))) not valid;

alter table "public"."store_cancellation_requests" validate constraint "store_cancellation_requests_status_check";

alter table "public"."store_cancellation_requests" add constraint "store_cancellation_requests_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE not valid;

alter table "public"."store_cancellation_requests" validate constraint "store_cancellation_requests_store_id_fkey";

alter table "public"."store_reports" add constraint "store_reports_handled_by_fkey" FOREIGN KEY (handled_by) REFERENCES public.users(id) not valid;

alter table "public"."store_reports" validate constraint "store_reports_handled_by_fkey";

alter table "public"."store_reports" add constraint "store_reports_report_type_check" CHECK ((report_type = ANY (ARRAY['food_quality'::text, 'service_issue'::text, 'hygiene'::text, 'fraud'::text, 'other'::text]))) not valid;

alter table "public"."store_reports" validate constraint "store_reports_report_type_check";

alter table "public"."store_reports" add constraint "store_reports_reporter_id_fkey" FOREIGN KEY (reporter_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."store_reports" validate constraint "store_reports_reporter_id_fkey";

alter table "public"."store_reports" add constraint "store_reports_severity_level_check" CHECK ((severity_level = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text, 'critical'::text]))) not valid;

alter table "public"."store_reports" validate constraint "store_reports_severity_level_check";

alter table "public"."store_reports" add constraint "store_reports_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'investigating'::text, 'resolved'::text, 'dismissed'::text]))) not valid;

alter table "public"."store_reports" validate constraint "store_reports_status_check";

alter table "public"."store_reports" add constraint "store_reports_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE not valid;

alter table "public"."store_reports" validate constraint "store_reports_store_id_fkey";

alter table "public"."store_suspension_history" add constraint "store_suspension_history_action_check" CHECK ((action = ANY (ARRAY['suspended'::text, 'unsuspended'::text]))) not valid;

alter table "public"."store_suspension_history" validate constraint "store_suspension_history_action_check";

alter table "public"."store_suspension_history" add constraint "store_suspension_history_store_id_fkey" FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE not valid;

alter table "public"."store_suspension_history" validate constraint "store_suspension_history_store_id_fkey";

alter table "public"."store_suspension_history" add constraint "store_suspension_history_suspended_by_fkey" FOREIGN KEY (suspended_by) REFERENCES public.users(id) not valid;

alter table "public"."store_suspension_history" validate constraint "store_suspension_history_suspended_by_fkey";

alter table "public"."store_suspension_history" add constraint "store_suspension_history_unsuspended_by_fkey" FOREIGN KEY (unsuspended_by) REFERENCES public.users(id) not valid;

alter table "public"."store_suspension_history" validate constraint "store_suspension_history_unsuspended_by_fkey";

alter table "public"."stores" add constraint "stores_code_store_key" UNIQUE using index "stores_code_store_key";

alter table "public"."stores" add constraint "stores_owner_id_fkey" FOREIGN KEY (owner_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."stores" validate constraint "stores_owner_id_fkey";

alter table "public"."stores" add constraint "stores_store_type_id_fkey" FOREIGN KEY (store_type_id) REFERENCES public.store_categories(id) not valid;

alter table "public"."stores" validate constraint "stores_store_type_id_fkey";

alter table "public"."stores" add constraint "stores_suspended_by_fkey" FOREIGN KEY (suspended_by) REFERENCES public.users(id) not valid;

alter table "public"."stores" validate constraint "stores_suspended_by_fkey";

alter table "public"."user_task_progress" add constraint "user_task_progress_max_progress_check" CHECK ((max_progress > 0)) not valid;

alter table "public"."user_task_progress" validate constraint "user_task_progress_max_progress_check";

alter table "public"."user_task_progress" add constraint "user_task_progress_progress_check" CHECK ((progress >= 0)) not valid;

alter table "public"."user_task_progress" validate constraint "user_task_progress_progress_check";

alter table "public"."user_task_progress" add constraint "user_task_progress_task_id_fkey" FOREIGN KEY (task_id) REFERENCES public.loyalty_tasks(id) ON DELETE CASCADE not valid;

alter table "public"."user_task_progress" validate constraint "user_task_progress_task_id_fkey";

alter table "public"."user_task_progress" add constraint "user_task_progress_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."user_task_progress" validate constraint "user_task_progress_user_id_fkey";

alter table "public"."user_task_progress" add constraint "user_task_progress_user_id_task_id_reset_period_start_key" UNIQUE using index "user_task_progress_user_id_task_id_reset_period_start_key";

alter table "public"."users" add constraint "users_auth_provider_check" CHECK (((google_id IS NOT NULL) OR (apple_id IS NOT NULL))) not valid;

alter table "public"."users" validate constraint "users_auth_provider_check";

alter table "public"."users" add constraint "users_email_key" UNIQUE using index "users_email_key";

alter table "public"."users" add constraint "users_google_id_key" UNIQUE using index "users_google_id_key";

alter table "public"."users" add constraint "users_role_check" CHECK ((role = ANY (ARRAY['customer'::text, 'store_owner'::text, 'rider'::text, 'admin'::text]))) not valid;

alter table "public"."users" validate constraint "users_role_check";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.accept_pending_order(p_order_id uuid, p_updated_by_user_id uuid DEFAULT NULL::uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_order_exists boolean;
    v_current_status text;
    v_result jsonb;
BEGIN
    -- ตรวจสอบว่าออเดอร์มีอยู่จริงหรือไม่
    SELECT EXISTS(SELECT 1 FROM public.orders WHERE id = p_order_id)
    INTO v_order_exists;
    
    IF NOT v_order_exists THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'ไม่พบออเดอร์ที่ระบุ',
            'order_id', p_order_id
        );
    END IF;
    
    -- ตรวจสอบสถานะปัจจุบัน
    SELECT status INTO v_current_status
    FROM public.orders
    WHERE id = p_order_id;
    
    IF v_current_status != 'pending' THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'ออเดอร์นี้ไม่ใช่สถานะ pending',
            'current_status', v_current_status,
            'order_id', p_order_id
        );
    END IF;
    
    -- อัปเดทสถานะเป็น accepted
    UPDATE public.orders
    SET 
        status = 'accepted',
        updated_at = now()
    WHERE id = p_order_id;
    
    -- บันทึกประวัติการเปลี่ยนแปลงสถานะ
    INSERT INTO public.order_status_history (
        order_id,
        status,
        changed_by,
        notes
    ) VALUES (
        p_order_id,
        'accepted',
        p_updated_by_user_id,
        'ออเดอร์ได้รับการยืนยันจากร้านค้า'
    );
    
    RETURN jsonb_build_object(
        'success', true,
        'message', 'ออเดอร์ได้รับการยืนยันเรียบร้อยแล้ว',
        'order_id', p_order_id,
        'new_status', 'accepted'
    );
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'เกิดข้อผิดพลาดในการอัปเดทสถานะ: ' || SQLERRM,
            'order_id', p_order_id
        );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.activate_user_by_admin(user_id_param uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    -- ตรวจสอบว่าเป็น admin หรือไม่
    IF NOT EXISTS (
        SELECT 1 FROM public.users 
        WHERE id = auth.uid() AND role = 'admin'
    ) THEN
        RAISE EXCEPTION 'Only admin can activate users';
    END IF;
    
    -- เปิดใช้งานผู้ใช้
    UPDATE public.users 
    SET 
        is_active = true,
        updated_at = NOW()
    WHERE id = user_id_param;
END;
$function$
;

create or replace view "public"."active_job_worker_fcm_tokens" as  SELECT jft.id,
    jft.worker_id,
    jft.fcm_token,
    jft.device_type,
    jft.is_active,
    jft.created_at,
    jft.updated_at,
    jw.user_id,
    u.full_name AS worker_name
   FROM ((public.job_worker_fcm_tokens jft
     JOIN public.job_workers jw ON ((jft.worker_id = jw.id)))
     JOIN public.users u ON ((jw.user_id = u.id)))
  WHERE (jft.is_active = true);


create or replace view "public"."active_rider_fcm_tokens" as  SELECT rt.id,
    rt.rider_id,
    rt.fcm_token,
    rt.device_type,
    rt.is_active,
    rt.created_at,
    rt.updated_at,
    r.user_id,
    r.is_available,
    u.full_name AS rider_name
   FROM ((public.rider_fcm_tokens rt
     JOIN public.riders r ON ((rt.rider_id = r.id)))
     JOIN public.users u ON ((r.user_id = u.id)))
  WHERE ((rt.is_active = true) AND (r.is_available = true));


CREATE OR REPLACE FUNCTION public.add_beauty_review(p_booking_id uuid, p_customer_name text, p_customer_email text, p_rating integer, p_review_text text DEFAULT NULL::text, p_review_images jsonb DEFAULT '[]'::jsonb, p_is_anonymous boolean DEFAULT false)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_booking_record RECORD;
    v_review_id uuid;
BEGIN
    -- ตรวจสอบว่าการจองมีอยู่และเสร็จสิ้นแล้ว
    SELECT * INTO v_booking_record
    FROM public.beauty_bookings
    WHERE id = p_booking_id AND booking_status = 'completed';
    
    IF v_booking_record IS NULL THEN
        RAISE EXCEPTION 'Booking not found or not completed';
    END IF;
    
    -- ตรวจสอบว่าไม่เคยรีวิวแล้ว
    IF EXISTS (
        SELECT 1 FROM public.beauty_reviews WHERE booking_id = p_booking_id
    ) THEN
        RAISE EXCEPTION 'Booking already has a review';
    END IF;
    
    -- เพิ่มรีวิว
    INSERT INTO public.beauty_reviews (
        booking_id,
        customer_name,
        customer_email,
        salon_id,
        service_id,
        staff_id,
        rating,
        review_text,
        review_images,
        is_anonymous
    ) VALUES (
        p_booking_id,
        p_customer_name,
        p_customer_email,
        v_booking_record.salon_id,
        v_booking_record.service_id,
        v_booking_record.staff_id,
        p_rating,
        p_review_text,
        p_review_images,
        p_is_anonymous
    ) RETURNING id INTO v_review_id;
    
    -- อัปเดตคะแนนช่าง
    UPDATE public.beauty_staff
    SET 
        rating = (
            SELECT AVG(rating) 
            FROM public.beauty_reviews 
            WHERE staff_id = v_booking_record.staff_id
        ),
        updated_at = now()
    WHERE id = v_booking_record.staff_id;
    
    RETURN v_review_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.add_delivery_note(p_user_id uuid, p_note_title text, p_note_content text, p_is_favorite boolean DEFAULT false)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    new_note_id uuid;
BEGIN
    -- ตรวจสอบว่ามีหมายเหตุซ้ำหรือไม่
    IF EXISTS (
        SELECT 1 FROM public.delivery_notes 
        WHERE user_id = p_user_id 
        AND note_content = p_note_content
    ) THEN
        -- ถ้ามีซ้ำ ให้อัปเดตจำนวนการใช้งาน
        UPDATE public.delivery_notes 
        SET 
            usage_count = usage_count + 1,
            last_used_at = now(),
            updated_at = now()
        WHERE user_id = p_user_id AND note_content = p_note_content
        RETURNING id INTO new_note_id;
    ELSE
        -- ถ้าไม่มีซ้ำ ให้สร้างใหม่
        INSERT INTO public.delivery_notes (
            user_id,
            note_title,
            note_content,
            is_favorite,
            usage_count,
            last_used_at
        ) VALUES (
            p_user_id,
            p_note_title,
            p_note_content,
            p_is_favorite,
            1,
            now()
        ) RETURNING id INTO new_note_id;
    END IF;
    
    RETURN new_note_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.add_option_value(p_option_id uuid, p_name text, p_price_adjustment numeric DEFAULT 0, p_is_default boolean DEFAULT false, p_display_order integer DEFAULT 0)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    value_id UUID;
BEGIN
    INSERT INTO product_option_values (
        option_id, name, price_adjustment, is_default, display_order
    ) VALUES (
        p_option_id, p_name, p_price_adjustment, p_is_default, p_display_order
    ) RETURNING id INTO value_id;
    
    RETURN value_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.add_order_review(p_order_id uuid, p_customer_id uuid, p_rating numeric, p_review_text text DEFAULT NULL::text, p_review_images text[] DEFAULT NULL::text[], p_is_anonymous boolean DEFAULT false)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_store_id uuid;
    v_review_id uuid;
BEGIN
    -- ตรวจสอบว่าออเดอร์มีอยู่และเป็นของลูกค้านี้
    SELECT store_id INTO v_store_id
    FROM public.orders
    WHERE id = p_order_id AND customer_id = p_customer_id;
    
    IF v_store_id IS NULL THEN
        RAISE EXCEPTION 'Order not found or does not belong to customer';
    END IF;
    
    -- ตรวจสอบว่าออเดอร์เสร็จสิ้นแล้ว
    IF NOT EXISTS (
        SELECT 1 FROM public.orders 
        WHERE id = p_order_id AND status = 'delivered'
    ) THEN
        RAISE EXCEPTION 'Order must be delivered before adding review';
    END IF;
    
    -- ตรวจสอบว่าไม่เคยรีวิวออเดอร์นี้แล้ว
    IF EXISTS (
        SELECT 1 FROM public.order_reviews WHERE order_id = p_order_id
    ) THEN
        RAISE EXCEPTION 'Order already has a review';
    END IF;
    
    -- เพิ่มรีวิว
    INSERT INTO public.order_reviews (
        order_id,
        customer_id,
        store_id,
        rating,
        review_text,
        review_images,
        is_anonymous
    ) VALUES (
        p_order_id,
        p_customer_id,
        v_store_id,
        p_rating,
        p_review_text,
        p_review_images,
        p_is_anonymous
    ) RETURNING id INTO v_review_id;
    
    RETURN v_review_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.add_rider_review(p_order_id uuid, p_customer_id uuid, p_rating numeric, p_review_text text DEFAULT NULL::text, p_review_images text[] DEFAULT NULL::text[], p_is_anonymous boolean DEFAULT false)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_rider_id uuid;
    v_review_id uuid;
BEGIN
    -- ตรวจสอบว่าออเดอร์มีอยู่และเป็นของลูกค้านี้
    SELECT rider_id INTO v_rider_id
    FROM public.orders
    WHERE id = p_order_id AND customer_id = p_customer_id;
    
    IF v_rider_id IS NULL THEN
        RAISE EXCEPTION 'Order not found or does not belong to customer';
    END IF;
    
    -- ตรวจสอบว่าออเดอร์เสร็จสิ้นแล้ว
    IF NOT EXISTS (
        SELECT 1 FROM public.orders 
        WHERE id = p_order_id AND status = 'delivered'
    ) THEN
        RAISE EXCEPTION 'Order must be delivered before adding review';
    END IF;
    
    -- ตรวจสอบว่าไม่เคยรีวิวออเดอร์นี้แล้ว
    IF EXISTS (
        SELECT 1 FROM public.rider_reviews WHERE order_id = p_order_id
    ) THEN
        RAISE EXCEPTION 'Order already has a rider review';
    END IF;
    
    -- เพิ่มรีวิว
    INSERT INTO public.rider_reviews (
        order_id,
        customer_id,
        rider_id,
        rating,
        review_text,
        review_images,
        is_anonymous
    ) VALUES (
        p_order_id,
        p_customer_id,
        v_rider_id,
        p_rating,
        p_review_text,
        p_review_images,
        p_is_anonymous
    ) RETURNING id INTO v_review_id;
    
    -- อัปเดตคะแนนไรเดอร์
    PERFORM public.update_rider_rating(v_rider_id, p_rating);
    
    RETURN v_review_id;
END;
$function$
;

create or replace view "public"."anonymous_order_reviews" as  SELECT rev.id,
    rev.order_id,
    rev.store_id,
    rev.rating,
    rev.review_text,
    rev.review_images,
    rev.created_at,
    o.order_number,
    s.name AS store_name,
    s.description AS store_description,
    s.logo_url AS store_image_url
   FROM ((public.order_reviews rev
     JOIN public.orders o ON ((rev.order_id = o.id)))
     JOIN public.stores s ON ((rev.store_id = s.id)))
  WHERE (rev.is_anonymous = true);


CREATE OR REPLACE FUNCTION public.apply_discount_code(p_order_id uuid, p_discount_code_id uuid, p_discount_amount numeric)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_discount_code record;
    v_order record;
BEGIN
    -- ตรวจสอบออเดอร์
    SELECT * INTO v_order FROM public.orders WHERE id = p_order_id;
    IF NOT FOUND THEN
        RETURN false;
    END IF;
    
    -- ตรวจสอบโค้ดส่วนลด
    SELECT * INTO v_discount_code FROM public.discount_codes WHERE id = p_discount_code_id;
    IF NOT FOUND THEN
        RETURN false;
    END IF;
    
    -- ตรวจสอบว่าใช้ได้หรือไม่
    IF NOT v_discount_code.is_active 
    OR v_discount_code.valid_from > now() 
    OR v_discount_code.valid_until < now()
    OR (v_discount_code.usage_limit IS NOT NULL AND v_discount_code.used_count >= v_discount_code.usage_limit) THEN
        RETURN false;
    END IF;
    
    -- บันทึกการใช้งานโค้ดส่วนลด
    INSERT INTO public.order_discounts (order_id, discount_code_id, discount_amount, applied_by)
    VALUES (p_order_id, p_discount_code_id, p_discount_amount, v_order.customer_id);
    
    -- บันทึกประวัติการใช้งาน
    INSERT INTO public.discount_code_usage (discount_code_id, user_id, order_id)
    VALUES (p_discount_code_id, v_order.customer_id, p_order_id);
    
    -- อัปเดตจำนวนการใช้งาน
    UPDATE public.discount_codes 
    SET used_count = used_count + 1,
        updated_at = now()
    WHERE id = p_discount_code_id;
    
    -- อัปเดตออเดอร์
    UPDATE public.orders 
    SET discount_code_id = p_discount_code_id,
        discount_code = v_discount_code.code,
        discount_description = v_discount_code.name,
        discount_amount = p_discount_amount,
        total_amount = total_amount - p_discount_amount,
        updated_at = now()
    WHERE id = p_order_id;
    
    RETURN true;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.approve_cancellation_request(request_uuid uuid, review_notes text DEFAULT NULL::text, reviewed_by_user_id uuid DEFAULT NULL::uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    assignment_uuid UUID;
    order_uuid UUID;
    rider_uuid UUID;
    cancellation_reason TEXT;
BEGIN
    -- อัปเดตสถานะคำขอ
    UPDATE cancellation_requests 
    SET 
        status = 'approved',
        reviewed_by = COALESCE(reviewed_by_user_id, (SELECT id FROM users WHERE role = 'admin' LIMIT 1)),
        reviewed_at = NOW(),
        review_notes = review_notes,
        updated_at = NOW()
    WHERE id = request_uuid;
    
    -- ดึงข้อมูล
    SELECT assignment_id, order_id, rider_id, reason 
    INTO assignment_uuid, order_uuid, rider_uuid, cancellation_reason
    FROM cancellation_requests WHERE id = request_uuid;
    
    -- ยกเลิกการมอบหมายงาน
    UPDATE rider_assignments 
    SET 
        status = 'cancelled',
        cancelled_at = NOW(),
        cancellation_reason = cancellation_reason,
        updated_at = NOW()
    WHERE id = assignment_uuid;
    
    -- อัปเดตคำสั่งซื้อกลับเป็น ready
    UPDATE orders 
    SET 
        rider_id = NULL,
        status = 'ready',
        updated_at = NOW()
    WHERE id = order_uuid;
    
    -- เพิ่มประวัติ
    INSERT INTO order_status_history (order_id, status, updated_by, notes)
    VALUES (order_uuid, 'ready', (SELECT user_id FROM riders WHERE id = rider_uuid), 
        'Rider assignment cancelled: ' || cancellation_reason);
    
    -- ส่งการแจ้งเตือน
    PERFORM send_notification(
        (SELECT customer_id FROM orders WHERE id = order_uuid),
        'การจัดส่งถูกยกเลิก',
        'ไดเดอร์ไม่สามารถจัดส่งได้ ระบบจะจัดหาไดเดอร์ใหม่ให้คุณ',
        'delivery_status',
        jsonb_build_object('order_id', order_uuid, 'reason', cancellation_reason)
    );
    
    PERFORM send_notification(
        (SELECT owner_id FROM stores WHERE id = (SELECT store_id FROM orders WHERE id = order_uuid)),
        'การจัดส่งถูกยกเลิก',
        'ไดเดอร์ไม่สามารถจัดส่งได้ ระบบจะจัดหาไดเดอร์ใหม่ให้คุณ',
        'delivery_status',
        jsonb_build_object('order_id', order_uuid, 'reason', cancellation_reason)
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.approve_store_cancellation_request(request_uuid uuid, review_notes text DEFAULT NULL::text, reviewed_by_user_id uuid DEFAULT NULL::uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    order_uuid UUID;
    store_uuid UUID;
    customer_uuid UUID;
    cancellation_reason TEXT;
BEGIN
    -- อัปเดตสถานะคำขอ
    UPDATE store_cancellation_requests 
    SET 
        status = 'approved',
        reviewed_by = COALESCE(reviewed_by_user_id, (SELECT id FROM users WHERE role = 'admin' LIMIT 1)),
        reviewed_at = NOW(),
        review_notes = review_notes,
        updated_at = NOW()
    WHERE id = request_uuid;
    
    -- ดึงข้อมูล
    SELECT order_id, store_id, reason 
    INTO order_uuid, store_uuid, cancellation_reason
    FROM store_cancellation_requests WHERE id = request_uuid;
    
    SELECT customer_id INTO customer_uuid FROM orders WHERE id = order_uuid;
    
    -- ยกเลิกออเดอร์
    UPDATE orders 
    SET 
        status = 'cancelled',
        updated_at = NOW()
    WHERE id = order_uuid;
    
    -- เพิ่มประวัติ
    INSERT INTO order_status_history (order_id, status, updated_by, notes)
    VALUES (order_uuid, 'cancelled', (SELECT owner_id FROM stores WHERE id = store_uuid), 
        'Order cancelled by store: ' || cancellation_reason);
    
    -- ส่งการแจ้งเตือนลูกค้า
    PERFORM send_notification(
        customer_uuid,
        'ออเดอร์ถูกยกเลิก',
        'ร้านค้าไม่สามารถดำเนินการออเดอร์ของคุณได้: ' || cancellation_reason,
        'order_update',
        jsonb_build_object('order_id', order_uuid, 'reason', cancellation_reason)
    );
    
    -- ถ้ามีไดเดอร์รับงานแล้ว ให้ยกเลิกงานด้วย
    UPDATE rider_assignments 
    SET 
        status = 'cancelled',
        cancelled_at = NOW(),
        cancellation_reason = 'Order cancelled by store',
        updated_at = NOW()
    WHERE order_id = order_uuid 
    AND status IN ('assigned', 'picked_up', 'delivering');
    
    -- แจ้งเตือนไดเดอร์
    PERFORM send_notification(
        (SELECT user_id FROM riders WHERE id = (
            SELECT rider_id FROM rider_assignments 
            WHERE order_id = order_uuid 
            AND status = 'cancelled'
            LIMIT 1
        )),
        'งานถูกยกเลิก',
        'ออเดอร์ถูกยกเลิกโดยร้านค้า',
        'delivery_status',
        jsonb_build_object('order_id', order_uuid)
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.assign_booked_orders_to_rider(p_rider_id uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_booking_record RECORD;
    v_assignment_id UUID;
    v_result JSONB;
    v_assignments_count INTEGER := 0;
BEGIN
    -- ดึงการจองที่พร้อมให้มอบหมาย (ออเดอร์สถานะ ready)
    FOR v_booking_record IN
        SELECT rob.id as booking_id, rob.order_id, rob.priority
        FROM rider_order_bookings rob
        JOIN orders o ON rob.order_id = o.id
        WHERE rob.rider_id = p_rider_id
        AND rob.status = 'booked'
        AND o.status = 'ready'
        AND o.rider_id IS NULL
        ORDER BY rob.priority ASC, rob.booked_at ASC
    LOOP
        -- ตรวจสอบว่าไรเดอร์ยังว่างอยู่
        IF EXISTS (
            SELECT 1 FROM rider_assignments 
            WHERE rider_id = p_rider_id 
            AND status IN ('assigned', 'picked_up', 'delivering')
        ) THEN
            EXIT; -- ออกจากลูปถ้าไรเดอร์มีงานแล้ว
        END IF;
        
        -- สร้างการมอบหมายงาน
        INSERT INTO rider_assignments (
            rider_id,
            order_id,
            status,
            assigned_at,
            created_at,
            updated_at
        ) VALUES (
            p_rider_id,
            v_booking_record.order_id,
            'assigned',
            NOW(),
            NOW(),
            NOW()
        ) RETURNING id INTO v_assignment_id;
        
        -- อัปเดตสถานะออเดอร์
        UPDATE orders 
        SET 
            rider_id = p_rider_id,
            status = 'assigned',
            updated_at = NOW()
        WHERE id = v_booking_record.order_id;
        
        -- อัปเดตสถานะการจอง
        UPDATE rider_order_bookings
        SET 
            status = 'assigned',
            assigned_at = NOW(),
            updated_at = NOW()
        WHERE id = v_booking_record.booking_id;
        
        v_assignments_count := v_assignments_count + 1;
    END LOOP;
    
    IF v_assignments_count > 0 THEN
        RETURN json_build_object(
            'success', true,
            'assignments_count', v_assignments_count,
            'message', 'มอบหมายงานสำเร็จ ' || v_assignments_count || ' ออเดอร์'
        );
    ELSE
        RETURN json_build_object(
            'success', false,
            'message', 'ไม่มีออเดอร์ที่พร้อมให้มอบหมาย'
        );
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', 'เกิดข้อผิดพลาด: ' || SQLERRM
        );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.assign_rider_to_order(order_uuid uuid)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    order_info RECORD;
    rider_info RECORD;
    result JSON;
BEGIN
    -- ดึงข้อมูลออเดอร์
    SELECT * INTO order_info FROM orders WHERE id = order_uuid;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'ไม่พบออเดอร์ที่ระบุ: %', order_uuid;
    END IF;
    
    -- ตรวจสอบสถานะออเดอร์
    IF order_info.status != 'ready' THEN
        RAISE EXCEPTION 'ออเดอร์ต้องมีสถานะ ready ก่อนที่จะมอบหมายให้ไรเดอร์';
    END IF;
    
    -- ค้นหาไรเดอร์ที่ว่างและใกล้ที่สุด
    SELECT 
        r.id,
        r.user_id,
        r.full_name,
        r.phone,
        r.current_latitude,
        r.current_longitude,
        r.status,
        -- คำนวณระยะทางจากไรเดอร์ไปยังร้านค้า
        ST_Distance(
            ST_MakePoint(r.current_longitude, r.current_latitude)::geography,
            ST_MakePoint(
                (SELECT longitude FROM stores WHERE id = order_info.store_id),
                (SELECT latitude FROM stores WHERE id = order_info.store_id)
            )::geography
        ) / 1000 AS distance_km
    INTO rider_info
    FROM riders r
    WHERE r.status = 'available' 
    AND r.is_verified = true
    AND r.is_active = true
    ORDER BY distance_km ASC
    LIMIT 1;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'ไม่พบไรเดอร์ที่ว่างในขณะนี้';
    END IF;
    
    -- อัปเดตสถานะออเดอร์เป็น assigned และกำหนดไรเดอร์
    UPDATE orders 
    SET 
        status = 'assigned',
        rider_id = rider_info.user_id,
        updated_at = NOW()
    WHERE id = order_uuid;
    
    -- เพิ่มประวัติการเปลี่ยนแปลงสถานะ
    INSERT INTO order_status_history (order_id, status, updated_by, notes)
    VALUES (order_uuid, 'assigned', rider_info.user_id, 'ไรเดอร์รับงาน: ' || rider_info.full_name);
    
    -- อัปเดตสถานะไรเดอร์เป็น busy
    UPDATE riders 
    SET 
        status = 'busy',
        updated_at = NOW()
    WHERE id = rider_info.id;
    
    -- สร้างการแจ้งเตือนให้ไรเดอร์
    PERFORM send_notification(
        rider_info.user_id,
        'order_assigned',
        'มีงานใหม่: ออเดอร์ #' || order_info.order_number,
        jsonb_build_object(
            'order_id', order_uuid,
            'order_number', order_info.order_number,
            'store_name', (SELECT name FROM stores WHERE id = order_info.store_id),
            'customer_address', order_info.customer_address,
            'total_amount', order_info.total_amount
        )
    );
    
    -- สร้างการแจ้งเตือนให้ลูกค้า
    PERFORM send_notification(
        order_info.customer_id,
        'order_update',
        'ไรเดอร์รับงานแล้ว: ออเดอร์ #' || order_info.order_number,
        jsonb_build_object(
            'order_id', order_uuid,
            'order_number', order_info.order_number,
            'status', 'assigned',
            'rider_name', rider_info.full_name
        )
    );
    
    -- สร้างการแจ้งเตือนให้ร้านค้า
    PERFORM send_notification(
        (SELECT owner_id FROM stores WHERE id = order_info.store_id),
        'order_update',
        'ไรเดอร์รับงานแล้ว: ออเดอร์ #' || order_info.order_number,
        jsonb_build_object(
            'order_id', order_uuid,
            'order_number', order_info.order_number,
            'status', 'assigned',
            'rider_name', rider_info.full_name
        )
    );
    
    -- สร้างผลลัพธ์
    result := jsonb_build_object(
        'success', true,
        'message', 'มอบหมายงานให้ไรเดอร์สำเร็จ',
        'order_id', order_uuid,
        'order_number', order_info.order_number,
        'rider_id', rider_info.user_id,
        'rider_name', rider_info.full_name,
        'rider_phone', rider_info.phone,
        'distance_km', rider_info.distance_km
    );
    
    RETURN result;
    
EXCEPTION
    WHEN OTHERS THEN
        -- สร้างผลลัพธ์ข้อผิดพลาด
        result := jsonb_build_object(
            'success', false,
            'message', SQLERRM,
            'order_id', order_uuid
        );
        
        RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.assign_rider_to_order(p_order_id uuid, p_rider_id uuid, p_status text DEFAULT 'assigned'::text)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_order_exists boolean;
    v_rider_exists boolean;
    v_assignment_exists boolean;
    v_assignment_id uuid;
    v_result json;
    v_order_status text;
BEGIN
    -- ตรวจสอบว่าออเดอร์มีอยู่จริง
    SELECT EXISTS(SELECT 1 FROM orders WHERE id = p_order_id) INTO v_order_exists;
    IF NOT v_order_exists THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Order not found',
            'order_id', p_order_id
        );
    END IF;

    -- ตรวจสอบว่ารายเดอร์มีอยู่จริง (ใช้ตาราง riders แทน rider_profiles)
    SELECT EXISTS(SELECT 1 FROM riders WHERE id = p_rider_id) INTO v_rider_exists;
    IF NOT v_rider_exists THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Rider not found',
            'rider_id', p_rider_id
        );
    END IF;

    -- ตรวจสอบสถานะออเดอร์
    SELECT status INTO v_order_status FROM orders WHERE id = p_order_id;
    IF v_order_status != 'ready' THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Order is not ready for assignment',
            'current_status', v_order_status
        );
    END IF;

    -- ตรวจสอบว่าออเดอร์ถูกมอบหมายแล้วหรือไม่
    SELECT EXISTS(SELECT 1 FROM rider_assignments WHERE order_id = p_order_id AND status IN ('assigned', 'picked_up', 'delivering')) INTO v_assignment_exists;
    IF v_assignment_exists THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Order is already assigned to another rider'
        );
    END IF;

    -- ตรวจสอบว่ารายเดอร์มีงานค้างอยู่หรือไม่
    IF EXISTS(SELECT 1 FROM rider_assignments WHERE rider_id = p_rider_id AND status IN ('assigned', 'picked_up', 'delivering')) THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Rider already has an active assignment'
        );
    END IF;

    -- เริ่ม transaction
    BEGIN
        -- สร้าง rider assignment
        INSERT INTO rider_assignments (
            rider_id,
            order_id,
            status,
            assigned_at,
            created_at,
            updated_at
        ) VALUES (
            p_rider_id,
            p_order_id,
            p_status,
            NOW(),
            NOW(),
            NOW()
        ) RETURNING id INTO v_assignment_id;

        -- อัปเดตสถานะออเดอร์
        UPDATE orders 
        SET 
            rider_id = p_rider_id,
            status = 'assigned',
            updated_at = NOW()
        WHERE id = p_order_id;

        -- สร้าง notification สำหรับร้านค้า (ถ้าตาราง notifications มีอยู่)
        BEGIN
            INSERT INTO notifications (
                user_id,
                title,
                message,
                type,
                related_id,
                created_at
            ) VALUES (
                (SELECT user_id FROM stores WHERE id = (SELECT store_id FROM orders WHERE id = p_order_id)),
                'ไรเดอร์รับงานแล้ว',
                'ไรเดอร์ได้รับงานหมายเลข ' || (SELECT order_number FROM orders WHERE id = p_order_id),
                'order_assigned',
                p_order_id,
                NOW()
            );
        EXCEPTION
            WHEN OTHERS THEN
                -- ถ้าตาราง notifications ไม่มีอยู่ ให้ข้ามไป
                NULL;
        END;

        -- สร้าง notification สำหรับลูกค้า (ถ้าตาราง notifications มีอยู่)
        BEGIN
            INSERT INTO notifications (
                user_id,
                title,
                message,
                type,
                related_id,
                created_at
            ) VALUES (
                (SELECT customer_id FROM orders WHERE id = p_order_id),
                'ไรเดอร์กำลังมา',
                'ไรเดอร์ได้รับงานของคุณแล้ว และกำลังเดินทางมาส่ง',
                'rider_assigned',
                p_order_id,
                NOW()
            );
        EXCEPTION
            WHEN OTHERS THEN
                -- ถ้าตาราง notifications ไม่มีอยู่ ให้ข้ามไป
                NULL;
        END;

        -- สร้างผลลัพธ์
        v_result := json_build_object(
            'success', true,
            'assignment_id', v_assignment_id,
            'order_id', p_order_id,
            'rider_id', p_rider_id,
            'status', p_status,
            'message', 'Order assigned successfully'
        );

        RETURN v_result;

    EXCEPTION
        WHEN OTHERS THEN
            -- Rollback จะเกิดขึ้นโดยอัตโนมัติ
            RETURN json_build_object(
                'success', false,
                'error', SQLERRM,
                'detail', SQLSTATE
            );
    END;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.assign_rider_to_order_new(rider_uuid uuid, order_uuid uuid)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    assignment_id UUID;
    order_status TEXT;
    rider_user_id UUID;
BEGIN
    -- ตรวจสอบสถานะออเดอร์
    SELECT status INTO order_status
    FROM orders
    WHERE id = order_uuid;
    
    -- ตรวจสอบว่าออเดอร์พร้อมให้ไรเดอร์รับ
    IF order_status NOT IN ('ready', 'waiting_rider_payment') THEN
        RAISE EXCEPTION 'Order is not ready for assignment. Current status: %', order_status;
    END IF;
    
    -- ตรวจสอบว่าไรเดอร์ว่างอยู่หรือไม่
    IF NOT EXISTS (
        SELECT 1 FROM riders 
        WHERE id = rider_uuid 
        AND is_available = true 
        AND documents_verified = true
    ) THEN
        RAISE EXCEPTION 'Rider is not available or documents not verified';
    END IF;
    
    -- ตรวจสอบว่าไรเดอร์มีงานค้างอยู่หรือไม่
    IF EXISTS (
        SELECT 1 FROM rider_assignments 
        WHERE rider_id = rider_uuid 
        AND status IN ('assigned', 'picked_up', 'delivering')
    ) THEN
        RAISE EXCEPTION 'Rider already has an active assignment';
    END IF;
    
    -- ตรวจสอบว่าออเดอร์ยังไม่ถูกมอบหมาย
    IF EXISTS (
        SELECT 1 FROM rider_assignments 
        WHERE order_id = order_uuid 
        AND status IN ('assigned', 'picked_up', 'delivering')
    ) THEN
        RAISE EXCEPTION 'Order is already assigned to another rider';
    END IF;
    
    -- สร้างการมอบหมายงาน
    INSERT INTO rider_assignments (rider_id, order_id, status)
    VALUES (rider_uuid, order_uuid, 'assigned')
    RETURNING id INTO assignment_id;
    
    -- อัปเดตสถานะออเดอร์
    PERFORM update_order_status_new(order_uuid, 'assigned', 
        (SELECT user_id FROM riders WHERE id = rider_uuid),
        'Rider assigned to order'
    );
    
    -- อัปเดตข้อมูลไรเดอร์ในออเดอร์
    UPDATE orders 
    SET rider_id = rider_uuid, updated_at = NOW()
    WHERE id = order_uuid;
    
    RETURN assignment_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.auto_update_fcm_tokens()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    rider_fcm TEXT;
    customer_fcm TEXT;
BEGIN
    -- ถ้า recipient_fcm_token เป็น null ให้อัปเดตทันที
    IF NEW.recipient_fcm_token IS NULL OR NEW.recipient_fcm_token = '' THEN
        IF NEW.sender_type = 'customer' THEN
            -- อัปเดต recipient_fcm_token สำหรับข้อความของลูกค้า
            rider_fcm := (
                SELECT u.fcm_token
                FROM users u
                JOIN rider_profile_view rpv ON u.id = rpv.user_id
                JOIN rider_assignments ra ON rpv.rider_id = ra.rider_id
                WHERE ra.order_id = NEW.order_id
                AND ra.status IN ('assigned', 'picked_up', 'delivering', 'completed')
                AND u.fcm_token IS NOT NULL
                AND u.fcm_token != ''
                ORDER BY ra.created_at DESC
                LIMIT 1
            );
            
            IF rider_fcm IS NOT NULL THEN
                UPDATE chat_messages 
                SET recipient_fcm_token = rider_fcm
                WHERE id = NEW.id;
            END IF;
        ELSIF NEW.sender_type = 'rider' THEN
            -- อัปเดต recipient_fcm_token สำหรับข้อความของไรเดอร์
            customer_fcm := (
                SELECT u.fcm_token
                FROM users u
                JOIN orders o ON u.id = o.customer_id
                WHERE o.id = NEW.order_id
                AND u.fcm_token IS NOT NULL
                AND u.fcm_token != ''
                LIMIT 1
            );
            
            IF customer_fcm IS NOT NULL THEN
                UPDATE chat_messages 
                SET recipient_fcm_token = customer_fcm
                WHERE id = NEW.id;
            END IF;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$function$
;

create or replace view "public"."available_jobs_count" as  SELECT (count(*))::integer AS total_count
   FROM (public.job_postings jp
     JOIN public.job_categories jc ON ((jp.category_id = jc.id)))
  WHERE ((jp.status = 'published'::text) AND (jp.worker_id IS NULL) AND (jc.is_active = true));


create or replace view "public"."available_orders_for_riders" as  SELECT o.id AS order_id,
    o.order_number,
    o.total_amount,
    o.subtotal,
    o.discount_amount,
    o.discount_code,
    o.discount_description,
    o.delivery_address,
    o.delivery_latitude,
    o.delivery_longitude,
    o.delivery_fee,
    o.calculated_delivery_fee,
    o.distance_km,
    o.delivery_line_id,
    o.payment_method,
    o.payment_status,
    o.created_at,
    o.updated_at,
    o.estimated_delivery_time,
    o.actual_delivery_time,
    o.special_instructions,
    o.bank_account_number,
    o.bank_account_name,
    o.transfer_amount,
    o.transfer_reference,
    o.bank_name,
    o.cancellation_reason,
    o.cancelled_by,
    o.cancelled_at,
    s.id AS store_id,
    s.name AS store_name,
    s.address AS store_address,
    s.phone AS store_phone,
    s.latitude AS store_latitude,
    s.longitude AS store_longitude,
    u.full_name AS customer_name,
    u.phone AS customer_phone,
    u.email AS customer_email,
    u.line_id AS customer_line_id
   FROM ((public.orders o
     JOIN public.stores s ON ((o.store_id = s.id)))
     JOIN public.users u ON ((o.customer_id = u.id)))
  WHERE ((o.status = ANY (ARRAY['ready'::text, 'waiting_rider_payment'::text])) AND (o.rider_id IS NULL) AND (s.is_active = true))
  ORDER BY o.created_at;


create or replace view "public"."available_riders" as  SELECT r.id AS rider_id,
    r.user_id,
    r.is_available,
    r.current_location,
    r.rating,
    r.total_deliveries,
    r.total_earnings,
    r.vehicle_type,
    r.license_plate,
    r.documents_verified,
    r.created_at,
    r.updated_at,
    u.full_name AS rider_name,
    u.phone AS rider_phone,
    u.email AS rider_email,
    u.line_id AS rider_line_id,
    u.google_picture AS rider_google_picture,
    u.avatar_url AS rider_avatar_url,
    latest_order.discount_code,
    latest_order.discount_description,
    latest_order.discount_amount
   FROM ((public.riders r
     JOIN public.users u ON ((r.user_id = u.id)))
     LEFT JOIN ( SELECT DISTINCT ON (o.rider_id) o.rider_id,
            o.discount_code,
            o.discount_description,
            o.discount_amount
           FROM public.orders o
          WHERE ((o.rider_id IS NOT NULL) AND (o.discount_code IS NOT NULL))
          ORDER BY o.rider_id, o.created_at DESC) latest_order ON ((r.id = latest_order.rider_id)))
  WHERE ((r.is_available = true) AND (r.documents_verified = true) AND (NOT (EXISTS ( SELECT 1
           FROM public.rider_assignments ra
          WHERE ((ra.rider_id = r.id) AND (ra.status = ANY (ARRAY['assigned'::text, 'picked_up'::text, 'delivering'::text])))))))
  ORDER BY r.rating DESC, r.total_deliveries DESC;


CREATE OR REPLACE FUNCTION public.award_credit_on_job_approval()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_worker_id uuid;
    v_credit_amount numeric(10,2);
    v_current_balance numeric(10,2);
    v_new_balance numeric(10,2);
    v_job_assignment_id uuid;
BEGIN
    -- ตรวจสอบว่าสถานะเปลี่ยนเป็น 'approved' และยังไม่ได้โอนเครดิต
    IF NEW.approval_status = 'approved' 
       AND OLD.approval_status != 'approved' 
       AND NEW.credit_transferred = false THEN
        
        v_worker_id := NEW.worker_id;
        v_credit_amount := NEW.credit_amount;
        v_job_assignment_id := NEW.job_assignment_id;

        -- 1. อัพเดท job_completion_approvals - บันทึกว่าโอนเครดิตแล้ว
        UPDATE public.job_completion_approvals
        SET 
            credit_transferred = true,
            credit_transferred_at = now(),
            updated_at = now()
        WHERE id = NEW.id;

        -- 2. อัพเดทหรือสร้าง job_worker_credits record
        INSERT INTO public.job_worker_credits (
            worker_id,
            available_balance,
            pending_balance,
            total_earned,
            last_transaction_at,
            updated_at
        )
        VALUES (
            v_worker_id,
            v_credit_amount,  -- เริ่มต้นด้วย credit_amount
            0,
            NEW.job_price,    -- total_earned = job_price
            now(),
            now()
        )
        ON CONFLICT (worker_id) 
        DO UPDATE SET
            available_balance = job_worker_credits.available_balance + v_credit_amount,
            total_earned = job_worker_credits.total_earned + NEW.job_price,
            last_transaction_at = now(),
            updated_at = now();

        -- 3. ดึงยอดคงเหลือปัจจุบันหลังจากเพิ่มเครดิต
        SELECT available_balance INTO v_new_balance
        FROM public.job_worker_credits
        WHERE worker_id = v_worker_id;

        -- 4. อัพเดท job_workers (credit_balance, total_earnings, total_jobs)
        UPDATE public.job_workers
        SET 
            credit_balance = COALESCE(credit_balance, 0) + v_credit_amount,
            total_earnings = COALESCE(total_earnings, 0) + NEW.job_price,
            total_jobs = COALESCE(total_jobs, 0) + 1,
            updated_at = now()
        WHERE id = v_worker_id;

        -- 5. บันทึก Credit transaction ใน ledger
        INSERT INTO public.job_worker_credit_ledger (
            worker_id,
            job_assignment_id,
            transaction_type,
            amount,
            balance_after,
            reason_code,
            description,
            created_at
        )
        VALUES (
            v_worker_id,
            v_job_assignment_id,
            'credit',
            v_credit_amount,
            v_new_balance,
            'JOB_COMPLETED',
            'โอนเครดิตจากงาน: ' || COALESCE(NEW.job_number, 'ไม่ระบุเลขที่'),
            now()
        );

        -- 6. บันทึก Fee transaction (ถ้ามีค่าธรรมเนียม)
        IF NEW.platform_fee_amount > 0 THEN
            INSERT INTO public.job_worker_credit_ledger (
                worker_id,
                job_assignment_id,
                transaction_type,
                amount,
                balance_after,
                reason_code,
                description,
                created_at
            )
            VALUES (
                v_worker_id,
                v_job_assignment_id,
                'fee',
                -NEW.platform_fee_amount,  -- เป็นลบเพราะเป็นค่าธรรมเนียม
                v_new_balance,
                'PLATFORM_FEE',
                'ค่าธรรมเนียมแพลตฟอร์มจากงาน: ' || COALESCE(NEW.job_number, 'ไม่ระบุเลขที่'),
                now()
            );
        END IF;

    END IF;

    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.award_order_delivery_points()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_rule public.loyalty_point_rules;
    v_amount_unit numeric;
    v_points_unit integer;
    v_awarded_points integer;
BEGIN
    IF NEW.status = 'delivered' AND (OLD.status IS DISTINCT FROM 'delivered') AND NEW.customer_id IS NOT NULL THEN
        SELECT *
        INTO v_rule
        FROM public.loyalty_point_rules
        WHERE trigger_event = 'ORDER_DELIVERED'
          AND is_active
          AND (effective_from IS NULL OR effective_from <= now())
          AND (effective_to IS NULL OR effective_to >= now())
        ORDER BY effective_from DESC NULLS LAST
        LIMIT 1;

        IF FOUND THEN
            v_amount_unit := NULLIF((v_rule.conditions ->> 'amount_per_unit')::numeric, 0);
            v_points_unit := COALESCE((v_rule.conditions ->> 'points_per_unit')::integer, v_rule.points_awarded);

            IF v_amount_unit IS NOT NULL THEN
                v_awarded_points := FLOOR((NEW.total_amount / v_amount_unit) * v_points_unit)::integer;
            ELSE
                v_awarded_points := v_rule.points_awarded;
            END IF;

            IF COALESCE(v_awarded_points, 0) <= 0 THEN
                RETURN NEW;
            END IF;

            INSERT INTO public.loyalty_point_ledger (
                user_id,
                order_id,
                transaction_type,
                points_change,
                reason_code,
                description
            )
            VALUES (
                NEW.customer_id,
                NEW.id,
                'earn',
                v_awarded_points,
                v_rule.rule_code,
                COALESCE(v_rule.description, 'Earned from delivered order')
            )
            ON CONFLICT (order_id, reason_code) DO NOTHING;
        END IF;
    END IF;

    RETURN NEW;
END;
$function$
;

create or replace view "public"."beauty_bookings_with_details" as  SELECT bb.id,
    bb.booking_number,
    bb.customer_name,
    bb.customer_email,
    bb.customer_phone,
    bb.customer_line_id,
    bb.salon_id,
    bb.service_id,
    bb.staff_id,
    bb.booking_date,
    bb.booking_time,
    bb.duration_minutes,
    bb.customer_count,
    bb.total_amount,
    bb.payment_method,
    bb.payment_status,
    bb.booking_status,
    bb.special_requests,
    bb.cancellation_reason,
    bb.cancelled_at,
    bb.created_at,
    bb.updated_at,
    bs.salon_name,
    bs.address AS salon_address,
    bsv.service_name,
    bsv.category AS service_category,
    bst.full_name AS staff_name,
    bst.phone AS staff_phone
   FROM (((public.beauty_bookings bb
     JOIN public.beauty_salons bs ON ((bb.salon_id = bs.id)))
     JOIN public.beauty_services bsv ON ((bb.service_id = bsv.id)))
     LEFT JOIN public.beauty_staff bst ON ((bb.staff_id = bst.id)));


create or replace view "public"."beauty_salons_with_owner" as  SELECT bs.id,
    bs.owner_id,
    bs.owner_name,
    bs.owner_email,
    bs.owner_phone,
    bs.salon_name,
    bs.description,
    bs.address,
    bs.phone,
    bs.email,
    bs.website,
    bs.latitude,
    bs.longitude,
    bs.opening_hours,
    bs.holidays,
    bs.amenities,
    bs.images,
    bs.policies,
    bs.verification_documents,
    bs.is_active,
    bs.is_verified,
    bs.verification_status,
    bs.created_at,
    bs.updated_at,
    boa.email AS account_email,
    boa.is_active AS owner_active
   FROM (public.beauty_salons bs
     LEFT JOIN public.beauty_owner_accounts boa ON ((bs.id = boa.salon_id)));


create or replace view "public"."beauty_services_with_salon" as  SELECT bsv.id,
    bsv.salon_id,
    bsv.service_name,
    bsv.description,
    bsv.category,
    bsv.duration_minutes,
    bsv.price,
    bsv.images,
    bsv.is_active,
    bsv.requires_advance_booking,
    bsv.max_customers_per_slot,
    bsv.min_age,
    bsv.is_featured,
    bsv.created_at,
    bsv.updated_at,
    bs.salon_name,
    bs.address AS salon_address
   FROM (public.beauty_services bsv
     JOIN public.beauty_salons bs ON ((bsv.salon_id = bs.id)));


create or replace view "public"."beauty_staff_with_salon" as  SELECT bst.id,
    bst.salon_id,
    bst.user_id,
    bst.full_name,
    bst.phone,
    bst.email,
    bst.avatar_url,
    bst.specialties,
    bst.experience_years,
    bst.working_hours,
    bst.is_active,
    bst.is_verified,
    bst.rating,
    bst.total_bookings,
    bst.created_at,
    bst.updated_at,
    bs.salon_name,
    bs.address AS salon_address
   FROM (public.beauty_staff bst
     JOIN public.beauty_salons bs ON ((bst.salon_id = bs.id)));


CREATE OR REPLACE FUNCTION public.book_order_for_rider(p_rider_id uuid, p_order_id uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_booking_id UUID;
    v_store_id UUID;
    v_existing_bookings_count INTEGER;
    v_order_status TEXT;
    v_rider_available BOOLEAN;
    v_documents_verified BOOLEAN;
    v_booking_count INTEGER;
    v_result JSONB;
BEGIN
    -- ตรวจสอบสถานะออเดอร์
    SELECT status, store_id INTO v_order_status, v_store_id
    FROM orders
    WHERE id = p_order_id;
    
    IF v_order_status IS NULL THEN
        RETURN json_build_object(
            'success', false,
            'error', 'ไม่พบออเดอร์'
        );
    END IF;
    
    -- ตรวจสอบว่าออเดอร์พร้อมให้จองหรือไม่
    IF v_order_status NOT IN ('pending', 'accepted', 'preparing') THEN
        RETURN json_build_object(
            'success', false,
            'error', 'ออเดอร์ไม่พร้อมให้จอง (สถานะ: ' || v_order_status || ')'
        );
    END IF;
    
    -- ตรวจสอบว่าไรเดอร์ว่างและเอกสารผ่านการตรวจสอบ
    SELECT is_available, documents_verified INTO v_rider_available, v_documents_verified
    FROM riders
    WHERE id = p_rider_id;
    
    IF NOT v_rider_available OR NOT v_documents_verified THEN
        RETURN json_build_object(
            'success', false,
            'error', 'ไรเดอร์ไม่พร้อมรับงาน (ว่าง: ' || v_rider_available || ', เอกสารผ่าน: ' || v_documents_verified || ')'
        );
    END IF;
    
    -- ตรวจสอบจำนวนการจองของไรเดอร์ในร้านเดียวกัน
    SELECT COUNT(*) INTO v_booking_count
    FROM rider_order_bookings rob
    JOIN orders o ON rob.order_id = o.id
    WHERE rob.rider_id = p_rider_id 
    AND o.store_id = v_store_id
    AND rob.status = 'booked';
    
    IF v_booking_count >= 3 THEN
        RETURN json_build_object(
            'success', false,
            'error', 'ไรเดอร์จองออเดอร์ในร้านนี้ครบ 3 ออเดอร์แล้ว'
        );
    END IF;
    
    -- ตรวจสอบว่าออเดอร์ถูกจองแล้วหรือไม่
    IF EXISTS (
        SELECT 1 FROM rider_order_bookings 
        WHERE order_id = p_order_id AND status = 'booked'
    ) THEN
        RETURN json_build_object(
            'success', false,
            'error', 'ออเดอร์นี้ถูกจองแล้ว'
        );
    END IF;
    
    -- ตรวจสอบว่าไรเดอร์มีงานที่กำลังทำอยู่หรือไม่
    IF EXISTS (
        SELECT 1 FROM rider_assignments 
        WHERE rider_id = p_rider_id 
        AND status IN ('assigned', 'picked_up', 'delivering')
    ) THEN
        RETURN json_build_object(
            'success', false,
            'error', 'ไรเดอร์มีงานที่กำลังทำอยู่'
        );
    END IF;
    
    -- สร้างการจอง
    INSERT INTO rider_order_bookings (
        rider_id,
        order_id,
        status,
        priority,
        booked_at,
        expires_at,
        created_at,
        updated_at
    ) VALUES (
        p_rider_id,
        p_order_id,
        'booked',
        v_booking_count + 1,
        NOW(),
        NOW() + INTERVAL '30 minutes',
        NOW(),
        NOW()
    ) RETURNING id INTO v_booking_id;
    
    RETURN json_build_object(
        'success', true,
        'booking_id', v_booking_id,
        'message', 'จองออเดอร์สำเร็จ'
    );
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', 'เกิดข้อผิดพลาด: ' || SQLERRM
        );
END;
$function$
;

create or replace view "public"."bookable_orders_for_riders" as  SELECT o.id AS order_id,
    o.order_number,
    o.total_amount,
    o.subtotal,
    o.delivery_address,
    o.delivery_latitude,
    o.delivery_longitude,
    o.delivery_fee,
    o.calculated_delivery_fee,
    o.distance_km,
    o.delivery_line_id,
    o.payment_method,
    o.payment_status,
    o.created_at,
    o.updated_at,
    o.estimated_delivery_time,
    o.actual_delivery_time,
    o.special_instructions,
    o.bank_account_number,
    o.bank_account_name,
    o.transfer_amount,
    o.transfer_reference,
    o.bank_name,
    o.cancellation_reason,
    o.cancelled_by,
    o.cancelled_at,
    s.id AS store_id,
    s.name AS store_name,
    s.address AS store_address,
    s.phone AS store_phone,
    s.latitude AS store_latitude,
    s.longitude AS store_longitude,
    u.full_name AS customer_name,
    u.phone AS customer_phone,
    u.email AS customer_email,
    u.line_id AS customer_line_id
   FROM ((public.orders o
     JOIN public.stores s ON ((o.store_id = s.id)))
     JOIN public.users u ON ((o.customer_id = u.id)))
  WHERE ((o.status = ANY (ARRAY['pending'::text, 'accepted'::text, 'preparing'::text])) AND (o.rider_id IS NULL) AND (s.is_active = true) AND (NOT (EXISTS ( SELECT 1
           FROM public.rider_order_bookings rob
          WHERE ((rob.order_id = o.id) AND (rob.status = 'booked'::text))))))
  ORDER BY o.created_at;


CREATE OR REPLACE FUNCTION public.calculate_age(birth_date date)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN EXTRACT(YEAR FROM AGE(birth_date));
END;
$function$
;

CREATE OR REPLACE FUNCTION public.calculate_delivery_fee(store_latitude numeric, store_longitude numeric, delivery_latitude numeric, delivery_longitude numeric, subtotal numeric, order_time timestamp with time zone DEFAULT now())
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    fee_settings RECORD;
    distance_km DECIMAL;
    base_fee DECIMAL;
    distance_fee DECIMAL;
    total_fee DECIMAL;
    peak_multiplier DECIMAL;
    order_time_value TIME;
    result JSONB;
BEGIN
    -- ดึงการตั้งค่าค่าส่งที่ใช้งานอยู่
    SELECT * INTO fee_settings 
    FROM delivery_fee_settings 
    WHERE is_active = true 
    ORDER BY is_default DESC, created_at DESC 
    LIMIT 1;
    
    -- ถ้าไม่มีข้อมูลการตั้งค่า ให้ใช้ค่าเริ่มต้น
    IF fee_settings IS NULL THEN
        fee_settings.base_fee := 30;
        fee_settings.distance_fee_per_km := 5;
        fee_settings.max_delivery_distance := 10;
        fee_settings.free_delivery_threshold := 0;
        fee_settings.peak_hour_multiplier := 1.0;
    END IF;
    
    -- คำนวณระยะทาง (กิโลเมตร)
    distance_km := (
        6371 * acos(
            cos(radians(store_latitude)) * 
            cos(radians(delivery_latitude)) * 
            cos(radians(delivery_longitude) - radians(store_longitude)) + 
            sin(radians(store_latitude)) * 
            sin(radians(delivery_latitude))
        )
    );
    
    -- ตรวจสอบระยะการจัดส่งสูงสุด
    IF distance_km > fee_settings.max_delivery_distance THEN
        RAISE EXCEPTION 'ระยะการจัดส่งเกินกว่าที่กำหนด (% km)', fee_settings.max_delivery_distance;
    END IF;
    
    -- ตรวจสอบค่าส่งฟรี
    IF subtotal >= fee_settings.free_delivery_threshold AND fee_settings.free_delivery_threshold > 0 THEN
        total_fee := 0;
    ELSE
        -- คำนวณค่าส่งพื้นฐาน
        base_fee := fee_settings.base_fee;
        
        -- คำนวณค่าส่งตามระยะทาง
        distance_fee := distance_km * fee_settings.distance_fee_per_km;
        
        -- คำนวณค่าส่งรวม
        total_fee := base_fee + distance_fee;
        
        -- ตรวจสอบช่วงเวลาเร่งด่วน
        order_time_value := order_time::TIME;
        IF order_time_value >= fee_settings.peak_hour_start AND order_time_value <= fee_settings.peak_hour_end THEN
            peak_multiplier := fee_settings.peak_hour_multiplier;
            total_fee := total_fee * peak_multiplier;
        END IF;
    END IF;
    
    -- สร้างผลลัพธ์
    result := jsonb_build_object(
        'delivery_fee', total_fee,
        'distance_km', distance_km,
        'base_fee', base_fee,
        'distance_fee', distance_fee,
        'peak_multiplier', COALESCE(peak_multiplier, 1.0),
        'is_free_delivery', (subtotal >= fee_settings.free_delivery_threshold AND fee_settings.free_delivery_threshold > 0),
        'free_delivery_threshold', fee_settings.free_delivery_threshold,
        'max_delivery_distance', fee_settings.max_delivery_distance
    );
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.calculate_delivery_fee_v2(p_distance_km numeric, p_subtotal numeric DEFAULT 0, p_order_time timestamp with time zone DEFAULT now())
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_config public.delivery_fee_config_v2%ROWTYPE;
    v_tier public.delivery_fee_tiers%ROWTYPE;
    v_fee numeric(10,2) := 0;
    v_base_fee numeric(10,2) := 0;
    v_is_peak_hour boolean := false;
    v_is_free_delivery boolean := false;
    v_result jsonb;
BEGIN
    -- ดึงการตั้งค่าที่ใช้งานอยู่
    SELECT * INTO v_config
    FROM public.delivery_fee_config_v2
    WHERE is_active = true
    ORDER BY is_default DESC, created_at DESC
    LIMIT 1;

    -- ถ้าไม่มีการตั้งค่า ให้ใช้ค่าเริ่มต้น
    IF v_config IS NULL THEN
        RETURN jsonb_build_object(
            'delivery_fee', 0,
            'distance_km', p_distance_km,
            'error', 'ไม่มีการตั้งค่าค่าส่ง'
        );
    END IF;

    -- ตรวจสอบระยะทางสูงสุด
    IF p_distance_km > v_config.max_delivery_distance THEN
        RETURN jsonb_build_object(
            'delivery_fee', 0,
            'distance_km', p_distance_km,
            'max_delivery_distance', v_config.max_delivery_distance,
            'error', format('ระยะการจัดส่งเกินกว่าที่กำหนด (%s กม.)', v_config.max_delivery_distance)
        );
    END IF;

    -- ค้นหา tier ที่ตรงกับระยะทาง (เรียงตาม min_distance DESC เพื่อให้เจอ tier ที่มีระยะทางมากที่สุดที่ยังครอบคลุม)
    SELECT * INTO v_tier
    FROM public.delivery_fee_tiers
    WHERE config_id = v_config.id
        AND min_distance <= p_distance_km
        AND (max_distance IS NULL OR max_distance >= p_distance_km)
    ORDER BY min_distance DESC
    LIMIT 1;

    -- ถ้าไม่เจอ tier ให้ใช้ค่าเริ่มต้น
    IF v_tier IS NULL THEN
        RAISE WARNING 'ไม่พบ tier สำหรับระยะทาง % km, ใช้ค่าเริ่มต้น 7 บาท', p_distance_km;
        v_fee := 7; -- ค่าเริ่มต้น
        v_base_fee := 7;
    ELSE
        v_fee := v_tier.fee;
        v_base_fee := v_tier.fee;
        RAISE NOTICE 'พบ tier: ระยะทาง % km อยู่ในช่วง %.1f-%.1f km, ค่าส่ง % บาท', 
            p_distance_km, v_tier.min_distance, COALESCE(v_tier.max_distance, 999), v_tier.fee;
    END IF;

    -- ตรวจสอบช่วงเวลาเร่งด่วน
    v_is_peak_hour := (
        EXTRACT(HOUR FROM p_order_time) * 60 + EXTRACT(MINUTE FROM p_order_time) >= 
        EXTRACT(HOUR FROM v_config.peak_hour_start) * 60 + EXTRACT(MINUTE FROM v_config.peak_hour_start)
    ) AND (
        EXTRACT(HOUR FROM p_order_time) * 60 + EXTRACT(MINUTE FROM p_order_time) <=
        EXTRACT(HOUR FROM v_config.peak_hour_end) * 60 + EXTRACT(MINUTE FROM v_config.peak_hour_end)
    );

    IF v_is_peak_hour AND v_config.peak_hour_multiplier > 1 THEN
        v_fee := CEIL(v_fee * v_config.peak_hour_multiplier);
    END IF;

    -- ตรวจสอบส่งฟรี
    IF v_config.free_delivery_threshold > 0 AND p_subtotal >= v_config.free_delivery_threshold THEN
        v_is_free_delivery := true;
        v_fee := 0;
    END IF;

    -- สร้างผลลัพธ์
    v_result := jsonb_build_object(
        'delivery_fee', v_fee,
        'distance_km', p_distance_km,
        'base_fee', v_base_fee,
        'peak_multiplier', CASE WHEN v_is_peak_hour THEN v_config.peak_hour_multiplier ELSE 1.0 END,
        'is_free_delivery', v_is_free_delivery,
        'free_delivery_threshold', v_config.free_delivery_threshold,
        'max_delivery_distance', v_config.max_delivery_distance,
        'is_peak_hour', v_is_peak_hour,
        'calculation_method', 'tier_based'
    );

    RETURN v_result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.calculate_deposit_amount(p_total_amount numeric, p_distance_km numeric)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
DECLARE
  v_deposit numeric;
  v_percent numeric;
BEGIN
  -- Get deposit percentage from settings
  SELECT deposit_rate_percent INTO v_percent
  FROM preorder_settings
  WHERE is_active = true
  LIMIT 1;
  
  -- Default to 30% if not found
  v_percent := COALESCE(v_percent, 30);
  
  -- Calculate deposit
  v_deposit := (p_total_amount * v_percent) / 100;
  
  -- Round up to nearest integer
  v_deposit := CEIL(v_deposit);
  
  RETURN v_deposit;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.calculate_max_store_distance(p_store_ids uuid[], p_customer_lat numeric, p_customer_lng numeric)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
DECLARE
  v_max_distance numeric := 0;
  v_store_lat numeric;
  v_store_lng numeric;
  v_distance numeric;
  v_store_id uuid;
BEGIN
  -- ถ้าไม่มีร้านให้คืนค่า 0
  IF array_length(p_store_ids, 1) IS NULL OR array_length(p_store_ids, 1) = 0 THEN
    RETURN 0;
  END IF;

  -- วนลูปคำนวณระยะทางจากแต่ละร้าน
  FOREACH v_store_id IN ARRAY p_store_ids
  LOOP
    -- ดึงตำแหน่งของร้าน
    SELECT latitude, longitude
    INTO v_store_lat, v_store_lng
    FROM stores
    WHERE id = v_store_id;

    -- ถ้าร้านมีตำแหน่ง ให้คำนวณระยะทาง
    IF v_store_lat IS NOT NULL AND v_store_lng IS NOT NULL THEN
      -- คำนวณระยะทางโดยใช้ Haversine formula
      v_distance := (
        6371 * acos(
          cos(radians(p_customer_lat)) *
          cos(radians(v_store_lat)) *
          cos(radians(v_store_lng) - radians(p_customer_lng)) +
          sin(radians(p_customer_lat)) *
          sin(radians(v_store_lat))
        )
      );

      -- เก็บระยะทางที่ไกลที่สุด
      IF v_distance > v_max_distance THEN
        v_max_distance := v_distance;
      END IF;
    END IF;
  END LOOP;

  RETURN v_max_distance;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.calculate_preorder_delivery_fee(p_distance_km numeric, p_subtotal numeric, p_order_time timestamp with time zone DEFAULT now())
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
  v_config record;
  v_distance_km numeric := GREATEST(p_distance_km, 0);
  v_fee numeric := 0;
  v_base_fee numeric := 0;
  v_peak_multiplier numeric := 1;
  v_is_free_delivery boolean := false;
  v_distance_for_fee numeric := 0;
  v_error text;
  v_threshold numeric;
BEGIN
  SELECT *
  INTO v_config
  FROM preorder_delivery_fee_config
  WHERE is_active = true
  ORDER BY is_default DESC, created_at DESC
  LIMIT 1;

  IF v_config IS NULL THEN
    v_base_fee := 10;
    v_fee := 10;
    v_distance_for_fee := v_distance_km;
    v_threshold := 0;
    v_error := 'NO_CONFIG';
  ELSE
    v_base_fee := v_config.base_fee;
    v_threshold := v_config.free_delivery_threshold;

    IF v_distance_km > COALESCE(v_config.max_delivery_distance, 999) THEN
      v_error := 'OUT_OF_RANGE';
    ELSE
      -- หา tier ที่ตรงกับระยะทาง
      SELECT (tier ->> 'fee')::numeric,
             (tier ->> 'max_km')::numeric
      INTO v_fee, v_distance_for_fee
      FROM jsonb_array_elements(v_config.tier_json) AS tier
      WHERE (tier ->> 'max_km')::numeric >= v_distance_km
      ORDER BY (tier ->> 'max_km')::numeric
      LIMIT 1;

      v_fee := COALESCE(v_fee, v_base_fee);
      v_distance_for_fee := COALESCE(v_distance_for_fee, v_distance_km);
    END IF;

    -- ตรวจ free delivery
    IF v_threshold > 0 AND p_subtotal >= v_threshold THEN
      v_fee := 0;
      v_is_free_delivery := true;
    ELSE
      -- ตรวจ peak hour
      IF to_char(p_order_time, 'HH24:MI') BETWEEN
         to_char(v_config.peak_hour_start, 'HH24:MI') AND
         to_char(v_config.peak_hour_end, 'HH24:MI') THEN
        v_peak_multiplier := COALESCE(v_config.peak_hour_multiplier, 1);
        v_fee := CEIL(v_fee * v_peak_multiplier);
      END IF;
    END IF;
  END IF;

  RETURN jsonb_build_object(
    'delivery_fee', v_fee,
    'base_fee', v_base_fee,
    'distance_km', v_distance_km,
    'distance_km_for_fee', v_distance_for_fee,
    'max_delivery_distance', COALESCE(v_config.max_delivery_distance, 0),
    'free_delivery_threshold', v_threshold,
    'peak_multiplier', v_peak_multiplier,
    'is_free_delivery', v_is_free_delivery,
    'error', v_error
  );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.calculate_store_average_rating(store_uuid uuid)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
DECLARE
    avg_rating numeric;
BEGIN
    SELECT COALESCE(AVG(rating), 0)
    INTO avg_rating
    FROM public.order_reviews
    WHERE store_id = store_uuid;
    
    RETURN ROUND(avg_rating, 2);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.cancel_beauty_booking(p_booking_id uuid, p_cancelled_by text, p_reason text DEFAULT NULL::text)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- อัปเดตสถานะการจอง
    UPDATE public.beauty_bookings
    SET 
        booking_status = 'cancelled',
        cancellation_reason = p_reason,
        cancelled_at = now(),
        updated_at = now()
    WHERE id = p_booking_id AND booking_status IN ('pending', 'confirmed');
    
    IF NOT FOUND THEN
        RETURN false;
    END IF;
    
    -- เพิ่มประวัติสถานะ
    INSERT INTO public.beauty_booking_status_history (
        booking_id,
        status,
        changed_by,
        notes
    ) VALUES (
        p_booking_id,
        'cancelled',
        p_cancelled_by,
        'Booking cancelled: ' || COALESCE(p_reason, 'No reason provided')
    );
    
    RETURN true;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.cancel_order(order_uuid uuid, cancellation_reason text DEFAULT 'ยกเลิกโดยลูกค้า'::text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE
    order_exists BOOLEAN;
    current_status TEXT;
    order_data RECORD;
    current_user_id UUID;
BEGIN
    -- ดึง ID ของผู้ใช้ปัจจุบัน
    current_user_id := auth.uid();
    
    IF current_user_id IS NULL THEN
        RAISE EXCEPTION 'User not authenticated';
    END IF;
    
    -- ตรวจสอบว่าออเดอร์มีอยู่และเป็นของลูกค้านี้
    SELECT EXISTS(
        SELECT 1 FROM orders 
        WHERE id = order_uuid 
        AND customer_id = current_user_id
    ) INTO order_exists;
    
    IF NOT order_exists THEN
        RAISE EXCEPTION 'Order not found or not authorized';
    END IF;
    
    -- ดึงข้อมูลออเดอร์
    SELECT * INTO order_data 
    FROM orders 
    WHERE id = order_uuid;
    
    -- ตรวจสอบว่าสามารถยกเลิกได้หรือไม่
    IF NOT (order_data.status IN ('pending', 'accepted')) THEN
        RAISE EXCEPTION 'Order cannot be cancelled in current status: %', order_data.status;
    END IF;
    
    -- อัปเดตสถานะโดยตรง - ไม่ใช้ triggers
    UPDATE orders 
    SET 
        status = 'cancelled',
        updated_at = NOW()
    WHERE id = order_uuid;
    
    -- เพิ่มประวัติการเปลี่ยนแปลงสถานะ (ถ้าตารางมีอยู่)
    BEGIN
        INSERT INTO order_status_history (order_id, status, updated_by, cancellation_reason)
        VALUES (order_uuid, 'cancelled', current_user_id, cancellation_reason);
    EXCEPTION
        WHEN undefined_table THEN
            NULL;
    END;
    
    -- สร้างการแจ้งเตือนลูกค้า (ถ้าตารางมีอยู่)
    BEGIN
        INSERT INTO notifications (user_id, title, message, type, data)
        VALUES (
            current_user_id,
            'ออเดอร์ถูกยกเลิก',
            'ออเดอร์ของคุณถูกยกเลิกแล้ว: ' || cancellation_reason,
            'order_update',
            jsonb_build_object('order_id', order_uuid, 'status', 'cancelled')
        );
    EXCEPTION
        WHEN undefined_table THEN
            NULL;
    END;
    
    -- ส่งการแจ้งเตือนไปยังร้านค้า (ถ้าตารางมีอยู่)
    BEGIN
        INSERT INTO notifications (user_id, title, message, type, data)
        VALUES (
            (SELECT owner_id FROM stores WHERE id = order_data.store_id),
            'ลูกค้ายกเลิกออเดอร์',
            'ลูกค้าได้ยกเลิกออเดอร์ #' || order_data.order_number || ': ' || cancellation_reason,
            'order_update',
            jsonb_build_object('order_id', order_uuid, 'status', 'cancelled')
        );
    EXCEPTION
        WHEN undefined_table THEN
            NULL;
    END;
    
    RAISE NOTICE 'Order % cancelled successfully by user % with reason: %', 
        order_uuid, current_user_id, cancellation_reason;
END;$function$
;

CREATE OR REPLACE FUNCTION public.cancel_order_booking(p_booking_id uuid, p_reason text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_booking_exists BOOLEAN;
    v_result JSONB;
BEGIN
    -- ตรวจสอบว่าการจองมีอยู่จริง
    SELECT EXISTS(
        SELECT 1 FROM rider_order_bookings 
        WHERE id = p_booking_id AND status = 'booked'
    ) INTO v_booking_exists;
    
    IF NOT v_booking_exists THEN
        RETURN json_build_object(
            'success', false,
            'error', 'ไม่พบการจองหรือการจองไม่สามารถยกเลิกได้'
        );
    END IF;
    
    -- ยกเลิกการจอง
    UPDATE rider_order_bookings
    SET 
        status = 'cancelled',
        cancelled_at = NOW(),
        cancellation_reason = p_reason,
        updated_at = NOW()
    WHERE id = p_booking_id;
    
    RETURN json_build_object(
        'success', true,
        'message', 'ยกเลิกการจองสำเร็จ'
    );
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', 'เกิดข้อผิดพลาด: ' || SQLERRM
        );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.cancel_payment(order_uuid uuid, cancelled_by_user_id uuid, reason text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    order_info RECORD;
BEGIN
    -- ดึงข้อมูลออเดอร์
    SELECT * INTO order_info FROM orders WHERE id = order_uuid;
    
    -- อัปเดตสถานะการชำระเงิน
    UPDATE orders 
    SET 
        payment_status = 'cancelled',
        updated_at = NOW()
    WHERE id = order_uuid;
    
    -- เพิ่มประวัติการชำระเงิน
    INSERT INTO payment_history (
        order_id, 
        payment_method, 
        amount, 
        status, 
        action, 
        notes, 
        processed_by
    )
    VALUES (
        order_uuid,
        order_info.payment_method,
        order_info.total_amount,
        'cancelled',
        'payment_cancelled',
        reason,
        cancelled_by_user_id
    );
    
    -- ส่งการแจ้งเตือนลูกค้า
    PERFORM send_notification(
        order_info.customer_id,
        'การชำระเงินถูกยกเลิก',
        'การชำระเงินของคุณถูกยกเลิก: ' || COALESCE(reason, 'ไม่มีเหตุผล'),
        'payment',
        jsonb_build_object(
            'order_id', order_uuid,
            'order_number', order_info.order_number,
            'reason', reason
        )
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.cancel_rider_assignment(assignment_uuid uuid, cancellation_reason text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    order_uuid UUID;
    rider_uuid UUID;
BEGIN
    -- ดึงข้อมูล
    SELECT order_id, rider_id INTO order_uuid, rider_uuid 
    FROM rider_assignments WHERE id = assignment_uuid;
    
    -- อัปเดตสถานะงาน
    UPDATE rider_assignments 
    SET 
        status = 'cancelled',
        cancelled_at = NOW(),
        cancellation_reason = cancellation_reason,
        updated_at = NOW()
    WHERE id = assignment_uuid;
    
    -- อัปเดตคำสั่งซื้อกลับเป็น ready
    UPDATE orders 
    SET 
        rider_id = NULL,
        status = 'ready',
        updated_at = NOW()
    WHERE id = order_uuid;
    
    -- เพิ่มประวัติ
    INSERT INTO order_status_history (order_id, status, updated_by, notes)
    VALUES (order_uuid, 'ready', (SELECT user_id FROM riders WHERE id = rider_uuid), 
        'Rider assignment cancelled: ' || COALESCE(cancellation_reason, 'No reason provided'));
END;
$function$
;

create or replace view "public"."chat_messages_by_date" as  SELECT date(created_at) AS message_date,
    count(*) AS total_messages,
    count(
        CASE
            WHEN (sender_type = 'customer'::text) THEN 1
            ELSE NULL::integer
        END) AS customer_messages,
    count(
        CASE
            WHEN (sender_type = 'rider'::text) THEN 1
            ELSE NULL::integer
        END) AS rider_messages,
    count(
        CASE
            WHEN (message_type = 'text'::text) THEN 1
            ELSE NULL::integer
        END) AS text_messages,
    count(
        CASE
            WHEN (message_type = 'image'::text) THEN 1
            ELSE NULL::integer
        END) AS image_messages,
    count(
        CASE
            WHEN (message_type = 'location'::text) THEN 1
            ELSE NULL::integer
        END) AS location_messages,
    count(
        CASE
            WHEN (is_read = false) THEN 1
            ELSE NULL::integer
        END) AS unread_messages
   FROM public.chat_messages cm
  GROUP BY (date(created_at))
  ORDER BY (date(created_at)) DESC;


create or replace view "public"."chat_messages_statistics" as  SELECT cm.order_id,
    o.order_number,
    o.customer_name,
    o.customer_phone,
    o.delivery_address,
    o.status AS order_status,
    count(*) AS total_messages,
    count(
        CASE
            WHEN (cm.sender_type = 'customer'::text) THEN 1
            ELSE NULL::integer
        END) AS customer_messages,
    count(
        CASE
            WHEN (cm.sender_type = 'rider'::text) THEN 1
            ELSE NULL::integer
        END) AS rider_messages,
    count(
        CASE
            WHEN (cm.is_read = false) THEN 1
            ELSE NULL::integer
        END) AS unread_messages,
    count(
        CASE
            WHEN (cm.message_type = 'text'::text) THEN 1
            ELSE NULL::integer
        END) AS text_messages,
    count(
        CASE
            WHEN (cm.message_type = 'image'::text) THEN 1
            ELSE NULL::integer
        END) AS image_messages,
    count(
        CASE
            WHEN (cm.message_type = 'location'::text) THEN 1
            ELSE NULL::integer
        END) AS location_messages,
    min(cm.created_at) AS first_message_time,
    max(cm.created_at) AS last_message_time,
    (EXTRACT(epoch FROM (max(cm.created_at) - min(cm.created_at))) / (3600)::numeric) AS conversation_duration_hours
   FROM (public.chat_messages cm
     JOIN public.orders o ON ((cm.order_id = o.id)))
  GROUP BY cm.order_id, o.order_number, o.customer_name, o.customer_phone, o.delivery_address, o.status
  ORDER BY (max(cm.created_at)) DESC;


create or replace view "public"."chat_messages_with_location" as  SELECT cm.id,
    cm.order_id,
    cm.sender_type,
    cm.sender_id,
    cm.message,
    cm.message_type,
    cm.is_read,
    cm.created_at,
    o.order_number,
    o.customer_name,
    o.customer_phone,
    o.delivery_address,
        CASE
            WHEN ((cm.message_type = 'location'::text) AND (cm.message IS NOT NULL)) THEN cm.message
            ELSE NULL::text
        END AS location_data
   FROM (public.chat_messages cm
     JOIN public.orders o ON ((cm.order_id = o.id)))
  WHERE (cm.message_type = 'location'::text)
  ORDER BY cm.created_at DESC;


CREATE OR REPLACE FUNCTION public.check_app_version(p_platform character varying, p_current_version_code integer)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_latest_version RECORD;
    v_result JSONB;
BEGIN
    -- ดึงเวอร์ชันล่าสุด
    SELECT * INTO v_latest_version
    FROM app_versions
    WHERE platform = p_platform 
    AND is_active = true 
    ORDER BY version_code DESC
    LIMIT 1;

    IF v_latest_version IS NULL THEN
        RETURN jsonb_build_object(
            'needs_update', false,
            'force_update', false,
            'message', 'No version information available'
        );
    END IF;

    -- ตรวจสอบว่าต้องอัปเดทหรือไม่
    IF p_current_version_code < v_latest_version.version_code THEN
        v_result := jsonb_build_object(
            'needs_update', true,
            'force_update', v_latest_version.force_update,
            'latest_version_code', v_latest_version.version_code,
            'latest_version_name', v_latest_version.version_name,
            'min_required_version', v_latest_version.min_required_version,
            'update_message', v_latest_version.update_message,
            'download_url', v_latest_version.download_url,
            'is_critical', p_current_version_code < v_latest_version.min_required_version
        );
    ELSE
        v_result := jsonb_build_object(
            'needs_update', false,
            'force_update', false,
            'current_version', p_current_version_code,
            'latest_version', v_latest_version.version_code
        );
    END IF;

    RETURN v_result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_email_exists(email_param text)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    exists_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO exists_count
    FROM public.users
    WHERE email = email_param;
    
    RETURN exists_count > 0;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_expiring_documents()
 RETURNS TABLE(rider_id uuid, document_type text, expiry_date date, days_until_expiry integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        r.id,
        'driver_license' as document_type,
        r.driver_license_expiry as expiry_date,
        (r.driver_license_expiry - CURRENT_DATE)::INTEGER as days_until_expiry
    FROM riders r
    WHERE r.driver_license_expiry IS NOT NULL
    AND r.driver_license_expiry <= CURRENT_DATE + INTERVAL '30 days'
    AND r.driver_license_expiry > CURRENT_DATE
    
    UNION ALL
    
    SELECT 
        r.id,
        'car_tax' as document_type,
        r.car_tax_expiry as expiry_date,
        (r.car_tax_expiry - CURRENT_DATE)::INTEGER as days_until_expiry
    FROM riders r
    WHERE r.car_tax_expiry IS NOT NULL
    AND r.car_tax_expiry <= CURRENT_DATE + INTERVAL '30 days'
    AND r.car_tax_expiry > CURRENT_DATE
    
    UNION ALL
    
    SELECT 
        r.id,
        'insurance' as document_type,
        r.insurance_expiry as expiry_date,
        (r.insurance_expiry - CURRENT_DATE)::INTEGER as days_until_expiry
    FROM riders r
    WHERE r.insurance_expiry IS NOT NULL
    AND r.insurance_expiry <= CURRENT_DATE + INTERVAL '30 days'
    AND r.insurance_expiry > CURRENT_DATE;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_fcm_token_status_for_order(order_uuid uuid)
 RETURNS TABLE(total_messages integer, messages_with_sender_fcm integer, messages_with_recipient_fcm integer, messages_missing_fcm integer)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_messages,
        COUNT(CASE WHEN sender_fcm_token IS NOT NULL AND sender_fcm_token != '' THEN 1 END)::INTEGER as messages_with_sender_fcm,
        COUNT(CASE WHEN recipient_fcm_token IS NOT NULL AND recipient_fcm_token != '' THEN 1 END)::INTEGER as messages_with_recipient_fcm,
        COUNT(CASE WHEN (sender_fcm_token IS NULL OR sender_fcm_token = '') OR (recipient_fcm_token IS NULL OR recipient_fcm_token = '') THEN 1 END)::INTEGER as messages_missing_fcm
    FROM chat_messages
    WHERE order_id = order_uuid;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_file_access(bucket_name text, file_path text, operation text)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    user_id_from_path TEXT;
    current_user_id TEXT;
    user_role TEXT;
    is_authorized BOOLEAN := false;
BEGIN
    -- ดึง user_id จาก path
    user_id_from_path := (string_to_array(file_path, '/'))[1];
    current_user_id := auth.uid()::TEXT;
    
    -- ดึงบทบาทผู้ใช้
    SELECT role INTO user_role 
    FROM public.users 
    WHERE id = auth.uid();
    
    -- ตรวจสอบสิทธิ์ตาม operation
    CASE operation
        WHEN 'read' THEN
            -- อ่านได้ถ้าเป็นไฟล์ของตัวเอง หรือเป็น admin
            is_authorized := (user_id_from_path = current_user_id) OR (user_role = 'admin');
            
            -- สำหรับ payment-slips ให้ store owner อ่านได้
            IF bucket_name = 'payment-slips' AND user_role = 'store_owner' THEN
                is_authorized := true;
            END IF;
            
        WHEN 'write' THEN
            -- เขียนได้ถ้าเป็นไฟล์ของตัวเอง
            is_authorized := (user_id_from_path = current_user_id);
            
        WHEN 'delete' THEN
            -- ลบได้ถ้าเป็นไฟล์ของตัวเอง หรือเป็น admin
            is_authorized := (user_id_from_path = current_user_id) OR (user_role = 'admin');
            
        ELSE
            is_authorized := false;
    END CASE;
    
    RETURN is_authorized;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_google_id_exists(google_id_param text)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    exists_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO exists_count
    FROM public.users
    WHERE google_id = google_id_param;
    
    RETURN exists_count > 0;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_single_store_status(store_uuid uuid)
 RETURNS TABLE(store_id uuid, store_name text, current_status boolean, should_be_open boolean, opening_hours jsonb, current_time_value time without time zone, opening_time text, closing_time text, status_match boolean)
 LANGUAGE plpgsql
AS $function$
DECLARE
    store_record RECORD;
    current_time_value TIME;
    opening_time TEXT;
    closing_time TEXT;
    should_be_open BOOLEAN;
BEGIN
    -- ตั้งค่าเวลาปัจจุบัน (เวลาไทย UTC+7)
    current_time_value := (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Bangkok')::TIME;
    
    -- ดึงข้อมูลร้าน
    SELECT 
        id,
        name,
        is_open,
        stores.opening_hours,
        stores.is_active,
        stores.is_suspended,
        stores.is_auto_open
    INTO store_record
    FROM stores 
    WHERE id = store_uuid;
    
    -- ตรวจสอบว่าร้านมีอยู่หรือไม่
    IF NOT FOUND THEN
        RAISE EXCEPTION 'ไม่พบร้านที่ระบุ ID: %', store_uuid;
    END IF;
    
    should_be_open := false;
    opening_time := NULL;
    closing_time := NULL;
    
    -- ตรวจสอบว่ามี opening_hours หรือไม่
    IF store_record.opening_hours IS NOT NULL THEN
        -- ทำความสะอาด opening_hours (แปลง JSON เป็น TEXT และลบ quotes)
        DECLARE
            clean_hours TEXT;
        BEGIN
            clean_hours := store_record.opening_hours::TEXT;
            -- ลบ quotes ที่ซ้อนกันออก
            clean_hours := replace(clean_hours, '"""', '');
            clean_hours := replace(clean_hours, '"', '');
            
            -- แยกเวลาเปิดและปิดจากรูปแบบ "08:00-17:40"
            IF position('-' in clean_hours) > 0 THEN
                opening_time := split_part(clean_hours, '-', 1);
                closing_time := split_part(clean_hours, '-', 2);
                
                -- ตรวจสอบว่าเวลาเปิดปิดถูกต้อง
                IF opening_time IS NOT NULL AND closing_time IS NOT NULL THEN
                    -- ตรวจสอบว่าเวลาปัจจุบันอยู่ในช่วงเปิดร้านหรือไม่
                    IF current_time_value >= opening_time::TIME AND current_time_value <= closing_time::TIME THEN
                        should_be_open := true;
                    END IF;
                END IF;
            END IF;
        END;
    END IF;
    
    -- คืนค่าผลลัพธ์
    RETURN QUERY SELECT 
        store_record.id,
        store_record.name,
        store_record.is_open,
        should_be_open,
        store_record.opening_hours,
        current_time_value,
        opening_time,
        closing_time,
        (store_record.is_open = should_be_open);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_slot_availability(p_salon_id uuid, p_staff_id uuid, p_date date, p_time_slot time without time zone, p_duration_minutes integer)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_is_available boolean;
    v_end_time time;
BEGIN
    -- คำนวณเวลาสิ้นสุด
    v_end_time := p_time_slot + (p_duration_minutes || ' minutes')::interval;
    
    -- ตรวจสอบความว่าง
    SELECT NOT EXISTS(
        SELECT 1 FROM public.beauty_schedules
        WHERE salon_id = p_salon_id
        AND staff_id = p_staff_id
        AND date = p_date
        AND time_slot < v_end_time
        AND (time_slot + (duration_minutes || ' minutes')::interval) > p_time_slot
        AND is_available = false
    ) INTO v_is_available;
    
    RETURN v_is_available;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_user_registration_status()
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    user_record RECORD;
    result JSONB;
BEGIN
    -- ตรวจสอบว่าผู้ใช้มีอยู่ในตาราง users หรือไม่
    SELECT * INTO user_record 
    FROM public.users 
    WHERE id = auth.uid();
    
    IF user_record IS NULL THEN
        -- ไม่พบผู้ใช้ในตาราง users
        result := jsonb_build_object(
            'is_logged_in', false,
            'is_registered', false,
            'message', 'User not found in users table'
        );
    ELSE
        -- พบผู้ใช้ในตาราง users
        result := jsonb_build_object(
            'is_logged_in', true,
            'user_id', user_record.id,
            'google_id', user_record.google_id,
            'email', user_record.email,
            'full_name', user_record.full_name,
            'role', user_record.role,
            'is_active', user_record.is_active,
            'last_login_at', user_record.last_login_at,
            'login_count', user_record.login_count,
            'created_at', user_record.created_at,
            'avatar_url', user_record.avatar_url,
            'phone', user_record.phone,
            'line_id', user_record.line_id,
            'address', user_record.address,
            'profile_complete', CASE 
                WHEN user_record.phone IS NOT NULL 
                     AND user_record.line_id IS NOT NULL 
                     AND user_record.address IS NOT NULL 
                THEN true 
                ELSE false 
            END,
            'has_role', CASE 
                WHEN user_record.role IS NOT NULL AND user_record.role != '' 
                THEN true 
                ELSE false 
            END,
            'message', 'User logged in successfully'
        );
    END IF;
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_user_registration_status(google_id_param text DEFAULT NULL::text, email_param text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    user_record RECORD;
    result JSONB;
BEGIN
    -- ตรวจสอบว่ามี google_id หรือ email หรือไม่
    IF google_id_param IS NULL AND email_param IS NULL THEN
        -- ใช้ auth.uid() ถ้าไม่ระบุ
        SELECT * INTO user_record 
        FROM public.users 
        WHERE id = auth.uid();
    ELSE
        -- ตรวจสอบด้วย google_id หรือ email
        SELECT * INTO user_record 
        FROM public.users 
        WHERE (google_id_param IS NOT NULL AND google_id = google_id_param)
           OR (email_param IS NOT NULL AND email = email_param);
    END IF;
    
    IF user_record IS NULL THEN
        -- ไม่พบผู้ใช้
        result := jsonb_build_object(
            'exists', false,
            'message', 'User not found',
            'is_registered', false
        );
    ELSE
        -- พบผู้ใช้
        result := jsonb_build_object(
            'exists', true,
            'is_registered', true,
            'user_id', user_record.id,
            'google_id', user_record.google_id,
            'email', user_record.email,
            'full_name', user_record.full_name,
            'role', user_record.role,
            'is_active', user_record.is_active,
            'last_login_at', user_record.last_login_at,
            'login_count', user_record.login_count,
            'created_at', user_record.created_at,
            'avatar_url', user_record.avatar_url,
            'message', 'User found'
        );
    END IF;
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_user_status()
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    user_record RECORD;
    result JSONB;
BEGIN
    SELECT * INTO user_record 
    FROM public.users 
    WHERE id = auth.uid();
    
    IF user_record IS NULL THEN
        result := jsonb_build_object(
            'exists', false,
            'message', 'User not found in users table'
        );
    ELSE
        result := jsonb_build_object(
            'exists', true,
            'user_id', user_record.id,
            'email', user_record.email,
            'full_name', user_record.full_name,
            'role', user_record.role,
            'message', 'User found'
        );
    END IF;
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_window_availability(p_delivery_date date, p_window_id uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
  v_max_orders integer;
  v_current_orders integer;
  v_is_available boolean;
BEGIN
  SELECT dw.max_orders, COALESCE(dwa.current_orders, 0)
  INTO v_max_orders, v_current_orders
  FROM delivery_windows dw
  LEFT JOIN delivery_window_allocations dwa
    ON dwa.delivery_window_id = dw.id
    AND dwa.delivery_date = p_delivery_date
  WHERE dw.id = p_window_id
    AND dw.is_active = true;
  
  v_is_available := v_current_orders < v_max_orders;
  
  RETURN jsonb_build_object(
    'available', v_is_available,
    'max_orders', v_max_orders,
    'current_orders', v_current_orders,
    'remaining', v_max_orders - v_current_orders
  );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.cleanup_expired_bookings()
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_expired_count INTEGER;
BEGIN
    -- ลบการจองที่หมดอายุ
    DELETE FROM rider_order_bookings
    WHERE status = 'booked' 
    AND expires_at < NOW();
    
    GET DIAGNOSTICS v_expired_count = ROW_COUNT;
    
    RETURN json_build_object(
        'success', true,
        'expired_count', v_expired_count,
        'message', 'ลบการจองที่หมดอายุ ' || v_expired_count || ' รายการ'
    );
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', 'เกิดข้อผิดพลาด: ' || SQLERRM
        );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.cleanup_inactive_fcm_tokens()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM fcm_store 
    WHERE is_active = false 
    AND updated_at < NOW() - INTERVAL '30 days';
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.cleanup_old_fcm_data()
 RETURNS TABLE(cleaned_users integer, cleaned_tokens integer)
 LANGUAGE plpgsql
AS $function$
DECLARE
    user_count INTEGER;
    token_count INTEGER;
BEGIN
    -- ลบ FCM tokens ที่ไม่ใช้งานแล้ว (เก่ากว่า 30 วัน)
    DELETE FROM fcm_store 
    WHERE is_active = false 
    AND updated_at < NOW() - INTERVAL '30 days';
    
    GET DIAGNOSTICS token_count = ROW_COUNT;
    
    -- อัปเดต fcm_token ในตาราง users เป็น NULL (ไม่ลบข้อมูลผู้ใช้)
    UPDATE users 
    SET fcm_token = NULL, updated_at = NOW()
    WHERE fcm_token IS NOT NULL 
    AND fcm_token != ''
    AND id IN (
        SELECT DISTINCT user_id 
        FROM fcm_store 
        WHERE is_active = true
    );
    
    GET DIAGNOSTICS user_count = ROW_COUNT;
    
    RETURN QUERY SELECT user_count, token_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.cleanup_old_files()
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    result JSONB;
    deleted_count INTEGER := 0;
BEGIN
    -- ฟังก์ชันนี้จะถูกเรียกจาก cron job หรือ scheduled task
    -- เพื่อลบไฟล์ที่ไม่ได้ใช้แล้ว
    
    -- ตัวอย่าง: ลบรูปโปรไฟล์เก่าที่ไม่ได้ใช้
    -- (ต้องใช้ Supabase Storage API ในแอปพลิเคชัน)
    
    result := jsonb_build_object(
        'success', true,
        'deleted_count', deleted_count,
        'message', 'Cleanup completed'
    );
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.cleanup_rider_locations_after_delivery()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM public.order_rider_locations
    WHERE order_id = NEW.id;
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.clear_user_delivery_location(user_id_param uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE users 
    SET 
        latitude = NULL,
        longitude = NULL,
        updated_at = NOW()
    WHERE id = user_id_param;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'User not found with ID: %', user_id_param;
    END IF;
END;
$function$
;

create or replace view "public"."community_post_images_with_urls" as  SELECT id,
    post_id,
    file_path,
    image_order,
    file_name,
    file_size,
    mime_type,
    created_at,
        CASE
            WHEN ((file_path ~~ 'https://%'::text) OR (file_path ~~ 'http://%'::text)) THEN file_path
            ELSE ( SELECT
                    CASE
                        WHEN (o.id IS NOT NULL) THEN ((((('https://'::text || current_setting('app.settings.supabase_url'::text, true)) || '/storage/v1/object/public/'::text) || o.bucket_id) || '/'::text) || o.name)
                        ELSE ('https://lwmvqwmchpxmimoxsdkl.supabase.co/storage/v1/object/public/post-images/'::text || pi.file_path)
                    END AS "case"
               FROM storage.objects o
              WHERE ((o.bucket_id = 'post-images'::text) AND (o.name = pi.file_path))
             LIMIT 1)
        END AS image_url
   FROM public.community_post_images pi
  ORDER BY post_id, image_order;


create or replace view "public"."community_posts_with_details" as  SELECT p.id,
    p.user_id,
    p.post_type,
    p.content,
    p.location_name,
    p.latitude,
    p.longitude,
    p.is_active,
    p.created_at,
    p.updated_at,
    u.full_name AS author_name,
    u.avatar_url AS author_avatar,
    COALESCE(like_count.likes, (0)::bigint) AS like_count,
    COALESCE(comment_count.comments, (0)::bigint) AS comment_count,
    false AS is_liked_by_user
   FROM (((public.community_posts p
     JOIN public.users u ON ((p.user_id = u.id)))
     LEFT JOIN ( SELECT community_post_likes.post_id,
            count(*) AS likes
           FROM public.community_post_likes
          GROUP BY community_post_likes.post_id) like_count ON ((p.id = like_count.post_id)))
     LEFT JOIN ( SELECT community_comments.post_id,
            count(*) AS comments
           FROM public.community_comments
          WHERE (community_comments.is_active = true)
          GROUP BY community_comments.post_id) comment_count ON ((p.id = comment_count.post_id)))
  WHERE (p.is_active = true);


CREATE OR REPLACE FUNCTION public.confirm_bank_transfer(order_uuid uuid, transfer_slip_url text, confirmed_by_user_id uuid DEFAULT NULL::uuid, notes text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    order_info RECORD;
    store_owner_uuid UUID;
BEGIN
    -- ดึงข้อมูลออเดอร์
    SELECT o.*, s.owner_id INTO order_info
    FROM orders o
    JOIN stores s ON o.store_id = s.id
    WHERE o.id = order_uuid;
    
    -- ดึง store_owner_uuid จาก order_info
    store_owner_uuid := order_info.owner_id;
    
    -- ตรวจสอบว่าเป็นเจ้าของร้าน
    IF confirmed_by_user_id != store_owner_uuid THEN
        RAISE EXCEPTION 'You are not authorized to confirm this payment';
    END IF;
    
    -- ตรวจสอบว่าออเดอร์เป็นแบบโอนเงิน
    IF order_info.payment_method != 'bank_transfer' THEN
        RAISE EXCEPTION 'Order is not a bank transfer payment';
    END IF;
    
    -- ตรวจสอบว่ายังไม่ยืนยันการโอนเงิน
    IF order_info.payment_status = 'paid' THEN
        RAISE EXCEPTION 'Payment already confirmed';
    END IF;
    
    -- อัปเดตสถานะการชำระเงิน
    UPDATE orders 
    SET 
        payment_status = 'paid',
        transfer_slip_url = transfer_slip_url,
        transfer_confirmed_at = NOW(),
        transfer_confirmed_by = confirmed_by_user_id,
        updated_at = NOW()
    WHERE id = order_uuid;
    
    -- เพิ่มประวัติการชำระเงิน
    INSERT INTO payment_history (
        order_id, 
        payment_method, 
        amount, 
        status, 
        action, 
        notes, 
        processed_by
    )
    VALUES (
        order_uuid,
        'bank_transfer',
        order_info.total_amount,
        'paid',
        'payment_confirmed',
        notes,
        confirmed_by_user_id
    );
    
    -- อัปเดตสถานะออเดอร์เป็น accepted
    PERFORM update_order_status(
        order_uuid, 
        'accepted', 
        confirmed_by_user_id, 
        'Payment confirmed via bank transfer'
    );
    
    -- ส่งการแจ้งเตือนลูกค้า
    PERFORM send_notification(
        order_info.customer_id,
        'การชำระเงินยืนยันแล้ว',
        'การโอนเงินของคุณได้รับการยืนยันแล้ว ร้านค้ากำลังเตรียมอาหารให้คุณ',
        'payment',
        jsonb_build_object(
            'order_id', order_uuid,
            'order_number', order_info.order_number,
            'amount', order_info.total_amount
        )
    );
    
    -- ส่งการแจ้งเตือนไดเดอร์ (ถ้ามี)
    IF EXISTS (
        SELECT 1 FROM riders 
        WHERE is_available = true 
        AND documents_verified = true
    ) THEN
        PERFORM send_notification(
            (SELECT user_id FROM riders 
             WHERE is_available = true 
             AND documents_verified = true 
             LIMIT 1),
            'มีออเดอร์ใหม่',
            'มีออเดอร์ใหม่จากร้าน ' || (SELECT name FROM stores WHERE id = order_info.store_id),
            'order_update',
            jsonb_build_object(
                'order_id', order_uuid,
                'store_id', order_info.store_id,
                'delivery_fee', order_info.delivery_fee
            )
        );
    END IF;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.confirm_beauty_booking(p_booking_id uuid, p_confirmed_by text)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- อัปเดตสถานะการจอง
    UPDATE public.beauty_bookings
    SET 
        booking_status = 'confirmed',
        updated_at = now()
    WHERE id = p_booking_id AND booking_status = 'pending';
    
    IF NOT FOUND THEN
        RETURN false;
    END IF;
    
    -- เพิ่มประวัติสถานะ
    INSERT INTO public.beauty_booking_status_history (
        booking_id,
        status,
        changed_by,
        notes
    ) VALUES (
        p_booking_id,
        'confirmed',
        p_confirmed_by,
        'Booking confirmed by salon'
    );
    
    RETURN true;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.count_available_riders()
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    rider_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO rider_count
    FROM riders r
    WHERE r.is_available = true 
    AND r.documents_verified = true
    AND NOT EXISTS (
        SELECT 1 FROM rider_assignments ra 
        WHERE ra.rider_id = r.id 
        AND ra.status IN ('assigned', 'picked_up', 'delivering')
    );
    
    RETURN rider_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.count_pending_orders(p_store_id uuid DEFAULT NULL::uuid)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_count integer;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM public.orders o
    WHERE o.status = 'pending'
    AND (p_store_id IS NULL OR o.store_id = p_store_id);
    
    RETURN v_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.count_store_reviews(store_uuid uuid)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
    review_count integer;
BEGIN
    SELECT COUNT(*)
    INTO review_count
    FROM public.order_reviews
    WHERE store_id = store_uuid;
    
    RETURN review_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.create_admin_user(p_email text, p_password text, p_full_name text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_admin_user_id UUID;
    v_result JSONB;
BEGIN
    -- ตรวจสอบว่าเป็น admin หรือไม่
    IF NOT EXISTS (
        SELECT 1 FROM public.users 
        WHERE id = auth.uid() AND role = 'admin'
    ) THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'คุณไม่มีสิทธิ์สร้างแอดมิน'
        );
    END IF;
    
    -- ตรวจสอบว่า email ซ้ำหรือไม่
    IF EXISTS (
        SELECT 1 FROM public.users WHERE email = p_email
    ) THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'อีเมลนี้มีอยู่ในระบบแล้ว'
        );
    END IF;
    
    -- สร้าง admin user ใน auth.users
    INSERT INTO auth.users (
        instance_id,
        id,
        aud,
        role,
        email,
        encrypted_password,
        email_confirmed_at,
        recovery_sent_at,
        last_sign_in_at,
        raw_app_meta_data,
        raw_user_meta_data,
        created_at,
        updated_at,
        confirmation_token,
        email_change,
        email_change_token_new,
        recovery_token
    ) VALUES (
        '00000000-0000-0000-0000-000000000000',
        gen_random_uuid(),
        'authenticated',
        'authenticated',
        p_email,
        crypt(p_password, gen_salt('bf')),
        NOW(),
        NULL,
        NOW(),
        '{"provider": "email", "providers": ["email"], "role": "admin"}',
        jsonb_build_object('full_name', p_full_name),
        NOW(),
        NOW(),
        '',
        '',
        '',
        ''
    ) RETURNING id INTO v_admin_user_id;
    
    -- สร้าง admin user ใน public.users
    INSERT INTO public.users (
        id,
        google_id,
        email,
        full_name,
        role,
        is_active,
        email_verified,
        phone_verified,
        google_verified_email,
        last_login_at,
        login_count,
        created_at,
        updated_at
    ) VALUES (
        v_admin_user_id,
        p_email,
        p_email,
        p_full_name,
        'admin',
        true,
        true,
        false,
        true,
        NOW(),
        0,
        NOW(),
        NOW()
    );
    
    -- สร้างผลลัพธ์
    v_result := jsonb_build_object(
        'success', true,
        'message', 'สร้างแอดมินสำเร็จ',
        'user_id', v_admin_user_id,
        'email', p_email,
        'full_name', p_full_name
    );
    
    RETURN v_result;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'เกิดข้อผิดพลาด: ' || SQLERRM
        );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.create_bank_transfer_info(order_uuid uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    order_info RECORD;
    bank_account RECORD;
    transfer_info JSONB;
BEGIN
    -- ดึงข้อมูลออเดอร์
    SELECT o.*, s.name as store_name INTO order_info
    FROM orders o
    JOIN stores s ON o.store_id = s.id
    WHERE o.id = order_uuid;
    
    -- ดึงข้อมูลบัญชีธนาคารของร้านค้า
    SELECT * INTO bank_account
    FROM store_bank_accounts
    WHERE store_id = order_info.store_id 
    AND is_active = true 
    AND is_default = true
    LIMIT 1;
    
    -- ถ้าไม่มีบัญชี default ให้ใช้บัญชีแรก
    IF bank_account IS NULL THEN
        SELECT * INTO bank_account
        FROM store_bank_accounts
        WHERE store_id = order_info.store_id 
        AND is_active = true
        LIMIT 1;
    END IF;
    
    -- อัปเดตข้อมูลการโอนเงินในออเดอร์
    UPDATE orders 
    SET 
        bank_name = bank_account.bank_name,
        bank_account_number = bank_account.account_number,
        bank_account_name = bank_account.account_name,
        qr_code_url = bank_account.qr_code_url,
        transfer_amount = total_amount,
        transfer_reference = 'TRF' || SUBSTRING(order_number FROM 9),
        updated_at = NOW()
    WHERE id = order_uuid;
    
    -- สร้างข้อมูลการโอนเงิน
    transfer_info := jsonb_build_object(
        'order_id', order_uuid,
        'order_number', order_info.order_number,
        'store_name', order_info.store_name,
        'amount', order_info.total_amount,
        'bank_name', bank_account.bank_name,
        'account_number', bank_account.account_number,
        'account_name', bank_account.account_name,
        'qr_code_url', bank_account.qr_code_url,
        'transfer_reference', 'TRF' || SUBSTRING(order_info.order_number FROM 9)
    );
    
    -- เพิ่มประวัติการชำระเงิน
    INSERT INTO payment_history (
        order_id, 
        payment_method, 
        amount, 
        status, 
        action, 
        notes
    )
    VALUES (
        order_uuid,
        'bank_transfer',
        order_info.total_amount,
        'pending',
        'payment_requested',
        'Bank transfer information generated'
    );
    
    -- ส่งการแจ้งเตือนลูกค้า
    PERFORM send_notification(
        order_info.customer_id,
        'ข้อมูลการโอนเงิน',
        'กรุณาโอนเงินจำนวน ' || order_info.total_amount || ' บาท ไปยังบัญชี ' || bank_account.bank_name || ' ' || bank_account.account_number,
        'payment',
        transfer_info
    );
    
    RETURN transfer_info;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.create_beauty_booking(p_customer_name text, p_customer_email text, p_customer_phone text, p_customer_line_id text, p_salon_id uuid, p_service_id uuid, p_staff_id uuid, p_booking_date date, p_booking_time time without time zone, p_customer_count integer DEFAULT 1, p_special_requests text DEFAULT NULL::text)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_service_record RECORD;
    v_booking_id uuid;
    v_booking_number text;
    v_total_amount numeric;
BEGIN
    -- ดึงข้อมูลบริการ
    SELECT * INTO v_service_record
    FROM public.beauty_services
    WHERE id = p_service_id AND salon_id = p_salon_id AND is_active = true;
    
    IF v_service_record IS NULL THEN
        RAISE EXCEPTION 'Service not found or not active';
    END IF;
    
    -- ตรวจสอบความว่างของสล็อต
    IF NOT public.check_slot_availability(p_salon_id, p_staff_id, p_booking_date, p_booking_time, v_service_record.duration_minutes) THEN
        RAISE EXCEPTION 'Time slot is not available';
    END IF;
    
    -- คำนวณราคารวม
    v_total_amount := v_service_record.price * p_customer_count;
    
    -- สร้างเลขที่การจอง
    v_booking_number := public.generate_beauty_booking_number();
    
    -- สร้างการจอง
    INSERT INTO public.beauty_bookings (
        booking_number,
        customer_name,
        customer_email,
        customer_phone,
        customer_line_id,
        salon_id,
        service_id,
        staff_id,
        booking_date,
        booking_time,
        duration_minutes,
        customer_count,
        total_amount,
        special_requests
    ) VALUES (
        v_booking_number,
        p_customer_name,
        p_customer_email,
        p_customer_phone,
        p_customer_line_id,
        p_salon_id,
        p_service_id,
        p_staff_id,
        p_booking_date,
        p_booking_time,
        v_service_record.duration_minutes,
        p_customer_count,
        v_total_amount,
        p_special_requests
    ) RETURNING id INTO v_booking_id;
    
    -- เพิ่มประวัติสถานะ
    INSERT INTO public.beauty_booking_status_history (
        booking_id,
        status,
        changed_by,
        notes
    ) VALUES (
        v_booking_id,
        'pending',
        'system',
        'Booking created'
    );
    
    RETURN v_booking_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.create_delivery_fee_setting(created_by_user_id uuid, setting_name text, base_fee_param numeric, distance_fee_per_km_param numeric, max_delivery_distance_param integer, setting_description text DEFAULT NULL::text, free_delivery_threshold_param numeric DEFAULT 0, peak_hour_multiplier_param numeric DEFAULT 1.0, peak_hour_start_param time without time zone DEFAULT '00:00:00'::time without time zone, peak_hour_end_param time without time zone DEFAULT '23:59:59'::time without time zone, is_default_param boolean DEFAULT false)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    setting_id UUID;
BEGIN
    -- ตรวจสอบว่าเป็น admin
    IF NOT EXISTS (SELECT 1 FROM users WHERE id = created_by_user_id AND role = 'admin') THEN
        RAISE EXCEPTION 'Only admin can create delivery fee settings';
    END IF;
    
    -- ถ้าเป็น default ให้ยกเลิก default อื่นๆ ก่อน
    IF is_default_param THEN
        UPDATE delivery_fee_settings 
        SET is_default = false 
        WHERE is_default = true;
    END IF;
    
    -- สร้างการตั้งค่าใหม่
    INSERT INTO delivery_fee_settings (
        name,
        description,
        base_fee,
        distance_fee_per_km,
        max_delivery_distance,
        free_delivery_threshold,
        peak_hour_multiplier,
        peak_hour_start,
        peak_hour_end,
        is_default,
        created_by
    )
    VALUES (
        setting_name,
        setting_description,
        base_fee_param,
        distance_fee_per_km_param,
        max_delivery_distance_param,
        free_delivery_threshold_param,
        peak_hour_multiplier_param,
        peak_hour_start_param,
        peak_hour_end_param,
        is_default_param,
        created_by_user_id
    )
    RETURNING id INTO setting_id;
    
    -- ส่งการแจ้งเตือน
    PERFORM send_notification(
        created_by_user_id,
        'สร้างการตั้งค่าค่าส่งสำเร็จ',
        'สร้างการตั้งค่าค่าส่ง: ' || setting_name,
        'system',
        jsonb_build_object('setting_id', setting_id, 'setting_name', setting_name)
    );
    
    RETURN setting_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.create_new_order(customer_uuid uuid, store_uuid uuid, total_amount numeric, subtotal numeric, delivery_fee numeric, delivery_address text, delivery_latitude numeric, delivery_longitude numeric, payment_method text DEFAULT 'cash'::text, special_instructions text DEFAULT NULL::text)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    order_id UUID;
    order_number TEXT;
    initial_status TEXT;
    store_code TEXT;
    date_str TEXT;
    sequence_num INTEGER;
BEGIN
    -- ดึง code_store จาก stores
    SELECT s.code_store INTO store_code
    FROM stores s
    WHERE s.id = store_uuid;
    
    -- ตรวจสอบว่า code_store มีค่า
    IF store_code IS NULL THEN
        RAISE EXCEPTION 'code_store not found for store_id: %', store_uuid;
    END IF;
    
    date_str := to_char(NOW(), 'YYYYMMDD');
    
    -- หาเลขลำดับสูงสุดของร้านนี้ในวันนี้
    -- รูปแบบใหม่: CODE-YYYYMMDD-0001
    -- รูปแบบเก่า: YYYYMMDD0001 หรือ ORDYYYYMMDD-0001 (จะไม่ถูกนับ)
    -- ดึงเลขลำดับ 4 หลักสุดท้าย (ใช้ RIGHT เพื่อดึง 4 ตัวอักษรสุดท้าย)
    SELECT COALESCE(MAX(CAST(RIGHT(o.order_number, 4) AS INTEGER)), 0) + 1
    INTO sequence_num
    FROM orders o
    WHERE o.store_id = store_uuid
      AND o.order_number LIKE store_code || '-' || date_str || '-%'
      AND LENGTH(o.order_number) = LENGTH(store_code) + 1 + 8 + 1 + 4; -- CODE-YYYYMMDD-0001
    -- หมายเหตุ: order_number เดิมจะไม่ถูกนับ เพราะไม่ตรงกับรูปแบบใหม่
    -- ลำดับจะเริ่มใหม่จาก 0001 สำหรับรูปแบบใหม่
    
    -- สร้างเลขที่ออเดอร์ในรูปแบบ: CODE-YYYYMMDD-0001
    order_number := store_code || '-' || date_str || '-' || LPAD(sequence_num::TEXT, 4, '0');
    
    -- กำหนดสถานะเริ่มต้นตาม payment_method
    initial_status := CASE 
        WHEN payment_method = 'bank_transfer' THEN 'waiting_payment'
        ELSE 'created'
    END;
    
    -- สร้างออเดอร์
    INSERT INTO orders (
        order_number,
        customer_id,
        store_id,
        total_amount,
        subtotal,
        delivery_fee,
        delivery_address,
        delivery_latitude,
        delivery_longitude,
        payment_method,
        special_instructions,
        status
    ) VALUES (
        order_number,
        customer_uuid,
        store_uuid,
        total_amount,
        subtotal,
        delivery_fee,
        delivery_address,
        delivery_latitude,
        delivery_longitude,
        payment_method,
        special_instructions,
        initial_status
    ) RETURNING id INTO order_id;
    
    -- ส่งการแจ้งเตือนร้านค้า
    PERFORM update_order_status_new(order_id, initial_status, customer_uuid, 
        CASE 
            WHEN payment_method = 'bank_transfer' THEN 'Order created with bank transfer payment - waiting for payment'
            ELSE 'Order created successfully'
        END
    );
    
    RETURN order_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.create_product_option(p_product_id uuid, p_name text, p_description text DEFAULT NULL::text, p_is_required boolean DEFAULT false, p_min_selections integer DEFAULT 1, p_max_selections integer DEFAULT 1, p_display_order integer DEFAULT 0)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    option_id UUID;
BEGIN
    INSERT INTO product_options (
        product_id, name, description, is_required, 
        min_selections, max_selections, display_order
    ) VALUES (
        p_product_id, p_name, p_description, p_is_required,
        p_min_selections, p_max_selections, p_display_order
    ) RETURNING id INTO option_id;
    
    RETURN option_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.create_signed_url(bucket_name text, file_path text, expires_in integer DEFAULT 3600)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    signed_url TEXT;
BEGIN
    -- ตรวจสอบสิทธิ์การเข้าถึง
    IF NOT public.check_file_access(bucket_name, file_path, 'read') THEN
        RAISE EXCEPTION 'Access denied';
    END IF;
    
    -- สร้าง signed URL (ต้องใช้ Supabase Storage API ในแอปพลิเคชัน)
    -- ฟังก์ชันนี้จะส่งคืน path ที่จะใช้สร้าง signed URL
    signed_url := bucket_name || '/' || file_path;
    
    RETURN signed_url;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.create_user_from_google(google_id_param text, email_param text, full_name_param text, avatar_url_param text DEFAULT NULL::text, given_name_param text DEFAULT NULL::text, family_name_param text DEFAULT NULL::text, locale_param text DEFAULT NULL::text, picture_param text DEFAULT NULL::text, role_param text DEFAULT 'customer'::text)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    user_id UUID;
BEGIN
    -- ตรวจสอบว่า google_id ซ้ำหรือไม่
    IF EXISTS (SELECT 1 FROM users WHERE google_id = google_id_param) THEN
        RAISE EXCEPTION 'Google ID already exists';
    END IF;
    
    -- ตรวจสอบว่า email ซ้ำหรือไม่
    IF EXISTS (SELECT 1 FROM users WHERE email = email_param) THEN
        RAISE EXCEPTION 'Email already exists';
    END IF;
    
    -- สร้างผู้ใช้ใหม่
    INSERT INTO users (
        google_id,
        email,
        full_name,
        avatar_url,
        google_given_name,
        google_family_name,
        google_locale,
        google_picture,
        role,
        last_login_at,
        login_count
    )
    VALUES (
        google_id_param,
        email_param,
        full_name_param,
        COALESCE(avatar_url_param, picture_param),
        given_name_param,
        family_name_param,
        locale_param,
        picture_param,
        role_param,
        NOW(),
        1
    )
    RETURNING id INTO user_id;
    
    -- ส่งการแจ้งเตือนต้อนรับ
    PERFORM send_notification(
        user_id,
        'ยินดีต้อนรับสู่ระบบ Delivery',
        'ขอบคุณที่สมัครสมาชิกกับเรา กรุณาเลือกบทบาทของคุณ',
        'system',
        jsonb_build_object('user_id', user_id, 'role', role_param)
    );
    
    RETURN user_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.create_user_from_google(google_id_param text, email_param text, full_name_param text, avatar_url_param text DEFAULT NULL::text, phone_param text DEFAULT NULL::text, line_id_param text DEFAULT NULL::text, address_param text DEFAULT NULL::text, latitude_param numeric DEFAULT NULL::numeric, longitude_param numeric DEFAULT NULL::numeric)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    user_id UUID;
BEGIN
    -- ตรวจสอบว่าผู้ใช้มีอยู่แล้วหรือไม่
    SELECT id INTO user_id 
    FROM users 
    WHERE google_id = google_id_param;
    
    IF user_id IS NOT NULL THEN
        -- อัปเดตข้อมูลผู้ใช้ที่มีอยู่
        UPDATE users 
        SET 
            email = email_param,
            full_name = full_name_param,
            avatar_url = COALESCE(avatar_url_param, avatar_url),
            phone = COALESCE(phone_param, phone),
            line_id = COALESCE(line_id_param, line_id),
            address = COALESCE(address_param, address),
            latitude = COALESCE(latitude_param, latitude),
            longitude = COALESCE(longitude_param, longitude),
            last_login_at = NOW(),
            login_count = login_count + 1,
            updated_at = NOW()
        WHERE id = user_id;
    ELSE
        -- สร้างผู้ใช้ใหม่
        INSERT INTO users (
            google_id, 
            email, 
            full_name, 
            avatar_url, 
            phone, 
            line_id, 
            address,
            latitude,
            longitude,
            role, 
            last_login_at, 
            login_count
        ) VALUES (
            google_id_param, 
            email_param, 
            full_name_param, 
            avatar_url_param, 
            phone_param, 
            line_id_param, 
            address_param,
            latitude_param,
            longitude_param,
            'customer', 
            NOW(), 
            1
        ) RETURNING id INTO user_id;
    END IF;
    
    RETURN user_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.create_user_manually(user_id uuid, user_email text, user_name text DEFAULT NULL::text, user_google_id text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    result JSONB;
BEGIN
    -- ตรวจสอบว่าผู้ใช้มีอยู่แล้วหรือไม่
    IF EXISTS (SELECT 1 FROM public.users WHERE id = user_id) THEN
        result := jsonb_build_object(
            'success', false,
            'message', 'User already exists'
        );
    ELSE
        -- สร้างผู้ใช้ใหม่
        INSERT INTO public.users (
            id,
            google_id,
            email,
            full_name,
            role,
            is_active,
            email_verified,
            phone_verified,
            google_verified_email,
            last_login_at,
            login_count,
            created_at,
            updated_at
        )
        VALUES (
            user_id,
            COALESCE(user_google_id, user_id::text),
            user_email,
            COALESCE(user_name, user_email),
            'customer',
            true,
            true,
            false,
            true,
            NOW(),
            1,
            NOW(),
            NOW()
        );
        
        result := jsonb_build_object(
            'success', true,
            'message', 'User created successfully',
            'user_id', user_id
        );
    END IF;
    
    RETURN result;
EXCEPTION
    WHEN OTHERS THEN
        result := jsonb_build_object(
            'success', false,
            'message', 'Error creating user: ' || SQLERRM
        );
        RETURN result;
END;
$function$
;

create or replace view "public"."current_rider_assignments" as  SELECT ra.id AS assignment_id,
    ra.id,
    ra.rider_id,
    ra.order_id,
    ra.status AS assignment_status,
    ra.status,
    ra.assigned_at,
    ra.picked_up_at,
    ra.started_delivery_at,
    ra.completed_at,
    ra.created_at,
    ra.updated_at,
    o.order_number,
    o.total_amount,
    o.subtotal,
    o.delivery_address,
    o.delivery_latitude,
    o.delivery_longitude,
    o.delivery_fee,
    o.distance_km,
    o.delivery_line_id,
    o.status AS order_status,
    o.discount_code,
    o.discount_description,
    o.discount_amount,
    s.name AS store_name,
    s.address AS store_address,
    s.phone AS store_phone,
    s.latitude AS store_latitude,
    s.longitude AS store_longitude,
    u.full_name AS customer_name,
    u.phone AS customer_phone,
    u.email AS customer_email,
    u.line_id AS customer_line_id,
    dc.id AS discount_code_id,
    dc.code AS discount_code_full,
    dc.name AS discount_code_name,
    dc.description AS discount_code_description,
    dc.discount_type,
    dc.discount_value,
    dc.minimum_order_amount,
    dc.maximum_discount_amount,
    dc.usage_limit,
    dc.used_count,
    dc.is_active AS discount_code_active,
    dc.valid_from AS discount_valid_from,
    dc.valid_until AS discount_valid_until,
    od.applied_at AS discount_applied_at,
    od.applied_by AS discount_applied_by,
    COALESCE(( SELECT json_agg(json_build_object('item_name', oi.product_name, 'quantity', oi.quantity, 'price', oi.product_price, 'total_price', oi.total_price, 'special_instructions', oi.special_instructions)) AS json_agg
           FROM public.order_items oi
          WHERE (oi.order_id = o.id)), '[]'::json) AS order_items
   FROM (((((public.rider_assignments ra
     JOIN public.orders o ON ((ra.order_id = o.id)))
     JOIN public.stores s ON ((o.store_id = s.id)))
     JOIN public.users u ON ((o.customer_id = u.id)))
     LEFT JOIN public.discount_codes dc ON ((o.discount_code_id = dc.id)))
     LEFT JOIN public.order_discounts od ON ((o.id = od.order_id)))
  WHERE (ra.status = ANY (ARRAY['assigned'::text, 'picked_up'::text, 'delivering'::text]))
  ORDER BY ra.assigned_at;


create or replace view "public"."daily_sales_report" as  WITH base AS (
         SELECT ((o.created_at AT TIME ZONE 'Asia/Bangkok'::text))::date AS sale_date,
            o.store_id,
            s.name AS store_name,
            count(o.id) AS order_count,
            count(o.id) FILTER (WHERE (o.status = ANY (ARRAY['delivered'::text, 'completed'::text]))) AS completed_orders,
            count(o.id) FILTER (WHERE (o.status = 'cancelled'::text)) AS cancelled_orders,
            COALESCE(sum(o.total_amount), (0)::numeric) AS total_amount_sum,
            COALESCE(sum(COALESCE(o.discount_amount, (0)::numeric)), (0)::numeric) AS discount_amount_sum,
            COALESCE(sum(
                CASE
                    WHEN (o.status <> 'cancelled'::text) THEN o.subtotal
                    ELSE (0)::numeric
                END), (0)::numeric) AS net_revenue,
            COALESCE(avg(
                CASE
                    WHEN (o.status <> 'cancelled'::text) THEN o.subtotal
                    ELSE NULL::numeric
                END), (0)::numeric) AS avg_subtotal,
            count(o.id) FILTER (WHERE (o.discount_code IS NOT NULL)) AS discount_orders,
            COALESCE(sum(
                CASE
                    WHEN ((o.payment_method = 'cash'::text) AND (o.status <> 'cancelled'::text)) THEN o.subtotal
                    ELSE (0)::numeric
                END), (0)::numeric) AS cash_revenue,
            COALESCE(sum(
                CASE
                    WHEN ((o.payment_method = 'bank_transfer'::text) AND (o.status <> 'cancelled'::text)) THEN o.subtotal
                    ELSE (0)::numeric
                END), (0)::numeric) AS transfer_revenue,
            count(o.id) FILTER (WHERE (o.payment_method = 'cash'::text)) AS cash_orders,
            count(o.id) FILTER (WHERE (o.payment_method = 'bank_transfer'::text)) AS transfer_orders,
            count(DISTINCT o.customer_id) AS unique_customers,
            count(DISTINCT o.rider_id) AS unique_riders
           FROM (public.orders o
             LEFT JOIN public.stores s ON ((s.id = o.store_id)))
          WHERE (o.created_at IS NOT NULL)
          GROUP BY (((o.created_at AT TIME ZONE 'Asia/Bangkok'::text))::date), o.store_id, s.name
        )
 SELECT sale_date,
    order_count AS total_orders,
    net_revenue AS total_revenue,
    discount_amount_sum AS total_discount_given,
    (net_revenue + discount_amount_sum) AS gross_revenue,
    avg_subtotal AS average_order_value,
    discount_orders AS orders_with_discount,
        CASE
            WHEN (order_count > 0) THEN (((discount_orders)::numeric * 100.0) / (order_count)::numeric)
            ELSE (0)::numeric
        END AS discount_usage_percentage,
    discount_amount_sum AS total_discount_amount,
    NULL::text AS most_used_discount_code,
    NULL::text AS most_used_discount_count,
    store_id,
    store_name,
    order_count AS daily_orders,
    net_revenue AS daily_revenue,
    total_amount_sum AS total_amount_revenue,
    completed_orders,
    cancelled_orders,
    cash_revenue,
    transfer_revenue,
    cash_orders,
    transfer_orders,
    unique_customers,
    unique_riders
   FROM base
  ORDER BY sale_date DESC, net_revenue DESC;


CREATE OR REPLACE FUNCTION public.deactivate_user_by_admin(user_id_param uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    -- ตรวจสอบว่าเป็น admin หรือไม่
    IF NOT EXISTS (
        SELECT 1 FROM public.users 
        WHERE id = auth.uid() AND role = 'admin'
    ) THEN
        RAISE EXCEPTION 'Only admin can deactivate users';
    END IF;
    
    -- ปิดใช้งานผู้ใช้
    UPDATE public.users 
    SET 
        is_active = false,
        updated_at = NOW()
    WHERE id = user_id_param;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.deduct_credit_on_withdrawal_approved()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_worker_id uuid;
    v_withdrawal_amount numeric(10,2);
    v_current_balance numeric(10,2);
    v_new_balance numeric(10,2);
    v_withdrawal_id uuid;
BEGIN
    -- ตรวจสอบว่าสถานะเปลี่ยนเป็น 'approved' และยังไม่ได้หักเครดิต
    -- ตรวจสอบว่า OLD.status != 'approved' เพื่อป้องกันการหักซ้ำ
    IF NEW.status = 'approved' 
       AND OLD.status != 'approved' THEN
        
        v_worker_id := NEW.worker_id;
        v_withdrawal_amount := NEW.amount;
        v_withdrawal_id := NEW.id;

        -- 1. ดึงยอดคงเหลือปัจจุบัน
        SELECT available_balance INTO v_current_balance
        FROM public.job_worker_credits
        WHERE worker_id = v_worker_id;

        -- ถ้าไม่มี record ใน job_worker_credits ให้สร้างใหม่
        IF v_current_balance IS NULL THEN
            INSERT INTO public.job_worker_credits (
                worker_id,
                available_balance,
                pending_balance,
                total_earned,
                last_transaction_at,
                updated_at
            )
            VALUES (
                v_worker_id,
                0,
                0,
                0,
                now(),
                now()
            );
            v_current_balance := 0;
        END IF;

        -- 2. ตรวจสอบว่ายอดคงเหลือเพียงพอหรือไม่
        IF v_current_balance < v_withdrawal_amount THEN
            -- ถ้าไม่เพียงพอ ให้ reject การอัพเดท
            RAISE EXCEPTION 'ยอดคงเหลือไม่เพียงพอ (คงเหลือ: %, ต้องการ: %)', 
                v_current_balance, v_withdrawal_amount;
        END IF;

        -- 3. คำนวณยอดคงเหลือใหม่
        v_new_balance := v_current_balance - v_withdrawal_amount;

        -- 4. อัพเดท job_worker_credits - หักเครดิต
        UPDATE public.job_worker_credits
        SET 
            available_balance = v_new_balance,
            last_transaction_at = now(),
            updated_at = now()
        WHERE worker_id = v_worker_id;

        -- 5. อัพเดท job_workers (credit_balance - cache)
        UPDATE public.job_workers
        SET 
            credit_balance = v_new_balance,
            updated_at = now()
        WHERE id = v_worker_id;

        -- 6. บันทึก Withdrawal transaction ใน ledger
        INSERT INTO public.job_worker_credit_ledger (
            worker_id,
            job_assignment_id,
            transaction_type,
            amount,
            balance_after,
            reason_code,
            description,
            payment_method,
            bank_account_number,
            bank_account_name,
            bank_name,
            transfer_reference,
            withdrawal_status,
            processed_by,
            created_at
        )
        VALUES (
            v_worker_id,
            NULL,  -- withdrawal ไม่ได้เกี่ยวกับ job_assignment
            'withdrawal',
            -v_withdrawal_amount,  -- เป็นลบเพราะหักออก
            v_new_balance,
            'WITHDRAWAL',
            'ถอนเงิน: ' || COALESCE(NEW.bank_name, '') || ' - ' || COALESCE(NEW.bank_account_number, ''),
            'bank_transfer',
            NEW.bank_account_number,
            NEW.bank_account_name,
            NEW.bank_name,
            NEW.transfer_reference,
            'completed',  -- ใช้ 'completed' ใน ledger เพราะ ledger ยังใช้ status เดิม
            NEW.processed_by,
            now()
        );

        -- 7. อัพเดท processed_at ถ้ายังไม่ได้ set
        IF NEW.processed_at IS NULL THEN
            NEW.processed_at := now();
        END IF;

    END IF;

    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.delete_chat_image()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- ลบรูปภาพจาก Storage เมื่อลบข้อความแชท
    IF OLD.message_type = 'image' THEN
        -- ดึงชื่อไฟล์จาก URL
        DECLARE
            file_path TEXT;
        BEGIN
            -- แยกชื่อไฟล์จาก URL
            file_path := substring(OLD.message from 'chat-images/(.*)');
            
            IF file_path IS NOT NULL THEN
                -- ลบไฟล์จาก Storage
                DELETE FROM storage.objects 
                WHERE bucket_id = 'chat-images' 
                AND name = file_path;
            END IF;
        END;
    END IF;
    
    RETURN OLD;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.delete_community_comment_image()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF OLD.image_file_path IS NOT NULL THEN
        DELETE FROM storage.objects 
        WHERE bucket_id = 'post-images' 
        AND name = OLD.image_file_path;  -- ใช้ column "name" แทน "file_path"
        
        RAISE NOTICE 'Deleted comment image: %', OLD.image_file_path;
    ELSE
        RAISE NOTICE 'No image to delete for comment: %', OLD.id;
    END IF;
    
    RETURN OLD;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.delete_community_post_images()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- ตรวจสอบว่าโพสต์มีรูปภาพหรือไม่
    IF EXISTS (SELECT 1 FROM public.community_post_images WHERE post_id = OLD.id) THEN
        -- ลบรูปภาพในโพสต์ (ใช้ column "name" แทน "file_path")
        DELETE FROM storage.objects 
        WHERE bucket_id = 'post-images' 
        AND name IN (
            SELECT file_path 
            FROM public.community_post_images 
            WHERE post_id = OLD.id
        );
        
        RAISE NOTICE 'Deleted post images for post: %', OLD.id;
    ELSE
        RAISE NOTICE 'No images to delete for post: %', OLD.id;
    END IF;
    
    -- ตรวจสอบว่ามีรูปภาพในคอมเมนต์หรือไม่
    IF EXISTS (SELECT 1 FROM public.community_comments WHERE post_id = OLD.id AND image_file_path IS NOT NULL) THEN
        -- ลบรูปภาพในคอมเมนต์
        DELETE FROM storage.objects 
        WHERE bucket_id = 'post-images' 
        AND name IN (
            SELECT image_file_path 
            FROM public.community_comments 
            WHERE post_id = OLD.id AND image_file_path IS NOT NULL
        );
        
        RAISE NOTICE 'Deleted comment images for post: %', OLD.id;
    ELSE
        RAISE NOTICE 'No comment images to delete for post: %', OLD.id;
    END IF;
    
    RETURN OLD;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.delete_delivery_note(p_note_id uuid, p_user_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM public.delivery_notes 
    WHERE id = p_note_id AND user_id = p_user_id;
    
    RETURN FOUND;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.delete_file_from_storage(bucket_name text, file_path text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    result JSONB;
BEGIN
    -- ฟังก์ชันนี้จะถูกเรียกจากแอปพลิเคชันเพื่อลบไฟล์จาก Storage
    -- เนื่องจาก Supabase ไม่มีฟังก์ชันลบไฟล์โดยตรงใน SQL
    
    result := jsonb_build_object(
        'success', true,
        'bucket', bucket_name,
        'file_path', file_path,
        'message', 'File marked for deletion. Use Supabase Storage API to delete the actual file.'
    );
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.delete_order_review(p_review_id uuid, p_customer_id uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM public.order_reviews
    WHERE id = p_review_id AND customer_id = p_customer_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Review not found or does not belong to customer';
    END IF;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.delete_product_image(product_id_param uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    product_record RECORD;
    old_image_url TEXT;
    result JSONB;
BEGIN
    -- ตรวจสอบว่าเป็นเจ้าของสินค้า
    SELECT p.*, s.owner_id INTO product_record 
    FROM public.products p
    JOIN public.stores s ON p.store_id = s.id
    WHERE p.id = product_id_param AND s.owner_id = auth.uid();
    
    IF product_record IS NULL THEN
        RAISE EXCEPTION 'Product not found or unauthorized';
    END IF;
    
    -- เก็บ URL รูปภาพเก่า
    old_image_url := product_record.image_url;
    
    -- ลบรูปภาพจากฐานข้อมูล
    UPDATE public.products 
    SET 
        image_url = NULL,
        updated_at = NOW()
    WHERE id = product_id_param;
    
    result := jsonb_build_object(
        'success', true,
        'product_id', product_id_param,
        'old_image_url', old_image_url,
        'bucket', 'product-images',
        'message', 'Product image deleted successfully'
    );
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.delete_rider_review(p_review_id uuid, p_customer_id uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_rider_id uuid;
    v_old_rating numeric;
BEGIN
    -- ดึงข้อมูลรีวิวก่อนลบ
    SELECT rider_id, rating INTO v_rider_id, v_old_rating
    FROM public.rider_reviews
    WHERE id = p_review_id AND customer_id = p_customer_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Review not found or does not belong to customer';
    END IF;
    
    -- ลบรีวิว
    DELETE FROM public.rider_reviews
    WHERE id = p_review_id AND customer_id = p_customer_id;
    
    -- อัปเดตคะแนนไรเดอร์ใหม่โดยคำนวณจากรีวิวที่เหลือ
    UPDATE public.riders
    SET 
        rating = COALESCE((
            SELECT AVG(rating) 
            FROM public.rider_reviews 
            WHERE rider_id = v_rider_id
        ), 0),
        total_ratings = (
            SELECT COUNT(*) 
            FROM public.rider_reviews 
            WHERE rider_id = v_rider_id
        ),
        updated_at = NOW()
    WHERE id = v_rider_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.delete_user_avatar()
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    user_record RECORD;
    old_avatar_url TEXT;
    result JSONB;
BEGIN
    -- ดึงข้อมูลผู้ใช้ปัจจุบัน
    SELECT * INTO user_record 
    FROM public.users 
    WHERE id = auth.uid();
    
    IF user_record IS NULL THEN
        RAISE EXCEPTION 'User not found';
    END IF;
    
    -- เก็บ URL เดิมไว้
    old_avatar_url := user_record.avatar_url;
    
    -- ลบรูปโปรไฟล์ (ตั้งค่าเป็น NULL)
    UPDATE public.users 
    SET 
        avatar_url = NULL,
        updated_at = NOW()
    WHERE id = auth.uid();
    
    result := jsonb_build_object(
        'success', true,
        'user_id', user_record.id,
        'old_avatar_url', old_avatar_url,
        'bucket', 'user-avatars',
        'message', 'Avatar deleted successfully'
    );
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.delete_user_by_admin(user_id_param uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    -- ตรวจสอบว่าเป็น admin หรือไม่
    IF NOT EXISTS (
        SELECT 1 FROM public.users 
        WHERE id = auth.uid() AND role = 'admin'
    ) THEN
        RAISE EXCEPTION 'Only admin can delete users';
    END IF;
    
    -- ลบผู้ใช้
    DELETE FROM public.users WHERE id = user_id_param;
END;
$function$
;

create or replace view "public"."delivery_fee_config_v2_view" as  SELECT c.id,
    c.name,
    c.description,
    c.is_active,
    c.is_default,
    c.max_delivery_distance,
    c.free_delivery_threshold,
    c.peak_hour_multiplier,
    c.peak_hour_start,
    c.peak_hour_end,
    count(t.id) AS tier_count,
    min(t.fee) AS min_fee,
    max(t.fee) AS max_fee,
    c.created_at,
    c.updated_at
   FROM (public.delivery_fee_config_v2 c
     LEFT JOIN public.delivery_fee_tiers t ON ((c.id = t.config_id)))
  GROUP BY c.id, c.name, c.description, c.is_active, c.is_default, c.max_delivery_distance, c.free_delivery_threshold, c.peak_hour_multiplier, c.peak_hour_start, c.peak_hour_end, c.created_at, c.updated_at;


create or replace view "public"."delivery_fee_report" as  SELECT o.id AS order_id,
    o.order_number,
    o.delivery_fee,
    o.calculated_delivery_fee,
    o.distance_km,
    o.subtotal,
    o.total_amount,
    s.name AS store_name,
    s.address AS store_address,
    o.delivery_address,
    u.full_name AS customer_name,
    o.created_at AS order_date,
        CASE
            WHEN (o.delivery_fee = (0)::numeric) THEN 'ฟรี'::text
            WHEN (o.delivery_fee <= (30)::numeric) THEN 'ต่ำ'::text
            WHEN (o.delivery_fee <= (60)::numeric) THEN 'ปานกลาง'::text
            ELSE 'สูง'::text
        END AS fee_level
   FROM ((public.orders o
     JOIN public.stores s ON ((o.store_id = s.id)))
     JOIN public.users u ON ((o.customer_id = u.id)))
  WHERE (o.delivery_fee > (0)::numeric)
  ORDER BY o.created_at DESC;


create or replace view "public"."delivery_fee_statistics" as  SELECT date(created_at) AS delivery_date,
    count(id) AS total_orders,
    avg(delivery_fee) AS avg_delivery_fee,
    min(delivery_fee) AS min_delivery_fee,
    max(delivery_fee) AS max_delivery_fee,
    sum(delivery_fee) AS total_delivery_fees,
    avg(distance_km) AS avg_distance,
    count(
        CASE
            WHEN (delivery_fee = (0)::numeric) THEN 1
            ELSE NULL::integer
        END) AS free_deliveries,
    count(
        CASE
            WHEN (delivery_fee > (0)::numeric) THEN 1
            ELSE NULL::integer
        END) AS paid_deliveries
   FROM public.orders o
  WHERE (created_at >= (CURRENT_DATE - '30 days'::interval))
  GROUP BY (date(created_at))
  ORDER BY (date(created_at)) DESC;


create or replace view "public"."discount_usage_summary" as  SELECT dc.code,
    dc.name,
    dc.discount_type,
    dc.discount_value,
    dc.used_count,
    dc.usage_limit,
    COALESCE(sum(od.discount_amount), (0)::numeric) AS total_discount_given,
    count(od.id) AS total_orders_used,
    dc.valid_from,
    dc.valid_until,
    dc.is_active
   FROM (public.discount_codes dc
     LEFT JOIN public.order_discounts od ON ((dc.id = od.discount_code_id)))
  GROUP BY dc.id, dc.code, dc.name, dc.discount_type, dc.discount_value, dc.used_count, dc.usage_limit, dc.valid_from, dc.valid_until, dc.is_active;


CREATE OR REPLACE FUNCTION public.emergency_cancel_order(order_uuid uuid, customer_user_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    order_exists BOOLEAN;
    current_status TEXT;
BEGIN
    -- ตรวจสอบว่าออเดอร์มีอยู่และเป็นของลูกค้านี้
    SELECT EXISTS(
        SELECT 1 FROM orders 
        WHERE id = order_uuid 
        AND customer_id = customer_user_id
    ) INTO order_exists;
    
    IF NOT order_exists THEN
        RAISE EXCEPTION 'Order not found or not authorized';
    END IF;
    
    -- ตรวจสอบสถานะปัจจุบัน
    SELECT status INTO current_status 
    FROM orders 
    WHERE id = order_uuid;
    
    -- ตรวจสอบว่าสามารถยกเลิกได้หรือไม่
    IF NOT (current_status IN ('pending', 'accepted')) THEN
        RAISE EXCEPTION 'Order cannot be cancelled in current status: %', current_status;
    END IF;
    
    -- ปิด triggers ชั่วคราว
    SET session_replication_role = replica;
    
    -- อัปเดตสถานะโดยตรง
    UPDATE orders 
    SET 
        status = 'cancelled',
        updated_at = NOW()
    WHERE id = order_uuid;
    
    -- เปิด triggers กลับมา
    SET session_replication_role = DEFAULT;
    
    -- เพิ่มประวัติการเปลี่ยนแปลงสถานะ (ถ้าตารางมีอยู่)
    BEGIN
        INSERT INTO order_status_history (order_id, status, updated_by, notes)
        VALUES (order_uuid, 'cancelled', customer_user_id, 'ลูกค้ายกเลิกออเดอร์');
    EXCEPTION
        WHEN undefined_table THEN
            NULL;
    END;
    
    -- สร้างการแจ้งเตือน (ถ้าตารางมีอยู่)
    BEGIN
        INSERT INTO notifications (user_id, title, message, type, data)
        VALUES (
            customer_user_id,
            'ออเดอร์ถูกยกเลิก',
            'ออเดอร์ของคุณถูกยกเลิกแล้ว',
            'order_update',
            jsonb_build_object('order_id', order_uuid, 'status', 'cancelled')
        );
    EXCEPTION
        WHEN undefined_table THEN
            NULL;
    END;
END;
$function$
;

create or replace view "public"."employer_job_postings" as  SELECT jp.id AS job_posting_id,
    jp.job_number,
    jp.title,
    jp.description,
    jp.job_price,
    jp.category_id,
    jc.name AS category_name,
    jc.icon_url AS category_icon,
    jp.status,
    jp.employer_address,
    jp.employer_latitude,
    jp.employer_longitude,
    jp.estimated_completion_time,
    jp.actual_completion_time,
    jp.special_instructions,
    jp.payment_method,
    jp.payment_status,
    jp.worker_id,
    jw.user_id AS worker_user_id,
    u.full_name AS worker_name,
    u.phone AS worker_phone,
    u.line_id AS worker_line_id,
    ja.id AS assignment_id,
    ja.status AS assignment_status,
    ja.assigned_at,
    ja.started_at,
    ja.completed_at,
    ja.rating_by_employer,
    ja.rating_by_worker,
    ja.review_by_employer,
    ja.review_by_worker,
    jp.created_at,
    jp.updated_at
   FROM ((((public.job_postings jp
     LEFT JOIN public.job_categories jc ON ((jp.category_id = jc.id)))
     LEFT JOIN public.job_workers jw ON ((jp.worker_id = jw.id)))
     LEFT JOIN public.users u ON ((jw.user_id = u.id)))
     LEFT JOIN public.job_assignments ja ON ((jp.id = ja.job_posting_id)))
  ORDER BY jp.created_at DESC;


CREATE OR REPLACE FUNCTION public.ensure_fcm_tokens_on_insert()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    sender_fcm TEXT;
    recipient_fcm TEXT;
BEGIN
    -- ดึง FCM token ของผู้ส่ง
    IF NEW.sender_fcm_token IS NULL OR NEW.sender_fcm_token = '' THEN
        IF NEW.sender_type = 'rider' THEN
            sender_fcm := get_rider_fcm_token(NEW.sender_id);
        ELSE
            sender_fcm := (
                SELECT fcm_token 
                FROM users 
                WHERE id = NEW.sender_id
                AND fcm_token IS NOT NULL
                AND fcm_token != ''
            );
        END IF;
        
        IF sender_fcm IS NOT NULL THEN
            NEW.sender_fcm_token := sender_fcm;
        END IF;
    END IF;

    -- ดึง FCM token ของผู้รับ
    IF NEW.recipient_fcm_token IS NULL OR NEW.recipient_fcm_token = '' THEN
        IF NEW.sender_type = 'rider' THEN
            recipient_fcm := get_customer_fcm_token(NEW.order_id);
        ELSE
            recipient_fcm := get_assigned_rider_fcm_token(NEW.order_id);
        END IF;
        
        IF recipient_fcm IS NOT NULL THEN
            NEW.recipient_fcm_token := recipient_fcm;
        END IF;
    END IF;

    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.ensure_fcm_tokens_on_update()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    sender_fcm TEXT;
    recipient_fcm TEXT;
BEGIN
    -- ดึง FCM token ของผู้ส่ง
    IF NEW.sender_fcm_token IS NULL OR NEW.sender_fcm_token = '' THEN
        IF NEW.sender_type = 'rider' THEN
            sender_fcm := get_rider_fcm_token(NEW.sender_id);
        ELSE
            sender_fcm := (
                SELECT fcm_token 
                FROM users 
                WHERE id = NEW.sender_id
                AND fcm_token IS NOT NULL
                AND fcm_token != ''
            );
        END IF;
        
        IF sender_fcm IS NOT NULL THEN
            NEW.sender_fcm_token := sender_fcm;
        END IF;
    END IF;

    -- ดึง FCM token ของผู้รับ
    IF NEW.recipient_fcm_token IS NULL OR NEW.recipient_fcm_token = '' THEN
        IF NEW.sender_type = 'rider' THEN
            recipient_fcm := get_customer_fcm_token(NEW.order_id);
        ELSE
            recipient_fcm := get_assigned_rider_fcm_token(NEW.order_id);
        END IF;
        
        IF recipient_fcm IS NOT NULL THEN
            NEW.recipient_fcm_token := recipient_fcm;
        END IF;
    END IF;

    RETURN NEW;
END;
$function$
;

create or replace view "public"."expiring_documents_view" as  SELECT r.id AS rider_id,
    u.full_name AS rider_name,
    u.phone AS rider_phone,
    u.line_id AS rider_line_id,
    'driver_license'::text AS document_type,
    r.driver_license_expiry AS expiry_date,
    (r.driver_license_expiry - CURRENT_DATE) AS days_until_expiry
   FROM (public.riders r
     JOIN public.users u ON ((r.user_id = u.id)))
  WHERE ((r.driver_license_expiry IS NOT NULL) AND (r.driver_license_expiry <= (CURRENT_DATE + '30 days'::interval)) AND (r.driver_license_expiry > CURRENT_DATE))
UNION ALL
 SELECT r.id AS rider_id,
    u.full_name AS rider_name,
    u.phone AS rider_phone,
    u.line_id AS rider_line_id,
    'car_tax'::text AS document_type,
    r.car_tax_expiry AS expiry_date,
    (r.car_tax_expiry - CURRENT_DATE) AS days_until_expiry
   FROM (public.riders r
     JOIN public.users u ON ((r.user_id = u.id)))
  WHERE ((r.car_tax_expiry IS NOT NULL) AND (r.car_tax_expiry <= (CURRENT_DATE + '30 days'::interval)) AND (r.car_tax_expiry > CURRENT_DATE))
UNION ALL
 SELECT r.id AS rider_id,
    u.full_name AS rider_name,
    u.phone AS rider_phone,
    u.line_id AS rider_line_id,
    'insurance'::text AS document_type,
    r.insurance_expiry AS expiry_date,
    (r.insurance_expiry - CURRENT_DATE) AS days_until_expiry
   FROM (public.riders r
     JOIN public.users u ON ((r.user_id = u.id)))
  WHERE ((r.insurance_expiry IS NOT NULL) AND (r.insurance_expiry <= (CURRENT_DATE + '30 days'::interval)) AND (r.insurance_expiry > CURRENT_DATE))
  ORDER BY 7;


create or replace view "public"."fcm_store_monitoring" as  SELECT s.name AS store_name,
    s.id AS store_id,
    count(fs.id) AS total_tokens,
    count(
        CASE
            WHEN (fs.is_active = true) THEN 1
            ELSE NULL::integer
        END) AS active_tokens,
    count(
        CASE
            WHEN (fs.is_active = false) THEN 1
            ELSE NULL::integer
        END) AS inactive_tokens,
    max(fs.last_used_at) AS last_activity,
    min(fs.created_at) AS first_token_created
   FROM (public.stores s
     LEFT JOIN public.fcm_store fs ON ((s.id = fs.store_id)))
  GROUP BY s.id, s.name
  ORDER BY (count(
        CASE
            WHEN (fs.is_active = true) THEN 1
            ELSE NULL::integer
        END)) DESC;


CREATE OR REPLACE FUNCTION public.fix_all_missing_fcm_tokens()
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    updated_count INTEGER := 0;
    message_record RECORD;
    rider_fcm TEXT;
    customer_fcm TEXT;
BEGIN
    -- อัปเดตข้อความที่ sender_type = 'customer' และ recipient_fcm_token เป็น null
    FOR message_record IN 
        SELECT id, order_id
        FROM chat_messages 
        WHERE sender_type = 'customer'
        AND (recipient_fcm_token IS NULL OR recipient_fcm_token = '')
    LOOP
        -- ดึง FCM token ของไรเดอร์
        rider_fcm := (
            SELECT u.fcm_token
            FROM users u
            JOIN rider_profile_view rpv ON u.id = rpv.user_id
            JOIN rider_assignments ra ON rpv.rider_id = ra.rider_id
            WHERE ra.order_id = message_record.order_id
            AND ra.status IN ('assigned', 'picked_up', 'delivering')
            AND u.fcm_token IS NOT NULL
            AND u.fcm_token != ''
            LIMIT 1
        );

        -- อัปเดต recipient_fcm_token
        IF rider_fcm IS NOT NULL THEN
            UPDATE chat_messages 
            SET recipient_fcm_token = rider_fcm
            WHERE id = message_record.id;
            updated_count := updated_count + 1;
        END IF;
    END LOOP;

    -- อัปเดตข้อความที่ sender_type = 'rider' และ recipient_fcm_token เป็น null
    FOR message_record IN 
        SELECT id, order_id
        FROM chat_messages 
        WHERE sender_type = 'rider'
        AND (recipient_fcm_token IS NULL OR recipient_fcm_token = '')
    LOOP
        -- ดึง FCM token ของลูกค้า
        customer_fcm := (
            SELECT u.fcm_token
            FROM users u
            JOIN orders o ON u.id = o.customer_id
            WHERE o.id = message_record.order_id
            AND u.fcm_token IS NOT NULL
            AND u.fcm_token != ''
            LIMIT 1
        );

        -- อัปเดต recipient_fcm_token
        IF customer_fcm IS NOT NULL THEN
            UPDATE chat_messages 
            SET recipient_fcm_token = customer_fcm
            WHERE id = message_record.id;
            updated_count := updated_count + 1;
        END IF;
    END LOOP;

    RETURN updated_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.fix_fcm_tokens_for_order(order_uuid uuid)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    updated_count INTEGER := 0;
    message_record RECORD;
    sender_fcm TEXT;
    recipient_fcm TEXT;
BEGIN
    -- อัปเดตข้อความที่ sender_fcm_token เป็น null
    FOR message_record IN 
        SELECT id, sender_type, sender_id
        FROM chat_messages 
        WHERE order_id = order_uuid
        AND (sender_fcm_token IS NULL OR sender_fcm_token = '')
    LOOP
        -- ดึง FCM token ของผู้ส่ง
        IF message_record.sender_type = 'rider' THEN
            sender_fcm := get_rider_fcm_token(message_record.sender_id);
        ELSE
            sender_fcm := (
                SELECT fcm_token 
                FROM users 
                WHERE id = message_record.sender_id
                AND fcm_token IS NOT NULL
                AND fcm_token != ''
            );
        END IF;

        -- อัปเดต sender_fcm_token
        IF sender_fcm IS NOT NULL THEN
            UPDATE chat_messages 
            SET sender_fcm_token = sender_fcm
            WHERE id = message_record.id;
            updated_count := updated_count + 1;
        END IF;
    END LOOP;

    -- อัปเดตข้อความที่ recipient_fcm_token เป็น null
    FOR message_record IN 
        SELECT id, sender_type
        FROM chat_messages 
        WHERE order_id = order_uuid
        AND (recipient_fcm_token IS NULL OR recipient_fcm_token = '')
    LOOP
        -- ดึง FCM token ของผู้รับ
        IF message_record.sender_type = 'rider' THEN
            recipient_fcm := get_customer_fcm_token(order_uuid);
        ELSE
            recipient_fcm := get_assigned_rider_fcm_token(order_uuid);
        END IF;

        -- อัปเดต recipient_fcm_token
        IF recipient_fcm IS NOT NULL THEN
            UPDATE chat_messages 
            SET recipient_fcm_token = recipient_fcm
            WHERE id = message_record.id;
            updated_count := updated_count + 1;
        END IF;
    END LOOP;

    RETURN updated_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.generate_beauty_booking_number()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_year text;
    v_sequence integer;
    v_booking_number text;
BEGIN
    v_year := EXTRACT(YEAR FROM NOW())::text;
    
    SELECT nextval('public.beauty_booking_number_seq') INTO v_sequence;
    
    v_booking_number := 'BBN-' || v_year || '-' || LPAD(v_sequence::text, 6, '0');
    
    RETURN v_booking_number;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.generate_file_name(original_name text, file_type text, entity_id uuid DEFAULT NULL::uuid)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    file_extension TEXT;
    timestamp_text TEXT;
    random_suffix TEXT;
    new_file_name TEXT;
BEGIN
    -- ดึงนามสกุลไฟล์
    file_extension := LOWER(SUBSTRING(original_name FROM '\.([^.]*)$'));
    
    -- สร้าง timestamp
    timestamp_text := to_char(NOW(), 'YYYYMMDD_HH24MISS');
    
    -- สร้าง random suffix (4 ตัวอักษร)
    random_suffix := SUBSTRING(MD5(RANDOM()::TEXT) FROM 1 FOR 4);
    
    -- สร้างชื่อไฟล์ใหม่
    CASE file_type
        WHEN 'avatar' THEN
            new_file_name := 'avatar_' || timestamp_text || '_' || random_suffix || '.' || file_extension;
        WHEN 'store_logo' THEN
            new_file_name := 'logo_' || timestamp_text || '_' || random_suffix || '.' || file_extension;
        WHEN 'store_banner' THEN
            new_file_name := 'banner_' || timestamp_text || '_' || random_suffix || '.' || file_extension;
        WHEN 'product' THEN
            new_file_name := 'product_' || timestamp_text || '_' || random_suffix || '.' || file_extension;
        WHEN 'document' THEN
            new_file_name := 'doc_' || timestamp_text || '_' || random_suffix || '.' || file_extension;
        WHEN 'payment_slip' THEN
            new_file_name := 'slip_' || timestamp_text || '_' || random_suffix || '.' || file_extension;
        WHEN 'ads' THEN
            new_file_name := 'ads_' || timestamp_text || '_' || random_suffix || '.' || file_extension;
        WHEN 'store_category' THEN
            new_file_name := 'category_' || timestamp_text || '_' || random_suffix || '.' || file_extension;
        ELSE
            new_file_name := 'file_' || timestamp_text || '_' || random_suffix || '.' || file_extension;
    END CASE;
    
    RETURN new_file_name;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.generate_file_path(user_id_param uuid, file_type text, file_name text, entity_id uuid DEFAULT NULL::uuid)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    file_path TEXT;
BEGIN
    CASE file_type
        WHEN 'avatar' THEN
            file_path := user_id_param::TEXT || '/avatar/' || file_name;
        WHEN 'store_logo' THEN
            file_path := user_id_param::TEXT || '/stores/' || entity_id::TEXT || '/logo/' || file_name;
        WHEN 'store_banner' THEN
            file_path := user_id_param::TEXT || '/stores/' || entity_id::TEXT || '/banner/' || file_name;
        WHEN 'product' THEN
            file_path := user_id_param::TEXT || '/products/' || entity_id::TEXT || '/' || file_name;
        WHEN 'document' THEN
            file_path := user_id_param::TEXT || '/documents/' || file_name;
        WHEN 'payment_slip' THEN
            file_path := user_id_param::TEXT || '/payments/' || entity_id::TEXT || '/' || file_name;
        WHEN 'ads' THEN
            file_path := 'ads-' || to_char(NOW(), 'YYYYMMDD') || '/' || file_name;
        WHEN 'store_category' THEN
            file_path := entity_id::TEXT || '/' || file_name;
        ELSE
            file_path := user_id_param::TEXT || '/others/' || file_name;
    END CASE;
    
    RETURN file_path;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.generate_hotel_booking_number()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_year text;
    v_sequence integer;
    v_booking_number text;
BEGIN
    v_year := EXTRACT(YEAR FROM NOW())::text;
    
    SELECT nextval('public.hotel_booking_number_seq') INTO v_sequence;
    
    v_booking_number := 'HBN-' || v_year || '-' || LPAD(v_sequence::text, 6, '0');
    
    RETURN v_booking_number;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.generate_order_number()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    new_order_number TEXT;
    date_str TEXT;
    sequence_num INTEGER;
    store_code TEXT;
BEGIN
    -- ตรวจสอบว่า store_id มีค่า
    IF NEW.store_id IS NULL THEN
        RAISE EXCEPTION 'store_id cannot be NULL when generating order_number';
    END IF;
    
    -- ดึง code_store จาก stores
    SELECT s.code_store INTO store_code
    FROM stores s
    WHERE s.id = NEW.store_id;
    
    -- ตรวจสอบว่า code_store มีค่า
    IF store_code IS NULL THEN
        RAISE EXCEPTION 'code_store not found for store_id: %', NEW.store_id;
    END IF;
    
    date_str := to_char(NOW(), 'YYYYMMDD');
    
    -- หาเลขลำดับสูงสุดของร้านนี้ในวันนี้
    -- รูปแบบใหม่: CODE-YYYYMMDD-0001
    -- รูปแบบเก่า: YYYYMMDD0001 หรือ ORDYYYYMMDD-0001 (จะไม่ถูกนับ)
    -- ดึงเลขลำดับ 4 หลักสุดท้าย (ใช้ RIGHT เพื่อดึง 4 ตัวอักษรสุดท้าย)
    SELECT COALESCE(MAX(CAST(RIGHT(o.order_number, 4) AS INTEGER)), 0) + 1
    INTO sequence_num
    FROM orders o
    WHERE o.store_id = NEW.store_id
      AND o.order_number LIKE store_code || '-' || date_str || '-%'
      AND LENGTH(o.order_number) = LENGTH(store_code) + 1 + 8 + 1 + 4; -- CODE-YYYYMMDD-0001
    -- หมายเหตุ: order_number เดิมจะไม่ถูกนับ เพราะไม่ตรงกับรูปแบบใหม่
    -- ลำดับจะเริ่มใหม่จาก 0001 สำหรับรูปแบบใหม่
    
    -- สร้าง order_number ในรูปแบบ: CODE-YYYYMMDD-0001
    new_order_number := store_code || '-' || date_str || '-' || LPAD(sequence_num::TEXT, 4, '0');
    
    -- กำหนดค่า order_number ให้กับ NEW record
    NEW.order_number := new_order_number;
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.generate_preorder_number()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.preorder_number = 'PRE' || TO_CHAR(now(), 'YYYYMMDD') || '-' || LPAD(NEXTVAL('preorder_number_seq')::text, 4, '0');
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.generate_product_image_name(original_name text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    file_extension TEXT;
    timestamp_text TEXT;
    random_suffix TEXT;
    new_file_name TEXT;
BEGIN
    -- ดึงนามสกุลไฟล์
    file_extension := split_part(original_name, '.', -1);
    
    -- สร้าง timestamp
    timestamp_text := to_char(NOW(), 'YYYYMMDD_HH24MISS');
    
    -- สร้างสตริงสุ่ม 8 ตัวอักษร
    random_suffix := substr(md5(random()::text), 1, 8);
    
    -- สร้างชื่อไฟล์ใหม่
    new_file_name := 'product_' || timestamp_text || '_' || random_suffix || '.' || file_extension;
    
    RETURN new_file_name;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.generate_product_image_name(original_name text, product_id uuid)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    file_extension TEXT;
    timestamp_text TEXT;
    random_suffix TEXT;
    new_file_name TEXT;
BEGIN
    -- ดึงนามสกุลไฟล์
    file_extension := split_part(original_name, '.', -1);
    
    -- สร้าง timestamp
    timestamp_text := to_char(NOW(), 'YYYYMMDD_HH24MISS');
    
    -- สร้างสตริงสุ่ม 8 ตัวอักษร
    random_suffix := substr(md5(random()::text), 1, 8);
    
    -- สร้างชื่อไฟล์ใหม่
    new_file_name := 'product_' || timestamp_text || '_' || random_suffix || '.' || file_extension;
    
    RETURN new_file_name;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.generate_product_image_path(store_id uuid, product_id uuid, file_name text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- สร้าง path: storeID/productId/filename
    RETURN store_id::TEXT || '/' || product_id::TEXT || '/' || file_name;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.generate_store_code()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    new_code TEXT;
    chars TEXT := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    code_length INTEGER := 4;
    random_char TEXT;
    i INTEGER;
    code_exists BOOLEAN;
BEGIN
    -- สร้างรหัส 4 ตัวอักษรแบบสุ่ม
    LOOP
        new_code := '';
        FOR i IN 1..code_length LOOP
            random_char := SUBSTRING(chars, FLOOR(RANDOM() * LENGTH(chars) + 1)::INTEGER, 1);
            new_code := new_code || random_char;
        END LOOP;
        
        -- ตรวจสอบว่ารหัสซ้ำหรือไม่
        SELECT EXISTS(SELECT 1 FROM stores WHERE code_store = new_code) INTO code_exists;
        
        -- ถ้าไม่ซ้ำให้ออกจาก loop
        EXIT WHEN NOT code_exists;
    END LOOP;
    
    -- กำหนดค่า code_store ให้กับ NEW record
    NEW.code_store := new_code;
    
    RETURN NEW;
END;
$function$
;

-- create type "public"."geometry_dump" as ("path" integer[], "geom" public.geometry);

CREATE OR REPLACE FUNCTION public.get_active_beauty_salons()
 RETURNS TABLE(id uuid, salon_name text, description text, address text, phone text, latitude numeric, longitude numeric, rating numeric, total_reviews integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        bs.id,
        bs.salon_name,
        bs.description,
        bs.address,
        bs.phone,
        bs.latitude,
        bs.longitude,
        COALESCE(AVG(br.rating), 0) as rating,
        COUNT(br.id) as total_reviews
    FROM public.beauty_salons bs
    LEFT JOIN public.beauty_reviews br ON bs.id = br.salon_id
    WHERE bs.is_active = true AND bs.is_verified = true
    GROUP BY bs.id, bs.salon_name, bs.description, bs.address, bs.phone, bs.latitude, bs.longitude
    ORDER BY rating DESC NULLS LAST;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_active_connections()
 RETURNS TABLE(pid integer, usename text, application_name text, client_addr text, state text, query text, query_start timestamp with time zone, state_change timestamp with time zone, duration_seconds numeric)
 LANGUAGE sql
 SECURITY DEFINER
AS $function$
SELECT 
  pid,
  usename,
  application_name,
  client_addr::text,
  state,
  CASE 
    WHEN length(query) > 100 THEN substring(query from 1 for 100) || '...'
    ELSE query
  END as query,
  query_start,
  state_change,
  EXTRACT(EPOCH FROM (now() - query_start))::numeric(10,2) as duration_seconds
FROM pg_stat_activity
WHERE datname = current_database()
  AND pid <> pg_backend_pid()
ORDER BY query_start DESC
LIMIT 50;
$function$
;

CREATE OR REPLACE FUNCTION public.get_active_hotel_ads()
 RETURNS TABLE(id uuid, name text, content text, image_url text, hotel_id uuid, room_id uuid, target_url text, start_date timestamp with time zone, end_date timestamp with time zone, is_active boolean, priority integer, click_count integer, view_count integer, created_at timestamp with time zone, updated_at timestamp with time zone)
 LANGUAGE sql
 SECURITY DEFINER
AS $function$
  SELECT 
    id,
    name,
    content,
    image_url,
    hotel_id,
    room_id,
    target_url,
    start_date,
    end_date,
    is_active,
    priority,
    click_count,
    view_count,
    created_at,
    updated_at
  FROM ads_hotel
  WHERE is_active = true
  ORDER BY priority DESC, created_at DESC;
$function$
;

CREATE OR REPLACE FUNCTION public.get_all_hotel_ads()
 RETURNS TABLE(id uuid, name text, content text, image_url text, hotel_id uuid, room_id uuid, target_url text, start_date timestamp with time zone, end_date timestamp with time zone, is_active boolean, priority integer, click_count integer, view_count integer, created_at timestamp with time zone, updated_at timestamp with time zone)
 LANGUAGE sql
 SECURITY DEFINER
AS $function$
  SELECT 
    id,
    name,
    content,
    image_url,
    hotel_id,
    room_id,
    target_url,
    start_date,
    end_date,
    is_active,
    priority,
    click_count,
    view_count,
    created_at,
    updated_at
  FROM ads_hotel
  ORDER BY priority DESC, created_at DESC;
$function$
;

CREATE OR REPLACE FUNCTION public.get_all_stores_status()
 RETURNS TABLE(store_id uuid, store_name text, current_status boolean, should_be_open boolean, is_active boolean, is_suspended boolean, is_auto_open boolean, opening_hours jsonb, current_time_value time without time zone, opening_time text, closing_time text, status_match boolean, action_needed text)
 LANGUAGE plpgsql
AS $function$
DECLARE
    store_record RECORD;
    current_time_value TIME;
    opening_time TEXT;
    closing_time TEXT;
    should_be_open BOOLEAN;
BEGIN
    -- ตั้งค่าเวลาปัจจุบัน (เวลาไทย UTC+7)
    current_time_value := (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Bangkok')::TIME;
    
    -- วนลูปผ่านร้านทั้งหมด
    FOR store_record IN 
        SELECT 
            id,
            name,
            is_open,
            stores.opening_hours,
            stores.is_active,
            stores.is_suspended,
            stores.is_auto_open
        FROM stores 
        ORDER BY name
    LOOP
        should_be_open := false;
        opening_time := NULL;
        closing_time := NULL;
        
        -- ตรวจสอบว่ามี opening_hours หรือไม่
        IF store_record.opening_hours IS NOT NULL THEN
            -- ทำความสะอาด opening_hours (แปลง JSON เป็น TEXT และลบ quotes)
            DECLARE
                clean_hours TEXT;
            BEGIN
                clean_hours := store_record.opening_hours::TEXT;
                -- ลบ quotes ที่ซ้อนกันออก
                clean_hours := replace(clean_hours, '"""', '');
                clean_hours := replace(clean_hours, '"', '');
                
                -- แยกเวลาเปิดและปิดจากรูปแบบ "08:00-17:40"
                IF position('-' in clean_hours) > 0 THEN
                    opening_time := split_part(clean_hours, '-', 1);
                    closing_time := split_part(clean_hours, '-', 2);
                    
                    -- ตรวจสอบว่าเวลาเปิดปิดถูกต้อง
                    IF opening_time IS NOT NULL AND closing_time IS NOT NULL THEN
                        -- ตรวจสอบว่าเวลาปัจจุบันอยู่ในช่วงเปิดร้านหรือไม่
                        IF current_time_value >= opening_time::TIME AND current_time_value <= closing_time::TIME THEN
                            should_be_open := true;
                        END IF;
                    END IF;
                END IF;
            END;
        END IF;
        
        -- คืนค่าผลลัพธ์
        RETURN QUERY SELECT 
            store_record.id,
            store_record.name,
            store_record.is_open,
            should_be_open,
            store_record.is_active,
            store_record.is_suspended,
            store_record.is_auto_open,
            store_record.opening_hours,
            current_time_value,
            opening_time,
            closing_time,
            (store_record.is_open = should_be_open),
            CASE 
                WHEN NOT store_record.is_active THEN 'ร้านไม่ active'
                WHEN store_record.is_suspended THEN 'ร้านถูกระงับ'
                WHEN NOT store_record.is_auto_open THEN 'ปิดการเปิดปิดอัตโนมัติ'
                WHEN store_record.is_open != should_be_open THEN 
                    CASE 
                        WHEN should_be_open THEN 'ต้องเปิดร้าน'
                        ELSE 'ต้องปิดร้าน'
                    END
                ELSE 'สถานะถูกต้อง'
            END;
    END LOOP;
    
    RETURN;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_assigned_rider_fcm_token(order_uuid uuid)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN (
        SELECT u.fcm_token
        FROM users u
        JOIN rider_profile_view rpv ON u.id = rpv.user_id
        JOIN rider_assignments ra ON rpv.rider_id = ra.rider_id
        WHERE ra.order_id = order_uuid
        AND ra.status IN ('assigned', 'picked_up', 'delivering')
        AND u.fcm_token IS NOT NULL
        AND u.fcm_token != ''
        LIMIT 1
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_available_riders()
 RETURNS TABLE(rider_id uuid, rider_name text, rider_phone text, rider_line_id text, vehicle_type text, license_plate text, current_location point, rating numeric, total_deliveries integer, is_available boolean, documents_verified boolean)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        r.id as rider_id,
        u.full_name as rider_name,
        u.phone as rider_phone,
        u.line_id as rider_line_id,
        r.vehicle_type,
        r.license_plate,
        r.current_location,
        r.rating,
        r.total_deliveries,
        r.is_available,
        r.documents_verified
    FROM riders r
    JOIN users u ON r.user_id = u.id
    WHERE r.is_available = true 
    AND r.documents_verified = true
    AND NOT EXISTS (
        SELECT 1 FROM rider_assignments ra 
        WHERE ra.rider_id = r.id 
        AND ra.status IN ('assigned', 'picked_up', 'delivering')
    )
    ORDER BY r.rating DESC NULLS LAST, r.total_deliveries DESC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_available_time_slots(p_salon_id uuid, p_staff_id uuid, p_date date, p_service_duration integer)
 RETURNS TABLE(time_slot time without time zone, is_available boolean)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        bs.time_slot,
        bs.is_available
    FROM public.beauty_schedules bs
    WHERE bs.salon_id = p_salon_id
    AND bs.staff_id = p_staff_id
    AND bs.date = p_date
    AND bs.duration_minutes >= p_service_duration
    AND bs.is_available = true
    ORDER BY bs.time_slot;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_beauty_services_by_salon(p_salon_id uuid)
 RETURNS TABLE(id uuid, service_name text, description text, category text, duration_minutes integer, price numeric, images jsonb)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        bs.id,
        bs.service_name,
        bs.description,
        bs.category,
        bs.duration_minutes,
        bs.price,
        bs.images
    FROM public.beauty_services bs
    WHERE bs.salon_id = p_salon_id AND bs.is_active = true
    ORDER BY bs.category, bs.service_name;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_beauty_staff_by_salon(p_salon_id uuid)
 RETURNS TABLE(id uuid, full_name text, phone text, email text, avatar_url text, specialties jsonb, experience_years integer, rating numeric, total_bookings integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        bst.id,
        bst.full_name,
        bst.phone,
        bst.email,
        bst.avatar_url,
        bst.specialties,
        bst.experience_years,
        bst.rating,
        bst.total_bookings
    FROM public.beauty_staff bst
    WHERE bst.salon_id = p_salon_id AND bst.is_active = true
    ORDER BY bst.rating DESC NULLS LAST;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_chat_image_url(file_path text)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN 'https://' || current_setting('app.supabase_url') || '/storage/v1/object/public/chat-images/' || file_path;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_chat_messages_with_fcm(p_order_id uuid)
 RETURNS TABLE(id uuid, order_id uuid, sender_type text, sender_id uuid, message text, message_type text, is_read boolean, created_at timestamp with time zone, sender_fcm_token text, recipient_fcm_token text)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        cm.id,
        cm.order_id,
        cm.sender_type,
        cm.sender_id,
        cm.message,
        cm.message_type,
        cm.is_read,
        cm.created_at,
        cm.sender_fcm_token,
        cm.recipient_fcm_token
    FROM chat_messages cm
    WHERE cm.order_id = p_order_id
    ORDER BY cm.created_at;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_community_post_image_url(file_path text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN public.get_image_url('post-images', file_path);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_customer_bookings(p_customer_email text)
 RETURNS TABLE(id uuid, booking_number text, salon_name text, service_name text, staff_name text, booking_date date, booking_time time without time zone, total_amount numeric, booking_status text, payment_status text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        bb.id,
        bb.booking_number,
        bs.salon_name,
        bsv.service_name,
        bst.full_name as staff_name,
        bb.booking_date,
        bb.booking_time,
        bb.total_amount,
        bb.booking_status,
        bb.payment_status
    FROM public.beauty_bookings bb
    JOIN public.beauty_salons bs ON bb.salon_id = bs.id
    JOIN public.beauty_services bsv ON bb.service_id = bsv.id
    LEFT JOIN public.beauty_staff bst ON bb.staff_id = bst.id
    WHERE bb.customer_email = p_customer_email
    ORDER BY bb.booking_date DESC, bb.booking_time DESC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_customer_fcm_token(order_uuid uuid)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN (
        SELECT u.fcm_token
        FROM users u
        JOIN orders o ON u.id = o.customer_id
        WHERE o.id = order_uuid
        LIMIT 1
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_daily_sales_report(store_uuid uuid DEFAULT NULL::uuid, start_date date DEFAULT (CURRENT_DATE - '30 days'::interval), end_date date DEFAULT CURRENT_DATE)
 RETURNS TABLE(store_id uuid, store_name text, sale_date date, daily_orders bigint, daily_revenue numeric, avg_order_value numeric, completed_orders bigint, cancelled_orders bigint, cash_revenue numeric, transfer_revenue numeric, cash_orders bigint, transfer_orders bigint)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        s.id as store_id,
        s.name as store_name,
        DATE(o.created_at) as sale_date,
        COUNT(o.id) as daily_orders,
        SUM(CASE WHEN o.status != 'cancelled' THEN o.subtotal ELSE 0 END) as daily_revenue,
        AVG(CASE WHEN o.status != 'cancelled' THEN o.subtotal ELSE NULL END) as avg_order_value,
        COUNT(CASE WHEN o.status = 'delivered' THEN 1 END) as completed_orders,
        COUNT(CASE WHEN o.status = 'cancelled' THEN 1 END) as cancelled_orders,
        SUM(CASE WHEN o.payment_method = 'cash' AND o.status != 'cancelled' THEN o.subtotal ELSE 0 END) as cash_revenue,
        SUM(CASE WHEN o.payment_method = 'bank_transfer' AND o.status != 'cancelled' THEN o.subtotal ELSE 0 END) as transfer_revenue,
        COUNT(CASE WHEN o.payment_method = 'cash' THEN 1 END) as cash_orders,
        COUNT(CASE WHEN o.payment_method = 'bank_transfer' THEN 1 END) as transfer_orders
    FROM stores s
    LEFT JOIN orders o ON s.id = o.store_id 
        AND o.created_at >= start_date 
        AND o.created_at <= end_date + INTERVAL '1 day' - INTERVAL '1 second'
    WHERE (store_uuid IS NULL OR s.id = store_uuid)
    GROUP BY s.id, s.name, DATE(o.created_at)
    ORDER BY s.name, DATE(o.created_at) DESC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_database_overview()
 RETURNS json
 LANGUAGE sql
 SECURITY DEFINER
AS $function$
SELECT json_build_object(
  'database_name', current_database(),
  'database_size_bytes', pg_database_size(current_database()),
  'active_connections', (SELECT count(*) FROM pg_stat_activity WHERE state = 'active' AND datname = current_database()),
  'idle_connections', (SELECT count(*) FROM pg_stat_activity WHERE state = 'idle' AND datname = current_database()),
  'total_connections', (SELECT count(*) FROM pg_stat_activity WHERE datname = current_database()),
  'stats_reset', (SELECT stats_reset FROM pg_stat_database WHERE datname = current_database())
);
$function$
;

CREATE OR REPLACE FUNCTION public.get_delivery_fee_base_v2()
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_base_fee numeric;
BEGIN
    -- ดึงค่าส่งของ tier แรก (ระยะทางต่ำสุด)
    SELECT fee INTO v_base_fee
    FROM public.delivery_fee_tiers
    WHERE config_id = (
        SELECT id
        FROM public.delivery_fee_config_v2
        WHERE is_active = true
        ORDER BY is_default DESC, created_at DESC
        LIMIT 1
    )
    ORDER BY sort_order
    LIMIT 1;

    RETURN COALESCE(v_base_fee, 7.0); -- ค่าเริ่มต้น
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_delivery_fee_max_distance_v2()
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_max_distance numeric;
BEGIN
    SELECT max_delivery_distance INTO v_max_distance
    FROM public.delivery_fee_config_v2
    WHERE is_active = true
    ORDER BY is_default DESC, created_at DESC
    LIMIT 1;

    RETURN COALESCE(v_max_distance, 10.0);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_detailed_user_status()
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    user_record RECORD;
    result JSONB;
BEGIN
    -- ดึงข้อมูลผู้ใช้ปัจจุบัน
    SELECT * INTO user_record 
    FROM public.users 
    WHERE id = auth.uid();
    
    IF user_record IS NULL THEN
        result := jsonb_build_object(
            'is_logged_in', false,
            'message', 'User not found'
        );
    ELSE
        -- ตรวจสอบสถานะต่างๆ
        result := jsonb_build_object(
            'is_logged_in', true,
            'user_id', user_record.id,
            'google_id', user_record.google_id,
            'email', user_record.email,
            'full_name', user_record.full_name,
            'role', user_record.role,
            'is_active', user_record.is_active,
            'last_login_at', user_record.last_login_at,
            'login_count', user_record.login_count,
            'created_at', user_record.created_at,
            'avatar_url', user_record.avatar_url,
            'phone', user_record.phone,
            'line_id', user_record.line_id,
            'address', user_record.address,
            'profile_complete', CASE 
                WHEN user_record.phone IS NOT NULL 
                     AND user_record.line_id IS NOT NULL 
                     AND user_record.address IS NOT NULL 
                THEN true 
                ELSE false 
            END,
            'has_role', CASE 
                WHEN user_record.role IS NOT NULL AND user_record.role != '' 
                THEN true 
                ELSE false 
            END,
            'message', 'User logged in successfully'
        );
    END IF;
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_image_url(bucket_name text, file_path text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- สร้าง URL สำหรับรูปภาพ
    RETURN 'https://' || current_setting('app.settings.supabase_url') || '/storage/v1/object/public/' || bucket_name || '/' || file_path;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_latest_rider_locations()
 RETURNS TABLE(id uuid, order_id uuid, rider_id uuid, latitude numeric, longitude numeric, recorded_at timestamp with time zone, order_status text, order_number text, rider_name text, rider_phone text)
 LANGUAGE sql
 STABLE
AS $function$
    SELECT DISTINCT ON (orl.rider_id)
        orl.id,
        orl.order_id,
        orl.rider_id,
        orl.latitude,
        orl.longitude,
        orl.recorded_at,
        o.status AS order_status,
        o.order_number,
        u.full_name AS rider_name,
        u.phone AS rider_phone
    FROM public.order_rider_locations orl
    JOIN public.orders o ON o.id = orl.order_id
    JOIN public.riders r ON r.id = orl.rider_id
    JOIN public.users u ON u.id = r.user_id
    ORDER BY orl.rider_id, orl.recorded_at DESC;
$function$
;

CREATE OR REPLACE FUNCTION public.get_monthly_sales_report(store_uuid uuid DEFAULT NULL::uuid, start_month date DEFAULT (date_trunc('month'::text, (CURRENT_DATE)::timestamp with time zone) - '1 year'::interval), end_month date DEFAULT date_trunc('month'::text, (CURRENT_DATE)::timestamp with time zone))
 RETURNS TABLE(store_id uuid, store_name text, month_start date, month_end date, year integer, month_number integer, month_name text, monthly_orders bigint, monthly_revenue numeric, avg_order_value numeric, completed_orders bigint, cancelled_orders bigint, cash_revenue numeric, transfer_revenue numeric, cash_orders bigint, transfer_orders bigint)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        s.id as store_id,
        s.name as store_name,
        date_trunc('month', o.created_at)::date as month_start,
        (date_trunc('month', o.created_at) + INTERVAL '1 month' - INTERVAL '1 day')::date as month_end,
        EXTRACT(year FROM o.created_at)::integer as year,
        EXTRACT(month FROM o.created_at)::integer as month_number,
        to_char(date_trunc('month', o.created_at), 'Month YYYY') as month_name,
        COUNT(o.id) as monthly_orders,
        SUM(CASE WHEN o.status != 'cancelled' THEN o.subtotal ELSE 0 END) as monthly_revenue,
        AVG(CASE WHEN o.status != 'cancelled' THEN o.subtotal ELSE NULL END) as avg_order_value,
        COUNT(CASE WHEN o.status = 'delivered' THEN 1 END) as completed_orders,
        COUNT(CASE WHEN o.status = 'cancelled' THEN 1 END) as cancelled_orders,
        SUM(CASE WHEN o.payment_method = 'cash' AND o.status != 'cancelled' THEN o.subtotal ELSE 0 END) as cash_revenue,
        SUM(CASE WHEN o.payment_method = 'bank_transfer' AND o.status != 'cancelled' THEN o.subtotal ELSE 0 END) as transfer_revenue,
        COUNT(CASE WHEN o.payment_method = 'cash' THEN 1 END) as cash_orders,
        COUNT(CASE WHEN o.payment_method = 'bank_transfer' THEN 1 END) as transfer_orders
    FROM stores s
    LEFT JOIN orders o ON s.id = o.store_id 
        AND o.created_at >= start_month 
        AND o.created_at < end_month + INTERVAL '1 month'
    WHERE (store_uuid IS NULL OR s.id = store_uuid)
    GROUP BY s.id, s.name, date_trunc('month', o.created_at), EXTRACT(year FROM o.created_at), EXTRACT(month FROM o.created_at)
    ORDER BY s.name, date_trunc('month', o.created_at) DESC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_or_create_user_from_google(google_id_param text, email_param text, full_name_param text, avatar_url_param text DEFAULT NULL::text, given_name_param text DEFAULT NULL::text, family_name_param text DEFAULT NULL::text, locale_param text DEFAULT NULL::text, picture_param text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    user_record RECORD;
    result JSONB;
BEGIN
    -- ตรวจสอบว่าผู้ใช้มีอยู่แล้วหรือไม่
    SELECT * INTO user_record 
    FROM users 
    WHERE google_id = google_id_param OR email = email_param;
    
    IF user_record IS NULL THEN
        -- สร้างผู้ใช้ใหม่
        INSERT INTO users (
            google_id,
            email,
            full_name,
            avatar_url,
            google_given_name,
            google_family_name,
            google_locale,
            google_picture,
            role,
            is_active,
            email_verified,
            phone_verified,
            google_verified_email,
            last_login_at,
            login_count
        )
        VALUES (
            google_id_param,
            email_param,
            full_name_param,
            COALESCE(avatar_url_param, picture_param),
            given_name_param,
            family_name_param,
            locale_param,
            picture_param,
            'customer', -- ตั้งค่าเป็นลูกค้าโดยอัตโนมัติ
            true, -- is_active
            true, -- email_verified (Google email ผ่านการยืนยันแล้ว)
            false, -- phone_verified
            true, -- google_verified_email
            NOW(),
            1
        )
        RETURNING * INTO user_record;
        
        -- ส่งการแจ้งเตือนต้อนรับ
        PERFORM send_notification(
            user_record.id,
            'ยินดีต้อนรับสู่ระบบ Delivery',
            'ขอบคุณที่สมัครสมาชิกกับเรา กรุณาเลือกบทบาทของคุณ',
            'system',
            jsonb_build_object('user_id', user_record.id, 'is_new_user', true)
        );
        
        result := jsonb_build_object(
            'user_id', user_record.id,
            'is_new_user', true,
            'message', 'User created successfully'
        );
    ELSE
        -- อัปเดตข้อมูลการเข้าสู่ระบบ
        UPDATE users 
        SET 
            last_login_at = NOW(),
            login_count = login_count + 1,
            updated_at = NOW()
        WHERE id = user_record.id;
        
        result := jsonb_build_object(
            'user_id', user_record.id,
            'is_new_user', false,
            'message', 'User logged in successfully'
        );
    END IF;
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_orders_by_date(p_store_uuid uuid, p_date date)
 RETURNS TABLE(id uuid, order_number text, customer_id uuid, customer_name text, customer_phone text, status text, payment_method text, subtotal numeric, delivery_fee numeric, total_amount numeric, created_at timestamp with time zone, items jsonb)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        o.id,
        o.order_number,
        o.customer_id,
        COALESCE(o.customer_name, u.full_name) as customer_name,
        COALESCE(o.customer_phone, u.phone) as customer_phone,
        o.status,
        o.payment_method,
        o.subtotal,
        o.delivery_fee,
        o.total_amount,
        o.created_at,
        -- รวมรายการสินค้าเป็น JSONB array
        COALESCE(
            (
                SELECT jsonb_agg(
                    jsonb_build_object(
                        'id', oi.id,
                        'product_id', oi.product_id,
                        'product_name', oi.product_name,
                        'product_price', oi.product_price,
                        'quantity', oi.quantity,
                        'total_price', oi.total_price,
                        'special_instructions', oi.special_instructions
                    )
                )
                FROM order_items oi
                WHERE oi.order_id = o.id
            ),
            '[]'::jsonb
        ) as items
    FROM orders o
    LEFT JOIN users u ON o.customer_id = u.id
    WHERE o.store_id = p_store_uuid
      AND DATE(o.created_at AT TIME ZONE 'Asia/Bangkok') = p_date
    ORDER BY o.created_at DESC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_pending_order_details(p_order_id uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_order_data jsonb;
    v_order_items jsonb;
    v_result jsonb;
BEGIN
    -- ดึงข้อมูลออเดอร์
    SELECT jsonb_build_object(
        'order_id', o.id,
        'order_number', o.order_number,
        'total_amount', o.total_amount,
        'subtotal', o.subtotal,
        'delivery_fee', o.delivery_fee,
        'payment_method', o.payment_method,
        'payment_status', o.payment_status,
        'delivery_address', o.delivery_address,
        'delivery_latitude', o.delivery_latitude,
        'delivery_longitude', o.delivery_longitude,
        'special_instructions', o.special_instructions,
        'created_at', o.created_at,
        'updated_at', o.updated_at,
        'store', jsonb_build_object(
            'id', s.id,
            'name', s.name,
            'phone', s.phone,
            'address', s.address,
            'latitude', s.latitude,
            'longitude', s.longitude
        ),
        'customer', jsonb_build_object(
            'id', u.id,
            'name', u.full_name,
            'phone', u.phone,
            'email', u.email,
            'line_id', u.line_id
        ),
        'estimated_delivery_time', o.estimated_delivery_time,
        'distance_km', o.distance_km
    )
    INTO v_order_data
    FROM public.orders o
    JOIN public.stores s ON o.store_id = s.id
    JOIN public.users u ON o.customer_id = u.id
    WHERE o.id = p_order_id AND o.status = 'pending';
    
    IF v_order_data IS NULL THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'ไม่พบออเดอร์ที่ระบุหรือออเดอร์ไม่ใช่สถานะ pending'
        );
    END IF;
    
    -- ดึงรายการสินค้าในออเดอร์
    SELECT jsonb_agg(
        jsonb_build_object(
            'item_id', oi.id,
            'product_id', oi.product_id,
            'product_name', p.name,
            'quantity', oi.quantity,
            'unit_price', oi.unit_price,
            'total_price', oi.total_price,
            'special_instructions', oi.special_instructions,
            'options', COALESCE(oi_options.options, '[]'::jsonb)
        )
    )
    INTO v_order_items
    FROM public.order_items oi
    JOIN public.products p ON oi.product_id = p.id
    LEFT JOIN (
        SELECT 
            oio.order_item_id,
            jsonb_agg(
                jsonb_build_object(
                    'option_name', oio.option_name,
                    'selected_value', oio.selected_value_name,
                    'price_adjustment', oio.price_adjustment
                )
            ) AS options
        FROM public.order_item_options oio
        GROUP BY oio.order_item_id
    ) oi_options ON oi.id = oi_options.order_item_id
    WHERE oi.order_id = p_order_id;
    
    -- รวมผลลัพธ์
    v_result := jsonb_build_object(
        'success', true,
        'order', v_order_data,
        'items', COALESCE(v_order_items, '[]'::jsonb)
    );
    
    RETURN v_result;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'เกิดข้อผิดพลาดในการดึงข้อมูล: ' || SQLERRM
        );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_pending_orders(p_store_id uuid DEFAULT NULL::uuid, p_limit integer DEFAULT 50, p_offset integer DEFAULT 0)
 RETURNS TABLE(order_id uuid, order_number text, total_amount numeric, subtotal numeric, delivery_fee numeric, payment_method text, payment_status text, delivery_address text, delivery_latitude numeric, delivery_longitude numeric, special_instructions text, created_at timestamp with time zone, updated_at timestamp with time zone, store_id uuid, store_name text, store_phone text, store_address text, store_latitude numeric, store_longitude numeric, customer_name text, customer_phone text, customer_email text, customer_line_id text, order_items_count bigint, estimated_delivery_time timestamp with time zone, distance_km numeric)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        o.id AS order_id,
        o.order_number,
        o.total_amount,
        o.subtotal,
        o.delivery_fee,
        o.payment_method,
        o.payment_status,
        o.delivery_address,
        o.delivery_latitude,
        o.delivery_longitude,
        o.special_instructions,
        o.created_at,
        o.updated_at,
        s.id AS store_id,
        s.name AS store_name,
        s.phone AS store_phone,
        s.address AS store_address,
        s.latitude AS store_latitude,
        s.longitude AS store_longitude,
        u.full_name AS customer_name,
        u.phone AS customer_phone,
        u.email AS customer_email,
        u.line_id AS customer_line_id,
        COALESCE(oi_count.item_count, 0) AS order_items_count,
        o.estimated_delivery_time,
        o.distance_km
    FROM public.orders o
    JOIN public.stores s ON o.store_id = s.id
    JOIN public.users u ON o.customer_id = u.id
    LEFT JOIN (
        SELECT 
            order_id,
            COUNT(*) AS item_count
        FROM public.order_items
        GROUP BY order_id
    ) oi_count ON o.id = oi_count.order_id
    WHERE o.status = 'pending'
    AND (p_store_id IS NULL OR o.store_id = p_store_id)
    ORDER BY o.created_at DESC
    LIMIT p_limit
    OFFSET p_offset;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_performance_metrics()
 RETURNS json
 LANGUAGE sql
 SECURITY DEFINER
AS $function$
SELECT json_build_object(
  'transactions_committed', xact_commit,
  'transactions_rolled_back', xact_rollback,
  'blocks_read', blks_read,
  'blocks_hit', blks_hit,
  'cache_hit_ratio', 
    CASE WHEN (blks_hit + blks_read) > 0 
    THEN round((blks_hit::numeric / (blks_hit + blks_read)) * 100, 2)
    ELSE 0 
    END,
  'tuples_returned', tup_returned,
  'tuples_fetched', tup_fetched,
  'tuples_inserted', tup_inserted,
  'tuples_updated', tup_updated,
  'tuples_deleted', tup_deleted,
  'temp_files', temp_files,
  'temp_bytes', temp_bytes,
  'deadlocks', deadlocks,
  'block_read_time', blk_read_time,
  'block_write_time', blk_write_time
)
FROM pg_stat_database
WHERE datname = current_database();
$function$
;

CREATE OR REPLACE FUNCTION public.get_product_image_url(file_path text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- สร้าง URL สำหรับรูปภาพ
    RETURN 'https://' || current_setting('app.settings.supabase_url') || '/storage/v1/object/public/product-images/' || file_path;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_product_options_with_values(p_product_id uuid)
 RETURNS TABLE(option_id uuid, option_name text, option_description text, is_required boolean, min_selections integer, max_selections integer, display_order integer, value_id uuid, value_name text, price_adjustment numeric, is_default boolean, is_available boolean, value_display_order integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        po.id as option_id,
        po.name as option_name,
        po.description as option_description,
        po.is_required,
        po.min_selections,
        po.max_selections,
        po.display_order,
        pov.id as value_id,
        pov.name as value_name,
        pov.price_adjustment,
        pov.is_default,
        pov.is_available,
        pov.display_order as value_display_order
    FROM product_options po
    LEFT JOIN product_option_values pov ON po.id = pov.option_id
    WHERE po.product_id = p_product_id 
    AND po.is_active = true
    ORDER BY po.display_order, pov.display_order;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_rider_bookings(p_rider_id uuid)
 RETURNS TABLE(booking_id uuid, order_id uuid, order_number text, store_name text, store_address text, customer_name text, customer_phone text, total_amount numeric, delivery_fee numeric, delivery_address text, priority integer, status text, booked_at timestamp with time zone, expires_at timestamp with time zone, order_status text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        rob.id as booking_id,
        rob.order_id,
        o.order_number,
        s.name as store_name,
        s.address as store_address,
        u.full_name as customer_name,
        u.phone as customer_phone,
        o.total_amount,
        o.delivery_fee,
        o.delivery_address,
        rob.priority,
        rob.status,
        rob.booked_at,
        rob.expires_at,
        o.status as order_status
    FROM rider_order_bookings rob
    JOIN orders o ON rob.order_id = o.id
    JOIN stores s ON o.store_id = s.id
    JOIN users u ON o.customer_id = u.id
    WHERE rob.rider_id = p_rider_id
    AND rob.status IN ('booked', 'assigned')
    ORDER BY rob.priority ASC, rob.booked_at ASC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_rider_fcm_token(rider_uuid uuid)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN (
        SELECT u.fcm_token
        FROM users u
        JOIN rider_profile_view rpv ON u.id = rpv.user_id
        WHERE rpv.rider_id = rider_uuid
        LIMIT 1
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_rider_reviews(p_rider_id uuid, p_limit integer DEFAULT 10, p_offset integer DEFAULT 0)
 RETURNS TABLE(review_id uuid, order_id uuid, customer_id uuid, customer_name text, rating numeric, review_text text, review_images text[], is_anonymous boolean, created_at timestamp with time zone)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        rr.id as review_id,
        rr.order_id,
        rr.customer_id,
        CASE 
            WHEN rr.is_anonymous THEN 'ผู้ใช้ไม่ระบุชื่อ'
            ELSE u.full_name
        END as customer_name,
        rr.rating,
        rr.review_text,
        rr.review_images,
        rr.is_anonymous,
        rr.created_at
    FROM public.rider_reviews rr
    JOIN public.users u ON rr.customer_id = u.id
    WHERE rr.rider_id = p_rider_id
    ORDER BY rr.created_at DESC
    LIMIT p_limit
    OFFSET p_offset;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_shopping_list_by_store(p_delivery_date date)
 RETURNS TABLE(store_id uuid, store_name text, items jsonb)
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN QUERY
  SELECT
    pi.store_id,
    pi.store_name_snapshot,
    jsonb_agg(
      jsonb_build_object(
        'product_name', pi.product_name_snapshot,
        'qty', pi.qty,
        'unit', pi.unit,
        'custom_price', pi.custom_price,
        'notes', pi.notes
      ) ORDER BY pi.product_name_snapshot
    ) as items
  FROM preorder_items pi
  JOIN preorder_orders po ON po.id = pi.preorder_order_id
  WHERE po.scheduled_delivery_date = p_delivery_date
    AND po.status IN ('deposit_confirmed', 'preparing', 'items_ready')
  GROUP BY pi.store_id, pi.store_name_snapshot
  ORDER BY pi.store_name_snapshot;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_store_dashboard_summary(store_uuid uuid)
 RETURNS TABLE(today_sales numeric, today_orders bigint, total_sales numeric, total_orders bigint, monthly_sales numeric, monthly_orders bigint, completed_orders bigint, cancelled_orders bigint, cash_revenue numeric, transfer_revenue numeric)
 LANGUAGE plpgsql
AS $function$
DECLARE
  today_date date := CURRENT_DATE;
  month_start date := date_trunc('month', CURRENT_DATE)::date;
  month_end date := (date_trunc('month', CURRENT_DATE) + INTERVAL '1 month' - INTERVAL '1 day')::date;
BEGIN
  RETURN QUERY
  WITH today_data AS (
    SELECT 
      COALESCE(SUM(CASE WHEN o.status != 'cancelled' THEN o.subtotal ELSE 0 END), 0) as today_sales,
      COUNT(o.id) as today_orders
    FROM orders o
    WHERE o.store_id = store_uuid 
      AND DATE(o.created_at) = today_date
  ),
  total_data AS (
    SELECT 
      COALESCE(SUM(CASE WHEN o.status != 'cancelled' THEN o.subtotal ELSE 0 END), 0) as total_sales,
      COUNT(o.id) as total_orders,
      COUNT(CASE WHEN o.status = 'delivered' THEN 1 END) as completed_orders,
      COUNT(CASE WHEN o.status = 'cancelled' THEN 1 END) as cancelled_orders,
      COALESCE(SUM(CASE WHEN o.payment_method = 'cash' AND o.status != 'cancelled' THEN o.subtotal ELSE 0 END), 0) as cash_revenue,
      COALESCE(SUM(CASE WHEN o.payment_method = 'bank_transfer' AND o.status != 'cancelled' THEN o.subtotal ELSE 0 END), 0) as transfer_revenue
    FROM orders o
    WHERE o.store_id = store_uuid
  ),
  monthly_data AS (
    SELECT 
      COALESCE(SUM(CASE WHEN o.status != 'cancelled' THEN o.subtotal ELSE 0 END), 0) as monthly_sales,
      COUNT(o.id) as monthly_orders
    FROM orders o
    WHERE o.store_id = store_uuid 
      AND o.created_at >= month_start 
      AND o.created_at <= month_end
  )
  SELECT 
    td.today_sales,
    td.today_orders,
    tot.total_sales,
    tot.total_orders,
    md.monthly_sales,
    md.monthly_orders,
    tot.completed_orders,
    tot.cancelled_orders,
    tot.cash_revenue,
    tot.transfer_revenue
  FROM today_data td
  CROSS JOIN total_data tot
  CROSS JOIN monthly_data md;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_store_fcm_tokens(store_uuid uuid)
 RETURNS TABLE(fcm_token text, device_name character varying, platform character varying, last_used_at timestamp with time zone)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        fs.fcm_token,
        fs.device_name,
        fs.platform,
        fs.last_used_at
    FROM fcm_store fs
    WHERE fs.store_id = store_uuid 
    AND fs.is_active = true
    ORDER BY fs.last_used_at DESC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_stores_by_distance(user_lat double precision, user_lon double precision, limit_count integer DEFAULT 20, offset_count integer DEFAULT 0)
 RETURNS TABLE(id uuid, name text, description text, opening_hours jsonb, is_open boolean, logo_url text, banner_url text, latitude numeric, longitude numeric, delivery_radius integer, minimum_order numeric, store_type_id uuid, distance_km numeric)
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE
    user_location GEOGRAPHY;
BEGIN
    -- สร้าง geography point จากตำแหน่งผู้ใช้
    user_location := ST_SetSRID(ST_MakePoint(user_lon, user_lat), 4326)::geography;
    
    RETURN QUERY
    SELECT 
        s.id,
        s.name,
        s.description,
        s.opening_hours,
        s.is_open,
        s.logo_url,
        s.banner_url,
        s.latitude::NUMERIC,
        s.longitude::NUMERIC,
        s.delivery_radius,
        s.minimum_order,
        s.store_type_id,
        -- คำนวณระยะทางด้วย PostGIS (เป็นกิโลเมตร)
        (ST_Distance(user_location, s.location) / 1000.0)::NUMERIC AS distance_km
    FROM public.stores s
    WHERE s.is_active = true
      AND s.location IS NOT NULL
    ORDER BY 
        s.is_open DESC,  -- ร้านที่เปิดมาก่อน (true ก่อน false)
        s.location <-> user_location ASC  -- เรียงตามระยะทางใกล้สุดภายในแต่ละกลุ่ม
    LIMIT limit_count
    OFFSET offset_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_system_sales_summary(start_date date DEFAULT (CURRENT_DATE - '30 days'::interval), end_date date DEFAULT CURRENT_DATE)
 RETURNS TABLE(total_orders bigint, total_revenue numeric, avg_order_value numeric, completed_orders bigint, cancelled_orders bigint, active_stores bigint, active_customers bigint, active_riders bigint, cash_revenue numeric, transfer_revenue numeric, cash_orders bigint, transfer_orders bigint)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(o.id) as total_orders,
        SUM(CASE WHEN o.status != 'cancelled' THEN o.subtotal ELSE 0 END) as total_revenue,
        AVG(CASE WHEN o.status != 'cancelled' THEN o.subtotal ELSE NULL END) as avg_order_value,
        COUNT(CASE WHEN o.status = 'delivered' THEN 1 END) as completed_orders,
        COUNT(CASE WHEN o.status = 'cancelled' THEN 1 END) as cancelled_orders,
        COUNT(DISTINCT o.store_id) as active_stores,
        COUNT(DISTINCT o.customer_id) as active_customers,
        COUNT(DISTINCT o.rider_id) as active_riders,
        SUM(CASE WHEN o.payment_method = 'cash' AND o.status != 'cancelled' THEN o.subtotal ELSE 0 END) as cash_revenue,
        SUM(CASE WHEN o.payment_method = 'bank_transfer' AND o.status != 'cancelled' THEN o.subtotal ELSE 0 END) as transfer_revenue,
        COUNT(CASE WHEN o.payment_method = 'cash' THEN 1 END) as cash_orders,
        COUNT(CASE WHEN o.payment_method = 'bank_transfer' THEN 1 END) as transfer_orders
    FROM orders o
    WHERE o.created_at >= start_date 
        AND o.created_at <= end_date + INTERVAL '1 day' - INTERVAL '1 second';
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_table_statistics()
 RETURNS TABLE(schema_name text, table_name text, total_size_bytes bigint, table_size_bytes bigint, indexes_size_bytes bigint, row_count bigint, last_vacuum timestamp with time zone, last_analyze timestamp with time zone)
 LANGUAGE sql
 SECURITY DEFINER
AS $function$
SELECT 
  t.schemaname::text,
  t.relname::text,
  pg_total_relation_size(quote_ident(t.schemaname)||'.'||quote_ident(t.relname))::bigint as total_size_bytes,
  pg_relation_size(quote_ident(t.schemaname)||'.'||quote_ident(t.relname))::bigint as table_size_bytes,
  (pg_total_relation_size(quote_ident(t.schemaname)||'.'||quote_ident(t.relname)) - pg_relation_size(quote_ident(t.schemaname)||'.'||quote_ident(t.relname)))::bigint as indexes_size_bytes,
  t.n_live_tup::bigint,
  t.last_vacuum,
  t.last_analyze
FROM pg_stat_user_tables t
ORDER BY pg_total_relation_size(quote_ident(t.schemaname)||'.'||quote_ident(t.relname)) DESC
LIMIT 20;
$function$
;

CREATE OR REPLACE FUNCTION public.get_top_products_report(store_uuid uuid DEFAULT NULL::uuid, start_date date DEFAULT (CURRENT_DATE - '30 days'::interval), end_date date DEFAULT CURRENT_DATE, limit_count integer DEFAULT 10)
 RETURNS TABLE(store_id uuid, store_name text, product_id uuid, product_name text, category text, total_quantity_sold bigint, total_revenue numeric, order_count bigint, avg_quantity_per_order numeric)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        s.id as store_id,
        s.name as store_name,
        p.id as product_id,
        p.name as product_name,
        p.category,
        SUM(oi.quantity) as total_quantity_sold,
        SUM(oi.total_price) as total_revenue,
        COUNT(DISTINCT o.id) as order_count,
        AVG(oi.quantity) as avg_quantity_per_order
    FROM stores s
    JOIN products p ON s.id = p.store_id
    JOIN order_items oi ON p.id = oi.product_id
    JOIN orders o ON oi.order_id = o.id
    WHERE o.created_at >= start_date 
    AND o.created_at <= end_date + INTERVAL '1 day' - INTERVAL '1 second'
    AND o.status = 'delivered'
    AND (store_uuid IS NULL OR s.id = store_uuid)
    GROUP BY s.id, s.name, p.id, p.name, p.category
    ORDER BY total_revenue DESC
    LIMIT limit_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_unread_message_count(order_uuid uuid)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM chat_messages
        WHERE order_id = order_uuid
        AND is_read = FALSE
        AND sender_type != (
            CASE 
                WHEN EXISTS (
                    SELECT 1 FROM current_rider_assignments cra
                    WHERE cra.order_id = order_uuid
                    AND cra.rider_id = (
                        SELECT rider_id FROM rider_profile_view rpv
                        WHERE rpv.user_id = auth.uid()
                    )
                ) THEN 'rider'
                ELSE 'customer'
            END
        )
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_unread_message_count_with_fcm(order_uuid uuid)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM chat_messages
        WHERE order_id = order_uuid
        AND is_read = FALSE
        AND sender_type != (
            CASE 
                WHEN EXISTS (
                    SELECT 1 FROM current_rider_assignments cra
                    WHERE cra.order_id = order_uuid
                    AND cra.rider_id = (
                        SELECT rider_id FROM rider_profile_view rpv
                        WHERE rpv.user_id = auth.uid()
                    )
                ) THEN 'rider'
                ELSE 'customer'
            END
        )
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_user_auth_status()
 RETURNS TABLE(user_id uuid, google_id text, email text, full_name text, role text, is_active boolean, last_login_at timestamp with time zone, login_count integer, avatar_url text)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        u.id,
        u.google_id,
        u.email,
        u.full_name,
        u.role,
        u.is_active,
        u.last_login_at,
        u.login_count,
        u.avatar_url
    FROM public.users u
    WHERE u.id = auth.uid();
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_user_by_email(email_param text)
 RETURNS TABLE(user_id uuid, google_id text, email text, full_name text, role text, is_active boolean, last_login_at timestamp with time zone, login_count integer, avatar_url text, phone text, line_id text, address text, created_at timestamp with time zone)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        u.id,
        u.google_id,
        u.email,
        u.full_name,
        u.role,
        u.is_active,
        u.last_login_at,
        u.login_count,
        u.avatar_url,
        u.phone,
        u.line_id,
        u.address,
        u.created_at
    FROM public.users u
    WHERE u.email = email_param;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_user_by_google_id(google_id_param text)
 RETURNS TABLE(user_id uuid, google_id text, email text, full_name text, role text, is_active boolean, last_login_at timestamp with time zone, login_count integer, avatar_url text, phone text, line_id text, address text, created_at timestamp with time zone)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        u.id,
        u.google_id,
        u.email,
        u.full_name,
        u.role,
        u.is_active,
        u.last_login_at,
        u.login_count,
        u.avatar_url,
        u.phone,
        u.line_id,
        u.address,
        u.created_at
    FROM public.users u
    WHERE u.google_id = google_id_param;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_user_by_id(user_id uuid)
 RETURNS TABLE(id uuid, google_id text, email text, full_name text, role text, is_active boolean, last_login_at timestamp with time zone, login_count integer, created_at timestamp with time zone)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        u.id,
        u.google_id,
        u.email,
        u.full_name,
        u.role,
        u.is_active,
        u.last_login_at,
        u.login_count,
        u.created_at
    FROM public.users u
    WHERE u.id = user_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_user_delivery_notes(p_user_id uuid, p_limit integer DEFAULT 10)
 RETURNS TABLE(id uuid, note_title text, note_content text, is_favorite boolean, usage_count integer, last_used_at timestamp with time zone, created_at timestamp with time zone)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        dn.id,
        dn.note_title,
        dn.note_content,
        dn.is_favorite,
        dn.usage_count,
        dn.last_used_at,
        dn.created_at
    FROM public.delivery_notes dn
    WHERE dn.user_id = p_user_id
    ORDER BY 
        dn.is_favorite DESC,
        dn.usage_count DESC,
        dn.last_used_at DESC NULLS LAST,
        dn.created_at DESC
    LIMIT p_limit;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_weekly_sales_report(store_uuid uuid DEFAULT NULL::uuid, start_date date DEFAULT (CURRENT_DATE - '30 days'::interval), end_date date DEFAULT CURRENT_DATE)
 RETURNS TABLE(store_id uuid, store_name text, week_start date, week_end date, year integer, week_number integer, weekly_orders bigint, weekly_revenue numeric, avg_order_value numeric, completed_orders bigint, cancelled_orders bigint, cash_revenue numeric, transfer_revenue numeric, cash_orders bigint, transfer_orders bigint)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        s.id as store_id,
        s.name as store_name,
        date_trunc('week', o.created_at)::date as week_start,
        (date_trunc('week', o.created_at) + INTERVAL '6 days')::date as week_end,
        EXTRACT(year FROM o.created_at)::integer as year,
        EXTRACT(week FROM o.created_at)::integer as week_number,
        COUNT(o.id) as weekly_orders,
        SUM(CASE WHEN o.status != 'cancelled' THEN o.subtotal ELSE 0 END) as weekly_revenue,
        AVG(CASE WHEN o.status != 'cancelled' THEN o.subtotal ELSE NULL END) as avg_order_value,
        COUNT(CASE WHEN o.status = 'delivered' THEN 1 END) as completed_orders,
        COUNT(CASE WHEN o.status = 'cancelled' THEN 1 END) as cancelled_orders,
        SUM(CASE WHEN o.payment_method = 'cash' AND o.status != 'cancelled' THEN o.subtotal ELSE 0 END) as cash_revenue,
        SUM(CASE WHEN o.payment_method = 'bank_transfer' AND o.status != 'cancelled' THEN o.subtotal ELSE 0 END) as transfer_revenue,
        COUNT(CASE WHEN o.payment_method = 'cash' THEN 1 END) as cash_orders,
        COUNT(CASE WHEN o.payment_method = 'bank_transfer' THEN 1 END) as transfer_orders
    FROM stores s
    LEFT JOIN orders o ON s.id = o.store_id 
        AND o.created_at >= start_date 
        AND o.created_at <= end_date + INTERVAL '1 day' - INTERVAL '1 second'
    WHERE (store_uuid IS NULL OR s.id = store_uuid)
    GROUP BY s.id, s.name, date_trunc('week', o.created_at), EXTRACT(year FROM o.created_at), EXTRACT(week FROM o.created_at)
    ORDER BY s.name, date_trunc('week', o.created_at) DESC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_yearly_sales_report(store_uuid uuid DEFAULT NULL::uuid, start_year integer DEFAULT (EXTRACT(year FROM CURRENT_DATE) - (5)::numeric), end_year integer DEFAULT EXTRACT(year FROM CURRENT_DATE))
 RETURNS TABLE(store_id uuid, store_name text, year integer, yearly_orders bigint, yearly_revenue numeric, avg_order_value numeric, completed_orders bigint, cancelled_orders bigint, cash_revenue numeric, transfer_revenue numeric, cash_orders bigint, transfer_orders bigint)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        s.id as store_id,
        s.name as store_name,
        EXTRACT(year FROM o.created_at)::integer as year,
        COUNT(o.id) as yearly_orders,
        SUM(CASE WHEN o.status != 'cancelled' THEN o.subtotal ELSE 0 END) as yearly_revenue,
        AVG(CASE WHEN o.status != 'cancelled' THEN o.subtotal ELSE NULL END) as avg_order_value,
        COUNT(CASE WHEN o.status = 'delivered' THEN 1 END) as completed_orders,
        COUNT(CASE WHEN o.status = 'cancelled' THEN 1 END) as cancelled_orders,
        SUM(CASE WHEN o.payment_method = 'cash' AND o.status != 'cancelled' THEN o.subtotal ELSE 0 END) as cash_revenue,
        SUM(CASE WHEN o.payment_method = 'bank_transfer' AND o.status != 'cancelled' THEN o.subtotal ELSE 0 END) as transfer_revenue,
        COUNT(CASE WHEN o.payment_method = 'cash' THEN 1 END) as cash_orders,
        COUNT(CASE WHEN o.payment_method = 'bank_transfer' THEN 1 END) as transfer_orders
    FROM stores s
    LEFT JOIN orders o ON s.id = o.store_id 
        AND EXTRACT(year FROM o.created_at) BETWEEN start_year AND end_year
    WHERE (store_uuid IS NULL OR s.id = store_uuid)
    GROUP BY s.id, s.name, EXTRACT(year FROM o.created_at)
    ORDER BY s.name, EXTRACT(year FROM o.created_at) DESC;
END;
$function$
;

create or replace view "public"."google_users_report" as  SELECT id,
    google_id,
    email,
    full_name,
    role,
    avatar_url,
    google_given_name,
    google_family_name,
    google_locale,
    google_verified_email,
    last_login_at,
    login_count,
    is_active,
    created_at,
    updated_at
   FROM public.users
  WHERE (google_id IS NOT NULL)
  ORDER BY last_login_at DESC;


CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    -- ตรวจสอบว่าผู้ใช้มีอยู่แล้วหรือไม่
    IF NOT EXISTS (SELECT 1 FROM public.users WHERE id = NEW.id) THEN
        -- สร้างผู้ใช้ใหม่ในตาราง users
        INSERT INTO public.users (
            id,
            google_id,
            email,
            full_name,
            avatar_url,
            google_given_name,
            google_family_name,
            google_locale,
            google_picture,
            role,
            is_active,
            email_verified,
            phone_verified,
            google_verified_email,
            last_login_at,
            login_count,
            created_at,
            updated_at
        )
        VALUES (
            NEW.id,
            COALESCE(NEW.raw_user_meta_data->>'sub', NEW.id),
            NEW.email,
            COALESCE(NEW.raw_user_meta_data->>'name', NEW.email),
            NEW.raw_user_meta_data->>'picture',
            NEW.raw_user_meta_data->>'given_name',
            NEW.raw_user_meta_data->>'family_name',
            NEW.raw_user_meta_data->>'locale',
            NEW.raw_user_meta_data->>'picture',
            'customer',
            true,
            true,
            false,
            true,
            NOW(),
            1,
            NOW(),
            NOW()
        );
        
        RAISE NOTICE 'Created new user: %', NEW.id;
    ELSE
        -- อัปเดตข้อมูลการเข้าสู่ระบบ
        UPDATE public.users 
        SET 
            last_login_at = NOW(),
            login_count = COALESCE(login_count, 0) + 1,
            updated_at = NOW()
        WHERE id = NEW.id;
        
        RAISE NOTICE 'Updated existing user: %', NEW.id;
    END IF;
    
    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in handle_new_user for user %: %', NEW.id, SQLERRM;
        RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_store_report(report_uuid uuid, new_status text, handled_by_user_id uuid, admin_notes_param text DEFAULT NULL::text, ip_address_param inet DEFAULT NULL::inet, user_agent_param text DEFAULT NULL::text, session_id_param text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    report_info RECORD;
    store_info RECORD;
    start_time TIMESTAMP;
    execution_time_ms INTEGER;
BEGIN
    start_time := clock_timestamp();
    
    -- ตรวจสอบว่าเป็น admin
    IF NOT EXISTS (SELECT 1 FROM users WHERE id = handled_by_user_id AND role = 'admin') THEN
        -- บันทึก log การทำงานที่ล้มเหลว
        PERFORM log_admin_activity(
            handled_by_user_id,
            'store_report_handling',
            'handle_report',
            'store_reports',
            report_uuid,
            NULL,
            NULL,
            NULL,
            'Failed to handle store report - Not admin',
            ip_address_param,
            user_agent_param,
            session_id_param,
            NULL,
            false,
            'Only admin can handle store reports',
            EXTRACT(EPOCH FROM (clock_timestamp() - start_time)) * 1000,
            0,
            jsonb_build_object('report_id', report_uuid, 'new_status', new_status)
        );
        RAISE EXCEPTION 'Only admin can handle store reports';
    END IF;
    
    -- ดึงข้อมูลรายงาน
    SELECT * INTO report_info FROM store_reports WHERE id = report_uuid;
    
    -- ดึงข้อมูลร้านค้า
    SELECT * INTO store_info FROM stores WHERE id = report_info.store_id;
    
    -- บันทึกค่าเดิม
    PERFORM log_admin_activity(
        handled_by_user_id,
        'store_report_handling',
        'handle_report',
        'store_reports',
        report_uuid,
        store_info.name,
        jsonb_build_object('status', report_info.status, 'admin_notes', report_info.admin_notes),
        jsonb_build_object('status', new_status, 'admin_notes', admin_notes_param),
        'Handled store report: ' || report_info.title,
        ip_address_param,
        user_agent_param,
        session_id_param,
        NULL,
        true,
        NULL,
        EXTRACT(EPOCH FROM (clock_timestamp() - start_time)) * 1000,
        1,
        jsonb_build_object(
            'report_id', report_uuid,
            'store_id', report_info.store_id,
            'report_type', report_info.report_type,
            'severity_level', report_info.severity_level,
            'new_status', new_status
        )
    );
    
    -- อัปเดตสถานะรายงาน
    UPDATE store_reports 
    SET 
        status = new_status,
        admin_notes = admin_notes_param,
        handled_by = handled_by_user_id,
        handled_at = NOW(),
        updated_at = NOW()
    WHERE id = report_uuid;
    
    -- ส่งการแจ้งเตือนผู้รายงาน
    PERFORM send_notification(
        report_info.reporter_id,
        'รายงานปัญหาของคุณได้รับการจัดการ',
        'รายงานปัญหาที่คุณส่งได้รับการจัดการแล้ว สถานะ: ' || 
        CASE 
            WHEN new_status = 'investigating' THEN 'กำลังตรวจสอบ'
            WHEN new_status = 'resolved' THEN 'แก้ไขแล้ว'
            WHEN new_status = 'dismissed' THEN 'ไม่พบปัญหา'
        END,
        'system',
        jsonb_build_object(
            'report_id', report_uuid,
            'status', new_status,
            'admin_notes', admin_notes_param
        )
    );
    
    -- ส่งการแจ้งเตือนเจ้าของร้าน
    PERFORM send_notification(
        store_info.owner_id,
        'รายงานปัญหาถูกจัดการ',
        'มีรายงานปัญหากับร้านของคุณได้รับการจัดการแล้ว กรุณาตรวจสอบ',
        'system',
        jsonb_build_object(
            'report_id', report_uuid,
            'status', new_status,
            'admin_notes', admin_notes_param
        )
    );
END;
$function$
;

create or replace view "public"."hotel_bookings_with_details" as  SELECT hb.id,
    hb.booking_number,
    hb.customer_name,
    hb.customer_email,
    hb.customer_phone,
    hb.customer_line_id,
    hb.hotel_id,
    hb.room_id,
    hb.check_in_date,
    hb.check_out_date,
    hb.total_nights,
    hb.check_in_time,
    hb.check_out_time,
    hb.total_hours,
    hb.booking_type,
    hb.guests_count,
    hb.total_amount,
    hb.deposit_amount,
    hb.payment_method,
    hb.payment_status,
    hb.booking_status,
    hb.guests,
    hb.extras,
    hb.notes,
    hb.payment_info,
    hb.special_requests,
    hb.cancellation_reason,
    hb.cancelled_at,
    hb.created_at,
    hb.updated_at,
    hp.hotel_name,
    hp.address AS hotel_address,
    hr.room_number,
    hr.room_type
   FROM ((public.hotel_bookings hb
     JOIN public.hotel_properties hp ON ((hb.hotel_id = hp.id)))
     JOIN public.hotel_rooms hr ON ((hb.room_id = hr.id)));


create or replace view "public"."hotel_properties_with_owner" as  SELECT hp.id,
    hp.owner_id,
    hp.owner_name,
    hp.owner_email,
    hp.owner_phone,
    hp.hotel_name,
    hp.description,
    hp.address,
    hp.hotel_phone,
    hp.hotel_email,
    hp.website,
    hp.latitude,
    hp.longitude,
    hp.star_rating,
    hp.price_range,
    hp.hotel_size,
    hp.max_rooms,
    hp.total_rooms,
    hp.amenities,
    hp.images,
    hp.policies,
    hp.verification_documents,
    hp.is_active,
    hp.is_verified,
    hp.verification_status,
    hp.created_at,
    hp.updated_at,
    hoa.email AS account_email,
    hoa.is_active AS owner_active
   FROM (public.hotel_properties hp
     LEFT JOIN public.hotel_owner_accounts hoa ON ((hp.id = hoa.hotel_id)));


create or replace view "public"."hotel_rooms_with_hotel" as  SELECT hr.id,
    hr.hotel_id,
    hr.room_type_id,
    hr.room_type,
    hr.room_number,
    hr.floor_number,
    hr.price_per_night,
    hr.hourly_price,
    hr.capacity,
    hr.size_sqm,
    hr.amenities,
    hr.images,
    hr.maintenance_history,
    hr.cleaning_schedule,
    hr.supports_hourly,
    hr.hourly_minimum_hours,
    hr.hourly_maximum_hours,
    hr.is_available,
    hr.room_status,
    hr.created_at,
    hr.updated_at,
    hp.hotel_name,
    hp.address AS hotel_address,
    hrt.type_name AS room_type_name
   FROM ((public.hotel_rooms hr
     JOIN public.hotel_properties hp ON ((hr.hotel_id = hp.id)))
     LEFT JOIN public.hotel_room_types hrt ON ((hr.room_type_id = hrt.id)));


create or replace view "public"."important_chat_messages" as  SELECT cm.id,
    cm.order_id,
    cm.sender_type,
    cm.sender_id,
    cm.message,
    cm.message_type,
    cm.is_read,
    cm.created_at,
    o.order_number,
    o.customer_name,
    o.customer_phone,
    o.delivery_address,
    o.status AS order_status,
        CASE
            WHEN ((cm.message ~~* '%ยกเลิก%'::text) OR (cm.message ~~* '%cancel%'::text)) THEN 'ยกเลิก'::text
            WHEN ((cm.message ~~* '%ปัญหา%'::text) OR (cm.message ~~* '%problem%'::text)) THEN 'ปัญหา'::text
            WHEN ((cm.message ~~* '%ช้า%'::text) OR (cm.message ~~* '%slow%'::text)) THEN 'ความล่าช้า'::text
            WHEN ((cm.message ~~* '%ผิด%'::text) OR (cm.message ~~* '%wrong%'::text)) THEN 'ข้อผิดพลาด'::text
            WHEN ((cm.message ~~* '%ขอบคุณ%'::text) OR (cm.message ~~* '%thank%'::text)) THEN 'ขอบคุณ'::text
            ELSE 'ทั่วไป'::text
        END AS message_category
   FROM (public.chat_messages cm
     JOIN public.orders o ON ((cm.order_id = o.id)))
  WHERE ((cm.message ~~* '%ยกเลิก%'::text) OR (cm.message ~~* '%cancel%'::text) OR (cm.message ~~* '%ปัญหา%'::text) OR (cm.message ~~* '%problem%'::text) OR (cm.message ~~* '%ช้า%'::text) OR (cm.message ~~* '%slow%'::text) OR (cm.message ~~* '%ผิด%'::text) OR (cm.message ~~* '%wrong%'::text) OR (cm.message ~~* '%ขอบคุณ%'::text) OR (cm.message ~~* '%thank%'::text))
  ORDER BY cm.created_at DESC;


CREATE OR REPLACE FUNCTION public.increment_ads_click_count(ad_id uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE public.ads 
    SET click_count = click_count + 1 
    WHERE id = ad_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.increment_ads_floating_click_count(ad_id uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE public.ads_floating 
    SET click_count = click_count + 1 
    WHERE id = ad_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.increment_ads_floating_view_count(ad_id uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE public.ads_floating 
    SET view_count = view_count + 1 
    WHERE id = ad_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.increment_ads_view_count(ad_id uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE public.ads 
    SET view_count = view_count + 1 
    WHERE id = ad_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.increment_delivery_note_usage(note_id uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE public.delivery_notes 
    SET 
        usage_count = usage_count + 1,
        last_used_at = now(),
        updated_at = now()
    WHERE id = note_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.increment_hotel_ad_click_count(ad_id uuid)
 RETURNS void
 LANGUAGE sql
 SECURITY DEFINER
AS $function$
  UPDATE ads_hotel 
  SET click_count = click_count + 1 
  WHERE id = ad_id;
$function$
;

CREATE OR REPLACE FUNCTION public.increment_hotel_ad_view_count(ad_id uuid)
 RETURNS void
 LANGUAGE sql
 SECURITY DEFINER
AS $function$
  UPDATE ads_hotel 
  SET view_count = view_count + 1 
  WHERE id = ad_id;
$function$
;

CREATE OR REPLACE FUNCTION public.insert_chat_message_with_fcm(p_order_id uuid, p_sender_type text, p_sender_id uuid, p_message text, p_message_type text DEFAULT 'text'::text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    message_id UUID;
    sender_fcm TEXT;
    recipient_fcm TEXT;
    debug_info TEXT;
BEGIN
    -- Debug: เก็บข้อมูลสำหรับตรวจสอบ
    debug_info := 'Order: ' || p_order_id || ', Sender: ' || p_sender_type || ', SenderID: ' || p_sender_id;
    
    -- ดึง FCM token ของผู้ส่ง
    IF p_sender_type = 'rider' THEN
        sender_fcm := (
            SELECT u.fcm_token
            FROM users u
            JOIN rider_profile_view rpv ON u.id = rpv.user_id
            WHERE rpv.rider_id = p_sender_id
            AND u.fcm_token IS NOT NULL
            AND u.fcm_token != ''
            LIMIT 1
        );
    ELSE
        sender_fcm := (
            SELECT fcm_token 
            FROM users 
            WHERE id = p_sender_id
            AND fcm_token IS NOT NULL
            AND fcm_token != ''
        );
    END IF;

    -- ดึง FCM token ของผู้รับ (ปรับปรุงแล้ว)
    IF p_sender_type = 'rider' THEN
        -- ถ้าผู้ส่งเป็นไรเดอร์ ผู้รับคือลูกค้า
        recipient_fcm := (
            SELECT u.fcm_token
            FROM users u
            JOIN orders o ON u.id = o.customer_id
            WHERE o.id = p_order_id
            AND u.fcm_token IS NOT NULL
            AND u.fcm_token != ''
            LIMIT 1
        );
    ELSE
        -- ถ้าผู้ส่งเป็นลูกค้า ผู้รับคือไรเดอร์ (ปรับปรุงแล้ว)
        recipient_fcm := (
            SELECT u.fcm_token
            FROM users u
            JOIN rider_profile_view rpv ON u.id = rpv.user_id
            JOIN rider_assignments ra ON rpv.rider_id = ra.rider_id
            WHERE ra.order_id = p_order_id
            AND ra.status IN ('assigned', 'picked_up', 'delivering', 'completed')
            AND u.fcm_token IS NOT NULL
            AND u.fcm_token != ''
            ORDER BY ra.created_at DESC
            LIMIT 1
        );
        
        -- ถ้าไม่เจอไรเดอร์ที่ได้รับมอบหมาย ให้ลองหาไรเดอร์ที่เคยได้รับมอบหมาย
        IF recipient_fcm IS NULL THEN
            recipient_fcm := (
                SELECT u.fcm_token
                FROM users u
                JOIN rider_profile_view rpv ON u.id = rpv.user_id
                JOIN rider_assignments ra ON rpv.rider_id = ra.rider_id
                WHERE ra.order_id = p_order_id
                AND u.fcm_token IS NOT NULL
                AND u.fcm_token != ''
                ORDER BY ra.created_at DESC
                LIMIT 1
            );
        END IF;
    END IF;

    -- Debug: แสดงข้อมูล FCM token
    RAISE NOTICE 'Debug: % - Sender FCM: % - Recipient FCM: %', 
        debug_info, 
        CASE WHEN sender_fcm IS NULL THEN 'NULL' ELSE 'VALID' END,
        CASE WHEN recipient_fcm IS NULL THEN 'NULL' ELSE 'VALID' END;

    -- เพิ่มข้อความ
    INSERT INTO chat_messages (
        order_id,
        sender_type,
        sender_id,
        message,
        message_type,
        sender_fcm_token,
        recipient_fcm_token
    ) VALUES (
        p_order_id,
        p_sender_type,
        p_sender_id,
        p_message,
        p_message_type,
        sender_fcm,
        recipient_fcm
    ) RETURNING id INTO message_id;

    RETURN message_id;
END;
$function$
;

create or replace view "public"."latest_chat_messages" as  SELECT DISTINCT ON (cm.order_id) cm.id,
    cm.order_id,
    cm.sender_type,
    cm.sender_id,
    cm.message,
    cm.message_type,
    cm.is_read,
    cm.created_at,
    o.order_number,
    o.customer_name,
    o.customer_phone,
    o.delivery_address,
    o.status AS order_status,
        CASE
            WHEN (cm.sender_type = 'customer'::text) THEN 'ลูกค้า'::text
            WHEN (cm.sender_type = 'rider'::text) THEN 'ไรเดอร์'::text
            ELSE 'ไม่ทราบ'::text
        END AS sender_type_thai
   FROM (public.chat_messages cm
     JOIN public.orders o ON ((cm.order_id = o.id)))
  ORDER BY cm.order_id, cm.created_at DESC;


CREATE OR REPLACE FUNCTION public.log_admin_activity(admin_user_id uuid, action_type_param text, action_subtype_param text DEFAULT NULL::text, target_table_param text DEFAULT NULL::text, target_id_param uuid DEFAULT NULL::uuid, target_name_param text DEFAULT NULL::text, old_values_param jsonb DEFAULT NULL::jsonb, new_values_param jsonb DEFAULT NULL::jsonb, action_details_param text DEFAULT NULL::text, ip_address_param inet DEFAULT NULL::inet, user_agent_param text DEFAULT NULL::text, session_id_param text DEFAULT NULL::text, request_id_param text DEFAULT NULL::text, success_param boolean DEFAULT true, error_message_param text DEFAULT NULL::text, execution_time_ms_param integer DEFAULT NULL::integer, affected_rows_param integer DEFAULT NULL::integer, additional_data_param jsonb DEFAULT NULL::jsonb)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    log_id UUID;
BEGIN
    INSERT INTO admin_activity_logs (
        admin_id,
        action_type,
        action_subtype,
        target_table,
        target_id,
        target_name,
        old_values,
        new_values,
        action_details,
        ip_address,
        user_agent,
        session_id,
        request_id,
        success,
        error_message,
        execution_time_ms,
        affected_rows,
        additional_data
    )
    VALUES (
        admin_user_id,
        action_type_param,
        action_subtype_param,
        target_table_param,
        target_id_param,
        target_name_param,
        old_values_param,
        new_values_param,
        action_details_param,
        ip_address_param,
        user_agent_param,
        session_id_param,
        request_id_param,
        success_param,
        error_message_param,
        execution_time_ms_param,
        affected_rows_param,
        additional_data_param
    )
    RETURNING id INTO log_id;
    
    RETURN log_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.log_admin_export(admin_user_id uuid, export_type_param text, target_table_param text, filters_applied_param jsonb DEFAULT NULL::jsonb, date_range_param jsonb DEFAULT NULL::jsonb, file_name_param text DEFAULT NULL::text, file_size_bytes_param integer DEFAULT NULL::integer, record_count_param integer DEFAULT NULL::integer, ip_address_param inet DEFAULT NULL::inet, user_agent_param text DEFAULT NULL::text, session_id_param text DEFAULT NULL::text, export_success_param boolean DEFAULT true, error_message_param text DEFAULT NULL::text)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    log_id UUID;
BEGIN
    INSERT INTO admin_export_logs (
        admin_id,
        export_type,
        target_table,
        filters_applied,
        date_range,
        file_name,
        file_size_bytes,
        record_count,
        ip_address,
        user_agent,
        session_id,
        export_success,
        error_message
    )
    VALUES (
        admin_user_id,
        export_type_param,
        target_table_param,
        filters_applied_param,
        date_range_param,
        file_name_param,
        file_size_bytes_param,
        record_count_param,
        ip_address_param,
        user_agent_param,
        session_id_param,
        export_success_param,
        error_message_param
    )
    RETURNING id INTO log_id;
    
    RETURN log_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.log_admin_login(admin_user_id uuid, login_method_param text DEFAULT 'google'::text, ip_address_param inet DEFAULT NULL::inet, user_agent_param text DEFAULT NULL::text, session_id_param text DEFAULT NULL::text, login_success_param boolean DEFAULT true, failure_reason_param text DEFAULT NULL::text)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    log_id UUID;
BEGIN
    INSERT INTO admin_login_logs (
        admin_id,
        login_method,
        ip_address,
        user_agent,
        session_id,
        login_success,
        failure_reason
    )
    VALUES (
        admin_user_id,
        login_method_param,
        ip_address_param,
        user_agent_param,
        session_id_param,
        login_success_param,
        failure_reason_param
    )
    RETURNING id INTO log_id;
    
    RETURN log_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.log_admin_logout(admin_user_id uuid, session_id_param text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE admin_login_logs 
    SET 
        logout_at = NOW(),
        session_duration_minutes = EXTRACT(EPOCH FROM (NOW() - login_at))/60
    WHERE session_id = session_id_param 
    AND logout_at IS NULL;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.log_admin_system_config(admin_user_id uuid, config_type_param text, config_key_param text, old_value_param jsonb DEFAULT NULL::jsonb, new_value_param jsonb DEFAULT NULL::jsonb, change_reason_param text DEFAULT NULL::text, ip_address_param inet DEFAULT NULL::inet, user_agent_param text DEFAULT NULL::text, session_id_param text DEFAULT NULL::text)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    log_id UUID;
BEGIN
    INSERT INTO admin_system_config_logs (
        admin_id,
        config_type,
        config_key,
        old_value,
        new_value,
        change_reason,
        ip_address,
        user_agent,
        session_id
    )
    VALUES (
        admin_user_id,
        config_type_param,
        config_key_param,
        old_value_param,
        new_value_param,
        change_reason_param,
        ip_address_param,
        user_agent_param,
        session_id_param
    )
    RETURNING id INTO log_id;
    
    RETURN log_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.log_admin_view(admin_user_id uuid, view_type_param text, target_table_param text DEFAULT NULL::text, target_id_param uuid DEFAULT NULL::uuid, filters_applied_param jsonb DEFAULT NULL::jsonb, search_terms_param text DEFAULT NULL::text, sort_by_param text DEFAULT NULL::text, page_number_param integer DEFAULT NULL::integer, items_per_page_param integer DEFAULT NULL::integer, total_items_param integer DEFAULT NULL::integer, ip_address_param inet DEFAULT NULL::inet, user_agent_param text DEFAULT NULL::text, session_id_param text DEFAULT NULL::text, view_duration_ms_param integer DEFAULT NULL::integer)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    log_id UUID;
BEGIN
    INSERT INTO admin_view_logs (
        admin_id,
        view_type,
        target_table,
        target_id,
        filters_applied,
        search_terms,
        sort_by,
        page_number,
        items_per_page,
        total_items,
        ip_address,
        user_agent,
        session_id,
        view_duration_ms
    )
    VALUES (
        admin_user_id,
        view_type_param,
        target_table_param,
        target_id_param,
        filters_applied_param,
        search_terms_param,
        sort_by_param,
        page_number_param,
        items_per_page_param,
        total_items_param,
        ip_address_param,
        user_agent_param,
        session_id_param,
        view_duration_ms_param
    )
    RETURNING id INTO log_id;
    
    RETURN log_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.mark_messages_as_read(order_uuid uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    UPDATE chat_messages
    SET is_read = TRUE
    WHERE order_id = order_uuid
    AND is_read = FALSE
    AND sender_type != (
        CASE 
            WHEN EXISTS (
                SELECT 1 FROM current_rider_assignments cra
                WHERE cra.order_id = order_uuid
                AND cra.rider_id = (
                    SELECT rider_id FROM rider_profile_view rpv
                    WHERE rpv.user_id = auth.uid()
                )
            ) THEN 'rider'
            ELSE 'customer'
        END
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.mark_messages_as_read_with_fcm(order_uuid uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    UPDATE chat_messages
    SET is_read = TRUE
    WHERE order_id = order_uuid
    AND is_read = FALSE
    AND sender_type != (
        CASE 
            WHEN EXISTS (
                SELECT 1 FROM current_rider_assignments cra
                WHERE cra.order_id = order_uuid
                AND cra.rider_id = (
                    SELECT rider_id FROM rider_profile_view rpv
                    WHERE rpv.user_id = auth.uid()
                )
            ) THEN 'rider'
            ELSE 'customer'
        END
    );
END;
$function$
;

create or replace view "public"."monthly_sales_report" as  WITH base AS (
         SELECT (date_trunc('month'::text, (o.created_at AT TIME ZONE 'Asia/Bangkok'::text)))::date AS month_start,
            ((date_trunc('month'::text, (o.created_at AT TIME ZONE 'Asia/Bangkok'::text)) + '1 mon -1 days'::interval))::date AS month_end,
            EXTRACT(year FROM (o.created_at AT TIME ZONE 'Asia/Bangkok'::text)) AS year,
            EXTRACT(month FROM (o.created_at AT TIME ZONE 'Asia/Bangkok'::text)) AS month_number,
            to_char((o.created_at AT TIME ZONE 'Asia/Bangkok'::text), 'Month'::text) AS month_name,
            o.store_id,
            s.name AS store_name,
            count(o.id) AS order_count,
            count(o.id) FILTER (WHERE (o.status = ANY (ARRAY['delivered'::text, 'completed'::text]))) AS completed_orders,
            count(o.id) FILTER (WHERE (o.status = 'cancelled'::text)) AS cancelled_orders,
            COALESCE(sum(o.total_amount), (0)::numeric) AS total_amount_sum,
            COALESCE(sum(COALESCE(o.discount_amount, (0)::numeric)), (0)::numeric) AS discount_amount_sum,
            COALESCE(sum(
                CASE
                    WHEN (o.status <> 'cancelled'::text) THEN o.subtotal
                    ELSE (0)::numeric
                END), (0)::numeric) AS net_revenue,
            COALESCE(avg(
                CASE
                    WHEN (o.status <> 'cancelled'::text) THEN o.subtotal
                    ELSE NULL::numeric
                END), (0)::numeric) AS avg_subtotal,
            count(o.id) FILTER (WHERE (o.discount_code IS NOT NULL)) AS discount_orders,
            COALESCE(sum(
                CASE
                    WHEN ((o.payment_method = 'cash'::text) AND (o.status <> 'cancelled'::text)) THEN o.subtotal
                    ELSE (0)::numeric
                END), (0)::numeric) AS cash_revenue,
            COALESCE(sum(
                CASE
                    WHEN ((o.payment_method = 'bank_transfer'::text) AND (o.status <> 'cancelled'::text)) THEN o.subtotal
                    ELSE (0)::numeric
                END), (0)::numeric) AS transfer_revenue,
            count(o.id) FILTER (WHERE (o.payment_method = 'cash'::text)) AS cash_orders,
            count(o.id) FILTER (WHERE (o.payment_method = 'bank_transfer'::text)) AS transfer_orders,
            count(DISTINCT o.customer_id) AS unique_customers,
            count(DISTINCT o.rider_id) AS unique_riders
           FROM (public.orders o
             LEFT JOIN public.stores s ON ((s.id = o.store_id)))
          WHERE (o.created_at IS NOT NULL)
          GROUP BY (date_trunc('month'::text, (o.created_at AT TIME ZONE 'Asia/Bangkok'::text))), (((date_trunc('month'::text, (o.created_at AT TIME ZONE 'Asia/Bangkok'::text)) + '1 mon -1 days'::interval))::date), (EXTRACT(year FROM (o.created_at AT TIME ZONE 'Asia/Bangkok'::text))), (EXTRACT(month FROM (o.created_at AT TIME ZONE 'Asia/Bangkok'::text))), (to_char((o.created_at AT TIME ZONE 'Asia/Bangkok'::text), 'Month'::text)), o.store_id, s.name
        )
 SELECT month_start,
    month_end,
    year,
    month_number,
    month_name,
    order_count AS total_orders,
    net_revenue AS total_revenue,
    discount_amount_sum AS total_discount_given,
    (net_revenue + discount_amount_sum) AS gross_revenue,
    avg_subtotal AS average_order_value,
    discount_orders AS orders_with_discount,
        CASE
            WHEN (order_count > 0) THEN (((discount_orders)::numeric * 100.0) / (order_count)::numeric)
            ELSE (0)::numeric
        END AS discount_usage_percentage,
    NULL::text AS most_used_discount_code,
    NULL::text AS most_used_discount_count,
    store_id,
    store_name,
    net_revenue AS monthly_revenue,
    order_count AS monthly_orders,
    total_amount_sum AS total_amount_revenue,
    completed_orders,
    cancelled_orders,
    cash_revenue,
    transfer_revenue,
    cash_orders,
    transfer_orders,
    unique_customers,
    unique_riders
   FROM base
  ORDER BY month_start DESC, net_revenue DESC;


create or replace view "public"."new_orders" as  SELECT o.id AS order_id,
    o.order_number,
    o.total_amount,
    o.subtotal,
    o.delivery_fee,
    o.payment_method,
    o.payment_status,
    o.delivery_address,
    o.delivery_latitude,
    o.delivery_longitude,
    o.special_instructions,
    o.created_at,
    o.updated_at,
    s.id AS store_id,
    s.name AS store_name,
    s.phone AS store_phone,
    s.address AS store_address,
    s.latitude AS store_latitude,
    s.longitude AS store_longitude,
    u.full_name AS customer_name,
    u.phone AS customer_phone,
    u.email AS customer_email,
    u.line_id AS customer_line_id
   FROM ((public.orders o
     JOIN public.stores s ON ((o.store_id = s.id)))
     JOIN public.users u ON ((o.customer_id = u.id)))
  WHERE (o.status = 'pending'::text)
  ORDER BY o.created_at DESC;


create or replace view "public"."new_stores_view" as  SELECT s.id,
    s.owner_id,
    s.name,
    s.description,
    s.address,
    s.phone,
    s.email,
    s.opening_hours,
    s.is_active,
    s.is_open,
    s.is_suspended,
    s.suspension_reason,
    s.suspended_by,
    s.suspended_at,
    s.auto_accept_orders,
    s.logo_url,
    s.banner_url,
    s.latitude,
    s.longitude,
    s.delivery_radius,
    s.minimum_order,
    s.created_at,
    s.updated_at,
    s.store_type_id,
    s.line_id,
    s.minimum_order_amount,
    s.phone_number,
    s.is_auto_open,
    (CURRENT_DATE - (s.created_at)::date) AS days_since_opening,
    sc.name AS store_type_name,
    u.full_name AS owner_name,
    u.email AS owner_email,
    u.phone AS owner_phone
   FROM ((public.stores s
     LEFT JOIN public.store_categories sc ON ((s.store_type_id = sc.id)))
     LEFT JOIN public.users u ON ((s.owner_id = u.id)))
  WHERE ((s.is_active = true) AND (s.is_suspended = false) AND (s.created_at >= (CURRENT_DATE - '30 days'::interval)))
  ORDER BY s.created_at DESC;


CREATE OR REPLACE FUNCTION public.notify_new_order()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    -- ส่งการแจ้งเตือนไปยังไรเดอร์ทั้งหมดเมื่อมีออเดอร์ใหม่ที่มีสถานะ ready
    IF NEW.order_status = 'ready' THEN
        PERFORM send_notification_to_all_riders(
            'ออเดอร์ใหม่',
            'มีออเดอร์ใหม่ที่พร้อมให้คุณรับ',
            jsonb_build_object(
                'type', 'new_order',
                'order_id', NEW.id,
                'order_number', NEW.order_number,
                'timestamp', NOW()::text
            )
        );
    END IF;
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.notify_new_pending_order(p_order_id uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_store_id uuid;
    v_store_name text;
    v_order_number text;
    v_customer_name text;
    v_total_amount numeric;
    v_notification_title text;
    v_notification_message text;
    v_notification_data jsonb;
BEGIN
    -- ดึงข้อมูลออเดอร์
    SELECT 
        o.store_id,
        s.name,
        o.order_number,
        u.full_name,
        o.total_amount
    INTO v_store_id, v_store_name, v_order_number, v_customer_name, v_total_amount
    FROM public.orders o
    JOIN public.stores s ON o.store_id = s.id
    JOIN public.users u ON o.customer_id = u.id
    WHERE o.id = p_order_id AND o.status = 'pending';
    
    IF v_store_id IS NULL THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'ไม่พบออเดอร์ที่ระบุ'
        );
    END IF;
    
    -- สร้างข้อความแจ้งเตือน
    v_notification_title := 'ออเดอร์ใหม่ #' || v_order_number;
    v_notification_message := 'มีออเดอร์ใหม่จาก ' || v_customer_name || ' จำนวน ' || v_total_amount || ' บาท';
    v_notification_data := jsonb_build_object(
        'order_id', p_order_id,
        'order_number', v_order_number,
        'store_id', v_store_id,
        'store_name', v_store_name,
        'customer_name', v_customer_name,
        'total_amount', v_total_amount
    );
    
    -- ส่งการแจ้งเตือนไปยังร้านค้า
    PERFORM public.send_notification(
        v_store_id,
        v_notification_title,
        v_notification_message,
        'order_update',
        v_notification_data
    );
    
    RETURN jsonb_build_object(
        'success', true,
        'message', 'ส่งการแจ้งเตือนออเดอร์ใหม่เรียบร้อยแล้ว',
        'order_id', p_order_id,
        'notification_title', v_notification_title,
        'notification_message', v_notification_message
    );
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'เกิดข้อผิดพลาดในการส่งการแจ้งเตือน: ' || SQLERRM
        );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.notify_order_status_change()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    store_owner_id UUID;
    customer_id UUID;
    existing_notification_id UUID;
    cancellation_reason_text TEXT;
BEGIN
    -- ดึงข้อมูลที่จำเป็น
    customer_id := NEW.customer_id;
    SELECT owner_id INTO store_owner_id 
    FROM stores 
    WHERE id = NEW.store_id;
    
    -- แจ้งเตือนลูกค้าเมื่อสถานะเปลี่ยน (ยกเว้นการยกเลิก เพราะจะจัดการใน update_order_status)
    IF OLD.status != NEW.status AND NEW.status != 'cancelled' THEN
        -- ตรวจสอบว่ามีการแจ้งเตือนสำหรับการเปลี่ยนแปลงสถานะนี้แล้วหรือไม่
        SELECT id INTO existing_notification_id
        FROM notifications 
        WHERE user_id = customer_id
        AND type = 'order_update'
        AND data->>'order_id' = NEW.id::text
        AND data->>'status' = NEW.status
        AND created_at > NOW() - INTERVAL '1 minute'
        LIMIT 1;
        
        -- ถ้ายังไม่มี ให้สร้างใหม่
        IF existing_notification_id IS NULL THEN
            PERFORM send_notification(
                customer_id,
                CASE 
                    WHEN NEW.status = 'accepted' THEN 'ร้านค้ารับออเดอร์แล้ว'
                    WHEN NEW.status = 'preparing' THEN 'ร้านค้ากำลังเตรียมอาหาร'
                    WHEN NEW.status = 'ready' THEN 'อาหารพร้อมส่ง'
                    WHEN NEW.status = 'picked_up' THEN 'ไดเดอร์ไปรับอาหารแล้ว'
                    WHEN NEW.status = 'delivering' THEN 'ไดเดอร์กำลังจัดส่ง'
                    WHEN NEW.status = 'completed' THEN 'จัดส่งสำเร็จ'
                    ELSE 'อัปเดตสถานะออเดอร์'
                END,
                CASE 
                    WHEN NEW.status = 'accepted' THEN 'ร้านค้าได้ยืนยันการรับออเดอร์ของคุณแล้ว'
                    WHEN NEW.status = 'preparing' THEN 'ร้านค้ากำลังเตรียมอาหารให้คุณ'
                    WHEN NEW.status = 'ready' THEN 'อาหารของคุณพร้อมส่งแล้ว ไดเดอร์จะมารับเร็วๆ นี้'
                    WHEN NEW.status = 'picked_up' THEN 'ไดเดอร์ได้ไปรับอาหารจากร้านค้าแล้ว'
                    WHEN NEW.status = 'delivering' THEN 'ไดเดอร์กำลังจัดส่งอาหารให้คุณ'
                    WHEN NEW.status = 'completed' THEN 'อาหารของคุณจัดส่งสำเร็จแล้ว กรุณาให้คะแนน'
                    ELSE 'สถานะออเดอร์ของคุณได้อัปเดตเป็น: ' || NEW.status
                END,
                'order_update',
                jsonb_build_object(
                    'order_id', NEW.id,
                    'order_number', NEW.order_number,
                    'status', NEW.status,
                    'previous_status', OLD.status
                )
            );
        END IF;
        
        -- แจ้งเตือนร้านค้าเมื่อสถานะเปลี่ยนเป็นสำคัญ (ยกเว้นการยกเลิก)
        IF store_owner_id IS NOT NULL AND NEW.status = 'ready' THEN
            -- ตรวจสอบว่ามีการแจ้งเตือนสำหรับร้านค้าแล้วหรือไม่
            SELECT id INTO existing_notification_id
            FROM notifications 
            WHERE user_id = store_owner_id
            AND type = 'order_update'
            AND data->>'order_id' = NEW.id::text
            AND data->>'status' = NEW.status
            AND created_at > NOW() - INTERVAL '1 minute'
            LIMIT 1;
            
            -- ถ้ายังไม่มี ให้สร้างใหม่
            IF existing_notification_id IS NULL THEN
                PERFORM send_notification(
                    store_owner_id,
                    'อาหารพร้อมส่ง #' || NEW.order_number,
                    'อาหารสำหรับออเดอร์ #' || NEW.order_number || ' พร้อมส่งแล้ว',
                    'order_update',
                    jsonb_build_object(
                        'order_id', NEW.id,
                        'order_number', NEW.order_number,
                        'status', NEW.status
                    )
                );
            END IF;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.notify_order_status_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    store_owner_id UUID;
    customer_id UUID;
BEGIN
    -- ดึง owner_id ของร้านค้า
    SELECT owner_id INTO store_owner_id 
    FROM stores 
    WHERE id = NEW.store_id;
    
    -- ดึง customer_id
    customer_id := NEW.customer_id;
    
    -- แจ้งเตือนลูกค้าเมื่อสถานะเปลี่ยน
    IF OLD.status != NEW.status THEN
        -- แจ้งเตือนลูกค้า
        PERFORM send_notification(
            customer_id,
            CASE 
                WHEN NEW.status = 'accepted' THEN 'ร้านค้ารับออเดอร์แล้ว'
                WHEN NEW.status = 'preparing' THEN 'ร้านค้ากำลังเตรียมอาหาร'
                WHEN NEW.status = 'ready' THEN 'อาหารพร้อมส่ง'
                WHEN NEW.status = 'picked_up' THEN 'ไดเดอร์ไปรับอาหารแล้ว'
                WHEN NEW.status = 'delivering' THEN 'ไดเดอร์กำลังจัดส่ง'
                WHEN NEW.status = 'completed' THEN 'จัดส่งสำเร็จ'
                WHEN NEW.status = 'cancelled' THEN 'ออเดอร์ถูกยกเลิก'
                ELSE 'อัปเดตสถานะออเดอร์'
            END,
            CASE 
                WHEN NEW.status = 'accepted' THEN 'ร้านค้าได้ยืนยันการรับออเดอร์ของคุณแล้ว'
                WHEN NEW.status = 'preparing' THEN 'ร้านค้ากำลังเตรียมอาหารให้คุณ'
                WHEN NEW.status = 'ready' THEN 'อาหารของคุณพร้อมส่งแล้ว ไดเดอร์จะมารับเร็วๆ นี้'
                WHEN NEW.status = 'picked_up' THEN 'ไดเดอร์ได้ไปรับอาหารจากร้านค้าแล้ว'
                WHEN NEW.status = 'delivering' THEN 'ไดเดอร์กำลังจัดส่งอาหารให้คุณ'
                WHEN NEW.status = 'completed' THEN 'อาหารของคุณจัดส่งสำเร็จแล้ว กรุณาให้คะแนน'
                WHEN NEW.status = 'cancelled' THEN 'ออเดอร์ของคุณถูกยกเลิก: ' || COALESCE(NEW.cancellation_reason, 'ไม่มีเหตุผล')
                ELSE 'สถานะออเดอร์ของคุณได้อัปเดตเป็น: ' || NEW.status
            END,
            'order_update',
            jsonb_build_object(
                'order_id', NEW.id,
                'order_number', NEW.order_number,
                'status', NEW.status,
                'previous_status', OLD.status
            )
        );
        
        -- แจ้งเตือนร้านค้าเมื่อสถานะเปลี่ยนเป็นสำคัญ
        IF store_owner_id IS NOT NULL AND NEW.status IN ('ready', 'cancelled') THEN
            PERFORM send_notification(
                store_owner_id,
                CASE 
                    WHEN NEW.status = 'ready' THEN 'อาหารพร้อมส่ง #' || NEW.order_number
                    WHEN NEW.status = 'cancelled' THEN 'ออเดอร์ถูกยกเลิก #' || NEW.order_number
                END,
                CASE 
                    WHEN NEW.status = 'ready' THEN 'อาหารสำหรับออเดอร์ #' || NEW.order_number || ' พร้อมส่งแล้ว'
                    WHEN NEW.status = 'cancelled' THEN 'ออเดอร์ #' || NEW.order_number || ' ถูกยกเลิก: ' || COALESCE(NEW.cancellation_reason, 'ไม่มีเหตุผล')
                END,
                'order_update',
                jsonb_build_object(
                    'order_id', NEW.id,
                    'order_number', NEW.order_number,
                    'status', NEW.status
                )
            );
        END IF;
    END IF;
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.notify_riders_new_order()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    edge_function_url TEXT;
    notification_data JSONB;
    response_status INTEGER;
    response_body TEXT;
    store_name TEXT;
    delivery_fee DECIMAL;
BEGIN
    -- ตรวจสอบว่า order นี้จะปรากฏใน available_orders_for_riders หรือไม่
    -- (status = 'ready' และ rider_id IS NULL และ store ต้อง active)
    IF NEW.status = 'ready' AND NEW.rider_id IS NULL THEN
        
        -- ดึงข้อมูลร้านค้าและตรวจสอบว่า active หรือไม่
        SELECT s.name, NEW.delivery_fee 
        INTO store_name, delivery_fee
        FROM stores s 
        WHERE s.id = NEW.store_id AND s.is_active = true;
        
        -- ถ้าไม่พบร้านค้าที่ active ให้ออกจาก function
        IF store_name IS NULL THEN
            RETURN NEW;
        END IF;

        -- ตั้งค่า URL ของ Edge Function (แก้ไขเป็น URL จริงของโปรเจคคุณ)
        -- เปลี่ยน URL นี้เป็น URL จริงของโปรเจคคุณ
        edge_function_url := 'https://lwmvqwmchpxmimoxsdkl.supabase.co/functions/v1/rider-notification';

        -- สร้างข้อมูลการแจ้งเตือน
        notification_data := jsonb_build_object(
            'title', 'มีงานใหม่เข้ามาแล้ว! 🚚',
            'body', 'มีออเดอร์ใหม่รอคุณอยู่ เปิดแอปเพื่อดูรายละเอียด',
            'order_id', NEW.id,
            'trigger_type', 'new_order',
            'data', jsonb_build_object(
                'order_id', NEW.id,
                'type', 'new_order_notification',
                'timestamp', NOW()::TEXT,
                'store_name', COALESCE(store_name, 'ร้านค้า'),
                'delivery_fee', COALESCE(delivery_fee, 0),
                'distance_km', COALESCE(NEW.distance_km, 0)
            )
        );

        -- เรียกใช้ Edge Function
        SELECT 
            status,
            content::TEXT
        INTO 
            response_status,
            response_body
        FROM 
            http((
                'POST',
                edge_function_url,
                ARRAY[
                    http_header('Content-Type', 'application/json'),
                    http_header('Authorization', 'Bearer ' || current_setting('app.settings.service_role_key'))
                ],
                'application/json',
                notification_data::TEXT
            ));

        -- บันทึก log การส่งการแจ้งเตือน
        INSERT INTO notification_logs (
            order_id,
            trigger_type,
            notification_data,
            response_status,
            response_body,
            created_at
        ) VALUES (
            NEW.id,
            'new_order',
            notification_data,
            response_status,
            response_body,
            NOW()
        );

        -- ถ้าส่งไม่สำเร็จ ให้ log error
        IF response_status != 200 THEN
            RAISE WARNING 'Failed to send notification for order %: Status %, Response %', 
                NEW.id, response_status, response_body;
        ELSE
            RAISE NOTICE 'Notification sent successfully for order %: %', 
                NEW.id, response_body;
        END IF;
    END IF;

    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.notify_store_on_order_insert()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    store_owner_id UUID;
    existing_notification_id UUID;
BEGIN
    -- ดึง owner_id ของร้านค้า
    SELECT owner_id INTO store_owner_id 
    FROM stores 
    WHERE id = NEW.store_id;
    
    -- สร้างการแจ้งเตือนให้ร้านค้า
    IF store_owner_id IS NOT NULL THEN
        -- ตรวจสอบว่ามีการแจ้งเตือนสำหรับออเดอร์นี้แล้วหรือไม่
        SELECT id INTO existing_notification_id
        FROM notifications 
        WHERE user_id = store_owner_id
        AND title = 'ออเดอร์ใหม่ #' || NEW.order_number
        AND message = 'มีออเดอร์ใหม่เข้ามาในระบบ กรุณาตรวจสอบและยืนยัน'
        AND type = 'order_update'
        AND data->>'order_id' = NEW.id::text
        AND created_at > NOW() - INTERVAL '1 minute'
        LIMIT 1;
        
        -- ถ้ายังไม่มี ให้สร้างใหม่
        IF existing_notification_id IS NULL THEN
            PERFORM send_notification(
                store_owner_id,
                'ออเดอร์ใหม่ #' || NEW.order_number,
                'มีออเดอร์ใหม่เข้ามาในระบบ กรุณาตรวจสอบและยืนยัน',
                'order_update',
                jsonb_build_object(
                    'order_id', NEW.id,
                    'order_number', NEW.order_number,
                    'status', NEW.status,
                    'total_amount', NEW.total_amount
                )
            );
        ELSE
            RAISE NOTICE 'ข้ามการแจ้งเตือนออเดอร์ใหม่ที่ซ้ำกัน: %', existing_notification_id;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$function$
;

create or replace view "public"."order_reviews_with_details" as  SELECT rev.id,
    rev.order_id,
    rev.customer_id,
    rev.store_id,
    rev.rating,
    rev.review_text,
    rev.review_images,
    rev.is_anonymous,
    rev.created_at,
    rev.updated_at,
    o.order_number,
    o.status AS order_status,
    o.total_amount,
    u.full_name AS customer_name,
    u.email AS customer_email,
    u.avatar_url AS customer_avatar,
    s.name AS store_name,
    s.description AS store_description,
    s.logo_url AS store_image_url
   FROM (((public.order_reviews rev
     JOIN public.orders o ON ((rev.order_id = o.id)))
     JOIN public.users u ON ((rev.customer_id = u.id)))
     JOIN public.stores s ON ((rev.store_id = s.id)))
  WHERE (rev.is_anonymous = false);


create or replace view "public"."order_rider_locations_view" as  SELECT orl.id,
    orl.order_id,
    orl.rider_id,
    orl.latitude,
    orl.longitude,
    orl.recorded_at,
    o.status AS order_status,
    o.order_number,
    u.full_name AS rider_name,
    u.phone AS rider_phone
   FROM (((public.order_rider_locations orl
     JOIN public.orders o ON ((o.id = orl.order_id)))
     JOIN public.riders r ON ((r.id = orl.rider_id)))
     JOIN public.users u ON ((u.id = r.user_id)));


create or replace view "public"."order_status_statistics" as  SELECT status,
    count(*) AS count,
        CASE
            WHEN (status = 'created'::text) THEN 'สร้างออเดอร์แล้ว'::text
            WHEN (status = 'waiting_payment'::text) THEN 'รอการชำระเงิน'::text
            WHEN (status = 'payment_confirmed'::text) THEN 'ยืนยันการชำระเงินแล้ว'::text
            WHEN (status = 'accepted'::text) THEN 'ยืนยันแล้ว'::text
            WHEN (status = 'waiting_rider_payment'::text) THEN 'รอไรเดอร์จ่ายเงิน'::text
            WHEN (status = 'preparing'::text) THEN 'กำลังเตรียม'::text
            WHEN (status = 'ready'::text) THEN 'พร้อมส่ง'::text
            WHEN (status = 'assigned'::text) THEN 'ได้รับมอบหมาย'::text
            WHEN (status = 'picked_up'::text) THEN 'รับสินค้าแล้ว'::text
            WHEN (status = 'delivering'::text) THEN 'กำลังส่ง'::text
            WHEN (status = 'delivered'::text) THEN 'ส่งสำเร็จ'::text
            WHEN (status = 'cancelled'::text) THEN 'ยกเลิก'::text
            ELSE status
        END AS status_text,
        CASE
            WHEN (status = 'created'::text) THEN '#2196F3'::text
            WHEN (status = 'waiting_payment'::text) THEN '#FF9800'::text
            WHEN (status = 'payment_confirmed'::text) THEN '#4CAF50'::text
            WHEN (status = 'accepted'::text) THEN '#2196F3'::text
            WHEN (status = 'waiting_rider_payment'::text) THEN '#FF9800'::text
            WHEN (status = 'preparing'::text) THEN '#9C27B0'::text
            WHEN (status = 'ready'::text) THEN '#4CAF50'::text
            WHEN (status = 'assigned'::text) THEN '#673AB7'::text
            WHEN (status = 'picked_up'::text) THEN '#FF9800'::text
            WHEN (status = 'delivering'::text) THEN '#00BCD4'::text
            WHEN (status = 'delivered'::text) THEN '#4CAF50'::text
            WHEN (status = 'cancelled'::text) THEN '#F44336'::text
            ELSE '#9E9E9E'::text
        END AS status_color
   FROM public.orders
  WHERE (created_at >= (CURRENT_DATE - '30 days'::interval))
  GROUP BY status
  ORDER BY (count(*)) DESC;


create or replace view "public"."order_status_statistics_daily" as  SELECT ((created_at AT TIME ZONE 'Asia/Bangkok'::text))::date AS order_date,
    status,
    count(*) AS order_count,
    sum(total_amount) AS total_revenue,
    sum(COALESCE(discount_amount, (0)::numeric)) AS total_discount_given,
    count(
        CASE
            WHEN (discount_code IS NOT NULL) THEN 1
            ELSE NULL::integer
        END) AS orders_with_discount,
    (((count(
        CASE
            WHEN (discount_code IS NOT NULL) THEN 1
            ELSE NULL::integer
        END))::numeric * 100.0) / (count(*))::numeric) AS discount_usage_percentage
   FROM public.orders o
  GROUP BY (((created_at AT TIME ZONE 'Asia/Bangkok'::text))::date), status
  ORDER BY (((created_at AT TIME ZONE 'Asia/Bangkok'::text))::date) DESC, (count(*)) DESC;


create or replace view "public"."order_status_statistics_today" as  SELECT status,
    count(*) AS order_count,
    sum(total_amount) AS total_revenue,
    sum(COALESCE(discount_amount, (0)::numeric)) AS total_discount_given,
    count(
        CASE
            WHEN (discount_code IS NOT NULL) THEN 1
            ELSE NULL::integer
        END) AS orders_with_discount,
    (((count(
        CASE
            WHEN (discount_code IS NOT NULL) THEN 1
            ELSE NULL::integer
        END))::numeric * 100.0) / (count(*))::numeric) AS discount_usage_percentage
   FROM public.orders o
  WHERE (((created_at AT TIME ZONE 'Asia/Bangkok'::text))::date = ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Bangkok'::text))::date)
  GROUP BY status
  ORDER BY (count(*)) DESC;


create or replace view "public"."orders_payment_confirmed" as  SELECT o.id AS order_id,
    o.order_number,
    o.total_amount,
    o.subtotal,
    o.delivery_fee,
    o.payment_method,
    o.payment_status,
    o.transfer_confirmed_at,
    o.transfer_confirmed_by,
    o.created_at,
    o.updated_at,
    s.id AS store_id,
    s.name AS store_name,
    s.phone AS store_phone,
    s.address AS store_address,
    s.latitude AS store_latitude,
    s.longitude AS store_longitude,
    u.full_name AS customer_name,
    u.phone AS customer_phone,
    u.email AS customer_email,
    u.line_id AS customer_line_id
   FROM ((public.orders o
     JOIN public.stores s ON ((o.store_id = s.id)))
     JOIN public.users u ON ((o.customer_id = u.id)))
  WHERE (o.status = 'payment_confirmed'::text)
  ORDER BY o.created_at;


create or replace view "public"."orders_waiting_payment" as  SELECT o.id AS order_id,
    o.order_number,
    o.total_amount,
    o.subtotal,
    o.delivery_fee,
    o.payment_method,
    o.payment_status,
    o.bank_account_number,
    o.bank_account_name,
    o.bank_name,
    o.transfer_amount,
    o.transfer_reference,
    o.qr_code_url,
    o.created_at,
    o.updated_at,
    s.name AS store_name,
    s.phone AS store_phone,
    u.full_name AS customer_name,
    u.phone AS customer_phone,
    u.email AS customer_email,
    u.line_id AS customer_line_id
   FROM ((public.orders o
     JOIN public.stores s ON ((o.store_id = s.id)))
     JOIN public.users u ON ((o.customer_id = u.id)))
  WHERE ((o.status = 'waiting_payment'::text) AND (o.payment_method = 'bank_transfer'::text))
  ORDER BY o.created_at;


create or replace view "public"."orders_waiting_rider_payment" as  SELECT o.id AS order_id,
    o.order_number,
    o.total_amount,
    o.subtotal,
    o.delivery_fee,
    o.payment_method,
    o.payment_status,
    o.created_at,
    o.updated_at,
    s.name AS store_name,
    s.phone AS store_phone,
    s.address AS store_address,
    s.latitude AS store_latitude,
    s.longitude AS store_longitude,
    u.full_name AS customer_name,
    u.phone AS customer_phone,
    u.email AS customer_email,
    u.line_id AS customer_line_id
   FROM ((public.orders o
     JOIN public.stores s ON ((o.store_id = s.id)))
     JOIN public.users u ON ((o.customer_id = u.id)))
  WHERE (o.status = 'waiting_rider_payment'::text)
  ORDER BY o.created_at;


create or replace view "public"."payment_report" as  SELECT o.id AS order_id,
    o.order_number,
    o.payment_method,
    o.payment_status,
    o.total_amount,
    o.bank_account_number,
    o.bank_account_name,
    o.transfer_reference,
    o.transfer_confirmed_at,
    ( SELECT users.full_name
           FROM public.users
          WHERE (users.id = o.transfer_confirmed_by)) AS confirmed_by_name,
    s.name AS store_name,
    u.full_name AS customer_name,
    u.phone AS customer_phone,
    u.line_id AS customer_line_id,
    o.created_at AS order_created_at,
    o.updated_at AS order_updated_at
   FROM ((public.orders o
     JOIN public.stores s ON ((o.store_id = s.id)))
     JOIN public.users u ON ((o.customer_id = u.id)))
  WHERE (o.payment_method IS NOT NULL)
  ORDER BY o.created_at DESC;


create or replace view "public"."payment_statistics" as  SELECT payment_method,
    payment_status,
    count(*) AS count,
    sum(total_amount) AS total_amount,
    avg(total_amount) AS average_amount,
        CASE
            WHEN (payment_method = 'cash'::text) THEN 'เงินสด'::text
            WHEN (payment_method = 'bank_transfer'::text) THEN 'โอนเงิน'::text
            WHEN (payment_method = 'credit_card'::text) THEN 'บัตรเครดิต'::text
            ELSE payment_method
        END AS payment_method_text,
        CASE
            WHEN (payment_status = 'pending'::text) THEN 'รอชำระ'::text
            WHEN (payment_status = 'paid'::text) THEN 'ชำระแล้ว'::text
            WHEN (payment_status = 'failed'::text) THEN 'ล้มเหลว'::text
            WHEN (payment_status = 'cancelled'::text) THEN 'ยกเลิก'::text
            ELSE payment_status
        END AS payment_status_text
   FROM public.orders
  WHERE (created_at >= (CURRENT_DATE - '30 days'::interval))
  GROUP BY payment_method, payment_status
  ORDER BY payment_method, payment_status;


create or replace view "public"."pending_orders_view" as  SELECT o.id AS order_id,
    o.order_number,
    o.total_amount,
    o.subtotal,
    o.delivery_fee,
    o.payment_method,
    o.payment_status,
    o.delivery_address,
    o.delivery_latitude,
    o.delivery_longitude,
    o.special_instructions,
    o.created_at,
    o.updated_at,
    s.id AS store_id,
    s.name AS store_name,
    s.phone AS store_phone,
    s.address AS store_address,
    s.latitude AS store_latitude,
    s.longitude AS store_longitude,
    u.full_name AS customer_name,
    u.phone AS customer_phone,
    u.email AS customer_email,
    u.line_id AS customer_line_id,
    COALESCE(oi_count.item_count, (0)::bigint) AS order_items_count,
    o.estimated_delivery_time,
    o.distance_km
   FROM (((public.orders o
     JOIN public.stores s ON ((o.store_id = s.id)))
     JOIN public.users u ON ((o.customer_id = u.id)))
     LEFT JOIN ( SELECT order_items.order_id,
            count(*) AS item_count
           FROM public.order_items
          GROUP BY order_items.order_id) oi_count ON ((o.id = oi_count.order_id)))
  WHERE (o.status = 'pending'::text)
  ORDER BY o.created_at DESC;


create or replace view "public"."popular_delivery_notes" as  SELECT dn.id,
    dn.user_id,
    u.full_name AS user_name,
    dn.note_title,
    dn.note_content,
    dn.is_favorite,
    dn.usage_count,
    dn.last_used_at,
    dn.created_at
   FROM (public.delivery_notes dn
     JOIN public.users u ON ((dn.user_id = u.id)))
  WHERE (dn.usage_count > 0)
  ORDER BY dn.usage_count DESC, dn.last_used_at DESC;


create or replace view "public"."preorder_dashboard" as  SELECT po.id,
    po.preorder_number,
    po.customer_id,
    u.full_name AS customer_name,
    u.phone AS customer_phone,
    po.scheduled_delivery_date,
    dw.name AS delivery_window_name,
    dw.start_time,
    dw.end_time,
    po.total_amount,
    po.required_deposit,
    po.deposit_status,
    po.status,
    po.created_at,
    count(pi.id) AS item_count,
    count(DISTINCT pi.store_id) AS store_count
   FROM (((public.preorder_orders po
     JOIN public.users u ON ((u.id = po.customer_id)))
     JOIN public.delivery_windows dw ON ((dw.id = po.delivery_window_id)))
     LEFT JOIN public.preorder_items pi ON ((pi.preorder_order_id = po.id)))
  GROUP BY po.id, u.full_name, u.phone, dw.name, dw.start_time, dw.end_time;


create or replace view "public"."products_with_options" as  SELECT p.id,
    p.store_id,
    p.name,
    p.description,
    p.price,
    p.original_price,
    p.image_url,
    p.category,
    p.subcategory,
    p.stock_quantity,
    p.is_available,
    p.is_featured,
    p.preparation_time,
    p.allergens,
    p.nutritional_info,
    p.created_at,
    p.updated_at,
    count(DISTINCT po.id) AS options_count,
    count(DISTINCT pov.id) AS option_values_count
   FROM ((public.products p
     LEFT JOIN public.product_options po ON (((p.id = po.product_id) AND (po.is_active = true))))
     LEFT JOIN public.product_option_values pov ON (((po.id = pov.option_id) AND (pov.is_available = true))))
  GROUP BY p.id;


CREATE OR REPLACE FUNCTION public.reject_cancellation_request(request_uuid uuid, review_notes text DEFAULT NULL::text, reviewed_by_user_id uuid DEFAULT NULL::uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE cancellation_requests 
    SET 
        status = 'rejected',
        reviewed_by = COALESCE(reviewed_by_user_id, (SELECT id FROM users WHERE role = 'admin' LIMIT 1)),
        reviewed_at = NOW(),
        review_notes = review_notes,
        updated_at = NOW()
    WHERE id = request_uuid;
    
    -- ส่งการแจ้งเตือนไดเดอร์
    PERFORM send_notification(
        (SELECT user_id FROM riders WHERE id = (SELECT rider_id FROM cancellation_requests WHERE id = request_uuid)),
        'คำขอยกเลิกถูกปฏิเสธ',
        'คำขอยกเลิกงานของคุณถูกปฏิเสธ กรุณาติดต่อผู้ดูแลระบบ',
        'system',
        jsonb_build_object('request_id', request_uuid, 'notes', review_notes)
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.reject_pending_order(p_order_id uuid, p_rejection_reason text DEFAULT NULL::text, p_updated_by_user_id uuid DEFAULT NULL::uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_order_exists boolean;
    v_current_status text;
    v_result jsonb;
BEGIN
    -- ตรวจสอบว่าออเดอร์มีอยู่จริงหรือไม่
    SELECT EXISTS(SELECT 1 FROM public.orders WHERE id = p_order_id)
    INTO v_order_exists;
    
    IF NOT v_order_exists THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'ไม่พบออเดอร์ที่ระบุ',
            'order_id', p_order_id
        );
    END IF;
    
    -- ตรวจสอบสถานะปัจจุบัน
    SELECT status INTO v_current_status
    FROM public.orders
    WHERE id = p_order_id;
    
    IF v_current_status != 'pending' THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'ออเดอร์นี้ไม่ใช่สถานะ pending',
            'current_status', v_current_status,
            'order_id', p_order_id
        );
    END IF;
    
    -- อัปเดทสถานะเป็น rejected
    UPDATE public.orders
    SET 
        status = 'rejected',
        cancellation_reason = COALESCE(p_rejection_reason, 'ออเดอร์ถูกปฏิเสธโดยร้านค้า'),
        cancelled_by = p_updated_by_user_id,
        cancelled_at = now(),
        updated_at = now()
    WHERE id = p_order_id;
    
    -- บันทึกประวัติการเปลี่ยนแปลงสถานะ
    INSERT INTO public.order_status_history (
        order_id,
        status,
        changed_by,
        notes
    ) VALUES (
        p_order_id,
        'rejected',
        p_updated_by_user_id,
        COALESCE(p_rejection_reason, 'ออเดอร์ถูกปฏิเสธโดยร้านค้า')
    );
    
    RETURN jsonb_build_object(
        'success', true,
        'message', 'ออเดอร์ถูกปฏิเสธเรียบร้อยแล้ว',
        'order_id', p_order_id,
        'new_status', 'rejected',
        'rejection_reason', COALESCE(p_rejection_reason, 'ออเดอร์ถูกปฏิเสธโดยร้านค้า')
    );
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'เกิดข้อผิดพลาดในการปฏิเสธออเดอร์: ' || SQLERRM,
            'order_id', p_order_id
        );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.reject_store_cancellation_request(request_uuid uuid, review_notes text DEFAULT NULL::text, reviewed_by_user_id uuid DEFAULT NULL::uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    store_owner_uuid UUID;
BEGIN
    UPDATE store_cancellation_requests 
    SET 
        status = 'rejected',
        reviewed_by = COALESCE(reviewed_by_user_id, (SELECT id FROM users WHERE role = 'admin' LIMIT 1)),
        reviewed_at = NOW(),
        review_notes = review_notes,
        updated_at = NOW()
    WHERE id = request_uuid;
    
    -- ส่งการแจ้งเตือน
    PERFORM send_notification(
        (SELECT owner_id FROM stores WHERE id = (
            SELECT store_id FROM store_cancellation_requests WHERE id = request_uuid
        )),
        'คำขอยกเลิกถูกปฏิเสธ',
        'คำขอยกเลิกออเดอร์ของคุณถูกปฏิเสธ กรุณาติดต่อผู้ดูแลระบบ',
        'system',
        jsonb_build_object('request_id', request_uuid, 'notes', review_notes)
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.report_fcm_token_by_order(order_uuid uuid)
 RETURNS TABLE(order_id uuid, total_messages integer, messages_with_sender_fcm integer, messages_with_recipient_fcm integer, messages_with_both_fcm integer, messages_without_fcm integer)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        cm.order_id,
        COUNT(*)::INTEGER as total_messages,
        COUNT(CASE WHEN cm.sender_fcm_token IS NOT NULL AND cm.sender_fcm_token != '' THEN 1 END)::INTEGER as messages_with_sender_fcm,
        COUNT(CASE WHEN cm.recipient_fcm_token IS NOT NULL AND cm.recipient_fcm_token != '' THEN 1 END)::INTEGER as messages_with_recipient_fcm,
        COUNT(CASE WHEN cm.sender_fcm_token IS NOT NULL AND cm.sender_fcm_token != '' AND cm.recipient_fcm_token IS NOT NULL AND cm.recipient_fcm_token != '' THEN 1 END)::INTEGER as messages_with_both_fcm,
        COUNT(CASE WHEN (cm.sender_fcm_token IS NULL OR cm.sender_fcm_token = '') OR (cm.recipient_fcm_token IS NULL OR cm.recipient_fcm_token = '') THEN 1 END)::INTEGER as messages_without_fcm
    FROM chat_messages cm
    WHERE cm.order_id = order_uuid
    GROUP BY cm.order_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.report_fcm_token_status()
 RETURNS TABLE(total_messages integer, messages_with_sender_fcm integer, messages_with_recipient_fcm integer, messages_with_both_fcm integer, messages_without_fcm integer)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_messages,
        COUNT(CASE WHEN sender_fcm_token IS NOT NULL AND sender_fcm_token != '' THEN 1 END)::INTEGER as messages_with_sender_fcm,
        COUNT(CASE WHEN recipient_fcm_token IS NOT NULL AND recipient_fcm_token != '' THEN 1 END)::INTEGER as messages_with_recipient_fcm,
        COUNT(CASE WHEN sender_fcm_token IS NOT NULL AND sender_fcm_token != '' AND recipient_fcm_token IS NOT NULL AND recipient_fcm_token != '' THEN 1 END)::INTEGER as messages_with_both_fcm,
        COUNT(CASE WHEN (sender_fcm_token IS NULL OR sender_fcm_token = '') OR (recipient_fcm_token IS NULL OR recipient_fcm_token = '') THEN 1 END)::INTEGER as messages_without_fcm
    FROM chat_messages;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.report_store_issue(store_uuid uuid, reporter_user_id uuid, report_type_param text, title_param text, severity_level_param text DEFAULT 'medium'::text, description_param text DEFAULT NULL::text, evidence_images_param text[] DEFAULT NULL::text[])
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    report_id UUID;
    store_info RECORD;
BEGIN
    -- ตรวจสอบว่าเป็นลูกค้า
    IF NOT EXISTS (SELECT 1 FROM users WHERE id = reporter_user_id AND role = 'customer') THEN
        RAISE EXCEPTION 'Only customers can report store issues';
    END IF;
    
    -- ดึงข้อมูลร้านค้า
    SELECT * INTO store_info FROM stores WHERE id = store_uuid;
    
    -- สร้างรายงาน
    INSERT INTO store_reports (
        store_id,
        reporter_id,
        report_type,
        title,
        description,
        evidence_images,
        severity_level
    )
    VALUES (
        store_uuid,
        reporter_user_id,
        report_type_param,
        title_param,
        description_param,
        evidence_images_param,
        severity_level_param
    )
    RETURNING id INTO report_id;
    
    -- ส่งการแจ้งเตือนไปยัง admin
    PERFORM send_notification(
        (SELECT id FROM users WHERE role = 'admin' LIMIT 1),
        'รายงานปัญหาใหม่',
        'มีรายงานปัญหาใหม่จากร้าน ' || store_info.name || ' - ระดับ: ' || severity_level_param,
        'system',
        jsonb_build_object(
            'report_id', report_id,
            'store_id', store_uuid,
            'report_type', report_type_param,
            'severity_level', severity_level_param
        )
    );
    
    -- ส่งการแจ้งเตือนเจ้าของร้าน
    PERFORM send_notification(
        store_info.owner_id,
        'มีรายงานปัญหาใหม่',
        'มีลูกค้ารายงานปัญหากับร้านของคุณ กรุณาตรวจสอบและแก้ไข',
        'system',
        jsonb_build_object(
            'report_id', report_id,
            'report_type', report_type_param,
            'severity_level', severity_level_param
        )
    );
    
    RETURN report_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.request_cancellation(reason text, assignment_uuid uuid, emergency_level text DEFAULT 'medium'::text, description text DEFAULT NULL::text, evidence_images text[] DEFAULT NULL::text[])
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    request_id UUID;
    rider_uuid UUID;
    order_uuid UUID;
BEGIN
    -- ตรวจสอบว่า assignment ยังใช้งานได้
    IF NOT EXISTS (
        SELECT 1 FROM rider_assignments 
        WHERE id = assignment_uuid 
        AND status IN ('assigned', 'picked_up', 'delivering')
    ) THEN
        RAISE EXCEPTION 'Assignment is not active';
    END IF;
    
    -- ดึงข้อมูล
    SELECT rider_id, order_id INTO rider_uuid, order_uuid 
    FROM rider_assignments WHERE id = assignment_uuid;
    
    -- สร้างคำขอยกเลิก
    INSERT INTO cancellation_requests (
        assignment_id, 
        rider_id, 
        order_id, 
        reason, 
        description, 
        evidence_images, 
        emergency_level
    )
    VALUES (
        assignment_uuid,
        rider_uuid,
        order_uuid,
        reason,
        description,
        evidence_images,
        emergency_level
    )
    RETURNING id INTO request_id;
    
    -- ส่งการแจ้งเตือนไปยัง admin
    PERFORM send_notification(
        (SELECT id FROM users WHERE role = 'admin' LIMIT 1),
        'คำขอยกเลิกงานใหม่',
        'ไดเดอร์ขอยกเลิกงาน - ระดับความเร่งด่วน: ' || emergency_level,
        'system',
        jsonb_build_object(
            'request_id', request_id,
            'assignment_id', assignment_uuid,
            'order_id', order_uuid,
            'emergency_level', emergency_level
        )
    );
    
    -- ถ้าเป็นเหตุฉุกเฉินระดับ critical ให้ยกเลิกทันที
    IF emergency_level = 'critical' THEN
        PERFORM approve_cancellation_request(request_id, 'Auto-approved due to critical emergency');
    END IF;
    
    RETURN request_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.request_store_cancellation(reason text, cancellation_type text, order_uuid uuid, description text DEFAULT NULL::text, evidence_images text[] DEFAULT NULL::text[])
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    request_id UUID;
    store_uuid UUID;
    customer_uuid UUID;
BEGIN
    -- ตรวจสอบว่าเป็นร้านค้าของออเดอร์นี้
    SELECT store_id, customer_id INTO store_uuid, customer_uuid 
    FROM orders WHERE id = order_uuid;
    
    -- ตรวจสอบว่าเป็นเจ้าของร้าน
    IF NOT EXISTS (
        SELECT 1 FROM stores 
        WHERE id = store_uuid 
        AND owner_id = auth.uid()
    ) THEN
        RAISE EXCEPTION 'You are not authorized to cancel this order';
    END IF;
    
    -- ตรวจสอบว่าออเดอร์ยังไม่เสร็จสิ้น
    IF NOT EXISTS (
        SELECT 1 FROM orders 
        WHERE id = order_uuid 
        AND status IN ('pending', 'accepted', 'preparing')
    ) THEN
        RAISE EXCEPTION 'Order cannot be cancelled at this stage';
    END IF;
    
    -- สร้างคำขอยกเลิก
    INSERT INTO store_cancellation_requests (
        order_id, 
        store_id, 
        reason, 
        description, 
        evidence_images, 
        cancellation_type
    )
    VALUES (
        order_uuid,
        store_uuid,
        reason,
        description,
        evidence_images,
        cancellation_type
    )
    RETURNING id INTO request_id;
    
    -- ส่งการแจ้งเตือนไปยัง admin
    PERFORM send_notification(
        (SELECT id FROM users WHERE role = 'admin' LIMIT 1),
        'คำขอยกเลิกออเดอร์จากร้านค้า',
        'ร้านค้าขอยกเลิกออเดอร์ - ประเภท: ' || cancellation_type,
        'system',
        jsonb_build_object(
            'request_id', request_id,
            'order_id', order_uuid,
            'cancellation_type', cancellation_type
        )
    );
    
    -- ถ้าเป็นของหมดหรือปิดร้าน ให้ยกเลิกทันที
    IF cancellation_type IN ('out_of_stock', 'store_closed') THEN
        PERFORM approve_store_cancellation_request(request_id, 'Auto-approved due to ' || cancellation_type, NULL);
    END IF;
    
    RETURN request_id;
END;
$function$
;

create or replace view "public"."rider_active_work" as  SELECT ra.id AS assignment_id,
    ra.rider_id,
    ra.order_id,
    ra.status AS assignment_status,
    ra.assigned_at,
    ra.picked_up_at,
    ra.started_delivery_at,
    o.order_number,
    o.total_amount,
    o.delivery_fee,
    o.delivery_address,
    o.delivery_latitude,
    o.delivery_longitude,
    o.distance_km,
    s.name AS store_name,
    s.address AS store_address,
    s.latitude AS store_latitude,
    s.longitude AS store_longitude,
    u.full_name AS customer_name,
    u.phone AS customer_phone,
    u.line_id AS customer_line_id,
    (EXTRACT(epoch FROM (now() - ra.assigned_at)) / (60)::numeric) AS elapsed_minutes
   FROM (((public.rider_assignments ra
     JOIN public.orders o ON ((ra.order_id = o.id)))
     JOIN public.stores s ON ((o.store_id = s.id)))
     JOIN public.users u ON ((o.customer_id = u.id)))
  WHERE (ra.status = ANY (ARRAY['assigned'::text, 'picked_up'::text, 'delivering'::text]))
  ORDER BY ra.assigned_at;


create or replace view "public"."rider_bookings_view" as  SELECT rob.id AS booking_id,
    rob.rider_id,
    rob.order_id,
    rob.status AS booking_status,
    rob.priority,
    rob.booked_at,
    rob.expires_at,
    rob.assigned_at,
    rob.cancelled_at,
    rob.cancellation_reason,
    o.order_number,
    o.total_amount,
    o.delivery_fee,
    o.delivery_address,
    o.delivery_latitude,
    o.delivery_longitude,
    o.distance_km,
    o.status AS order_status,
    s.name AS store_name,
    s.address AS store_address,
    s.phone AS store_phone,
    s.latitude AS store_latitude,
    s.longitude AS store_longitude,
    u.full_name AS customer_name,
    u.phone AS customer_phone,
    u.line_id AS customer_line_id,
    r.full_name AS rider_name,
    r.phone AS rider_phone
   FROM (((((public.rider_order_bookings rob
     JOIN public.orders o ON ((rob.order_id = o.id)))
     JOIN public.stores s ON ((o.store_id = s.id)))
     JOIN public.users u ON ((o.customer_id = u.id)))
     JOIN public.riders rd ON ((rob.rider_id = rd.id)))
     JOIN public.users r ON ((rd.user_id = r.id)))
  ORDER BY rob.priority, rob.booked_at;


create or replace view "public"."rider_daily_stats" as  SELECT ra.rider_id,
    ((ra.assigned_at AT TIME ZONE 'Asia/Bangkok'::text))::date AS work_date,
    count(*) AS total_orders,
    count(
        CASE
            WHEN (ra.status = 'delivered'::text) THEN 1
            ELSE NULL::integer
        END) AS completed_orders,
    count(
        CASE
            WHEN (ra.status = 'cancelled'::text) THEN 1
            ELSE NULL::integer
        END) AS cancelled_orders,
    sum(
        CASE
            WHEN (ra.status = 'delivered'::text) THEN o.delivery_fee
            ELSE (0)::numeric
        END) AS total_earnings,
    sum(
        CASE
            WHEN (ra.status = 'delivered'::text) THEN o.total_amount
            ELSE (0)::numeric
        END) AS total_amount,
    sum(
        CASE
            WHEN (ra.status = 'delivered'::text) THEN o.distance_km
            ELSE (0)::numeric
        END) AS total_distance_km,
    avg(
        CASE
            WHEN (ra.completed_at IS NOT NULL) THEN (EXTRACT(epoch FROM (ra.completed_at - ra.assigned_at)) / (60)::numeric)
            ELSE NULL::numeric
        END) AS avg_delivery_time_minutes,
    count(
        CASE
            WHEN (o.discount_code IS NOT NULL) THEN 1
            ELSE NULL::integer
        END) AS deliveries_with_discount,
    (((count(
        CASE
            WHEN (o.discount_code IS NOT NULL) THEN 1
            ELSE NULL::integer
        END))::numeric * 100.0) / (count(*))::numeric) AS discount_usage_percentage,
    sum(
        CASE
            WHEN (o.discount_code IS NOT NULL) THEN o.discount_amount
            ELSE (0)::numeric
        END) AS total_discount_amount,
    NULL::text AS most_used_discount_code,
    NULL::text AS most_used_discount_count
   FROM (public.rider_assignments ra
     JOIN public.orders o ON ((ra.order_id = o.id)))
  GROUP BY ra.rider_id, (((ra.assigned_at AT TIME ZONE 'Asia/Bangkok'::text))::date)
  ORDER BY (((ra.assigned_at AT TIME ZONE 'Asia/Bangkok'::text))::date) DESC, (count(*)) DESC;


create or replace view "public"."rider_documents_report" as  SELECT r.id AS rider_id,
    u.full_name AS rider_name,
    u.email AS rider_email,
    u.phone AS rider_phone,
    u.line_id AS rider_line_id,
    r.vehicle_type,
    r.license_plate,
    r.vehicle_model,
    r.vehicle_color,
    r.driver_license_number,
    r.driver_license_expiry,
    r.driver_license_type,
    r.car_tax_expiry,
    r.insurance_expiry,
    r.insurance_company,
    r.documents_verified,
    r.verified_at,
    ( SELECT users.full_name
           FROM public.users
          WHERE (users.id = r.verified_by)) AS verified_by_name,
    count(rd.id) AS total_documents,
    count(
        CASE
            WHEN (rd.verified = true) THEN 1
            ELSE NULL::integer
        END) AS verified_documents,
    count(
        CASE
            WHEN (rd.verified = false) THEN 1
            ELSE NULL::integer
        END) AS pending_documents,
    max(rd.uploaded_at) AS last_document_upload
   FROM ((public.riders r
     JOIN public.users u ON ((r.user_id = u.id)))
     LEFT JOIN public.rider_documents rd ON ((r.id = rd.rider_id)))
  GROUP BY r.id, u.full_name, u.email, u.phone, u.line_id, r.vehicle_type, r.license_plate, r.vehicle_model, r.vehicle_color, r.driver_license_number, r.driver_license_expiry, r.driver_license_type, r.car_tax_expiry, r.insurance_expiry, r.insurance_company, r.documents_verified, r.verified_at, r.verified_by;


create or replace view "public"."rider_documents_view" as  SELECT rd.id AS document_id,
    rd.rider_id,
    rd.document_type,
    rd.file_url,
    rd.file_name,
    rd.file_size,
    rd.mime_type,
    rd.uploaded_at,
    rd.verified,
    rd.verified_by,
    rd.verified_at,
    rd.verification_notes,
    rd.created_at,
    rd.updated_at,
    u.full_name AS rider_name,
    u.email AS rider_email,
    u.phone AS rider_phone,
    r.vehicle_type,
    r.license_plate,
        CASE
            WHEN (rd.document_type = 'driver_license'::text) THEN 'ใบอนุญาตขับขี่'::text
            WHEN (rd.document_type = 'car_tax'::text) THEN 'เอกสารใบภาษีรถ'::text
            WHEN (rd.document_type = 'id_card'::text) THEN 'บัตรประจำตัวประชาชน'::text
            WHEN (rd.document_type = 'rider_application'::text) THEN 'เอกสารสมัครไรเดอร์'::text
            WHEN (rd.document_type = 'vehicle_photo'::text) THEN 'รูปถ่ายพาหนะ'::text
            WHEN (rd.document_type = 'license_plate'::text) THEN 'ภาพถ่ายป้ายทะเบียน'::text
            WHEN (rd.document_type = 'insurance'::text) THEN 'ใบประกันภัย'::text
            WHEN (rd.document_type = 'vehicle_registration'::text) THEN 'ใบจดทะเบียนรถ'::text
            ELSE rd.document_type
        END AS document_type_thai,
        CASE
            WHEN (rd.verified = true) THEN 'ผ่านการตรวจสอบ'::text
            WHEN ((rd.verified = false) AND (rd.uploaded_at IS NOT NULL)) THEN 'รอการตรวจสอบ'::text
            ELSE 'ยังไม่ได้อัปโหลด'::text
        END AS verification_status_thai
   FROM ((public.rider_documents rd
     JOIN public.riders r ON ((rd.rider_id = r.id)))
     JOIN public.users u ON ((r.user_id = u.id)))
  ORDER BY rd.uploaded_at DESC;


create or replace view "public"."rider_monthly_stats" as  SELECT ra.rider_id,
    (date_trunc('month'::text, COALESCE(ra.delivered_at, ra.completed_at, ra.updated_at)))::date AS work_month,
    EXTRACT(year FROM COALESCE(ra.delivered_at, ra.completed_at, ra.updated_at)) AS year,
    EXTRACT(month FROM COALESCE(ra.delivered_at, ra.completed_at, ra.updated_at)) AS month_number,
    to_char(COALESCE(ra.delivered_at, ra.completed_at, ra.updated_at), 'Month'::text) AS month_name,
    count(*) AS total_deliveries,
    sum(o.delivery_fee) AS total_earnings,
    avg(o.delivery_fee) AS average_delivery_fee,
    sum(o.distance_km) AS total_distance,
    avg(o.distance_km) AS average_distance,
    count(
        CASE
            WHEN (o.discount_code IS NOT NULL) THEN 1
            ELSE NULL::integer
        END) AS deliveries_with_discount,
        CASE
            WHEN (count(*) > 0) THEN (((count(
            CASE
                WHEN (o.discount_code IS NOT NULL) THEN 1
                ELSE NULL::integer
            END))::numeric * 100.0) / (count(*))::numeric)
            ELSE (0)::numeric
        END AS discount_usage_percentage,
    sum(
        CASE
            WHEN (o.discount_code IS NOT NULL) THEN o.discount_amount
            ELSE (0)::numeric
        END) AS total_discount_amount,
    NULL::text AS most_used_discount_code,
    NULL::text AS most_used_discount_count
   FROM (public.rider_assignments ra
     JOIN public.orders o ON ((ra.order_id = o.id)))
  WHERE ((ra.status = 'delivered'::text) AND (COALESCE(ra.delivered_at, ra.completed_at, ra.updated_at) IS NOT NULL))
  GROUP BY ra.rider_id, (date_trunc('month'::text, COALESCE(ra.delivered_at, ra.completed_at, ra.updated_at))), (EXTRACT(year FROM COALESCE(ra.delivered_at, ra.completed_at, ra.updated_at))), (EXTRACT(month FROM COALESCE(ra.delivered_at, ra.completed_at, ra.updated_at))), (to_char(COALESCE(ra.delivered_at, ra.completed_at, ra.updated_at), 'Month'::text))
  ORDER BY ((date_trunc('month'::text, COALESCE(ra.delivered_at, ra.completed_at, ra.updated_at)))::date) DESC, (count(*)) DESC;


create or replace view "public"."rider_performance_report" as  SELECT r.id AS rider_id,
    u.full_name AS rider_name,
    r.total_deliveries,
    r.total_earnings,
    r.rating,
    r.total_ratings,
    count(o.id) AS current_month_orders,
    sum(o.delivery_fee) AS current_month_earnings
   FROM ((public.riders r
     JOIN public.users u ON ((r.user_id = u.id)))
     LEFT JOIN public.orders o ON (((r.id = o.rider_id) AND (o.created_at >= date_trunc('month'::text, (CURRENT_DATE)::timestamp with time zone)) AND (o.status = 'delivered'::text))))
  GROUP BY r.id, u.full_name, r.total_deliveries, r.total_earnings, r.rating, r.total_ratings;


create or replace view "public"."rider_profile_view" as  SELECT r.id AS rider_id,
    r.user_id,
    r.vehicle_type,
    r.license_plate,
    r.vehicle_brand,
    r.vehicle_model,
    r.vehicle_color,
    r.current_location,
    r.is_available,
    r.total_deliveries,
    r.total_earnings,
    r.rating,
    r.total_ratings,
    r.documents_verified,
    r.driver_license_number,
    r.driver_license_expiry,
    r.car_tax_expiry,
    r.insurance_expiry,
    r.emergency_contact,
    r.emergency_phone,
    r.bank_account_name,
    r.bank_account_number,
    r.bank_name,
    r.qr_code_url,
    r.created_at,
    r.updated_at,
    u.full_name,
    u.email,
    u.phone,
    u.line_id,
    u.address,
    u.role,
    u.is_active,
    u.google_picture,
    u.avatar_url,
    latest_order.discount_code,
    latest_order.discount_description,
    latest_order.discount_amount,
    discount_stats.total_orders_with_discount,
    discount_stats.total_discount_amount,
    discount_stats.discount_usage_percentage
   FROM (((public.riders r
     JOIN public.users u ON ((r.user_id = u.id)))
     LEFT JOIN ( SELECT DISTINCT ON (o.rider_id) o.rider_id,
            o.discount_code,
            o.discount_description,
            o.discount_amount
           FROM public.orders o
          WHERE ((o.rider_id IS NOT NULL) AND (o.discount_code IS NOT NULL))
          ORDER BY o.rider_id, o.created_at DESC) latest_order ON ((r.id = latest_order.rider_id)))
     LEFT JOIN ( SELECT o.rider_id,
            count(
                CASE
                    WHEN (o.discount_code IS NOT NULL) THEN 1
                    ELSE NULL::integer
                END) AS total_orders_with_discount,
            sum(
                CASE
                    WHEN (o.discount_code IS NOT NULL) THEN o.discount_amount
                    ELSE (0)::numeric
                END) AS total_discount_amount,
            (((count(
                CASE
                    WHEN (o.discount_code IS NOT NULL) THEN 1
                    ELSE NULL::integer
                END))::numeric * 100.0) / (count(*))::numeric) AS discount_usage_percentage
           FROM public.orders o
          WHERE (o.rider_id IS NOT NULL)
          GROUP BY o.rider_id) discount_stats ON ((r.id = discount_stats.rider_id)))
  ORDER BY r.rating DESC, r.total_deliveries DESC;


create or replace view "public"."rider_response_statistics" as  SELECT rpv.rider_id,
    rpv.full_name,
    count(cm.id) AS total_messages,
    count(
        CASE
            WHEN (cm.sender_type = 'rider'::text) THEN 1
            ELSE NULL::integer
        END) AS rider_messages,
    count(
        CASE
            WHEN (cm.sender_type = 'customer'::text) THEN 1
            ELSE NULL::integer
        END) AS customer_messages,
    count(
        CASE
            WHEN (cm.sender_type = 'store'::text) THEN 1
            ELSE NULL::integer
        END) AS store_messages,
    NULL::text AS avg_response_time_seconds
   FROM (public.rider_profile_view rpv
     LEFT JOIN public.chat_messages cm ON (((rpv.rider_id = cm.sender_id) AND (cm.sender_type = 'rider'::text))))
  GROUP BY rpv.rider_id, rpv.full_name
  ORDER BY (count(cm.id)) DESC;


create or replace view "public"."rider_response_time_analysis" as  WITH message_sequence AS (
         SELECT cm.order_id,
            cm.sender_type,
            cm.created_at,
            lag(cm.created_at) OVER (PARTITION BY cm.order_id ORDER BY cm.created_at) AS prev_message_time,
            lag(cm.sender_type) OVER (PARTITION BY cm.order_id ORDER BY cm.created_at) AS prev_sender_type
           FROM public.chat_messages cm
        ), response_times AS (
         SELECT message_sequence.order_id,
            message_sequence.sender_type,
            message_sequence.created_at,
                CASE
                    WHEN ((message_sequence.sender_type = 'rider'::text) AND (message_sequence.prev_sender_type = 'customer'::text)) THEN (EXTRACT(epoch FROM (message_sequence.created_at - message_sequence.prev_message_time)) / (60)::numeric)
                    ELSE NULL::numeric
                END AS response_time_minutes
           FROM message_sequence
          WHERE ((message_sequence.sender_type = 'rider'::text) AND (message_sequence.prev_sender_type = 'customer'::text))
        ), rider_orders AS (
         SELECT o.rider_id,
            u.full_name AS rider_name,
            u.phone AS rider_phone,
            o.id AS order_id
           FROM (public.orders o
             JOIN public.users u ON ((o.rider_id = u.id)))
          WHERE (o.rider_id IS NOT NULL)
        )
 SELECT ro.rider_id,
    ro.rider_name,
    ro.rider_phone,
    count(DISTINCT ro.order_id) AS total_orders_with_chat,
    count(DISTINCT rt.order_id) AS orders_with_response_time,
    count(rt.response_time_minutes) AS total_response_times,
    avg(rt.response_time_minutes) AS avg_response_time_minutes,
    min(rt.response_time_minutes) AS min_response_time_minutes,
    max(rt.response_time_minutes) AS max_response_time_minutes,
    percentile_cont((0.5)::double precision) WITHIN GROUP (ORDER BY ((rt.response_time_minutes)::double precision)) AS median_response_time_minutes
   FROM (rider_orders ro
     LEFT JOIN response_times rt ON ((ro.order_id = rt.order_id)))
  GROUP BY ro.rider_id, ro.rider_name, ro.rider_phone;


create or replace view "public"."rider_review_stats" as  SELECT r.id AS rider_id,
    r.user_id,
    u.full_name AS rider_name,
    u.phone AS rider_phone,
    r.rating AS average_rating,
    r.total_ratings AS total_reviews,
    count(
        CASE
            WHEN (rr.rating = (5)::numeric) THEN 1
            ELSE NULL::integer
        END) AS five_star_count,
    count(
        CASE
            WHEN (rr.rating = (4)::numeric) THEN 1
            ELSE NULL::integer
        END) AS four_star_count,
    count(
        CASE
            WHEN (rr.rating = (3)::numeric) THEN 1
            ELSE NULL::integer
        END) AS three_star_count,
    count(
        CASE
            WHEN (rr.rating = (2)::numeric) THEN 1
            ELSE NULL::integer
        END) AS two_star_count,
    count(
        CASE
            WHEN (rr.rating = (1)::numeric) THEN 1
            ELSE NULL::integer
        END) AS one_star_count,
    count(
        CASE
            WHEN ((rr.review_text IS NOT NULL) AND (rr.review_text <> ''::text)) THEN 1
            ELSE NULL::integer
        END) AS reviews_with_text,
    count(
        CASE
            WHEN ((rr.review_images IS NOT NULL) AND (array_length(rr.review_images, 1) > 0)) THEN 1
            ELSE NULL::integer
        END) AS reviews_with_images,
    max(rr.created_at) AS last_review_date
   FROM ((public.riders r
     JOIN public.users u ON ((r.user_id = u.id)))
     LEFT JOIN public.rider_reviews rr ON ((r.id = rr.rider_id)))
  GROUP BY r.id, r.user_id, u.full_name, u.phone, r.rating, r.total_ratings;


create or replace view "public"."rider_work_history" as  SELECT ra.id AS assignment_id,
    ra.rider_id,
    ra.order_id,
    ra.status AS assignment_status,
    ra.assigned_at,
    ra.picked_up_at,
    ra.started_delivery_at,
    ra.completed_at,
    ra.cancelled_at,
    ra.cancellation_reason,
    ra.created_at,
    ra.updated_at,
    o.order_number,
    o.total_amount,
    o.subtotal,
    o.delivery_fee,
    o.payment_method,
    o.payment_status,
    o.delivery_address,
    o.delivery_latitude,
    o.delivery_longitude,
    o.estimated_delivery_time,
    o.actual_delivery_time,
    o.special_instructions,
    o.cancellation_reason AS order_cancellation_reason,
    o.cancelled_by,
    o.cancelled_at AS order_cancelled_at,
    o.distance_km,
    o.discount_code,
    o.discount_description,
    o.discount_amount,
    s.name AS store_name,
    s.address AS store_address,
    s.phone AS store_phone,
    s.latitude AS store_latitude,
    s.longitude AS store_longitude,
    u.full_name AS customer_name,
    u.phone AS customer_phone,
    u.email AS customer_email,
    u.line_id AS customer_line_id,
    dc.id AS discount_code_id,
    dc.code AS discount_code_full,
    dc.name AS discount_code_name,
    dc.discount_type,
    dc.discount_value,
    dc.minimum_order_amount,
    dc.maximum_discount_amount,
    dc.usage_limit,
    dc.used_count,
    dc.is_active AS discount_code_active,
    dc.valid_from AS discount_valid_from,
    dc.valid_until AS discount_valid_until,
    od.applied_at AS discount_applied_at,
    od.applied_by AS discount_applied_by
   FROM (((((public.rider_assignments ra
     JOIN public.orders o ON ((ra.order_id = o.id)))
     JOIN public.stores s ON ((o.store_id = s.id)))
     JOIN public.users u ON ((o.customer_id = u.id)))
     LEFT JOIN public.discount_codes dc ON ((o.discount_code_id = dc.id)))
     LEFT JOIN public.order_discounts od ON ((o.id = od.order_id)))
  WHERE (ra.status = ANY (ARRAY['delivered'::text, 'cancelled'::text]))
  ORDER BY ra.assigned_at DESC;


CREATE OR REPLACE FUNCTION public.search_delivery_notes(p_user_id uuid, p_search_term text, p_limit integer DEFAULT 10)
 RETURNS TABLE(id uuid, note_title text, note_content text, is_favorite boolean, usage_count integer, last_used_at timestamp with time zone, created_at timestamp with time zone, relevance_score integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        dn.id,
        dn.note_title,
        dn.note_content,
        dn.is_favorite,
        dn.usage_count,
        dn.last_used_at,
        dn.created_at,
        CASE 
            WHEN dn.note_title ILIKE '%' || p_search_term || '%' THEN 3
            WHEN dn.note_content ILIKE '%' || p_search_term || '%' THEN 2
            ELSE 1
        END as relevance_score
    FROM public.delivery_notes dn
    WHERE dn.user_id = p_user_id
    AND (
        dn.note_title ILIKE '%' || p_search_term || '%' 
        OR dn.note_content ILIKE '%' || p_search_term || '%'
    )
    ORDER BY 
        relevance_score DESC,
        dn.is_favorite DESC,
        dn.usage_count DESC,
        dn.last_used_at DESC NULLS LAST
    LIMIT p_limit;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.send_expiring_document_notifications()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    expiring_doc RECORD;
BEGIN
    FOR expiring_doc IN 
        SELECT * FROM check_expiring_documents()
    LOOP
        -- ส่งการแจ้งเตือนไดเดอร์
        PERFORM send_notification(
            (SELECT user_id FROM riders WHERE id = expiring_doc.rider_id),
            'เอกสารใกล้หมดอายุ',
            'เอกสาร ' || expiring_doc.document_type || ' จะหมดอายุใน ' || expiring_doc.days_until_expiry || ' วัน กรุณาอัปเดตเอกสาร',
            'system',
            jsonb_build_object(
                'document_type', expiring_doc.document_type,
                'expiry_date', expiring_doc.expiry_date,
                'days_until_expiry', expiring_doc.days_until_expiry
            )
        );
        
        -- ส่งการแจ้งเตือนแอดมิน
        PERFORM send_notification(
            (SELECT id FROM users WHERE role = 'admin' LIMIT 1),
            'เอกสารไดเดอร์ใกล้หมดอายุ',
            'ไดเดอร์ ID: ' || expiring_doc.rider_id || ' เอกสาร ' || expiring_doc.document_type || ' หมดอายุใน ' || expiring_doc.days_until_expiry || ' วัน',
            'system',
            jsonb_build_object(
                'rider_id', expiring_doc.rider_id,
                'document_type', expiring_doc.document_type,
                'expiry_date', expiring_doc.expiry_date
            )
        );
    END LOOP;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.send_notification(p_target_user_id uuid, p_notification_title text, p_notification_message text, p_notification_type text, p_notification_data jsonb DEFAULT NULL::jsonb)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    notification_id UUID;
    existing_notification_id UUID;
BEGIN
    -- ตรวจสอบว่ามีการแจ้งเตือนซ้ำภายใน 5 นาที
    SELECT id INTO existing_notification_id
    FROM notifications 
    WHERE user_id = p_target_user_id
      AND title = p_notification_title
      AND message = p_notification_message
      AND type = p_notification_type
      AND created_at > NOW() - INTERVAL '5 minutes'
    LIMIT 1;

    IF existing_notification_id IS NOT NULL THEN
        RAISE NOTICE 'ข้ามการแจ้งเตือนที่ซ้ำกัน: %', existing_notification_id;
        RETURN existing_notification_id;
    END IF;

    IF p_notification_data IS NOT NULL THEN
        SELECT id INTO existing_notification_id
        FROM notifications 
        WHERE user_id = p_target_user_id
          AND type = p_notification_type
          AND data = p_notification_data
          AND created_at > NOW() - INTERVAL '5 minutes'
        LIMIT 1;

        IF existing_notification_id IS NOT NULL THEN
            RAISE NOTICE 'ข้ามการแจ้งเตือนที่มี data เดียวกัน: %', existing_notification_id;
            RETURN existing_notification_id;
        END IF;
    END IF;

    INSERT INTO notifications (user_id, title, message, type, data)
    VALUES (p_target_user_id, p_notification_title, p_notification_message, p_notification_type, p_notification_data)
    RETURNING id INTO notification_id;

    RAISE NOTICE 'สร้างการแจ้งเตือนใหม่: % สำหรับผู้ใช้: %', notification_id, p_target_user_id;

    RETURN notification_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'เกิดข้อผิดพลาดในการสร้างการแจ้งเตือน: %', SQLERRM;
        RETURN NULL;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.send_notification_to_all_riders(p_title text, p_body text, p_data jsonb DEFAULT '{}'::jsonb)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    result JSONB;
    fcm_token_record RECORD;
    success_count INTEGER := 0;
    error_count INTEGER := 0;
BEGIN
    -- ส่งการแจ้งเตือนไปยังไรเดอร์ทุกคนที่มี FCM Token
    FOR fcm_token_record IN 
        SELECT fcm_token FROM rider_fcm_tokens WHERE is_active = true
    LOOP
        BEGIN
            -- เรียกใช้ Supabase Edge Function หรือ Firebase Cloud Functions
            -- ตัวอย่างการส่งผ่าน HTTP request
            PERFORM net.http_post(
                url := 'https://your-project.supabase.co/functions/v1/send-fcm-notification',
                headers := jsonb_build_object(
                    'Content-Type', 'application/json',
                    'Authorization', 'Bearer ' || current_setting('app.settings.jwt_secret')
                ),
                body := jsonb_build_object(
                    'fcm_token', fcm_token_record.fcm_token,
                    'title', p_title,
                    'body', p_body,
                    'data', p_data
                )
            );
            success_count := success_count + 1;
        EXCEPTION WHEN OTHERS THEN
            error_count := error_count + 1;
        END;
    END LOOP;
    
    result := jsonb_build_object(
        'success_count', success_count,
        'error_count', error_count,
        'total_sent', success_count + error_count
    );
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.send_notification_to_rider(p_rider_id uuid, p_title text, p_body text, p_data jsonb DEFAULT '{}'::jsonb)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    result JSONB;
    fcm_token_record RECORD;
BEGIN
    -- หา FCM Token ของไรเดอร์
    SELECT fcm_token INTO fcm_token_record
    FROM rider_fcm_tokens 
    WHERE rider_id = p_rider_id AND is_active = true
    LIMIT 1;
    
    IF fcm_token_record.fcm_token IS NULL THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'No active FCM token found for rider'
        );
    END IF;
    
    BEGIN
        -- เรียกใช้ Supabase Edge Function หรือ Firebase Cloud Functions
        PERFORM net.http_post(
            url := 'https://your-project.supabase.co/functions/v1/send-fcm-notification',
            headers := jsonb_build_object(
                'Content-Type', 'application/json',
                'Authorization', 'Bearer ' || current_setting('app.settings.jwt_secret')
            ),
            body := jsonb_build_object(
                'fcm_token', fcm_token_record.fcm_token,
                'title', p_title,
                'body', p_body,
                'data', p_data
            )
        );
        
        result := jsonb_build_object(
            'success', true,
            'message', 'Notification sent successfully'
        );
    EXCEPTION WHEN OTHERS THEN
        result := jsonb_build_object(
            'success', false,
            'error', SQLERRM
        );
    END;
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.set_favorite_delivery_note(target_note_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  -- ตั้งหมายเหตุทั้งหมดเป็น false ก่อน
  UPDATE delivery_notes 
  SET is_favorite = false 
  WHERE user_id = auth.uid();
  
  -- ตั้งหมายเหตุที่เลือกเป็น true
  UPDATE delivery_notes 
  SET is_favorite = true 
  WHERE id = target_note_id 
    AND user_id = auth.uid();
    
  -- ตรวจสอบว่ามีการอัปเดตหรือไม่
  IF NOT FOUND THEN
    RAISE EXCEPTION 'ไม่พบหมายเหตุที่ระบุหรือไม่มีสิทธิ์เข้าถึง';
  END IF;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.set_preorder_fee_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$function$
;

create or replace view "public"."small_stores_view" as  SELECT s.id,
    s.owner_id,
    s.name,
    s.description,
    s.address,
    s.phone,
    s.email,
    s.opening_hours,
    s.is_active,
    s.is_open,
    s.is_suspended,
    s.suspension_reason,
    s.suspended_by,
    s.suspended_at,
    s.auto_accept_orders,
    s.logo_url,
    s.banner_url,
    s.latitude,
    s.longitude,
    s.delivery_radius,
    s.minimum_order,
    s.created_at,
    s.updated_at,
    s.store_type_id,
    s.line_id,
    s.minimum_order_amount,
    s.phone_number,
    s.is_auto_open,
    COALESCE(order_stats.total_orders_30d, (0)::bigint) AS total_orders_30d,
    COALESCE(order_stats.total_revenue_30d, (0)::numeric) AS total_revenue_30d,
    COALESCE(order_stats.total_orders_7d, (0)::bigint) AS total_orders_7d,
    COALESCE(order_stats.total_revenue_7d, (0)::numeric) AS total_revenue_7d,
    COALESCE(order_stats.total_orders_all, (0)::bigint) AS total_orders_all,
    COALESCE(order_stats.total_revenue_all, (0)::numeric) AS total_revenue_all,
    order_stats.last_order_date,
        CASE
            WHEN (order_stats.last_order_date IS NULL) THEN NULL::integer
            ELSE (CURRENT_DATE - (order_stats.last_order_date)::date)
        END AS days_since_last_order,
    sc.name AS store_type_name,
    u.full_name AS owner_name,
    u.email AS owner_email,
    u.phone AS owner_phone,
        CASE
            WHEN (COALESCE(order_stats.total_orders_30d, (0)::bigint) < 10) THEN 'low_orders'::text
            WHEN (COALESCE(order_stats.total_revenue_30d, (0)::numeric) < (5000)::numeric) THEN 'low_revenue'::text
            WHEN (order_stats.last_order_date < (CURRENT_DATE - '14 days'::interval)) THEN 'inactive'::text
            ELSE 'other'::text
        END AS small_store_reason
   FROM (((public.stores s
     LEFT JOIN public.store_categories sc ON ((s.store_type_id = sc.id)))
     LEFT JOIN public.users u ON ((s.owner_id = u.id)))
     LEFT JOIN ( SELECT orders.store_id,
            count(
                CASE
                    WHEN ((orders.created_at >= (CURRENT_DATE - '30 days'::interval)) AND (orders.status = 'delivered'::text)) THEN 1
                    ELSE NULL::integer
                END) AS total_orders_30d,
            COALESCE(sum(
                CASE
                    WHEN ((orders.created_at >= (CURRENT_DATE - '30 days'::interval)) AND (orders.status = 'delivered'::text)) THEN orders.total_amount
                    ELSE NULL::numeric
                END), (0)::numeric) AS total_revenue_30d,
            count(
                CASE
                    WHEN ((orders.created_at >= (CURRENT_DATE - '7 days'::interval)) AND (orders.status = 'delivered'::text)) THEN 1
                    ELSE NULL::integer
                END) AS total_orders_7d,
            COALESCE(sum(
                CASE
                    WHEN ((orders.created_at >= (CURRENT_DATE - '7 days'::interval)) AND (orders.status = 'delivered'::text)) THEN orders.total_amount
                    ELSE NULL::numeric
                END), (0)::numeric) AS total_revenue_7d,
            count(
                CASE
                    WHEN (orders.status = 'delivered'::text) THEN 1
                    ELSE NULL::integer
                END) AS total_orders_all,
            COALESCE(sum(
                CASE
                    WHEN (orders.status = 'delivered'::text) THEN orders.total_amount
                    ELSE NULL::numeric
                END), (0)::numeric) AS total_revenue_all,
            max(
                CASE
                    WHEN (orders.status = 'delivered'::text) THEN orders.created_at
                    ELSE NULL::timestamp with time zone
                END) AS last_order_date
           FROM public.orders
          GROUP BY orders.store_id) order_stats ON ((s.id = order_stats.store_id)))
  WHERE ((s.is_active = true) AND (s.is_suspended = false) AND ((COALESCE(order_stats.total_orders_30d, (0)::bigint) < 10) OR (COALESCE(order_stats.total_revenue_30d, (0)::numeric) < (5000)::numeric) OR (order_stats.last_order_date < (CURRENT_DATE - '14 days'::interval)) OR (order_stats.last_order_date IS NULL)))
  ORDER BY COALESCE(order_stats.total_orders_30d, (0)::bigint), COALESCE(order_stats.total_revenue_30d, (0)::numeric), order_stats.last_order_date NULLS FIRST;


create or replace view "public"."store_fcm_tokens_view" as  SELECT fs.id,
    fs.store_id,
    s.name AS store_name,
    fs.user_id,
    u.full_name AS user_name,
    u.email,
    fs.fcm_token,
    fs.device_name,
    fs.platform,
    fs.app_version,
    fs.is_active,
    fs.last_used_at,
    fs.created_at,
    fs.updated_at
   FROM ((public.fcm_store fs
     JOIN public.stores s ON ((fs.store_id = s.id)))
     JOIN public.users u ON ((fs.user_id = u.id)))
  WHERE (fs.is_active = true)
  ORDER BY fs.last_used_at DESC;


create or replace view "public"."store_issues_report" as  SELECT sr.id AS report_id,
    sr.store_id,
    s.name AS store_name,
    sr.report_type,
    sr.title,
    sr.description,
    sr.severity_level,
    sr.status,
    sr.created_at AS reported_at,
    sr.handled_at,
    ( SELECT users.full_name
           FROM public.users
          WHERE (users.id = sr.reporter_id)) AS reporter_name,
    ( SELECT users.email
           FROM public.users
          WHERE (users.id = sr.reporter_id)) AS reporter_email,
    ( SELECT users.full_name
           FROM public.users
          WHERE (users.id = sr.handled_by)) AS handled_by_name,
    sr.admin_notes,
    ( SELECT users.full_name
           FROM public.users
          WHERE (users.id = s.owner_id)) AS store_owner_name,
    ( SELECT users.email
           FROM public.users
          WHERE (users.id = s.owner_id)) AS store_owner_email
   FROM (public.store_reports sr
     JOIN public.stores s ON ((sr.store_id = s.id)))
  ORDER BY sr.created_at DESC;


create or replace view "public"."store_payment_report" as  SELECT s.id AS store_id,
    s.name AS store_name,
    count(o.id) AS total_orders,
    count(
        CASE
            WHEN (o.payment_method = 'cash'::text) THEN 1
            ELSE NULL::integer
        END) AS cash_orders,
    count(
        CASE
            WHEN (o.payment_method = 'bank_transfer'::text) THEN 1
            ELSE NULL::integer
        END) AS transfer_orders,
    sum(
        CASE
            WHEN (o.payment_status = 'paid'::text) THEN o.total_amount
            ELSE (0)::numeric
        END) AS total_paid_amount,
    sum(
        CASE
            WHEN ((o.payment_method = 'cash'::text) AND (o.payment_status = 'paid'::text)) THEN o.total_amount
            ELSE (0)::numeric
        END) AS cash_paid_amount,
    sum(
        CASE
            WHEN ((o.payment_method = 'bank_transfer'::text) AND (o.payment_status = 'paid'::text)) THEN o.total_amount
            ELSE (0)::numeric
        END) AS transfer_paid_amount,
    count(
        CASE
            WHEN (o.payment_status = 'pending'::text) THEN 1
            ELSE NULL::integer
        END) AS pending_payments,
    count(
        CASE
            WHEN (o.payment_status = 'cancelled'::text) THEN 1
            ELSE NULL::integer
        END) AS cancelled_payments
   FROM (public.stores s
     LEFT JOIN public.orders o ON ((s.id = o.store_id)))
  GROUP BY s.id, s.name
  ORDER BY (sum(
        CASE
            WHEN (o.payment_status = 'paid'::text) THEN o.total_amount
            ELSE (0)::numeric
        END)) DESC;


create or replace view "public"."store_review_statistics" as  SELECT s.id AS store_id,
    s.name AS store_name,
    s.description AS store_description,
    s.logo_url AS store_image_url,
    count(rev.id) AS total_reviews,
    COALESCE(avg(rev.rating), (0)::numeric) AS average_rating,
    count(
        CASE
            WHEN (rev.rating = (5)::numeric) THEN 1
            ELSE NULL::integer
        END) AS five_star_count,
    count(
        CASE
            WHEN (rev.rating = (4)::numeric) THEN 1
            ELSE NULL::integer
        END) AS four_star_count,
    count(
        CASE
            WHEN (rev.rating = (3)::numeric) THEN 1
            ELSE NULL::integer
        END) AS three_star_count,
    count(
        CASE
            WHEN (rev.rating = (2)::numeric) THEN 1
            ELSE NULL::integer
        END) AS two_star_count,
    count(
        CASE
            WHEN (rev.rating = (1)::numeric) THEN 1
            ELSE NULL::integer
        END) AS one_star_count,
        CASE
            WHEN (count(rev.id) > 0) THEN round((((count(
            CASE
                WHEN (rev.rating >= (4)::numeric) THEN 1
                ELSE NULL::integer
            END))::numeric / (count(rev.id))::numeric) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS positive_review_percentage
   FROM (public.stores s
     LEFT JOIN public.order_reviews rev ON ((s.id = rev.store_id)))
  GROUP BY s.id, s.name, s.description, s.logo_url;


create or replace view "public"."store_sales_report" as  SELECT s.id AS store_id,
    s.name AS store_name,
    count(
        CASE
            WHEN (o.status <> ALL (ARRAY['cancelled'::text, 'rejected'::text])) THEN 1
            ELSE NULL::integer
        END) AS total_orders,
    COALESCE(sum(
        CASE
            WHEN (o.status <> ALL (ARRAY['cancelled'::text, 'rejected'::text])) THEN o.subtotal
            ELSE NULL::numeric
        END), (0)::numeric) AS total_sales,
    avg(
        CASE
            WHEN (o.status <> ALL (ARRAY['cancelled'::text, 'rejected'::text])) THEN o.subtotal
            ELSE NULL::numeric
        END) AS avg_order_value,
    count(
        CASE
            WHEN (o.status = 'delivered'::text) THEN 1
            ELSE NULL::integer
        END) AS completed_orders,
    count(
        CASE
            WHEN (o.status = 'cancelled'::text) THEN 1
            ELSE NULL::integer
        END) AS cancelled_orders,
    count(
        CASE
            WHEN (o.status = 'rejected'::text) THEN 1
            ELSE NULL::integer
        END) AS rejected_orders,
    count(
        CASE
            WHEN (o.status = ANY (ARRAY['pending'::text, 'accepted'::text, 'preparing'::text, 'ready'::text])) THEN 1
            ELSE NULL::integer
        END) AS pending_orders,
    count(
        CASE
            WHEN (o.status = ANY (ARRAY['assigned'::text, 'picked_up'::text, 'delivering'::text])) THEN 1
            ELSE NULL::integer
        END) AS in_transit_orders,
    COALESCE(sum(
        CASE
            WHEN ((o.payment_method = 'cash'::text) AND (o.status <> ALL (ARRAY['cancelled'::text, 'rejected'::text]))) THEN o.subtotal
            ELSE NULL::numeric
        END), (0)::numeric) AS cash_revenue,
    COALESCE(sum(
        CASE
            WHEN ((o.payment_method = 'bank_transfer'::text) AND (o.status <> ALL (ARRAY['cancelled'::text, 'rejected'::text]))) THEN o.subtotal
            ELSE NULL::numeric
        END), (0)::numeric) AS transfer_revenue,
    count(
        CASE
            WHEN ((o.payment_method = 'cash'::text) AND (o.status <> ALL (ARRAY['cancelled'::text, 'rejected'::text]))) THEN 1
            ELSE NULL::integer
        END) AS cash_orders,
    count(
        CASE
            WHEN ((o.payment_method = 'bank_transfer'::text) AND (o.status <> ALL (ARRAY['cancelled'::text, 'rejected'::text]))) THEN 1
            ELSE NULL::integer
        END) AS transfer_orders
   FROM (public.stores s
     LEFT JOIN public.orders o ON ((s.id = o.store_id)))
  GROUP BY s.id, s.name;


create or replace view "public"."store_suspension_history_view" as  SELECT ssh.id,
    ssh.store_id,
    s.name AS store_name,
    ssh.action,
    ssh.reason,
    ssh.admin_notes,
    ssh.suspended_at,
    ssh.unsuspended_at,
    ( SELECT users.full_name
           FROM public.users
          WHERE (users.id = ssh.suspended_by)) AS suspended_by_name,
    ( SELECT users.full_name
           FROM public.users
          WHERE (users.id = ssh.unsuspended_by)) AS unsuspended_by_name,
    ( SELECT users.full_name
           FROM public.users
          WHERE (users.id = s.owner_id)) AS store_owner_name,
        CASE
            WHEN ((ssh.action = 'suspended'::text) AND (ssh.unsuspended_at IS NULL)) THEN 'Currently Suspended'::text
            WHEN ((ssh.action = 'suspended'::text) AND (ssh.unsuspended_at IS NOT NULL)) THEN 'Previously Suspended'::text
            WHEN (ssh.action = 'unsuspended'::text) THEN 'Reopened'::text
            ELSE NULL::text
        END AS suspension_status,
        CASE
            WHEN (ssh.unsuspended_at IS NOT NULL) THEN (EXTRACT(epoch FROM (ssh.unsuspended_at - ssh.suspended_at)) / (86400)::numeric)
            ELSE (EXTRACT(epoch FROM (now() - ssh.suspended_at)) / (86400)::numeric)
        END AS suspension_duration_days
   FROM (public.store_suspension_history ssh
     JOIN public.stores s ON ((ssh.store_id = s.id)))
  ORDER BY ssh.suspended_at DESC;


create or replace view "public"."store_suspension_report" as  SELECT s.id AS store_id,
    s.name AS store_name,
    s.is_suspended,
    s.suspension_reason,
    s.suspended_at,
    ( SELECT users.full_name
           FROM public.users
          WHERE (users.id = s.suspended_by)) AS suspended_by_name,
    ( SELECT users.full_name
           FROM public.users
          WHERE (users.id = s.owner_id)) AS owner_name,
    ( SELECT users.email
           FROM public.users
          WHERE (users.id = s.owner_id)) AS owner_email,
    ( SELECT users.phone
           FROM public.users
          WHERE (users.id = s.owner_id)) AS owner_phone,
    count(sr.id) AS total_reports,
    count(
        CASE
            WHEN (sr.severity_level = 'critical'::text) THEN 1
            ELSE NULL::integer
        END) AS critical_reports,
    count(
        CASE
            WHEN (sr.severity_level = 'high'::text) THEN 1
            ELSE NULL::integer
        END) AS high_reports,
    count(
        CASE
            WHEN (sr.status = 'pending'::text) THEN 1
            ELSE NULL::integer
        END) AS pending_reports,
    max(sr.created_at) AS last_report_date
   FROM (public.stores s
     LEFT JOIN public.store_reports sr ON ((s.id = sr.store_id)))
  GROUP BY s.id, s.name, s.is_suspended, s.suspension_reason, s.suspended_at, s.suspended_by, s.owner_id
  ORDER BY s.suspended_at DESC NULLS LAST;


CREATE OR REPLACE FUNCTION public.suspend_store(store_uuid uuid, suspension_reason_param text, suspended_by_user_id uuid DEFAULT NULL::uuid, admin_notes_param text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    store_info RECORD;
    active_orders_count INTEGER;
BEGIN
    -- ตรวจสอบว่าเป็น admin
    IF NOT EXISTS (SELECT 1 FROM users WHERE id = suspended_by_user_id AND role = 'admin') THEN
        RAISE EXCEPTION 'Only admin can suspend stores';
    END IF;
    
    -- ดึงข้อมูลร้านค้า
    SELECT * INTO store_info FROM stores WHERE id = store_uuid;
    
    -- ตรวจสอบว่าร้านค้ายังไม่ถูกระงับ
    IF store_info.is_suspended THEN
        RAISE EXCEPTION 'Store is already suspended';
    END IF;
    
    -- นับจำนวนออเดอร์ที่ยังไม่เสร็จสิ้น
    SELECT COUNT(*) INTO active_orders_count
    FROM orders 
    WHERE store_id = store_uuid 
    AND status IN ('pending', 'accepted', 'preparing', 'ready');
    
    -- อัปเดตสถานะร้านค้า
    UPDATE stores 
    SET 
        is_suspended = true,
        suspension_reason = suspension_reason_param,
        suspended_by = suspended_by_user_id,
        suspended_at = NOW(),
        is_open = false, -- ปิดร้านอัตโนมัติเมื่อถูกระงับ
        updated_at = NOW()
    WHERE id = store_uuid;
    
    -- เพิ่มประวัติการระงับ
    INSERT INTO store_suspension_history (
        store_id,
        action,
        reason,
        admin_notes,
        suspended_by
    )
    VALUES (
        store_uuid,
        'suspended',
        suspension_reason_param,
        admin_notes_param,
        suspended_by_user_id
    );
    
    -- ยกเลิกออเดอร์ที่ยังไม่เสร็จสิ้น
    IF active_orders_count > 0 THEN
        UPDATE orders 
        SET 
            status = 'cancelled',
            updated_at = NOW()
        WHERE store_id = store_uuid 
        AND status IN ('pending', 'accepted', 'preparing', 'ready');
        
        -- เพิ่มประวัติการยกเลิก
        INSERT INTO order_status_history (order_id, status, updated_by, notes)
        SELECT 
            id, 
            'cancelled', 
            suspended_by_user_id,
            'Store suspended by admin: ' || suspension_reason_param
        FROM orders 
        WHERE store_id = store_uuid 
        AND status = 'cancelled';
        
        -- แจ้งเตือนลูกค้า
        PERFORM send_notification(
            customer_id,
            'ร้านค้าถูกระงับ',
            'ร้านค้าที่คุณสั่งซื้อถูกระงับโดยผู้ดูแลระบบ ออเดอร์ของคุณถูกยกเลิก',
            'order_update',
            jsonb_build_object('order_id', id, 'reason', 'Store suspended')
        )
        FROM orders 
        WHERE store_id = store_uuid 
        AND status = 'cancelled';
    END IF;
    
    -- ส่งการแจ้งเตือนเจ้าของร้าน
    PERFORM send_notification(
        store_info.owner_id,
        'ร้านค้าถูกระงับ',
        'ร้านค้าของคุณถูกระงับโดยผู้ดูแลระบบ เหตุผล: ' || suspension_reason_param,
        'system',
        jsonb_build_object(
            'store_id', store_uuid,
            'reason', suspension_reason_param,
            'admin_notes', admin_notes_param
        )
    );
    
    -- ส่งการแจ้งเตือนไดเดอร์ที่เกี่ยวข้อง
    PERFORM send_notification(
        (SELECT user_id FROM riders WHERE id = rider_id),
        'ร้านค้าถูกระงับ',
        'ร้านค้าที่คุณรับงานถูกระงับ งานทั้งหมดถูกยกเลิก',
        'delivery_status',
        jsonb_build_object('store_id', store_uuid)
    )
    FROM orders 
    WHERE store_id = store_uuid 
    AND rider_id IS NOT NULL 
    AND status = 'cancelled';
END;
$function$
;

CREATE OR REPLACE FUNCTION public.sync_all_available_jobs()
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    -- ลบข้อมูลเก่าทั้งหมด
    TRUNCATE TABLE public.available_jobs_for_workers;
    
    -- Insert ข้อมูลใหม่ทั้งหมด
    INSERT INTO public.available_jobs_for_workers (
        job_posting_id,
        job_number,
        title,
        description,
        job_price,
        category_id,
        category_name,
        employer_address,
        employer_latitude,
        employer_longitude,
        distance_km,
        employer_name,
        employer_phone,
        employer_line_id,
        special_instructions,
        estimated_completion_time,
        payment_method,
        payment_status,
        created_at,
        updated_at
    )
    SELECT 
        jp.id,
        jp.job_number,
        jp.title,
        jp.description,
        jp.job_price,
        jp.category_id,
        jc.name,
        jp.employer_address,
        jp.employer_latitude,
        jp.employer_longitude,
        jp.distance_km,
        jp.employer_name,
        jp.employer_phone,
        jp.employer_line_id,
        jp.special_instructions,
        jp.estimated_completion_time,
        jp.payment_method,
        jp.payment_status,
        jp.created_at,
        now()
    FROM public.job_postings jp
    JOIN public.job_categories jc ON jp.category_id = jc.id
    WHERE jp.status = 'published'
      AND jp.worker_id IS NULL
      AND jc.is_active = true;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.sync_available_jobs_for_workers()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    -- เมื่อมีการเปลี่ยนแปลงใน job_postings
    IF TG_TABLE_NAME = 'job_postings' THEN
        -- ถ้าเป็น DELETE operation
        IF TG_OP = 'DELETE' THEN
            DELETE FROM public.available_jobs_for_workers 
            WHERE job_posting_id = OLD.id;
            RETURN OLD;
        END IF;
        
        -- ถ้า status = 'published' และ worker_id IS NULL และ category ยัง active อยู่
        IF NEW.status = 'published' AND NEW.worker_id IS NULL THEN
            -- เช็คว่า category ยัง active อยู่หรือไม่
            IF EXISTS (
                SELECT 1 FROM public.job_categories 
                WHERE id = NEW.category_id AND is_active = true
            ) THEN
                INSERT INTO public.available_jobs_for_workers (
                    job_posting_id,
                    job_number,
                    title,
                    description,
                    job_price,
                    category_id,
                    category_name,
                    employer_address,
                    employer_latitude,
                    employer_longitude,
                    distance_km,
                    employer_name,
                    employer_phone,
                    employer_line_id,
                    special_instructions,
                    estimated_completion_time,
                    payment_method,
                    payment_status,
                    created_at,
                    updated_at
                )
                SELECT 
                    jp.id,
                    jp.job_number,
                    jp.title,
                    jp.description,
                    jp.job_price,
                    jp.category_id,
                    jc.name,
                    jp.employer_address,
                    jp.employer_latitude,
                    jp.employer_longitude,
                    jp.distance_km,
                    jp.employer_name,
                    jp.employer_phone,
                    jp.employer_line_id,
                    jp.special_instructions,
                    jp.estimated_completion_time,
                    jp.payment_method,
                    jp.payment_status,
                    jp.created_at,
                    now()
                FROM public.job_postings jp
                JOIN public.job_categories jc ON jp.category_id = jc.id
                WHERE jp.id = NEW.id
                  AND jp.status = 'published'
                  AND jp.worker_id IS NULL
                  AND jc.is_active = true
                ON CONFLICT (job_posting_id)
                DO UPDATE SET
                    job_number = EXCLUDED.job_number,
                    title = EXCLUDED.title,
                    description = EXCLUDED.description,
                    job_price = EXCLUDED.job_price,
                    category_id = EXCLUDED.category_id,
                    category_name = EXCLUDED.category_name,
                    employer_address = EXCLUDED.employer_address,
                    employer_latitude = EXCLUDED.employer_latitude,
                    employer_longitude = EXCLUDED.employer_longitude,
                    distance_km = EXCLUDED.distance_km,
                    employer_name = EXCLUDED.employer_name,
                    employer_phone = EXCLUDED.employer_phone,
                    employer_line_id = EXCLUDED.employer_line_id,
                    special_instructions = EXCLUDED.special_instructions,
                    estimated_completion_time = EXCLUDED.estimated_completion_time,
                    payment_method = EXCLUDED.payment_method,
                    payment_status = EXCLUDED.payment_status,
                    updated_at = now();
            ELSE
                -- Category ไม่ active หรือไม่มี category แล้ว ลบออก
                DELETE FROM public.available_jobs_for_workers 
                WHERE job_posting_id = NEW.id;
            END IF;
        ELSE
            -- ถ้าไม่ใช่ published หรือมี worker_id แล้ว ลบออก
            DELETE FROM public.available_jobs_for_workers 
            WHERE job_posting_id = NEW.id;
        END IF;
        
        RETURN NEW;
    END IF;
    
    -- เมื่อมีการเปลี่ยนแปลงใน job_categories
    IF TG_TABLE_NAME = 'job_categories' THEN
        -- ถ้าเป็น DELETE operation
        IF TG_OP = 'DELETE' THEN
            DELETE FROM public.available_jobs_for_workers 
            WHERE category_id = OLD.id;
            RETURN OLD;
        END IF;
        
        -- ถ้า is_active เปลี่ยนเป็น false
        IF NEW.is_active = false THEN
            -- ลบงานทั้งหมดที่ใช้ category นี้
            DELETE FROM public.available_jobs_for_workers 
            WHERE category_id = NEW.id;
        ELSE
            -- ถ้า is_active เปลี่ยนเป็น true ให้ sync งานที่ใช้ category นี้ใหม่
            INSERT INTO public.available_jobs_for_workers (
                job_posting_id,
                job_number,
                title,
                description,
                job_price,
                category_id,
                category_name,
                employer_address,
                employer_latitude,
                employer_longitude,
                distance_km,
                employer_name,
                employer_phone,
                employer_line_id,
                special_instructions,
                estimated_completion_time,
                payment_method,
                payment_status,
                created_at,
                updated_at
            )
            SELECT 
                jp.id,
                jp.job_number,
                jp.title,
                jp.description,
                jp.job_price,
                jp.category_id,
                NEW.name,
                jp.employer_address,
                jp.employer_latitude,
                jp.employer_longitude,
                jp.distance_km,
                jp.employer_name,
                jp.employer_phone,
                jp.employer_line_id,
                jp.special_instructions,
                jp.estimated_completion_time,
                jp.payment_method,
                jp.payment_status,
                jp.created_at,
                now()
            FROM public.job_postings jp
            WHERE jp.category_id = NEW.id
              AND jp.status = 'published'
              AND jp.worker_id IS NULL
            ON CONFLICT (job_posting_id)
            DO UPDATE SET
                category_name = NEW.name,
                updated_at = now();
        END IF;
        
        RETURN NEW;
    END IF;
    
    RETURN NULL;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.sync_deposit_status_on_status_change()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  -- When status changes to deposit_confirmed, set deposit_status to 'paid'
  IF NEW.status = 'deposit_confirmed' AND OLD.status != 'deposit_confirmed' THEN
    NEW.deposit_status := 'paid';
    NEW.deposit_paid_at := COALESCE(NEW.deposit_paid_at, now());
  END IF;
  
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.sync_job_worker_fcm_tokens()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    user_fcm_token text;
    token_record RECORD;
BEGIN
    -- เช็คว่า is_active เปลี่ยนหรือไม่
    IF (OLD.is_active IS DISTINCT FROM NEW.is_active) THEN
        IF NEW.is_active = true THEN
            -- เมื่อ is_active = true: เอา FCM token จาก users มาใส่ใน job_worker_fcm_tokens
            
            -- ดึง FCM token จาก users.fcm_token (primary source)
            SELECT fcm_token INTO user_fcm_token
            FROM public.users
            WHERE id = NEW.user_id
            AND fcm_token IS NOT NULL
            AND fcm_token != '';
            
            -- ถ้ามี FCM token ให้ insert
            IF user_fcm_token IS NOT NULL AND user_fcm_token != '' THEN
                INSERT INTO public.job_worker_fcm_tokens (
                    worker_id,
                    fcm_token,
                    device_type,
                    is_active,
                    created_at,
                    updated_at
                )
                VALUES (
                    NEW.id,
                    user_fcm_token,
                    'mobile', -- default device type
                    true,
                    now(),
                    now()
                )
                ON CONFLICT (worker_id, fcm_token)
                DO UPDATE SET
                    is_active = true,
                    updated_at = now();
            END IF;
            
            -- รองรับกรณีที่มีหลาย FCM tokens ใน fcm_store (ถ้ามีในอนาคต)
            -- สำหรับตอนนี้ใช้เฉพาะ users.fcm_token
            -- ถ้าในอนาคตต้องการดึงจาก fcm_store ด้วย ให้ uncomment ส่วนนี้:
            /*
            FOR token_record IN
                SELECT fcm_token, platform
                FROM public.fcm_store
                WHERE user_id = NEW.user_id
                AND is_active = true
                AND fcm_token IS NOT NULL
                AND fcm_token != ''
            LOOP
                INSERT INTO public.job_worker_fcm_tokens (
                    worker_id,
                    fcm_token,
                    device_type,
                    is_active,
                    created_at,
                    updated_at
                )
                VALUES (
                    NEW.id,
                    token_record.fcm_token,
                    CASE 
                        WHEN token_record.platform IN ('ios', 'android') THEN 'mobile'
                        WHEN token_record.platform = 'web' THEN 'desktop'
                        ELSE 'mobile'
                    END,
                    true,
                    now(),
                    now()
                )
                ON CONFLICT (worker_id, fcm_token)
                DO UPDATE SET
                    is_active = true,
                    updated_at = now();
            END LOOP;
            */
        ELSE
            -- เมื่อ is_active = false: ลบ FCM tokens ของ worker นั้นออกทั้งหมด
            DELETE FROM public.job_worker_fcm_tokens
            WHERE worker_id = NEW.id;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.sync_new_order_for_riders()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_store_name text;
    v_store_active boolean;
BEGIN
    -- ถ้าเป็น INSERT หรือ UPDATE และสถานะเป็น 'ready' และยังไม่มีไรเดอร์รับงาน
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') AND 
       NEW.status = 'ready' AND 
       NEW.rider_id IS NULL THEN
        
        -- ดึงข้อมูลร้านค้า
        SELECT name, is_active
        INTO v_store_name, v_store_active
        FROM public.stores
        WHERE id = NEW.store_id;
        
        -- ตรวจสอบว่าร้านค้ายังเปิดใช้งานอยู่
        IF v_store_active = true THEN
            -- INSERT หรือ UPDATE ข้อมูลในตาราง new_order_for_riders
            INSERT INTO public.new_order_for_riders (
                order_id,
                store_name,
                delivery_fee,
                status
            ) VALUES (
                NEW.id,
                v_store_name,
                NEW.delivery_fee,
                NEW.status
            )
            ON CONFLICT (order_id) DO UPDATE
            SET 
                store_name = EXCLUDED.store_name,
                delivery_fee = EXCLUDED.delivery_fee,
                status = EXCLUDED.status;
        END IF;
        
        RETURN NEW;
    END IF;
    
    -- ถ้า UPDATE และสถานะไม่ใช่ 'ready' หรือมีไรเดอร์รับงานแล้ว ให้ลบออก
    IF TG_OP = 'UPDATE' AND 
       (NEW.status != 'ready' OR NEW.rider_id IS NOT NULL) THEN
        DELETE FROM public.new_order_for_riders WHERE order_id = NEW.id;
        RETURN NEW;
    END IF;
    
    -- ถ้า DELETE ให้ลบออกจาก new_order_for_riders ด้วย
    IF TG_OP = 'DELETE' THEN
        DELETE FROM public.new_order_for_riders WHERE order_id = OLD.id;
        RETURN OLD;
    END IF;
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.sync_store_active_orders()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  -- ถ้าเป็น INSERT หรือ UPDATE เป็น active status
  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') AND 
     NEW.status IN ('pending', 'accepted', 'preparing', 'ready', 'assigned', 'picked_up', 'delivering') THEN
    
    INSERT INTO store_active_orders
    SELECT NEW.*
    ON CONFLICT (id) DO UPDATE
    SET 
      status = NEW.status,
      updated_at = NEW.updated_at,
      rider_id = NEW.rider_id,
      payment_status = NEW.payment_status,
      delivery_address = NEW.delivery_address,
      customer_name = NEW.customer_name,
      customer_phone = NEW.customer_phone,
      total_amount = NEW.total_amount,
      subtotal = NEW.subtotal,
      delivery_fee = NEW.delivery_fee,
      discount_amount = NEW.discount_amount,
      tax_amount = NEW.tax_amount,
      payment_method = NEW.payment_method,
      order_number = NEW.order_number,
      customer_id = NEW.customer_id,
      store_id = NEW.store_id,
      created_at = NEW.created_at,
      distance_km = NEW.distance_km,
      customer_email = NEW.customer_email,
      customer_line_id = NEW.customer_line_id,
      qr_code_url = NEW.qr_code_url,
      bank_name = NEW.bank_name,
      transfer_amount = NEW.transfer_amount,
      cancelled_at = NEW.cancelled_at,
      cancelled_by = NEW.cancelled_by,
      discount_code = NEW.discount_code;
    
    RETURN NEW;
  END IF;
  
  -- ถ้า UPDATE เป็น inactive status (delivered, cancelled) ให้ลบออก
  IF TG_OP = 'UPDATE' AND 
     NEW.status NOT IN ('pending', 'accepted', 'preparing', 'ready', 'assigned', 'picked_up', 'delivering') THEN
    DELETE FROM store_active_orders WHERE id = NEW.id;
    RETURN NEW;
  END IF;
  
  -- ถ้า DELETE ให้ลบออกจาก active orders ด้วย
  IF TG_OP = 'DELETE' THEN
    DELETE FROM store_active_orders WHERE id = OLD.id;
    RETURN OLD;
  END IF;
  
  RETURN NEW;
END;
$function$
;

create or replace view "public"."system_sales_summary" as  SELECT count(id) AS total_orders,
    COALESCE(sum(total_amount), (0)::numeric) AS total_revenue,
    COALESCE(sum(COALESCE(discount_amount, (0)::numeric)), (0)::numeric) AS total_discount_given,
    COALESCE(sum((total_amount + COALESCE(discount_amount, (0)::numeric))), (0)::numeric) AS gross_revenue,
    COALESCE(avg(total_amount), (0)::numeric) AS average_order_value,
    count(id) FILTER (WHERE (discount_code IS NOT NULL)) AS orders_with_discount,
        CASE
            WHEN (count(id) > 0) THEN (((count(id) FILTER (WHERE (discount_code IS NOT NULL)))::numeric * 100.0) / (count(id))::numeric)
            ELSE (0)::numeric
        END AS discount_usage_percentage,
    count(id) FILTER (WHERE (status = ANY (ARRAY['delivered'::text, 'completed'::text]))) AS completed_orders,
    count(id) FILTER (WHERE (status = 'cancelled'::text)) AS cancelled_orders,
    count(id) FILTER (WHERE (status = 'pending'::text)) AS pending_orders,
    count(id) FILTER (WHERE (status = 'accepted'::text)) AS accepted_orders,
    count(id) FILTER (WHERE (status = 'preparing'::text)) AS preparing_orders,
    count(id) FILTER (WHERE (status = 'ready'::text)) AS ready_orders,
    count(id) FILTER (WHERE (status = 'assigned'::text)) AS assigned_orders,
    count(id) FILTER (WHERE (status = 'picked_up'::text)) AS picked_up_orders,
    count(id) FILTER (WHERE (status = 'delivering'::text)) AS delivering_orders,
    count(DISTINCT discount_code_id) AS unique_discount_codes_used,
    NULL::text AS most_popular_discount_code,
    NULL::text AS most_popular_discount_usage_count,
    ( SELECT count(*) AS count
           FROM public.stores s
          WHERE ((COALESCE(s.is_active, true) = true) AND (COALESCE(s.is_suspended, false) = false))) AS active_stores,
    count(DISTINCT store_id) FILTER (WHERE (status = ANY (ARRAY['delivered'::text, 'completed'::text]))) AS completed_store_count,
    count(DISTINCT customer_id) FILTER (WHERE (status = ANY (ARRAY['delivered'::text, 'completed'::text]))) AS active_customers,
    count(DISTINCT rider_id) FILTER (WHERE (status = ANY (ARRAY['delivered'::text, 'completed'::text]))) AS active_riders,
    COALESCE(sum(
        CASE
            WHEN ((payment_method = 'cash'::text) AND (status <> 'cancelled'::text)) THEN subtotal
            ELSE (0)::numeric
        END), (0)::numeric) AS cash_revenue,
    COALESCE(sum(
        CASE
            WHEN ((payment_method = 'bank_transfer'::text) AND (status <> 'cancelled'::text)) THEN subtotal
            ELSE (0)::numeric
        END), (0)::numeric) AS transfer_revenue,
    count(id) FILTER (WHERE (payment_method = 'cash'::text)) AS cash_orders,
    count(id) FILTER (WHERE (payment_method = 'bank_transfer'::text)) AS transfer_orders
   FROM public.orders o;


CREATE OR REPLACE FUNCTION public.test_customer_fcm_token(order_uuid uuid)
 RETURNS TABLE(customer_id uuid, customer_name text, fcm_token text)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        u.id as customer_id,
        u.full_name as customer_name,
        u.fcm_token
    FROM users u
    JOIN orders o ON u.id = o.customer_id
    WHERE o.id = order_uuid;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.test_direct_update(order_uuid uuid)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    result TEXT;
BEGIN
    -- ทดสอบการอัปเดตโดยตรง
    UPDATE orders 
    SET 
        status = 'cancelled',
        updated_at = NOW()
    WHERE id = order_uuid;
    
    result := 'Success: Direct update without triggers';
    RETURN result;
EXCEPTION
    WHEN OTHERS THEN
        result := 'Error: ' || SQLERRM;
        RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.test_direct_update_no_triggers(order_uuid uuid)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    result TEXT;
BEGIN
    -- ทดสอบการอัปเดตโดยตรงโดยไม่ใช้ triggers
    UPDATE orders 
    SET 
        status = 'cancelled',
        updated_at = NOW()
    WHERE id = order_uuid;
    
    result := 'Success: Direct update without triggers';
    RETURN result;
EXCEPTION
    WHEN OTHERS THEN
        result := 'Error: ' || SQLERRM;
        RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.test_rider_fcm_token(order_uuid uuid)
 RETURNS TABLE(rider_id uuid, rider_name text, fcm_token text, assignment_status text)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        rpv.rider_id,
        rpv.full_name as rider_name,
        u.fcm_token,
        ra.status as assignment_status
    FROM users u
    JOIN rider_profile_view rpv ON u.id = rpv.user_id
    JOIN rider_assignments ra ON rpv.rider_id = ra.rider_id
    WHERE ra.order_id = order_uuid
    AND ra.status IN ('assigned', 'picked_up', 'delivering')
    ORDER BY ra.assigned_at DESC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.toggle_delivery_note_favorite(p_note_id uuid, p_user_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE public.delivery_notes 
    SET 
        is_favorite = NOT is_favorite,
        updated_at = now()
    WHERE id = p_note_id AND user_id = p_user_id;
    
    RETURN FOUND;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.toggle_store_status(store_uuid uuid, new_is_open boolean, reason text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    store_info RECORD;
BEGIN
    -- ดึงข้อมูลร้านค้า
    SELECT * INTO store_info FROM stores WHERE id = store_uuid;
    
    -- ตรวจสอบว่าเป็นเจ้าของร้าน
    IF store_info.owner_id != auth.uid() THEN
        RAISE EXCEPTION 'You are not authorized to modify this store';
    END IF;
    
    -- อัปเดตสถานะร้านค้า
    UPDATE stores 
    SET 
        is_open = new_is_open,
        updated_at = NOW()
    WHERE id = store_uuid;
    
    -- No order cancellation performed when store is closed; orders remain unchanged
    
    -- ส่งการแจ้งเตือนเจ้าของร้าน (ใช้ประเภท 'system' แทน 'store_status')
    PERFORM send_notification(
        store_info.owner_id,
        CASE 
            WHEN new_is_open THEN 'ร้านค้าเปิดทำการ'
            ELSE 'ร้านค้าปิดทำการ'
        END,
        CASE 
            WHEN new_is_open THEN 'ร้านค้าของคุณได้เปิดทำการแล้ว'
            ELSE 'ร้านค้าของคุณได้ปิดทำการแล้ว' || 
                 CASE WHEN reason IS NOT NULL THEN ' เหตุผล: ' || reason ELSE '' END
        END,
        'system',
        jsonb_build_object(
            'store_id', store_uuid,
            'is_open', new_is_open,
            'reason', reason
        )
    );
END;
$function$
;

create or replace view "public"."top_products_report" as  WITH base AS (
         SELECT ((o.created_at AT TIME ZONE 'Asia/Bangkok'::text))::date AS sale_date,
            oi.product_name,
            oi.product_id,
            count(*) AS total_orders,
            COALESCE(sum(oi.quantity), (0)::bigint) AS total_quantity,
            COALESCE(sum(oi.total_price), (0)::numeric) AS total_revenue,
            COALESCE(avg(oi.product_price), (0)::numeric) AS average_price,
            count(*) FILTER (WHERE (o.discount_code IS NOT NULL)) AS orders_with_discount,
                CASE
                    WHEN (count(*) > 0) THEN (((count(*) FILTER (WHERE (o.discount_code IS NOT NULL)))::numeric * 100.0) / (count(*))::numeric)
                    ELSE (0)::numeric
                END AS discount_usage_percentage,
            COALESCE(sum(
                CASE
                    WHEN (o.discount_code IS NOT NULL) THEN o.discount_amount
                    ELSE (0)::numeric
                END), (0)::numeric) AS total_discount_amount,
            NULL::text AS most_used_discount_code,
            NULL::text AS most_used_discount_count,
            (date_trunc('week'::text, (o.created_at AT TIME ZONE 'Asia/Bangkok'::text)))::date AS week_start,
            (date_trunc('month'::text, (o.created_at AT TIME ZONE 'Asia/Bangkok'::text)))::date AS month_start,
            (EXTRACT(year FROM (o.created_at AT TIME ZONE 'Asia/Bangkok'::text)))::integer AS year,
            o.store_id,
            s.name AS store_name,
            COALESCE(avg((oi.quantity)::numeric), (0)::numeric) AS avg_quantity_per_order
           FROM (((public.orders o
             JOIN public.order_items oi ON ((oi.order_id = o.id)))
             LEFT JOIN public.products p ON ((p.id = oi.product_id)))
             LEFT JOIN public.stores s ON ((s.id = o.store_id)))
          WHERE (o.status = ANY (ARRAY['delivered'::text, 'completed'::text]))
          GROUP BY (((o.created_at AT TIME ZONE 'Asia/Bangkok'::text))::date), oi.product_name, oi.product_id, ((date_trunc('week'::text, (o.created_at AT TIME ZONE 'Asia/Bangkok'::text)))::date), ((date_trunc('month'::text, (o.created_at AT TIME ZONE 'Asia/Bangkok'::text)))::date), ((EXTRACT(year FROM (o.created_at AT TIME ZONE 'Asia/Bangkok'::text)))::integer), o.store_id, s.name
        )
 SELECT sale_date,
    product_name,
    product_id,
    total_orders,
    total_quantity,
    total_revenue,
    average_price,
    orders_with_discount,
    discount_usage_percentage,
    total_discount_amount,
    most_used_discount_code,
    most_used_discount_count,
    store_id,
    store_name,
    week_start,
    month_start,
    year,
    total_quantity AS total_quantity_sold,
    avg_quantity_per_order
   FROM base
  ORDER BY sale_date DESC, total_revenue DESC;


CREATE OR REPLACE FUNCTION public.trigger_assign_booked_orders()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- เมื่อออเดอร์เปลี่ยนสถานะเป็น ready ให้มอบหมายงานที่จองไว้
    IF NEW.status = 'ready' AND OLD.status != 'ready' THEN
        -- มอบหมายงานที่จองไว้ให้ไรเดอร์ที่จอง
        PERFORM assign_booked_orders_to_rider(rob.rider_id)
        FROM rider_order_bookings rob
        WHERE rob.order_id = NEW.id
        AND rob.status = 'booked';
    END IF;
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.trigger_cleanup_bookings_on_completion()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- เมื่องานเสร็จสิ้น ให้ลบการจองที่เกี่ยวข้อง
    IF NEW.status IN ('delivered', 'cancelled') AND OLD.status NOT IN ('delivered', 'cancelled') THEN
        DELETE FROM rider_order_bookings
        WHERE order_id = NEW.order_id
        AND rider_id = NEW.rider_id;
        
        -- มอบหมายงานที่จองไว้ถัดไป
        PERFORM assign_booked_orders_to_rider(NEW.rider_id);
    END IF;
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.trigger_notify_new_pending_order()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF NEW.status = 'pending' THEN
        PERFORM public.notify_new_pending_order(NEW.id);
    END IF;
    RETURN NEW;
END;
$function$
;

create or replace view "public"."unread_chat_messages" as  SELECT cm.id,
    cm.order_id,
    cm.sender_type,
    cm.sender_id,
    cm.message,
    cm.message_type,
    cm.created_at,
    cm.sender_fcm_token,
    cm.recipient_fcm_token,
    o.order_number,
    o.customer_name,
    o.customer_phone,
    o.delivery_address,
    o.status AS order_status
   FROM (public.chat_messages cm
     JOIN public.orders o ON ((cm.order_id = o.id)))
  WHERE (cm.is_read = false)
  ORDER BY cm.created_at DESC;


CREATE OR REPLACE FUNCTION public.unsuspend_store(store_uuid uuid, unsuspension_reason_param text, admin_notes_param text DEFAULT NULL::text, unsuspended_by_user_id uuid DEFAULT NULL::uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    store_info RECORD;
    suspension_history_id UUID;
BEGIN
    -- ตรวจสอบว่าเป็น admin
    IF NOT EXISTS (SELECT 1 FROM users WHERE id = unsuspended_by_user_id AND role = 'admin') THEN
        RAISE EXCEPTION 'Only admin can unsuspend stores';
    END IF;
    
    -- ดึงข้อมูลร้านค้า
    SELECT * INTO store_info FROM stores WHERE id = store_uuid;
    
    -- ตรวจสอบว่าร้านค้าถูกระงับอยู่
    IF NOT store_info.is_suspended THEN
        RAISE EXCEPTION 'Store is not suspended';
    END IF;
    
    -- อัปเดตสถานะร้านค้า
    UPDATE stores 
    SET 
        is_suspended = false,
        suspension_reason = NULL,
        suspended_by = NULL,
        suspended_at = NULL,
        updated_at = NOW()
    WHERE id = store_uuid;
    
    -- อัปเดตประวัติการระงับ
    UPDATE store_suspension_history 
    SET 
        unsuspended_at = NOW(),
        unsuspended_by = unsuspended_by_user_id
    WHERE store_id = store_uuid 
    AND action = 'suspended' 
    AND unsuspended_at IS NULL;
    
    -- เพิ่มประวัติการเปิดร้านคืน
    INSERT INTO store_suspension_history (
        store_id,
        action,
        reason,
        admin_notes,
        suspended_by
    )
    VALUES (
        store_uuid,
        'unsuspended',
        unsuspension_reason_param,
        admin_notes_param,
        unsuspended_by_user_id
    );
    
    -- ส่งการแจ้งเตือนเจ้าของร้าน
    PERFORM send_notification(
        store_info.owner_id,
        'ร้านค้าเปิดให้บริการแล้ว',
        'ร้านค้าของคุณได้รับการเปิดให้บริการแล้ว คุณสามารถเปิดร้านและรับออเดอร์ได้',
        'system',
        jsonb_build_object(
            'store_id', store_uuid,
            'reason', unsuspension_reason_param
        )
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_ads_floating_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_ads_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_age_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  IF NEW.date_of_birth IS NOT NULL THEN
    NEW.age = calculate_age(NEW.date_of_birth);
  END IF;
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_app_store_versions_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_available_jobs_for_workers_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_available_riders_from_assignments()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- เมื่อมีการสร้าง assignment ใหม่
    IF TG_OP = 'INSERT' THEN
        IF NEW.status IN ('assigned', 'picked_up', 'delivering') THEN
            RAISE NOTICE 'ไรเดอร์ % (ID: %) เริ่มงานใหม่ - จะไม่ปรากฏใน available_riders', NEW.rider_id, NEW.rider_id;
        END IF;
    END IF;
    
    -- เมื่อมีการอัปเดต assignment
    IF TG_OP = 'UPDATE' THEN
        -- ถ้าสถานะเปลี่ยนจาก active เป็น completed/cancelled
        IF OLD.status IN ('assigned', 'picked_up', 'delivering') AND 
           NEW.status NOT IN ('assigned', 'picked_up', 'delivering') THEN
            -- ตรวจสอบว่าไรเดอร์พร้อมรับงานหรือไม่
            IF EXISTS (
                SELECT 1 FROM riders r
                WHERE r.id = NEW.rider_id 
                AND r.is_available = true 
                AND r.documents_verified = true
            ) THEN
                RAISE NOTICE 'ไรเดอร์ % (ID: %) เสร็จงานแล้ว - พร้อมรับงานใหม่', NEW.rider_id, NEW.rider_id;
            END IF;
        END IF;
        
        -- ถ้าสถานะเปลี่ยนเป็น active
        IF OLD.status NOT IN ('assigned', 'picked_up', 'delivering') AND 
           NEW.status IN ('assigned', 'picked_up', 'delivering') THEN
            RAISE NOTICE 'ไรเดอร์ % (ID: %) เริ่มงานใหม่ - จะไม่ปรากฏใน available_riders', NEW.rider_id, NEW.rider_id;
        END IF;
    END IF;
    
    -- เมื่อมีการลบ assignment
    IF TG_OP = 'DELETE' THEN
        IF OLD.status IN ('assigned', 'picked_up', 'delivering') THEN
            -- ตรวจสอบว่าไรเดอร์พร้อมรับงานหรือไม่
            IF EXISTS (
                SELECT 1 FROM riders r
                WHERE r.id = OLD.rider_id 
                AND r.is_available = true 
                AND r.documents_verified = true
            ) THEN
                RAISE NOTICE 'ไรเดอร์ % (ID: %) งานถูกยกเลิก - พร้อมรับงานใหม่', OLD.rider_id, OLD.rider_id;
            END IF;
        END IF;
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_available_riders_status()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- ตรวจสอบการเปลี่ยนแปลงของ is_available
    IF OLD.is_available IS DISTINCT FROM NEW.is_available THEN
        -- ถ้าไรเดอร์เปิดระบบรับงาน (is_available = true)
        IF NEW.is_available = true THEN
            -- ตรวจสอบว่าไรเดอร์มีเอกสารยืนยันแล้วและไม่มีงานค้าง
            IF NEW.documents_verified = true AND NOT EXISTS (
                SELECT 1 FROM rider_assignments ra 
                WHERE ra.rider_id = NEW.id 
                AND ra.status IN ('assigned', 'picked_up', 'delivering')
            ) THEN
                RAISE NOTICE 'ไรเดอร์ % (ID: %) พร้อมรับงานแล้ว', NEW.id, NEW.id;
            ELSE
                RAISE NOTICE 'ไรเดอร์ % (ID: %) เปิดระบบรับงาน แต่ยังไม่พร้อม (เอกสารไม่ยืนยันหรือมีงานค้าง)', NEW.id, NEW.id;
            END IF;
        ELSE
            -- ถ้าไรเดอร์ปิดระบบรับงาน (is_available = false)
            RAISE NOTICE 'ไรเดอร์ % (ID: %) ปิดระบบรับงานแล้ว', NEW.id, NEW.id;
        END IF;
    END IF;
    
    -- ตรวจสอบการเปลี่ยนแปลงของ documents_verified
    IF OLD.documents_verified IS DISTINCT FROM NEW.documents_verified THEN
        IF NEW.documents_verified = true AND NEW.is_available = true THEN
            -- ตรวจสอบว่าไม่มีงานค้าง
            IF NOT EXISTS (
                SELECT 1 FROM rider_assignments ra 
                WHERE ra.rider_id = NEW.id 
                AND ra.status IN ('assigned', 'picked_up', 'delivering')
            ) THEN
                RAISE NOTICE 'ไรเดอร์ % (ID: %) เอกสารยืนยันแล้วและพร้อมรับงาน', NEW.id, NEW.id;
            END IF;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_chat_messages_fcm_tokens(p_order_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    order_rider_id UUID;
    customer_fcm TEXT;
    rider_fcm TEXT;
    chat_message RECORD;
BEGIN
    -- ตรวจสอบว่าออเดอร์มีไรเดอร์หรือไม่
    SELECT rider_id INTO order_rider_id 
    FROM orders 
    WHERE id = p_order_id;

    -- ดึง FCM token ของลูกค้า
    customer_fcm := get_customer_fcm_token(p_order_id);

    -- ดึง FCM token ของไรเดอร์ (ถ้ามี)
    IF order_rider_id IS NOT NULL THEN
        SELECT arft.fcm_token INTO rider_fcm
        FROM active_rider_fcm_tokens arft
        WHERE arft.rider_id = order_rider_id
        LIMIT 1;
    ELSE
        rider_fcm := NULL;
    END IF;

    -- อัปเดท FCM tokens ในข้อความแชททั้งหมดของออเดอร์นี้
    FOR chat_message IN 
        SELECT id, sender_type 
        FROM chat_messages 
        WHERE order_id = p_order_id
    LOOP
        IF chat_message.sender_type = 'rider' THEN
            -- ถ้าไรเดอร์ส่งข้อความ ให้อัปเดท recipient_fcm_token เป็นของลูกค้า
            UPDATE chat_messages 
            SET recipient_fcm_token = customer_fcm
            WHERE id = chat_message.id;
        ELSE
            -- ถ้าลูกค้าส่งข้อความ ให้อัปเดท recipient_fcm_token เป็นของไรเดอร์ (ถ้ามี)
            UPDATE chat_messages 
            SET recipient_fcm_token = rider_fcm
            WHERE id = chat_message.id;
        END IF;
    END LOOP;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_customer_data_in_orders()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- อัปเดตข้อมูลลูกค้าในออเดอร์ทั้งหมดเมื่อข้อมูลผู้ใช้เปลี่ยน
    UPDATE orders 
    SET 
        customer_name = NEW.full_name,
        customer_phone = NEW.phone,
        customer_email = NEW.email,
        customer_line_id = NEW.line_id
    WHERE customer_id = NEW.id;
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_delivery_fee_setting(setting_uuid uuid, new_base_fee numeric, new_distance_fee_per_km numeric, new_max_delivery_distance integer, updated_by_user_id uuid, reason text DEFAULT NULL::text, new_free_delivery_threshold numeric DEFAULT 0, new_peak_hour_multiplier numeric DEFAULT 1.0, new_peak_hour_start time without time zone DEFAULT '00:00:00'::time without time zone, new_peak_hour_end time without time zone DEFAULT '23:59:59'::time without time zone)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    old_setting RECORD;
BEGIN
    -- ตรวจสอบว่าเป็น admin
    IF NOT EXISTS (SELECT 1 FROM users WHERE id = updated_by_user_id AND role = 'admin') THEN
        RAISE EXCEPTION 'Only admin can update delivery fee settings';
    END IF;
    
    -- ดึงข้อมูลเก่า
    SELECT * INTO old_setting FROM delivery_fee_settings WHERE id = setting_uuid;
    
    -- อัปเดตการตั้งค่า
    UPDATE delivery_fee_settings 
    SET 
        base_fee = new_base_fee,
        distance_fee_per_km = new_distance_fee_per_km,
        max_delivery_distance = new_max_delivery_distance,
        free_delivery_threshold = new_free_delivery_threshold,
        peak_hour_multiplier = new_peak_hour_multiplier,
        peak_hour_start = new_peak_hour_start,
        peak_hour_end = new_peak_hour_end,
        updated_at = NOW()
    WHERE id = setting_uuid;
    
    -- เพิ่มประวัติการเปลี่ยนแปลง
    INSERT INTO delivery_fee_history (
        setting_id,
        old_base_fee,
        new_base_fee,
        old_distance_fee_per_km,
        new_distance_fee_per_km,
        old_free_delivery_threshold,
        new_free_delivery_threshold,
        reason,
        changed_by
    )
    VALUES (
        setting_uuid,
        old_setting.base_fee,
        new_base_fee,
        old_setting.distance_fee_per_km,
        new_distance_fee_per_km,
        old_setting.free_delivery_threshold,
        new_free_delivery_threshold,
        reason,
        updated_by_user_id
    );
    
    -- ส่งการแจ้งเตือน
    PERFORM send_notification(
        updated_by_user_id,
        'อัปเดตการตั้งค่าค่าส่งสำเร็จ',
        'อัปเดตการตั้งค่าค่าส่ง: ' || old_setting.name,
        'system',
        jsonb_build_object('setting_id', setting_uuid, 'setting_name', old_setting.name)
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_delivery_notes_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_fcm_store_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_fcm_token_last_used(token text)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE fcm_store 
    SET last_used_at = NOW()
    WHERE fcm_token = token AND is_active = true;
    
    RETURN FOUND;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_job_assignments_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_job_categories_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_job_fee_settings_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_job_postings_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_job_worker_credits_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_job_worker_fcm_tokens_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_job_worker_withdrawals_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_job_workers_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_missing_fcm_tokens()
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    updated_count INTEGER := 0;
    message_record RECORD;
    sender_fcm TEXT;
    recipient_fcm TEXT;
BEGIN
    -- อัปเดตข้อความที่ sender_fcm_token เป็น null
    FOR message_record IN 
        SELECT id, order_id, sender_type, sender_id
        FROM chat_messages 
        WHERE sender_fcm_token IS NULL OR sender_fcm_token = ''
    LOOP
        -- ดึง FCM token ของผู้ส่ง
        IF message_record.sender_type = 'rider' THEN
            sender_fcm := get_rider_fcm_token(message_record.sender_id);
        ELSE
            sender_fcm := (
                SELECT fcm_token 
                FROM users 
                WHERE id = message_record.sender_id
                AND fcm_token IS NOT NULL
                AND fcm_token != ''
            );
        END IF;

        -- อัปเดต sender_fcm_token
        IF sender_fcm IS NOT NULL THEN
            UPDATE chat_messages 
            SET sender_fcm_token = sender_fcm
            WHERE id = message_record.id;
            updated_count := updated_count + 1;
        END IF;
    END LOOP;

    -- อัปเดตข้อความที่ recipient_fcm_token เป็น null
    FOR message_record IN 
        SELECT id, order_id, sender_type
        FROM chat_messages 
        WHERE recipient_fcm_token IS NULL OR recipient_fcm_token = ''
    LOOP
        -- ดึง FCM token ของผู้รับ
        IF message_record.sender_type = 'rider' THEN
            recipient_fcm := get_customer_fcm_token(message_record.order_id);
        ELSE
            recipient_fcm := get_assigned_rider_fcm_token(message_record.order_id);
        END IF;

        -- อัปเดต recipient_fcm_token
        IF recipient_fcm IS NOT NULL THEN
            UPDATE chat_messages 
            SET recipient_fcm_token = recipient_fcm
            WHERE id = message_record.id;
            updated_count := updated_count + 1;
        END IF;
    END LOOP;

    RETURN updated_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_missing_fcm_tokens_for_order(order_uuid uuid)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    updated_count INTEGER := 0;
    rider_fcm TEXT;
    customer_fcm TEXT;
BEGIN
    -- ดึง FCM token ของไรเดอร์ที่ได้รับมอบหมายออเดอร์นี้
    rider_fcm := (
        SELECT u.fcm_token
        FROM users u
        JOIN rider_profile_view rpv ON u.id = rpv.user_id
        JOIN rider_assignments ra ON rpv.rider_id = ra.rider_id
        WHERE ra.order_id = order_uuid
        AND ra.status IN ('assigned', 'picked_up', 'delivering', 'completed')
        AND u.fcm_token IS NOT NULL
        AND u.fcm_token != ''
        ORDER BY ra.created_at DESC
        LIMIT 1
    );

    -- ดึง FCM token ของลูกค้าของออเดอร์นี้
    customer_fcm := (
        SELECT u.fcm_token
        FROM users u
        JOIN orders o ON u.id = o.customer_id
        WHERE o.id = order_uuid
        AND u.fcm_token IS NOT NULL
        AND u.fcm_token != ''
        LIMIT 1
    );

    -- อัปเดตข้อความที่ sender_type = 'customer' และ recipient_fcm_token เป็น null
    IF rider_fcm IS NOT NULL THEN
        UPDATE chat_messages 
        SET recipient_fcm_token = rider_fcm
        WHERE order_id = order_uuid
        AND sender_type = 'customer'
        AND (recipient_fcm_token IS NULL OR recipient_fcm_token = '');
        
        GET DIAGNOSTICS updated_count = ROW_COUNT;
    END IF;

    -- อัปเดตข้อความที่ sender_type = 'rider' และ recipient_fcm_token เป็น null
    IF customer_fcm IS NOT NULL THEN
        UPDATE chat_messages 
        SET recipient_fcm_token = customer_fcm
        WHERE order_id = order_uuid
        AND sender_type = 'rider'
        AND (recipient_fcm_token IS NULL OR recipient_fcm_token = '');
        
        updated_count := updated_count + ROW_COUNT;
    END IF;

    RETURN updated_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_order_customer_data()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- อัปเดตข้อมูลลูกค้าเมื่อมีการสร้างออเดอร์ใหม่
    IF TG_OP = 'INSERT' THEN
        UPDATE orders 
        SET 
            customer_name = u.full_name,
            customer_phone = u.phone,
            customer_email = u.email,
            customer_line_id = u.line_id
        FROM users u
        WHERE orders.id = NEW.id
        AND u.id = NEW.customer_id;
    END IF;
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_order_review(p_review_id uuid, p_customer_id uuid, p_rating numeric, p_review_text text DEFAULT NULL::text, p_review_images text[] DEFAULT NULL::text[], p_is_anonymous boolean DEFAULT false)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE public.order_reviews
    SET 
        rating = p_rating,
        review_text = p_review_text,
        review_images = p_review_images,
        is_anonymous = p_is_anonymous,
        updated_at = NOW()
    WHERE id = p_review_id AND customer_id = p_customer_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Review not found or does not belong to customer';
    END IF;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_order_reviews_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_order_status(order_uuid uuid, new_status text, updated_by_user_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    PERFORM update_order_status(order_uuid, new_status, updated_by_user_id, NULL);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_order_status(order_uuid uuid, new_status text, updated_by_user_id uuid, cancellation_reason text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    order_info RECORD;
    customer_uuid UUID;
    store_owner_uuid UUID;
    existing_notification_id UUID;
    rider_uuid UUID;
BEGIN
    -- ดึงข้อมูลออเดอร์
    SELECT * INTO order_info FROM orders WHERE id = order_uuid;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'ไม่พบออเดอร์ที่ระบุ: %', order_uuid;
    END IF;
    
    -- ดึงข้อมูลที่จำเป็น
    customer_uuid := order_info.customer_id;
    SELECT owner_id INTO store_owner_uuid 
    FROM stores 
    WHERE id = order_info.store_id;
    
    -- อัปเดตสถานะในตาราง orders
    UPDATE orders 
    SET 
        status = new_status,
        updated_at = NOW(),
        -- เพิ่มข้อมูลการยกเลิกถ้าเป็นการยกเลิก
        cancellation_reason = CASE 
            WHEN new_status = 'cancelled' THEN cancellation_reason
            ELSE order_info.cancellation_reason
        END,
        cancelled_by = CASE 
            WHEN new_status = 'cancelled' THEN updated_by_user_id
            ELSE order_info.cancelled_by
        END,
        cancelled_at = CASE 
            WHEN new_status = 'cancelled' THEN NOW()
            ELSE order_info.cancelled_at
        END
    WHERE id = order_uuid;
    
    -- เพิ่มประวัติการเปลี่ยนแปลงสถานะ
    INSERT INTO order_status_history (order_id, status, updated_by, cancellation_reason)
    VALUES (order_uuid, new_status, updated_by_user_id, cancellation_reason);
    
    -- สร้างการแจ้งเตือนตามสถานะ
    IF new_status = 'cancelled' THEN
        -- ตรวจสอบว่ามีการแจ้งเตือนการยกเลิกแล้วหรือไม่
        SELECT id INTO existing_notification_id
        FROM notifications 
        WHERE user_id = customer_uuid
        AND type = 'order_update'
        AND data->>'order_id' = order_uuid::text
        AND data->>'status' = 'cancelled'
        AND created_at > NOW() - INTERVAL '1 minute'
        LIMIT 1;
        
        -- แจ้งเตือนลูกค้า (ถ้ายังไม่มี)
        IF existing_notification_id IS NULL THEN
            PERFORM send_notification(
                customer_uuid,
                'ออเดอร์ถูกยกเลิก',
                'ออเดอร์ของคุณถูกยกเลิกแล้ว: ' || COALESCE(cancellation_reason, 'ไม่มีเหตุผล'),
                'order_update',
                jsonb_build_object(
                    'order_id', order_uuid,
                    'order_number', order_info.order_number,
                    'status', new_status,
                    'cancellation_reason', cancellation_reason
                )
            );
        END IF;
        
        -- ตรวจสอบว่ามีการแจ้งเตือนการยกเลิกสำหรับร้านค้าแล้วหรือไม่
        IF store_owner_uuid IS NOT NULL THEN
            SELECT id INTO existing_notification_id
            FROM notifications 
            WHERE user_id = store_owner_uuid
            AND type = 'order_update'
            AND data->>'order_id' = order_uuid::text
            AND data->>'status' = 'cancelled'
            AND created_at > NOW() - INTERVAL '1 minute'
            LIMIT 1;
            
            -- แจ้งเตือนร้านค้า (ถ้ายังไม่มี)
            IF existing_notification_id IS NULL THEN
                PERFORM send_notification(
                    store_owner_uuid,
                    'ลูกค้ายกเลิกออเดอร์ #' || order_info.order_number,
                    'ลูกค้าได้ยกเลิกออเดอร์ #' || order_info.order_number || ': ' || COALESCE(cancellation_reason, 'ไม่มีเหตุผล'),
                    'order_update',
                    jsonb_build_object(
                        'order_id', order_uuid,
                        'order_number', order_info.order_number,
                        'status', new_status,
                        'cancellation_reason', cancellation_reason
                    )
                );
            END IF;
        END IF;
    ELSE
        -- แจ้งเตือนสำหรับสถานะอื่นๆ
        PERFORM send_notification(
            customer_uuid,
            CASE 
                WHEN new_status = 'accepted' THEN 'ร้านค้ารับออเดอร์แล้ว'
                WHEN new_status = 'preparing' THEN 'ร้านค้ากำลังเตรียมอาหาร'
                WHEN new_status = 'ready' THEN 'อาหารพร้อมส่ง'
                WHEN new_status = 'assigned' THEN 'ไรเดอร์รับงานแล้ว'
                WHEN new_status = 'picked_up' THEN 'ไรเดอร์รับอาหารแล้ว'
                WHEN new_status = 'delivering' THEN 'ไรเดอร์กำลังจัดส่ง'
                WHEN new_status = 'delivered' THEN 'จัดส่งสำเร็จ'
                ELSE 'อัปเดตสถานะออเดอร์'
            END,
            CASE 
                WHEN new_status = 'accepted' THEN 'ร้านค้าได้ยืนยันการรับออเดอร์ของคุณแล้ว'
                WHEN new_status = 'preparing' THEN 'ร้านค้ากำลังเตรียมอาหารให้คุณ'
                WHEN new_status = 'ready' THEN 'อาหารของคุณพร้อมส่งแล้ว ไรเดอร์จะมารับเร็วๆ นี้'
                WHEN new_status = 'assigned' THEN 'ไรเดอร์ได้รับงานของคุณแล้ว และกำลังเดินทางมาส่ง'
                WHEN new_status = 'picked_up' THEN 'ไรเดอร์ได้รับอาหารจากร้านค้าแล้ว'
                WHEN new_status = 'delivering' THEN 'ไรเดอร์กำลังจัดส่งอาหารให้คุณ'
                WHEN new_status = 'delivered' THEN 'อาหารของคุณจัดส่งสำเร็จแล้ว กรุณาให้คะแนน'
                ELSE 'สถานะออเดอร์ของคุณได้อัปเดตเป็น: ' || new_status
            END,
            'order_update',
            jsonb_build_object(
                'order_id', order_uuid,
                'order_number', order_info.order_number,
                'status', new_status
            )
        );
    END IF;
    
    -- แจ้งเตือนไรเดอร์เมื่ออาหารพร้อมส่ง
    IF new_status = 'ready' THEN
        IF EXISTS (
            SELECT 1 FROM riders 
            WHERE is_available = true 
            AND documents_verified = true
        ) THEN
            PERFORM send_notification(
                (SELECT user_id FROM riders 
                 WHERE is_available = true 
                 AND documents_verified = true 
                 LIMIT 1),
                'มีออเดอร์ใหม่',
                'มีออเดอร์ใหม่จากร้าน ' || (SELECT name FROM stores WHERE id = order_info.store_id) || ' พร้อมส่งแล้ว',
                'order_update',
                jsonb_build_object(
                    'order_id', order_uuid,
                    'store_id', order_info.store_id,
                    'delivery_fee', order_info.delivery_fee,
                    'status', 'ready'
                )
            );
        END IF;
    END IF;
    
    -- แจ้งเตือนร้านค้าเมื่อไรเดอร์รับงาน
    IF new_status = 'assigned' THEN
        IF store_owner_uuid IS NOT NULL THEN
            -- ดึงข้อมูลไรเดอร์
            SELECT user_id INTO rider_uuid
            FROM riders 
            WHERE id = order_info.rider_id;
            
            PERFORM send_notification(
                store_owner_uuid,
                'ไรเดอร์รับงานแล้ว',
                'ไรเดอร์ได้รับงานหมายเลข #' || order_info.order_number || ' แล้ว',
                'order_update',
                jsonb_build_object(
                    'order_id', order_uuid,
                    'order_number', order_info.order_number,
                    'status', new_status,
                    'rider_id', order_info.rider_id
                )
            );
        END IF;
    END IF;
    
    -- แจ้งเตือนไรเดอร์เมื่อสถานะเปลี่ยนเป็น picked_up หรือ delivering
    IF new_status IN ('picked_up', 'delivering') THEN
        IF order_info.rider_id IS NOT NULL THEN
            SELECT user_id INTO rider_uuid
            FROM riders 
            WHERE id = order_info.rider_id;
            
            IF rider_uuid IS NOT NULL THEN
                PERFORM send_notification(
                    rider_uuid,
                    CASE 
                        WHEN new_status = 'picked_up' THEN 'อัปเดตสถานะงาน'
                        WHEN new_status = 'delivering' THEN 'เริ่มจัดส่ง'
                        ELSE 'อัปเดตสถานะงาน'
                    END,
                    CASE 
                        WHEN new_status = 'picked_up' THEN 'คุณได้รับอาหารจากร้านค้าแล้ว'
                        WHEN new_status = 'delivering' THEN 'คุณได้เริ่มการจัดส่งแล้ว'
                        ELSE 'สถานะงานของคุณได้อัปเดตเป็น: ' || new_status
                    END,
                    'order_update',
                    jsonb_build_object(
                        'order_id', order_uuid,
                        'order_number', order_info.order_number,
                        'status', new_status
                    )
                );
            END IF;
        END IF;
    END IF;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_order_status(p_order_uuid uuid, p_new_status text, p_cancellation_reason text, p_updated_by_user_id uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    order_info RECORD;
    customer_uuid UUID;
    store_owner_uuid UUID;
    existing_notification_id UUID;
    rider_uuid UUID;
BEGIN
    -- ดึงข้อมูลออเดอร์
    SELECT * INTO order_info FROM orders WHERE id = p_order_uuid;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'ไม่พบออเดอร์ที่ระบุ: %', p_order_uuid;
    END IF;

    -- ดึงข้อมูลลูกค้าและเจ้าของร้าน
    customer_uuid := order_info.customer_id;
    SELECT owner_id INTO store_owner_uuid 
    FROM stores 
    WHERE id = order_info.store_id;

    -- อัปเดตสถานะออเดอร์
    UPDATE orders 
    SET 
        status = p_new_status,
        updated_at = NOW(),
        cancellation_reason = CASE 
            WHEN p_new_status = 'cancelled' THEN p_cancellation_reason
            ELSE order_info.cancellation_reason
        END,
        cancelled_by = CASE 
            WHEN p_new_status = 'cancelled' THEN p_updated_by_user_id
            ELSE order_info.cancelled_by
        END,
        cancelled_at = CASE 
            WHEN p_new_status = 'cancelled' THEN NOW()
            ELSE order_info.cancelled_at
        END
    WHERE id = p_order_uuid;

    -- เพิ่มประวัติการเปลี่ยนแปลงสถานะ
    INSERT INTO order_status_history (order_id, status, updated_by, cancellation_reason)
    VALUES (p_order_uuid, p_new_status, p_updated_by_user_id, p_cancellation_reason);

    -- แจ้งเตือนตามสถานะ
    IF p_new_status = 'cancelled' THEN
        SELECT id INTO existing_notification_id
        FROM notifications 
        WHERE user_id = customer_uuid
          AND type = 'order_update'
          AND data->>'order_id' = p_order_uuid::text
          AND data->>'status' = 'cancelled'
          AND created_at > NOW() - INTERVAL '1 minute'
        LIMIT 1;

        IF existing_notification_id IS NULL THEN
            PERFORM send_notification(
                customer_uuid,
                'ออเดอร์ถูกยกเลิก',
                'ออเดอร์ของคุณถูกยกเลิกแล้ว: ' || COALESCE(p_cancellation_reason, 'ไม่มีเหตุผล'),
                'order_update',
                jsonb_build_object(
                    'order_id', p_order_uuid,
                    'order_number', order_info.order_number,
                    'status', p_new_status,
                    'cancellation_reason', p_cancellation_reason
                )
            );
        END IF;

        IF store_owner_uuid IS NOT NULL THEN
            SELECT id INTO existing_notification_id
            FROM notifications 
            WHERE user_id = store_owner_uuid
              AND type = 'order_update'
              AND data->>'order_id' = p_order_uuid::text
              AND data->>'status' = 'cancelled'
              AND created_at > NOW() - INTERVAL '1 minute'
            LIMIT 1;

            IF existing_notification_id IS NULL THEN
                PERFORM send_notification(
                    store_owner_uuid,
                    'ลูกค้ายกเลิกออเดอร์ #' || order_info.order_number,
                    'ลูกค้าได้ยกเลิกออเดอร์ #' || order_info.order_number || ': ' || COALESCE(p_cancellation_reason, 'ไม่มีเหตุผล'),
                    'order_update',
                    jsonb_build_object(
                        'order_id', p_order_uuid,
                        'order_number', order_info.order_number,
                        'status', p_new_status,
                        'cancellation_reason', p_cancellation_reason
                    )
                );
            END IF;
        END IF;

    ELSE
        PERFORM send_notification(
            customer_uuid,
            CASE 
                WHEN p_new_status = 'accepted' THEN 'ร้านค้ารับออเดอร์แล้ว'
                WHEN p_new_status = 'preparing' THEN 'ร้านค้ากำลังเตรียมอาหาร'
                WHEN p_new_status = 'ready' THEN 'อาหารพร้อมส่ง'
                WHEN p_new_status = 'assigned' THEN 'ไรเดอร์รับงานแล้ว'
                WHEN p_new_status = 'picked_up' THEN 'ไรเดอร์รับอาหารแล้ว'
                WHEN p_new_status = 'delivering' THEN 'ไรเดอร์กำลังจัดส่ง'
                WHEN p_new_status = 'delivered' THEN 'จัดส่งสำเร็จ'
                ELSE 'อัปเดตสถานะออเดอร์'
            END,
            CASE 
                WHEN p_new_status = 'accepted' THEN 'ร้านค้าได้ยืนยันการรับออเดอร์ของคุณแล้ว'
                WHEN p_new_status = 'preparing' THEN 'ร้านค้ากำลังเตรียมอาหารให้คุณ'
                WHEN p_new_status = 'ready' THEN 'อาหารของคุณพร้อมส่งแล้ว ไรเดอร์จะมารับเร็วๆ นี้'
                WHEN p_new_status = 'assigned' THEN 'ไรเดอร์ได้รับงานของคุณแล้ว และกำลังเดินทางมาส่ง'
                WHEN p_new_status = 'picked_up' THEN 'ไรเดอร์ได้รับอาหารจากร้านค้าแล้ว'
                WHEN p_new_status = 'delivering' THEN 'ไรเดอร์กำลังจัดส่งอาหารให้คุณ'
                WHEN p_new_status = 'delivered' THEN 'อาหารของคุณจัดส่งสำเร็จแล้ว กรุณาให้คะแนน'
                ELSE 'สถานะออเดอร์ของคุณได้อัปเดตเป็น: ' || p_new_status
            END,
            'order_update',
            jsonb_build_object(
                'order_id', p_order_uuid,
                'order_number', order_info.order_number,
                'status', p_new_status
            )
        );
    END IF;

    IF p_new_status = 'ready' THEN
        IF EXISTS (
            SELECT 1 FROM riders 
            WHERE is_available = true 
              AND documents_verified = true
        ) THEN
            PERFORM send_notification(
                (SELECT user_id FROM riders 
                 WHERE is_available = true 
                   AND documents_verified = true 
                 LIMIT 1),
                'มีออเดอร์ใหม่',
                'มีออเดอร์ใหม่จากร้าน ' || (SELECT name FROM stores WHERE id = order_info.store_id) || ' พร้อมส่งแล้ว',
                'order_update',
                jsonb_build_object(
                    'order_id', p_order_uuid,
                    'store_id', order_info.store_id,
                    'delivery_fee', order_info.delivery_fee,
                    'status', 'ready'
                )
            );
        END IF;
    END IF;

    IF p_new_status = 'assigned' THEN
        IF store_owner_uuid IS NOT NULL THEN
            SELECT user_id INTO rider_uuid
            FROM riders 
            WHERE id = order_info.rider_id;

            PERFORM send_notification(
                store_owner_uuid,
                'ไรเดอร์รับงานแล้ว',
                'ไรเดอร์ได้รับงานหมายเลข #' || order_info.order_number || ' แล้ว',
                'order_update',
                jsonb_build_object(
                    'order_id', p_order_uuid,
                    'order_number', order_info.order_number,
                    'status', p_new_status,
                    'rider_id', order_info.rider_id
                )
            );
        END IF;
    END IF;

    IF p_new_status IN ('picked_up', 'delivering') THEN
        IF order_info.rider_id IS NOT NULL THEN
            SELECT user_id INTO rider_uuid
            FROM riders 
            WHERE id = order_info.rider_id;

            IF rider_uuid IS NOT NULL THEN
                PERFORM send_notification(
                    rider_uuid,
                    CASE 
                        WHEN p_new_status = 'picked_up' THEN 'อัปเดตสถานะงาน'
                        WHEN p_new_status = 'delivering' THEN 'เริ่มจัดส่ง'
                        ELSE 'อัปเดตสถานะงาน'
                    END,
                    CASE 
                        WHEN p_new_status = 'picked_up' THEN 'คุณได้รับอาหารจากร้านค้าแล้ว'
                        WHEN p_new_status = 'delivering' THEN 'คุณได้เริ่มการจัดส่งแล้ว'
                        ELSE 'สถานะงานของคุณได้อัปเดตเป็น: ' || p_new_status
                    END,
                    'order_update',
                    jsonb_build_object(
                        'order_id', p_order_uuid,
                        'order_number', order_info.order_number,
                        'status', p_new_status
                    )
                );
            END IF;
        END IF;
    END IF;

END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_product_option_values_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_product_options_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_rider_assignment_status(assignment_uuid uuid, new_status text, notes text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    order_uuid UUID;
    rider_uuid UUID;
    customer_uuid UUID;
    store_owner_uuid UUID;
BEGIN
    -- ดึงข้อมูลที่จำเป็น
    SELECT order_id, rider_id INTO order_uuid, rider_uuid 
    FROM rider_assignments WHERE id = assignment_uuid;
    
    -- อัปเดตสถานะงาน (ใช้ EXCEPTION เพื่อจัดการกรณีที่ไม่มีคอลัมน์ cancellation_reason)
    BEGIN
        UPDATE rider_assignments 
        SET 
            status = new_status,
            updated_at = NOW(),
            picked_up_at = CASE WHEN new_status = 'picked_up' THEN NOW() ELSE picked_up_at END,
            started_delivery_at = CASE WHEN new_status = 'delivering' THEN NOW() ELSE started_delivery_at END,
            completed_at = CASE WHEN new_status = 'completed' THEN NOW() ELSE completed_at END,
            cancelled_at = CASE WHEN new_status = 'cancelled' THEN NOW() ELSE cancelled_at END,
            cancellation_reason = CASE WHEN new_status = 'cancelled' THEN notes ELSE cancellation_reason END
        WHERE id = assignment_uuid;
    EXCEPTION
        WHEN undefined_column THEN
            -- ถ้าคอลัมน์ cancellation_reason ไม่มี ให้อัปเดตแบบไม่มีคอลัมน์นั้น
            UPDATE rider_assignments 
            SET 
                status = new_status,
                updated_at = NOW(),
                picked_up_at = CASE WHEN new_status = 'picked_up' THEN NOW() ELSE picked_up_at END,
                started_delivery_at = CASE WHEN new_status = 'delivering' THEN NOW() ELSE started_delivery_at END,
                completed_at = CASE WHEN new_status = 'completed' THEN NOW() ELSE completed_at END,
                cancelled_at = CASE WHEN new_status = 'cancelled' THEN NOW() ELSE cancelled_at END
            WHERE id = assignment_uuid;
    END;
    
    -- อัปเดตสถานะคำสั่งซื้อ
    UPDATE orders 
    SET 
        status = CASE 
            WHEN new_status = 'picked_up' THEN 'picked_up'
            WHEN new_status = 'delivering' THEN 'delivering'
            WHEN new_status = 'completed' THEN 'delivered'
            WHEN new_status = 'cancelled' THEN 'cancelled'
        END,
        updated_at = NOW(),
        actual_delivery_time = CASE WHEN new_status = 'completed' THEN NOW() ELSE actual_delivery_time END
    WHERE id = order_uuid;
    
    -- เพิ่มประวัติการเปลี่ยนแปลงสถานะ (ถ้าตารางมีอยู่)
    BEGIN
        INSERT INTO order_status_history (order_id, status, updated_by, notes)
        VALUES (order_uuid, 
            CASE 
                WHEN new_status = 'picked_up' THEN 'picked_up'
                WHEN new_status = 'delivering' THEN 'delivering'
                WHEN new_status = 'completed' THEN 'delivered'
                WHEN new_status = 'cancelled' THEN 'cancelled'
            END,
            (SELECT user_id FROM riders WHERE id = rider_uuid),
            notes
        );
    EXCEPTION
        WHEN undefined_table THEN
            NULL;
    END;
    
    -- สร้างการแจ้งเตือน (ถ้าตารางมีอยู่)
    BEGIN
        SELECT customer_id, (SELECT owner_id FROM stores WHERE id = store_id) 
        INTO customer_uuid, store_owner_uuid 
        FROM orders WHERE id = order_uuid;
        
        -- แจ้งเตือนลูกค้า
        PERFORM send_notification(
            customer_uuid,
            CASE 
                WHEN new_status = 'picked_up' THEN 'ไดเดอร์ไปรับอาหารแล้ว'
                WHEN new_status = 'delivering' THEN 'ไดเดอร์กำลังจัดส่ง'
                WHEN new_status = 'completed' THEN 'จัดส่งสำเร็จ'
                WHEN new_status = 'cancelled' THEN 'การจัดส่งถูกยกเลิก'
            END,
            CASE 
                WHEN new_status = 'picked_up' THEN 'ไดเดอร์ได้ไปรับอาหารจากร้านค้าแล้ว'
                WHEN new_status = 'delivering' THEN 'ไดเดอร์กำลังจัดส่งอาหารให้คุณ'
                WHEN new_status = 'completed' THEN 'อาหารของคุณจัดส่งสำเร็จแล้ว กรุณาให้คะแนน'
                WHEN new_status = 'cancelled' THEN 'การจัดส่งถูกยกเลิก: ' || COALESCE(notes, 'ไม่มีเหตุผล')
            END,
            'delivery_status',
            jsonb_build_object('order_id', order_uuid, 'status', new_status)
        );
        
        -- แจ้งเตือนร้านค้า
        PERFORM send_notification(
            store_owner_uuid,
            CASE 
                WHEN new_status = 'picked_up' THEN 'ไดเดอร์รับอาหารแล้ว'
                WHEN new_status = 'delivering' THEN 'ไดเดอร์กำลังจัดส่ง'
                WHEN new_status = 'completed' THEN 'จัดส่งสำเร็จ'
                WHEN new_status = 'cancelled' THEN 'การจัดส่งถูกยกเลิก'
            END,
            CASE 
                WHEN new_status = 'picked_up' THEN 'ไดเดอร์ได้รับอาหารจากร้านค้าแล้ว'
                WHEN new_status = 'delivering' THEN 'ไดเดอร์กำลังจัดส่งอาหาร'
                WHEN new_status = 'completed' THEN 'การจัดส่งเสร็จสิ้นแล้ว'
                WHEN new_status = 'cancelled' THEN 'การจัดส่งถูกยกเลิก: ' || COALESCE(notes, 'ไม่มีเหตุผล')
            END,
            'delivery_status',
            jsonb_build_object('order_id', order_uuid, 'status', new_status)
        );
    EXCEPTION
        WHEN undefined_table THEN
            NULL;
    END;
    
    -- อัปเดตสถิติไดเดอร์เมื่องานเสร็จสิ้น
    IF new_status = 'completed' THEN
        BEGIN
            UPDATE riders 
            SET 
                total_deliveries = total_deliveries + 1,
                total_earnings = total_earnings + (SELECT delivery_fee FROM orders WHERE id = order_uuid),
                updated_at = NOW()
            WHERE id = rider_uuid;
        EXCEPTION
            WHEN undefined_column THEN
                NULL;
        END;
    END IF;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_rider_fcm_tokens_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_rider_location(rider_user_id uuid, new_latitude numeric, new_longitude numeric)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE riders 
    SET 
        current_location = point(new_longitude, new_latitude),
        updated_at = NOW()
    WHERE user_id = rider_user_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_rider_rating(p_rider_id uuid, p_new_rating numeric)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE public.riders 
    SET 
        total_ratings = total_ratings + 1,
        rating = (
            (rating * total_ratings + p_new_rating) / (total_ratings + 1)
        ),
        updated_at = NOW()
    WHERE id = p_rider_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_rider_reviews_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_rider_stats_on_delivery()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- ตรวจสอบว่าสถานะเปลี่ยนเป็น 'delivered' หรือไม่
    IF NEW.status = 'delivered' AND (OLD.status IS NULL OR OLD.status != 'delivered') THEN
        -- อัปเดตข้อมูลในตาราง riders
        UPDATE public.riders 
        SET 
            total_deliveries = total_deliveries + 1,
            total_earnings = total_earnings + (
                SELECT COALESCE(delivery_fee, 0) 
                FROM public.orders 
                WHERE id = NEW.order_id
            ),
            updated_at = NOW()
        WHERE id = NEW.rider_id;
    END IF;
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_store_location()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF NEW.latitude IS NOT NULL AND NEW.longitude IS NOT NULL THEN
        NEW.location = ST_SetSRID(ST_MakePoint(NEW.longitude, NEW.latitude), 4326)::geography;
    ELSE
        NEW.location = NULL;
    END IF;
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_store_open_status()
 RETURNS TABLE(store_id uuid, store_name text, old_status boolean, new_status boolean, opening_hours jsonb, current_time_value time without time zone, action_taken text)
 LANGUAGE plpgsql
AS $function$
DECLARE
    store_record RECORD;
    current_time_value TIME;
    opening_time TEXT;
    closing_time TEXT;
    should_be_open BOOLEAN;
BEGIN
    -- ตั้งค่าเวลาปัจจุบัน (เวลาไทย UTC+7)
    current_time_value := (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Bangkok')::TIME;
    
    -- วนลูปผ่านร้านทั้งหมดที่ active และไม่ถูกระงับ
    FOR store_record IN 
        SELECT 
            id,
            name,
            is_open,
            stores.opening_hours,
            stores.is_active,
            stores.is_suspended,
            stores.is_auto_open
        FROM stores 
        WHERE stores.is_active = true 
        AND stores.is_suspended = false
        AND stores.is_auto_open = true
    LOOP
        should_be_open := false;
        
        -- ตรวจสอบว่ามี opening_hours หรือไม่
        IF store_record.opening_hours IS NOT NULL THEN
            -- ทำความสะอาด opening_hours (แปลง JSON เป็น TEXT และลบ quotes)
            DECLARE
                clean_hours TEXT;
            BEGIN
                clean_hours := store_record.opening_hours::TEXT;
                -- ลบ quotes ที่ซ้อนกันออก
                clean_hours := replace(clean_hours, '"""', '');
                clean_hours := replace(clean_hours, '"', '');
                
                -- แยกเวลาเปิดและปิดจากรูปแบบ "08:00-17:40"
                IF position('-' in clean_hours) > 0 THEN
                    opening_time := split_part(clean_hours, '-', 1);
                    closing_time := split_part(clean_hours, '-', 2);
                    
                    -- ตรวจสอบว่าเวลาเปิดปิดถูกต้อง
                    IF opening_time IS NOT NULL AND closing_time IS NOT NULL THEN
                        -- ตรวจสอบว่าเวลาปัจจุบันอยู่ในช่วงเปิดร้านหรือไม่
                        IF current_time_value >= opening_time::TIME AND current_time_value <= closing_time::TIME THEN
                            should_be_open := true;
                        END IF;
                    END IF;
                END IF;
            END;
        END IF;
        
        -- อัปเดตสถานะถ้าต่างจากเดิม
        IF store_record.is_open != should_be_open THEN
            UPDATE stores 
            SET 
                is_open = should_be_open,
                updated_at = NOW()
            WHERE id = store_record.id;
            
            -- คืนค่าข้อมูลที่ถูกอัปเดต
            RETURN QUERY SELECT 
                store_record.id,
                store_record.name,
                store_record.is_open,
                should_be_open,
                store_record.opening_hours,
                current_time_value,
                CASE 
                    WHEN should_be_open THEN 'เปิดร้านอัตโนมัติ'
                    ELSE 'ปิดร้านอัตโนมัติ'
                END;
        END IF;
    END LOOP;
    
    RETURN;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_task_progress_on_event()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_user_id uuid;
    v_event_type text;
    v_tasks RECORD;
    v_progress RECORD;
    v_reset_period_start timestamp with time zone;
    v_new_progress integer;
    v_is_first_order boolean;
BEGIN
    -- กำหนด event type และ user_id ตามประเภท trigger
    IF TG_TABLE_NAME = 'orders' THEN
        -- ORDER_DELIVERED event
        IF NEW.status = 'delivered' AND (OLD.status IS DISTINCT FROM 'delivered') AND NEW.customer_id IS NOT NULL THEN
            v_user_id := NEW.customer_id;
            v_event_type := 'ORDER_DELIVERED';
            
            -- ตรวจสอบว่าคือออเดอร์แรกหรือไม่
            SELECT NOT EXISTS (
                SELECT 1 FROM public.orders 
                WHERE customer_id = NEW.customer_id 
                AND status = 'delivered' 
                AND id != NEW.id
            ) INTO v_is_first_order;
        ELSE
            RETURN NEW;
        END IF;
    ELSIF TG_TABLE_NAME = 'order_reviews' THEN
        -- REVIEW_CREATED event
        IF TG_OP = 'INSERT' THEN
            v_user_id := NEW.customer_id;
            v_event_type := 'REVIEW_CREATED';
        ELSE
            RETURN NEW;
        END IF;
    ELSE
        RETURN NEW;
    END IF;

    -- ดึงภารกิจที่เกี่ยวข้องกับ event นี้
    FOR v_tasks IN 
        SELECT id, task_code, points_reward, max_progress, reset_frequency, task_type, conditions
        FROM public.loyalty_tasks
        WHERE trigger_event = v_event_type
          AND is_active = true
          AND (effective_from IS NULL OR effective_from <= now())
          AND (effective_to IS NULL OR effective_to >= now())
    LOOP
        -- ตรวจสอบเงื่อนไขเพิ่มเติม
        IF v_event_type = 'ORDER_DELIVERED' THEN
            -- ตรวจสอบ first order สำหรับ SPECIAL_FIRST_ORDER
            IF v_tasks.task_code = 'SPECIAL_FIRST_ORDER' AND NOT v_is_first_order THEN
                CONTINUE;
            END IF;
            
            -- ตรวจสอบ conditions ถ้ามี (เช่น min_amount)
            IF v_tasks.conditions ? 'min_amount' THEN
                IF NEW.total_amount < (v_tasks.conditions->>'min_amount')::numeric THEN
                    CONTINUE;
                END IF;
            END IF;
        END IF;

        -- คำนวณ reset_period_start ตาม reset_frequency
        v_reset_period_start := CASE v_tasks.reset_frequency
            WHEN 'daily' THEN date_trunc('day', now())
            WHEN 'weekly' THEN date_trunc('week', now())
            WHEN 'monthly' THEN date_trunc('month', now())
            WHEN 'never' THEN '1970-01-01'::timestamp with time zone
            ELSE now()
        END;

        -- ดึงหรือสร้างความคืบหน้า
        SELECT * INTO v_progress
        FROM public.user_task_progress
        WHERE user_id = v_user_id
          AND task_id = v_tasks.id
          AND reset_period_start = v_reset_period_start;

        -- ถ้ายังไม่มี ให้สร้างใหม่
        IF NOT FOUND THEN
            -- สร้าง progress ใหม่
            INSERT INTO public.user_task_progress (
                user_id,
                task_id,
                progress,
                max_progress,
                reset_period_start
            )
            VALUES (
                v_user_id,
                v_tasks.id,
                1,
                v_tasks.max_progress,
                v_reset_period_start
            )
            ON CONFLICT (user_id, task_id, reset_period_start) DO UPDATE
            SET progress = LEAST(user_task_progress.progress + 1, v_tasks.max_progress),
                updated_at = now()
            RETURNING * INTO v_progress;
            
            -- ดึง progress หลัง INSERT เพื่อเช็คสถานะ
            IF NOT FOUND THEN
                SELECT * INTO v_progress
                FROM public.user_task_progress
                WHERE user_id = v_user_id
                  AND task_id = v_tasks.id
                  AND reset_period_start = v_reset_period_start;
            END IF;
            
            -- เช็คว่าถึง max_progress แล้วหรือยัง (สำหรับกรณีที่ max_progress = 1)
            IF v_progress.progress >= v_tasks.max_progress AND NOT v_progress.points_awarded THEN
                UPDATE public.user_task_progress
                SET is_completed = true,
                    completed_at = now(),
                    points_awarded = true,
                    points_awarded_at = now()
                WHERE id = v_progress.id;

                -- ให้แต้มใน loyalty_point_ledger
                INSERT INTO public.loyalty_point_ledger (
                    user_id,
                    transaction_type,
                    points_change,
                    reason_code,
                    description
                )
                VALUES (
                    v_user_id,
                    'earn',
                    v_tasks.points_reward,
                    v_tasks.task_code,
                    'Completed task: ' || v_tasks.task_code
                );
            END IF;
        ELSE
            -- อัปเดตความคืบหน้า
            v_new_progress := LEAST(v_progress.progress + 1, v_tasks.max_progress);
            
            UPDATE public.user_task_progress
            SET progress = v_new_progress,
                updated_at = now()
            WHERE id = v_progress.id;
            
            -- ถ้าภารกิจสำเร็จและยังไม่ได้ให้แต้ม ให้แต้ม
            IF v_new_progress >= v_tasks.max_progress AND NOT v_progress.points_awarded THEN
                UPDATE public.user_task_progress
                SET is_completed = true,
                    completed_at = now(),
                    points_awarded = true,
                    points_awarded_at = now()
                WHERE id = v_progress.id;

                -- ให้แต้มใน loyalty_point_ledger
                INSERT INTO public.loyalty_point_ledger (
                    user_id,
                    transaction_type,
                    points_change,
                    reason_code,
                    description
                )
                VALUES (
                    v_user_id,
                    'earn',
                    v_tasks.points_reward,
                    v_tasks.task_code,
                    'Completed task: ' || v_tasks.task_code
                );
            END IF;
        END IF;
    END LOOP;

    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_user_delivery_location(user_id_param uuid, latitude_param numeric, longitude_param numeric, address_param text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE users 
    SET 
        latitude = latitude_param,
        longitude = longitude_param,
        address = COALESCE(address_param, address),
        updated_at = NOW()
    WHERE id = user_id_param;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'User not found with ID: %', user_id_param;
    END IF;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_user_login_info(google_id_param text)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    user_id UUID;
BEGIN
    UPDATE users 
    SET 
        last_login_at = NOW(),
        login_count = login_count + 1,
        updated_at = NOW()
    WHERE google_id = google_id_param
    RETURNING id INTO user_id;
    
    IF user_id IS NULL THEN
        RAISE EXCEPTION 'User not found with Google ID: %', google_id_param;
    END IF;
    
    RETURN user_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_user_profile(phone_param text DEFAULT NULL::text, line_id_param text DEFAULT NULL::text, address_param text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    UPDATE public.users 
    SET 
        phone = COALESCE(phone_param, phone),
        line_id = COALESCE(line_id_param, line_id),
        address = COALESCE(address_param, address),
        updated_at = NOW()
    WHERE id = auth.uid();
    
    -- ส่งการแจ้งเตือน
    PERFORM send_notification(
        auth.uid(),
        'ข้อมูลโปรไฟล์ได้รับการอัปเดต',
        'ข้อมูลโปรไฟล์ของคุณได้รับการอัปเดตเรียบร้อยแล้ว',
        'system',
        jsonb_build_object('updated_fields', jsonb_build_object(
            'phone', phone_param IS NOT NULL,
            'line_id', line_id_param IS NOT NULL,
            'address', address_param IS NOT NULL
        ))
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_user_profile(user_id_param uuid, phone_param text DEFAULT NULL::text, line_id_param text DEFAULT NULL::text, address_param text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE users 
    SET 
        phone = COALESCE(phone_param, phone),
        line_id = COALESCE(line_id_param, line_id),
        address = COALESCE(address_param, address),
        updated_at = NOW()
    WHERE id = user_id_param;
    
    -- ส่งการแจ้งเตือน
    PERFORM send_notification(
        user_id_param,
        'ข้อมูลโปรไฟล์ได้รับการอัปเดต',
        'ข้อมูลโปรไฟล์ของคุณได้รับการอัปเดตเรียบร้อยแล้ว',
        'system',
        jsonb_build_object('updated_fields', jsonb_build_object(
            'phone', phone_param IS NOT NULL,
            'line_id', line_id_param IS NOT NULL,
            'address', address_param IS NOT NULL
        ))
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_user_profile(user_id_param uuid, phone_param text DEFAULT NULL::text, line_id_param text DEFAULT NULL::text, address_param text DEFAULT NULL::text, latitude_param numeric DEFAULT NULL::numeric, longitude_param numeric DEFAULT NULL::numeric)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE users 
    SET 
        phone = COALESCE(phone_param, phone),
        line_id = COALESCE(line_id_param, line_id),
        address = COALESCE(address_param, address),
        latitude = COALESCE(latitude_param, latitude),
        longitude = COALESCE(longitude_param, longitude),
        updated_at = NOW()
    WHERE id = user_id_param;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'User not found with ID: %', user_id_param;
    END IF;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_user_role(new_role text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    -- ตรวจสอบบทบาทที่ถูกต้อง
    IF new_role NOT IN ('customer', 'store_owner', 'rider', 'admin') THEN
        RAISE EXCEPTION 'Invalid role: %', new_role;
    END IF;
    
    -- อัปเดตบทบาท
    UPDATE public.users 
    SET 
        role = new_role,
        updated_at = NOW()
    WHERE id = auth.uid();
    
    -- ส่งการแจ้งเตือน
    PERFORM send_notification(
        auth.uid(),
        'บทบาทได้รับการอัปเดต',
        'บทบาทของคุณได้รับการอัปเดตเป็น: ' || 
        CASE 
            WHEN new_role = 'customer' THEN 'ลูกค้า'
            WHEN new_role = 'store_owner' THEN 'เจ้าของร้านค้า'
            WHEN new_role = 'rider' THEN 'ไดเดอร์'
            WHEN new_role = 'admin' THEN 'ผู้ดูแลระบบ'
        END,
        'system',
        jsonb_build_object('new_role', new_role)
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_user_role(user_id_param uuid, new_role text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- ตรวจสอบบทบาทที่ถูกต้อง
    IF new_role NOT IN ('customer', 'store_owner', 'rider', 'admin') THEN
        RAISE EXCEPTION 'Invalid role: %', new_role;
    END IF;
    
    -- อัปเดตบทบาท
    UPDATE users 
    SET 
        role = new_role,
        updated_at = NOW()
    WHERE id = user_id_param;
    
    -- ส่งการแจ้งเตือน
    PERFORM send_notification(
        user_id_param,
        'บทบาทได้รับการอัปเดต',
        'บทบาทของคุณได้รับการอัปเดตเป็น: ' || 
        CASE 
            WHEN new_role = 'customer' THEN 'ลูกค้า'
            WHEN new_role = 'store_owner' THEN 'เจ้าของร้านค้า'
            WHEN new_role = 'rider' THEN 'ไดเดอร์'
            WHEN new_role = 'admin' THEN 'ผู้ดูแลระบบ'
        END,
        'system',
        jsonb_build_object('new_role', new_role)
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_window_allocation()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO delivery_window_allocations (delivery_date, delivery_window_id, max_orders, current_orders)
    SELECT NEW.scheduled_delivery_date, NEW.delivery_window_id, dw.max_orders, 1
    FROM delivery_windows dw
    WHERE dw.id = NEW.delivery_window_id
    ON CONFLICT (delivery_date, delivery_window_id)
    DO UPDATE SET current_orders = delivery_window_allocations.current_orders + 1;
    
  ELSIF TG_OP = 'UPDATE' AND OLD.delivery_window_id != NEW.delivery_window_id THEN
    UPDATE delivery_window_allocations
    SET current_orders = current_orders - 1
    WHERE delivery_date = OLD.scheduled_delivery_date
      AND delivery_window_id = OLD.delivery_window_id;
    
    INSERT INTO delivery_window_allocations (delivery_date, delivery_window_id, max_orders, current_orders)
    SELECT NEW.scheduled_delivery_date, NEW.delivery_window_id, dw.max_orders, 1
    FROM delivery_windows dw
    WHERE dw.id = NEW.delivery_window_id
    ON CONFLICT (delivery_date, delivery_window_id)
    DO UPDATE SET current_orders = delivery_window_allocations.current_orders + 1;
    
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE delivery_window_allocations
    SET current_orders = current_orders - 1
    WHERE delivery_date = OLD.scheduled_delivery_date
      AND delivery_window_id = OLD.delivery_window_id;
  END IF;
  
  RETURN COALESCE(NEW, OLD);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.upload_ads_image(ads_id_param uuid, original_file_name text, file_size integer DEFAULT NULL::integer, mime_type text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    ads_record RECORD;
    new_file_name TEXT;
    file_path TEXT;
    result JSONB;
BEGIN
    -- ตรวจสอบว่า ads มีอยู่จริง
    SELECT * INTO ads_record 
    FROM public.ads 
    WHERE id = ads_id_param;
    
    IF ads_record IS NULL THEN
        RAISE EXCEPTION 'Ads not found';
    END IF;
    
    -- สร้างชื่อไฟล์ใหม่
    new_file_name := public.generate_file_name(original_file_name, 'ads');
    
    -- สร้าง path (ใช้รูปแบบ ads-(date)/filename)
    file_path := public.generate_file_path(auth.uid(), 'ads', new_file_name);
    
    -- อัปเดตรูปภาพ ads
    UPDATE public.ads 
    SET 
        image_url = file_path,
        updated_at = NOW()
    WHERE id = ads_id_param;
    
    result := jsonb_build_object(
        'success', true,
        'ads_id', ads_id_param,
        'file_name', new_file_name,
        'file_path', file_path,
        'bucket', 'ads-images',
        'message', 'Ads image uploaded successfully'
    );
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.upload_payment_slip(order_id_param uuid, original_file_name text, file_size integer DEFAULT NULL::integer, mime_type text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    order_record RECORD;
    new_file_name TEXT;
    file_path TEXT;
    result JSONB;
BEGIN
    -- ตรวจสอบว่าเป็นเจ้าของออเดอร์
    SELECT * INTO order_record 
    FROM public.orders 
    WHERE id = order_id_param AND customer_id = auth.uid();
    
    IF order_record IS NULL THEN
        RAISE EXCEPTION 'Order not found or unauthorized';
    END IF;
    
    -- สร้างชื่อไฟล์ใหม่
    new_file_name := public.generate_file_name(original_file_name, 'payment_slip');
    
    -- สร้าง path
    file_path := public.generate_file_path(auth.uid(), 'payment_slip', new_file_name, order_id_param);
    
    -- อัปเดตสลิปการโอนเงิน
    UPDATE public.orders 
    SET 
        transfer_slip_url = file_path,
        updated_at = NOW()
    WHERE id = order_id_param;
    
    result := jsonb_build_object(
        'success', true,
        'order_id', order_id_param,
        'file_name', new_file_name,
        'file_path', file_path,
        'bucket', 'payment-slips',
        'message', 'Payment slip uploaded successfully'
    );
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.upload_product_image(product_id_param uuid, original_file_name text, file_size integer DEFAULT NULL::integer, mime_type text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    product_record RECORD;
    new_file_name TEXT;
    file_path TEXT;
    result JSONB;
BEGIN
    -- ตรวจสอบว่าเป็นเจ้าของสินค้า
    SELECT p.*, s.owner_id INTO product_record 
    FROM public.products p
    JOIN public.stores s ON p.store_id = s.id
    WHERE p.id = product_id_param AND s.owner_id = auth.uid();
    
    IF product_record IS NULL THEN
        RAISE EXCEPTION 'Product not found or unauthorized';
    END IF;
    
    -- สร้างชื่อไฟล์ใหม่
    new_file_name := public.generate_product_image_name(original_file_name);
    
    -- สร้าง path
    file_path := public.generate_product_image_path(
        product_record.store_id, 
        product_id_param, 
        new_file_name
    );
    
    -- อัปเดตรูปสินค้า
    UPDATE public.products 
    SET 
        image_url = file_path,
        updated_at = NOW()
    WHERE id = product_id_param;
    
    result := jsonb_build_object(
        'success', true,
        'product_id', product_id_param,
        'store_id', product_record.store_id,
        'file_name', new_file_name,
        'file_path', file_path,
        'bucket', 'product-images',
        'message', 'Product image uploaded successfully'
    );
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.upload_rider_document(document_type_param text, original_file_name text, file_size integer DEFAULT NULL::integer, mime_type text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    rider_record RECORD;
    document_id UUID;
    new_file_name TEXT;
    file_path TEXT;
    result JSONB;
BEGIN
    -- ตรวจสอบว่าเป็นไดเดอร์
    SELECT * INTO rider_record 
    FROM public.riders 
    WHERE user_id = auth.uid();
    
    IF rider_record IS NULL THEN
        RAISE EXCEPTION 'Rider profile not found';
    END IF;
    
    -- สร้างชื่อไฟล์ใหม่
    new_file_name := public.generate_file_name(original_file_name, 'document');
    
    -- สร้าง path
    file_path := public.generate_file_path(auth.uid(), 'document', new_file_name);
    
    -- สร้างเอกสารใหม่
    INSERT INTO public.rider_documents (
        rider_id,
        document_type,
        file_url,
        file_name,
        file_size,
        mime_type
    )
    VALUES (
        rider_record.id,
        document_type_param,
        file_path,
        new_file_name,
        file_size,
        mime_type
    )
    RETURNING id INTO document_id;
    
    result := jsonb_build_object(
        'success', true,
        'document_id', document_id,
        'rider_id', rider_record.id,
        'document_type', document_type_param,
        'file_name', new_file_name,
        'file_path', file_path,
        'bucket', 'rider-documents',
        'message', 'Document uploaded successfully'
    );
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.upload_rider_document(rider_uuid uuid, document_type text, file_url text, file_name text DEFAULT NULL::text, file_size integer DEFAULT NULL::integer, mime_type text DEFAULT NULL::text)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    document_id UUID;
BEGIN
    -- ตรวจสอบว่าเป็นผู้ใช้ที่ถูกต้อง
    IF NOT EXISTS (
        SELECT 1 FROM riders 
        WHERE id = rider_uuid 
        AND user_id = auth.uid()
    ) THEN
        RAISE EXCEPTION 'You are not authorized to upload documents for this rider';
    END IF;
    
    -- สร้างเอกสารใหม่
    INSERT INTO rider_documents (
        rider_id, 
        document_type, 
        file_url, 
        file_name, 
        file_size, 
        mime_type
    )
    VALUES (
        rider_uuid,
        document_type,
        file_url,
        file_name,
        file_size,
        mime_type
    )
    RETURNING id INTO document_id;
    
    -- เพิ่มประวัติการส่งเอกสาร
    INSERT INTO document_verification_history (
        document_id,
        rider_id,
        action,
        notes
    )
    VALUES (
        document_id,
        rider_uuid,
        'submitted',
        'Document uploaded: ' || document_type
    );
    
    -- ส่งการแจ้งเตือน
    PERFORM send_notification(
        (SELECT id FROM users WHERE role = 'admin' LIMIT 1),
        'เอกสารใหม่จากไดเดอร์',
        'ไดเดอร์อัปโหลดเอกสารใหม่: ' || document_type,
        'system',
        jsonb_build_object(
            'document_id', document_id,
            'rider_id', rider_uuid,
            'document_type', document_type
        )
    );
    
    RETURN document_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.upload_rider_document_pdf(rider_uuid uuid, document_type_param text, original_file_name text, file_size integer DEFAULT NULL::integer, mime_type text DEFAULT 'application/pdf'::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    document_id UUID;
    new_file_name TEXT;
    file_path TEXT;
    result JSONB;
BEGIN
    -- ตรวจสอบว่าเป็นไดเดอร์
    IF NOT EXISTS (
        SELECT 1 FROM riders 
        WHERE id = rider_uuid 
        AND user_id = auth.uid()
    ) THEN
        RAISE EXCEPTION 'You are not authorized to upload documents for this rider';
    END IF;
    
    -- ตรวจสอบประเภทเอกสาร
    IF document_type_param NOT IN (
        'driver_license', 'car_tax', 'id_card', 'rider_application'
    ) THEN
        RAISE EXCEPTION 'Invalid document type: %', document_type_param;
    END IF;
    
    -- สร้างชื่อไฟล์ใหม่
    new_file_name := document_type_param || '_' || 
                     EXTRACT(EPOCH FROM NOW())::BIGINT || '_' ||
                     gen_random_uuid()::TEXT || '.pdf';
    
    -- สร้าง path
    file_path := 'rider-images/' || rider_uuid::TEXT || '/doc/' || new_file_name;
    
    -- สร้างเอกสารใหม่
    INSERT INTO rider_documents (
        rider_id,
        document_type,
        file_url,
        file_name,
        file_size,
        mime_type
    )
    VALUES (
        rider_uuid,
        document_type_param,
        file_path,
        original_file_name,
        file_size,
        mime_type
    )
    RETURNING id INTO document_id;
    
    -- เพิ่มประวัติการส่งเอกสาร
    INSERT INTO document_verification_history (
        document_id,
        rider_id,
        action,
        notes
    )
    VALUES (
        document_id,
        rider_uuid,
        'submitted',
        'Document uploaded: ' || document_type_param
    );
    
    -- ส่งการแจ้งเตือนให้ admin
    PERFORM send_notification(
        (SELECT id FROM users WHERE role = 'admin' LIMIT 1),
        'เอกสารใหม่จากไรเดอร์',
        'ไรเดอร์อัปโหลดเอกสารใหม่: ' || document_type_param,
        'system',
        jsonb_build_object(
            'document_id', document_id,
            'rider_id', rider_uuid,
            'document_type', document_type_param,
            'file_name', original_file_name
        )
    );
    
    result := jsonb_build_object(
        'success', true,
        'document_id', document_id,
        'rider_id', rider_uuid,
        'document_type', document_type_param,
        'file_name', original_file_name,
        'file_path', file_path,
        'bucket', 'rider-images',
        'message', 'Document uploaded successfully'
    );
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.upload_store_category_image(category_id_param uuid, original_file_name text, file_size integer DEFAULT NULL::integer, mime_type text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    category_record RECORD;
    new_file_name TEXT;
    file_path TEXT;
    result JSONB;
BEGIN
    -- ตรวจสอบว่า category มีอยู่จริง
    SELECT * INTO category_record 
    FROM public.store_categories 
    WHERE id = category_id_param;
    
    IF category_record IS NULL THEN
        RAISE EXCEPTION 'Store category not found';
    END IF;
    
    -- สร้างชื่อไฟล์ใหม่
    new_file_name := public.generate_file_name(original_file_name, 'store_category');
    
    -- สร้าง path (ใช้รูปแบบ categoryId/filename)
    file_path := public.generate_file_path(auth.uid(), 'store_category', new_file_name, category_id_param);
    
    -- อัปเดตรูปภาพ category
    UPDATE public.store_categories 
    SET 
        icon_url = file_path,
        updated_at = NOW()
    WHERE id = category_id_param;
    
    result := jsonb_build_object(
        'success', true,
        'category_id', category_id_param,
        'file_name', new_file_name,
        'file_path', file_path,
        'bucket', 'store-categories-images',
        'message', 'Store category icon uploaded successfully'
    );
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.upload_store_image(store_id_param uuid, image_type text, original_file_name text, file_size integer DEFAULT NULL::integer, mime_type text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    store_record RECORD;
    new_file_name TEXT;
    file_path TEXT;
    result JSONB;
BEGIN
    -- ตรวจสอบว่าเป็นเจ้าของร้าน
    SELECT * INTO store_record 
    FROM public.stores 
    WHERE id = store_id_param AND owner_id = auth.uid();
    
    IF store_record IS NULL THEN
        RAISE EXCEPTION 'Store not found or unauthorized';
    END IF;
    
    -- สร้างชื่อไฟล์ใหม่
    new_file_name := public.generate_file_name(original_file_name, 'store_' || image_type);
    
    -- สร้าง path
    file_path := public.generate_file_path(auth.uid(), 'store_' || image_type, new_file_name, store_id_param);
    
    -- อัปเดตรูปภาพตามประเภท
    IF image_type = 'logo' THEN
        UPDATE public.stores 
        SET 
            logo_url = file_path,
            updated_at = NOW()
        WHERE id = store_id_param;
    ELSIF image_type = 'banner' THEN
        UPDATE public.stores 
        SET 
            banner_url = file_path,
            updated_at = NOW()
        WHERE id = store_id_param;
    ELSE
        RAISE EXCEPTION 'Invalid image type. Use "logo" or "banner"';
    END IF;
    
    result := jsonb_build_object(
        'success', true,
        'store_id', store_id_param,
        'image_type', image_type,
        'file_name', new_file_name,
        'file_path', file_path,
        'bucket', 'store-images',
        'message', 'Store image uploaded successfully'
    );
    
    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.upload_user_avatar(original_file_name text, file_size integer DEFAULT NULL::integer, mime_type text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    user_record RECORD;
    new_file_name TEXT;
    file_path TEXT;
    result JSONB;
BEGIN
    -- ดึงข้อมูลผู้ใช้ปัจจุบัน
    SELECT * INTO user_record 
    FROM public.users 
    WHERE id = auth.uid();
    
    IF user_record IS NULL THEN
        RAISE EXCEPTION 'User not found';
    END IF;
    
    -- สร้างชื่อไฟล์ใหม่
    new_file_name := public.generate_file_name(original_file_name, 'avatar');
    
    -- สร้าง path
    file_path := public.generate_file_path(auth.uid(), 'avatar', new_file_name);
    
    -- อัปเดตรูปโปรไฟล์
    UPDATE public.users 
    SET 
        avatar_url = file_path,
        updated_at = NOW()
    WHERE id = auth.uid();
    
    result := jsonb_build_object(
        'success', true,
        'user_id', user_record.id,
        'file_name', new_file_name,
        'file_path', file_path,
        'bucket', 'user-avatars',
        'message', 'Avatar uploaded successfully'
    );
    
    RETURN result;
END;
$function$
;

create or replace view "public"."user_discount_usage" as  SELECT u.id AS user_id,
    u.email,
    dc.code,
    dc.name AS discount_name,
    COALESCE(o.discount_amount, od.discount_amount, (0)::numeric) AS discount_amount,
    o.order_number,
    COALESCE(od.applied_at, dcu.used_at) AS applied_at,
    o.total_amount AS order_total
   FROM ((((auth.users u
     JOIN public.discount_code_usage dcu ON ((u.id = dcu.user_id)))
     JOIN public.discount_codes dc ON ((dcu.discount_code_id = dc.id)))
     LEFT JOIN public.order_discounts od ON ((dcu.order_id = od.order_id)))
     JOIN public.orders o ON ((dcu.order_id = o.id)))
  ORDER BY COALESCE(od.applied_at, dcu.used_at) DESC;


create or replace view "public"."user_login_activity" as  SELECT id,
    google_id,
    email,
    full_name,
    role,
    last_login_at,
    login_count,
    created_at,
    EXTRACT(days FROM (now() - last_login_at)) AS days_since_last_login,
        CASE
            WHEN (last_login_at >= (now() - '7 days'::interval)) THEN 'Active'::text
            WHEN (last_login_at >= (now() - '30 days'::interval)) THEN 'Recent'::text
            WHEN (last_login_at >= (now() - '90 days'::interval)) THEN 'Inactive'::text
            ELSE 'Very Inactive'::text
        END AS activity_status
   FROM public.users u
  WHERE (google_id IS NOT NULL)
  ORDER BY last_login_at DESC;


create or replace view "public"."user_order_summary" as  SELECT u.id AS user_id,
    u.full_name AS user_name,
    u.email AS user_email,
    count(o.id) AS total_orders,
    count(*) FILTER (WHERE (o.status = ANY (ARRAY['delivered'::text, 'completed'::text]))) AS successful_orders,
    count(*) FILTER (WHERE (o.status = ANY (ARRAY['cancelled'::text, 'rejected'::text]))) AS cancelled_orders,
    COALESCE(sum(o.total_amount), (0)::numeric) AS total_order_amount,
    COALESCE(sum(o.total_amount) FILTER (WHERE (o.status = ANY (ARRAY['delivered'::text, 'completed'::text]))), (0)::numeric) AS total_completed_amount,
    COALESCE(max(o.total_amount) FILTER (WHERE (o.status = ANY (ARRAY['delivered'::text, 'completed'::text]))), (0)::numeric) AS max_completed_order_amount,
    COALESCE(min(o.total_amount) FILTER (WHERE (o.status = ANY (ARRAY['delivered'::text, 'completed'::text]))), (0)::numeric) AS min_completed_order_amount,
    min(o.created_at) AS first_order_at,
    max(o.created_at) AS last_order_at
   FROM (public.orders o
     JOIN public.users u ON ((o.customer_id = u.id)))
  GROUP BY u.id, u.full_name, u.email;


create or replace view "public"."user_store_order_overview" as  SELECT u.id AS user_id,
    u.full_name AS user_name,
    u.email AS user_email,
    s.id AS store_id,
    s.name AS store_name,
    count(o.id) AS order_count,
    sum(o.total_amount) AS total_order_amount,
    sum(o.subtotal) AS total_subtotal_amount,
    sum(COALESCE(o.discount_amount, (0)::numeric)) AS total_discount_amount,
    min(o.created_at) AS first_order_at,
    max(o.created_at) AS last_order_at,
    ( SELECT COALESCE(jsonb_agg(DISTINCT jsonb_build_object('product_id', oi.product_id, 'product_name', oi.product_name)) FILTER (WHERE (oi.product_name IS NOT NULL)), '[]'::jsonb) AS "coalesce"
           FROM public.order_items oi
          WHERE (oi.order_id IN ( SELECT o2.id
                   FROM public.orders o2
                  WHERE ((o2.customer_id = u.id) AND (o2.store_id = s.id) AND (o2.status <> 'cancelled'::text) AND (o2.status <> 'rejected'::text))))) AS products_ordered,
    ( SELECT COALESCE(sum(oi.quantity), (0)::bigint) AS "coalesce"
           FROM public.order_items oi
          WHERE (oi.order_id IN ( SELECT o3.id
                   FROM public.orders o3
                  WHERE ((o3.customer_id = u.id) AND (o3.store_id = s.id) AND (o3.status <> 'cancelled'::text) AND (o3.status <> 'rejected'::text))))) AS total_items_ordered,
    ( SELECT COALESCE(jsonb_agg(jsonb_build_object('order_id', o4.id, 'order_number', o4.order_number, 'total_amount', o4.total_amount, 'created_at', o4.created_at) ORDER BY o4.created_at DESC), '[]'::jsonb) AS "coalesce"
           FROM public.orders o4
          WHERE ((o4.customer_id = u.id) AND (o4.store_id = s.id) AND (o4.status <> 'cancelled'::text) AND (o4.status <> 'rejected'::text))) AS orders_detail
   FROM ((public.orders o
     JOIN public.users u ON ((o.customer_id = u.id)))
     JOIN public.stores s ON ((o.store_id = s.id)))
  WHERE ((o.status <> 'cancelled'::text) AND (o.status <> 'rejected'::text))
  GROUP BY u.id, u.full_name, u.email, s.id, s.name;


create or replace view "public"."users_point_balances" as  SELECT u.id AS user_id,
    u.full_name,
    COALESCE(sum(
        CASE
            WHEN ((l.expires_at IS NULL) OR (l.expires_at > now())) THEN l.points_change
            ELSE 0
        END), (0)::bigint) AS available_points,
    COALESCE(sum(l.points_change), (0)::bigint) AS total_points_all_time,
    max(l.created_at) AS last_activity_at
   FROM (public.users u
     LEFT JOIN public.loyalty_point_ledger l ON ((u.id = l.user_id)))
  GROUP BY u.id, u.full_name;


create or replace view "public"."users_with_delivery_location" as  SELECT id,
    full_name,
    email,
    phone,
    address,
    latitude,
    longitude,
    role,
    created_at,
    updated_at
   FROM public.users
  WHERE ((latitude IS NOT NULL) AND (longitude IS NOT NULL) AND (role = 'customer'::text));


create or replace view "public"."v_daily_best_selling_stores" as  SELECT s.id,
    s.name,
    s.logo_url,
    s.banner_url,
    count(o.id) AS daily_order_count,
    COALESCE(sum(o.total_amount), (0)::numeric) AS daily_total_sales
   FROM (public.stores s
     JOIN public.orders o ON ((s.id = o.store_id)))
  WHERE ((date(o.created_at) = CURRENT_DATE) AND (o.status = 'delivered'::text))
  GROUP BY s.id
  ORDER BY (count(o.id)) DESC, COALESCE(sum(o.total_amount), (0)::numeric) DESC
 LIMIT 5;


create or replace view "public"."v_daily_new_stores" as  SELECT id,
    owner_id,
    name,
    description,
    address,
    phone,
    email,
    opening_hours,
    is_active,
    is_open,
    is_suspended,
    suspension_reason,
    suspended_by,
    suspended_at,
    auto_accept_orders,
    logo_url,
    banner_url,
    latitude,
    longitude,
    delivery_radius,
    minimum_order,
    created_at,
    updated_at,
    store_type_id,
    line_id,
    minimum_order_amount,
    phone_number,
    is_auto_open,
    location,
    code_store
   FROM public.stores
  WHERE ((created_at >= (now() - '30 days'::interval)) AND (is_active = true))
  ORDER BY (md5((((id)::text || (CURRENT_DATE)::text) || 'new_stores'::text)))
 LIMIT 5;


create or replace view "public"."v_daily_small_stores" as  SELECT id,
    owner_id,
    name,
    description,
    address,
    phone,
    email,
    opening_hours,
    is_active,
    is_open,
    is_suspended,
    suspension_reason,
    suspended_by,
    suspended_at,
    auto_accept_orders,
    logo_url,
    banner_url,
    latitude,
    longitude,
    delivery_radius,
    minimum_order,
    created_at,
    updated_at,
    store_type_id,
    line_id,
    minimum_order_amount,
    phone_number,
    is_auto_open,
    location,
    code_store
   FROM public.stores
  WHERE (is_active = true)
  ORDER BY (md5((((id)::text || (CURRENT_DATE)::text) || 'small_stores'::text)))
 LIMIT 5;


create or replace view "public"."v_pharmacy_stores" as  SELECT s.id,
    s.name,
    s.logo_url,
    s.banner_url,
    s.is_active,
    s.is_open,
    s.address,
    s.phone,
    s.created_at
   FROM (public.stores s
     JOIN public.store_categories sc ON ((s.store_type_id = sc.id)))
  WHERE ((sc.name = 'ร้านขายยา'::text) AND (s.is_active = true))
  ORDER BY s.created_at DESC;


create or replace view "public"."v_user_favorite_stores" as  SELECT o.customer_id,
    s.id,
    s.name,
    s.logo_url,
    s.banner_url,
    s.is_active,
    s.is_open,
    count(o.id) AS order_count,
    max(o.created_at) AS last_order_date,
    COALESCE(sum(o.total_amount), (0)::numeric) AS total_spent
   FROM (public.stores s
     JOIN public.orders o ON ((s.id = o.store_id)))
  WHERE (o.status = 'delivered'::text)
  GROUP BY o.customer_id, s.id, s.name, s.logo_url, s.banner_url, s.is_active, s.is_open
  ORDER BY o.customer_id, (count(o.id)) DESC, (max(o.created_at)) DESC;


-- create type "public"."valid_detail" as ("valid" boolean, "reason" character varying, "location" public.geometry);

CREATE OR REPLACE FUNCTION public.validate_discount_code(p_code text, p_store_id uuid, p_subtotal numeric)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_discount_code record;
    v_discount_amount numeric(10,2) := 0;
    v_result jsonb;
BEGIN
    -- ค้นหาโค้ดส่วนลด
    SELECT * INTO v_discount_code
    FROM public.discount_codes
    WHERE code = p_code
    AND is_active = true
    AND valid_from <= now()
    AND valid_until >= now()
    AND (usage_limit IS NULL OR used_count < usage_limit);
    
    -- ตรวจสอบว่าเจอโค้ดหรือไม่
    IF NOT FOUND THEN
        RETURN jsonb_build_object(
            'is_valid', false,
            'error', 'โค้ดส่วนลดไม่ถูกต้องหรือหมดอายุแล้ว'
        );
    END IF;
    
    -- ตรวจสอบร้านค้าที่ใช้ได้
    IF v_discount_code.applicable_stores IS NOT NULL 
    AND NOT (p_store_id = ANY(v_discount_code.applicable_stores)) THEN
        RETURN jsonb_build_object(
            'is_valid', false,
            'error', 'โค้ดส่วนลดนี้ไม่สามารถใช้กับร้านค้านี้ได้'
        );
    END IF;
    
    -- ตรวจสอบยอดสั่งซื้อขั้นต่ำ
    IF p_subtotal < v_discount_code.minimum_order_amount THEN
        RETURN jsonb_build_object(
            'is_valid', false,
            'error', 'ยอดสั่งซื้อไม่ถึงขั้นต่ำ ' || v_discount_code.minimum_order_amount || ' บาท'
        );
    END IF;
    
    -- คำนวณส่วนลด
    IF v_discount_code.discount_type = 'percentage' THEN
        v_discount_amount := p_subtotal * (v_discount_code.discount_value / 100);
        -- ตรวจสอบส่วนลดสูงสุด
        IF v_discount_code.maximum_discount_amount IS NOT NULL 
        AND v_discount_amount > v_discount_code.maximum_discount_amount THEN
            v_discount_amount := v_discount_code.maximum_discount_amount;
        END IF;
    ELSE -- fixed_amount
        v_discount_amount := v_discount_code.discount_value;
        -- ตรวจสอบว่าไม่เกินยอดสั่งซื้อ
        IF v_discount_amount > p_subtotal THEN
            v_discount_amount := p_subtotal;
        END IF;
    END IF;
    
    -- ส่งผลลัพธ์
    RETURN jsonb_build_object(
        'is_valid', true,
        'discount_code', jsonb_build_object(
            'id', v_discount_code.id,
            'code', v_discount_code.code,
            'name', v_discount_code.name,
            'description', v_discount_code.description,
            'discount_type', v_discount_code.discount_type,
            'discount_value', v_discount_code.discount_value,
            'discount_amount', v_discount_amount
        )
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.verify_deposit(p_deposit_id uuid, p_verified_by uuid, p_approved boolean)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
  IF p_approved THEN
    UPDATE order_deposits
    SET payment_status = 'paid',
        verified_by = p_verified_by,
        verified_at = now()
    WHERE id = p_deposit_id;
    
    UPDATE preorder_orders
    SET deposit_status = 'paid',
        deposit_paid_at = now(),
        status = 'deposit_confirmed'
    WHERE id = (SELECT preorder_order_id FROM order_deposits WHERE id = p_deposit_id);
  ELSE
    UPDATE order_deposits
    SET payment_status = 'failed',
        verified_by = p_verified_by,
        verified_at = now()
    WHERE id = p_deposit_id;
    
    UPDATE preorder_orders
    SET status = 'cancelled'
    WHERE id = (SELECT preorder_order_id FROM order_deposits WHERE id = p_deposit_id);
  END IF;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.verify_rider_document(document_uuid uuid, is_verified boolean, verified_by_user_id uuid DEFAULT NULL::uuid, verification_notes text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    rider_uuid UUID;
    document_type TEXT;
BEGIN
    -- ดึงข้อมูลเอกสาร
    SELECT rider_id, document_type INTO rider_uuid, document_type
    FROM rider_documents WHERE id = document_uuid;
    
    -- อัปเดตสถานะเอกสาร
    UPDATE rider_documents 
    SET 
        verified = is_verified,
        verified_by = verified_by_user_id,
        verified_at = NOW(),
        verification_notes = verification_notes,
        updated_at = NOW()
    WHERE id = document_uuid;
    
    -- เพิ่มประวัติการตรวจสอบ
    INSERT INTO document_verification_history (
        document_id,
        rider_id,
        action,
        verified_by,
        notes
    )
    VALUES (
        document_uuid,
        rider_uuid,
        CASE WHEN is_verified THEN 'verified' ELSE 'rejected' END,
        verified_by_user_id,
        verification_notes
    );
    
    -- ตรวจสอบว่าทุกเอกสารผ่านการตรวจสอบแล้วหรือไม่
    IF is_verified AND NOT EXISTS (
        SELECT 1 FROM rider_documents 
        WHERE rider_id = rider_uuid 
        AND verified = false
    ) THEN
        -- อัปเดตสถานะการตรวจสอบของไดเดอร์
        UPDATE riders 
        SET 
            documents_verified = true,
            verified_by = verified_by_user_id,
            verified_at = NOW(),
            verification_notes = 'All documents verified',
            updated_at = NOW()
        WHERE id = rider_uuid;
        
        -- ส่งการแจ้งเตือนไปยังไดเดอร์
        PERFORM send_notification(
            (SELECT user_id FROM riders WHERE id = rider_uuid),
            'เอกสารผ่านการตรวจสอบ',
            'เอกสารทั้งหมดของคุณผ่านการตรวจสอบแล้ว คุณสามารถรับงานได้',
            'system',
            jsonb_build_object('rider_id', rider_uuid)
        );
    END IF;
    
    -- ส่งการแจ้งเตือนไปยังไดเดอร์
    PERFORM send_notification(
        (SELECT user_id FROM riders WHERE id = rider_uuid),
        CASE WHEN is_verified THEN 'เอกสารผ่านการตรวจสอบ' ELSE 'เอกสารไม่ผ่านการตรวจสอบ' END,
        CASE 
            WHEN is_verified THEN 'เอกสาร ' || document_type || ' ผ่านการตรวจสอบแล้ว'
            ELSE 'เอกสาร ' || document_type || ' ไม่ผ่านการตรวจสอบ: ' || COALESCE(verification_notes, 'ไม่มีเหตุผล')
        END,
        'system',
        jsonb_build_object('document_id', document_uuid, 'verified', is_verified)
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.verify_rider_document_pdf(document_uuid uuid, is_verified boolean, verified_by_user_id uuid DEFAULT NULL::uuid, verification_notes text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    rider_uuid UUID;
    document_type TEXT;
    result JSONB;
BEGIN
    -- ดึงข้อมูลเอกสาร
    SELECT rider_id, document_type INTO rider_uuid, document_type
    FROM rider_documents WHERE id = document_uuid;
    
    IF rider_uuid IS NULL THEN
        RAISE EXCEPTION 'Document not found';
    END IF;
    
    -- อัปเดตสถานะเอกสาร
    UPDATE rider_documents 
    SET 
        verified = is_verified,
        verified_by = verified_by_user_id,
        verified_at = NOW(),
        verification_notes = verification_notes,
        updated_at = NOW()
    WHERE id = document_uuid;
    
    -- เพิ่มประวัติการตรวจสอบ
    INSERT INTO document_verification_history (
        document_id,
        rider_id,
        action,
        verified_by,
        notes
    )
    VALUES (
        document_uuid,
        rider_uuid,
        CASE WHEN is_verified THEN 'verified' ELSE 'rejected' END,
        verified_by_user_id,
        verification_notes
    );
    
    -- ตรวจสอบว่าทุกเอกสารผ่านการตรวจสอบแล้วหรือไม่
    IF is_verified AND NOT EXISTS (
        SELECT 1 FROM rider_documents 
        WHERE rider_id = rider_uuid 
        AND verified = false
        AND document_type IN ('driver_license', 'car_tax', 'id_card', 'rider_application')
    ) THEN
        -- อัปเดตสถานะการตรวจสอบเอกสารของไรเดอร์
        UPDATE riders 
        SET 
            documents_verified = true,
            verified_by = verified_by_user_id,
            verified_at = NOW(),
            updated_at = NOW()
        WHERE id = rider_uuid;
        
        -- ส่งการแจ้งเตือนให้ไรเดอร์
        PERFORM send_notification(
            (SELECT user_id FROM riders WHERE id = rider_uuid),
            'เอกสารได้รับการยืนยัน',
            'เอกสารทั้งหมดของคุณได้รับการตรวจสอบและยืนยันแล้ว',
            'system',
            jsonb_build_object(
                'rider_id', rider_uuid,
                'documents_verified', true
            )
        );
    END IF;
    
    result := jsonb_build_object(
        'success', true,
        'document_id', document_uuid,
        'rider_id', rider_uuid,
        'document_type', document_type,
        'verified', is_verified,
        'message', CASE 
            WHEN is_verified THEN 'Document verified successfully'
            ELSE 'Document rejected'
        END
    );
    
    RETURN result;
END;
$function$
;

create or replace view "public"."weekly_sales_report" as  WITH base AS (
         SELECT (date_trunc('week'::text, (o.created_at AT TIME ZONE 'Asia/Bangkok'::text)))::date AS week_start,
            ((date_trunc('week'::text, (o.created_at AT TIME ZONE 'Asia/Bangkok'::text)) + '6 days'::interval))::date AS week_end,
            EXTRACT(year FROM (o.created_at AT TIME ZONE 'Asia/Bangkok'::text)) AS year,
            EXTRACT(week FROM (o.created_at AT TIME ZONE 'Asia/Bangkok'::text)) AS week_number,
            o.store_id,
            s.name AS store_name,
            count(o.id) AS order_count,
            count(o.id) FILTER (WHERE (o.status = ANY (ARRAY['delivered'::text, 'completed'::text]))) AS completed_orders,
            count(o.id) FILTER (WHERE (o.status = 'cancelled'::text)) AS cancelled_orders,
            COALESCE(sum(o.total_amount), (0)::numeric) AS total_amount_sum,
            COALESCE(sum(COALESCE(o.discount_amount, (0)::numeric)), (0)::numeric) AS discount_amount_sum,
            COALESCE(sum(
                CASE
                    WHEN (o.status <> 'cancelled'::text) THEN o.subtotal
                    ELSE (0)::numeric
                END), (0)::numeric) AS net_revenue,
            COALESCE(avg(
                CASE
                    WHEN (o.status <> 'cancelled'::text) THEN o.subtotal
                    ELSE NULL::numeric
                END), (0)::numeric) AS avg_subtotal,
            count(o.id) FILTER (WHERE (o.discount_code IS NOT NULL)) AS discount_orders,
            COALESCE(sum(
                CASE
                    WHEN ((o.payment_method = 'cash'::text) AND (o.status <> 'cancelled'::text)) THEN o.subtotal
                    ELSE (0)::numeric
                END), (0)::numeric) AS cash_revenue,
            COALESCE(sum(
                CASE
                    WHEN ((o.payment_method = 'bank_transfer'::text) AND (o.status <> 'cancelled'::text)) THEN o.subtotal
                    ELSE (0)::numeric
                END), (0)::numeric) AS transfer_revenue,
            count(o.id) FILTER (WHERE (o.payment_method = 'cash'::text)) AS cash_orders,
            count(o.id) FILTER (WHERE (o.payment_method = 'bank_transfer'::text)) AS transfer_orders,
            count(DISTINCT o.customer_id) AS unique_customers,
            count(DISTINCT o.rider_id) AS unique_riders
           FROM (public.orders o
             LEFT JOIN public.stores s ON ((s.id = o.store_id)))
          WHERE (o.created_at IS NOT NULL)
          GROUP BY (date_trunc('week'::text, (o.created_at AT TIME ZONE 'Asia/Bangkok'::text))), (((date_trunc('week'::text, (o.created_at AT TIME ZONE 'Asia/Bangkok'::text)) + '6 days'::interval))::date), (EXTRACT(year FROM (o.created_at AT TIME ZONE 'Asia/Bangkok'::text))), (EXTRACT(week FROM (o.created_at AT TIME ZONE 'Asia/Bangkok'::text))), o.store_id, s.name
        )
 SELECT week_start,
    week_end,
    year,
    week_number,
    order_count AS total_orders,
    net_revenue AS total_revenue,
    discount_amount_sum AS total_discount_given,
    (net_revenue + discount_amount_sum) AS gross_revenue,
    avg_subtotal AS average_order_value,
    discount_orders AS orders_with_discount,
        CASE
            WHEN (order_count > 0) THEN (((discount_orders)::numeric * 100.0) / (order_count)::numeric)
            ELSE (0)::numeric
        END AS discount_usage_percentage,
    NULL::text AS most_used_discount_code,
    NULL::text AS most_used_discount_count,
    store_id,
    store_name,
    net_revenue AS weekly_revenue,
    order_count AS weekly_orders,
    total_amount_sum AS total_amount_revenue,
    completed_orders,
    cancelled_orders,
    cash_revenue,
    transfer_revenue,
    cash_orders,
    transfer_orders,
    unique_customers,
    unique_riders
   FROM base
  ORDER BY week_start DESC, net_revenue DESC;


create or replace view "public"."worker_job_assignments" as  SELECT ja.id AS assignment_id,
    ja.job_posting_id,
    ja.worker_id,
    ja.status AS assignment_status,
    ja.assigned_at,
    ja.started_at,
    ja.completed_at,
    COALESCE(ja.job_price, jp.job_price) AS job_price,
    ja.platform_fee_amount,
    ja.fee_percentage_used,
    ja.credit_amount,
    ja.rating_by_employer,
    ja.rating_by_worker,
    ja.review_by_employer,
    ja.review_by_worker,
    jp.job_number,
    jp.title,
    jp.description,
    jp.category_id,
    jc.name AS category_name,
    jp.employer_id,
    u_employer.full_name AS employer_name,
    u_employer.phone AS employer_phone,
    u_employer.line_id AS employer_line_id,
    jp.employer_address,
    jp.employer_latitude,
    jp.employer_longitude,
    jp.distance_km,
    jp.special_instructions,
    jp.estimated_completion_time,
    jp.actual_completion_time,
    jp.payment_method,
    jp.payment_status,
    jp.status AS job_status,
    ja.created_at,
    ja.updated_at
   FROM (((public.job_assignments ja
     JOIN public.job_postings jp ON ((ja.job_posting_id = jp.id)))
     LEFT JOIN public.job_categories jc ON ((jp.category_id = jc.id)))
     LEFT JOIN public.users u_employer ON ((jp.employer_id = u_employer.id)))
  ORDER BY ja.created_at DESC;


create or replace view "public"."yearly_sales_report" as  WITH base AS (
         SELECT EXTRACT(year FROM (o.created_at AT TIME ZONE 'Asia/Bangkok'::text)) AS year,
            o.store_id,
            s.name AS store_name,
            count(o.id) AS order_count,
            count(o.id) FILTER (WHERE (o.status = ANY (ARRAY['delivered'::text, 'completed'::text]))) AS completed_orders,
            count(o.id) FILTER (WHERE (o.status = 'cancelled'::text)) AS cancelled_orders,
            COALESCE(sum(o.total_amount), (0)::numeric) AS total_amount_sum,
            COALESCE(sum(COALESCE(o.discount_amount, (0)::numeric)), (0)::numeric) AS discount_amount_sum,
            COALESCE(sum(
                CASE
                    WHEN (o.status <> 'cancelled'::text) THEN o.subtotal
                    ELSE (0)::numeric
                END), (0)::numeric) AS net_revenue,
            COALESCE(avg(
                CASE
                    WHEN (o.status <> 'cancelled'::text) THEN o.subtotal
                    ELSE NULL::numeric
                END), (0)::numeric) AS avg_subtotal,
            count(o.id) FILTER (WHERE (o.discount_code IS NOT NULL)) AS discount_orders,
            COALESCE(sum(
                CASE
                    WHEN ((o.payment_method = 'cash'::text) AND (o.status <> 'cancelled'::text)) THEN o.subtotal
                    ELSE (0)::numeric
                END), (0)::numeric) AS cash_revenue,
            COALESCE(sum(
                CASE
                    WHEN ((o.payment_method = 'bank_transfer'::text) AND (o.status <> 'cancelled'::text)) THEN o.subtotal
                    ELSE (0)::numeric
                END), (0)::numeric) AS transfer_revenue,
            count(o.id) FILTER (WHERE (o.payment_method = 'cash'::text)) AS cash_orders,
            count(o.id) FILTER (WHERE (o.payment_method = 'bank_transfer'::text)) AS transfer_orders,
            count(DISTINCT o.customer_id) AS unique_customers,
            count(DISTINCT o.rider_id) AS unique_riders
           FROM (public.orders o
             LEFT JOIN public.stores s ON ((s.id = o.store_id)))
          WHERE (o.created_at IS NOT NULL)
          GROUP BY (EXTRACT(year FROM (o.created_at AT TIME ZONE 'Asia/Bangkok'::text))), o.store_id, s.name
        )
 SELECT year,
    order_count AS total_orders,
    net_revenue AS total_revenue,
    discount_amount_sum AS total_discount_given,
    (net_revenue + discount_amount_sum) AS gross_revenue,
    avg_subtotal AS average_order_value,
    discount_orders AS orders_with_discount,
        CASE
            WHEN (order_count > 0) THEN (((discount_orders)::numeric * 100.0) / (order_count)::numeric)
            ELSE (0)::numeric
        END AS discount_usage_percentage,
    NULL::text AS most_used_discount_code,
    NULL::text AS most_used_discount_count,
    store_id,
    store_name,
    net_revenue AS yearly_revenue,
    order_count AS yearly_orders,
    total_amount_sum AS total_amount_revenue,
    completed_orders,
    cancelled_orders,
    cash_revenue,
    transfer_revenue,
    cash_orders,
    transfer_orders,
    unique_customers,
    unique_riders
   FROM base
  ORDER BY year DESC, net_revenue DESC;


create or replace view "public"."active_order_chat_messages" as  SELECT cm.id,
    cm.order_id,
    cm.sender_type,
    cm.sender_id,
    cm.message,
    cm.message_type,
    cm.is_read,
    cm.sender_fcm_token,
    cm.recipient_fcm_token,
    cm.created_at,
    cm.updated_at,
        CASE
            WHEN (cm.sender_type = 'customer'::text) THEN u.full_name
            WHEN (cm.sender_type = 'rider'::text) THEN rpv.full_name
            WHEN (cm.sender_type = 'store'::text) THEN s.name
            ELSE 'Unknown'::text
        END AS sender_name,
        CASE
            WHEN (cm.sender_type = 'customer'::text) THEN u.avatar_url
            WHEN (cm.sender_type = 'rider'::text) THEN rpv.avatar_url
            ELSE NULL::text
        END AS sender_avatar
   FROM ((((public.chat_messages cm
     JOIN public.orders o ON ((cm.order_id = o.id)))
     LEFT JOIN public.users u ON (((cm.sender_id = u.id) AND (cm.sender_type = 'customer'::text))))
     LEFT JOIN public.rider_profile_view rpv ON (((cm.sender_id = rpv.rider_id) AND (cm.sender_type = 'rider'::text))))
     LEFT JOIN public.stores s ON (((cm.sender_id = s.id) AND (cm.sender_type = 'store'::text))))
  WHERE (o.status = ANY (ARRAY['assigned'::text, 'picked_up'::text, 'delivering'::text]))
  ORDER BY cm.created_at;


create or replace view "public"."chat_messages_with_images" as  SELECT cm.id,
    cm.order_id,
    cm.sender_type,
    cm.sender_id,
    cm.message,
    cm.message_type,
    cm.is_read,
    cm.created_at,
    o.order_number,
    o.customer_name,
    o.customer_phone,
    o.delivery_address,
        CASE
            WHEN ((cm.message_type = 'image'::text) AND (cm.message IS NOT NULL)) THEN public.get_chat_image_url(cm.message)
            ELSE NULL::text
        END AS image_url
   FROM (public.chat_messages cm
     JOIN public.orders o ON ((cm.order_id = o.id)))
  WHERE (cm.message_type = 'image'::text)
  ORDER BY cm.created_at DESC;


create or replace view "public"."chat_messages_with_sender_info" as  SELECT cm.id,
    cm.order_id,
    cm.sender_type,
    cm.sender_id,
    cm.message,
    cm.message_type,
    cm.is_read,
    cm.sender_fcm_token,
    cm.recipient_fcm_token,
    cm.created_at,
    cm.updated_at,
        CASE
            WHEN (cm.sender_type = 'customer'::text) THEN u.full_name
            WHEN (cm.sender_type = 'rider'::text) THEN rpv.full_name
            WHEN (cm.sender_type = 'store'::text) THEN s.name
            ELSE 'Unknown'::text
        END AS sender_name,
        CASE
            WHEN (cm.sender_type = 'customer'::text) THEN u.avatar_url
            WHEN (cm.sender_type = 'rider'::text) THEN rpv.avatar_url
            ELSE NULL::text
        END AS sender_avatar
   FROM (((public.chat_messages cm
     LEFT JOIN public.users u ON (((cm.sender_id = u.id) AND (cm.sender_type = 'customer'::text))))
     LEFT JOIN public.rider_profile_view rpv ON (((cm.sender_id = rpv.rider_id) AND (cm.sender_type = 'rider'::text))))
     LEFT JOIN public.stores s ON (((cm.sender_id = s.id) AND (cm.sender_type = 'store'::text))))
  ORDER BY cm.created_at;


create or replace view "public"."community_comments_with_details" as  SELECT c.id,
    c.post_id,
    c.user_id,
    c.parent_comment_id,
    c.content,
    c.image_file_path,
    c.image_file_name,
    c.image_file_size,
    c.image_mime_type,
    c.is_active,
    c.created_at,
    c.updated_at,
    u.full_name AS author_name,
    u.avatar_url AS author_avatar,
    COALESCE(like_count.likes, (0)::bigint) AS like_count,
        CASE
            WHEN (c.image_file_path IS NOT NULL) THEN public.get_community_post_image_url(c.image_file_path)
            ELSE NULL::text
        END AS image_url
   FROM ((public.community_comments c
     JOIN public.users u ON ((c.user_id = u.id)))
     LEFT JOIN ( SELECT community_comment_likes.comment_id,
            count(*) AS likes
           FROM public.community_comment_likes
          GROUP BY community_comment_likes.comment_id) like_count ON ((c.id = like_count.comment_id)))
  WHERE (c.is_active = true);


grant delete on table "public"."admin_activity_logs" to "anon";

grant insert on table "public"."admin_activity_logs" to "anon";

grant references on table "public"."admin_activity_logs" to "anon";

grant select on table "public"."admin_activity_logs" to "anon";

grant trigger on table "public"."admin_activity_logs" to "anon";

grant truncate on table "public"."admin_activity_logs" to "anon";

grant update on table "public"."admin_activity_logs" to "anon";

grant delete on table "public"."admin_activity_logs" to "authenticated";

grant insert on table "public"."admin_activity_logs" to "authenticated";

grant references on table "public"."admin_activity_logs" to "authenticated";

grant select on table "public"."admin_activity_logs" to "authenticated";

grant trigger on table "public"."admin_activity_logs" to "authenticated";

grant truncate on table "public"."admin_activity_logs" to "authenticated";

grant update on table "public"."admin_activity_logs" to "authenticated";

grant delete on table "public"."admin_activity_logs" to "service_role";

grant insert on table "public"."admin_activity_logs" to "service_role";

grant references on table "public"."admin_activity_logs" to "service_role";

grant select on table "public"."admin_activity_logs" to "service_role";

grant trigger on table "public"."admin_activity_logs" to "service_role";

grant truncate on table "public"."admin_activity_logs" to "service_role";

grant update on table "public"."admin_activity_logs" to "service_role";

grant delete on table "public"."admin_export_logs" to "anon";

grant insert on table "public"."admin_export_logs" to "anon";

grant references on table "public"."admin_export_logs" to "anon";

grant select on table "public"."admin_export_logs" to "anon";

grant trigger on table "public"."admin_export_logs" to "anon";

grant truncate on table "public"."admin_export_logs" to "anon";

grant update on table "public"."admin_export_logs" to "anon";

grant delete on table "public"."admin_export_logs" to "authenticated";

grant insert on table "public"."admin_export_logs" to "authenticated";

grant references on table "public"."admin_export_logs" to "authenticated";

grant select on table "public"."admin_export_logs" to "authenticated";

grant trigger on table "public"."admin_export_logs" to "authenticated";

grant truncate on table "public"."admin_export_logs" to "authenticated";

grant update on table "public"."admin_export_logs" to "authenticated";

grant delete on table "public"."admin_export_logs" to "service_role";

grant insert on table "public"."admin_export_logs" to "service_role";

grant references on table "public"."admin_export_logs" to "service_role";

grant select on table "public"."admin_export_logs" to "service_role";

grant trigger on table "public"."admin_export_logs" to "service_role";

grant truncate on table "public"."admin_export_logs" to "service_role";

grant update on table "public"."admin_export_logs" to "service_role";

grant delete on table "public"."admin_login_logs" to "anon";

grant insert on table "public"."admin_login_logs" to "anon";

grant references on table "public"."admin_login_logs" to "anon";

grant select on table "public"."admin_login_logs" to "anon";

grant trigger on table "public"."admin_login_logs" to "anon";

grant truncate on table "public"."admin_login_logs" to "anon";

grant update on table "public"."admin_login_logs" to "anon";

grant delete on table "public"."admin_login_logs" to "authenticated";

grant insert on table "public"."admin_login_logs" to "authenticated";

grant references on table "public"."admin_login_logs" to "authenticated";

grant select on table "public"."admin_login_logs" to "authenticated";

grant trigger on table "public"."admin_login_logs" to "authenticated";

grant truncate on table "public"."admin_login_logs" to "authenticated";

grant update on table "public"."admin_login_logs" to "authenticated";

grant delete on table "public"."admin_login_logs" to "service_role";

grant insert on table "public"."admin_login_logs" to "service_role";

grant references on table "public"."admin_login_logs" to "service_role";

grant select on table "public"."admin_login_logs" to "service_role";

grant trigger on table "public"."admin_login_logs" to "service_role";

grant truncate on table "public"."admin_login_logs" to "service_role";

grant update on table "public"."admin_login_logs" to "service_role";

grant delete on table "public"."admin_system_config_logs" to "anon";

grant insert on table "public"."admin_system_config_logs" to "anon";

grant references on table "public"."admin_system_config_logs" to "anon";

grant select on table "public"."admin_system_config_logs" to "anon";

grant trigger on table "public"."admin_system_config_logs" to "anon";

grant truncate on table "public"."admin_system_config_logs" to "anon";

grant update on table "public"."admin_system_config_logs" to "anon";

grant delete on table "public"."admin_system_config_logs" to "authenticated";

grant insert on table "public"."admin_system_config_logs" to "authenticated";

grant references on table "public"."admin_system_config_logs" to "authenticated";

grant select on table "public"."admin_system_config_logs" to "authenticated";

grant trigger on table "public"."admin_system_config_logs" to "authenticated";

grant truncate on table "public"."admin_system_config_logs" to "authenticated";

grant update on table "public"."admin_system_config_logs" to "authenticated";

grant delete on table "public"."admin_system_config_logs" to "service_role";

grant insert on table "public"."admin_system_config_logs" to "service_role";

grant references on table "public"."admin_system_config_logs" to "service_role";

grant select on table "public"."admin_system_config_logs" to "service_role";

grant trigger on table "public"."admin_system_config_logs" to "service_role";

grant truncate on table "public"."admin_system_config_logs" to "service_role";

grant update on table "public"."admin_system_config_logs" to "service_role";

grant delete on table "public"."admin_view_logs" to "anon";

grant insert on table "public"."admin_view_logs" to "anon";

grant references on table "public"."admin_view_logs" to "anon";

grant select on table "public"."admin_view_logs" to "anon";

grant trigger on table "public"."admin_view_logs" to "anon";

grant truncate on table "public"."admin_view_logs" to "anon";

grant update on table "public"."admin_view_logs" to "anon";

grant delete on table "public"."admin_view_logs" to "authenticated";

grant insert on table "public"."admin_view_logs" to "authenticated";

grant references on table "public"."admin_view_logs" to "authenticated";

grant select on table "public"."admin_view_logs" to "authenticated";

grant trigger on table "public"."admin_view_logs" to "authenticated";

grant truncate on table "public"."admin_view_logs" to "authenticated";

grant update on table "public"."admin_view_logs" to "authenticated";

grant delete on table "public"."admin_view_logs" to "service_role";

grant insert on table "public"."admin_view_logs" to "service_role";

grant references on table "public"."admin_view_logs" to "service_role";

grant select on table "public"."admin_view_logs" to "service_role";

grant trigger on table "public"."admin_view_logs" to "service_role";

grant truncate on table "public"."admin_view_logs" to "service_role";

grant update on table "public"."admin_view_logs" to "service_role";

grant delete on table "public"."ads" to "anon";

grant insert on table "public"."ads" to "anon";

grant references on table "public"."ads" to "anon";

grant select on table "public"."ads" to "anon";

grant trigger on table "public"."ads" to "anon";

grant truncate on table "public"."ads" to "anon";

grant update on table "public"."ads" to "anon";

grant delete on table "public"."ads" to "authenticated";

grant insert on table "public"."ads" to "authenticated";

grant references on table "public"."ads" to "authenticated";

grant select on table "public"."ads" to "authenticated";

grant trigger on table "public"."ads" to "authenticated";

grant truncate on table "public"."ads" to "authenticated";

grant update on table "public"."ads" to "authenticated";

grant delete on table "public"."ads" to "service_role";

grant insert on table "public"."ads" to "service_role";

grant references on table "public"."ads" to "service_role";

grant select on table "public"."ads" to "service_role";

grant trigger on table "public"."ads" to "service_role";

grant truncate on table "public"."ads" to "service_role";

grant update on table "public"."ads" to "service_role";

grant delete on table "public"."ads_floating" to "anon";

grant insert on table "public"."ads_floating" to "anon";

grant references on table "public"."ads_floating" to "anon";

grant select on table "public"."ads_floating" to "anon";

grant trigger on table "public"."ads_floating" to "anon";

grant truncate on table "public"."ads_floating" to "anon";

grant update on table "public"."ads_floating" to "anon";

grant delete on table "public"."ads_floating" to "authenticated";

grant insert on table "public"."ads_floating" to "authenticated";

grant references on table "public"."ads_floating" to "authenticated";

grant select on table "public"."ads_floating" to "authenticated";

grant trigger on table "public"."ads_floating" to "authenticated";

grant truncate on table "public"."ads_floating" to "authenticated";

grant update on table "public"."ads_floating" to "authenticated";

grant delete on table "public"."ads_floating" to "service_role";

grant insert on table "public"."ads_floating" to "service_role";

grant references on table "public"."ads_floating" to "service_role";

grant select on table "public"."ads_floating" to "service_role";

grant trigger on table "public"."ads_floating" to "service_role";

grant truncate on table "public"."ads_floating" to "service_role";

grant update on table "public"."ads_floating" to "service_role";

grant delete on table "public"."ads_hotel" to "anon";

grant insert on table "public"."ads_hotel" to "anon";

grant references on table "public"."ads_hotel" to "anon";

grant select on table "public"."ads_hotel" to "anon";

grant trigger on table "public"."ads_hotel" to "anon";

grant truncate on table "public"."ads_hotel" to "anon";

grant update on table "public"."ads_hotel" to "anon";

grant delete on table "public"."ads_hotel" to "authenticated";

grant insert on table "public"."ads_hotel" to "authenticated";

grant references on table "public"."ads_hotel" to "authenticated";

grant select on table "public"."ads_hotel" to "authenticated";

grant trigger on table "public"."ads_hotel" to "authenticated";

grant truncate on table "public"."ads_hotel" to "authenticated";

grant update on table "public"."ads_hotel" to "authenticated";

grant delete on table "public"."ads_hotel" to "service_role";

grant insert on table "public"."ads_hotel" to "service_role";

grant references on table "public"."ads_hotel" to "service_role";

grant select on table "public"."ads_hotel" to "service_role";

grant trigger on table "public"."ads_hotel" to "service_role";

grant truncate on table "public"."ads_hotel" to "service_role";

grant update on table "public"."ads_hotel" to "service_role";

grant delete on table "public"."app_store_versions" to "anon";

grant insert on table "public"."app_store_versions" to "anon";

grant references on table "public"."app_store_versions" to "anon";

grant select on table "public"."app_store_versions" to "anon";

grant trigger on table "public"."app_store_versions" to "anon";

grant truncate on table "public"."app_store_versions" to "anon";

grant update on table "public"."app_store_versions" to "anon";

grant delete on table "public"."app_store_versions" to "authenticated";

grant insert on table "public"."app_store_versions" to "authenticated";

grant references on table "public"."app_store_versions" to "authenticated";

grant select on table "public"."app_store_versions" to "authenticated";

grant trigger on table "public"."app_store_versions" to "authenticated";

grant truncate on table "public"."app_store_versions" to "authenticated";

grant update on table "public"."app_store_versions" to "authenticated";

grant delete on table "public"."app_store_versions" to "service_role";

grant insert on table "public"."app_store_versions" to "service_role";

grant references on table "public"."app_store_versions" to "service_role";

grant select on table "public"."app_store_versions" to "service_role";

grant trigger on table "public"."app_store_versions" to "service_role";

grant truncate on table "public"."app_store_versions" to "service_role";

grant update on table "public"."app_store_versions" to "service_role";

grant delete on table "public"."app_versions" to "anon";

grant insert on table "public"."app_versions" to "anon";

grant references on table "public"."app_versions" to "anon";

grant select on table "public"."app_versions" to "anon";

grant trigger on table "public"."app_versions" to "anon";

grant truncate on table "public"."app_versions" to "anon";

grant update on table "public"."app_versions" to "anon";

grant delete on table "public"."app_versions" to "authenticated";

grant insert on table "public"."app_versions" to "authenticated";

grant references on table "public"."app_versions" to "authenticated";

grant select on table "public"."app_versions" to "authenticated";

grant trigger on table "public"."app_versions" to "authenticated";

grant truncate on table "public"."app_versions" to "authenticated";

grant update on table "public"."app_versions" to "authenticated";

grant delete on table "public"."app_versions" to "service_role";

grant insert on table "public"."app_versions" to "service_role";

grant references on table "public"."app_versions" to "service_role";

grant select on table "public"."app_versions" to "service_role";

grant trigger on table "public"."app_versions" to "service_role";

grant truncate on table "public"."app_versions" to "service_role";

grant update on table "public"."app_versions" to "service_role";

grant delete on table "public"."available_jobs_for_workers" to "anon";

grant insert on table "public"."available_jobs_for_workers" to "anon";

grant references on table "public"."available_jobs_for_workers" to "anon";

grant select on table "public"."available_jobs_for_workers" to "anon";

grant trigger on table "public"."available_jobs_for_workers" to "anon";

grant truncate on table "public"."available_jobs_for_workers" to "anon";

grant update on table "public"."available_jobs_for_workers" to "anon";

grant delete on table "public"."available_jobs_for_workers" to "authenticated";

grant insert on table "public"."available_jobs_for_workers" to "authenticated";

grant references on table "public"."available_jobs_for_workers" to "authenticated";

grant select on table "public"."available_jobs_for_workers" to "authenticated";

grant trigger on table "public"."available_jobs_for_workers" to "authenticated";

grant truncate on table "public"."available_jobs_for_workers" to "authenticated";

grant update on table "public"."available_jobs_for_workers" to "authenticated";

grant delete on table "public"."available_jobs_for_workers" to "service_role";

grant insert on table "public"."available_jobs_for_workers" to "service_role";

grant references on table "public"."available_jobs_for_workers" to "service_role";

grant select on table "public"."available_jobs_for_workers" to "service_role";

grant trigger on table "public"."available_jobs_for_workers" to "service_role";

grant truncate on table "public"."available_jobs_for_workers" to "service_role";

grant update on table "public"."available_jobs_for_workers" to "service_role";

grant delete on table "public"."beauty_booking_status_history" to "anon";

grant insert on table "public"."beauty_booking_status_history" to "anon";

grant references on table "public"."beauty_booking_status_history" to "anon";

grant select on table "public"."beauty_booking_status_history" to "anon";

grant trigger on table "public"."beauty_booking_status_history" to "anon";

grant truncate on table "public"."beauty_booking_status_history" to "anon";

grant update on table "public"."beauty_booking_status_history" to "anon";

grant delete on table "public"."beauty_booking_status_history" to "authenticated";

grant insert on table "public"."beauty_booking_status_history" to "authenticated";

grant references on table "public"."beauty_booking_status_history" to "authenticated";

grant select on table "public"."beauty_booking_status_history" to "authenticated";

grant trigger on table "public"."beauty_booking_status_history" to "authenticated";

grant truncate on table "public"."beauty_booking_status_history" to "authenticated";

grant update on table "public"."beauty_booking_status_history" to "authenticated";

grant delete on table "public"."beauty_booking_status_history" to "service_role";

grant insert on table "public"."beauty_booking_status_history" to "service_role";

grant references on table "public"."beauty_booking_status_history" to "service_role";

grant select on table "public"."beauty_booking_status_history" to "service_role";

grant trigger on table "public"."beauty_booking_status_history" to "service_role";

grant truncate on table "public"."beauty_booking_status_history" to "service_role";

grant update on table "public"."beauty_booking_status_history" to "service_role";

grant delete on table "public"."beauty_bookings" to "anon";

grant insert on table "public"."beauty_bookings" to "anon";

grant references on table "public"."beauty_bookings" to "anon";

grant select on table "public"."beauty_bookings" to "anon";

grant trigger on table "public"."beauty_bookings" to "anon";

grant truncate on table "public"."beauty_bookings" to "anon";

grant update on table "public"."beauty_bookings" to "anon";

grant delete on table "public"."beauty_bookings" to "authenticated";

grant insert on table "public"."beauty_bookings" to "authenticated";

grant references on table "public"."beauty_bookings" to "authenticated";

grant select on table "public"."beauty_bookings" to "authenticated";

grant trigger on table "public"."beauty_bookings" to "authenticated";

grant truncate on table "public"."beauty_bookings" to "authenticated";

grant update on table "public"."beauty_bookings" to "authenticated";

grant delete on table "public"."beauty_bookings" to "service_role";

grant insert on table "public"."beauty_bookings" to "service_role";

grant references on table "public"."beauty_bookings" to "service_role";

grant select on table "public"."beauty_bookings" to "service_role";

grant trigger on table "public"."beauty_bookings" to "service_role";

grant truncate on table "public"."beauty_bookings" to "service_role";

grant update on table "public"."beauty_bookings" to "service_role";

grant delete on table "public"."beauty_notifications" to "anon";

grant insert on table "public"."beauty_notifications" to "anon";

grant references on table "public"."beauty_notifications" to "anon";

grant select on table "public"."beauty_notifications" to "anon";

grant trigger on table "public"."beauty_notifications" to "anon";

grant truncate on table "public"."beauty_notifications" to "anon";

grant update on table "public"."beauty_notifications" to "anon";

grant delete on table "public"."beauty_notifications" to "authenticated";

grant insert on table "public"."beauty_notifications" to "authenticated";

grant references on table "public"."beauty_notifications" to "authenticated";

grant select on table "public"."beauty_notifications" to "authenticated";

grant trigger on table "public"."beauty_notifications" to "authenticated";

grant truncate on table "public"."beauty_notifications" to "authenticated";

grant update on table "public"."beauty_notifications" to "authenticated";

grant delete on table "public"."beauty_notifications" to "service_role";

grant insert on table "public"."beauty_notifications" to "service_role";

grant references on table "public"."beauty_notifications" to "service_role";

grant select on table "public"."beauty_notifications" to "service_role";

grant trigger on table "public"."beauty_notifications" to "service_role";

grant truncate on table "public"."beauty_notifications" to "service_role";

grant update on table "public"."beauty_notifications" to "service_role";

grant delete on table "public"."beauty_owner_accounts" to "anon";

grant insert on table "public"."beauty_owner_accounts" to "anon";

grant references on table "public"."beauty_owner_accounts" to "anon";

grant select on table "public"."beauty_owner_accounts" to "anon";

grant trigger on table "public"."beauty_owner_accounts" to "anon";

grant truncate on table "public"."beauty_owner_accounts" to "anon";

grant update on table "public"."beauty_owner_accounts" to "anon";

grant delete on table "public"."beauty_owner_accounts" to "authenticated";

grant insert on table "public"."beauty_owner_accounts" to "authenticated";

grant references on table "public"."beauty_owner_accounts" to "authenticated";

grant select on table "public"."beauty_owner_accounts" to "authenticated";

grant trigger on table "public"."beauty_owner_accounts" to "authenticated";

grant truncate on table "public"."beauty_owner_accounts" to "authenticated";

grant update on table "public"."beauty_owner_accounts" to "authenticated";

grant delete on table "public"."beauty_owner_accounts" to "service_role";

grant insert on table "public"."beauty_owner_accounts" to "service_role";

grant references on table "public"."beauty_owner_accounts" to "service_role";

grant select on table "public"."beauty_owner_accounts" to "service_role";

grant trigger on table "public"."beauty_owner_accounts" to "service_role";

grant truncate on table "public"."beauty_owner_accounts" to "service_role";

grant update on table "public"."beauty_owner_accounts" to "service_role";

grant delete on table "public"."beauty_reviews" to "anon";

grant insert on table "public"."beauty_reviews" to "anon";

grant references on table "public"."beauty_reviews" to "anon";

grant select on table "public"."beauty_reviews" to "anon";

grant trigger on table "public"."beauty_reviews" to "anon";

grant truncate on table "public"."beauty_reviews" to "anon";

grant update on table "public"."beauty_reviews" to "anon";

grant delete on table "public"."beauty_reviews" to "authenticated";

grant insert on table "public"."beauty_reviews" to "authenticated";

grant references on table "public"."beauty_reviews" to "authenticated";

grant select on table "public"."beauty_reviews" to "authenticated";

grant trigger on table "public"."beauty_reviews" to "authenticated";

grant truncate on table "public"."beauty_reviews" to "authenticated";

grant update on table "public"."beauty_reviews" to "authenticated";

grant delete on table "public"."beauty_reviews" to "service_role";

grant insert on table "public"."beauty_reviews" to "service_role";

grant references on table "public"."beauty_reviews" to "service_role";

grant select on table "public"."beauty_reviews" to "service_role";

grant trigger on table "public"."beauty_reviews" to "service_role";

grant truncate on table "public"."beauty_reviews" to "service_role";

grant update on table "public"."beauty_reviews" to "service_role";

grant delete on table "public"."beauty_salons" to "anon";

grant insert on table "public"."beauty_salons" to "anon";

grant references on table "public"."beauty_salons" to "anon";

grant select on table "public"."beauty_salons" to "anon";

grant trigger on table "public"."beauty_salons" to "anon";

grant truncate on table "public"."beauty_salons" to "anon";

grant update on table "public"."beauty_salons" to "anon";

grant delete on table "public"."beauty_salons" to "authenticated";

grant insert on table "public"."beauty_salons" to "authenticated";

grant references on table "public"."beauty_salons" to "authenticated";

grant select on table "public"."beauty_salons" to "authenticated";

grant trigger on table "public"."beauty_salons" to "authenticated";

grant truncate on table "public"."beauty_salons" to "authenticated";

grant update on table "public"."beauty_salons" to "authenticated";

grant delete on table "public"."beauty_salons" to "service_role";

grant insert on table "public"."beauty_salons" to "service_role";

grant references on table "public"."beauty_salons" to "service_role";

grant select on table "public"."beauty_salons" to "service_role";

grant trigger on table "public"."beauty_salons" to "service_role";

grant truncate on table "public"."beauty_salons" to "service_role";

grant update on table "public"."beauty_salons" to "service_role";

grant delete on table "public"."beauty_schedules" to "anon";

grant insert on table "public"."beauty_schedules" to "anon";

grant references on table "public"."beauty_schedules" to "anon";

grant select on table "public"."beauty_schedules" to "anon";

grant trigger on table "public"."beauty_schedules" to "anon";

grant truncate on table "public"."beauty_schedules" to "anon";

grant update on table "public"."beauty_schedules" to "anon";

grant delete on table "public"."beauty_schedules" to "authenticated";

grant insert on table "public"."beauty_schedules" to "authenticated";

grant references on table "public"."beauty_schedules" to "authenticated";

grant select on table "public"."beauty_schedules" to "authenticated";

grant trigger on table "public"."beauty_schedules" to "authenticated";

grant truncate on table "public"."beauty_schedules" to "authenticated";

grant update on table "public"."beauty_schedules" to "authenticated";

grant delete on table "public"."beauty_schedules" to "service_role";

grant insert on table "public"."beauty_schedules" to "service_role";

grant references on table "public"."beauty_schedules" to "service_role";

grant select on table "public"."beauty_schedules" to "service_role";

grant trigger on table "public"."beauty_schedules" to "service_role";

grant truncate on table "public"."beauty_schedules" to "service_role";

grant update on table "public"."beauty_schedules" to "service_role";

grant delete on table "public"."beauty_services" to "anon";

grant insert on table "public"."beauty_services" to "anon";

grant references on table "public"."beauty_services" to "anon";

grant select on table "public"."beauty_services" to "anon";

grant trigger on table "public"."beauty_services" to "anon";

grant truncate on table "public"."beauty_services" to "anon";

grant update on table "public"."beauty_services" to "anon";

grant delete on table "public"."beauty_services" to "authenticated";

grant insert on table "public"."beauty_services" to "authenticated";

grant references on table "public"."beauty_services" to "authenticated";

grant select on table "public"."beauty_services" to "authenticated";

grant trigger on table "public"."beauty_services" to "authenticated";

grant truncate on table "public"."beauty_services" to "authenticated";

grant update on table "public"."beauty_services" to "authenticated";

grant delete on table "public"."beauty_services" to "service_role";

grant insert on table "public"."beauty_services" to "service_role";

grant references on table "public"."beauty_services" to "service_role";

grant select on table "public"."beauty_services" to "service_role";

grant trigger on table "public"."beauty_services" to "service_role";

grant truncate on table "public"."beauty_services" to "service_role";

grant update on table "public"."beauty_services" to "service_role";

grant delete on table "public"."beauty_staff" to "anon";

grant insert on table "public"."beauty_staff" to "anon";

grant references on table "public"."beauty_staff" to "anon";

grant select on table "public"."beauty_staff" to "anon";

grant trigger on table "public"."beauty_staff" to "anon";

grant truncate on table "public"."beauty_staff" to "anon";

grant update on table "public"."beauty_staff" to "anon";

grant delete on table "public"."beauty_staff" to "authenticated";

grant insert on table "public"."beauty_staff" to "authenticated";

grant references on table "public"."beauty_staff" to "authenticated";

grant select on table "public"."beauty_staff" to "authenticated";

grant trigger on table "public"."beauty_staff" to "authenticated";

grant truncate on table "public"."beauty_staff" to "authenticated";

grant update on table "public"."beauty_staff" to "authenticated";

grant delete on table "public"."beauty_staff" to "service_role";

grant insert on table "public"."beauty_staff" to "service_role";

grant references on table "public"."beauty_staff" to "service_role";

grant select on table "public"."beauty_staff" to "service_role";

grant trigger on table "public"."beauty_staff" to "service_role";

grant truncate on table "public"."beauty_staff" to "service_role";

grant update on table "public"."beauty_staff" to "service_role";

grant delete on table "public"."cancellation_requests" to "anon";

grant insert on table "public"."cancellation_requests" to "anon";

grant references on table "public"."cancellation_requests" to "anon";

grant select on table "public"."cancellation_requests" to "anon";

grant trigger on table "public"."cancellation_requests" to "anon";

grant truncate on table "public"."cancellation_requests" to "anon";

grant update on table "public"."cancellation_requests" to "anon";

grant delete on table "public"."cancellation_requests" to "authenticated";

grant insert on table "public"."cancellation_requests" to "authenticated";

grant references on table "public"."cancellation_requests" to "authenticated";

grant select on table "public"."cancellation_requests" to "authenticated";

grant trigger on table "public"."cancellation_requests" to "authenticated";

grant truncate on table "public"."cancellation_requests" to "authenticated";

grant update on table "public"."cancellation_requests" to "authenticated";

grant delete on table "public"."cancellation_requests" to "service_role";

grant insert on table "public"."cancellation_requests" to "service_role";

grant references on table "public"."cancellation_requests" to "service_role";

grant select on table "public"."cancellation_requests" to "service_role";

grant trigger on table "public"."cancellation_requests" to "service_role";

grant truncate on table "public"."cancellation_requests" to "service_role";

grant update on table "public"."cancellation_requests" to "service_role";

grant delete on table "public"."chat_messages" to "anon";

grant insert on table "public"."chat_messages" to "anon";

grant references on table "public"."chat_messages" to "anon";

grant select on table "public"."chat_messages" to "anon";

grant trigger on table "public"."chat_messages" to "anon";

grant truncate on table "public"."chat_messages" to "anon";

grant update on table "public"."chat_messages" to "anon";

grant delete on table "public"."chat_messages" to "authenticated";

grant insert on table "public"."chat_messages" to "authenticated";

grant references on table "public"."chat_messages" to "authenticated";

grant select on table "public"."chat_messages" to "authenticated";

grant trigger on table "public"."chat_messages" to "authenticated";

grant truncate on table "public"."chat_messages" to "authenticated";

grant update on table "public"."chat_messages" to "authenticated";

grant delete on table "public"."chat_messages" to "service_role";

grant insert on table "public"."chat_messages" to "service_role";

grant references on table "public"."chat_messages" to "service_role";

grant select on table "public"."chat_messages" to "service_role";

grant trigger on table "public"."chat_messages" to "service_role";

grant truncate on table "public"."chat_messages" to "service_role";

grant update on table "public"."chat_messages" to "service_role";

grant delete on table "public"."community_comment_likes" to "anon";

grant insert on table "public"."community_comment_likes" to "anon";

grant references on table "public"."community_comment_likes" to "anon";

grant select on table "public"."community_comment_likes" to "anon";

grant trigger on table "public"."community_comment_likes" to "anon";

grant truncate on table "public"."community_comment_likes" to "anon";

grant update on table "public"."community_comment_likes" to "anon";

grant delete on table "public"."community_comment_likes" to "authenticated";

grant insert on table "public"."community_comment_likes" to "authenticated";

grant references on table "public"."community_comment_likes" to "authenticated";

grant select on table "public"."community_comment_likes" to "authenticated";

grant trigger on table "public"."community_comment_likes" to "authenticated";

grant truncate on table "public"."community_comment_likes" to "authenticated";

grant update on table "public"."community_comment_likes" to "authenticated";

grant delete on table "public"."community_comment_likes" to "service_role";

grant insert on table "public"."community_comment_likes" to "service_role";

grant references on table "public"."community_comment_likes" to "service_role";

grant select on table "public"."community_comment_likes" to "service_role";

grant trigger on table "public"."community_comment_likes" to "service_role";

grant truncate on table "public"."community_comment_likes" to "service_role";

grant update on table "public"."community_comment_likes" to "service_role";

grant delete on table "public"."community_comments" to "anon";

grant insert on table "public"."community_comments" to "anon";

grant references on table "public"."community_comments" to "anon";

grant select on table "public"."community_comments" to "anon";

grant trigger on table "public"."community_comments" to "anon";

grant truncate on table "public"."community_comments" to "anon";

grant update on table "public"."community_comments" to "anon";

grant delete on table "public"."community_comments" to "authenticated";

grant insert on table "public"."community_comments" to "authenticated";

grant references on table "public"."community_comments" to "authenticated";

grant select on table "public"."community_comments" to "authenticated";

grant trigger on table "public"."community_comments" to "authenticated";

grant truncate on table "public"."community_comments" to "authenticated";

grant update on table "public"."community_comments" to "authenticated";

grant delete on table "public"."community_comments" to "service_role";

grant insert on table "public"."community_comments" to "service_role";

grant references on table "public"."community_comments" to "service_role";

grant select on table "public"."community_comments" to "service_role";

grant trigger on table "public"."community_comments" to "service_role";

grant truncate on table "public"."community_comments" to "service_role";

grant update on table "public"."community_comments" to "service_role";

grant delete on table "public"."community_post_images" to "anon";

grant insert on table "public"."community_post_images" to "anon";

grant references on table "public"."community_post_images" to "anon";

grant select on table "public"."community_post_images" to "anon";

grant trigger on table "public"."community_post_images" to "anon";

grant truncate on table "public"."community_post_images" to "anon";

grant update on table "public"."community_post_images" to "anon";

grant delete on table "public"."community_post_images" to "authenticated";

grant insert on table "public"."community_post_images" to "authenticated";

grant references on table "public"."community_post_images" to "authenticated";

grant select on table "public"."community_post_images" to "authenticated";

grant trigger on table "public"."community_post_images" to "authenticated";

grant truncate on table "public"."community_post_images" to "authenticated";

grant update on table "public"."community_post_images" to "authenticated";

grant delete on table "public"."community_post_images" to "service_role";

grant insert on table "public"."community_post_images" to "service_role";

grant references on table "public"."community_post_images" to "service_role";

grant select on table "public"."community_post_images" to "service_role";

grant trigger on table "public"."community_post_images" to "service_role";

grant truncate on table "public"."community_post_images" to "service_role";

grant update on table "public"."community_post_images" to "service_role";

grant delete on table "public"."community_post_likes" to "anon";

grant insert on table "public"."community_post_likes" to "anon";

grant references on table "public"."community_post_likes" to "anon";

grant select on table "public"."community_post_likes" to "anon";

grant trigger on table "public"."community_post_likes" to "anon";

grant truncate on table "public"."community_post_likes" to "anon";

grant update on table "public"."community_post_likes" to "anon";

grant delete on table "public"."community_post_likes" to "authenticated";

grant insert on table "public"."community_post_likes" to "authenticated";

grant references on table "public"."community_post_likes" to "authenticated";

grant select on table "public"."community_post_likes" to "authenticated";

grant trigger on table "public"."community_post_likes" to "authenticated";

grant truncate on table "public"."community_post_likes" to "authenticated";

grant update on table "public"."community_post_likes" to "authenticated";

grant delete on table "public"."community_post_likes" to "service_role";

grant insert on table "public"."community_post_likes" to "service_role";

grant references on table "public"."community_post_likes" to "service_role";

grant select on table "public"."community_post_likes" to "service_role";

grant trigger on table "public"."community_post_likes" to "service_role";

grant truncate on table "public"."community_post_likes" to "service_role";

grant update on table "public"."community_post_likes" to "service_role";

grant delete on table "public"."community_posts" to "anon";

grant insert on table "public"."community_posts" to "anon";

grant references on table "public"."community_posts" to "anon";

grant select on table "public"."community_posts" to "anon";

grant trigger on table "public"."community_posts" to "anon";

grant truncate on table "public"."community_posts" to "anon";

grant update on table "public"."community_posts" to "anon";

grant delete on table "public"."community_posts" to "authenticated";

grant insert on table "public"."community_posts" to "authenticated";

grant references on table "public"."community_posts" to "authenticated";

grant select on table "public"."community_posts" to "authenticated";

grant trigger on table "public"."community_posts" to "authenticated";

grant truncate on table "public"."community_posts" to "authenticated";

grant update on table "public"."community_posts" to "authenticated";

grant delete on table "public"."community_posts" to "service_role";

grant insert on table "public"."community_posts" to "service_role";

grant references on table "public"."community_posts" to "service_role";

grant select on table "public"."community_posts" to "service_role";

grant trigger on table "public"."community_posts" to "service_role";

grant truncate on table "public"."community_posts" to "service_role";

grant update on table "public"."community_posts" to "service_role";

grant delete on table "public"."delivery_fee_config_v2" to "anon";

grant insert on table "public"."delivery_fee_config_v2" to "anon";

grant references on table "public"."delivery_fee_config_v2" to "anon";

grant select on table "public"."delivery_fee_config_v2" to "anon";

grant trigger on table "public"."delivery_fee_config_v2" to "anon";

grant truncate on table "public"."delivery_fee_config_v2" to "anon";

grant update on table "public"."delivery_fee_config_v2" to "anon";

grant delete on table "public"."delivery_fee_config_v2" to "authenticated";

grant insert on table "public"."delivery_fee_config_v2" to "authenticated";

grant references on table "public"."delivery_fee_config_v2" to "authenticated";

grant select on table "public"."delivery_fee_config_v2" to "authenticated";

grant trigger on table "public"."delivery_fee_config_v2" to "authenticated";

grant truncate on table "public"."delivery_fee_config_v2" to "authenticated";

grant update on table "public"."delivery_fee_config_v2" to "authenticated";

grant delete on table "public"."delivery_fee_config_v2" to "service_role";

grant insert on table "public"."delivery_fee_config_v2" to "service_role";

grant references on table "public"."delivery_fee_config_v2" to "service_role";

grant select on table "public"."delivery_fee_config_v2" to "service_role";

grant trigger on table "public"."delivery_fee_config_v2" to "service_role";

grant truncate on table "public"."delivery_fee_config_v2" to "service_role";

grant update on table "public"."delivery_fee_config_v2" to "service_role";

grant delete on table "public"."delivery_fee_history" to "anon";

grant insert on table "public"."delivery_fee_history" to "anon";

grant references on table "public"."delivery_fee_history" to "anon";

grant select on table "public"."delivery_fee_history" to "anon";

grant trigger on table "public"."delivery_fee_history" to "anon";

grant truncate on table "public"."delivery_fee_history" to "anon";

grant update on table "public"."delivery_fee_history" to "anon";

grant delete on table "public"."delivery_fee_history" to "authenticated";

grant insert on table "public"."delivery_fee_history" to "authenticated";

grant references on table "public"."delivery_fee_history" to "authenticated";

grant select on table "public"."delivery_fee_history" to "authenticated";

grant trigger on table "public"."delivery_fee_history" to "authenticated";

grant truncate on table "public"."delivery_fee_history" to "authenticated";

grant update on table "public"."delivery_fee_history" to "authenticated";

grant delete on table "public"."delivery_fee_history" to "service_role";

grant insert on table "public"."delivery_fee_history" to "service_role";

grant references on table "public"."delivery_fee_history" to "service_role";

grant select on table "public"."delivery_fee_history" to "service_role";

grant trigger on table "public"."delivery_fee_history" to "service_role";

grant truncate on table "public"."delivery_fee_history" to "service_role";

grant update on table "public"."delivery_fee_history" to "service_role";

grant delete on table "public"."delivery_fee_settings" to "anon";

grant insert on table "public"."delivery_fee_settings" to "anon";

grant references on table "public"."delivery_fee_settings" to "anon";

grant select on table "public"."delivery_fee_settings" to "anon";

grant trigger on table "public"."delivery_fee_settings" to "anon";

grant truncate on table "public"."delivery_fee_settings" to "anon";

grant update on table "public"."delivery_fee_settings" to "anon";

grant delete on table "public"."delivery_fee_settings" to "authenticated";

grant insert on table "public"."delivery_fee_settings" to "authenticated";

grant references on table "public"."delivery_fee_settings" to "authenticated";

grant select on table "public"."delivery_fee_settings" to "authenticated";

grant trigger on table "public"."delivery_fee_settings" to "authenticated";

grant truncate on table "public"."delivery_fee_settings" to "authenticated";

grant update on table "public"."delivery_fee_settings" to "authenticated";

grant delete on table "public"."delivery_fee_settings" to "service_role";

grant insert on table "public"."delivery_fee_settings" to "service_role";

grant references on table "public"."delivery_fee_settings" to "service_role";

grant select on table "public"."delivery_fee_settings" to "service_role";

grant trigger on table "public"."delivery_fee_settings" to "service_role";

grant truncate on table "public"."delivery_fee_settings" to "service_role";

grant update on table "public"."delivery_fee_settings" to "service_role";

grant delete on table "public"."delivery_fee_tiers" to "anon";

grant insert on table "public"."delivery_fee_tiers" to "anon";

grant references on table "public"."delivery_fee_tiers" to "anon";

grant select on table "public"."delivery_fee_tiers" to "anon";

grant trigger on table "public"."delivery_fee_tiers" to "anon";

grant truncate on table "public"."delivery_fee_tiers" to "anon";

grant update on table "public"."delivery_fee_tiers" to "anon";

grant delete on table "public"."delivery_fee_tiers" to "authenticated";

grant insert on table "public"."delivery_fee_tiers" to "authenticated";

grant references on table "public"."delivery_fee_tiers" to "authenticated";

grant select on table "public"."delivery_fee_tiers" to "authenticated";

grant trigger on table "public"."delivery_fee_tiers" to "authenticated";

grant truncate on table "public"."delivery_fee_tiers" to "authenticated";

grant update on table "public"."delivery_fee_tiers" to "authenticated";

grant delete on table "public"."delivery_fee_tiers" to "service_role";

grant insert on table "public"."delivery_fee_tiers" to "service_role";

grant references on table "public"."delivery_fee_tiers" to "service_role";

grant select on table "public"."delivery_fee_tiers" to "service_role";

grant trigger on table "public"."delivery_fee_tiers" to "service_role";

grant truncate on table "public"."delivery_fee_tiers" to "service_role";

grant update on table "public"."delivery_fee_tiers" to "service_role";

grant delete on table "public"."delivery_notes" to "anon";

grant insert on table "public"."delivery_notes" to "anon";

grant references on table "public"."delivery_notes" to "anon";

grant select on table "public"."delivery_notes" to "anon";

grant trigger on table "public"."delivery_notes" to "anon";

grant truncate on table "public"."delivery_notes" to "anon";

grant update on table "public"."delivery_notes" to "anon";

grant delete on table "public"."delivery_notes" to "authenticated";

grant insert on table "public"."delivery_notes" to "authenticated";

grant references on table "public"."delivery_notes" to "authenticated";

grant select on table "public"."delivery_notes" to "authenticated";

grant trigger on table "public"."delivery_notes" to "authenticated";

grant truncate on table "public"."delivery_notes" to "authenticated";

grant update on table "public"."delivery_notes" to "authenticated";

grant delete on table "public"."delivery_notes" to "service_role";

grant insert on table "public"."delivery_notes" to "service_role";

grant references on table "public"."delivery_notes" to "service_role";

grant select on table "public"."delivery_notes" to "service_role";

grant trigger on table "public"."delivery_notes" to "service_role";

grant truncate on table "public"."delivery_notes" to "service_role";

grant update on table "public"."delivery_notes" to "service_role";

grant delete on table "public"."delivery_window_allocations" to "anon";

grant insert on table "public"."delivery_window_allocations" to "anon";

grant references on table "public"."delivery_window_allocations" to "anon";

grant select on table "public"."delivery_window_allocations" to "anon";

grant trigger on table "public"."delivery_window_allocations" to "anon";

grant truncate on table "public"."delivery_window_allocations" to "anon";

grant update on table "public"."delivery_window_allocations" to "anon";

grant delete on table "public"."delivery_window_allocations" to "authenticated";

grant insert on table "public"."delivery_window_allocations" to "authenticated";

grant references on table "public"."delivery_window_allocations" to "authenticated";

grant select on table "public"."delivery_window_allocations" to "authenticated";

grant trigger on table "public"."delivery_window_allocations" to "authenticated";

grant truncate on table "public"."delivery_window_allocations" to "authenticated";

grant update on table "public"."delivery_window_allocations" to "authenticated";

grant delete on table "public"."delivery_window_allocations" to "service_role";

grant insert on table "public"."delivery_window_allocations" to "service_role";

grant references on table "public"."delivery_window_allocations" to "service_role";

grant select on table "public"."delivery_window_allocations" to "service_role";

grant trigger on table "public"."delivery_window_allocations" to "service_role";

grant truncate on table "public"."delivery_window_allocations" to "service_role";

grant update on table "public"."delivery_window_allocations" to "service_role";

grant delete on table "public"."delivery_windows" to "anon";

grant insert on table "public"."delivery_windows" to "anon";

grant references on table "public"."delivery_windows" to "anon";

grant select on table "public"."delivery_windows" to "anon";

grant trigger on table "public"."delivery_windows" to "anon";

grant truncate on table "public"."delivery_windows" to "anon";

grant update on table "public"."delivery_windows" to "anon";

grant delete on table "public"."delivery_windows" to "authenticated";

grant insert on table "public"."delivery_windows" to "authenticated";

grant references on table "public"."delivery_windows" to "authenticated";

grant select on table "public"."delivery_windows" to "authenticated";

grant trigger on table "public"."delivery_windows" to "authenticated";

grant truncate on table "public"."delivery_windows" to "authenticated";

grant update on table "public"."delivery_windows" to "authenticated";

grant delete on table "public"."delivery_windows" to "service_role";

grant insert on table "public"."delivery_windows" to "service_role";

grant references on table "public"."delivery_windows" to "service_role";

grant select on table "public"."delivery_windows" to "service_role";

grant trigger on table "public"."delivery_windows" to "service_role";

grant truncate on table "public"."delivery_windows" to "service_role";

grant update on table "public"."delivery_windows" to "service_role";

grant delete on table "public"."discount_code_usage" to "anon";

grant insert on table "public"."discount_code_usage" to "anon";

grant references on table "public"."discount_code_usage" to "anon";

grant select on table "public"."discount_code_usage" to "anon";

grant trigger on table "public"."discount_code_usage" to "anon";

grant truncate on table "public"."discount_code_usage" to "anon";

grant update on table "public"."discount_code_usage" to "anon";

grant delete on table "public"."discount_code_usage" to "authenticated";

grant insert on table "public"."discount_code_usage" to "authenticated";

grant references on table "public"."discount_code_usage" to "authenticated";

grant select on table "public"."discount_code_usage" to "authenticated";

grant trigger on table "public"."discount_code_usage" to "authenticated";

grant truncate on table "public"."discount_code_usage" to "authenticated";

grant update on table "public"."discount_code_usage" to "authenticated";

grant delete on table "public"."discount_code_usage" to "service_role";

grant insert on table "public"."discount_code_usage" to "service_role";

grant references on table "public"."discount_code_usage" to "service_role";

grant select on table "public"."discount_code_usage" to "service_role";

grant trigger on table "public"."discount_code_usage" to "service_role";

grant truncate on table "public"."discount_code_usage" to "service_role";

grant update on table "public"."discount_code_usage" to "service_role";

grant delete on table "public"."discount_codes" to "anon";

grant insert on table "public"."discount_codes" to "anon";

grant references on table "public"."discount_codes" to "anon";

grant select on table "public"."discount_codes" to "anon";

grant trigger on table "public"."discount_codes" to "anon";

grant truncate on table "public"."discount_codes" to "anon";

grant update on table "public"."discount_codes" to "anon";

grant delete on table "public"."discount_codes" to "authenticated";

grant insert on table "public"."discount_codes" to "authenticated";

grant references on table "public"."discount_codes" to "authenticated";

grant select on table "public"."discount_codes" to "authenticated";

grant trigger on table "public"."discount_codes" to "authenticated";

grant truncate on table "public"."discount_codes" to "authenticated";

grant update on table "public"."discount_codes" to "authenticated";

grant delete on table "public"."discount_codes" to "service_role";

grant insert on table "public"."discount_codes" to "service_role";

grant references on table "public"."discount_codes" to "service_role";

grant select on table "public"."discount_codes" to "service_role";

grant trigger on table "public"."discount_codes" to "service_role";

grant truncate on table "public"."discount_codes" to "service_role";

grant update on table "public"."discount_codes" to "service_role";

grant delete on table "public"."document_verification_history" to "anon";

grant insert on table "public"."document_verification_history" to "anon";

grant references on table "public"."document_verification_history" to "anon";

grant select on table "public"."document_verification_history" to "anon";

grant trigger on table "public"."document_verification_history" to "anon";

grant truncate on table "public"."document_verification_history" to "anon";

grant update on table "public"."document_verification_history" to "anon";

grant delete on table "public"."document_verification_history" to "authenticated";

grant insert on table "public"."document_verification_history" to "authenticated";

grant references on table "public"."document_verification_history" to "authenticated";

grant select on table "public"."document_verification_history" to "authenticated";

grant trigger on table "public"."document_verification_history" to "authenticated";

grant truncate on table "public"."document_verification_history" to "authenticated";

grant update on table "public"."document_verification_history" to "authenticated";

grant delete on table "public"."document_verification_history" to "service_role";

grant insert on table "public"."document_verification_history" to "service_role";

grant references on table "public"."document_verification_history" to "service_role";

grant select on table "public"."document_verification_history" to "service_role";

grant trigger on table "public"."document_verification_history" to "service_role";

grant truncate on table "public"."document_verification_history" to "service_role";

grant update on table "public"."document_verification_history" to "service_role";

grant delete on table "public"."documents" to "anon";

grant insert on table "public"."documents" to "anon";

grant references on table "public"."documents" to "anon";

grant select on table "public"."documents" to "anon";

grant trigger on table "public"."documents" to "anon";

grant truncate on table "public"."documents" to "anon";

grant update on table "public"."documents" to "anon";

grant delete on table "public"."documents" to "authenticated";

grant insert on table "public"."documents" to "authenticated";

grant references on table "public"."documents" to "authenticated";

grant select on table "public"."documents" to "authenticated";

grant trigger on table "public"."documents" to "authenticated";

grant truncate on table "public"."documents" to "authenticated";

grant update on table "public"."documents" to "authenticated";

grant delete on table "public"."documents" to "service_role";

grant insert on table "public"."documents" to "service_role";

grant references on table "public"."documents" to "service_role";

grant select on table "public"."documents" to "service_role";

grant trigger on table "public"."documents" to "service_role";

grant truncate on table "public"."documents" to "service_role";

grant update on table "public"."documents" to "service_role";

grant delete on table "public"."fcm_store" to "anon";

grant insert on table "public"."fcm_store" to "anon";

grant references on table "public"."fcm_store" to "anon";

grant select on table "public"."fcm_store" to "anon";

grant trigger on table "public"."fcm_store" to "anon";

grant truncate on table "public"."fcm_store" to "anon";

grant update on table "public"."fcm_store" to "anon";

grant delete on table "public"."fcm_store" to "authenticated";

grant insert on table "public"."fcm_store" to "authenticated";

grant references on table "public"."fcm_store" to "authenticated";

grant select on table "public"."fcm_store" to "authenticated";

grant trigger on table "public"."fcm_store" to "authenticated";

grant truncate on table "public"."fcm_store" to "authenticated";

grant update on table "public"."fcm_store" to "authenticated";

grant delete on table "public"."fcm_store" to "service_role";

grant insert on table "public"."fcm_store" to "service_role";

grant references on table "public"."fcm_store" to "service_role";

grant select on table "public"."fcm_store" to "service_role";

grant trigger on table "public"."fcm_store" to "service_role";

grant truncate on table "public"."fcm_store" to "service_role";

grant update on table "public"."fcm_store" to "service_role";

grant delete on table "public"."hotel_booking_status_history" to "anon";

grant insert on table "public"."hotel_booking_status_history" to "anon";

grant references on table "public"."hotel_booking_status_history" to "anon";

grant select on table "public"."hotel_booking_status_history" to "anon";

grant trigger on table "public"."hotel_booking_status_history" to "anon";

grant truncate on table "public"."hotel_booking_status_history" to "anon";

grant update on table "public"."hotel_booking_status_history" to "anon";

grant delete on table "public"."hotel_booking_status_history" to "authenticated";

grant insert on table "public"."hotel_booking_status_history" to "authenticated";

grant references on table "public"."hotel_booking_status_history" to "authenticated";

grant select on table "public"."hotel_booking_status_history" to "authenticated";

grant trigger on table "public"."hotel_booking_status_history" to "authenticated";

grant truncate on table "public"."hotel_booking_status_history" to "authenticated";

grant update on table "public"."hotel_booking_status_history" to "authenticated";

grant delete on table "public"."hotel_booking_status_history" to "service_role";

grant insert on table "public"."hotel_booking_status_history" to "service_role";

grant references on table "public"."hotel_booking_status_history" to "service_role";

grant select on table "public"."hotel_booking_status_history" to "service_role";

grant trigger on table "public"."hotel_booking_status_history" to "service_role";

grant truncate on table "public"."hotel_booking_status_history" to "service_role";

grant update on table "public"."hotel_booking_status_history" to "service_role";

grant delete on table "public"."hotel_bookings" to "anon";

grant insert on table "public"."hotel_bookings" to "anon";

grant references on table "public"."hotel_bookings" to "anon";

grant select on table "public"."hotel_bookings" to "anon";

grant trigger on table "public"."hotel_bookings" to "anon";

grant truncate on table "public"."hotel_bookings" to "anon";

grant update on table "public"."hotel_bookings" to "anon";

grant delete on table "public"."hotel_bookings" to "authenticated";

grant insert on table "public"."hotel_bookings" to "authenticated";

grant references on table "public"."hotel_bookings" to "authenticated";

grant select on table "public"."hotel_bookings" to "authenticated";

grant trigger on table "public"."hotel_bookings" to "authenticated";

grant truncate on table "public"."hotel_bookings" to "authenticated";

grant update on table "public"."hotel_bookings" to "authenticated";

grant delete on table "public"."hotel_bookings" to "service_role";

grant insert on table "public"."hotel_bookings" to "service_role";

grant references on table "public"."hotel_bookings" to "service_role";

grant select on table "public"."hotel_bookings" to "service_role";

grant trigger on table "public"."hotel_bookings" to "service_role";

grant truncate on table "public"."hotel_bookings" to "service_role";

grant update on table "public"."hotel_bookings" to "service_role";

grant delete on table "public"."hotel_hourly_availability" to "anon";

grant insert on table "public"."hotel_hourly_availability" to "anon";

grant references on table "public"."hotel_hourly_availability" to "anon";

grant select on table "public"."hotel_hourly_availability" to "anon";

grant trigger on table "public"."hotel_hourly_availability" to "anon";

grant truncate on table "public"."hotel_hourly_availability" to "anon";

grant update on table "public"."hotel_hourly_availability" to "anon";

grant delete on table "public"."hotel_hourly_availability" to "authenticated";

grant insert on table "public"."hotel_hourly_availability" to "authenticated";

grant references on table "public"."hotel_hourly_availability" to "authenticated";

grant select on table "public"."hotel_hourly_availability" to "authenticated";

grant trigger on table "public"."hotel_hourly_availability" to "authenticated";

grant truncate on table "public"."hotel_hourly_availability" to "authenticated";

grant update on table "public"."hotel_hourly_availability" to "authenticated";

grant delete on table "public"."hotel_hourly_availability" to "service_role";

grant insert on table "public"."hotel_hourly_availability" to "service_role";

grant references on table "public"."hotel_hourly_availability" to "service_role";

grant select on table "public"."hotel_hourly_availability" to "service_role";

grant trigger on table "public"."hotel_hourly_availability" to "service_role";

grant truncate on table "public"."hotel_hourly_availability" to "service_role";

grant update on table "public"."hotel_hourly_availability" to "service_role";

grant delete on table "public"."hotel_notifications" to "anon";

grant insert on table "public"."hotel_notifications" to "anon";

grant references on table "public"."hotel_notifications" to "anon";

grant select on table "public"."hotel_notifications" to "anon";

grant trigger on table "public"."hotel_notifications" to "anon";

grant truncate on table "public"."hotel_notifications" to "anon";

grant update on table "public"."hotel_notifications" to "anon";

grant delete on table "public"."hotel_notifications" to "authenticated";

grant insert on table "public"."hotel_notifications" to "authenticated";

grant references on table "public"."hotel_notifications" to "authenticated";

grant select on table "public"."hotel_notifications" to "authenticated";

grant trigger on table "public"."hotel_notifications" to "authenticated";

grant truncate on table "public"."hotel_notifications" to "authenticated";

grant update on table "public"."hotel_notifications" to "authenticated";

grant delete on table "public"."hotel_notifications" to "service_role";

grant insert on table "public"."hotel_notifications" to "service_role";

grant references on table "public"."hotel_notifications" to "service_role";

grant select on table "public"."hotel_notifications" to "service_role";

grant trigger on table "public"."hotel_notifications" to "service_role";

grant truncate on table "public"."hotel_notifications" to "service_role";

grant update on table "public"."hotel_notifications" to "service_role";

grant delete on table "public"."hotel_owner_accounts" to "anon";

grant insert on table "public"."hotel_owner_accounts" to "anon";

grant references on table "public"."hotel_owner_accounts" to "anon";

grant select on table "public"."hotel_owner_accounts" to "anon";

grant trigger on table "public"."hotel_owner_accounts" to "anon";

grant truncate on table "public"."hotel_owner_accounts" to "anon";

grant update on table "public"."hotel_owner_accounts" to "anon";

grant delete on table "public"."hotel_owner_accounts" to "authenticated";

grant insert on table "public"."hotel_owner_accounts" to "authenticated";

grant references on table "public"."hotel_owner_accounts" to "authenticated";

grant select on table "public"."hotel_owner_accounts" to "authenticated";

grant trigger on table "public"."hotel_owner_accounts" to "authenticated";

grant truncate on table "public"."hotel_owner_accounts" to "authenticated";

grant update on table "public"."hotel_owner_accounts" to "authenticated";

grant delete on table "public"."hotel_owner_accounts" to "service_role";

grant insert on table "public"."hotel_owner_accounts" to "service_role";

grant references on table "public"."hotel_owner_accounts" to "service_role";

grant select on table "public"."hotel_owner_accounts" to "service_role";

grant trigger on table "public"."hotel_owner_accounts" to "service_role";

grant truncate on table "public"."hotel_owner_accounts" to "service_role";

grant update on table "public"."hotel_owner_accounts" to "service_role";

grant delete on table "public"."hotel_properties" to "anon";

grant insert on table "public"."hotel_properties" to "anon";

grant references on table "public"."hotel_properties" to "anon";

grant select on table "public"."hotel_properties" to "anon";

grant trigger on table "public"."hotel_properties" to "anon";

grant truncate on table "public"."hotel_properties" to "anon";

grant update on table "public"."hotel_properties" to "anon";

grant delete on table "public"."hotel_properties" to "authenticated";

grant insert on table "public"."hotel_properties" to "authenticated";

grant references on table "public"."hotel_properties" to "authenticated";

grant select on table "public"."hotel_properties" to "authenticated";

grant trigger on table "public"."hotel_properties" to "authenticated";

grant truncate on table "public"."hotel_properties" to "authenticated";

grant update on table "public"."hotel_properties" to "authenticated";

grant delete on table "public"."hotel_properties" to "service_role";

grant insert on table "public"."hotel_properties" to "service_role";

grant references on table "public"."hotel_properties" to "service_role";

grant select on table "public"."hotel_properties" to "service_role";

grant trigger on table "public"."hotel_properties" to "service_role";

grant truncate on table "public"."hotel_properties" to "service_role";

grant update on table "public"."hotel_properties" to "service_role";

grant delete on table "public"."hotel_reviews" to "anon";

grant insert on table "public"."hotel_reviews" to "anon";

grant references on table "public"."hotel_reviews" to "anon";

grant select on table "public"."hotel_reviews" to "anon";

grant trigger on table "public"."hotel_reviews" to "anon";

grant truncate on table "public"."hotel_reviews" to "anon";

grant update on table "public"."hotel_reviews" to "anon";

grant delete on table "public"."hotel_reviews" to "authenticated";

grant insert on table "public"."hotel_reviews" to "authenticated";

grant references on table "public"."hotel_reviews" to "authenticated";

grant select on table "public"."hotel_reviews" to "authenticated";

grant trigger on table "public"."hotel_reviews" to "authenticated";

grant truncate on table "public"."hotel_reviews" to "authenticated";

grant update on table "public"."hotel_reviews" to "authenticated";

grant delete on table "public"."hotel_reviews" to "service_role";

grant insert on table "public"."hotel_reviews" to "service_role";

grant references on table "public"."hotel_reviews" to "service_role";

grant select on table "public"."hotel_reviews" to "service_role";

grant trigger on table "public"."hotel_reviews" to "service_role";

grant truncate on table "public"."hotel_reviews" to "service_role";

grant update on table "public"."hotel_reviews" to "service_role";

grant delete on table "public"."hotel_room_availability" to "anon";

grant insert on table "public"."hotel_room_availability" to "anon";

grant references on table "public"."hotel_room_availability" to "anon";

grant select on table "public"."hotel_room_availability" to "anon";

grant trigger on table "public"."hotel_room_availability" to "anon";

grant truncate on table "public"."hotel_room_availability" to "anon";

grant update on table "public"."hotel_room_availability" to "anon";

grant delete on table "public"."hotel_room_availability" to "authenticated";

grant insert on table "public"."hotel_room_availability" to "authenticated";

grant references on table "public"."hotel_room_availability" to "authenticated";

grant select on table "public"."hotel_room_availability" to "authenticated";

grant trigger on table "public"."hotel_room_availability" to "authenticated";

grant truncate on table "public"."hotel_room_availability" to "authenticated";

grant update on table "public"."hotel_room_availability" to "authenticated";

grant delete on table "public"."hotel_room_availability" to "service_role";

grant insert on table "public"."hotel_room_availability" to "service_role";

grant references on table "public"."hotel_room_availability" to "service_role";

grant select on table "public"."hotel_room_availability" to "service_role";

grant trigger on table "public"."hotel_room_availability" to "service_role";

grant truncate on table "public"."hotel_room_availability" to "service_role";

grant update on table "public"."hotel_room_availability" to "service_role";

grant delete on table "public"."hotel_room_types" to "anon";

grant insert on table "public"."hotel_room_types" to "anon";

grant references on table "public"."hotel_room_types" to "anon";

grant select on table "public"."hotel_room_types" to "anon";

grant trigger on table "public"."hotel_room_types" to "anon";

grant truncate on table "public"."hotel_room_types" to "anon";

grant update on table "public"."hotel_room_types" to "anon";

grant delete on table "public"."hotel_room_types" to "authenticated";

grant insert on table "public"."hotel_room_types" to "authenticated";

grant references on table "public"."hotel_room_types" to "authenticated";

grant select on table "public"."hotel_room_types" to "authenticated";

grant trigger on table "public"."hotel_room_types" to "authenticated";

grant truncate on table "public"."hotel_room_types" to "authenticated";

grant update on table "public"."hotel_room_types" to "authenticated";

grant delete on table "public"."hotel_room_types" to "service_role";

grant insert on table "public"."hotel_room_types" to "service_role";

grant references on table "public"."hotel_room_types" to "service_role";

grant select on table "public"."hotel_room_types" to "service_role";

grant trigger on table "public"."hotel_room_types" to "service_role";

grant truncate on table "public"."hotel_room_types" to "service_role";

grant update on table "public"."hotel_room_types" to "service_role";

grant delete on table "public"."hotel_rooms" to "anon";

grant insert on table "public"."hotel_rooms" to "anon";

grant references on table "public"."hotel_rooms" to "anon";

grant select on table "public"."hotel_rooms" to "anon";

grant trigger on table "public"."hotel_rooms" to "anon";

grant truncate on table "public"."hotel_rooms" to "anon";

grant update on table "public"."hotel_rooms" to "anon";

grant delete on table "public"."hotel_rooms" to "authenticated";

grant insert on table "public"."hotel_rooms" to "authenticated";

grant references on table "public"."hotel_rooms" to "authenticated";

grant select on table "public"."hotel_rooms" to "authenticated";

grant trigger on table "public"."hotel_rooms" to "authenticated";

grant truncate on table "public"."hotel_rooms" to "authenticated";

grant update on table "public"."hotel_rooms" to "authenticated";

grant delete on table "public"."hotel_rooms" to "service_role";

grant insert on table "public"."hotel_rooms" to "service_role";

grant references on table "public"."hotel_rooms" to "service_role";

grant select on table "public"."hotel_rooms" to "service_role";

grant trigger on table "public"."hotel_rooms" to "service_role";

grant truncate on table "public"."hotel_rooms" to "service_role";

grant update on table "public"."hotel_rooms" to "service_role";

grant delete on table "public"."job_assignments" to "anon";

grant insert on table "public"."job_assignments" to "anon";

grant references on table "public"."job_assignments" to "anon";

grant select on table "public"."job_assignments" to "anon";

grant trigger on table "public"."job_assignments" to "anon";

grant truncate on table "public"."job_assignments" to "anon";

grant update on table "public"."job_assignments" to "anon";

grant delete on table "public"."job_assignments" to "authenticated";

grant insert on table "public"."job_assignments" to "authenticated";

grant references on table "public"."job_assignments" to "authenticated";

grant select on table "public"."job_assignments" to "authenticated";

grant trigger on table "public"."job_assignments" to "authenticated";

grant truncate on table "public"."job_assignments" to "authenticated";

grant update on table "public"."job_assignments" to "authenticated";

grant delete on table "public"."job_assignments" to "service_role";

grant insert on table "public"."job_assignments" to "service_role";

grant references on table "public"."job_assignments" to "service_role";

grant select on table "public"."job_assignments" to "service_role";

grant trigger on table "public"."job_assignments" to "service_role";

grant truncate on table "public"."job_assignments" to "service_role";

grant update on table "public"."job_assignments" to "service_role";

grant delete on table "public"."job_categories" to "anon";

grant insert on table "public"."job_categories" to "anon";

grant references on table "public"."job_categories" to "anon";

grant select on table "public"."job_categories" to "anon";

grant trigger on table "public"."job_categories" to "anon";

grant truncate on table "public"."job_categories" to "anon";

grant update on table "public"."job_categories" to "anon";

grant delete on table "public"."job_categories" to "authenticated";

grant insert on table "public"."job_categories" to "authenticated";

grant references on table "public"."job_categories" to "authenticated";

grant select on table "public"."job_categories" to "authenticated";

grant trigger on table "public"."job_categories" to "authenticated";

grant truncate on table "public"."job_categories" to "authenticated";

grant update on table "public"."job_categories" to "authenticated";

grant delete on table "public"."job_categories" to "service_role";

grant insert on table "public"."job_categories" to "service_role";

grant references on table "public"."job_categories" to "service_role";

grant select on table "public"."job_categories" to "service_role";

grant trigger on table "public"."job_categories" to "service_role";

grant truncate on table "public"."job_categories" to "service_role";

grant update on table "public"."job_categories" to "service_role";

grant delete on table "public"."job_company_bank_accounts" to "anon";

grant insert on table "public"."job_company_bank_accounts" to "anon";

grant references on table "public"."job_company_bank_accounts" to "anon";

grant select on table "public"."job_company_bank_accounts" to "anon";

grant trigger on table "public"."job_company_bank_accounts" to "anon";

grant truncate on table "public"."job_company_bank_accounts" to "anon";

grant update on table "public"."job_company_bank_accounts" to "anon";

grant delete on table "public"."job_company_bank_accounts" to "authenticated";

grant insert on table "public"."job_company_bank_accounts" to "authenticated";

grant references on table "public"."job_company_bank_accounts" to "authenticated";

grant select on table "public"."job_company_bank_accounts" to "authenticated";

grant trigger on table "public"."job_company_bank_accounts" to "authenticated";

grant truncate on table "public"."job_company_bank_accounts" to "authenticated";

grant update on table "public"."job_company_bank_accounts" to "authenticated";

grant delete on table "public"."job_company_bank_accounts" to "service_role";

grant insert on table "public"."job_company_bank_accounts" to "service_role";

grant references on table "public"."job_company_bank_accounts" to "service_role";

grant select on table "public"."job_company_bank_accounts" to "service_role";

grant trigger on table "public"."job_company_bank_accounts" to "service_role";

grant truncate on table "public"."job_company_bank_accounts" to "service_role";

grant update on table "public"."job_company_bank_accounts" to "service_role";

grant delete on table "public"."job_completion_approvals" to "anon";

grant insert on table "public"."job_completion_approvals" to "anon";

grant references on table "public"."job_completion_approvals" to "anon";

grant select on table "public"."job_completion_approvals" to "anon";

grant trigger on table "public"."job_completion_approvals" to "anon";

grant truncate on table "public"."job_completion_approvals" to "anon";

grant update on table "public"."job_completion_approvals" to "anon";

grant delete on table "public"."job_completion_approvals" to "authenticated";

grant insert on table "public"."job_completion_approvals" to "authenticated";

grant references on table "public"."job_completion_approvals" to "authenticated";

grant select on table "public"."job_completion_approvals" to "authenticated";

grant trigger on table "public"."job_completion_approvals" to "authenticated";

grant truncate on table "public"."job_completion_approvals" to "authenticated";

grant update on table "public"."job_completion_approvals" to "authenticated";

grant delete on table "public"."job_completion_approvals" to "service_role";

grant insert on table "public"."job_completion_approvals" to "service_role";

grant references on table "public"."job_completion_approvals" to "service_role";

grant select on table "public"."job_completion_approvals" to "service_role";

grant trigger on table "public"."job_completion_approvals" to "service_role";

grant truncate on table "public"."job_completion_approvals" to "service_role";

grant update on table "public"."job_completion_approvals" to "service_role";

grant delete on table "public"."job_fee_settings" to "anon";

grant insert on table "public"."job_fee_settings" to "anon";

grant references on table "public"."job_fee_settings" to "anon";

grant select on table "public"."job_fee_settings" to "anon";

grant trigger on table "public"."job_fee_settings" to "anon";

grant truncate on table "public"."job_fee_settings" to "anon";

grant update on table "public"."job_fee_settings" to "anon";

grant delete on table "public"."job_fee_settings" to "authenticated";

grant insert on table "public"."job_fee_settings" to "authenticated";

grant references on table "public"."job_fee_settings" to "authenticated";

grant select on table "public"."job_fee_settings" to "authenticated";

grant trigger on table "public"."job_fee_settings" to "authenticated";

grant truncate on table "public"."job_fee_settings" to "authenticated";

grant update on table "public"."job_fee_settings" to "authenticated";

grant delete on table "public"."job_fee_settings" to "service_role";

grant insert on table "public"."job_fee_settings" to "service_role";

grant references on table "public"."job_fee_settings" to "service_role";

grant select on table "public"."job_fee_settings" to "service_role";

grant trigger on table "public"."job_fee_settings" to "service_role";

grant truncate on table "public"."job_fee_settings" to "service_role";

grant update on table "public"."job_fee_settings" to "service_role";

grant delete on table "public"."job_postings" to "anon";

grant insert on table "public"."job_postings" to "anon";

grant references on table "public"."job_postings" to "anon";

grant select on table "public"."job_postings" to "anon";

grant trigger on table "public"."job_postings" to "anon";

grant truncate on table "public"."job_postings" to "anon";

grant update on table "public"."job_postings" to "anon";

grant delete on table "public"."job_postings" to "authenticated";

grant insert on table "public"."job_postings" to "authenticated";

grant references on table "public"."job_postings" to "authenticated";

grant select on table "public"."job_postings" to "authenticated";

grant trigger on table "public"."job_postings" to "authenticated";

grant truncate on table "public"."job_postings" to "authenticated";

grant update on table "public"."job_postings" to "authenticated";

grant delete on table "public"."job_postings" to "service_role";

grant insert on table "public"."job_postings" to "service_role";

grant references on table "public"."job_postings" to "service_role";

grant select on table "public"."job_postings" to "service_role";

grant trigger on table "public"."job_postings" to "service_role";

grant truncate on table "public"."job_postings" to "service_role";

grant update on table "public"."job_postings" to "service_role";

grant delete on table "public"."job_worker_credit_ledger" to "anon";

grant insert on table "public"."job_worker_credit_ledger" to "anon";

grant references on table "public"."job_worker_credit_ledger" to "anon";

grant select on table "public"."job_worker_credit_ledger" to "anon";

grant trigger on table "public"."job_worker_credit_ledger" to "anon";

grant truncate on table "public"."job_worker_credit_ledger" to "anon";

grant update on table "public"."job_worker_credit_ledger" to "anon";

grant delete on table "public"."job_worker_credit_ledger" to "authenticated";

grant insert on table "public"."job_worker_credit_ledger" to "authenticated";

grant references on table "public"."job_worker_credit_ledger" to "authenticated";

grant select on table "public"."job_worker_credit_ledger" to "authenticated";

grant trigger on table "public"."job_worker_credit_ledger" to "authenticated";

grant truncate on table "public"."job_worker_credit_ledger" to "authenticated";

grant update on table "public"."job_worker_credit_ledger" to "authenticated";

grant delete on table "public"."job_worker_credit_ledger" to "service_role";

grant insert on table "public"."job_worker_credit_ledger" to "service_role";

grant references on table "public"."job_worker_credit_ledger" to "service_role";

grant select on table "public"."job_worker_credit_ledger" to "service_role";

grant trigger on table "public"."job_worker_credit_ledger" to "service_role";

grant truncate on table "public"."job_worker_credit_ledger" to "service_role";

grant update on table "public"."job_worker_credit_ledger" to "service_role";

grant delete on table "public"."job_worker_credits" to "anon";

grant insert on table "public"."job_worker_credits" to "anon";

grant references on table "public"."job_worker_credits" to "anon";

grant select on table "public"."job_worker_credits" to "anon";

grant trigger on table "public"."job_worker_credits" to "anon";

grant truncate on table "public"."job_worker_credits" to "anon";

grant update on table "public"."job_worker_credits" to "anon";

grant delete on table "public"."job_worker_credits" to "authenticated";

grant insert on table "public"."job_worker_credits" to "authenticated";

grant references on table "public"."job_worker_credits" to "authenticated";

grant select on table "public"."job_worker_credits" to "authenticated";

grant trigger on table "public"."job_worker_credits" to "authenticated";

grant truncate on table "public"."job_worker_credits" to "authenticated";

grant update on table "public"."job_worker_credits" to "authenticated";

grant delete on table "public"."job_worker_credits" to "service_role";

grant insert on table "public"."job_worker_credits" to "service_role";

grant references on table "public"."job_worker_credits" to "service_role";

grant select on table "public"."job_worker_credits" to "service_role";

grant trigger on table "public"."job_worker_credits" to "service_role";

grant truncate on table "public"."job_worker_credits" to "service_role";

grant update on table "public"."job_worker_credits" to "service_role";

grant delete on table "public"."job_worker_fcm_tokens" to "anon";

grant insert on table "public"."job_worker_fcm_tokens" to "anon";

grant references on table "public"."job_worker_fcm_tokens" to "anon";

grant select on table "public"."job_worker_fcm_tokens" to "anon";

grant trigger on table "public"."job_worker_fcm_tokens" to "anon";

grant truncate on table "public"."job_worker_fcm_tokens" to "anon";

grant update on table "public"."job_worker_fcm_tokens" to "anon";

grant delete on table "public"."job_worker_fcm_tokens" to "authenticated";

grant insert on table "public"."job_worker_fcm_tokens" to "authenticated";

grant references on table "public"."job_worker_fcm_tokens" to "authenticated";

grant select on table "public"."job_worker_fcm_tokens" to "authenticated";

grant trigger on table "public"."job_worker_fcm_tokens" to "authenticated";

grant truncate on table "public"."job_worker_fcm_tokens" to "authenticated";

grant update on table "public"."job_worker_fcm_tokens" to "authenticated";

grant delete on table "public"."job_worker_fcm_tokens" to "service_role";

grant insert on table "public"."job_worker_fcm_tokens" to "service_role";

grant references on table "public"."job_worker_fcm_tokens" to "service_role";

grant select on table "public"."job_worker_fcm_tokens" to "service_role";

grant trigger on table "public"."job_worker_fcm_tokens" to "service_role";

grant truncate on table "public"."job_worker_fcm_tokens" to "service_role";

grant update on table "public"."job_worker_fcm_tokens" to "service_role";

grant delete on table "public"."job_worker_withdrawals" to "anon";

grant insert on table "public"."job_worker_withdrawals" to "anon";

grant references on table "public"."job_worker_withdrawals" to "anon";

grant select on table "public"."job_worker_withdrawals" to "anon";

grant trigger on table "public"."job_worker_withdrawals" to "anon";

grant truncate on table "public"."job_worker_withdrawals" to "anon";

grant update on table "public"."job_worker_withdrawals" to "anon";

grant delete on table "public"."job_worker_withdrawals" to "authenticated";

grant insert on table "public"."job_worker_withdrawals" to "authenticated";

grant references on table "public"."job_worker_withdrawals" to "authenticated";

grant select on table "public"."job_worker_withdrawals" to "authenticated";

grant trigger on table "public"."job_worker_withdrawals" to "authenticated";

grant truncate on table "public"."job_worker_withdrawals" to "authenticated";

grant update on table "public"."job_worker_withdrawals" to "authenticated";

grant delete on table "public"."job_worker_withdrawals" to "service_role";

grant insert on table "public"."job_worker_withdrawals" to "service_role";

grant references on table "public"."job_worker_withdrawals" to "service_role";

grant select on table "public"."job_worker_withdrawals" to "service_role";

grant trigger on table "public"."job_worker_withdrawals" to "service_role";

grant truncate on table "public"."job_worker_withdrawals" to "service_role";

grant update on table "public"."job_worker_withdrawals" to "service_role";

grant delete on table "public"."job_workers" to "anon";

grant insert on table "public"."job_workers" to "anon";

grant references on table "public"."job_workers" to "anon";

grant select on table "public"."job_workers" to "anon";

grant trigger on table "public"."job_workers" to "anon";

grant truncate on table "public"."job_workers" to "anon";

grant update on table "public"."job_workers" to "anon";

grant delete on table "public"."job_workers" to "authenticated";

grant insert on table "public"."job_workers" to "authenticated";

grant references on table "public"."job_workers" to "authenticated";

grant select on table "public"."job_workers" to "authenticated";

grant trigger on table "public"."job_workers" to "authenticated";

grant truncate on table "public"."job_workers" to "authenticated";

grant update on table "public"."job_workers" to "authenticated";

grant delete on table "public"."job_workers" to "service_role";

grant insert on table "public"."job_workers" to "service_role";

grant references on table "public"."job_workers" to "service_role";

grant select on table "public"."job_workers" to "service_role";

grant trigger on table "public"."job_workers" to "service_role";

grant truncate on table "public"."job_workers" to "service_role";

grant update on table "public"."job_workers" to "service_role";

grant delete on table "public"."loyalty_point_ledger" to "anon";

grant insert on table "public"."loyalty_point_ledger" to "anon";

grant references on table "public"."loyalty_point_ledger" to "anon";

grant select on table "public"."loyalty_point_ledger" to "anon";

grant trigger on table "public"."loyalty_point_ledger" to "anon";

grant truncate on table "public"."loyalty_point_ledger" to "anon";

grant update on table "public"."loyalty_point_ledger" to "anon";

grant delete on table "public"."loyalty_point_ledger" to "authenticated";

grant insert on table "public"."loyalty_point_ledger" to "authenticated";

grant references on table "public"."loyalty_point_ledger" to "authenticated";

grant select on table "public"."loyalty_point_ledger" to "authenticated";

grant trigger on table "public"."loyalty_point_ledger" to "authenticated";

grant truncate on table "public"."loyalty_point_ledger" to "authenticated";

grant update on table "public"."loyalty_point_ledger" to "authenticated";

grant delete on table "public"."loyalty_point_ledger" to "service_role";

grant insert on table "public"."loyalty_point_ledger" to "service_role";

grant references on table "public"."loyalty_point_ledger" to "service_role";

grant select on table "public"."loyalty_point_ledger" to "service_role";

grant trigger on table "public"."loyalty_point_ledger" to "service_role";

grant truncate on table "public"."loyalty_point_ledger" to "service_role";

grant update on table "public"."loyalty_point_ledger" to "service_role";

grant delete on table "public"."loyalty_point_rules" to "anon";

grant insert on table "public"."loyalty_point_rules" to "anon";

grant references on table "public"."loyalty_point_rules" to "anon";

grant select on table "public"."loyalty_point_rules" to "anon";

grant trigger on table "public"."loyalty_point_rules" to "anon";

grant truncate on table "public"."loyalty_point_rules" to "anon";

grant update on table "public"."loyalty_point_rules" to "anon";

grant delete on table "public"."loyalty_point_rules" to "authenticated";

grant insert on table "public"."loyalty_point_rules" to "authenticated";

grant references on table "public"."loyalty_point_rules" to "authenticated";

grant select on table "public"."loyalty_point_rules" to "authenticated";

grant trigger on table "public"."loyalty_point_rules" to "authenticated";

grant truncate on table "public"."loyalty_point_rules" to "authenticated";

grant update on table "public"."loyalty_point_rules" to "authenticated";

grant delete on table "public"."loyalty_point_rules" to "service_role";

grant insert on table "public"."loyalty_point_rules" to "service_role";

grant references on table "public"."loyalty_point_rules" to "service_role";

grant select on table "public"."loyalty_point_rules" to "service_role";

grant trigger on table "public"."loyalty_point_rules" to "service_role";

grant truncate on table "public"."loyalty_point_rules" to "service_role";

grant update on table "public"."loyalty_point_rules" to "service_role";

grant delete on table "public"."loyalty_redemption_rules" to "anon";

grant insert on table "public"."loyalty_redemption_rules" to "anon";

grant references on table "public"."loyalty_redemption_rules" to "anon";

grant select on table "public"."loyalty_redemption_rules" to "anon";

grant trigger on table "public"."loyalty_redemption_rules" to "anon";

grant truncate on table "public"."loyalty_redemption_rules" to "anon";

grant update on table "public"."loyalty_redemption_rules" to "anon";

grant delete on table "public"."loyalty_redemption_rules" to "authenticated";

grant insert on table "public"."loyalty_redemption_rules" to "authenticated";

grant references on table "public"."loyalty_redemption_rules" to "authenticated";

grant select on table "public"."loyalty_redemption_rules" to "authenticated";

grant trigger on table "public"."loyalty_redemption_rules" to "authenticated";

grant truncate on table "public"."loyalty_redemption_rules" to "authenticated";

grant update on table "public"."loyalty_redemption_rules" to "authenticated";

grant delete on table "public"."loyalty_redemption_rules" to "service_role";

grant insert on table "public"."loyalty_redemption_rules" to "service_role";

grant references on table "public"."loyalty_redemption_rules" to "service_role";

grant select on table "public"."loyalty_redemption_rules" to "service_role";

grant trigger on table "public"."loyalty_redemption_rules" to "service_role";

grant truncate on table "public"."loyalty_redemption_rules" to "service_role";

grant update on table "public"."loyalty_redemption_rules" to "service_role";

grant delete on table "public"."loyalty_tasks" to "anon";

grant insert on table "public"."loyalty_tasks" to "anon";

grant references on table "public"."loyalty_tasks" to "anon";

grant select on table "public"."loyalty_tasks" to "anon";

grant trigger on table "public"."loyalty_tasks" to "anon";

grant truncate on table "public"."loyalty_tasks" to "anon";

grant update on table "public"."loyalty_tasks" to "anon";

grant delete on table "public"."loyalty_tasks" to "authenticated";

grant insert on table "public"."loyalty_tasks" to "authenticated";

grant references on table "public"."loyalty_tasks" to "authenticated";

grant select on table "public"."loyalty_tasks" to "authenticated";

grant trigger on table "public"."loyalty_tasks" to "authenticated";

grant truncate on table "public"."loyalty_tasks" to "authenticated";

grant update on table "public"."loyalty_tasks" to "authenticated";

grant delete on table "public"."loyalty_tasks" to "service_role";

grant insert on table "public"."loyalty_tasks" to "service_role";

grant references on table "public"."loyalty_tasks" to "service_role";

grant select on table "public"."loyalty_tasks" to "service_role";

grant trigger on table "public"."loyalty_tasks" to "service_role";

grant truncate on table "public"."loyalty_tasks" to "service_role";

grant update on table "public"."loyalty_tasks" to "service_role";

grant delete on table "public"."new_order_for_riders" to "anon";

grant insert on table "public"."new_order_for_riders" to "anon";

grant references on table "public"."new_order_for_riders" to "anon";

grant select on table "public"."new_order_for_riders" to "anon";

grant trigger on table "public"."new_order_for_riders" to "anon";

grant truncate on table "public"."new_order_for_riders" to "anon";

grant update on table "public"."new_order_for_riders" to "anon";

grant delete on table "public"."new_order_for_riders" to "authenticated";

grant insert on table "public"."new_order_for_riders" to "authenticated";

grant references on table "public"."new_order_for_riders" to "authenticated";

grant select on table "public"."new_order_for_riders" to "authenticated";

grant trigger on table "public"."new_order_for_riders" to "authenticated";

grant truncate on table "public"."new_order_for_riders" to "authenticated";

grant update on table "public"."new_order_for_riders" to "authenticated";

grant delete on table "public"."new_order_for_riders" to "service_role";

grant insert on table "public"."new_order_for_riders" to "service_role";

grant references on table "public"."new_order_for_riders" to "service_role";

grant select on table "public"."new_order_for_riders" to "service_role";

grant trigger on table "public"."new_order_for_riders" to "service_role";

grant truncate on table "public"."new_order_for_riders" to "service_role";

grant update on table "public"."new_order_for_riders" to "service_role";

grant delete on table "public"."notification_logs" to "anon";

grant insert on table "public"."notification_logs" to "anon";

grant references on table "public"."notification_logs" to "anon";

grant select on table "public"."notification_logs" to "anon";

grant trigger on table "public"."notification_logs" to "anon";

grant truncate on table "public"."notification_logs" to "anon";

grant update on table "public"."notification_logs" to "anon";

grant delete on table "public"."notification_logs" to "authenticated";

grant insert on table "public"."notification_logs" to "authenticated";

grant references on table "public"."notification_logs" to "authenticated";

grant select on table "public"."notification_logs" to "authenticated";

grant trigger on table "public"."notification_logs" to "authenticated";

grant truncate on table "public"."notification_logs" to "authenticated";

grant update on table "public"."notification_logs" to "authenticated";

grant delete on table "public"."notification_logs" to "service_role";

grant insert on table "public"."notification_logs" to "service_role";

grant references on table "public"."notification_logs" to "service_role";

grant select on table "public"."notification_logs" to "service_role";

grant trigger on table "public"."notification_logs" to "service_role";

grant truncate on table "public"."notification_logs" to "service_role";

grant update on table "public"."notification_logs" to "service_role";

grant delete on table "public"."notifications" to "anon";

grant insert on table "public"."notifications" to "anon";

grant references on table "public"."notifications" to "anon";

grant select on table "public"."notifications" to "anon";

grant trigger on table "public"."notifications" to "anon";

grant truncate on table "public"."notifications" to "anon";

grant update on table "public"."notifications" to "anon";

grant delete on table "public"."notifications" to "authenticated";

grant insert on table "public"."notifications" to "authenticated";

grant references on table "public"."notifications" to "authenticated";

grant select on table "public"."notifications" to "authenticated";

grant trigger on table "public"."notifications" to "authenticated";

grant truncate on table "public"."notifications" to "authenticated";

grant update on table "public"."notifications" to "authenticated";

grant delete on table "public"."notifications" to "service_role";

grant insert on table "public"."notifications" to "service_role";

grant references on table "public"."notifications" to "service_role";

grant select on table "public"."notifications" to "service_role";

grant trigger on table "public"."notifications" to "service_role";

grant truncate on table "public"."notifications" to "service_role";

grant update on table "public"."notifications" to "service_role";

grant delete on table "public"."order_checklist_photos" to "anon";

grant insert on table "public"."order_checklist_photos" to "anon";

grant references on table "public"."order_checklist_photos" to "anon";

grant select on table "public"."order_checklist_photos" to "anon";

grant trigger on table "public"."order_checklist_photos" to "anon";

grant truncate on table "public"."order_checklist_photos" to "anon";

grant update on table "public"."order_checklist_photos" to "anon";

grant delete on table "public"."order_checklist_photos" to "authenticated";

grant insert on table "public"."order_checklist_photos" to "authenticated";

grant references on table "public"."order_checklist_photos" to "authenticated";

grant select on table "public"."order_checklist_photos" to "authenticated";

grant trigger on table "public"."order_checklist_photos" to "authenticated";

grant truncate on table "public"."order_checklist_photos" to "authenticated";

grant update on table "public"."order_checklist_photos" to "authenticated";

grant delete on table "public"."order_checklist_photos" to "service_role";

grant insert on table "public"."order_checklist_photos" to "service_role";

grant references on table "public"."order_checklist_photos" to "service_role";

grant select on table "public"."order_checklist_photos" to "service_role";

grant trigger on table "public"."order_checklist_photos" to "service_role";

grant truncate on table "public"."order_checklist_photos" to "service_role";

grant update on table "public"."order_checklist_photos" to "service_role";

grant delete on table "public"."order_deposits" to "anon";

grant insert on table "public"."order_deposits" to "anon";

grant references on table "public"."order_deposits" to "anon";

grant select on table "public"."order_deposits" to "anon";

grant trigger on table "public"."order_deposits" to "anon";

grant truncate on table "public"."order_deposits" to "anon";

grant update on table "public"."order_deposits" to "anon";

grant delete on table "public"."order_deposits" to "authenticated";

grant insert on table "public"."order_deposits" to "authenticated";

grant references on table "public"."order_deposits" to "authenticated";

grant select on table "public"."order_deposits" to "authenticated";

grant trigger on table "public"."order_deposits" to "authenticated";

grant truncate on table "public"."order_deposits" to "authenticated";

grant update on table "public"."order_deposits" to "authenticated";

grant delete on table "public"."order_deposits" to "service_role";

grant insert on table "public"."order_deposits" to "service_role";

grant references on table "public"."order_deposits" to "service_role";

grant select on table "public"."order_deposits" to "service_role";

grant trigger on table "public"."order_deposits" to "service_role";

grant truncate on table "public"."order_deposits" to "service_role";

grant update on table "public"."order_deposits" to "service_role";

grant delete on table "public"."order_discounts" to "anon";

grant insert on table "public"."order_discounts" to "anon";

grant references on table "public"."order_discounts" to "anon";

grant select on table "public"."order_discounts" to "anon";

grant trigger on table "public"."order_discounts" to "anon";

grant truncate on table "public"."order_discounts" to "anon";

grant update on table "public"."order_discounts" to "anon";

grant delete on table "public"."order_discounts" to "authenticated";

grant insert on table "public"."order_discounts" to "authenticated";

grant references on table "public"."order_discounts" to "authenticated";

grant select on table "public"."order_discounts" to "authenticated";

grant trigger on table "public"."order_discounts" to "authenticated";

grant truncate on table "public"."order_discounts" to "authenticated";

grant update on table "public"."order_discounts" to "authenticated";

grant delete on table "public"."order_discounts" to "service_role";

grant insert on table "public"."order_discounts" to "service_role";

grant references on table "public"."order_discounts" to "service_role";

grant select on table "public"."order_discounts" to "service_role";

grant trigger on table "public"."order_discounts" to "service_role";

grant truncate on table "public"."order_discounts" to "service_role";

grant update on table "public"."order_discounts" to "service_role";

grant delete on table "public"."order_item_options" to "anon";

grant insert on table "public"."order_item_options" to "anon";

grant references on table "public"."order_item_options" to "anon";

grant select on table "public"."order_item_options" to "anon";

grant trigger on table "public"."order_item_options" to "anon";

grant truncate on table "public"."order_item_options" to "anon";

grant update on table "public"."order_item_options" to "anon";

grant delete on table "public"."order_item_options" to "authenticated";

grant insert on table "public"."order_item_options" to "authenticated";

grant references on table "public"."order_item_options" to "authenticated";

grant select on table "public"."order_item_options" to "authenticated";

grant trigger on table "public"."order_item_options" to "authenticated";

grant truncate on table "public"."order_item_options" to "authenticated";

grant update on table "public"."order_item_options" to "authenticated";

grant delete on table "public"."order_item_options" to "service_role";

grant insert on table "public"."order_item_options" to "service_role";

grant references on table "public"."order_item_options" to "service_role";

grant select on table "public"."order_item_options" to "service_role";

grant trigger on table "public"."order_item_options" to "service_role";

grant truncate on table "public"."order_item_options" to "service_role";

grant update on table "public"."order_item_options" to "service_role";

grant delete on table "public"."order_items" to "anon";

grant insert on table "public"."order_items" to "anon";

grant references on table "public"."order_items" to "anon";

grant select on table "public"."order_items" to "anon";

grant trigger on table "public"."order_items" to "anon";

grant truncate on table "public"."order_items" to "anon";

grant update on table "public"."order_items" to "anon";

grant delete on table "public"."order_items" to "authenticated";

grant insert on table "public"."order_items" to "authenticated";

grant references on table "public"."order_items" to "authenticated";

grant select on table "public"."order_items" to "authenticated";

grant trigger on table "public"."order_items" to "authenticated";

grant truncate on table "public"."order_items" to "authenticated";

grant update on table "public"."order_items" to "authenticated";

grant delete on table "public"."order_items" to "service_role";

grant insert on table "public"."order_items" to "service_role";

grant references on table "public"."order_items" to "service_role";

grant select on table "public"."order_items" to "service_role";

grant trigger on table "public"."order_items" to "service_role";

grant truncate on table "public"."order_items" to "service_role";

grant update on table "public"."order_items" to "service_role";

grant delete on table "public"."order_reviews" to "anon";

grant insert on table "public"."order_reviews" to "anon";

grant references on table "public"."order_reviews" to "anon";

grant select on table "public"."order_reviews" to "anon";

grant trigger on table "public"."order_reviews" to "anon";

grant truncate on table "public"."order_reviews" to "anon";

grant update on table "public"."order_reviews" to "anon";

grant delete on table "public"."order_reviews" to "authenticated";

grant insert on table "public"."order_reviews" to "authenticated";

grant references on table "public"."order_reviews" to "authenticated";

grant select on table "public"."order_reviews" to "authenticated";

grant trigger on table "public"."order_reviews" to "authenticated";

grant truncate on table "public"."order_reviews" to "authenticated";

grant update on table "public"."order_reviews" to "authenticated";

grant delete on table "public"."order_reviews" to "service_role";

grant insert on table "public"."order_reviews" to "service_role";

grant references on table "public"."order_reviews" to "service_role";

grant select on table "public"."order_reviews" to "service_role";

grant trigger on table "public"."order_reviews" to "service_role";

grant truncate on table "public"."order_reviews" to "service_role";

grant update on table "public"."order_reviews" to "service_role";

grant delete on table "public"."order_rider_locations" to "anon";

grant insert on table "public"."order_rider_locations" to "anon";

grant references on table "public"."order_rider_locations" to "anon";

grant select on table "public"."order_rider_locations" to "anon";

grant trigger on table "public"."order_rider_locations" to "anon";

grant truncate on table "public"."order_rider_locations" to "anon";

grant update on table "public"."order_rider_locations" to "anon";

grant delete on table "public"."order_rider_locations" to "authenticated";

grant insert on table "public"."order_rider_locations" to "authenticated";

grant references on table "public"."order_rider_locations" to "authenticated";

grant select on table "public"."order_rider_locations" to "authenticated";

grant trigger on table "public"."order_rider_locations" to "authenticated";

grant truncate on table "public"."order_rider_locations" to "authenticated";

grant update on table "public"."order_rider_locations" to "authenticated";

grant delete on table "public"."order_rider_locations" to "service_role";

grant insert on table "public"."order_rider_locations" to "service_role";

grant references on table "public"."order_rider_locations" to "service_role";

grant select on table "public"."order_rider_locations" to "service_role";

grant trigger on table "public"."order_rider_locations" to "service_role";

grant truncate on table "public"."order_rider_locations" to "service_role";

grant update on table "public"."order_rider_locations" to "service_role";

grant delete on table "public"."order_status_history" to "anon";

grant insert on table "public"."order_status_history" to "anon";

grant references on table "public"."order_status_history" to "anon";

grant select on table "public"."order_status_history" to "anon";

grant trigger on table "public"."order_status_history" to "anon";

grant truncate on table "public"."order_status_history" to "anon";

grant update on table "public"."order_status_history" to "anon";

grant delete on table "public"."order_status_history" to "authenticated";

grant insert on table "public"."order_status_history" to "authenticated";

grant references on table "public"."order_status_history" to "authenticated";

grant select on table "public"."order_status_history" to "authenticated";

grant trigger on table "public"."order_status_history" to "authenticated";

grant truncate on table "public"."order_status_history" to "authenticated";

grant update on table "public"."order_status_history" to "authenticated";

grant delete on table "public"."order_status_history" to "service_role";

grant insert on table "public"."order_status_history" to "service_role";

grant references on table "public"."order_status_history" to "service_role";

grant select on table "public"."order_status_history" to "service_role";

grant trigger on table "public"."order_status_history" to "service_role";

grant truncate on table "public"."order_status_history" to "service_role";

grant update on table "public"."order_status_history" to "service_role";

grant delete on table "public"."orders" to "anon";

grant insert on table "public"."orders" to "anon";

grant references on table "public"."orders" to "anon";

grant select on table "public"."orders" to "anon";

grant trigger on table "public"."orders" to "anon";

grant truncate on table "public"."orders" to "anon";

grant update on table "public"."orders" to "anon";

grant delete on table "public"."orders" to "authenticated";

grant insert on table "public"."orders" to "authenticated";

grant references on table "public"."orders" to "authenticated";

grant select on table "public"."orders" to "authenticated";

grant trigger on table "public"."orders" to "authenticated";

grant truncate on table "public"."orders" to "authenticated";

grant update on table "public"."orders" to "authenticated";

grant delete on table "public"."orders" to "service_role";

grant insert on table "public"."orders" to "service_role";

grant references on table "public"."orders" to "service_role";

grant select on table "public"."orders" to "service_role";

grant trigger on table "public"."orders" to "service_role";

grant truncate on table "public"."orders" to "service_role";

grant update on table "public"."orders" to "service_role";

grant delete on table "public"."payment_history" to "anon";

grant insert on table "public"."payment_history" to "anon";

grant references on table "public"."payment_history" to "anon";

grant select on table "public"."payment_history" to "anon";

grant trigger on table "public"."payment_history" to "anon";

grant truncate on table "public"."payment_history" to "anon";

grant update on table "public"."payment_history" to "anon";

grant delete on table "public"."payment_history" to "authenticated";

grant insert on table "public"."payment_history" to "authenticated";

grant references on table "public"."payment_history" to "authenticated";

grant select on table "public"."payment_history" to "authenticated";

grant trigger on table "public"."payment_history" to "authenticated";

grant truncate on table "public"."payment_history" to "authenticated";

grant update on table "public"."payment_history" to "authenticated";

grant delete on table "public"."payment_history" to "service_role";

grant insert on table "public"."payment_history" to "service_role";

grant references on table "public"."payment_history" to "service_role";

grant select on table "public"."payment_history" to "service_role";

grant trigger on table "public"."payment_history" to "service_role";

grant truncate on table "public"."payment_history" to "service_role";

grant update on table "public"."payment_history" to "service_role";

grant delete on table "public"."preorder_delivery_fee_config" to "anon";

grant insert on table "public"."preorder_delivery_fee_config" to "anon";

grant references on table "public"."preorder_delivery_fee_config" to "anon";

grant select on table "public"."preorder_delivery_fee_config" to "anon";

grant trigger on table "public"."preorder_delivery_fee_config" to "anon";

grant truncate on table "public"."preorder_delivery_fee_config" to "anon";

grant update on table "public"."preorder_delivery_fee_config" to "anon";

grant delete on table "public"."preorder_delivery_fee_config" to "authenticated";

grant insert on table "public"."preorder_delivery_fee_config" to "authenticated";

grant references on table "public"."preorder_delivery_fee_config" to "authenticated";

grant select on table "public"."preorder_delivery_fee_config" to "authenticated";

grant trigger on table "public"."preorder_delivery_fee_config" to "authenticated";

grant truncate on table "public"."preorder_delivery_fee_config" to "authenticated";

grant update on table "public"."preorder_delivery_fee_config" to "authenticated";

grant delete on table "public"."preorder_delivery_fee_config" to "service_role";

grant insert on table "public"."preorder_delivery_fee_config" to "service_role";

grant references on table "public"."preorder_delivery_fee_config" to "service_role";

grant select on table "public"."preorder_delivery_fee_config" to "service_role";

grant trigger on table "public"."preorder_delivery_fee_config" to "service_role";

grant truncate on table "public"."preorder_delivery_fee_config" to "service_role";

grant update on table "public"."preorder_delivery_fee_config" to "service_role";

grant delete on table "public"."preorder_items" to "anon";

grant insert on table "public"."preorder_items" to "anon";

grant references on table "public"."preorder_items" to "anon";

grant select on table "public"."preorder_items" to "anon";

grant trigger on table "public"."preorder_items" to "anon";

grant truncate on table "public"."preorder_items" to "anon";

grant update on table "public"."preorder_items" to "anon";

grant delete on table "public"."preorder_items" to "authenticated";

grant insert on table "public"."preorder_items" to "authenticated";

grant references on table "public"."preorder_items" to "authenticated";

grant select on table "public"."preorder_items" to "authenticated";

grant trigger on table "public"."preorder_items" to "authenticated";

grant truncate on table "public"."preorder_items" to "authenticated";

grant update on table "public"."preorder_items" to "authenticated";

grant delete on table "public"."preorder_items" to "service_role";

grant insert on table "public"."preorder_items" to "service_role";

grant references on table "public"."preorder_items" to "service_role";

grant select on table "public"."preorder_items" to "service_role";

grant trigger on table "public"."preorder_items" to "service_role";

grant truncate on table "public"."preorder_items" to "service_role";

grant update on table "public"."preorder_items" to "service_role";

grant delete on table "public"."preorder_orders" to "anon";

grant insert on table "public"."preorder_orders" to "anon";

grant references on table "public"."preorder_orders" to "anon";

grant select on table "public"."preorder_orders" to "anon";

grant trigger on table "public"."preorder_orders" to "anon";

grant truncate on table "public"."preorder_orders" to "anon";

grant update on table "public"."preorder_orders" to "anon";

grant delete on table "public"."preorder_orders" to "authenticated";

grant insert on table "public"."preorder_orders" to "authenticated";

grant references on table "public"."preorder_orders" to "authenticated";

grant select on table "public"."preorder_orders" to "authenticated";

grant trigger on table "public"."preorder_orders" to "authenticated";

grant truncate on table "public"."preorder_orders" to "authenticated";

grant update on table "public"."preorder_orders" to "authenticated";

grant delete on table "public"."preorder_orders" to "service_role";

grant insert on table "public"."preorder_orders" to "service_role";

grant references on table "public"."preorder_orders" to "service_role";

grant select on table "public"."preorder_orders" to "service_role";

grant trigger on table "public"."preorder_orders" to "service_role";

grant truncate on table "public"."preorder_orders" to "service_role";

grant update on table "public"."preorder_orders" to "service_role";

grant delete on table "public"."preorder_settings" to "anon";

grant insert on table "public"."preorder_settings" to "anon";

grant references on table "public"."preorder_settings" to "anon";

grant select on table "public"."preorder_settings" to "anon";

grant trigger on table "public"."preorder_settings" to "anon";

grant truncate on table "public"."preorder_settings" to "anon";

grant update on table "public"."preorder_settings" to "anon";

grant delete on table "public"."preorder_settings" to "authenticated";

grant insert on table "public"."preorder_settings" to "authenticated";

grant references on table "public"."preorder_settings" to "authenticated";

grant select on table "public"."preorder_settings" to "authenticated";

grant trigger on table "public"."preorder_settings" to "authenticated";

grant truncate on table "public"."preorder_settings" to "authenticated";

grant update on table "public"."preorder_settings" to "authenticated";

grant delete on table "public"."preorder_settings" to "service_role";

grant insert on table "public"."preorder_settings" to "service_role";

grant references on table "public"."preorder_settings" to "service_role";

grant select on table "public"."preorder_settings" to "service_role";

grant trigger on table "public"."preorder_settings" to "service_role";

grant truncate on table "public"."preorder_settings" to "service_role";

grant update on table "public"."preorder_settings" to "service_role";

grant delete on table "public"."product_option_values" to "anon";

grant insert on table "public"."product_option_values" to "anon";

grant references on table "public"."product_option_values" to "anon";

grant select on table "public"."product_option_values" to "anon";

grant trigger on table "public"."product_option_values" to "anon";

grant truncate on table "public"."product_option_values" to "anon";

grant update on table "public"."product_option_values" to "anon";

grant delete on table "public"."product_option_values" to "authenticated";

grant insert on table "public"."product_option_values" to "authenticated";

grant references on table "public"."product_option_values" to "authenticated";

grant select on table "public"."product_option_values" to "authenticated";

grant trigger on table "public"."product_option_values" to "authenticated";

grant truncate on table "public"."product_option_values" to "authenticated";

grant update on table "public"."product_option_values" to "authenticated";

grant delete on table "public"."product_option_values" to "service_role";

grant insert on table "public"."product_option_values" to "service_role";

grant references on table "public"."product_option_values" to "service_role";

grant select on table "public"."product_option_values" to "service_role";

grant trigger on table "public"."product_option_values" to "service_role";

grant truncate on table "public"."product_option_values" to "service_role";

grant update on table "public"."product_option_values" to "service_role";

grant delete on table "public"."product_options" to "anon";

grant insert on table "public"."product_options" to "anon";

grant references on table "public"."product_options" to "anon";

grant select on table "public"."product_options" to "anon";

grant trigger on table "public"."product_options" to "anon";

grant truncate on table "public"."product_options" to "anon";

grant update on table "public"."product_options" to "anon";

grant delete on table "public"."product_options" to "authenticated";

grant insert on table "public"."product_options" to "authenticated";

grant references on table "public"."product_options" to "authenticated";

grant select on table "public"."product_options" to "authenticated";

grant trigger on table "public"."product_options" to "authenticated";

grant truncate on table "public"."product_options" to "authenticated";

grant update on table "public"."product_options" to "authenticated";

grant delete on table "public"."product_options" to "service_role";

grant insert on table "public"."product_options" to "service_role";

grant references on table "public"."product_options" to "service_role";

grant select on table "public"."product_options" to "service_role";

grant trigger on table "public"."product_options" to "service_role";

grant truncate on table "public"."product_options" to "service_role";

grant update on table "public"."product_options" to "service_role";

grant delete on table "public"."products" to "anon";

grant insert on table "public"."products" to "anon";

grant references on table "public"."products" to "anon";

grant select on table "public"."products" to "anon";

grant trigger on table "public"."products" to "anon";

grant truncate on table "public"."products" to "anon";

grant update on table "public"."products" to "anon";

grant delete on table "public"."products" to "authenticated";

grant insert on table "public"."products" to "authenticated";

grant references on table "public"."products" to "authenticated";

grant select on table "public"."products" to "authenticated";

grant trigger on table "public"."products" to "authenticated";

grant truncate on table "public"."products" to "authenticated";

grant update on table "public"."products" to "authenticated";

grant delete on table "public"."products" to "service_role";

grant insert on table "public"."products" to "service_role";

grant references on table "public"."products" to "service_role";

grant select on table "public"."products" to "service_role";

grant trigger on table "public"."products" to "service_role";

grant truncate on table "public"."products" to "service_role";

grant update on table "public"."products" to "service_role";

grant delete on table "public"."rider_assignments" to "anon";

grant insert on table "public"."rider_assignments" to "anon";

grant references on table "public"."rider_assignments" to "anon";

grant select on table "public"."rider_assignments" to "anon";

grant trigger on table "public"."rider_assignments" to "anon";

grant truncate on table "public"."rider_assignments" to "anon";

grant update on table "public"."rider_assignments" to "anon";

grant delete on table "public"."rider_assignments" to "authenticated";

grant insert on table "public"."rider_assignments" to "authenticated";

grant references on table "public"."rider_assignments" to "authenticated";

grant select on table "public"."rider_assignments" to "authenticated";

grant trigger on table "public"."rider_assignments" to "authenticated";

grant truncate on table "public"."rider_assignments" to "authenticated";

grant update on table "public"."rider_assignments" to "authenticated";

grant delete on table "public"."rider_assignments" to "service_role";

grant insert on table "public"."rider_assignments" to "service_role";

grant references on table "public"."rider_assignments" to "service_role";

grant select on table "public"."rider_assignments" to "service_role";

grant trigger on table "public"."rider_assignments" to "service_role";

grant truncate on table "public"."rider_assignments" to "service_role";

grant update on table "public"."rider_assignments" to "service_role";

grant delete on table "public"."rider_documents" to "anon";

grant insert on table "public"."rider_documents" to "anon";

grant references on table "public"."rider_documents" to "anon";

grant select on table "public"."rider_documents" to "anon";

grant trigger on table "public"."rider_documents" to "anon";

grant truncate on table "public"."rider_documents" to "anon";

grant update on table "public"."rider_documents" to "anon";

grant delete on table "public"."rider_documents" to "authenticated";

grant insert on table "public"."rider_documents" to "authenticated";

grant references on table "public"."rider_documents" to "authenticated";

grant select on table "public"."rider_documents" to "authenticated";

grant trigger on table "public"."rider_documents" to "authenticated";

grant truncate on table "public"."rider_documents" to "authenticated";

grant update on table "public"."rider_documents" to "authenticated";

grant delete on table "public"."rider_documents" to "service_role";

grant insert on table "public"."rider_documents" to "service_role";

grant references on table "public"."rider_documents" to "service_role";

grant select on table "public"."rider_documents" to "service_role";

grant trigger on table "public"."rider_documents" to "service_role";

grant truncate on table "public"."rider_documents" to "service_role";

grant update on table "public"."rider_documents" to "service_role";

grant delete on table "public"."rider_fcm_tokens" to "anon";

grant insert on table "public"."rider_fcm_tokens" to "anon";

grant references on table "public"."rider_fcm_tokens" to "anon";

grant select on table "public"."rider_fcm_tokens" to "anon";

grant trigger on table "public"."rider_fcm_tokens" to "anon";

grant truncate on table "public"."rider_fcm_tokens" to "anon";

grant update on table "public"."rider_fcm_tokens" to "anon";

grant delete on table "public"."rider_fcm_tokens" to "authenticated";

grant insert on table "public"."rider_fcm_tokens" to "authenticated";

grant references on table "public"."rider_fcm_tokens" to "authenticated";

grant select on table "public"."rider_fcm_tokens" to "authenticated";

grant trigger on table "public"."rider_fcm_tokens" to "authenticated";

grant truncate on table "public"."rider_fcm_tokens" to "authenticated";

grant update on table "public"."rider_fcm_tokens" to "authenticated";

grant delete on table "public"."rider_fcm_tokens" to "service_role";

grant insert on table "public"."rider_fcm_tokens" to "service_role";

grant references on table "public"."rider_fcm_tokens" to "service_role";

grant select on table "public"."rider_fcm_tokens" to "service_role";

grant trigger on table "public"."rider_fcm_tokens" to "service_role";

grant truncate on table "public"."rider_fcm_tokens" to "service_role";

grant update on table "public"."rider_fcm_tokens" to "service_role";

grant delete on table "public"."rider_order_bookings" to "anon";

grant insert on table "public"."rider_order_bookings" to "anon";

grant references on table "public"."rider_order_bookings" to "anon";

grant select on table "public"."rider_order_bookings" to "anon";

grant trigger on table "public"."rider_order_bookings" to "anon";

grant truncate on table "public"."rider_order_bookings" to "anon";

grant update on table "public"."rider_order_bookings" to "anon";

grant delete on table "public"."rider_order_bookings" to "authenticated";

grant insert on table "public"."rider_order_bookings" to "authenticated";

grant references on table "public"."rider_order_bookings" to "authenticated";

grant select on table "public"."rider_order_bookings" to "authenticated";

grant trigger on table "public"."rider_order_bookings" to "authenticated";

grant truncate on table "public"."rider_order_bookings" to "authenticated";

grant update on table "public"."rider_order_bookings" to "authenticated";

grant delete on table "public"."rider_order_bookings" to "service_role";

grant insert on table "public"."rider_order_bookings" to "service_role";

grant references on table "public"."rider_order_bookings" to "service_role";

grant select on table "public"."rider_order_bookings" to "service_role";

grant trigger on table "public"."rider_order_bookings" to "service_role";

grant truncate on table "public"."rider_order_bookings" to "service_role";

grant update on table "public"."rider_order_bookings" to "service_role";

grant delete on table "public"."rider_reviews" to "anon";

grant insert on table "public"."rider_reviews" to "anon";

grant references on table "public"."rider_reviews" to "anon";

grant select on table "public"."rider_reviews" to "anon";

grant trigger on table "public"."rider_reviews" to "anon";

grant truncate on table "public"."rider_reviews" to "anon";

grant update on table "public"."rider_reviews" to "anon";

grant delete on table "public"."rider_reviews" to "authenticated";

grant insert on table "public"."rider_reviews" to "authenticated";

grant references on table "public"."rider_reviews" to "authenticated";

grant select on table "public"."rider_reviews" to "authenticated";

grant trigger on table "public"."rider_reviews" to "authenticated";

grant truncate on table "public"."rider_reviews" to "authenticated";

grant update on table "public"."rider_reviews" to "authenticated";

grant delete on table "public"."rider_reviews" to "service_role";

grant insert on table "public"."rider_reviews" to "service_role";

grant references on table "public"."rider_reviews" to "service_role";

grant select on table "public"."rider_reviews" to "service_role";

grant trigger on table "public"."rider_reviews" to "service_role";

grant truncate on table "public"."rider_reviews" to "service_role";

grant update on table "public"."rider_reviews" to "service_role";

grant delete on table "public"."riders" to "anon";

grant insert on table "public"."riders" to "anon";

grant references on table "public"."riders" to "anon";

grant select on table "public"."riders" to "anon";

grant trigger on table "public"."riders" to "anon";

grant truncate on table "public"."riders" to "anon";

grant update on table "public"."riders" to "anon";

grant delete on table "public"."riders" to "authenticated";

grant insert on table "public"."riders" to "authenticated";

grant references on table "public"."riders" to "authenticated";

grant select on table "public"."riders" to "authenticated";

grant trigger on table "public"."riders" to "authenticated";

grant truncate on table "public"."riders" to "authenticated";

grant update on table "public"."riders" to "authenticated";

grant delete on table "public"."riders" to "service_role";

grant insert on table "public"."riders" to "service_role";

grant references on table "public"."riders" to "service_role";

grant select on table "public"."riders" to "service_role";

grant trigger on table "public"."riders" to "service_role";

grant truncate on table "public"."riders" to "service_role";

grant update on table "public"."riders" to "service_role";

grant delete on table "public"."spatial_ref_sys" to "anon";

grant insert on table "public"."spatial_ref_sys" to "anon";

grant references on table "public"."spatial_ref_sys" to "anon";

grant select on table "public"."spatial_ref_sys" to "anon";

grant trigger on table "public"."spatial_ref_sys" to "anon";

grant truncate on table "public"."spatial_ref_sys" to "anon";

grant update on table "public"."spatial_ref_sys" to "anon";

grant delete on table "public"."spatial_ref_sys" to "authenticated";

grant insert on table "public"."spatial_ref_sys" to "authenticated";

grant references on table "public"."spatial_ref_sys" to "authenticated";

grant select on table "public"."spatial_ref_sys" to "authenticated";

grant trigger on table "public"."spatial_ref_sys" to "authenticated";

grant truncate on table "public"."spatial_ref_sys" to "authenticated";

grant update on table "public"."spatial_ref_sys" to "authenticated";

grant delete on table "public"."spatial_ref_sys" to "postgres";

grant insert on table "public"."spatial_ref_sys" to "postgres";

grant references on table "public"."spatial_ref_sys" to "postgres";

grant select on table "public"."spatial_ref_sys" to "postgres";

grant trigger on table "public"."spatial_ref_sys" to "postgres";

grant truncate on table "public"."spatial_ref_sys" to "postgres";

grant update on table "public"."spatial_ref_sys" to "postgres";

grant delete on table "public"."spatial_ref_sys" to "service_role";

grant insert on table "public"."spatial_ref_sys" to "service_role";

grant references on table "public"."spatial_ref_sys" to "service_role";

grant select on table "public"."spatial_ref_sys" to "service_role";

grant trigger on table "public"."spatial_ref_sys" to "service_role";

grant truncate on table "public"."spatial_ref_sys" to "service_role";

grant update on table "public"."spatial_ref_sys" to "service_role";

grant delete on table "public"."store_active_orders" to "anon";

grant insert on table "public"."store_active_orders" to "anon";

grant references on table "public"."store_active_orders" to "anon";

grant select on table "public"."store_active_orders" to "anon";

grant trigger on table "public"."store_active_orders" to "anon";

grant truncate on table "public"."store_active_orders" to "anon";

grant update on table "public"."store_active_orders" to "anon";

grant delete on table "public"."store_active_orders" to "authenticated";

grant insert on table "public"."store_active_orders" to "authenticated";

grant references on table "public"."store_active_orders" to "authenticated";

grant select on table "public"."store_active_orders" to "authenticated";

grant trigger on table "public"."store_active_orders" to "authenticated";

grant truncate on table "public"."store_active_orders" to "authenticated";

grant update on table "public"."store_active_orders" to "authenticated";

grant delete on table "public"."store_active_orders" to "service_role";

grant insert on table "public"."store_active_orders" to "service_role";

grant references on table "public"."store_active_orders" to "service_role";

grant select on table "public"."store_active_orders" to "service_role";

grant trigger on table "public"."store_active_orders" to "service_role";

grant truncate on table "public"."store_active_orders" to "service_role";

grant update on table "public"."store_active_orders" to "service_role";

grant delete on table "public"."store_bank_accounts" to "anon";

grant insert on table "public"."store_bank_accounts" to "anon";

grant references on table "public"."store_bank_accounts" to "anon";

grant select on table "public"."store_bank_accounts" to "anon";

grant trigger on table "public"."store_bank_accounts" to "anon";

grant truncate on table "public"."store_bank_accounts" to "anon";

grant update on table "public"."store_bank_accounts" to "anon";

grant delete on table "public"."store_bank_accounts" to "authenticated";

grant insert on table "public"."store_bank_accounts" to "authenticated";

grant references on table "public"."store_bank_accounts" to "authenticated";

grant select on table "public"."store_bank_accounts" to "authenticated";

grant trigger on table "public"."store_bank_accounts" to "authenticated";

grant truncate on table "public"."store_bank_accounts" to "authenticated";

grant update on table "public"."store_bank_accounts" to "authenticated";

grant delete on table "public"."store_bank_accounts" to "service_role";

grant insert on table "public"."store_bank_accounts" to "service_role";

grant references on table "public"."store_bank_accounts" to "service_role";

grant select on table "public"."store_bank_accounts" to "service_role";

grant trigger on table "public"."store_bank_accounts" to "service_role";

grant truncate on table "public"."store_bank_accounts" to "service_role";

grant update on table "public"."store_bank_accounts" to "service_role";

grant delete on table "public"."store_cancellation_requests" to "anon";

grant insert on table "public"."store_cancellation_requests" to "anon";

grant references on table "public"."store_cancellation_requests" to "anon";

grant select on table "public"."store_cancellation_requests" to "anon";

grant trigger on table "public"."store_cancellation_requests" to "anon";

grant truncate on table "public"."store_cancellation_requests" to "anon";

grant update on table "public"."store_cancellation_requests" to "anon";

grant delete on table "public"."store_cancellation_requests" to "authenticated";

grant insert on table "public"."store_cancellation_requests" to "authenticated";

grant references on table "public"."store_cancellation_requests" to "authenticated";

grant select on table "public"."store_cancellation_requests" to "authenticated";

grant trigger on table "public"."store_cancellation_requests" to "authenticated";

grant truncate on table "public"."store_cancellation_requests" to "authenticated";

grant update on table "public"."store_cancellation_requests" to "authenticated";

grant delete on table "public"."store_cancellation_requests" to "service_role";

grant insert on table "public"."store_cancellation_requests" to "service_role";

grant references on table "public"."store_cancellation_requests" to "service_role";

grant select on table "public"."store_cancellation_requests" to "service_role";

grant trigger on table "public"."store_cancellation_requests" to "service_role";

grant truncate on table "public"."store_cancellation_requests" to "service_role";

grant update on table "public"."store_cancellation_requests" to "service_role";

grant delete on table "public"."store_categories" to "anon";

grant insert on table "public"."store_categories" to "anon";

grant references on table "public"."store_categories" to "anon";

grant select on table "public"."store_categories" to "anon";

grant trigger on table "public"."store_categories" to "anon";

grant truncate on table "public"."store_categories" to "anon";

grant update on table "public"."store_categories" to "anon";

grant delete on table "public"."store_categories" to "authenticated";

grant insert on table "public"."store_categories" to "authenticated";

grant references on table "public"."store_categories" to "authenticated";

grant select on table "public"."store_categories" to "authenticated";

grant trigger on table "public"."store_categories" to "authenticated";

grant truncate on table "public"."store_categories" to "authenticated";

grant update on table "public"."store_categories" to "authenticated";

grant delete on table "public"."store_categories" to "service_role";

grant insert on table "public"."store_categories" to "service_role";

grant references on table "public"."store_categories" to "service_role";

grant select on table "public"."store_categories" to "service_role";

grant trigger on table "public"."store_categories" to "service_role";

grant truncate on table "public"."store_categories" to "service_role";

grant update on table "public"."store_categories" to "service_role";

grant delete on table "public"."store_reports" to "anon";

grant insert on table "public"."store_reports" to "anon";

grant references on table "public"."store_reports" to "anon";

grant select on table "public"."store_reports" to "anon";

grant trigger on table "public"."store_reports" to "anon";

grant truncate on table "public"."store_reports" to "anon";

grant update on table "public"."store_reports" to "anon";

grant delete on table "public"."store_reports" to "authenticated";

grant insert on table "public"."store_reports" to "authenticated";

grant references on table "public"."store_reports" to "authenticated";

grant select on table "public"."store_reports" to "authenticated";

grant trigger on table "public"."store_reports" to "authenticated";

grant truncate on table "public"."store_reports" to "authenticated";

grant update on table "public"."store_reports" to "authenticated";

grant delete on table "public"."store_reports" to "service_role";

grant insert on table "public"."store_reports" to "service_role";

grant references on table "public"."store_reports" to "service_role";

grant select on table "public"."store_reports" to "service_role";

grant trigger on table "public"."store_reports" to "service_role";

grant truncate on table "public"."store_reports" to "service_role";

grant update on table "public"."store_reports" to "service_role";

grant delete on table "public"."store_suspension_history" to "anon";

grant insert on table "public"."store_suspension_history" to "anon";

grant references on table "public"."store_suspension_history" to "anon";

grant select on table "public"."store_suspension_history" to "anon";

grant trigger on table "public"."store_suspension_history" to "anon";

grant truncate on table "public"."store_suspension_history" to "anon";

grant update on table "public"."store_suspension_history" to "anon";

grant delete on table "public"."store_suspension_history" to "authenticated";

grant insert on table "public"."store_suspension_history" to "authenticated";

grant references on table "public"."store_suspension_history" to "authenticated";

grant select on table "public"."store_suspension_history" to "authenticated";

grant trigger on table "public"."store_suspension_history" to "authenticated";

grant truncate on table "public"."store_suspension_history" to "authenticated";

grant update on table "public"."store_suspension_history" to "authenticated";

grant delete on table "public"."store_suspension_history" to "service_role";

grant insert on table "public"."store_suspension_history" to "service_role";

grant references on table "public"."store_suspension_history" to "service_role";

grant select on table "public"."store_suspension_history" to "service_role";

grant trigger on table "public"."store_suspension_history" to "service_role";

grant truncate on table "public"."store_suspension_history" to "service_role";

grant update on table "public"."store_suspension_history" to "service_role";

grant delete on table "public"."stores" to "anon";

grant insert on table "public"."stores" to "anon";

grant references on table "public"."stores" to "anon";

grant select on table "public"."stores" to "anon";

grant trigger on table "public"."stores" to "anon";

grant truncate on table "public"."stores" to "anon";

grant update on table "public"."stores" to "anon";

grant delete on table "public"."stores" to "authenticated";

grant insert on table "public"."stores" to "authenticated";

grant references on table "public"."stores" to "authenticated";

grant select on table "public"."stores" to "authenticated";

grant trigger on table "public"."stores" to "authenticated";

grant truncate on table "public"."stores" to "authenticated";

grant update on table "public"."stores" to "authenticated";

grant delete on table "public"."stores" to "service_role";

grant insert on table "public"."stores" to "service_role";

grant references on table "public"."stores" to "service_role";

grant select on table "public"."stores" to "service_role";

grant trigger on table "public"."stores" to "service_role";

grant truncate on table "public"."stores" to "service_role";

grant update on table "public"."stores" to "service_role";

grant delete on table "public"."user_task_progress" to "anon";

grant insert on table "public"."user_task_progress" to "anon";

grant references on table "public"."user_task_progress" to "anon";

grant select on table "public"."user_task_progress" to "anon";

grant trigger on table "public"."user_task_progress" to "anon";

grant truncate on table "public"."user_task_progress" to "anon";

grant update on table "public"."user_task_progress" to "anon";

grant delete on table "public"."user_task_progress" to "authenticated";

grant insert on table "public"."user_task_progress" to "authenticated";

grant references on table "public"."user_task_progress" to "authenticated";

grant select on table "public"."user_task_progress" to "authenticated";

grant trigger on table "public"."user_task_progress" to "authenticated";

grant truncate on table "public"."user_task_progress" to "authenticated";

grant update on table "public"."user_task_progress" to "authenticated";

grant delete on table "public"."user_task_progress" to "service_role";

grant insert on table "public"."user_task_progress" to "service_role";

grant references on table "public"."user_task_progress" to "service_role";

grant select on table "public"."user_task_progress" to "service_role";

grant trigger on table "public"."user_task_progress" to "service_role";

grant truncate on table "public"."user_task_progress" to "service_role";

grant update on table "public"."user_task_progress" to "service_role";

grant delete on table "public"."users" to "anon";

grant insert on table "public"."users" to "anon";

grant references on table "public"."users" to "anon";

grant select on table "public"."users" to "anon";

grant trigger on table "public"."users" to "anon";

grant truncate on table "public"."users" to "anon";

grant update on table "public"."users" to "anon";

grant delete on table "public"."users" to "authenticated";

grant insert on table "public"."users" to "authenticated";

grant references on table "public"."users" to "authenticated";

grant select on table "public"."users" to "authenticated";

grant trigger on table "public"."users" to "authenticated";

grant truncate on table "public"."users" to "authenticated";

grant update on table "public"."users" to "authenticated";

grant delete on table "public"."users" to "service_role";

grant insert on table "public"."users" to "service_role";

grant references on table "public"."users" to "service_role";

grant select on table "public"."users" to "service_role";

grant trigger on table "public"."users" to "service_role";

grant truncate on table "public"."users" to "service_role";

grant update on table "public"."users" to "service_role";


  create policy "Allow admin insert activity logs"
  on "public"."admin_activity_logs"
  as permissive
  for insert
  to authenticated
with check ((auth.uid() IN ( SELECT users.id
   FROM public.users
  WHERE (users.role = 'admin'::text))));



  create policy "Allow admin view activity logs"
  on "public"."admin_activity_logs"
  as permissive
  for select
  to authenticated
using ((auth.uid() IN ( SELECT users.id
   FROM public.users
  WHERE (users.role = 'admin'::text))));



  create policy "Allow admin full access to ads"
  on "public"."ads"
  as permissive
  for all
  to public
using ((auth.role() = 'admin'::text));



  create policy "Allow public read access to ads"
  on "public"."ads"
  as permissive
  for select
  to public
using (true);



  create policy "Enable update for authenticated users only"
  on "public"."ads"
  as permissive
  for update
  to authenticated
using (true)
with check (true);



  create policy "Allow admin full access to floating ads"
  on "public"."ads_floating"
  as permissive
  for all
  to public
using ((auth.role() = 'admin'::text));



  create policy "Allow public read access to active floating ads"
  on "public"."ads_floating"
  as permissive
  for select
  to public
using (((is_active = true) AND ((end_date IS NULL) OR (end_date > now())) AND (start_date <= now())));



  create policy "Allow authenticated users to update app_store_versions"
  on "public"."app_store_versions"
  as permissive
  for update
  to public
using ((auth.role() = 'authenticated'::text))
with check ((auth.role() = 'authenticated'::text));



  create policy "Allow public read access to app_store_versions"
  on "public"."app_store_versions"
  as permissive
  for select
  to public
using ((is_active = true));



  create policy "beauty_bookings_insert_policy"
  on "public"."beauty_bookings"
  as permissive
  for insert
  to public
with check (true);



  create policy "beauty_bookings_select_policy"
  on "public"."beauty_bookings"
  as permissive
  for select
  to public
using (((customer_email = (( SELECT users.email
   FROM auth.users
  WHERE (users.id = auth.uid())))::text) OR (EXISTS ( SELECT 1
   FROM public.beauty_salons
  WHERE ((beauty_salons.id = beauty_bookings.salon_id) AND (beauty_salons.owner_id = auth.uid()))))));



  create policy "beauty_bookings_update_policy"
  on "public"."beauty_bookings"
  as permissive
  for update
  to public
using (((customer_email = (( SELECT users.email
   FROM auth.users
  WHERE (users.id = auth.uid())))::text) OR (EXISTS ( SELECT 1
   FROM public.beauty_salons
  WHERE ((beauty_salons.id = beauty_bookings.salon_id) AND (beauty_salons.owner_id = auth.uid()))))));



  create policy "beauty_notifications_insert_policy"
  on "public"."beauty_notifications"
  as permissive
  for insert
  to public
with check (true);



  create policy "beauty_notifications_select_policy"
  on "public"."beauty_notifications"
  as permissive
  for select
  to public
using ((user_id = auth.uid()));



  create policy "beauty_reviews_insert_policy"
  on "public"."beauty_reviews"
  as permissive
  for insert
  to public
with check ((customer_email = (( SELECT users.email
   FROM auth.users
  WHERE (users.id = auth.uid())))::text));



  create policy "beauty_reviews_select_policy"
  on "public"."beauty_reviews"
  as permissive
  for select
  to public
using (true);



  create policy "beauty_salons_insert_policy"
  on "public"."beauty_salons"
  as permissive
  for insert
  to public
with check ((auth.uid() = owner_id));



  create policy "beauty_salons_select_policy"
  on "public"."beauty_salons"
  as permissive
  for select
  to public
using ((is_active = true));



  create policy "beauty_salons_update_policy"
  on "public"."beauty_salons"
  as permissive
  for update
  to public
using ((auth.uid() = owner_id));



  create policy "beauty_schedules_insert_policy"
  on "public"."beauty_schedules"
  as permissive
  for insert
  to public
with check ((EXISTS ( SELECT 1
   FROM public.beauty_salons
  WHERE ((beauty_salons.id = beauty_schedules.salon_id) AND (beauty_salons.owner_id = auth.uid())))));



  create policy "beauty_schedules_select_policy"
  on "public"."beauty_schedules"
  as permissive
  for select
  to public
using (true);



  create policy "beauty_schedules_update_policy"
  on "public"."beauty_schedules"
  as permissive
  for update
  to public
using ((EXISTS ( SELECT 1
   FROM public.beauty_salons
  WHERE ((beauty_salons.id = beauty_schedules.salon_id) AND (beauty_salons.owner_id = auth.uid())))));



  create policy "beauty_services_insert_policy"
  on "public"."beauty_services"
  as permissive
  for insert
  to public
with check ((EXISTS ( SELECT 1
   FROM public.beauty_salons
  WHERE ((beauty_salons.id = beauty_services.salon_id) AND (beauty_salons.owner_id = auth.uid())))));



  create policy "beauty_services_select_policy"
  on "public"."beauty_services"
  as permissive
  for select
  to public
using ((is_active = true));



  create policy "beauty_services_update_policy"
  on "public"."beauty_services"
  as permissive
  for update
  to public
using ((EXISTS ( SELECT 1
   FROM public.beauty_salons
  WHERE ((beauty_salons.id = beauty_services.salon_id) AND (beauty_salons.owner_id = auth.uid())))));



  create policy "beauty_staff_insert_policy"
  on "public"."beauty_staff"
  as permissive
  for insert
  to public
with check ((EXISTS ( SELECT 1
   FROM public.beauty_salons
  WHERE ((beauty_salons.id = beauty_staff.salon_id) AND (beauty_salons.owner_id = auth.uid())))));



  create policy "beauty_staff_select_policy"
  on "public"."beauty_staff"
  as permissive
  for select
  to public
using ((is_active = true));



  create policy "beauty_staff_update_policy"
  on "public"."beauty_staff"
  as permissive
  for update
  to public
using ((EXISTS ( SELECT 1
   FROM public.beauty_salons
  WHERE ((beauty_salons.id = beauty_staff.salon_id) AND (beauty_salons.owner_id = auth.uid())))));



  create policy "Admins can update cancellation requests"
  on "public"."cancellation_requests"
  as permissive
  for update
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Admins can view all cancellation requests"
  on "public"."cancellation_requests"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Riders can create cancellation requests"
  on "public"."cancellation_requests"
  as permissive
  for insert
  to public
with check ((rider_id IN ( SELECT riders.id
   FROM public.riders
  WHERE (riders.user_id = auth.uid()))));



  create policy "Riders can view own cancellation requests"
  on "public"."cancellation_requests"
  as permissive
  for select
  to public
using ((rider_id IN ( SELECT riders.id
   FROM public.riders
  WHERE (riders.user_id = auth.uid()))));



  create policy "Customers can insert chat messages for their orders"
  on "public"."chat_messages"
  as permissive
  for insert
  to public
with check (((sender_type = 'customer'::text) AND (sender_id = auth.uid()) AND (EXISTS ( SELECT 1
   FROM public.orders o
  WHERE ((o.id = chat_messages.order_id) AND (o.customer_id = auth.uid()))))));



  create policy "Customers can update their own chat messages"
  on "public"."chat_messages"
  as permissive
  for update
  to public
using (((sender_type = 'customer'::text) AND (sender_id = auth.uid())));



  create policy "Customers can view their own chat messages"
  on "public"."chat_messages"
  as permissive
  for select
  to public
using (((sender_type = 'customer'::text) AND (sender_id = auth.uid()) AND (EXISTS ( SELECT 1
   FROM public.orders o
  WHERE ((o.id = chat_messages.order_id) AND (o.customer_id = auth.uid()))))));



  create policy "Enable delete access for all users"
  on "public"."chat_messages"
  as permissive
  for delete
  to public
using (true);



  create policy "Enable insert access for all users"
  on "public"."chat_messages"
  as permissive
  for insert
  to public
with check (true);



  create policy "Enable read access for all users"
  on "public"."chat_messages"
  as permissive
  for select
  to public
using (true);



  create policy "Enable update access for all users"
  on "public"."chat_messages"
  as permissive
  for update
  to public
using (true)
with check (true);



  create policy "Riders can insert chat messages for assigned orders"
  on "public"."chat_messages"
  as permissive
  for insert
  to public
with check (((sender_type = 'rider'::text) AND (sender_id = ( SELECT rpv.rider_id
   FROM public.rider_profile_view rpv
  WHERE (rpv.user_id = auth.uid()))) AND (EXISTS ( SELECT 1
   FROM public.current_rider_assignments cra
  WHERE ((cra.order_id = chat_messages.order_id) AND (cra.rider_id = ( SELECT rpv.rider_id
           FROM public.rider_profile_view rpv
          WHERE (rpv.user_id = auth.uid()))))))));



  create policy "Riders can update chat messages for assigned orders"
  on "public"."chat_messages"
  as permissive
  for update
  to public
using ((EXISTS ( SELECT 1
   FROM public.current_rider_assignments cra
  WHERE ((cra.order_id = chat_messages.order_id) AND (cra.rider_id = ( SELECT rpv.rider_id
           FROM public.rider_profile_view rpv
          WHERE (rpv.user_id = auth.uid())))))));



  create policy "Riders can view chat messages for assigned orders"
  on "public"."chat_messages"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.current_rider_assignments cra
  WHERE ((cra.order_id = chat_messages.order_id) AND (cra.rider_id = ( SELECT rpv.rider_id
           FROM public.rider_profile_view rpv
          WHERE (rpv.user_id = auth.uid())))))));



  create policy "Admins can insert delivery fee history"
  on "public"."delivery_fee_history"
  as permissive
  for insert
  to public
with check ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Admins can view all delivery fee history"
  on "public"."delivery_fee_history"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Admins can manage all delivery fee settings"
  on "public"."delivery_fee_settings"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Anyone can view active delivery fee settings"
  on "public"."delivery_fee_settings"
  as permissive
  for select
  to public
using ((is_active = true));



  create policy "Users can delete their own delivery notes"
  on "public"."delivery_notes"
  as permissive
  for delete
  to public
using ((auth.uid() = user_id));



  create policy "Users can insert their own delivery notes"
  on "public"."delivery_notes"
  as permissive
  for insert
  to public
with check ((auth.uid() = user_id));



  create policy "Users can update their own delivery notes"
  on "public"."delivery_notes"
  as permissive
  for update
  to public
using ((auth.uid() = user_id));



  create policy "Users can view their own delivery notes"
  on "public"."delivery_notes"
  as permissive
  for select
  to public
using ((auth.uid() = user_id));



  create policy "Anyone can view window allocations"
  on "public"."delivery_window_allocations"
  as permissive
  for select
  to public
using (true);



  create policy "System can manage allocations"
  on "public"."delivery_window_allocations"
  as permissive
  for all
  to public
using (true);



  create policy "Admin can manage delivery windows"
  on "public"."delivery_windows"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Anyone can view delivery windows"
  on "public"."delivery_windows"
  as permissive
  for select
  to public
using (true);



  create policy "Store owners can view discount usage for their stores"
  on "public"."discount_code_usage"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM (public.orders
     JOIN public.stores ON ((stores.id = orders.store_id)))
  WHERE ((orders.id = discount_code_usage.order_id) AND (stores.owner_id = auth.uid())))));



  create policy "Users can view their own discount usage"
  on "public"."discount_code_usage"
  as permissive
  for select
  to public
using ((user_id = auth.uid()));



  create policy "Allow all operations for testing"
  on "public"."discount_codes"
  as permissive
  for all
  to public
using (true);



  create policy "Admins can insert document history"
  on "public"."document_verification_history"
  as permissive
  for insert
  to public
with check ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Admins can view all document history"
  on "public"."document_verification_history"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Riders can view own document history"
  on "public"."document_verification_history"
  as permissive
  for select
  to public
using ((rider_id IN ( SELECT riders.id
   FROM public.riders
  WHERE (riders.user_id = auth.uid()))));



  create policy "Authenticated users can view notification logs"
  on "public"."notification_logs"
  as permissive
  for select
  to public
using ((auth.role() = 'authenticated'::text));



  create policy "Service role can insert notification logs"
  on "public"."notification_logs"
  as permissive
  for insert
  to public
with check ((auth.role() = 'service_role'::text));



  create policy "Users can update own notifications"
  on "public"."notifications"
  as permissive
  for update
  to public
using ((user_id = auth.uid()));



  create policy "Users can view own notifications"
  on "public"."notifications"
  as permissive
  for select
  to public
using ((user_id = auth.uid()));



  create policy "Admin can manage photos"
  on "public"."order_checklist_photos"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Users can view photos of accessible orders"
  on "public"."order_checklist_photos"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.preorder_orders po
  WHERE ((po.id = order_checklist_photos.preorder_order_id) AND ((po.customer_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.users
          WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))))))));



  create policy "Admin can manage deposits"
  on "public"."order_deposits"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Customers can create deposits"
  on "public"."order_deposits"
  as permissive
  for insert
  to public
with check ((EXISTS ( SELECT 1
   FROM public.preorder_orders po
  WHERE ((po.id = order_deposits.preorder_order_id) AND (po.customer_id = auth.uid())))));



  create policy "Users can view deposits of accessible orders"
  on "public"."order_deposits"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.preorder_orders po
  WHERE ((po.id = order_deposits.preorder_order_id) AND ((po.customer_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.users
          WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))))))));



  create policy "Store owners can view discounts for their orders"
  on "public"."order_discounts"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM (public.orders
     JOIN public.stores ON ((stores.id = orders.store_id)))
  WHERE ((orders.id = order_discounts.order_id) AND (stores.owner_id = auth.uid())))));



  create policy "Users can view their own order discounts"
  on "public"."order_discounts"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.orders
  WHERE ((orders.id = order_discounts.order_id) AND (orders.customer_id = auth.uid())))));



  create policy "Customers can create order items"
  on "public"."order_items"
  as permissive
  for insert
  to public
with check ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE (orders.customer_id = auth.uid()))));



  create policy "Users can view order items"
  on "public"."order_items"
  as permissive
  for select
  to public
using ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE ((orders.customer_id = auth.uid()) OR (orders.store_id IN ( SELECT stores.id
           FROM public.stores
          WHERE (stores.owner_id = auth.uid()))) OR (orders.rider_id IN ( SELECT riders.id
           FROM public.riders
          WHERE (riders.user_id = auth.uid())))))));



  create policy "Allow function to create status history"
  on "public"."order_status_history"
  as permissive
  for insert
  to public
with check (true);



  create policy "Users can delete order status history"
  on "public"."order_status_history"
  as permissive
  for delete
  to public
using ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE ((orders.customer_id = auth.uid()) OR (orders.store_id IN ( SELECT stores.id
           FROM public.stores
          WHERE (stores.owner_id = auth.uid()))) OR (orders.rider_id IN ( SELECT riders.id
           FROM public.riders
          WHERE (riders.user_id = auth.uid())))))));



  create policy "Users can update order status history"
  on "public"."order_status_history"
  as permissive
  for update
  to public
using ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE ((orders.customer_id = auth.uid()) OR (orders.store_id IN ( SELECT stores.id
           FROM public.stores
          WHERE (stores.owner_id = auth.uid()))) OR (orders.rider_id IN ( SELECT riders.id
           FROM public.riders
          WHERE (riders.user_id = auth.uid())))))));



  create policy "Users can view order status history"
  on "public"."order_status_history"
  as permissive
  for select
  to public
using ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE ((orders.customer_id = auth.uid()) OR (orders.store_id IN ( SELECT stores.id
           FROM public.stores
          WHERE (stores.owner_id = auth.uid()))) OR (orders.rider_id IN ( SELECT riders.id
           FROM public.riders
          WHERE (riders.user_id = auth.uid())))))));



  create policy "Customers can create orders"
  on "public"."orders"
  as permissive
  for insert
  to public
with check ((customer_id = auth.uid()));



  create policy "Customers can update own orders"
  on "public"."orders"
  as permissive
  for update
  to public
using ((customer_id = auth.uid()));



  create policy "Customers can view own orders"
  on "public"."orders"
  as permissive
  for select
  to public
using ((customer_id = auth.uid()));



  create policy "Store owners and riders can update orders"
  on "public"."orders"
  as permissive
  for update
  to public
using (((store_id IN ( SELECT stores.id
   FROM public.stores
  WHERE (stores.owner_id = auth.uid()))) OR (rider_id IN ( SELECT riders.id
   FROM public.riders
  WHERE (riders.user_id = auth.uid())))));



  create policy "Store owners can view store orders"
  on "public"."orders"
  as permissive
  for select
  to public
using ((store_id IN ( SELECT stores.id
   FROM public.stores
  WHERE (stores.owner_id = auth.uid()))));



  create policy "Admins can view all payment history"
  on "public"."payment_history"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Authorized users can insert payment history"
  on "public"."payment_history"
  as permissive
  for insert
  to public
with check (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))) OR (order_id IN ( SELECT o.id
   FROM public.orders o
  WHERE (o.store_id IN ( SELECT s.id
           FROM public.stores s
          WHERE (s.owner_id = auth.uid()))))) OR (order_id IN ( SELECT o.id
   FROM public.orders o
  WHERE (o.customer_id = auth.uid()))) OR (processed_by = auth.uid())));



  create policy "Store owners can view store payment history"
  on "public"."payment_history"
  as permissive
  for select
  to public
using ((order_id IN ( SELECT o.id
   FROM public.orders o
  WHERE (o.store_id IN ( SELECT s.id
           FROM public.stores s
          WHERE (s.owner_id = auth.uid()))))));



  create policy "Users can view own payment history"
  on "public"."payment_history"
  as permissive
  for select
  to public
using ((order_id IN ( SELECT o.id
   FROM public.orders o
  WHERE (o.customer_id = auth.uid()))));



  create policy "Users can manage items of own orders"
  on "public"."preorder_items"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.preorder_orders po
  WHERE ((po.id = preorder_items.preorder_order_id) AND ((po.customer_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.users
          WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))))))));



  create policy "Users can view items of accessible orders"
  on "public"."preorder_items"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.preorder_orders po
  WHERE ((po.id = preorder_items.preorder_order_id) AND ((po.customer_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.users
          WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))))))));



  create policy "Admin can delete preorders"
  on "public"."preorder_orders"
  as permissive
  for delete
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Customers can create preorders"
  on "public"."preorder_orders"
  as permissive
  for insert
  to public
with check ((customer_id = auth.uid()));



  create policy "Customers can update own preorders"
  on "public"."preorder_orders"
  as permissive
  for update
  to public
using (((customer_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text))))));



  create policy "Customers can view own preorders"
  on "public"."preorder_orders"
  as permissive
  for select
  to public
using (((customer_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text))))));



  create policy "Admin can manage settings"
  on "public"."preorder_settings"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Anyone can view preorder settings"
  on "public"."preorder_settings"
  as permissive
  for select
  to public
using (true);



  create policy "Anyone can view available products"
  on "public"."products"
  as permissive
  for select
  to public
using ((is_available = true));



  create policy "Store owners can manage own products"
  on "public"."products"
  as permissive
  for all
  to public
using ((store_id IN ( SELECT stores.id
   FROM public.stores
  WHERE (stores.owner_id = auth.uid()))));



  create policy "Allow function to create assignments"
  on "public"."rider_assignments"
  as permissive
  for insert
  to public
with check (true);



  create policy "Customers can view assignments for their orders"
  on "public"."rider_assignments"
  as permissive
  for select
  to public
using ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE (orders.customer_id = auth.uid()))));



  create policy "Riders can delete own assignments"
  on "public"."rider_assignments"
  as permissive
  for delete
  to public
using ((rider_id IN ( SELECT riders.id
   FROM public.riders
  WHERE (riders.user_id = auth.uid()))));



  create policy "Riders can update own assignments"
  on "public"."rider_assignments"
  as permissive
  for update
  to public
using ((rider_id IN ( SELECT riders.id
   FROM public.riders
  WHERE (riders.user_id = auth.uid()))));



  create policy "Store owners can view assignments for their orders"
  on "public"."rider_assignments"
  as permissive
  for select
  to public
using ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE (orders.store_id IN ( SELECT stores.id
           FROM public.stores
          WHERE (stores.owner_id = auth.uid()))))));



  create policy "Admins can manage all rider documents"
  on "public"."rider_documents"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Riders can update own documents"
  on "public"."rider_documents"
  as permissive
  for update
  to public
using ((rider_id IN ( SELECT riders.id
   FROM public.riders
  WHERE (riders.user_id = auth.uid()))));



  create policy "Riders can upload own documents"
  on "public"."rider_documents"
  as permissive
  for insert
  to public
with check ((rider_id IN ( SELECT riders.id
   FROM public.riders
  WHERE (riders.user_id = auth.uid()))));



  create policy "Riders can view own documents"
  on "public"."rider_documents"
  as permissive
  for select
  to public
using ((rider_id IN ( SELECT riders.id
   FROM public.riders
  WHERE (riders.user_id = auth.uid()))));



  create policy "riders_can_delete_fcm_token"
  on "public"."rider_fcm_tokens"
  as permissive
  for delete
  to public
using (true);



  create policy "riders_can_insert_fcm_token"
  on "public"."rider_fcm_tokens"
  as permissive
  for insert
  to public
with check (true);



  create policy "riders_can_select_fcm_token"
  on "public"."rider_fcm_tokens"
  as permissive
  for select
  to public
using (true);



  create policy "riders_can_update_fcm_token"
  on "public"."rider_fcm_tokens"
  as permissive
  for update
  to public
using (true)
with check (true);



  create policy "Admins can manage all reviews"
  on "public"."rider_reviews"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Customers can create reviews"
  on "public"."rider_reviews"
  as permissive
  for insert
  to public
with check (((customer_id = auth.uid()) AND (EXISTS ( SELECT 1
   FROM public.orders
  WHERE ((orders.id = rider_reviews.order_id) AND (orders.customer_id = auth.uid()) AND (orders.status = 'delivered'::text))))));



  create policy "Customers can delete own reviews"
  on "public"."rider_reviews"
  as permissive
  for delete
  to public
using ((customer_id = auth.uid()));



  create policy "Customers can update own reviews"
  on "public"."rider_reviews"
  as permissive
  for update
  to public
using ((customer_id = auth.uid()))
with check ((customer_id = auth.uid()));



  create policy "Customers can view own reviews"
  on "public"."rider_reviews"
  as permissive
  for select
  to public
using ((customer_id = auth.uid()));



  create policy "Public can view rider reviews"
  on "public"."rider_reviews"
  as permissive
  for select
  to public
using (true);



  create policy "Riders can view their reviews"
  on "public"."rider_reviews"
  as permissive
  for select
  to public
using ((rider_id IN ( SELECT riders.id
   FROM public.riders
  WHERE (riders.user_id = auth.uid()))));



  create policy "Anyone can view available riders"
  on "public"."riders"
  as permissive
  for select
  to public
using ((is_available = true));



  create policy "Riders can manage own profile"
  on "public"."riders"
  as permissive
  for all
  to public
using ((user_id = auth.uid()));



  create policy "Store owners can manage own bank accounts"
  on "public"."store_bank_accounts"
  as permissive
  for all
  to public
using ((store_id IN ( SELECT stores.id
   FROM public.stores
  WHERE (stores.owner_id = auth.uid()))));



  create policy "Admins can manage all store cancellation requests"
  on "public"."store_cancellation_requests"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Store owners can create cancellation requests"
  on "public"."store_cancellation_requests"
  as permissive
  for insert
  to public
with check ((auth.uid() = ( SELECT stores.owner_id
   FROM public.stores
  WHERE (stores.id = store_cancellation_requests.store_id))));



  create policy "Store owners can view their cancellation requests"
  on "public"."store_cancellation_requests"
  as permissive
  for select
  to public
using ((auth.uid() = ( SELECT stores.owner_id
   FROM public.stores
  WHERE (stores.id = store_cancellation_requests.store_id))));



  create policy "Admins can manage all store reports"
  on "public"."store_reports"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Customers can create store reports"
  on "public"."store_reports"
  as permissive
  for insert
  to public
with check (((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'customer'::text)))) AND (reporter_id = auth.uid())));



  create policy "Customers can view own reports"
  on "public"."store_reports"
  as permissive
  for select
  to public
using ((reporter_id = auth.uid()));



  create policy "Store owners can view reports for their stores"
  on "public"."store_reports"
  as permissive
  for select
  to public
using ((store_id IN ( SELECT stores.id
   FROM public.stores
  WHERE (stores.owner_id = auth.uid()))));



  create policy "Admins can manage all suspension history"
  on "public"."store_suspension_history"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Store owners can view own suspension history"
  on "public"."store_suspension_history"
  as permissive
  for select
  to public
using ((store_id IN ( SELECT stores.id
   FROM public.stores
  WHERE (stores.owner_id = auth.uid()))));



  create policy "Admins can manage all stores"
  on "public"."stores"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.role = 'admin'::text)))));



  create policy "Anyone can view active stores"
  on "public"."stores"
  as permissive
  for select
  to public
using ((is_active = true));



  create policy "Store owners can manage own store"
  on "public"."stores"
  as permissive
  for all
  to public
using ((owner_id = auth.uid()));



  create policy "Allow Google Login"
  on "public"."users"
  as permissive
  for insert
  to public
with check (true);



  create policy "Users can call check_user_registration_status"
  on "public"."users"
  as permissive
  for select
  to public
using ((auth.uid() = id));



  create policy "Users can call get_user_auth_status"
  on "public"."users"
  as permissive
  for select
  to public
using ((auth.uid() = id));



  create policy "Users can call update_user_profile"
  on "public"."users"
  as permissive
  for update
  to public
using ((auth.uid() = id));



  create policy "Users can call update_user_role"
  on "public"."users"
  as permissive
  for update
  to public
using ((auth.uid() = id));



  create policy "Users can update login info"
  on "public"."users"
  as permissive
  for update
  to public
using ((auth.uid() = id));



  create policy "Users can update own profile"
  on "public"."users"
  as permissive
  for update
  to public
using ((auth.uid() = id));



  create policy "Users can update their own fcm_token"
  on "public"."users"
  as permissive
  for update
  to public
using ((auth.uid() = id))
with check ((auth.uid() = id));



  create policy "Users can view own profile"
  on "public"."users"
  as permissive
  for select
  to public
using ((auth.uid() = id));


CREATE TRIGGER update_ads_updated_at_trigger BEFORE UPDATE ON public.ads FOR EACH ROW EXECUTE FUNCTION public.update_ads_updated_at();

CREATE TRIGGER update_ads_floating_updated_at_trigger BEFORE UPDATE ON public.ads_floating FOR EACH ROW EXECUTE FUNCTION public.update_ads_floating_updated_at();

CREATE TRIGGER update_ads_hotel_updated_at BEFORE UPDATE ON public.ads_hotel FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER app_store_versions_updated_at_trigger BEFORE UPDATE ON public.app_store_versions FOR EACH ROW EXECUTE FUNCTION public.update_app_store_versions_updated_at();

CREATE TRIGGER trigger_update_available_jobs_for_workers_updated_at BEFORE UPDATE ON public.available_jobs_for_workers FOR EACH ROW EXECUTE FUNCTION public.update_available_jobs_for_workers_updated_at();

CREATE TRIGGER auto_update_fcm_tokens_trigger AFTER INSERT ON public.chat_messages FOR EACH ROW EXECUTE FUNCTION public.auto_update_fcm_tokens();

CREATE TRIGGER delete_chat_image_trigger BEFORE DELETE ON public.chat_messages FOR EACH ROW EXECUTE FUNCTION public.delete_chat_image();

CREATE TRIGGER ensure_fcm_tokens_trigger BEFORE INSERT ON public.chat_messages FOR EACH ROW EXECUTE FUNCTION public.ensure_fcm_tokens_on_insert();

CREATE TRIGGER ensure_fcm_tokens_update_trigger BEFORE UPDATE ON public.chat_messages FOR EACH ROW EXECUTE FUNCTION public.ensure_fcm_tokens_on_update();

CREATE TRIGGER delete_community_comment_image_trigger BEFORE DELETE ON public.community_comments FOR EACH ROW EXECUTE FUNCTION public.delete_community_comment_image();

CREATE TRIGGER delete_community_post_images_trigger BEFORE DELETE ON public.community_posts FOR EACH ROW EXECUTE FUNCTION public.delete_community_post_images();

CREATE TRIGGER "n8n-community-posts-noti" AFTER INSERT ON public.community_posts FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('http://n8n.ขายง่ายง่าย.com/webhook/post-callback', 'POST', '{"Content-type":"application/json"}', '{}', '5000');

CREATE TRIGGER trigger_update_delivery_notes_updated_at BEFORE UPDATE ON public.delivery_notes FOR EACH ROW EXECUTE FUNCTION public.update_delivery_notes_updated_at();

CREATE TRIGGER trigger_update_fcm_store_updated_at BEFORE UPDATE ON public.fcm_store FOR EACH ROW EXECUTE FUNCTION public.update_fcm_store_updated_at();

CREATE TRIGGER update_hotel_bookings_updated_at BEFORE UPDATE ON public.hotel_bookings FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_hotel_hourly_availability_updated_at BEFORE UPDATE ON public.hotel_hourly_availability FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_hotel_owner_accounts_updated_at BEFORE UPDATE ON public.hotel_owner_accounts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_hotel_properties_updated_at BEFORE UPDATE ON public.hotel_properties FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_hotel_room_availability_updated_at BEFORE UPDATE ON public.hotel_room_availability FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_hotel_room_types_updated_at BEFORE UPDATE ON public.hotel_room_types FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_hotel_rooms_updated_at BEFORE UPDATE ON public.hotel_rooms FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER trigger_update_job_assignments_updated_at BEFORE UPDATE ON public.job_assignments FOR EACH ROW EXECUTE FUNCTION public.update_job_assignments_updated_at();

CREATE TRIGGER trigger_sync_available_jobs_for_workers_category AFTER DELETE OR UPDATE ON public.job_categories FOR EACH ROW EXECUTE FUNCTION public.sync_available_jobs_for_workers();

CREATE TRIGGER trigger_update_job_categories_updated_at BEFORE UPDATE ON public.job_categories FOR EACH ROW EXECUTE FUNCTION public.update_job_categories_updated_at();

CREATE TRIGGER trigger_award_credit_on_approval AFTER UPDATE OF approval_status ON public.job_completion_approvals FOR EACH ROW WHEN (((new.approval_status = 'approved'::text) AND (old.approval_status <> 'approved'::text))) EXECUTE FUNCTION public.award_credit_on_job_approval();

CREATE TRIGGER trigger_update_job_fee_settings_updated_at BEFORE UPDATE ON public.job_fee_settings FOR EACH ROW EXECUTE FUNCTION public.update_job_fee_settings_updated_at();

CREATE TRIGGER trigger_sync_available_jobs_for_workers AFTER INSERT OR DELETE OR UPDATE ON public.job_postings FOR EACH ROW EXECUTE FUNCTION public.sync_available_jobs_for_workers();

CREATE TRIGGER trigger_update_job_postings_updated_at BEFORE UPDATE ON public.job_postings FOR EACH ROW EXECUTE FUNCTION public.update_job_postings_updated_at();

CREATE TRIGGER trigger_update_job_worker_credits_updated_at BEFORE UPDATE ON public.job_worker_credits FOR EACH ROW EXECUTE FUNCTION public.update_job_worker_credits_updated_at();

CREATE TRIGGER trigger_update_job_worker_fcm_tokens_updated_at BEFORE UPDATE ON public.job_worker_fcm_tokens FOR EACH ROW EXECUTE FUNCTION public.update_job_worker_fcm_tokens_updated_at();

CREATE TRIGGER trigger_deduct_credit_on_withdrawal_approved AFTER UPDATE OF status ON public.job_worker_withdrawals FOR EACH ROW WHEN (((new.status = 'approved'::text) AND (old.status <> 'approved'::text))) EXECUTE FUNCTION public.deduct_credit_on_withdrawal_approved();

CREATE TRIGGER trigger_update_job_worker_withdrawals_updated_at BEFORE UPDATE ON public.job_worker_withdrawals FOR EACH ROW EXECUTE FUNCTION public.update_job_worker_withdrawals_updated_at();

CREATE TRIGGER trigger_sync_job_worker_fcm_tokens AFTER UPDATE ON public.job_workers FOR EACH ROW WHEN ((old.is_active IS DISTINCT FROM new.is_active)) EXECUTE FUNCTION public.sync_job_worker_fcm_tokens();

CREATE TRIGGER trigger_update_job_workers_updated_at BEFORE UPDATE ON public.job_workers FOR EACH ROW EXECUTE FUNCTION public.update_job_workers_updated_at();

CREATE TRIGGER "n8n-rider-notification" AFTER INSERT ON public.new_order_for_riders FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('http://n8n.ขายง่ายง่าย.com/webhook/rider-callback', 'POST', '{}', '{}', '5000');

CREATE TRIGGER "n8n-notification" AFTER INSERT ON public.notifications FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('http://n8n.ขายง่ายง่าย.com/webhook/notification-callback', 'POST', '{}', '{}', '5000');

CREATE TRIGGER trg_update_task_progress_on_review_created AFTER INSERT ON public.order_reviews FOR EACH ROW EXECUTE FUNCTION public.update_task_progress_on_event();

CREATE TRIGGER trigger_update_order_reviews_updated_at BEFORE UPDATE ON public.order_reviews FOR EACH ROW EXECUTE FUNCTION public.update_order_reviews_updated_at();

CREATE TRIGGER generate_order_number_trigger BEFORE INSERT ON public.orders FOR EACH ROW WHEN ((new.order_number IS NULL)) EXECUTE FUNCTION public.generate_order_number();

CREATE TRIGGER sync_active_orders_trigger AFTER INSERT OR DELETE OR UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.sync_store_active_orders();

CREATE TRIGGER sync_store_active_orders_trigger AFTER INSERT OR UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.sync_store_active_orders();

CREATE TRIGGER trg_award_order_delivery_points AFTER UPDATE OF status ON public.orders FOR EACH ROW WHEN ((old.status IS DISTINCT FROM new.status)) EXECUTE FUNCTION public.award_order_delivery_points();

CREATE TRIGGER trg_cleanup_rider_locations_after_delivery AFTER UPDATE OF status ON public.orders FOR EACH ROW WHEN (((old.status IS DISTINCT FROM new.status) AND (new.status = 'delivered'::text))) EXECUTE FUNCTION public.cleanup_rider_locations_after_delivery();

CREATE TRIGGER trg_update_task_progress_on_order_delivered AFTER UPDATE OF status ON public.orders FOR EACH ROW WHEN (((old.status IS DISTINCT FROM new.status) AND (new.status = 'delivered'::text))) EXECUTE FUNCTION public.update_task_progress_on_event();

CREATE TRIGGER trigger_assign_booked_orders_on_order_status_change AFTER UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.trigger_assign_booked_orders();

CREATE TRIGGER trigger_notify_new_pending_order AFTER INSERT ON public.orders FOR EACH ROW EXECUTE FUNCTION public.trigger_notify_new_pending_order();

CREATE TRIGGER trigger_sync_new_order_for_riders AFTER INSERT OR DELETE OR UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.sync_new_order_for_riders();

CREATE TRIGGER trg_preorder_fee_updated_at BEFORE UPDATE ON public.preorder_delivery_fee_config FOR EACH ROW EXECUTE FUNCTION public.set_preorder_fee_updated_at();

CREATE TRIGGER manage_window_allocation AFTER INSERT OR DELETE OR UPDATE ON public.preorder_orders FOR EACH ROW EXECUTE FUNCTION public.update_window_allocation();

CREATE TRIGGER set_preorder_number BEFORE INSERT ON public.preorder_orders FOR EACH ROW WHEN (((new.preorder_number IS NULL) OR (new.preorder_number = ''::text))) EXECUTE FUNCTION public.generate_preorder_number();

CREATE TRIGGER trigger_sync_deposit_status BEFORE UPDATE ON public.preorder_orders FOR EACH ROW EXECUTE FUNCTION public.sync_deposit_status_on_status_change();

CREATE TRIGGER update_preorder_orders_updated_at BEFORE UPDATE ON public.preorder_orders FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_preorder_settings_updated_at BEFORE UPDATE ON public.preorder_settings FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER trigger_update_product_option_values_updated_at BEFORE UPDATE ON public.product_option_values FOR EACH ROW EXECUTE FUNCTION public.update_product_option_values_updated_at();

CREATE TRIGGER trigger_update_product_options_updated_at BEFORE UPDATE ON public.product_options FOR EACH ROW EXECUTE FUNCTION public.update_product_options_updated_at();

CREATE TRIGGER trigger_cleanup_bookings_on_assignment_completion AFTER UPDATE ON public.rider_assignments FOR EACH ROW EXECUTE FUNCTION public.trigger_cleanup_bookings_on_completion();

CREATE TRIGGER trigger_update_available_riders_from_assignments AFTER INSERT OR DELETE OR UPDATE ON public.rider_assignments FOR EACH ROW EXECUTE FUNCTION public.update_available_riders_from_assignments();

CREATE TRIGGER trigger_update_rider_stats_on_delivery AFTER UPDATE ON public.rider_assignments FOR EACH ROW EXECUTE FUNCTION public.update_rider_stats_on_delivery();

CREATE TRIGGER trigger_update_rider_fcm_tokens_updated_at BEFORE UPDATE ON public.rider_fcm_tokens FOR EACH ROW EXECUTE FUNCTION public.update_rider_fcm_tokens_updated_at();

CREATE TRIGGER trigger_update_rider_reviews_updated_at BEFORE UPDATE ON public.rider_reviews FOR EACH ROW EXECUTE FUNCTION public.update_rider_reviews_updated_at();

CREATE TRIGGER trigger_update_available_riders_status AFTER UPDATE ON public.riders FOR EACH ROW EXECUTE FUNCTION public.update_available_riders_status();

CREATE TRIGGER n8n_store_active_orders AFTER INSERT OR UPDATE ON public.store_active_orders FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('http://n8n.ขายง่ายง่าย.com/webhook/callback', 'POST', '{"Content-type":"application/json"}', '{}', '5000');

CREATE TRIGGER "test-noti" AFTER UPDATE ON public.store_active_orders FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('http://n8n.ขายง่ายง่าย.com/webhook-test/callback', 'POST', '{}', '{}', '5000');

CREATE TRIGGER generate_store_code_trigger BEFORE INSERT ON public.stores FOR EACH ROW WHEN ((new.code_store IS NULL)) EXECUTE FUNCTION public.generate_store_code();

CREATE TRIGGER trigger_update_store_location BEFORE INSERT OR UPDATE OF latitude, longitude ON public.stores FOR EACH ROW EXECUTE FUNCTION public.update_store_location();

CREATE TRIGGER trigger_update_customer_data_in_orders AFTER UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_customer_data_in_orders();

CREATE TRIGGER update_age_on_date_of_birth BEFORE INSERT OR UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_age_trigger();

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


  create policy " Anyone can view users images z23ahp_0"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'users-images'::text));



  create policy " Users can upload user images z23ahp_0"
  on "storage"."objects"
  as permissive
  for insert
  to public
with check ((bucket_id = 'users-images'::text));



  create policy "Allow admin to manage ads images"
  on "storage"."objects"
  as permissive
  for all
  to public
using (((bucket_id = 'ads-images'::text) AND (auth.role() = 'admin'::text)));



  create policy "Allow authenticated users to upload ads images"
  on "storage"."objects"
  as permissive
  for insert
  to public
with check (((bucket_id = 'ads-images'::text) AND (auth.role() = 'authenticated'::text)));



  create policy "Allow public read access to ads images"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'ads-images'::text));



  create policy "Anyone can view product images 16wiy3a_0"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'product-images'::text));



  create policy "Anyone can view rider images"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'rider-images'::text));



  create policy "Anyone can view store images 1q9l3ac_0"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'store-images'::text));



  create policy "Authenticated users can delete store category images"
  on "storage"."objects"
  as permissive
  for delete
  to authenticated
using (((bucket_id = 'store-categories-images'::text) AND ((storage.foldername(name))[1] IS NOT NULL)));



  create policy "Authenticated users can update store category images"
  on "storage"."objects"
  as permissive
  for update
  to authenticated
using ((bucket_id = 'store-categories-images'::text))
with check (((bucket_id = 'store-categories-images'::text) AND ((storage.foldername(name))[1] IS NOT NULL)));



  create policy "Authenticated users can upload 3pstwj_0"
  on "storage"."objects"
  as permissive
  for insert
  to public
with check ((bucket_id = 'hotel_images'::text));



  create policy "Authenticated users can upload store category images"
  on "storage"."objects"
  as permissive
  for insert
  to authenticated
with check (((bucket_id = 'store-categories-images'::text) AND ((storage.foldername(name))[1] IS NOT NULL)));



  create policy "Authenticated users can upload"
  on "storage"."objects"
  as permissive
  for insert
  to public
with check (((bucket_id = 'post-images'::text) AND (auth.role() = 'authenticated'::text)));



  create policy "Chat images are publicly accessible"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'chat-images'::text));



  create policy "Customers can delete chat images"
  on "storage"."objects"
  as permissive
  for delete
  to public
using (((bucket_id = 'chat-images'::text) AND (auth.role() = 'authenticated'::text)));



  create policy "Customers can update chat images"
  on "storage"."objects"
  as permissive
  for update
  to public
using (((bucket_id = 'chat-images'::text) AND (auth.role() = 'authenticated'::text)));



  create policy "Customers can upload chat images"
  on "storage"."objects"
  as permissive
  for insert
  to public
with check (((bucket_id = 'chat-images'::text) AND (auth.role() = 'authenticated'::text)));



  create policy "Public Access 3pstwj_0"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'hotel_images'::text));



  create policy "Public Access"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'post-images'::text));



  create policy "Public can view store category images"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'store-categories-images'::text));



  create policy "Riders can delete chat images"
  on "storage"."objects"
  as permissive
  for delete
  to public
using (((bucket_id = 'chat-images'::text) AND (EXISTS ( SELECT 1
   FROM public.rider_profile_view rpv
  WHERE (rpv.rider_id = auth.uid())))));



  create policy "Riders can update chat images"
  on "storage"."objects"
  as permissive
  for update
  to public
using (((bucket_id = 'chat-images'::text) AND (EXISTS ( SELECT 1
   FROM public.rider_profile_view rpv
  WHERE (rpv.rider_id = auth.uid())))));



  create policy "Riders can upload chat images"
  on "storage"."objects"
  as permissive
  for insert
  to public
with check (((bucket_id = 'chat-images'::text) AND (EXISTS ( SELECT 1
   FROM public.rider_profile_view rpv
  WHERE (rpv.rider_id = auth.uid())))));



  create policy "Users can delete own files 3pstwj_0"
  on "storage"."objects"
  as permissive
  for delete
  to public
using ((bucket_id = 'hotel_images'::text));



  create policy "Users can delete own files"
  on "storage"."objects"
  as permissive
  for delete
  to public
using (((bucket_id = 'post-images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));



  create policy "Users can delete their own product images 16wiy3a_0"
  on "storage"."objects"
  as permissive
  for delete
  to public
using ((bucket_id = 'product-images'::text));



  create policy "Users can delete their own rider images"
  on "storage"."objects"
  as permissive
  for delete
  to public
using (((bucket_id = 'rider-images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1]) AND ((storage.foldername(name))[2] = 'profile'::text)));



  create policy "Users can delete their own store images 1q9l3ac_0"
  on "storage"."objects"
  as permissive
  for delete
  to public
using ((bucket_id = 'store-images'::text));



  create policy "Users can delete their own users images z23ahp_0"
  on "storage"."objects"
  as permissive
  for delete
  to public
using ((bucket_id = 'users-images'::text));



  create policy "Users can update own files 3pstwj_0"
  on "storage"."objects"
  as permissive
  for update
  to public
using ((bucket_id = 'hotel_images'::text));



  create policy "Users can update own files"
  on "storage"."objects"
  as permissive
  for update
  to public
using (((bucket_id = 'post-images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));



  create policy "Users can update their own product images 16wiy3a_0"
  on "storage"."objects"
  as permissive
  for update
  to public
using ((bucket_id = 'product-images'::text));



  create policy "Users can update their own rider images"
  on "storage"."objects"
  as permissive
  for update
  to public
using (((bucket_id = 'rider-images'::text) AND ((auth.uid())::text = (storage.foldername(name))[1]) AND ((storage.foldername(name))[2] = 'profile'::text)));



  create policy "Users can update their own store images 1q9l3ac_0"
  on "storage"."objects"
  as permissive
  for insert
  to public
with check ((bucket_id = 'store-images'::text));



  create policy "Users can update their own store images 1q9l3ac_1"
  on "storage"."objects"
  as permissive
  for update
  to public
using ((bucket_id = 'store-images'::text));



  create policy "Users can update their own users images z23ahp_0"
  on "storage"."objects"
  as permissive
  for update
  to public
using ((bucket_id = 'users-images'::text));



  create policy "Users can upload product images 16wiy3a_0"
  on "storage"."objects"
  as permissive
  for insert
  to public
with check ((bucket_id = 'product-images'::text));



  create policy "Users can upload rider images"
  on "storage"."objects"
  as permissive
  for insert
  to public
with check (((bucket_id = 'rider-images'::text) AND (auth.uid() IS NOT NULL)));




drop policy if exists "Riders can delete chat images" on "storage"."objects";

drop policy if exists "Riders can update chat images" on "storage"."objects";

drop policy if exists "Riders can upload chat images" on "storage"."objects";

drop trigger if exists "sync_active_orders_trigger" on "public"."orders";

drop trigger if exists "sync_store_active_orders_trigger" on "public"."orders";

drop policy "Riders can insert chat messages for assigned orders" on "public"."chat_messages";

drop policy "Riders can update chat messages for assigned orders" on "public"."chat_messages";

drop policy "Riders can view chat messages for assigned orders" on "public"."chat_messages";

drop view if exists "public"."active_order_chat_messages";

drop view if exists "public"."chat_messages_with_sender_info";

drop view if exists "public"."rider_response_statistics";

drop view if exists "public"."available_orders_for_riders";

drop view if exists "public"."available_riders";

drop view if exists "public"."bookable_orders_for_riders";

drop view if exists "public"."current_rider_assignments";

drop view if exists "public"."rider_profile_view";

drop view if exists "public"."v_daily_best_selling_stores";

drop view if exists "public"."v_daily_new_stores";

drop view if exists "public"."v_daily_small_stores";

  create table "public"."admin_zones" (
    "id" uuid not null default gen_random_uuid(),
    "admin_id" uuid not null,
    "zone_id" uuid not null,
    "can_view" boolean default true,
    "can_edit" boolean default true,
    "can_manage_stores" boolean default true,
    "can_manage_riders" boolean default true,
    "can_manage_orders" boolean default true,
    "assigned_by" uuid,
    "assigned_at" timestamp with time zone default now(),
    "created_at" timestamp with time zone default now()
      );



  create table "public"."rider_zones" (
    "id" uuid not null default gen_random_uuid(),
    "rider_id" uuid not null,
    "zone_id" uuid not null,
    "is_primary" boolean default false,
    "created_at" timestamp with time zone default now()
      );



  create table "public"."zones" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "code" text not null,
    "province" text not null,
    "district" text,
    "description" text,
    "boundary_geojson" jsonb,
    "center_latitude" numeric(10,8),
    "center_longitude" numeric(11,8),
    "radius_km" numeric(5,2),
    "is_active" boolean default true,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."delivery_fee_config_v2" add column "base_fee" double precision default 7.0;

alter table "public"."delivery_fee_config_v2" add column "distance_fee_per_km" double precision default 5.0;

alter table "public"."delivery_fee_config_v2" add column "zone_id" uuid;

alter table "public"."orders" add column "last_notification_sent_at" timestamp with time zone;

alter table "public"."orders" add column "notification_error" text;

alter table "public"."orders" add column "notification_retry_count" integer default 0;

alter table "public"."orders" add column "notification_status" text default 'pending'::text;

alter table "public"."orders" add column "zone_id" uuid;

alter table "public"."orders" enable row level security;

alter table "public"."riders" add column "can_work_multiple_zones" boolean default false;

alter table "public"."riders" add column "zone_id" uuid;

alter table "public"."stores" add column "zone_id" uuid;

alter table "public"."users" add column "is_super_admin" boolean default false;

alter table "public"."users" add column "is_zone_admin" boolean default false;

CREATE UNIQUE INDEX admin_zones_admin_id_zone_id_key ON public.admin_zones USING btree (admin_id, zone_id);

CREATE UNIQUE INDEX admin_zones_pkey ON public.admin_zones USING btree (id);

CREATE INDEX idx_admin_zones_admin_id ON public.admin_zones USING btree (admin_id);

CREATE INDEX idx_admin_zones_zone_id ON public.admin_zones USING btree (zone_id);

CREATE INDEX idx_delivery_fee_config_v2_zone_id ON public.delivery_fee_config_v2 USING btree (zone_id);

CREATE INDEX idx_orders_zone_id ON public.orders USING btree (zone_id);

CREATE INDEX idx_rider_zones_rider_id ON public.rider_zones USING btree (rider_id);

CREATE INDEX idx_rider_zones_zone_id ON public.rider_zones USING btree (zone_id);

CREATE INDEX idx_riders_zone_id ON public.riders USING btree (zone_id);

CREATE INDEX idx_stores_zone_id ON public.stores USING btree (zone_id);

CREATE INDEX idx_users_is_super_admin ON public.users USING btree (is_super_admin);

CREATE INDEX idx_users_is_zone_admin ON public.users USING btree (is_zone_admin);

CREATE INDEX idx_zones_code ON public.zones USING btree (code);

CREATE INDEX idx_zones_is_active ON public.zones USING btree (is_active);

CREATE INDEX idx_zones_province ON public.zones USING btree (province);

CREATE UNIQUE INDEX rider_zones_pkey ON public.rider_zones USING btree (id);

CREATE UNIQUE INDEX rider_zones_rider_id_zone_id_key ON public.rider_zones USING btree (rider_id, zone_id);

CREATE UNIQUE INDEX zones_code_key ON public.zones USING btree (code);

CREATE UNIQUE INDEX zones_pkey ON public.zones USING btree (id);

alter table "public"."admin_zones" add constraint "admin_zones_pkey" PRIMARY KEY using index "admin_zones_pkey";

alter table "public"."rider_zones" add constraint "rider_zones_pkey" PRIMARY KEY using index "rider_zones_pkey";

alter table "public"."zones" add constraint "zones_pkey" PRIMARY KEY using index "zones_pkey";

alter table "public"."admin_zones" add constraint "admin_zones_admin_id_fkey" FOREIGN KEY (admin_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."admin_zones" validate constraint "admin_zones_admin_id_fkey";

alter table "public"."admin_zones" add constraint "admin_zones_admin_id_zone_id_key" UNIQUE using index "admin_zones_admin_id_zone_id_key";

alter table "public"."admin_zones" add constraint "admin_zones_assigned_by_fkey" FOREIGN KEY (assigned_by) REFERENCES public.users(id) not valid;

alter table "public"."admin_zones" validate constraint "admin_zones_assigned_by_fkey";

alter table "public"."admin_zones" add constraint "admin_zones_zone_id_fkey" FOREIGN KEY (zone_id) REFERENCES public.zones(id) ON DELETE CASCADE not valid;

alter table "public"."admin_zones" validate constraint "admin_zones_zone_id_fkey";

alter table "public"."delivery_fee_config_v2" add constraint "delivery_fee_config_v2_zone_id_fkey" FOREIGN KEY (zone_id) REFERENCES public.zones(id) not valid;

alter table "public"."delivery_fee_config_v2" validate constraint "delivery_fee_config_v2_zone_id_fkey";

alter table "public"."orders" add constraint "orders_zone_id_fkey" FOREIGN KEY (zone_id) REFERENCES public.zones(id) ON DELETE SET NULL not valid;

alter table "public"."orders" validate constraint "orders_zone_id_fkey";

alter table "public"."rider_zones" add constraint "rider_zones_rider_id_fkey" FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON DELETE CASCADE not valid;

alter table "public"."rider_zones" validate constraint "rider_zones_rider_id_fkey";

alter table "public"."rider_zones" add constraint "rider_zones_rider_id_zone_id_key" UNIQUE using index "rider_zones_rider_id_zone_id_key";

alter table "public"."rider_zones" add constraint "rider_zones_zone_id_fkey" FOREIGN KEY (zone_id) REFERENCES public.zones(id) ON DELETE CASCADE not valid;

alter table "public"."rider_zones" validate constraint "rider_zones_zone_id_fkey";

alter table "public"."riders" add constraint "riders_zone_id_fkey" FOREIGN KEY (zone_id) REFERENCES public.zones(id) ON DELETE SET NULL not valid;

alter table "public"."riders" validate constraint "riders_zone_id_fkey";

alter table "public"."stores" add constraint "stores_zone_id_fkey" FOREIGN KEY (zone_id) REFERENCES public.zones(id) ON DELETE SET NULL not valid;

alter table "public"."stores" validate constraint "stores_zone_id_fkey";

alter table "public"."zones" add constraint "zones_code_key" UNIQUE using index "zones_code_key";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.auto_assign_order_zone()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- กำหนดโซนตามร้านค้า
    IF NEW.store_id IS NOT NULL THEN
        SELECT zone_id INTO NEW.zone_id
        FROM public.stores
        WHERE id = NEW.store_id;
    END IF;
    
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.calculate_delivery_fee_v2(p_distance_km double precision, p_subtotal double precision, p_order_time timestamp with time zone, p_zone_id uuid DEFAULT NULL::uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_config RECORD;
    v_tier RECORD;
    v_total_fee DOUBLE PRECISION;
    v_peak_multiplier DOUBLE PRECISION := 1.0;
    v_is_free_delivery BOOLEAN := false;
    v_delivery_fee DOUBLE PRECISION := 0.0;
    v_base_fee DOUBLE PRECISION := 0.0;
BEGIN
    -- 1. Get Configuration (Prioritize Zone-specific -> Default)
    SELECT * INTO v_config
    FROM delivery_fee_config_v2
    WHERE is_active = true
      AND (
          (p_zone_id IS NOT NULL AND zone_id = p_zone_id)
          OR
          (zone_id IS NULL AND is_default = true)
      )
    ORDER BY zone_id NULLS LAST, is_default DESC
    LIMIT 1;

    -- Fallback to global default if still null
    IF v_config IS NULL THEN
        SELECT * INTO v_config
        FROM delivery_fee_config_v2
        WHERE is_active = true AND is_default = true
        LIMIT 1;
    END IF;

    IF v_config IS NULL THEN
        RETURN jsonb_build_object('error', 'No active delivery fee configuration found');
    END IF;

    -- 2. Check for Free Delivery
    IF v_config.free_delivery_threshold IS NOT NULL AND p_subtotal >= v_config.free_delivery_threshold THEN
        v_is_free_delivery := true;
        v_delivery_fee := 0;
    ELSE
        -- 3. Calculate Fee based on Tiers
        -- CHANGED: Using 'delivery_fee_tiers' instead of 'delivery_fee_tiers_v2'
        SELECT * INTO v_tier
        FROM delivery_fee_tiers
        WHERE config_id = v_config.id
          AND p_distance_km >= min_distance
          AND (max_distance IS NULL OR p_distance_km <= max_distance)
        ORDER BY min_distance DESC
        LIMIT 1;

        IF v_tier IS NOT NULL THEN
            -- Found a tier, use its fee
            v_delivery_fee := v_tier.fee;
        ELSE
            -- No tier found, fallback to base fee + distance calculation
            v_base_fee := COALESCE(v_config.base_fee, 0);
            v_delivery_fee := v_base_fee + (p_distance_km * COALESCE(v_config.distance_fee_per_km, 0));
        END IF;
    END IF;

    -- Return result
    RETURN jsonb_build_object(
        'delivery_fee', v_delivery_fee,
        'base_fee', COALESCE(v_config.base_fee, 0),
        'distance_km', p_distance_km,
        'config_name', v_config.name,
        'used_zone_id', v_config.zone_id,
        'is_free_delivery', v_is_free_delivery,
        'free_delivery_threshold', v_config.free_delivery_threshold
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_admin_zone_access(p_admin_id uuid, p_zone_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Super Admin เข้าได้ทุกโซน
    IF EXISTS (
        SELECT 1 FROM public.users 
        WHERE id = p_admin_id 
        AND role = 'admin' 
        AND is_super_admin = true
    ) THEN
        RETURN true;
    END IF;
    
    -- ตรวจสอบว่ามีสิทธิ์ในโซนนี้หรือไม่
    RETURN EXISTS (
        SELECT 1 FROM public.admin_zones
        WHERE admin_id = p_admin_id 
        AND zone_id = p_zone_id
        AND can_view = true
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.create_delivery_fee_setting(setting_name text, setting_description text, base_fee_param double precision, distance_fee_per_km_param double precision, max_delivery_distance_param integer, free_delivery_threshold_param double precision, peak_hour_multiplier_param double precision, peak_hour_start_param text, peak_hour_end_param text, is_default_param boolean, created_by_user_id uuid, zone_id_param uuid DEFAULT NULL::uuid)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
    new_id UUID;
BEGIN
    INSERT INTO delivery_fee_config_v2 (
        name, description, base_fee, distance_fee_per_km, max_delivery_distance,
        free_delivery_threshold, peak_hour_multiplier, peak_hour_start, peak_hour_end,
        is_default, created_by, zone_id
    ) VALUES (
        setting_name, setting_description, base_fee_param, distance_fee_per_km_param, max_delivery_distance_param,
        free_delivery_threshold_param, peak_hour_multiplier_param, peak_hour_start_param, peak_hour_end_param,
        is_default_param, created_by_user_id, zone_id_param
    )
    RETURNING id INTO new_id;
    
    RETURN new_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.find_zone_by_location(p_latitude numeric, p_longitude numeric)
 RETURNS TABLE(zone_id uuid, zone_name text, zone_code text, province text, district text, distance_km numeric)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        z.id AS zone_id,
        z.name AS zone_name,
        z.code AS zone_code,
        z.province,
        z.district,
        ROUND(
            CAST(
                6371 * acos(
                    LEAST(1.0, GREATEST(-1.0,
                        cos(radians(p_latitude)) * 
                        cos(radians(z.center_latitude)) * 
                        cos(radians(z.center_longitude) - radians(p_longitude)) + 
                        sin(radians(p_latitude)) * 
                        sin(radians(z.center_latitude))
                    ))
                ) AS NUMERIC
            ), 2
        ) AS distance_km
    FROM public.zones z
    WHERE z.is_active = true
    AND z.center_latitude IS NOT NULL
    AND z.center_longitude IS NOT NULL
    AND (
        z.radius_km IS NULL OR
        (
            6371 * acos(
                LEAST(1.0, GREATEST(-1.0,
                    cos(radians(p_latitude)) * 
                    cos(radians(z.center_latitude)) * 
                    cos(radians(z.center_longitude) - radians(p_longitude)) + 
                    sin(radians(p_latitude)) * 
                    sin(radians(z.center_latitude))
                ))
            )
        ) <= z.radius_km
    )
    ORDER BY distance_km ASC
    LIMIT 1;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_my_favorite_stores(p_user_id uuid, p_zone_id uuid)
 RETURNS TABLE(id uuid, name text, description text, address text, phone text, email text, opening_hours jsonb, is_active boolean, is_open boolean, is_suspended boolean, suspension_reason text, suspended_by uuid, suspended_at timestamp with time zone, auto_accept_orders boolean, logo_url text, banner_url text, latitude numeric, longitude numeric, delivery_radius integer, minimum_order numeric, delivery_fee numeric, store_type_id uuid, zone_id uuid, distance_km double precision, created_at timestamp with time zone, updated_at timestamp with time zone, is_serviceable boolean)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    WITH user_store_counts AS (
        SELECT 
            store_id, 
            count(*) as order_count
        FROM public.orders
        WHERE customer_id = p_user_id AND status = 'delivered'
        GROUP BY store_id
    )
    SELECT 
        s.id,
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
        0.0::NUMERIC as delivery_fee,
        s.store_type_id,
        s.zone_id,
        0.0::DOUBLE PRECISION as distance_km,
        s.created_at,
        s.updated_at,
        CASE 
            WHEN p_zone_id IS NULL THEN FALSE
            WHEN s.zone_id IS NULL THEN FALSE
            WHEN s.zone_id = p_zone_id THEN TRUE
            ELSE FALSE
        END as is_serviceable
    FROM 
        public.stores s
    JOIN 
        user_store_counts usc ON s.id = usc.store_id
    ORDER BY 
        usc.order_count DESC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_stores_by_distance(user_lat numeric, user_lon numeric, limit_count integer DEFAULT 20, offset_count integer DEFAULT 0, p_zone_id uuid DEFAULT NULL::uuid)
 RETURNS TABLE(id uuid, owner_id uuid, name text, description text, address text, phone text, email text, opening_hours jsonb, is_active boolean, is_open boolean, is_suspended boolean, suspension_reason text, suspended_by uuid, suspended_at timestamp with time zone, auto_accept_orders boolean, logo_url text, banner_url text, latitude numeric, longitude numeric, delivery_radius integer, minimum_order numeric, store_type_id uuid, zone_id uuid, distance_km numeric, created_at timestamp with time zone, updated_at timestamp with time zone)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        s.id,
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
        s.store_type_id,
        s.zone_id,
        -- คำนวณระยะทางจากตำแหน่งผู้ใช้ (Haversine formula)
        ROUND(
            CAST(
                6371 * acos(
                    LEAST(1.0, GREATEST(-1.0,
                        cos(radians(user_lat)) * 
                        cos(radians(s.latitude)) * 
                        cos(radians(s.longitude) - radians(user_lon)) + 
                        sin(radians(user_lat)) * 
                        sin(radians(s.latitude))
                    ))
                ) AS NUMERIC
            ), 2
        ) AS distance_km,
        s.created_at,
        s.updated_at
    FROM public.stores s
    WHERE s.is_active = true
    AND s.latitude IS NOT NULL
    AND s.longitude IS NOT NULL
    -- กรองตามโซน (ถ้ามีการระบุ zone_id)
    AND (p_zone_id IS NULL OR s.zone_id = p_zone_id)
    ORDER BY distance_km ASC
    LIMIT limit_count
    OFFSET offset_count;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_top_riders_by_zone(p_zone_id uuid, p_limit integer DEFAULT 10)
 RETURNS TABLE(rider_id uuid, rider_name text, total_deliveries bigint, completed_deliveries bigint, total_earnings numeric, avg_rating numeric)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        r.id AS rider_id,
        u.full_name AS rider_name,
        COUNT(DISTINCT o.id) AS total_deliveries,
        COUNT(DISTINCT CASE WHEN o.status = 'delivered' THEN o.id END) AS completed_deliveries,
        COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN o.delivery_fee ELSE 0 END), 0) AS total_earnings,
        r.rating AS avg_rating
    FROM public.riders r
    INNER JOIN public.users u ON r.user_id = u.id
    LEFT JOIN public.orders o ON r.id = o.rider_id
    WHERE r.zone_id = p_zone_id
    AND r.is_active = true
    GROUP BY r.id, u.full_name, r.rating
    ORDER BY total_earnings DESC
    LIMIT p_limit;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_top_stores_by_zone(p_zone_id uuid, p_limit integer DEFAULT 10)
 RETURNS TABLE(store_id uuid, store_name text, total_orders bigint, total_revenue numeric, avg_order_value numeric, unique_customers bigint)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        s.id AS store_id,
        s.name AS store_name,
        COUNT(DISTINCT o.id) AS total_orders,
        COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN o.total_amount ELSE 0 END), 0) AS total_revenue,
        COALESCE(AVG(CASE WHEN o.status = 'delivered' THEN o.total_amount END), 0) AS avg_order_value,
        COUNT(DISTINCT o.customer_id) AS unique_customers
    FROM public.stores s
    LEFT JOIN public.orders o ON s.id = o.store_id
    WHERE s.zone_id = p_zone_id
    AND s.is_active = true
    GROUP BY s.id, s.name
    ORDER BY total_revenue DESC
    LIMIT p_limit;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_zone_sales_by_date_range(p_zone_id uuid, p_start_date timestamp with time zone, p_end_date timestamp with time zone)
 RETURNS TABLE(zone_name text, sale_date date, total_orders bigint, completed_orders bigint, cancelled_orders bigint, total_revenue numeric, total_delivery_fee numeric, avg_order_value numeric)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        z.name AS zone_name,
        DATE(o.created_at) AS sale_date,
        COUNT(DISTINCT o.id) AS total_orders,
        COUNT(DISTINCT CASE WHEN o.status = 'delivered' THEN o.id END) AS completed_orders,
        COUNT(DISTINCT CASE WHEN o.status = 'cancelled' THEN o.id END) AS cancelled_orders,
        COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN o.total_amount ELSE 0 END), 0) AS total_revenue,
        COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN o.delivery_fee ELSE 0 END), 0) AS total_delivery_fee,
        COALESCE(AVG(CASE WHEN o.status = 'delivered' THEN o.total_amount END), 0) AS avg_order_value
    FROM public.zones z
    LEFT JOIN public.orders o ON z.id = o.zone_id
    WHERE z.id = p_zone_id
    AND o.created_at BETWEEN p_start_date AND p_end_date
    GROUP BY z.name, DATE(o.created_at)
    ORDER BY sale_date DESC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_zone_summary(p_zone_id uuid, p_start_date timestamp with time zone DEFAULT NULL::timestamp with time zone, p_end_date timestamp with time zone DEFAULT NULL::timestamp with time zone)
 RETURNS TABLE(zone_name text, total_stores bigint, active_stores bigint, total_riders bigint, active_riders bigint, total_orders bigint, completed_orders bigint, cancelled_orders bigint, total_revenue numeric, total_delivery_fee numeric, avg_order_value numeric, unique_customers bigint)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        z.name AS zone_name,
        COUNT(DISTINCT s.id) AS total_stores,
        COUNT(DISTINCT CASE WHEN s.is_active = true THEN s.id END) AS active_stores,
        COUNT(DISTINCT r.id) AS total_riders,
        COUNT(DISTINCT CASE WHEN r.is_active = true THEN r.id END) AS active_riders,
        COUNT(DISTINCT o.id) AS total_orders,
        COUNT(DISTINCT CASE WHEN o.status = 'delivered' THEN o.id END) AS completed_orders,
        COUNT(DISTINCT CASE WHEN o.status = 'cancelled' THEN o.id END) AS cancelled_orders,
        COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN o.total_amount ELSE 0 END), 0) AS total_revenue,
        COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN o.delivery_fee ELSE 0 END), 0) AS total_delivery_fee,
        COALESCE(AVG(CASE WHEN o.status = 'delivered' THEN o.total_amount END), 0) AS avg_order_value,
        COUNT(DISTINCT o.customer_id) AS unique_customers
    FROM public.zones z
    LEFT JOIN public.stores s ON z.id = s.zone_id
    LEFT JOIN public.riders r ON z.id = r.zone_id
    LEFT JOIN public.orders o ON z.id = o.zone_id
        AND (p_start_date IS NULL OR o.created_at >= p_start_date)
        AND (p_end_date IS NULL OR o.created_at <= p_end_date)
    WHERE z.id = p_zone_id
    GROUP BY z.name;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.search_products_by_zone(p_search_query text, p_zone_id uuid, p_limit integer DEFAULT 5)
 RETURNS TABLE(id uuid, store_id uuid, name text, description text, price numeric, original_price numeric, image_url text, category text, is_available boolean, created_at timestamp with time zone, updated_at timestamp with time zone)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        p.id,
        p.store_id,
        p.name,
        p.description,
        p.price,
        p.original_price,
        p.image_url,
        p.category,
        p.is_available,
        p.created_at,
        p.updated_at
    FROM public.products p
    INNER JOIN public.stores s ON p.store_id = s.id
    WHERE p.is_available = true
    AND s.is_active = true
    -- กรองตามโซน
    AND (p_zone_id IS NULL OR s.zone_id = p_zone_id)
    -- ค้นหาจากชื่อสินค้าหรือคำอธิบาย
    AND (
        p.name ILIKE '%' || p_search_query || '%' 
        OR p.description ILIKE '%' || p_search_query || '%'
    )
    -- เรียงลำดับตามชื่อสินค้า
    ORDER BY p.name ASC
    LIMIT p_limit;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.search_stores_by_zone(p_search_query text, p_zone_id uuid, p_user_lat numeric, p_user_lon numeric, p_limit integer DEFAULT 10, p_offset integer DEFAULT 0)
 RETURNS TABLE(id uuid, owner_id uuid, name text, description text, address text, phone text, email text, opening_hours jsonb, is_active boolean, is_open boolean, is_suspended boolean, suspension_reason text, suspended_by uuid, suspended_at timestamp with time zone, auto_accept_orders boolean, logo_url text, banner_url text, latitude numeric, longitude numeric, delivery_radius integer, minimum_order numeric, store_type_id uuid, zone_id uuid, distance_km numeric, created_at timestamp with time zone, updated_at timestamp with time zone)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        s.id,
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
        s.store_type_id,
        s.zone_id,
        -- คำนวณระยะทางจากตำแหน่งผู้ใช้ (Haversine formula)
        CASE 
            WHEN s.latitude IS NOT NULL AND s.longitude IS NOT NULL 
                AND p_user_lat IS NOT NULL AND p_user_lon IS NOT NULL
            THEN ROUND(
                CAST(
                    6371 * acos(
                        LEAST(1.0, GREATEST(-1.0,
                            cos(radians(p_user_lat)) * 
                            cos(radians(s.latitude)) * 
                            cos(radians(s.longitude) - radians(p_user_lon)) + 
                            sin(radians(p_user_lat)) * 
                            sin(radians(s.latitude))
                        ))
                    ) AS NUMERIC
                ), 2
            )
            ELSE NULL
        END AS distance_km,
        s.created_at,
        s.updated_at
    FROM public.stores s
    WHERE s.is_active = true
    -- กรองตามโซน
    AND (p_zone_id IS NULL OR s.zone_id = p_zone_id)
    -- ค้นหาจากชื่อร้านหรือคำอธิบาย
    AND (
        s.name ILIKE '%' || p_search_query || '%' 
        OR s.description ILIKE '%' || p_search_query || '%'
    )
    -- เรียงลำดับ: ร้านที่เปิดอยู่ก่อน แล้วเรียงตามระยะทาง
    ORDER BY 
        s.is_open DESC NULLS LAST,
        distance_km ASC NULLS LAST,
        s.name ASC
    LIMIT p_limit
    OFFSET p_offset;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_delivery_fee_setting(setting_uuid uuid, new_base_fee double precision, new_distance_fee_per_km double precision, new_max_delivery_distance integer, new_free_delivery_threshold double precision, new_peak_hour_multiplier double precision, new_peak_hour_start text, new_peak_hour_end text, updated_by_user_id uuid, reason text DEFAULT NULL::text, new_zone_id uuid DEFAULT NULL::uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE delivery_fee_config_v2
    SET 
        base_fee = new_base_fee,
        distance_fee_per_km = new_distance_fee_per_km,
        max_delivery_distance = new_max_delivery_distance,
        free_delivery_threshold = new_free_delivery_threshold,
        peak_hour_multiplier = new_peak_hour_multiplier,
        peak_hour_start = new_peak_hour_start,
        peak_hour_end = new_peak_hour_end,
        updated_by = updated_by_user_id,
        updated_at = NOW(),
        zone_id = new_zone_id
    WHERE id = setting_uuid;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_zones_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$
;

create or replace view "public"."zone_monthly_revenue" as  SELECT z.id AS zone_id,
    z.name AS zone_name,
    z.code AS zone_code,
    date_trunc('month'::text, o.created_at) AS month,
    count(DISTINCT o.id) AS total_orders,
    count(DISTINCT
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.id
            ELSE NULL::uuid
        END) AS completed_orders,
    COALESCE(sum(
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.total_amount
            ELSE (0)::numeric
        END), (0)::numeric) AS total_revenue,
    COALESCE(sum(
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.delivery_fee
            ELSE (0)::numeric
        END), (0)::numeric) AS total_delivery_fee,
    COALESCE(avg(
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.total_amount
            ELSE NULL::numeric
        END), (0)::numeric) AS avg_order_value,
    count(DISTINCT o.customer_id) AS unique_customers,
    count(DISTINCT o.store_id) AS active_stores
   FROM (public.zones z
     LEFT JOIN public.orders o ON ((z.id = o.zone_id)))
  GROUP BY z.id, z.name, z.code, (date_trunc('month'::text, o.created_at))
  ORDER BY (date_trunc('month'::text, o.created_at)) DESC, z.name;


create or replace view "public"."zone_order_status_report" as  SELECT z.id AS zone_id,
    z.name AS zone_name,
    z.code AS zone_code,
    o.status,
    date(o.created_at) AS order_date,
    count(o.id) AS order_count,
    COALESCE(sum(o.total_amount), (0)::numeric) AS total_amount,
    COALESCE(avg(o.total_amount), (0)::numeric) AS avg_amount
   FROM (public.zones z
     LEFT JOIN public.orders o ON ((z.id = o.zone_id)))
  GROUP BY z.id, z.name, z.code, o.status, (date(o.created_at))
  ORDER BY (date(o.created_at)) DESC, z.name, o.status;


create or replace view "public"."zone_rider_report" as  SELECT z.id AS zone_id,
    z.name AS zone_name,
    z.code AS zone_code,
    r.id AS rider_id,
    u.full_name AS rider_name,
    u.phone AS rider_phone,
    r.vehicle_type,
    r.is_available,
    r.is_active,
    count(DISTINCT o.id) AS total_deliveries,
    count(DISTINCT
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.id
            ELSE NULL::uuid
        END) AS completed_deliveries,
    COALESCE(sum(
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.delivery_fee
            ELSE (0)::numeric
        END), (0)::numeric) AS total_earnings,
    COALESCE(avg(
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.delivery_fee
            ELSE NULL::numeric
        END), (0)::numeric) AS avg_delivery_fee,
    r.rating,
    r.total_ratings,
    r.created_at AS rider_created_at
   FROM (((public.zones z
     JOIN public.riders r ON ((z.id = r.zone_id)))
     JOIN public.users u ON ((r.user_id = u.id)))
     LEFT JOIN public.orders o ON ((r.id = o.rider_id)))
  GROUP BY z.id, z.name, z.code, r.id, u.full_name, u.phone, r.vehicle_type, r.is_available, r.is_active, r.rating, r.total_ratings, r.created_at
  ORDER BY z.name, COALESCE(sum(
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.delivery_fee
            ELSE (0)::numeric
        END), (0)::numeric) DESC;


create or replace view "public"."zone_sales_report" as  SELECT z.id AS zone_id,
    z.name AS zone_name,
    z.code AS zone_code,
    date(o.created_at) AS sale_date,
    count(DISTINCT o.id) AS total_orders,
    count(DISTINCT
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.id
            ELSE NULL::uuid
        END) AS completed_orders,
    count(DISTINCT
        CASE
            WHEN (o.status = 'cancelled'::text) THEN o.id
            ELSE NULL::uuid
        END) AS cancelled_orders,
    COALESCE(sum(
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.total_amount
            ELSE (0)::numeric
        END), (0)::numeric) AS total_revenue,
    COALESCE(sum(
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.delivery_fee
            ELSE (0)::numeric
        END), (0)::numeric) AS total_delivery_fee,
    COALESCE(sum(
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.subtotal
            ELSE (0)::numeric
        END), (0)::numeric) AS total_subtotal,
    COALESCE(avg(
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.total_amount
            ELSE NULL::numeric
        END), (0)::numeric) AS avg_order_value,
    count(DISTINCT o.customer_id) AS unique_customers,
    count(DISTINCT o.store_id) AS active_stores,
    count(DISTINCT o.rider_id) AS active_riders
   FROM (public.zones z
     LEFT JOIN public.orders o ON ((z.id = o.zone_id)))
  GROUP BY z.id, z.name, z.code, (date(o.created_at))
  ORDER BY (date(o.created_at)) DESC, z.name;


create or replace view "public"."zone_statistics" as  SELECT z.id AS zone_id,
    z.name AS zone_name,
    z.code AS zone_code,
    z.province,
    z.district,
    count(DISTINCT s.id) AS total_stores,
    count(DISTINCT r.id) AS total_riders,
    count(DISTINCT o.id) AS total_orders,
    count(DISTINCT
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.id
            ELSE NULL::uuid
        END) AS delivered_orders,
    COALESCE(sum(
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.total_amount
            ELSE (0)::numeric
        END), (0)::numeric) AS total_revenue,
    count(DISTINCT az.admin_id) AS total_admins,
    z.is_active,
    z.created_at
   FROM ((((public.zones z
     LEFT JOIN public.stores s ON (((z.id = s.zone_id) AND (s.is_active = true))))
     LEFT JOIN public.riders r ON (((z.id = r.zone_id) AND (r.is_active = true))))
     LEFT JOIN public.orders o ON ((z.id = o.zone_id)))
     LEFT JOIN public.admin_zones az ON ((z.id = az.zone_id)))
  WHERE (z.is_active = true)
  GROUP BY z.id, z.name, z.code, z.province, z.district, z.is_active, z.created_at
  ORDER BY z.name;


create or replace view "public"."zone_store_report" as  SELECT z.id AS zone_id,
    z.name AS zone_name,
    z.code AS zone_code,
    s.id AS store_id,
    s.name AS store_name,
    s.is_active,
    s.is_open,
    count(DISTINCT o.id) AS total_orders,
    count(DISTINCT
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.id
            ELSE NULL::uuid
        END) AS completed_orders,
    COALESCE(sum(
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.total_amount
            ELSE (0)::numeric
        END), (0)::numeric) AS total_revenue,
    COALESCE(avg(
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.total_amount
            ELSE NULL::numeric
        END), (0)::numeric) AS avg_order_value,
    count(DISTINCT o.customer_id) AS unique_customers,
    s.created_at AS store_created_at
   FROM ((public.zones z
     JOIN public.stores s ON ((z.id = s.zone_id)))
     LEFT JOIN public.orders o ON ((s.id = o.store_id)))
  GROUP BY z.id, z.name, z.code, s.id, s.name, s.is_active, s.is_open, s.created_at
  ORDER BY z.name, COALESCE(sum(
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.total_amount
            ELSE (0)::numeric
        END), (0)::numeric) DESC;


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
    o.zone_id,
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
    r.zone_id,
    r.can_work_multiple_zones,
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
  WHERE ((r.is_available = true) AND (r.documents_verified = true) AND (NOT (EXISTS ( SELECT 1
           FROM public.rider_assignments ra
          WHERE ((ra.rider_id = r.id) AND (ra.status = ANY (ARRAY['assigned'::text, 'picked_up'::text, 'delivering'::text])))))))
  ORDER BY r.rating DESC, r.total_deliveries DESC;


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
    o.zone_id,
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
    o.payment_method,
    o.payment_status,
    o.special_instructions,
    o.zone_id,
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
   FROM (((public.rider_assignments ra
     JOIN public.orders o ON ((ra.order_id = o.id)))
     JOIN public.stores s ON ((o.store_id = s.id)))
     JOIN public.users u ON ((o.customer_id = u.id)))
  WHERE (ra.status = ANY (ARRAY['assigned'::text, 'picked_up'::text, 'delivering'::text]))
  ORDER BY ra.assigned_at DESC;


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
    r.zone_id,
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


CREATE OR REPLACE FUNCTION public.sync_store_active_orders()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  -- ถ้าเป็น INSERT หรือ UPDATE เป็น active status
  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') AND 
     NEW.status IN ('pending', 'accepted', 'preparing', 'ready', 'assigned', 'picked_up', 'delivering') THEN
    
    INSERT INTO store_active_orders (
      id, order_number, customer_id, store_id, rider_id, status,
      total_amount, subtotal, delivery_fee, calculated_delivery_fee,
      distance_km, tax_amount, discount_amount, delivery_address,
      delivery_latitude, delivery_longitude, delivery_line_id,
      estimated_delivery_time, actual_delivery_time, payment_method,
      payment_status, bank_account_number, bank_account_name, qr_code_url,
      transfer_amount, transfer_reference, transfer_slip_url,
      transfer_confirmed_at, transfer_confirmed_by, special_instructions,
      created_at, updated_at, bank_name, cancellation_reason,
      cancelled_by, cancelled_at, customer_name, customer_phone,
      customer_email, customer_line_id, discount_code_id, discount_code,
      discount_description, rider_latitude, rider_longitude,
      rider_location_captured_at, last_notification_sent_at,
      notification_retry_count,
      zone_id  -- เพิ่มฟิลด์ zone_id
    )
    VALUES (
      NEW.id, NEW.order_number, NEW.customer_id, NEW.store_id, NEW.rider_id,
      NEW.status, NEW.total_amount, NEW.subtotal, NEW.delivery_fee,
      NEW.calculated_delivery_fee, NEW.distance_km, NEW.tax_amount,
      NEW.discount_amount, NEW.delivery_address, NEW.delivery_latitude,
      NEW.delivery_longitude, NEW.delivery_line_id, NEW.estimated_delivery_time,
      NEW.actual_delivery_time, NEW.payment_method, NEW.payment_status,
      NEW.bank_account_number, NEW.bank_account_name, NEW.qr_code_url,
      NEW.transfer_amount, NEW.transfer_reference, NEW.transfer_slip_url,
      NEW.transfer_confirmed_at, NEW.transfer_confirmed_by, NEW.special_instructions,
      NEW.created_at, NEW.updated_at, NEW.bank_name, NEW.cancellation_reason,
      NEW.cancelled_by, NEW.cancelled_at, NEW.customer_name, NEW.customer_phone,
      NEW.customer_email, NEW.customer_line_id, NEW.discount_code_id,
      NEW.discount_code, NEW.discount_description, NEW.rider_latitude,
      NEW.rider_longitude, NEW.rider_location_captured_at,
      NEW.last_notification_sent_at, NEW.notification_retry_count,
      NEW.zone_id  -- เพิ่มค่า zone_id
    )
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
      discount_code = NEW.discount_code,
      rider_latitude = NEW.rider_latitude,
      rider_longitude = NEW.rider_longitude,
      rider_location_captured_at = NEW.rider_location_captured_at,
      last_notification_sent_at = NEW.last_notification_sent_at,
      notification_retry_count = NEW.notification_retry_count,
      zone_id = NEW.zone_id;  -- อัพเดท zone_id
    
  -- ถ้าเป็น UPDATE เป็น inactive status หรือ DELETE
  ELSIF (TG_OP = 'UPDATE' AND NEW.status IN ('delivered', 'cancelled', 'rejected')) OR 
        TG_OP = 'DELETE' THEN
    DELETE FROM store_active_orders WHERE id = COALESCE(NEW.id, OLD.id);
  END IF;
  
  RETURN NEW;
END;
$function$
;

create or replace view "public"."v_daily_best_selling_stores" as  SELECT s.id,
    s.name,
    s.logo_url,
    s.banner_url,
    s.zone_id,
    count(o.id) AS daily_order_count,
    COALESCE(sum(
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.total_amount
            ELSE (0)::numeric
        END), (0)::numeric) AS daily_total_sales
   FROM (public.stores s
     LEFT JOIN public.orders o ON (((s.id = o.store_id) AND (o.created_at >= CURRENT_DATE))))
  WHERE (s.is_active = true)
  GROUP BY s.id, s.name, s.logo_url, s.banner_url, s.zone_id
 HAVING (count(o.id) > 0)
  ORDER BY COALESCE(sum(
        CASE
            WHEN (o.status = 'delivered'::text) THEN o.total_amount
            ELSE (0)::numeric
        END), (0)::numeric) DESC, (count(o.id)) DESC;


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
    store_type_id,
    zone_id,
    created_at,
    updated_at
   FROM public.stores
  WHERE ((is_active = true) AND (created_at >= (CURRENT_DATE - '7 days'::interval)))
  ORDER BY created_at DESC;


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
    store_type_id,
    zone_id,
    created_at,
    updated_at
   FROM public.stores
  WHERE ((is_active = true) AND ((minimum_order IS NULL) OR (minimum_order < (50)::numeric)))
  ORDER BY created_at DESC;


grant delete on table "public"."admin_zones" to "anon";

grant insert on table "public"."admin_zones" to "anon";

grant references on table "public"."admin_zones" to "anon";

grant select on table "public"."admin_zones" to "anon";

grant trigger on table "public"."admin_zones" to "anon";

grant truncate on table "public"."admin_zones" to "anon";

grant update on table "public"."admin_zones" to "anon";

grant delete on table "public"."admin_zones" to "authenticated";

grant insert on table "public"."admin_zones" to "authenticated";

grant references on table "public"."admin_zones" to "authenticated";

grant select on table "public"."admin_zones" to "authenticated";

grant trigger on table "public"."admin_zones" to "authenticated";

grant truncate on table "public"."admin_zones" to "authenticated";

grant update on table "public"."admin_zones" to "authenticated";

grant delete on table "public"."admin_zones" to "service_role";

grant insert on table "public"."admin_zones" to "service_role";

grant references on table "public"."admin_zones" to "service_role";

grant select on table "public"."admin_zones" to "service_role";

grant trigger on table "public"."admin_zones" to "service_role";

grant truncate on table "public"."admin_zones" to "service_role";

grant update on table "public"."admin_zones" to "service_role";

grant delete on table "public"."rider_zones" to "anon";

grant insert on table "public"."rider_zones" to "anon";

grant references on table "public"."rider_zones" to "anon";

grant select on table "public"."rider_zones" to "anon";

grant trigger on table "public"."rider_zones" to "anon";

grant truncate on table "public"."rider_zones" to "anon";

grant update on table "public"."rider_zones" to "anon";

grant delete on table "public"."rider_zones" to "authenticated";

grant insert on table "public"."rider_zones" to "authenticated";

grant references on table "public"."rider_zones" to "authenticated";

grant select on table "public"."rider_zones" to "authenticated";

grant trigger on table "public"."rider_zones" to "authenticated";

grant truncate on table "public"."rider_zones" to "authenticated";

grant update on table "public"."rider_zones" to "authenticated";

grant delete on table "public"."rider_zones" to "service_role";

grant insert on table "public"."rider_zones" to "service_role";

grant references on table "public"."rider_zones" to "service_role";

grant select on table "public"."rider_zones" to "service_role";

grant trigger on table "public"."rider_zones" to "service_role";

grant truncate on table "public"."rider_zones" to "service_role";

grant update on table "public"."rider_zones" to "service_role";

grant delete on table "public"."zones" to "anon";

grant insert on table "public"."zones" to "anon";

grant references on table "public"."zones" to "anon";

grant select on table "public"."zones" to "anon";

grant trigger on table "public"."zones" to "anon";

grant truncate on table "public"."zones" to "anon";

grant update on table "public"."zones" to "anon";

grant delete on table "public"."zones" to "authenticated";

grant insert on table "public"."zones" to "authenticated";

grant references on table "public"."zones" to "authenticated";

grant select on table "public"."zones" to "authenticated";

grant trigger on table "public"."zones" to "authenticated";

grant truncate on table "public"."zones" to "authenticated";

grant update on table "public"."zones" to "authenticated";

grant delete on table "public"."zones" to "service_role";

grant insert on table "public"."zones" to "service_role";

grant references on table "public"."zones" to "service_role";

grant select on table "public"."zones" to "service_role";

grant trigger on table "public"."zones" to "service_role";

grant truncate on table "public"."zones" to "service_role";

grant update on table "public"."zones" to "service_role";

CREATE TRIGGER trigger_auto_assign_order_zone BEFORE INSERT ON public.orders FOR EACH ROW EXECUTE FUNCTION public.auto_assign_order_zone();

CREATE TRIGGER trigger_update_zones_updated_at BEFORE UPDATE ON public.zones FOR EACH ROW EXECUTE FUNCTION public.update_zones_updated_at();

CREATE TRIGGER sync_store_active_orders_trigger AFTER INSERT OR DELETE OR UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.sync_store_active_orders();





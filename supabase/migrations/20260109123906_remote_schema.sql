create extension if not exists "http" with schema "extensions";

drop trigger if exists "trigger_update_customer_data_in_orders" on "public"."users";

drop policy "Customers can view own orders" on "public"."orders";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_daily_sales_stats_v2(filter_zone_id uuid DEFAULT NULL::uuid)
 RETURNS TABLE(sale_date date, daily_revenue numeric, order_count bigint)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        (created_at AT TIME ZONE 'Asia/Bangkok')::date AS sale_date,
        COALESCE(sum(total_amount), 0) AS daily_revenue,
        count(id) AS order_count
    FROM public.orders
    WHERE status != 'cancelled'
    AND (filter_zone_id IS NULL OR zone_id = filter_zone_id)
    GROUP BY 1
    ORDER BY 1 DESC
    LIMIT 30;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_dashboard_summary_v2(filter_zone_id uuid DEFAULT NULL::uuid)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    result json;
BEGIN
    SELECT json_build_object(
        'total_orders', count(id),
        'total_revenue', COALESCE(sum(total_amount), 0),
        'completed_orders', count(id) FILTER (WHERE status IN ('delivered', 'completed')),
        'cancelled_orders', count(id) FILTER (WHERE status = 'cancelled'),
        'active_stores', (
            SELECT count(*) 
            FROM public.stores s 
            WHERE (s.is_active = true OR s.is_active IS NULL) 
            AND (s.is_suspended = false OR s.is_suspended IS NULL)
            AND (filter_zone_id IS NULL OR s.zone_id = filter_zone_id)
        )
    ) INTO result
    FROM public.orders o
    WHERE (filter_zone_id IS NULL OR o.zone_id = filter_zone_id);

    RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_monthly_sales_stats_v2(filter_zone_id uuid DEFAULT NULL::uuid)
 RETURNS TABLE(month_start date, monthly_revenue numeric, order_count bigint)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        date_trunc('month', created_at AT TIME ZONE 'Asia/Bangkok')::date AS month_start,
        COALESCE(sum(total_amount), 0) AS monthly_revenue,
        count(id) AS order_count
    FROM public.orders
    WHERE status != 'cancelled'
    AND (filter_zone_id IS NULL OR zone_id = filter_zone_id)
    GROUP BY 1
    ORDER BY 1 DESC
    LIMIT 12;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_today_order_stats_v2(filter_zone_id uuid DEFAULT NULL::uuid)
 RETURNS TABLE(status text, order_count bigint, store_names text)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        o.status,
        count(o.id) as order_count,
        string_agg(DISTINCT s.name, ', ' ORDER BY s.name) as store_names
    FROM public.orders o
    LEFT JOIN public.stores s ON s.id = o.store_id
    WHERE (o.created_at AT TIME ZONE 'Asia/Bangkok')::date = (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Bangkok')::date
    AND (filter_zone_id IS NULL OR o.zone_id = filter_zone_id)
    GROUP BY o.status
    ORDER BY order_count DESC;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_yearly_sales_stats_v2(filter_zone_id uuid DEFAULT NULL::uuid)
 RETURNS TABLE(year numeric, store_id uuid, store_name text, yearly_revenue numeric, total_orders bigint)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        EXTRACT(year FROM (o.created_at AT TIME ZONE 'Asia/Bangkok'))::numeric AS year,
        o.store_id,
        s.name AS store_name,
        COALESCE(sum(
            CASE
                WHEN o.status != 'cancelled' THEN o.subtotal
                ELSE 0
            END), 0) AS yearly_revenue,
        count(o.id) AS total_orders
    FROM public.orders o
    LEFT JOIN public.stores s ON s.id = o.store_id
    WHERE o.created_at IS NOT NULL
    AND (filter_zone_id IS NULL OR o.zone_id = filter_zone_id)
    GROUP BY 1, o.store_id, s.name
    ORDER BY yearly_revenue DESC;
END;
$function$
;

create or replace view "public"."order_status_statistics_today_zone" as  SELECT o.zone_id,
    o.status,
    count(o.id) AS order_count,
    string_agg(DISTINCT s.name, ', '::text ORDER BY s.name) AS store_names
   FROM (public.orders o
     LEFT JOIN public.stores s ON ((s.id = o.store_id)))
  WHERE (((o.created_at AT TIME ZONE 'Asia/Bangkok'::text))::date = ((CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Bangkok'::text))::date)
  GROUP BY o.zone_id, o.status;


CREATE OR REPLACE FUNCTION public.update_customer_data_in_orders()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
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


  create policy "Admins can view logs"
  on "public"."admin_activity_logs"
  as permissive
  for select
  to public
using ((auth.uid() IN ( SELECT users.id
   FROM public.users
  WHERE (users.role = 'admin'::text))));



  create policy "Allow insert for all users"
  on "public"."admin_activity_logs"
  as permissive
  for insert
  to public
with check (true);



  create policy "Admins can update orders"
  on "public"."orders"
  as permissive
  for update
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND ((users.role = 'admin'::text) OR (users.is_super_admin = true))))));



  create policy "Admins can view all orders"
  on "public"."orders"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND ((users.role = 'admin'::text) OR (users.is_super_admin = true))))));



  create policy "Riders can view assigned orders"
  on "public"."orders"
  as permissive
  for select
  to public
using (((rider_id IS NOT NULL) AND (EXISTS ( SELECT 1
   FROM public.riders
  WHERE ((riders.id = orders.rider_id) AND (riders.user_id = auth.uid()))))));



  create policy "Riders can view available and assigned orders"
  on "public"."orders"
  as permissive
  for select
  to public
using (((auth.uid() IN ( SELECT riders.user_id
   FROM public.riders)) AND ((status = 'ready'::text) OR (rider_id IN ( SELECT riders.id
   FROM public.riders
  WHERE (riders.user_id = auth.uid()))))));



  create policy "Store owners can view their store orders"
  on "public"."orders"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.stores
  WHERE ((stores.id = orders.store_id) AND (stores.owner_id = auth.uid())))));



  create policy "Customers can view own orders"
  on "public"."orders"
  as permissive
  for select
  to public
using ((auth.uid() = customer_id));


CREATE TRIGGER trigger_update_customer_data_in_orders AFTER UPDATE OF full_name, phone, email, line_id ON public.users FOR EACH ROW WHEN (((old.full_name IS DISTINCT FROM new.full_name) OR (old.phone IS DISTINCT FROM new.phone) OR (old.email IS DISTINCT FROM new.email) OR (old.line_id IS DISTINCT FROM new.line_id))) EXECUTE FUNCTION public.update_customer_data_in_orders();



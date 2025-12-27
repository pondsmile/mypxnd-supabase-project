-- ============================================
-- Update Views: เพิ่ม zone_id ให้กับ Daily Store Views
-- ============================================
-- อัปเดต views ให้รวมฟิลด์ zone_id เพื่อให้สามารถกรองตามโซนได้

-- 1. อัปเดต v_daily_new_stores
DROP VIEW IF EXISTS public.v_daily_new_stores CASCADE;

CREATE VIEW public.v_daily_new_stores AS
SELECT 
    id,
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
    zone_id,  -- เพิ่มฟิลด์ zone_id
    created_at,
    updated_at
FROM public.stores
WHERE is_active = true
AND created_at >= CURRENT_DATE - INTERVAL '7 days'  -- ร้านที่สร้างภายใน 7 วันที่ผ่านมา
ORDER BY created_at DESC;

-- 2. อัปเดต v_daily_small_stores
DROP VIEW IF EXISTS public.v_daily_small_stores CASCADE;

CREATE VIEW public.v_daily_small_stores AS
SELECT 
    id,
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
    zone_id,  -- เพิ่มฟิลด์ zone_id
    created_at,
    updated_at
FROM public.stores
WHERE is_active = true
-- เงื่อนไขสำหรับ "ร้านเล็ก" - สามารถปรับแต่งได้ตามต้องการ
-- ตัวอย่าง: ร้านที่มี minimum_order น้อยกว่า 50 บาท หรือไม่มีกำหนด
AND (minimum_order IS NULL OR minimum_order < 50)
ORDER BY created_at DESC;

-- 3. อัปเดต v_daily_best_selling_stores
DROP VIEW IF EXISTS public.v_daily_best_selling_stores CASCADE;

CREATE VIEW public.v_daily_best_selling_stores AS
SELECT 
    s.id,
    s.name,
    s.logo_url,
    s.banner_url,
    s.zone_id,  -- เพิ่มฟิลด์ zone_id
    COUNT(o.id) AS daily_order_count,
    COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN o.total_amount ELSE 0 END), 0) AS daily_total_sales
FROM public.stores s
LEFT JOIN public.orders o ON s.id = o.store_id 
    AND o.created_at >= CURRENT_DATE  -- ออเดอร์วันนี้
WHERE s.is_active = true
GROUP BY s.id, s.name, s.logo_url, s.banner_url, s.zone_id
HAVING COUNT(o.id) > 0  -- มีออเดอร์อย่างน้อย 1 รายการ
ORDER BY daily_total_sales DESC, daily_order_count DESC;

-- Grant permissions
GRANT SELECT ON public.v_daily_new_stores TO authenticated;
GRANT SELECT ON public.v_daily_new_stores TO anon;

GRANT SELECT ON public.v_daily_small_stores TO authenticated;
GRANT SELECT ON public.v_daily_small_stores TO anon;

GRANT SELECT ON public.v_daily_best_selling_stores TO authenticated;
GRANT SELECT ON public.v_daily_best_selling_stores TO anon;

-- ============================================
-- Verify Views
-- ============================================
-- ตรวจสอบว่า views ถูกสร้างเรียบร้อยแล้ว

-- ดู structure ของ v_daily_new_stores
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'v_daily_new_stores' 
ORDER BY ordinal_position;

-- ทดสอบดึงข้อมูลจาก views (กรองตามโซน)
-- SELECT * FROM v_daily_new_stores WHERE zone_id = 'your-zone-id-here';
-- SELECT * FROM v_daily_small_stores WHERE zone_id = 'your-zone-id-here';
-- SELECT * FROM v_daily_best_selling_stores WHERE zone_id = 'your-zone-id-here';

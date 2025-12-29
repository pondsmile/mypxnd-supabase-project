-- ============================================
-- Migration: Add Zone-Based Reporting Views and Functions
-- Description: เพิ่ม Views และ Functions สำหรับรายงานแยกตามโซน
-- Date: 2025-12-27
-- ============================================

-- ============================================
-- 1. View: รายงานยอดขายตามโซน (Sales Report by Zone)
-- ============================================
CREATE OR REPLACE VIEW public.zone_sales_report AS
SELECT 
    z.id AS zone_id,
    z.name AS zone_name,
    z.code AS zone_code,
    DATE(o.created_at) AS sale_date,
    COUNT(DISTINCT o.id) AS total_orders,
    COUNT(DISTINCT CASE WHEN o.status = 'delivered' THEN o.id END) AS completed_orders,
    COUNT(DISTINCT CASE WHEN o.status = 'cancelled' THEN o.id END) AS cancelled_orders,
    COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN o.total_amount ELSE 0 END), 0) AS total_revenue,
    COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN o.delivery_fee ELSE 0 END), 0) AS total_delivery_fee,
    COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN o.subtotal ELSE 0 END), 0) AS total_subtotal,
    COALESCE(AVG(CASE WHEN o.status = 'delivered' THEN o.total_amount END), 0) AS avg_order_value,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    COUNT(DISTINCT o.store_id) AS active_stores,
    COUNT(DISTINCT o.rider_id) AS active_riders
FROM public.zones z
LEFT JOIN public.orders o ON z.id = o.zone_id
GROUP BY z.id, z.name, z.code, DATE(o.created_at)
ORDER BY sale_date DESC, z.name;

COMMENT ON VIEW public.zone_sales_report IS 'รายงานยอดขายรายวันแยกตามโซน';

-- ============================================
-- 2. View: รายงานร้านค้าตามโซน (Store Report by Zone)
-- ============================================
CREATE OR REPLACE VIEW public.zone_store_report AS
SELECT 
    z.id AS zone_id,
    z.name AS zone_name,
    z.code AS zone_code,
    s.id AS store_id,
    s.name AS store_name,
    s.is_active,
    s.is_open,
    COUNT(DISTINCT o.id) AS total_orders,
    COUNT(DISTINCT CASE WHEN o.status = 'delivered' THEN o.id END) AS completed_orders,
    COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN o.total_amount ELSE 0 END), 0) AS total_revenue,
    COALESCE(AVG(CASE WHEN o.status = 'delivered' THEN o.total_amount END), 0) AS avg_order_value,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    s.created_at AS store_created_at
FROM public.zones z
INNER JOIN public.stores s ON z.id = s.zone_id
LEFT JOIN public.orders o ON s.id = o.store_id
GROUP BY z.id, z.name, z.code, s.id, s.name, s.is_active, s.is_open, s.created_at
ORDER BY z.name, total_revenue DESC;

COMMENT ON VIEW public.zone_store_report IS 'รายงานร้านค้าแยกตามโซน';

-- ============================================
-- 3. View: รายงานไรเดอร์ตามโซน (Rider Report by Zone)
-- ============================================
CREATE OR REPLACE VIEW public.zone_rider_report AS
SELECT 
    z.id AS zone_id,
    z.name AS zone_name,
    z.code AS zone_code,
    r.id AS rider_id,
    u.full_name AS rider_name,
    u.phone AS rider_phone,
    r.vehicle_type,
    r.is_available,
    r.is_active,
    COUNT(DISTINCT o.id) AS total_deliveries,
    COUNT(DISTINCT CASE WHEN o.status = 'delivered' THEN o.id END) AS completed_deliveries,
    COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN o.delivery_fee ELSE 0 END), 0) AS total_earnings,
    COALESCE(AVG(CASE WHEN o.status = 'delivered' THEN o.delivery_fee END), 0) AS avg_delivery_fee,
    r.rating,
    r.total_ratings,
    r.created_at AS rider_created_at
FROM public.zones z
INNER JOIN public.riders r ON z.id = r.zone_id
INNER JOIN public.users u ON r.user_id = u.id
LEFT JOIN public.orders o ON r.id = o.rider_id
GROUP BY z.id, z.name, z.code, r.id, u.full_name, u.phone, r.vehicle_type, r.is_available, r.is_active, r.rating, r.total_ratings, r.created_at
ORDER BY z.name, total_earnings DESC;

COMMENT ON VIEW public.zone_rider_report IS 'รายงานไรเดอร์แยกตามโซน';

-- ============================================
-- 4. View: รายงานออเดอร์ตามโซนและสถานะ (Order Status Report by Zone)
-- ============================================
CREATE OR REPLACE VIEW public.zone_order_status_report AS
SELECT 
    z.id AS zone_id,
    z.name AS zone_name,
    z.code AS zone_code,
    o.status,
    DATE(o.created_at) AS order_date,
    COUNT(o.id) AS order_count,
    COALESCE(SUM(o.total_amount), 0) AS total_amount,
    COALESCE(AVG(o.total_amount), 0) AS avg_amount
FROM public.zones z
LEFT JOIN public.orders o ON z.id = o.zone_id
GROUP BY z.id, z.name, z.code, o.status, DATE(o.created_at)
ORDER BY order_date DESC, z.name, o.status;

COMMENT ON VIEW public.zone_order_status_report IS 'รายงานสถานะออเดอร์แยกตามโซน';

-- ============================================
-- 5. View: รายงานรายได้รายเดือนตามโซน (Monthly Revenue by Zone)
-- ============================================
CREATE OR REPLACE VIEW public.zone_monthly_revenue AS
SELECT 
    z.id AS zone_id,
    z.name AS zone_name,
    z.code AS zone_code,
    DATE_TRUNC('month', o.created_at) AS month,
    COUNT(DISTINCT o.id) AS total_orders,
    COUNT(DISTINCT CASE WHEN o.status = 'delivered' THEN o.id END) AS completed_orders,
    COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN o.total_amount ELSE 0 END), 0) AS total_revenue,
    COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN o.delivery_fee ELSE 0 END), 0) AS total_delivery_fee,
    COALESCE(AVG(CASE WHEN o.status = 'delivered' THEN o.total_amount END), 0) AS avg_order_value,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    COUNT(DISTINCT o.store_id) AS active_stores
FROM public.zones z
LEFT JOIN public.orders o ON z.id = o.zone_id
GROUP BY z.id, z.name, z.code, DATE_TRUNC('month', o.created_at)
ORDER BY month DESC, z.name;

COMMENT ON VIEW public.zone_monthly_revenue IS 'รายงานรายได้รายเดือนแยกตามโซน';

-- ============================================
-- 6. Function: รายงานยอดขายตามช่วงเวลาและโซน
-- ============================================
CREATE OR REPLACE FUNCTION public.get_zone_sales_by_date_range(
    p_zone_id UUID,
    p_start_date TIMESTAMP WITH TIME ZONE,
    p_end_date TIMESTAMP WITH TIME ZONE
)
RETURNS TABLE (
    zone_name TEXT,
    sale_date DATE,
    total_orders BIGINT,
    completed_orders BIGINT,
    cancelled_orders BIGINT,
    total_revenue NUMERIC,
    total_delivery_fee NUMERIC,
    avg_order_value NUMERIC
) AS $$
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
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.get_zone_sales_by_date_range(UUID, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) 
IS 'ดึงรายงานยอดขายตามช่วงเวลาและโซน';

-- ============================================
-- 7. Function: รายงานร้านค้ายอดนิยมในโซน
-- ============================================
CREATE OR REPLACE FUNCTION public.get_top_stores_by_zone(
    p_zone_id UUID,
    p_limit INTEGER DEFAULT 10
)
RETURNS TABLE (
    store_id UUID,
    store_name TEXT,
    total_orders BIGINT,
    total_revenue NUMERIC,
    avg_order_value NUMERIC,
    unique_customers BIGINT
) AS $$
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
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.get_top_stores_by_zone(UUID, INTEGER) 
IS 'ดึงร้านค้ายอดนิยมในโซน (เรียงตามรายได้)';

-- ============================================
-- 8. Function: รายงานไรเดอร์ยอดนิยมในโซน
-- ============================================
CREATE OR REPLACE FUNCTION public.get_top_riders_by_zone(
    p_zone_id UUID,
    p_limit INTEGER DEFAULT 10
)
RETURNS TABLE (
    rider_id UUID,
    rider_name TEXT,
    total_deliveries BIGINT,
    completed_deliveries BIGINT,
    total_earnings NUMERIC,
    avg_rating NUMERIC
) AS $$
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
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.get_top_riders_by_zone(UUID, INTEGER) 
IS 'ดึงไรเดอร์ยอดนิยมในโซน (เรียงตามรายได้)';

-- ============================================
-- 9. Function: สรุปรายงานโซนแบบครบถ้วน
-- ============================================
CREATE OR REPLACE FUNCTION public.get_zone_summary(
    p_zone_id UUID,
    p_start_date TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    p_end_date TIMESTAMP WITH TIME ZONE DEFAULT NULL
)
RETURNS TABLE (
    zone_name TEXT,
    total_stores BIGINT,
    active_stores BIGINT,
    total_riders BIGINT,
    active_riders BIGINT,
    total_orders BIGINT,
    completed_orders BIGINT,
    cancelled_orders BIGINT,
    total_revenue NUMERIC,
    total_delivery_fee NUMERIC,
    avg_order_value NUMERIC,
    unique_customers BIGINT
) AS $$
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
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.get_zone_summary(UUID, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) 
IS 'สรุปรายงานโซนแบบครบถ้วน (สามารถระบุช่วงเวลาได้)';

-- ============================================
-- 10. Grant Permissions
-- ============================================
GRANT SELECT ON public.zone_sales_report TO authenticated;
GRANT SELECT ON public.zone_store_report TO authenticated;
GRANT SELECT ON public.zone_rider_report TO authenticated;
GRANT SELECT ON public.zone_order_status_report TO authenticated;
GRANT SELECT ON public.zone_monthly_revenue TO authenticated;

GRANT EXECUTE ON FUNCTION public.get_zone_sales_by_date_range(UUID, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_top_stores_by_zone(UUID, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_top_riders_by_zone(UUID, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_zone_summary(UUID, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) TO authenticated;

-- ============================================
-- Migration Complete
-- ============================================
-- สรุป:
-- ✅ สร้าง 5 Views สำหรับรายงานแยกตามโซน
-- ✅ สร้าง 4 Functions สำหรับดึงรายงานแบบกำหนดเอง
-- ✅ รองรับการกรองตามช่วงเวลา
-- ✅ รองรับการจัดอันดับร้านค้าและไรเดอร์
-- 
-- Views ที่สร้าง:
-- 1. zone_sales_report - รายงานยอดขายรายวัน
-- 2. zone_store_report - รายงานร้านค้า
-- 3. zone_rider_report - รายงานไรเดอร์
-- 4. zone_order_status_report - รายงานสถานะออเดอร์
-- 5. zone_monthly_revenue - รายงานรายได้รายเดือน
-- 
-- Functions ที่สร้าง:
-- 1. get_zone_sales_by_date_range() - ยอดขายตามช่วงเวลา
-- 2. get_top_stores_by_zone() - ร้านค้ายอดนิยม
-- 3. get_top_riders_by_zone() - ไรเดอร์ยอดนิยม
-- 4. get_zone_summary() - สรุปรายงานครบถ้วน

-- ============================================
-- Function: ดึงร้านค้าตามระยะทางและโซน
-- ============================================
-- ฟังก์ชันนี้ใช้สำหรับดึงร้านค้าโดยเรียงตามระยะทางจากตำแหน่งผู้ใช้
-- และสามารถกรองตามโซนได้ (optional)

CREATE OR REPLACE FUNCTION public.get_stores_by_distance(
    user_lat NUMERIC,
    user_lon NUMERIC,
    limit_count INTEGER DEFAULT 20,
    offset_count INTEGER DEFAULT 0,
    p_zone_id UUID DEFAULT NULL
)
RETURNS TABLE (
    id UUID,
    owner_id UUID,
    name TEXT,
    description TEXT,
    address TEXT,
    phone TEXT,
    email TEXT,
    opening_hours TEXT,
    is_active BOOLEAN,
    is_open BOOLEAN,
    is_suspended BOOLEAN,
    suspension_reason TEXT,
    suspended_by UUID,
    suspended_at TIMESTAMP WITH TIME ZONE,
    auto_accept_orders BOOLEAN,
    logo_url TEXT,
    banner_url TEXT,
    latitude NUMERIC,
    longitude NUMERIC,
    delivery_radius INTEGER,
    minimum_order NUMERIC,
    delivery_fee NUMERIC,
    store_type_id UUID,
    zone_id UUID,
    distance_km NUMERIC,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
) AS $$
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
        s.delivery_fee,
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
$$ LANGUAGE plpgsql;

-- Grant permissions
GRANT EXECUTE ON FUNCTION public.get_stores_by_distance(NUMERIC, NUMERIC, INTEGER, INTEGER, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_stores_by_distance(NUMERIC, NUMERIC, INTEGER, INTEGER, UUID) TO anon;

COMMENT ON FUNCTION public.get_stores_by_distance(NUMERIC, NUMERIC, INTEGER, INTEGER, UUID) IS 
'ดึงร้านค้าโดยเรียงตามระยะทางจากตำแหน่งผู้ใช้ และสามารถกรองตามโซนได้ (p_zone_id เป็น optional)';

-- ============================================
-- Test Query
-- ============================================
-- ทดสอบดึงร้านค้าทั้งหมดตามระยะทาง (ไม่กรองโซน)
-- SELECT * FROM get_stores_by_distance(16.6398834, 102.6788935, 20, 0, NULL);

-- ทดสอบดึงร้านค้าในโซนเฉพาะ (ต้องใส่ zone_id ที่ถูกต้อง)
-- SELECT * FROM get_stores_by_distance(16.6398834, 102.6788935, 20, 0, 'your-zone-id-here');

-- ============================================
-- Function: ตรวจสอบโซนจากตำแหน่งพิกัด
-- ============================================
-- ฟังก์ชันนี้ใช้สำหรับตรวจสอบว่าพิกัดที่ระบุอยู่ในโซนใด
-- โดยคำนวณระยะทางจากจุดกึ่งกลางของแต่ละโซนและเช็คว่าอยู่ในรัศมีหรือไม่

CREATE OR REPLACE FUNCTION public.find_zone_by_location(
    p_latitude NUMERIC,
    p_longitude NUMERIC
)
RETURNS TABLE (
    zone_id UUID,
    zone_name TEXT,
    zone_code TEXT,
    province TEXT,
    district TEXT,
    distance_km NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        z.id AS zone_id,
        z.name AS zone_name,
        z.code AS zone_code,
        z.province,
        z.district,
        -- คำนวณระยะทางจากจุดกึ่งกลางโซน (Haversine formula)
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
        -- ถ้าไม่มีกำหนดรัศมี ให้ตรวจสอบทุกโซน
        z.radius_km IS NULL OR
        -- ถ้ามีรัศมี ตรวจสอบว่าอยู่ในรัศมีหรือไม่
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
$$ LANGUAGE plpgsql;

-- Grant permissions
GRANT EXECUTE ON FUNCTION public.find_zone_by_location(NUMERIC, NUMERIC) TO authenticated;
GRANT EXECUTE ON FUNCTION public.find_zone_by_location(NUMERIC, NUMERIC) TO anon;

COMMENT ON FUNCTION public.find_zone_by_location(NUMERIC, NUMERIC) IS 
'ตรวจสอบโซนจากพิกัด latitude, longitude โดยคำนวณระยะทางจากจุดกึ่งกลางโซนและเช็คว่าอยู่ในรัศมีหรือไม่';

-- ============================================
-- Test Query
-- ============================================
-- ทดสอบด้วยพิกัดที่ผู้ใช้ให้มา (ตำบล ป่าหวายนั่ง อำเภอ บ้านฝาง ขอนแก่น)
-- SELECT * FROM find_zone_by_location(16.6398834, 102.6788935);

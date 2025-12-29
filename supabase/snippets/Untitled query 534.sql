-- ============================================
-- Insert Zone: อำเภอบ้านฝาง, ขอนแก่น
-- ============================================
-- ข้อมูลโซนสำหรับอำเภอบ้านฝาง จังหวัดขอนแก่น
-- พิกัดอ้างอิงจาก: ตำบล ป่าหวายนั่ง อำเภอ บ้านฝาง

INSERT INTO public.zones (
    name,
    code,
    province,
    district,
    description,
    center_latitude,
    center_longitude,
    radius_km,
    is_active
) VALUES (
    'อำเภอบ้านฝาง',
    'KKN-BANFANG',
    'ขอนแก่น',
    'บ้านฝาง',
    'โซนพื้นที่บริการอำเภอบ้านฝาง จังหวัดขอนแก่น ครอบคลุมตำบลป่าหวายนั่งและพื้นที่ใกล้เคียง',
    16.6398831,  -- center_latitude จากพิกัดที่ให้มา
    102.6788936, -- center_longitude จากพิกัดที่ให้มา
    15.0,        -- radius_km (15 กม. ครอบคลุมพื้นที่อำเภอ)
    true
)
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    province = EXCLUDED.province,
    district = EXCLUDED.district,
    description = EXCLUDED.description,
    center_latitude = EXCLUDED.center_latitude,
    center_longitude = EXCLUDED.center_longitude,
    radius_km = EXCLUDED.radius_km,
    is_active = EXCLUDED.is_active,
    updated_at = NOW();

-- ============================================
-- Verify Insert
-- ============================================
-- ตรวจสอบว่าข้อมูลถูกเพิ่มเรียบร้อยแล้ว
SELECT 
    id,
    name,
    code,
    province,
    district,
    center_latitude,
    center_longitude,
    radius_km,
    is_active,
    created_at
FROM public.zones
WHERE code = 'KKN-BANFANG';

-- ============================================
-- Test Zone Detection
-- ============================================
-- ทดสอบว่าพิกัดที่ให้มาตรวจพบโซนบ้านฝางหรือไม่
SELECT * FROM find_zone_by_location(16.6398831, 102.6788936);

-- Expected Result:
-- zone_name: อำเภอบ้านฝาง
-- zone_code: KKN-BANFANG
-- province: ขอนแก่น
-- district: บ้านฝาง
-- distance_km: 0.00 (เพราะพิกัดตรงกับจุดกึ่งกลาง)

-- ============================================
-- Insert Additional Zones
-- Requested by user on 2026-01-03
-- ============================================

-- 1. อำเภอโนนสัง (หนองบัวลำภู)
INSERT INTO public.zones (name, code, province, district, center_latitude, center_longitude, radius_km, description, is_active)
VALUES (
    'อำเภอโนนสัง',
    'NBL-NONSANG',
    'หนองบัวลำภู',
    'โนนสัง',
    16.868498,
    102.568512,
    15.0,
    'โซนพื้นที่บริการอำเภอโนนสัง จังหวัดหนองบัวลำภู',
    true
) ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    province = EXCLUDED.province,
    district = EXCLUDED.district,
    center_latitude = EXCLUDED.center_latitude,
    center_longitude = EXCLUDED.center_longitude,
    updated_at = NOW();

-- 2. อำเภออุบลรัตน์ (ขอนแก่น)
INSERT INTO public.zones (name, code, province, district, center_latitude, center_longitude, radius_km, description, is_active)
VALUES (
    'อำเภออุบลรัตน์',
    'KKN-UBOLRATANA',
    'ขอนแก่น',
    'อุบลรัตน์',
    16.761190,
    102.635121,
    15.0,
    'โซนพื้นที่บริการอำเภออุบลรัตน์ จังหวัดขอนแก่น',
    true
) ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    province = EXCLUDED.province,
    district = EXCLUDED.district,
    center_latitude = EXCLUDED.center_latitude,
    center_longitude = EXCLUDED.center_longitude,
    updated_at = NOW();

-- 3. อำเภอน้ำพอง (ขอนแก่น)
INSERT INTO public.zones (name, code, province, district, center_latitude, center_longitude, radius_km, description, is_active)
VALUES (
    'อำเภอน้ำพอง',
    'KKN-NAMPHONG',
    'ขอนแก่น',
    'น้ำพอง',
    16.729328,
    102.801474,
    15.0,
    'โซนพื้นที่บริการอำเภอน้ำพอง จังหวัดขอนแก่น',
    true
) ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    province = EXCLUDED.province,
    district = EXCLUDED.district,
    center_latitude = EXCLUDED.center_latitude,
    center_longitude = EXCLUDED.center_longitude,
    updated_at = NOW();

-- 4. อำเภอสีชมพู (ขอนแก่น)
INSERT INTO public.zones (name, code, province, district, center_latitude, center_longitude, radius_km, description, is_active)
VALUES (
    'อำเภอสีชมพู',
    'KKN-SICHOMPHU',
    'ขอนแก่น',
    'สีชมพู',
    16.799401,
    102.183903,
    15.0,
    'โซนพื้นที่บริการอำเภอสีชมพู จังหวัดขอนแก่น',
    true
) ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    province = EXCLUDED.province,
    district = EXCLUDED.district,
    center_latitude = EXCLUDED.center_latitude,
    center_longitude = EXCLUDED.center_longitude,
    updated_at = NOW();

-- 5. อำเภอเชียงยืน (มหาสารคาม)
INSERT INTO public.zones (name, code, province, district, center_latitude, center_longitude, radius_km, description, is_active)
VALUES (
    'อำเภอเชียงยืน',
    'MKM-CHIANGYUEN',
    'มหาสารคาม',
    'เชียงยืน',
    16.411214,
    103.095955,
    15.0,
    'โซนพื้นที่บริการอำเภอเชียงยืน จังหวัดมหาสารคาม',
    true
) ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    province = EXCLUDED.province,
    district = EXCLUDED.district,
    center_latitude = EXCLUDED.center_latitude,
    center_longitude = EXCLUDED.center_longitude,
    updated_at = NOW();

-- Check results
SELECT name, code, center_latitude, center_longitude, province FROM public.zones ORDER BY created_at DESC LIMIT 5;

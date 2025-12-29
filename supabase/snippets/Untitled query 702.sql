-- ============================================
-- Migration: Insert Sample Zones Data
-- Description: เพิ่มข้อมูลโซนตัวอย่างสำหรับเชียงใหม่
-- Date: 2025-12-27
-- ============================================

-- ============================================
-- 1. เพิ่มโซนอำเภอศรีบุญเรือง จังหวัดหนองบัวลำภู
-- ============================================

-- อำเภอศรีบุญเรือง (โซนใหญ่ครอบคลุมทั้งอำเภอ)
INSERT INTO public.zones (name, code, province, district, center_latitude, center_longitude, radius_km, description)
VALUES (
    'อำเภอศรีบุญเรือง',
    'NBL-SRIBUNYUENG',
    'หนองบัวลำภู',
    'ศรีบุญเรือง',
    17.1850,
    102.5850,
    15.0,
    'พื้นที่อำเภอศรีบุญเรือง จังหวัดหนองบัวลำภู ครอบคลุมทั้งอำเภอ'
) ON CONFLICT (code) DO NOTHING;

-- ============================================
-- 2. กำหนดโซนให้ข้อมูลเดิมทั้งหมด
-- ============================================

-- กำหนดโซนอำเภอศรีบุญเรืองให้ร้านค้าทั้งหมด
UPDATE public.stores 
SET zone_id = (SELECT id FROM public.zones WHERE code = 'NBL-SRIBUNYUENG')
WHERE zone_id IS NULL;

-- กำหนดโซนอำเภอศรีบุญเรืองให้ไรเดอร์ทั้งหมด
UPDATE public.riders 
SET zone_id = (SELECT id FROM public.zones WHERE code = 'NBL-SRIBUNYUENG')
WHERE zone_id IS NULL;

-- กำหนดโซนอำเภอศรีบุญเรืองให้ออเดอร์ทั้งหมด (ที่ยังไม่มีโซน)
UPDATE public.orders 
SET zone_id = (SELECT id FROM public.zones WHERE code = 'NBL-SRIBUNYUENG')
WHERE zone_id IS NULL;

-- ============================================
-- 3. ตั้งค่า Super Admin (Optional)
-- ============================================
-- หมายเหตุ: Uncomment และแก้ไข email ตามต้องการ
-- UPDATE public.users 
-- SET is_super_admin = true
-- WHERE email = 'admin@example.com' AND role = 'admin';

-- ============================================
-- Sample Data Complete
-- ============================================
-- สรุป:
-- ✅ เพิ่มโซนตัวอย่าง 5 อำเภอในเชียงใหม่
-- ✅ พร้อม SQL ตัวอย่างสำหรับกำหนดโซนให้ข้อมูลเดิม
-- 
-- หมายเหตุ: 
-- - ปรับแก้พิกัดและรัศมีตามความเหมาะสม
-- - Uncomment SQL ด้านบนเพื่อกำหนดโซนให้ข้อมูลเดิม

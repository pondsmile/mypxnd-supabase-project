-- ============================================
-- Migration: Add Zone Management System
-- Description: เพิ่มระบบแบ่งโซนพื้นที่สำหรับแอปเดลิเวอรี่
-- Date: 2025-12-27
-- ============================================

-- ============================================
-- 1. สร้างตาราง zones (โซนพื้นที่)
-- ============================================
CREATE TABLE IF NOT EXISTS public.zones (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    code TEXT NOT NULL UNIQUE,
    province TEXT NOT NULL,
    district TEXT,
    description TEXT,
    boundary_geojson JSONB,
    center_latitude NUMERIC(10,8),
    center_longitude NUMERIC(11,8),
    radius_km NUMERIC(5,2),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comments
COMMENT ON TABLE public.zones IS 'ตารางเก็บข้อมูลโซนพื้นที่บริการ';
COMMENT ON COLUMN public.zones.name IS 'ชื่อโซน เช่น "อำเภอศรีบุญเรือง"';
COMMENT ON COLUMN public.zones.code IS 'รหัสโซน เช่น "CM-MUANG" (ต้องไม่ซ้ำ)';
COMMENT ON COLUMN public.zones.province IS 'จังหวัด เช่น "หนองบัวลำภู"';
COMMENT ON COLUMN public.zones.district IS 'อำเภอ เช่น "ศรีบุญเรือง"';
COMMENT ON COLUMN public.zones.boundary_geojson IS 'ขอบเขตพื้นที่แบบ GeoJSON Polygon';
COMMENT ON COLUMN public.zones.center_latitude IS 'ละติจูดจุดกึ่งกลางโซน เช่น 17.1850';
COMMENT ON COLUMN public.zones.center_longitude IS 'ลองจิจูดจุดกึ่งกลางโซน เช่น 102.5850';
COMMENT ON COLUMN public.zones.radius_km IS 'รัศมีโซน (กม.) สำหรับโซนแบบวงกลม';
COMMENT ON COLUMN public.zones.is_active IS 'สถานะเปิด/ปิดโซน';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_zones_code ON public.zones(code);
CREATE INDEX IF NOT EXISTS idx_zones_province ON public.zones(province);
CREATE INDEX IF NOT EXISTS idx_zones_is_active ON public.zones(is_active);

-- ============================================
-- 2. สร้างตาราง admin_zones (กำหนดโซนให้ Admin)
-- ============================================
CREATE TABLE IF NOT EXISTS public.admin_zones (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    admin_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    zone_id UUID NOT NULL REFERENCES public.zones(id) ON DELETE CASCADE,
    can_view BOOLEAN DEFAULT true,
    can_edit BOOLEAN DEFAULT true,
    can_manage_stores BOOLEAN DEFAULT true,
    can_manage_riders BOOLEAN DEFAULT true,
    can_manage_orders BOOLEAN DEFAULT true,
    assigned_by UUID REFERENCES public.users(id),
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(admin_id, zone_id)
);

-- Comments
COMMENT ON TABLE public.admin_zones IS 'ตารางกำหนดโซนให้ Admin พร้อมสิทธิ์การเข้าถึง';
COMMENT ON COLUMN public.admin_zones.admin_id IS 'ID ของ Admin';
COMMENT ON COLUMN public.admin_zones.zone_id IS 'ID ของโซน';
COMMENT ON COLUMN public.admin_zones.can_view IS 'สิทธิ์ดูข้อมูลในโซน';
COMMENT ON COLUMN public.admin_zones.can_edit IS 'สิทธิ์แก้ไขข้อมูลในโซน';
COMMENT ON COLUMN public.admin_zones.can_manage_stores IS 'สิทธิ์จัดการร้านค้า';
COMMENT ON COLUMN public.admin_zones.can_manage_riders IS 'สิทธิ์จัดการไรเดอร์';
COMMENT ON COLUMN public.admin_zones.can_manage_orders IS 'สิทธิ์จัดการออเดอร์';
COMMENT ON COLUMN public.admin_zones.assigned_by IS 'ใครเป็นคนมอบหมาย';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_admin_zones_admin_id ON public.admin_zones(admin_id);
CREATE INDEX IF NOT EXISTS idx_admin_zones_zone_id ON public.admin_zones(zone_id);

-- ============================================
-- 3. เพิ่มฟิลด์ zone_id ในตาราง stores
-- ============================================
ALTER TABLE public.stores 
ADD COLUMN IF NOT EXISTS zone_id UUID REFERENCES public.zones(id) ON DELETE SET NULL;

COMMENT ON COLUMN public.stores.zone_id IS 'โซนที่ร้านค้าอยู่';

CREATE INDEX IF NOT EXISTS idx_stores_zone_id ON public.stores(zone_id);

-- ============================================
-- 4. เพิ่มฟิลด์ zone_id ในตาราง riders
-- ============================================
ALTER TABLE public.riders 
ADD COLUMN IF NOT EXISTS zone_id UUID REFERENCES public.zones(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS can_work_multiple_zones BOOLEAN DEFAULT false;

COMMENT ON COLUMN public.riders.zone_id IS 'โซนหลักที่ไรเดอร์ทำงาน';
COMMENT ON COLUMN public.riders.can_work_multiple_zones IS 'สามารถรับงานข้ามโซนได้หรือไม่';

CREATE INDEX IF NOT EXISTS idx_riders_zone_id ON public.riders(zone_id);

-- ============================================
-- 5. เพิ่มฟิลด์ zone_id ในตาราง orders
-- ============================================
ALTER TABLE public.orders 
ADD COLUMN IF NOT EXISTS zone_id UUID REFERENCES public.zones(id) ON DELETE SET NULL;

COMMENT ON COLUMN public.orders.zone_id IS 'โซนของออเดอร์ (ตามโซนของร้านค้า)';

CREATE INDEX IF NOT EXISTS idx_orders_zone_id ON public.orders(zone_id);

-- ============================================
-- 3. จัดการ Triggers ที่มีอยู่แล้ว (ป้องกัน Conflict)
-- ============================================

-- ลบ Trigger sync_store_active_orders ชั่วคราว (ถ้ามี)
DROP TRIGGER IF EXISTS sync_store_active_orders_trigger ON public.orders;

-- ============================================
-- 4. เพิ่มฟิลด์ zone_id ในตาราง orders
-- ============================================
ALTER TABLE public.orders 
ADD COLUMN IF NOT EXISTS zone_id UUID REFERENCES public.zones(id) ON DELETE SET NULL;

COMMENT ON COLUMN public.orders.zone_id IS 'โซนของออเดอร์ (ตามโซนของร้านค้า)';

CREATE INDEX IF NOT EXISTS idx_orders_zone_id ON public.orders(zone_id);

-- ============================================
-- 5. เพิ่มฟิลด์ zone_id ในตาราง store_active_orders (ถ้ามี)
-- ============================================
-- หมายเหตุ: ตาราง store_active_orders ต้องมีโครงสร้างเหมือนกับ orders
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'store_active_orders'
    ) THEN
        ALTER TABLE public.store_active_orders 
        ADD COLUMN IF NOT EXISTS zone_id UUID REFERENCES public.zones(id) ON DELETE SET NULL;
        
        CREATE INDEX IF NOT EXISTS idx_store_active_orders_zone_id ON public.store_active_orders(zone_id);
    END IF;
END $$;

-- ============================================
-- 6. ปิด Trigger sync_store_active_orders ถาวร (เพื่อป้องกัน Conflict)
-- ============================================
-- หมายเหตุ: Trigger นี้จะต้องถูกสร้างใหม่ด้วยตัวเองหลัง Migration
-- เพราะโครงสร้างตารางเปลี่ยนแปลง (เพิ่มฟิลด์ zone_id)
-- 
-- ถ้าต้องการให้ Trigger ทำงาน ให้รันคำสั่งนี้ภายหลัง:
-- DROP FUNCTION IF EXISTS sync_store_active_orders() CASCADE;
-- แล้วสร้าง Function ใหม่ที่รองรับฟิลด์ zone_id

-- ลบ Trigger (ไม่สร้างใหม่)
DROP TRIGGER IF EXISTS sync_store_active_orders_trigger ON public.orders;

-- ============================================
-- 7. เพิ่มฟิลด์ Admin ในตาราง users
-- ============================================
ALTER TABLE public.users 
ADD COLUMN IF NOT EXISTS is_zone_admin BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS is_super_admin BOOLEAN DEFAULT false;

COMMENT ON COLUMN public.users.is_zone_admin IS 'เป็น Admin ที่ดูแลเฉพาะโซน';
COMMENT ON COLUMN public.users.is_super_admin IS 'เป็น Super Admin ที่ดูได้ทุกโซน';

CREATE INDEX IF NOT EXISTS idx_users_is_zone_admin ON public.users(is_zone_admin);
CREATE INDEX IF NOT EXISTS idx_users_is_super_admin ON public.users(is_super_admin);

-- ============================================
-- 7. สร้างตาราง rider_zones (Optional - สำหรับไรเดอร์ทำงานหลายโซน)
-- ============================================
CREATE TABLE IF NOT EXISTS public.rider_zones (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    rider_id UUID NOT NULL REFERENCES public.riders(id) ON DELETE CASCADE,
    zone_id UUID NOT NULL REFERENCES public.zones(id) ON DELETE CASCADE,
    is_primary BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(rider_id, zone_id)
);

COMMENT ON TABLE public.rider_zones IS 'ตารางกำหนดโซนให้ไรเดอร์ (กรณีทำงานหลายโซน)';
COMMENT ON COLUMN public.rider_zones.is_primary IS 'โซนหลักหรือไม่';

CREATE INDEX IF NOT EXISTS idx_rider_zones_rider_id ON public.rider_zones(rider_id);
CREATE INDEX IF NOT EXISTS idx_rider_zones_zone_id ON public.rider_zones(zone_id);

-- ============================================
-- 8. สร้าง Function: กำหนดโซนให้ออเดอร์อัตโนมัติ
-- ============================================
CREATE OR REPLACE FUNCTION public.auto_assign_order_zone()
RETURNS TRIGGER AS $$
BEGIN
    -- กำหนดโซนตามร้านค้า
    IF NEW.store_id IS NOT NULL THEN
        SELECT zone_id INTO NEW.zone_id
        FROM public.stores
        WHERE id = NEW.store_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.auto_assign_order_zone() IS 'กำหนดโซนให้ออเดอร์อัตโนมัติตามโซนของร้านค้า';

-- ============================================
-- 9. สร้าง Trigger: กำหนดโซนให้ออเดอร์
-- ============================================
DROP TRIGGER IF EXISTS trigger_auto_assign_order_zone ON public.orders;

CREATE TRIGGER trigger_auto_assign_order_zone
    BEFORE INSERT ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.auto_assign_order_zone();

COMMENT ON TRIGGER trigger_auto_assign_order_zone ON public.orders IS 'Trigger กำหนดโซนให้ออเดอร์อัตโนมัติ';

-- ============================================
-- 10. สร้าง Function: ตรวจสอบสิทธิ์ Admin
-- ============================================
CREATE OR REPLACE FUNCTION public.check_admin_zone_access(
    p_admin_id UUID,
    p_zone_id UUID
) RETURNS BOOLEAN AS $$
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
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.check_admin_zone_access(UUID, UUID) IS 'ตรวจสอบว่า Admin มีสิทธิ์เข้าถึงโซนหรือไม่';

-- ============================================
-- 11. สร้าง View: สถิติแต่ละโซน
-- ============================================
CREATE OR REPLACE VIEW public.zone_statistics AS
SELECT 
    z.id AS zone_id,
    z.name AS zone_name,
    z.code AS zone_code,
    z.province,
    z.district,
    COUNT(DISTINCT s.id) AS total_stores,
    COUNT(DISTINCT r.id) AS total_riders,
    COUNT(DISTINCT o.id) AS total_orders,
    COUNT(DISTINCT CASE WHEN o.status = 'delivered' THEN o.id END) AS delivered_orders,
    COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN o.total_amount ELSE 0 END), 0) AS total_revenue,
    COUNT(DISTINCT az.admin_id) AS total_admins,
    z.is_active,
    z.created_at
FROM public.zones z
LEFT JOIN public.stores s ON z.id = s.zone_id AND s.is_active = true
LEFT JOIN public.riders r ON z.id = r.zone_id AND r.is_active = true
LEFT JOIN public.orders o ON z.id = o.zone_id
LEFT JOIN public.admin_zones az ON z.id = az.zone_id
WHERE z.is_active = true
GROUP BY z.id, z.name, z.code, z.province, z.district, z.is_active, z.created_at
ORDER BY z.name;

COMMENT ON VIEW public.zone_statistics IS 'สถิติแต่ละโซน (ร้านค้า, ไรเดอร์, ออเดอร์, รายได้)';

-- ============================================
-- 12. สร้าง Function: อัพเดท updated_at อัตโนมัติ
-- ============================================
CREATE OR REPLACE FUNCTION public.update_zones_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- 13. สร้าง Trigger: อัพเดท updated_at
-- ============================================
DROP TRIGGER IF EXISTS trigger_update_zones_updated_at ON public.zones;

CREATE TRIGGER trigger_update_zones_updated_at
    BEFORE UPDATE ON public.zones
    FOR EACH ROW
    EXECUTE FUNCTION public.update_zones_updated_at();

-- ============================================
-- 14. Enable Row Level Security (RLS) - Optional
-- ============================================
-- ALTER TABLE public.zones ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.admin_zones ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.rider_zones ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 15. Grant Permissions
-- ============================================
GRANT SELECT, INSERT, UPDATE, DELETE ON public.zones TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.admin_zones TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.rider_zones TO authenticated;
GRANT SELECT ON public.zone_statistics TO authenticated;

-- ============================================
-- Migration Complete
-- ============================================
-- สรุป:
-- ✅ สร้างตาราง zones, admin_zones, rider_zones
-- ✅ เพิ่มฟิลด์ zone_id ใน stores, riders, orders
-- ✅ เพิ่มฟิลด์ is_zone_admin, is_super_admin ใน users
-- ✅ สร้าง Functions และ Triggers
-- ✅ สร้าง View สำหรับสถิติ
-- ✅ สร้าง Indexes สำหรับ Performance
-- 
-- หมายเหตุ: แอปเดิมยังใช้งานได้ปกติ เพราะฟิลด์ใหม่ทั้งหมดเป็น NULLABLE

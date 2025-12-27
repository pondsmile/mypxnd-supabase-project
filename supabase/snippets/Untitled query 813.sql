-- ============================================
-- Fix: Recreate sync_store_active_orders Function with zone_id Support
-- Description: แก้ไข Function ให้รองรับฟิลด์ zone_id ก่อนรัน Zone Migration
-- Date: 2025-12-27
-- ============================================

-- ============================================
-- 1. ลบ Function และ Trigger เดิม
-- ============================================
DROP TRIGGER IF EXISTS sync_store_active_orders_trigger ON public.orders;
DROP FUNCTION IF EXISTS public.sync_store_active_orders() CASCADE;

-- ============================================
-- 2. สร้าง Function ใหม่ที่รองรับ zone_id
-- ============================================
CREATE OR REPLACE FUNCTION public.sync_store_active_orders()
RETURNS TRIGGER AS $$
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
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION public.sync_store_active_orders() IS 'Sync ออเดอร์ active ไปยัง store_active_orders (รองรับ zone_id)';

-- ============================================
-- 3. สร้าง Trigger ใหม่
-- ============================================
CREATE TRIGGER sync_store_active_orders_trigger
  AFTER INSERT OR UPDATE OR DELETE ON public.orders
  FOR EACH ROW
  EXECUTE FUNCTION public.sync_store_active_orders();

COMMENT ON TRIGGER sync_store_active_orders_trigger ON public.orders IS 'Trigger สำหรับ sync ข้อมูลไป store_active_orders';

-- ============================================
-- Fix Complete
-- ============================================
-- สรุป:
-- ✅ ลบ Function และ Trigger เดิม
-- ✅ สร้าง Function ใหม่ที่รองรับฟิลด์ zone_id
-- ✅ สร้าง Trigger ใหม่
-- 
-- หมายเหตุ:
-- - Function นี้จะทำงานได้ทั้งก่อนและหลังเพิ่มฟิลด์ zone_id
-- - ถ้ายังไม่มีฟิลด์ zone_id ค่าจะเป็น NULL
-- - หลังเพิ่มฟิลด์ zone_id แล้ว Function จะ sync ค่าได้ปกติ
-- 
-- ขั้นตอนต่อไป:
-- 1. รันไฟล์นี้ก่อน (000_fix_sync_function.sql)
-- 2. จากนั้นรัน 001_add_zone_management.sql
-- 3. รัน 002_insert_sample_zones.sql
-- 4. รัน 003_add_zone_reports.sql

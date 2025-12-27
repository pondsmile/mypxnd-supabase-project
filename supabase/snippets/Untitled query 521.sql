-- ============================================
-- สร้างออเดอร์ทดสอบ (ใช้ customer ทดสอบอัตโนมัติ)
-- ============================================

-- สร้างออเดอร์ทดสอบ 1: ออเดอร์เล็ก (ลูกชิ้น)
WITH test_customer AS (
    SELECT id FROM public.users 
    WHERE email = 'customer.test@example.com' 
    LIMIT 1
),
new_order AS (
    INSERT INTO public.orders (
        order_number,
        customer_id,
        store_id,
        status,
        total_amount,
        subtotal,
        delivery_fee,
        calculated_delivery_fee,
        distance_km,
        delivery_address,
        delivery_latitude,
        delivery_longitude,
        payment_method,
        payment_status,
        special_instructions,
        created_at
    )
    SELECT
        'ORD-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(FLOOR(RANDOM() * 10000)::TEXT, 4, '0'),
        test_customer.id,
        '70ac2521-c83d-4be3-9ed7-4a232d09cc5b',
        'pending',
        35.00,
        5.00,
        30.00,
        30.00,
        2.5,
        'JMQH+WRR ตำบล ป่าหวายนั่ง อำเภอ บ้านฝาง ขอนแก่น 40270',
        16.639883,
        102.6788936,
        'cash',
        'pending',
        'ออเดอร์ทดสอบ 1',
        NOW()
    FROM test_customer
    RETURNING id
)
INSERT INTO public.order_items (order_id, product_id, product_name, product_price, quantity, total_price)
SELECT 
    new_order.id,
    'a4bf63ea-e5bc-4d3a-8406-a182096b7640',
    'ลูกชิ้น',
    5.00,
    1,
    5.00
FROM new_order;

-- สร้างออเดอร์ทดสอบ 2: ออเดอร์กลาง (ข้าวผัด + ชาเย็น)
WITH test_customer AS (
    SELECT id FROM public.users 
    WHERE email = 'customer.test@example.com' 
    LIMIT 1
),
product_ids AS (
    SELECT id, name, price 
    FROM public.products 
    WHERE store_id = '70ac2521-c83d-4be3-9ed7-4a232d09cc5b'
    AND name IN ('ข้าวผัด', 'ชาเย็น')
),
new_order AS (
    INSERT INTO public.orders (
        order_number,
        customer_id,
        store_id,
        status,
        total_amount,
        subtotal,
        delivery_fee,
        calculated_delivery_fee,
        distance_km,
        delivery_address,
        delivery_latitude,
        delivery_longitude,
        payment_method,
        payment_status,
        special_instructions,
        created_at
    )
    SELECT
        'ORD-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(FLOOR(RANDOM() * 10000)::TEXT, 4, '0'),
        test_customer.id,
        '70ac2521-c83d-4be3-9ed7-4a232d09cc5b',
        'accepted',
        90.00,
        60.00,
        30.00,
        30.00,
        2.5,
        'JMQH+WRR ตำบล ป่าหวายนั่ง อำเภอ บ้านฝาง ขอนแก่น 40270',
        16.639883,
        102.6788936,
        'cash',
        'pending',
        'ออเดอร์ทดสอบ 2 - ไม่ใส่ผักชี',
        NOW() - INTERVAL '1 hour'
    FROM test_customer
    RETURNING id
)
INSERT INTO public.order_items (order_id, product_id, product_name, product_price, quantity, total_price)
SELECT 
    new_order.id,
    p.id,
    p.name,
    p.price,
    1,
    p.price
FROM new_order, product_ids p;

-- สร้างออเดอร์ทดสอบ 3: ออเดอร์ใหญ่ (หลายรายการ)
WITH test_customer AS (
    SELECT id FROM public.users 
    WHERE email = 'customer.test@example.com' 
    LIMIT 1
),
product_ids AS (
    SELECT id, name, price 
    FROM public.products 
    WHERE store_id = '70ac2521-c83d-4be3-9ed7-4a232d09cc5b'
    AND name IN ('ผัดกะเพรา', 'ส้มตำไทย', 'ไก่ทอด', 'น้ำเปล่า')
),
new_order AS (
    INSERT INTO public.orders (
        order_number,
        customer_id,
        store_id,
        status,
        total_amount,
        subtotal,
        delivery_fee,
        calculated_delivery_fee,
        distance_km,
        delivery_address,
        delivery_latitude,
        delivery_longitude,
        payment_method,
        payment_status,
        special_instructions,
        created_at
    )
    SELECT
        'ORD-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(FLOOR(RANDOM() * 10000)::TEXT, 4, '0'),
        test_customer.id,
        '70ac2521-c83d-4be3-9ed7-4a232d09cc5b',
        'preparing',
        160.00,
        130.00,
        30.00,
        30.00,
        2.5,
        'JMQH+WRR ตำบล ป่าหวายนั่ง อำเภอ บ้านฝาง ขอนแก่น 40270',
        16.639883,
        102.6788936,
        'cash',
        'pending',
        'ออเดอร์ทดสอบ 3 - เผ็ดน้อย',
        NOW() - INTERVAL '30 minutes'
    FROM test_customer
    RETURNING id
)
INSERT INTO public.order_items (order_id, product_id, product_name, product_price, quantity, total_price)
SELECT 
    new_order.id,
    p.id,
    p.name,
    p.price,
    1,
    p.price
FROM new_order, product_ids p;

-- ตรวจสอบออเดอร์ที่สร้าง
SELECT 
    o.id,
    o.order_number,
    o.status,
    o.total_amount,
    o.subtotal,
    o.delivery_fee,
    o.created_at,
    COUNT(oi.id) as item_count
FROM public.orders o
LEFT JOIN public.order_items oi ON o.id = oi.order_id
WHERE o.store_id = '70ac2521-c83d-4be3-9ed7-4a232d09cc5b'
GROUP BY o.id, o.order_number, o.status, o.total_amount, o.subtotal, o.delivery_fee, o.created_at
ORDER BY o.created_at DESC
LIMIT 10;

-- ดูรายละเอียดออเดอร์ล่าสุด
SELECT 
    o.order_number,
    o.status,
    oi.product_name,
    oi.quantity,
    oi.product_price,
    oi.total_price
FROM public.orders o
JOIN public.order_items oi ON o.id = oi.order_id
WHERE o.store_id = '70ac2521-c83d-4be3-9ed7-4a232d09cc5b'
ORDER BY o.created_at DESC, oi.product_name
LIMIT 20;

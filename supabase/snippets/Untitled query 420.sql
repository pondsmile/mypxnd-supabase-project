-- ตรวจสอบว่ามี schema supabase_functions หรือไม่
SELECT schema_name 
FROM information_schema.schemata 
WHERE schema_name = 'supabase_functions';

-- ตรวจสอบว่ามีฟังก์ชัน http_request หรือไม่
SELECT routine_name, routine_schema
FROM information_schema.routines 
WHERE routine_name = 'http_request';
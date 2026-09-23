-- ============================================================
-- SCRIPT DE DIAGNÓSTICO COMPLETO DE BASE DE DATOS
-- ============================================================
-- Este script verifica el estado completo de la base de datos
-- para identificar inconsistencias entre la aplicación y Supabase.

BEGIN;

-- 1. Verificar todos los usuarios en la tabla
SELECT '=== USUARIOS EN TABLA ===' as info;
SELECT 
    id, 
    email, 
    CASE 
        WHEN password IS NOT NULL THEN '***HASH_PRESENT***' 
        ELSE 'NULL' 
    END as password_status,
    nombre, 
    rol, 
    created_at,
    updated_at
FROM public.usuarios;

-- 2. Verificar schema actual
SELECT '=== SCHEMA ACTUAL ===' as info;
SELECT 
    table_name, 
    column_name, 
    data_type, 
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'usuarios' 
ORDER BY ordinal_position;

-- 3. Verificar índices
SELECT '=== ÍNDICES ===' as info;
SELECT 
    indexname, 
    indexdef
FROM pg_indexes 
WHERE tablename = 'usuarios';

-- 4. Verificar restricciones
SELECT '=== RESTRICCIONES ===' as info;
SELECT 
    conname as constraint_name,
    contype as constraint_type,
    pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint 
WHERE conrelid = 'public.usuarios'::regclass;

-- 5. Verificar conteo total
SELECT '=== CONTEO TOTAL ===' as info;
SELECT COUNT(*) as total_usuarios FROM public.usuarios;

COMMIT;

-- ============================================================
-- INSTRUCCIONES:
-- ============================================================
-- 1. Ejecutar este script completo en el SQL Editor de Supabase
-- 2. Revisar los resultados:
--    - Si "USUARIOS EN TABLA" muestra registros, hay usuarios ocultos
--    - Si "CONTEO TOTAL" > 0, hay datos que no se ven en el Table Editor
--    - Si el schema no coincide con el esperado, hay problemas de estructura
-- 3. Enviar los resultados para análisis adicional
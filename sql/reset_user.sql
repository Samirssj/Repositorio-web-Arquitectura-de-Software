-- ============================================================
-- SCRIPT DE RESET DE USUARIO ADMINISTRADOR
-- ============================================================
-- Este script elimina el usuario administrador existente para permitir
-- un registro limpio con el nuevo sistema de autenticación.

BEGIN;

-- Eliminar usuario administrador existente
DELETE FROM public.usuarios 
WHERE lower(trim(email)) = 'samircenfe17@gmail.com';

-- Verificar eliminación
SELECT 
    COUNT(*) as usuarios_eliminados
FROM public.usuarios 
WHERE lower(trim(email)) = 'samircenfe17@gmail.com';

COMMIT;

-- ============================================================
-- INSTRUCCIONES:
-- ============================================================
-- 1. Ejecutar este script en el SQL Editor de Supabase antes de
--    proceder con el nuevo sistema de registro.
-- 2. Después de ejecutar, el usuario será recreado automáticamente
--    mediante el servlet de registro con el rol correcto de 'admin'.
-- 3. El sistema detectará automáticamente el email reservado y
--    asignará el rol de administrador según la restricción de base de datos.
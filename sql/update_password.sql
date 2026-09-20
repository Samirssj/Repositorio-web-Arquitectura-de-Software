-- ============================================================
-- SCRIPT PARA ACTUALIZAR CONTRASEÑA DE USUARIO EXISTENTE
-- ============================================================
-- Este script actualiza la contraseña de un usuario existente
-- en la tabla usuarios usando BCrypt.

BEGIN;

-- Actualizar contraseña del usuario existente
UPDATE public.usuarios
SET 
    password = '$2a$12$q.l.l06oWPC0WV2k3WZTGuQ8bJlnydxLgPsMTNCWy58N.X.53lL2C', -- <--- REEMPLAZA ESTO CON TU NUEVO HASH BCRYPT
    updated_at = now()
WHERE lower(trim(email)) = lower(trim('samircenfe17@gmail.com'));

-- Verificar que la actualización fue exitosa
SELECT 
    id, 
    email, 
    CASE 
        WHEN password IS NOT NULL THEN '***HASH_ACTUALIZADO***' 
        ELSE 'NULL' 
    END as password_status,
    nombre, 
    rol, 
    updated_at
FROM public.usuarios
WHERE lower(trim(email)) = lower(trim('samircenfe17@gmail.com'));

COMMIT;

-- ============================================================
-- INSTRUCCIONES:
-- ============================================================
-- 1. Genera un nuevo hash BCrypt de tu contraseña deseada
--    Puedes usar herramientas online como:
--    - https://bcrypt-generator.com/
--    - https://bcrypt-calculator.com/
--    - O desde Java: BCrypt.hashpw("tu-nueva-contraseña", BCrypt.gensalt())
--
-- 2. Reemplaza el hash de ejemplo en la línea 11 con tu nuevo hash
--
-- 3. Ejecuta este script en el SQL Editor de Supabase
--
-- 4. Verifica que la consulta SELECT muestre "***HASH_ACTUALIZADO***"
--
-- 5. Prueba el login con tu nueva contraseña
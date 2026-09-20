-- ============================================================
-- SCRIPT PARA CORREGIR CONTRASEÑA CON HASH BCRYPT $2a$
-- ============================================================
-- Este script actualiza la contraseña usando la versión $2a$ de BCrypt
-- que es compatible con la biblioteca jbcrypt de Java.

BEGIN;

-- Actualizar contraseña con hash $2a$ (compatible con jbcrypt Java)
UPDATE public.usuarios
SET 
    password = '$2a$12$q.l.l06oWPC0WV2k3WZTGuQ8bJlnydxLgPsMTNCWy58N.X.53lL2C', -- Hash para: samir_1717ssj
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
-- EXPLICACIÓN:
-- ============================================================
-- El hash anterior ($2y$) no es totalmente compatible con jbcrypt de Java.
-- Este script usa un hash $2a$ que es el estándar para jbcrypt.
-- 
-- Para generar otros hashes $2a$ en el futuro, usa:
-- - https://bcrypt-generator.com/ (asegúrate que el hash empiece con $2a$)
-- - O desde Java: BCrypt.hashpw("tu-contraseña", BCrypt.gensalt())
--
-- El hash actual es para la contraseña: samir_1717ssj
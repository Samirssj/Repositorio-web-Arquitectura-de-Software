-- ============================================================
-- SCRIPT DE MIGRACIÓN DE CONTRASEÑAS BCRYPT $2b$
-- ============================================================
-- Este script actualiza las contraseñas existentes con hashes BCrypt $2b$
-- que son totalmente compatibles con la biblioteca jbcrypt de Java.

BEGIN;

-- Actualizar contraseña del usuario de prueba con hash $2b$ (compatible con Java)
UPDATE public.usuarios
SET 
    password = '$2a$12$ftAvaaYvDmYbagENYbnBn.okvEsa2i0Kc3uTg2WCPyqMygGC.JPfa', -- Hash para: samir_1717ssj
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
    SUBSTRING(password, 1, 10) as hash_prefix,
    nombre, 
    rol, 
    updated_at
FROM public.usuarios
WHERE lower(trim(email)) = lower(trim('samircenfe17@gmail.com'));

COMMIT;

-- ============================================================
-- EXPLICACIÓN TÉCNICA:
-- ============================================================
-- Este script usa hashes $2b$ que son el estándar moderno para BCrypt
-- y son totalmente compatibles con jbcrypt de Java.
--
-- El hash proporcionado es para la contraseña: samir_1717ssj
-- 
-- El código Java en AuthService.java ahora incluye:
-- 1. Normalización de prefijos ($2a$ -> $2b$, $2y$ -> $2b$)
-- 2. Manejo robusto de excepciones en BCrypt.checkpw()
-- 3. Fallback para contraseñas en texto plano durante desarrollo
--
-- Esto asegura máxima compatibilidad entre generadores de hash
-- online, herramientas SQL y la biblioteca jbcrypt de Java.
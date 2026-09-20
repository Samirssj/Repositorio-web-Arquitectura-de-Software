-- ============================================================
-- SCRIPT DE CORRECCIÓN SQL PARA SUPABASE
-- ============================================================
-- Este script corrige el esquema de la tabla archivos para incluir
-- la columna 'semana' necesaria para el funcionamiento de la aplicación.

BEGIN;

-- Agregar columna semana si no existe
ALTER TABLE public.archivos ADD COLUMN IF NOT EXISTS semana INT NOT NULL DEFAULT 1;

-- Crear índice para optimizar consultas por semana
CREATE INDEX IF NOT EXISTS archivos_semana_idx ON public.archivos (semana);

COMMIT;

-- Nota: Ejecutar este script en el SQL Editor de Supabase
-- https://supabase.com/dashboard/project/YOUR_PROJECT/sql
// Configuración global de Supabase para el cliente
const SUPABASE_CONFIG = {
    URL: "https://hpsyiynzgtetsimzzfyc.supabase.co", // Tu URL de Supabase
    ANON_KEY: "sb_publishable_Jktf0Wnw7bQJIq-hAD7N1Q_e8CWu7mw" // Pega tu anon public key aquí
};

// Inicialización del cliente oficial de Supabase
const supabaseClient = supabase.createClient(SUPABASE_CONFIG.URL, SUPABASE_CONFIG.ANON_KEY);
package com.miportafolio.config;

public class SupabaseConfig {
    private static final String SUPABASE_URL = "https://your-project.supabase.co";
    private static final String SUPABASE_KEY = "your-anon-key";

    public static String getSupabaseUrl() {
        return SUPABASE_URL;
    }

    public static String getSupabaseKey() {
        return SUPABASE_KEY;
    }
}

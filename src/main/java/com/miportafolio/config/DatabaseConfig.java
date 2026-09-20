package com.miportafolio.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConfig {

    // Credenciales fijas de Supabase
    private static final String URL = "jdbc:postgresql://db.hpsyiynzgtetsimzzfyc.supabase.co:5432/postgres";
    private static final String USER = "postgres";
    private static final String PASS = "FZ7i7APRePevXn_8";
    
    // Ruta de subida predeterminada para el almacenamiento
    private static final String UPLOAD_DIR = "uploads";

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("Error al cargar el driver JDBC de PostgreSQL.", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    // MÉTODO REQUERIDO POR StorageService.java
    public static String getProperty(String key) {
        if ("upload.directory".equals(key)) {
            return UPLOAD_DIR;
        }
        if ("supabase.url".equals(key) || "SUPABASE_URL".equals(key)) {
            return URL;
        }
        if ("supabase.username".equals(key) || "SUPABASE_USERNAME".equals(key)) {
            return USER;
        }
        if ("supabase.password".equals(key) || "SUPABASE_PASSWORD".equals(key)) {
            return PASS;
        }
        return null;
    }
}
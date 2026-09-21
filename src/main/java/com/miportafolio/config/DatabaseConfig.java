package com.miportafolio.config;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Configuracion de acceso a la base de datos (Supabase/PostgreSQL).
 *
 * Orden de resolucion de cada propiedad:
 *   1. Variable de entorno (SUPABASE_URL, SUPABASE_USERNAME, SUPABASE_PASSWORD, UPLOAD_DIRECTORY)
 *   2. src/main/resources/application.properties (ignorado por git)
 *   3. Valor por defecto embebido
 */
public class DatabaseConfig {

    private static final Logger LOGGER = Logger.getLogger(DatabaseConfig.class.getName());

    private static final String PROPERTIES_FILE = "application.properties";

    private static final String DEFAULT_URL = "jdbc:postgresql://db.hpsyiynzgtetsimzzfyc.supabase.co:5432/postgres";
    private static final String DEFAULT_USER = "postgres";
    private static final String DEFAULT_PASS = "FZ7i7APRePevXn_8";
    private static final String DEFAULT_UPLOAD_DIR = "uploads";

    private static final int LOGIN_TIMEOUT_SECONDS = 10;

    private static final Properties PROPERTIES = new Properties();

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Error al cargar el driver JDBC de PostgreSQL.", e);
        }

        try (InputStream in = DatabaseConfig.class.getClassLoader().getResourceAsStream(PROPERTIES_FILE)) {
            if (in != null) {
                PROPERTIES.load(in);
                LOGGER.info("Configuracion de base de datos cargada desde " + PROPERTIES_FILE);
            } else {
                LOGGER.info(PROPERTIES_FILE + " no encontrado; se usan variables de entorno o valores por defecto");
            }
        } catch (IOException e) {
            LOGGER.log(Level.WARNING, "No se pudo leer " + PROPERTIES_FILE, e);
        }

        DriverManager.setLoginTimeout(LOGIN_TIMEOUT_SECONDS);
        LOGGER.info("URL JDBC en uso: " + getUrl() + " (usuario: " + getUser() + ")");
    }

    public static Connection getConnection() throws SQLException {
        Properties props = new Properties();
        props.setProperty("user", getUser());
        props.setProperty("password", getPassword());
        props.setProperty("sslmode", "require");
        props.setProperty("connectTimeout", String.valueOf(LOGIN_TIMEOUT_SECONDS));
        props.setProperty("socketTimeout", "30");
        props.setProperty("ApplicationName", "MiPortafolio");
        return DriverManager.getConnection(getUrl(), props);
    }

    public static String getUrl() {
        return resolve("SUPABASE_URL", "supabase.url", DEFAULT_URL);
    }

    public static String getUser() {
        return resolve("SUPABASE_USERNAME", "supabase.username", DEFAULT_USER);
    }

    private static String getPassword() {
        return resolve("SUPABASE_PASSWORD", "supabase.password", DEFAULT_PASS);
    }

    public static String getUploadDirectory() {
        return resolve("UPLOAD_DIRECTORY", "upload.directory", DEFAULT_UPLOAD_DIR);
    }

    public static String getProperty(String key) {
        switch (key) {
            case "upload.directory":
            case "UPLOAD_DIRECTORY":
                return getUploadDirectory();
            case "supabase.url":
            case "SUPABASE_URL":
                return getUrl();
            case "supabase.username":
            case "SUPABASE_USERNAME":
                return getUser();
            case "supabase.password":
            case "SUPABASE_PASSWORD":
                return getPassword();
            default:
                String env = System.getenv(key);
                return env != null ? env : PROPERTIES.getProperty(key);
        }
    }

    private static String resolve(String envKey, String propertyKey, String defaultValue) {
        String env = System.getenv(envKey);
        if (env != null && !env.trim().isEmpty()) {
            return env.trim();
        }
        String prop = PROPERTIES.getProperty(propertyKey);
        if (prop != null && !prop.trim().isEmpty()) {
            return prop.trim();
        }
        return defaultValue;
    }
}

package com.miportafolio.config;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DatabaseConfig {

    private static final Logger LOGGER = Logger.getLogger(DatabaseConfig.class.getName());

    private static final String PROPERTIES_FILE = "application.properties";

    // Credenciales por defecto validadas para el Session Pooler de Supabase
    private static final String DEFAULT_URL = "jdbc:postgresql://aws-0-us-west-2.pooler.supabase.com:5432/postgres";
    private static final String DEFAULT_USER = "postgres.hpsyiynzgtetsimzzfyc";
    private static final String DEFAULT_PASS = "samir_1717ssj";
    private static final String DEFAULT_ADMIN_EMAIL = "samircenfe17@gmail.com";

    private static final int LOGIN_TIMEOUT_SECONDS = 10;
    private static final Properties PROPERTIES = new Properties();

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error al cargar el driver JDBC de PostgreSQL", e);
            throw new RuntimeException("Error al cargar el driver JDBC de PostgreSQL.", e);
        }

        try (InputStream in = DatabaseConfig.class.getClassLoader().getResourceAsStream(PROPERTIES_FILE)) {
            if (in != null) {
                PROPERTIES.load(in);
                LOGGER.info("Configuracion cargada exitosamente desde " + PROPERTIES_FILE);
            } else {
                LOGGER.info(PROPERTIES_FILE + " no encontrado en el classpath; usando variables de entorno o valores por defecto.");
            }
        } catch (IOException e) {
            LOGGER.log(Level.WARNING, "No se pudo leer " + PROPERTIES_FILE, e);
        }

        DriverManager.setLoginTimeout(LOGIN_TIMEOUT_SECONDS);
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

    public static String getPassword() {
        return resolve("SUPABASE_PASSWORD", "supabase.password", DEFAULT_PASS);
    }

    public static String getAdminEmail() {
        return resolve("ADMIN_EMAIL", "admin.email", DEFAULT_ADMIN_EMAIL);
    }

    public static String getUploadDirectory() {
        String env = System.getenv("UPLOAD_DIRECTORY");
        if (env != null && !env.trim().isEmpty()) {
            return env.trim();
        }
        String prop = PROPERTIES.getProperty("upload.directory");
        if (prop != null && !prop.trim().isEmpty() && !prop.startsWith("/usr/local")) {
            Path p = Paths.get(prop.trim());
            if (p.isAbsolute()) {
                return p.toString();
            }
        }
        // Si estamos ejecutando dentro de Tomcat, guardar en su carpeta webapps/uploads
        String catalinaBase = System.getProperty("catalina.base");
        if (catalinaBase != null && !catalinaBase.trim().isEmpty()) {
            return Paths.get(catalinaBase, "webapps", "uploads").toAbsolutePath().toString();
        }
        return Paths.get("uploads").toAbsolutePath().toString();
    }

    public static String getProperty(String key) {
        if ("upload.directory".equals(key) || "UPLOAD_DIRECTORY".equals(key)) {
            return getUploadDirectory();
        }
        if ("supabase.url".equals(key) || "SUPABASE_URL".equals(key)) {
            return getUrl();
        }
        if ("supabase.username".equals(key) || "SUPABASE_USERNAME".equals(key)) {
            return getUser();
        }
        if ("supabase.password".equals(key) || "SUPABASE_PASSWORD".equals(key)) {
            return getPassword();
        }
        if ("admin.email".equals(key) || "ADMIN_EMAIL".equals(key)) {
            return getAdminEmail();
        }
        String env = System.getenv(key);
        return env != null ? env : PROPERTIES.getProperty(key);
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
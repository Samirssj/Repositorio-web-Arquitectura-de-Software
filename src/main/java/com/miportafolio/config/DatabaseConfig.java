package com.miportafolio.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConfig {

    private static HikariDataSource dataSource;

    private static Properties properties;


    // =========================================================
    // INICIALIZACIÓN
    // =========================================================

    static {

        try {

            cargarConfiguracion();

            HikariConfig config =
                    new HikariConfig();


            // -------------------------------------------------
            // DATOS DE CONEXIÓN
            // -------------------------------------------------

            String jdbcUrl =
                    obtenerConfiguracion(
                            "SUPABASE_URL",
                            "supabase.url"
                    );

            String username =
                    obtenerConfiguracion(
                            "SUPABASE_USERNAME",
                            "supabase.username"
                    );

            String password =
                    obtenerConfiguracion(
                            "SUPABASE_PASSWORD",
                            "supabase.password"
                    );


            // -------------------------------------------------
            // HIKARI
            // -------------------------------------------------

            config.setJdbcUrl(jdbcUrl);

            config.setUsername(username);

            config.setPassword(password);

            config.setDriverClassName(
                    "org.postgresql.Driver"
            );


            config.setMaximumPoolSize(10);

            config.setMinimumIdle(2);

            config.setIdleTimeout(30000);

            config.setMaxLifetime(1800000);

            config.setConnectionTimeout(10000);


            dataSource =
                    new HikariDataSource(config);


        } catch (Exception e) {

            throw new RuntimeException(
                    "Error al configurar la conexión a Supabase.",
                    e
            );

        }

    }


    // =========================================================
    // CARGAR APPLICATION.PROPERTIES
    // =========================================================

    private static void cargarConfiguracion() {

        properties =
                new Properties();


        try {

            InputStream input =
                    DatabaseConfig.class
                            .getClassLoader()
                            .getResourceAsStream(
                                    "application.properties"
                            );


            if (input != null) {

                properties.load(input);

                input.close();

            }

        } catch (IOException e) {

            throw new RuntimeException(
                    "Error al cargar application.properties",
                    e
            );

        }

    }


    // =========================================================
    // OBTENER CONFIGURACIÓN
    // =========================================================

    private static String obtenerConfiguracion(
            String variableEntorno,
            String propiedad
    ) {


        // -----------------------------------------------------
        // Primero buscamos Environment Variable
        // -----------------------------------------------------

        String valor =
                System.getenv(
                        variableEntorno
                );


        if (
                valor != null &&
                !valor.trim().isEmpty()
        ) {

            return valor.trim();

        }


        // -----------------------------------------------------
        // Si no existe, usamos application.properties
        // -----------------------------------------------------

        if (properties != null) {

            valor =
                    properties.getProperty(
                            propiedad
                    );


            if (
                    valor != null &&
                    !valor.trim().isEmpty() &&
                    !valor.equals("your-password") &&
                    !valor.contains("your-project")
            ) {

                return valor.trim();

            }

        }


        // -----------------------------------------------------
        // No existe configuración
        // -----------------------------------------------------

        throw new RuntimeException(
                "No se encontró la configuración: "
                + variableEntorno
        );

    }


    // =========================================================
    // CONEXIÓN
    // =========================================================

    public static Connection getConnection()
            throws SQLException {

        return dataSource.getConnection();

    }


    // =========================================================
    // CERRAR POOL
    // =========================================================

    public static void closePool() {

        if (
                dataSource != null &&
                !dataSource.isClosed()
        ) {

            dataSource.close();

        }

    }


    // =========================================================
    // OBTENER PROPIEDAD
    // =========================================================

    public static String getProperty(
            String key
    ) {

        // -----------------------------------------------------
        // Variables relacionadas con uploads
        // -----------------------------------------------------

        if (
                key.equals("upload.directory")
        ) {

            String uploadDirectory =
                    System.getenv(
                            "UPLOAD_DIRECTORY"
                    );


            if (
                    uploadDirectory != null &&
                    !uploadDirectory.trim().isEmpty()
            ) {

                return uploadDirectory.trim();

            }

        }


        // -----------------------------------------------------
        // Properties locales
        // -----------------------------------------------------

        if (properties != null) {

            String value =
                    properties.getProperty(key);


            if (
                    value != null &&
                    !value.trim().isEmpty()
            ) {

                return value;

            }

        }


        // -----------------------------------------------------
        // Valores predeterminados
        // -----------------------------------------------------

        if (
                key.equals("upload.directory")
        ) {

            return "/usr/local/tomcat/uploads";

        }


        if (
                key.equals("upload.max.size")
        ) {

            return "10485760";

        }


        return null;

    }

}
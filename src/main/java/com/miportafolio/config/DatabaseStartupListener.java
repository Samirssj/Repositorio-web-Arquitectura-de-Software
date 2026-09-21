package com.miportafolio.config;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Prueba la conexion a Supabase al arrancar la aplicacion y deja en el log
 * de Tomcat un mensaje inequivoco de exito o de la causa del fallo.
 */
@WebListener
public class DatabaseStartupListener implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(DatabaseStartupListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        String sql = "SELECT current_database(), current_user, "
                + "(SELECT count(*) FROM public.usuarios) AS usuarios, "
                + "(SELECT count(*) FROM public.archivos) AS archivos";

        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                LOGGER.info("Conexion a Supabase OK -> db=" + rs.getString(1)
                        + " user=" + rs.getString(2)
                        + " usuarios=" + rs.getLong(3)
                        + " archivos=" + rs.getLong(4));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "NO SE PUDO CONECTAR A SUPABASE. URL=" + DatabaseConfig.getUrl()
                    + " usuario=" + DatabaseConfig.getUser()
                    + " [SQLState=" + e.getSQLState() + "] " + e.getMessage()
                    + " | Si el error es 'Network is unreachable' la red no tiene IPv6: usa la URL del "
                    + "Session Pooler (aws-0-<region>.pooler.supabase.com, usuario postgres.<project-ref>).", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}

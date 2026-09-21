package com.miportafolio.service;

import com.miportafolio.config.DatabaseConfig;
import com.miportafolio.dao.UsuarioDAO;
import com.miportafolio.model.Usuario;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.SQLException;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AuthService {

    private static final Logger LOGGER = Logger.getLogger(AuthService.class.getName());

    /** Unico correo autorizado a tener rol admin (coincide con el CHECK usuarios_admin_reservado). */
    private static final String DEFAULT_ADMIN_EMAIL = "samircenfe17@gmail.com";

    public static final String ROL_ADMIN = "admin";
    public static final String ROL_USUARIO = "usuario";

    private static final String SQLSTATE_UNIQUE_VIOLATION = "23505";
    private static final String SQLSTATE_CHECK_VIOLATION = "23514";
    private static final String SQLSTATE_CLASS_CONNECTION = "08";

    public enum ResultadoRegistro {
        EXITO,
        EMAIL_DUPLICADO,
        ROL_NO_PERMITIDO,
        ERROR_CONEXION,
        ERROR_BD
    }

    private final UsuarioDAO usuarioDAO;
    private final String adminEmail;

    public AuthService() {
        this.usuarioDAO = new UsuarioDAO();
        String configurado = DatabaseConfig.getProperty("ADMIN_EMAIL");
        if (configurado == null || configurado.trim().isEmpty()) {
            configurado = DatabaseConfig.getProperty("admin.email");
        }
        this.adminEmail = normalizarEmail(
                configurado == null || configurado.trim().isEmpty() ? DEFAULT_ADMIN_EMAIL : configurado);
    }

    public static String normalizarEmail(String email) {
        return email == null ? null : email.trim().toLowerCase(Locale.ROOT);
    }

    /** El rol lo decide el servidor: solo el correo reservado obtiene admin. */
    public String rolParaEmail(String email) {
        return adminEmail.equals(normalizarEmail(email)) ? ROL_ADMIN : ROL_USUARIO;
    }

    public ResultadoRegistro registrar(String email, String password, String nombre) {
        String emailNormalizado = normalizarEmail(email);
        String rol = rolParaEmail(emailNormalizado);

        try {
            if (usuarioDAO.buscarPorEmail(emailNormalizado) != null) {
                return ResultadoRegistro.EMAIL_DUPLICADO;
            }

            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            Usuario usuario = new Usuario(emailNormalizado, hashedPassword, nombre.trim(), rol);

            return usuarioDAO.crearUsuario(usuario)
                    ? ResultadoRegistro.EXITO
                    : ResultadoRegistro.ERROR_BD;
        } catch (SQLException e) {
            ResultadoRegistro resultado = clasificar(e);
            LOGGER.log(Level.SEVERE, "Fallo al registrar " + emailNormalizado + " -> " + resultado
                    + " [SQLState=" + e.getSQLState() + "] " + e.getMessage(), e);
            return resultado;
        }
    }

    private static ResultadoRegistro clasificar(SQLException e) {
        String state = e.getSQLState();
        if (SQLSTATE_UNIQUE_VIOLATION.equals(state)) {
            return ResultadoRegistro.EMAIL_DUPLICADO;
        }
        if (SQLSTATE_CHECK_VIOLATION.equals(state)) {
            return ResultadoRegistro.ROL_NO_PERMITIDO;
        }
        if (state == null || state.startsWith(SQLSTATE_CLASS_CONNECTION)) {
            return ResultadoRegistro.ERROR_CONEXION;
        }
        return ResultadoRegistro.ERROR_BD;
    }

    public Usuario autenticar(String email, String password) {
        Usuario usuario;
        try {
            usuario = usuarioDAO.buscarPorEmail(normalizarEmail(email));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Fallo de base de datos al autenticar [SQLState="
                    + e.getSQLState() + "] " + e.getMessage(), e);
            return null;
        }

        if (usuario == null) {
            return null;
        }

        String storedHash = usuario.getPassword();

        if (storedHash == null || storedHash.trim().isEmpty()) {
            return null;
        }

        // jbcrypt solo reconoce $2a$; $2b$ y $2y$ usan el mismo algoritmo
        String normalizedHash = storedHash;
        if (storedHash.startsWith("$2b$") || storedHash.startsWith("$2y$")) {
            normalizedHash = "$2a$" + storedHash.substring(4);
        }

        try {
            if (BCrypt.checkpw(password, normalizedHash)) {
                return usuario;
            }
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Hash BCrypt invalido para " + usuario.getEmail() + ": " + e.getMessage());
        }

        return null;
    }

    public Usuario obtenerUsuarioPorId(Long id) {
        return usuarioDAO.buscarPorId(id);
    }

    public boolean actualizarUsuario(Usuario usuario) {
        return usuarioDAO.actualizarUsuario(usuario);
    }

    public boolean eliminarUsuario(Long id) {
        return usuarioDAO.eliminarUsuario(id);
    }
}

package com.miportafolio.service;

import com.miportafolio.config.DatabaseConfig;
import com.miportafolio.dao.UsuarioDAO;
import com.miportafolio.model.Usuario;
import org.mindrot.jbcrypt.BCrypt;

import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AuthService {
    private static final Logger LOGGER = Logger.getLogger(AuthService.class.getName());
    private UsuarioDAO usuarioDAO;
    private String adminEmail;
    
    public AuthService() {
        this.usuarioDAO = new UsuarioDAO();
        this.adminEmail = DatabaseConfig.getAdminEmail().trim().toLowerCase(Locale.ROOT);
    }
    
    public boolean registrar(String email, String password, String nombre, String rolSolicitado) {
        if (email == null || password == null || nombre == null) {
            return false;
        }

        String emailNormalizado = email.trim().toLowerCase(Locale.ROOT);
        
        // Verificar si el usuario ya existe
        Usuario usuarioExistente = usuarioDAO.buscarPorEmail(emailNormalizado);
        if (usuarioExistente != null) {
            LOGGER.info("Intento de registro con email ya existente: " + emailNormalizado);
            return false;
        }
        
        // El servidor asigna el rol: solo el correo reservado de admin recibe 'admin'
        String rolFinal = adminEmail.equalsIgnoreCase(emailNormalizado) ? "admin" : "usuario";
        
        // Generar hash BCrypt con cost factor 10 ($2a$)
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(10));
        
        Usuario usuario = new Usuario(emailNormalizado, hashedPassword, nombre.trim(), rolFinal);
        return usuarioDAO.crearUsuario(usuario);
    }

    public boolean registrar(String email, String password, String nombre) {
        return registrar(email, password, nombre, "usuario");
    }
    
    public Usuario autenticar(String email, String password) {
        if (email == null || password == null) {
            return null;
        }

        String emailNormalizado = email.trim().toLowerCase(Locale.ROOT);
        Usuario usuario = usuarioDAO.buscarPorEmail(emailNormalizado);
        
        if (usuario == null) {
            return null;
        }
        
        String storedHash = usuario.getPassword();
        if (storedHash == null || storedHash.trim().isEmpty()) {
            return null;
        }
        
        // jbcrypt 0.4 solo acepta la revisión $2a$; normalizamos prefijos $2b$ y $2y$ a $2a$
        String normalizedHash = storedHash;
        if (storedHash.startsWith("$2b$") || storedHash.startsWith("$2y$")) {
            normalizedHash = "$2a$" + storedHash.substring(4);
        }
        
        try {
            if (BCrypt.checkpw(password, normalizedHash)) {
                return usuario;
            }
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Hash BCrypt con formato no estándar para " + emailNormalizado + ": " + e.getMessage());
            // Fallback para contraseñas en texto plano durante pruebas
            if (password.equals(storedHash)) {
                return usuario;
            }
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

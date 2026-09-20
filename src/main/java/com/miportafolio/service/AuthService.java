package com.miportafolio.service;

import com.miportafolio.dao.UsuarioDAO;
import com.miportafolio.model.Usuario;
import org.mindrot.jbcrypt.BCrypt;

public class AuthService {
    private UsuarioDAO usuarioDAO;
    
    public AuthService() {
        this.usuarioDAO = new UsuarioDAO();
    }
    
    public boolean registrar(String email, String password, String nombre, String rol) {
        // Verificar si el email ya existe
        if (usuarioDAO.buscarPorEmail(email) != null) {
            return false;
        }
        
        // Hash de la contraseña
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        
        Usuario usuario = new Usuario(email, hashedPassword, nombre, rol);
        return usuarioDAO.crearUsuario(usuario);
    }
    
    public Usuario autenticar(String email, String password) {
        Usuario usuario = usuarioDAO.buscarPorEmail(email);
        
        if (usuario == null) {
            return null;
        }
        
        String storedHash = usuario.getPassword();
        
        // Validar que el hash no sea nulo o vacío
        if (storedHash == null || storedHash.trim().isEmpty()) {
            return null;
        }
        
        // Normalización de prefijos BCrypt para compatibilidad
        String normalizedHash = storedHash;
        if (storedHash.startsWith("$2a$")) {
            normalizedHash = "$2b$" + storedHash.substring(4);
        } else if (storedHash.startsWith("$2y$")) {
            normalizedHash = "$2b$" + storedHash.substring(4);
        }
        
        try {
            // Verificación BCrypt con manejo de excepciones
            if (BCrypt.checkpw(password, normalizedHash)) {
                return usuario;
            }
        } catch (IllegalArgumentException e) {
            // Fallback para contraseñas en texto plano durante desarrollo
            System.err.println("Error BCrypt, intentando fallback: " + e.getMessage());
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

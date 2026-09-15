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
        
        if (usuario != null && BCrypt.checkpw(password, usuario.getPassword())) {
            return usuario;
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

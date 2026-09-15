package com.miportafolio.dao;

import com.miportafolio.config.DatabaseConfig;
import com.miportafolio.model.Archivo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ArchivoDAO {
    
    public boolean crearArchivo(Archivo archivo) {
        String sql = "INSERT INTO archivos (nombre, descripcion, tipo, url, usuario_id) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, archivo.getNombre());
            stmt.setString(2, archivo.getDescripcion());
            stmt.setString(3, archivo.getTipo());
            stmt.setString(4, archivo.getUrl());
            stmt.setLong(5, archivo.getUsuarioId());
            
            int filasAfectadas = stmt.executeUpdate();
            
            if (filasAfectadas > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        archivo.setId(rs.getLong(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public Archivo buscarPorId(Long id) {
        String sql = "SELECT * FROM archivos WHERE id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapearArchivo(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Archivo> listarPorUsuario(Long usuarioId) {
        String sql = "SELECT * FROM archivos WHERE usuario_id = ? ORDER BY created_at DESC";
        List<Archivo> archivos = new ArrayList<>();
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, usuarioId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                archivos.add(mapearArchivo(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return archivos;
    }
    
    public List<Archivo> listarTodos() {
        String sql = "SELECT * FROM archivos ORDER BY created_at DESC";
        List<Archivo> archivos = new ArrayList<>();
        
        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                archivos.add(mapearArchivo(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return archivos;
    }
    
    public boolean actualizarArchivo(Archivo archivo) {
        String sql = "UPDATE archivos SET nombre = ?, descripcion = ?, tipo = ?, url = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, archivo.getNombre());
            stmt.setString(2, archivo.getDescripcion());
            stmt.setString(3, archivo.getTipo());
            stmt.setString(4, archivo.getUrl());
            stmt.setLong(5, archivo.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean eliminarArchivo(Long id) {
        String sql = "DELETE FROM archivos WHERE id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private Archivo mapearArchivo(ResultSet rs) throws SQLException {
        Archivo archivo = new Archivo();
        archivo.setId(rs.getLong("id"));
        archivo.setNombre(rs.getString("nombre"));
        archivo.setDescripcion(rs.getString("descripcion"));
        archivo.setTipo(rs.getString("tipo"));
        archivo.setUrl(rs.getString("url"));
        archivo.setUsuarioId(rs.getLong("usuario_id"));
        archivo.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        archivo.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return archivo;
    }
}

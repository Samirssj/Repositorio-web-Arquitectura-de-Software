package com.miportafolio.dao;

import com.miportafolio.config.DatabaseConfig;
import com.miportafolio.model.Archivo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ArchivoDAO {
    
    public boolean crearArchivo(Archivo archivo) {
        String sql = "INSERT INTO archivos (nombre, descripcion, tipo, url, usuario_id, semana) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, archivo.getNombre());
            stmt.setString(2, archivo.getDescripcion());
            stmt.setString(3, archivo.getTipo());
            stmt.setString(4, archivo.getUrl());
            stmt.setLong(5, archivo.getUsuarioId());
            stmt.setInt(6, archivo.getSemana());
            
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
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapearArchivo(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // MÉTODO REQUERIDO POR EL SEMANASERVLET
    public List<Archivo> obtenerArchivosPorSemana(int numeroSemana) {
        String sql = "SELECT * FROM archivos WHERE semana = ? ORDER BY created_at DESC";
        List<Archivo> archivos = new ArrayList<>();
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, numeroSemana);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    archivos.add(mapearArchivo(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return archivos;
    }

    public List<Archivo> listarPorUsuario(Long usuarioId) {
        String sql = "SELECT * FROM archivos WHERE usuario_id = ? ORDER BY created_at DESC";
        List<Archivo> archivos = new ArrayList<>();
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, usuarioId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    archivos.add(mapearArchivo(rs));
                }
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
        String sql = "UPDATE archivos SET nombre = ?, descripcion = ?, tipo = ?, url = ?, semana = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, archivo.getNombre());
            stmt.setString(2, archivo.getDescripcion());
            stmt.setString(3, archivo.getTipo());
            stmt.setString(4, archivo.getUrl());
            stmt.setInt(5, archivo.getSemana());
            stmt.setLong(6, archivo.getId());
            
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

    public java.util.Map<Integer, Integer> contarArchivosPorTodasLasSemanas() {
        String sql = "SELECT semana, COUNT(*) FROM archivos GROUP BY semana";
        java.util.Map<Integer, Integer> conteo = new java.util.HashMap<>();
        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                conteo.put(rs.getInt(1), rs.getInt(2));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return conteo;
    }
    
    private Archivo mapearArchivo(ResultSet rs) throws SQLException {
        Archivo archivo = new Archivo();
        archivo.setId(rs.getLong("id"));
        archivo.setNombre(rs.getString("nombre"));
        archivo.setDescripcion(rs.getString("descripcion"));
        archivo.setTipo(rs.getString("tipo"));
        archivo.setUrl(rs.getString("url"));
        archivo.setUsuarioId(rs.getLong("usuario_id"));
        
        // Manejo de la columna semana (si existe en el ResultSet)
        try {
            archivo.setSemana(rs.getInt("semana"));
        } catch (SQLException e) {
            archivo.setSemana(1); // Valor por defecto si no está presente
        }

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            archivo.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            archivo.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return archivo;
    }
}
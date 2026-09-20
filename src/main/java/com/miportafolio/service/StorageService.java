package com.miportafolio.service;

import com.miportafolio.config.DatabaseConfig;
import com.miportafolio.dao.ArchivoDAO;
import com.miportafolio.model.Archivo;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

public class StorageService {
    private ArchivoDAO archivoDAO;
    private String uploadDirectory;
    
    public StorageService() {
        this.archivoDAO = new ArchivoDAO();
        this.uploadDirectory = DatabaseConfig.getProperty("upload.directory");
        
        // Crear directorio de uploads si no existe
        if (this.uploadDirectory != null && !this.uploadDirectory.trim().isEmpty()) {
            File uploadDir = new File(this.uploadDirectory);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
        }
    }
    
    // Método principal con el parámetro semana
    public Archivo guardarArchivo(String nombre, String descripcion, String tipo, Path filePath, Long usuarioId, int semana) {
        Archivo archivo = new Archivo();
        archivo.setNombre(nombre);
        archivo.setDescripcion(descripcion);
        archivo.setTipo(tipo);
        archivo.setUrl("uploads/" + filePath.getFileName().toString());
        archivo.setUsuarioId(usuarioId);
        archivo.setSemana(semana);

        boolean guardado = archivoDAO.crearArchivo(archivo);
        return guardado ? archivo : null;
    }

    // Sobrecarga por defecto (por si se invoca sin indicar la semana)
    public Archivo guardarArchivo(String nombre, String descripcion, String tipo, Path filePath, Long usuarioId) {
        return guardarArchivo(nombre, descripcion, tipo, filePath, usuarioId, 1);
    }
    
    public Archivo obtenerArchivo(Long id) {
        return archivoDAO.buscarPorId(id);
    }
    
    public List<Archivo> listarArchivosPorUsuario(Long usuarioId) {
        return archivoDAO.listarPorUsuario(usuarioId);
    }
    
    public List<Archivo> listarTodosArchivos() {
        return archivoDAO.listarTodos();
    }
    
    public boolean actualizarArchivo(Archivo archivo) {
        return archivoDAO.actualizarArchivo(archivo);
    }
    
    public boolean eliminarArchivo(Long id) throws IOException {
        Archivo archivo = archivoDAO.buscarPorId(id);
        
        if (archivo != null) {
            // Se limpia 'uploads/' de la URL guardada de forma segura
            String nombreArchivo = archivo.getUrl().replace("uploads/", "").replace("/uploads/", "");
            
            if (this.uploadDirectory != null && !this.uploadDirectory.trim().isEmpty()) {
                Path rutaArchivo = Paths.get(uploadDirectory, nombreArchivo);
                Files.deleteIfExists(rutaArchivo);
            }
            
            // Eliminar registro de la base de datos Supabase
            return archivoDAO.eliminarArchivo(id);
        }
        
        return false;
    }
    
    public Path obtenerRutaArchivo(String url) {
        if (url == null) return null;
        String nombreArchivo = url.replace("uploads/", "").replace("/uploads/", "");
        return Paths.get(uploadDirectory, nombreArchivo);
    }

    private String obtenerExtension(String nombreArchivo) {
        int puntoIndex = nombreArchivo.lastIndexOf('.');
        if (puntoIndex > 0) {
            return nombreArchivo.substring(puntoIndex);
        }
        return "";
    }
}
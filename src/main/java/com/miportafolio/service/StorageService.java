package com.miportafolio.service;

import com.miportafolio.config.DatabaseConfig;
import com.miportafolio.dao.ArchivoDAO;
import com.miportafolio.model.Archivo;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

public class StorageService {
    private ArchivoDAO archivoDAO;
    private String uploadDirectory;
    
    public StorageService() {
        this.archivoDAO = new ArchivoDAO();
        this.uploadDirectory = DatabaseConfig.getProperty("upload.directory");
        
        // Crear directorio de uploads si no existe
        File uploadDir = new File(uploadDirectory);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
    }
    
    public Archivo guardarArchivo(String nombreOriginal, String descripcion, String tipo, 
                                   Path rutaArchivo, Long usuarioId) throws IOException {
        // Generar nombre único
        String extension = obtenerExtension(nombreOriginal);
        String nombreUnico = UUID.randomUUID().toString() + extension;
        
        // Copiar archivo al directorio de uploads
        Path rutaDestino = Paths.get(uploadDirectory, nombreUnico);
        Files.copy(rutaArchivo, rutaDestino, StandardCopyOption.REPLACE_EXISTING);
        
        // Crear objeto Archivo
        Archivo archivo = new Archivo();
        archivo.setNombre(nombreOriginal);
        archivo.setDescripcion(descripcion);
        archivo.setTipo(tipo);
        archivo.setUrl("/uploads/" + nombreUnico);
        archivo.setUsuarioId(usuarioId);
        
        // Guardar en base de datos
        if (archivoDAO.crearArchivo(archivo)) {
            return archivo;
        }
        
        // Si falla, eliminar el archivo
        Files.deleteIfExists(rutaDestino);
        return null;
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
            // Eliminar archivo del sistema
            String nombreArchivo = archivo.getUrl().replace("/uploads/", "");
            Path rutaArchivo = Paths.get(uploadDirectory, nombreArchivo);
            Files.deleteIfExists(rutaArchivo);
            
            // Eliminar de base de datos
            return archivoDAO.eliminarArchivo(id);
        }
        
        return false;
    }
    
    private String obtenerExtension(String nombreArchivo) {
        int puntoIndex = nombreArchivo.lastIndexOf('.');
        if (puntoIndex > 0) {
            return nombreArchivo.substring(puntoIndex);
        }
        return "";
    }
    
    public Path obtenerRutaArchivo(String url) {
        String nombreArchivo = url.replace("/uploads/", "");
        return Paths.get(uploadDirectory, nombreArchivo);
    }
}

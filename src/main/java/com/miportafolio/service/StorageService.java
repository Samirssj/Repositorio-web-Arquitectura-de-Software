package com.miportafolio.service;

import com.miportafolio.config.DatabaseConfig;
import com.miportafolio.dao.ArchivoDAO;
import com.miportafolio.model.Archivo;
import com.miportafolio.model.ArchivoContenido;

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
        this.uploadDirectory = DatabaseConfig.getUploadDirectory();
        
        // Crear directorio de uploads si no existe
        if (this.uploadDirectory != null && !this.uploadDirectory.trim().isEmpty()) {
            File uploadDir = new File(this.uploadDirectory);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
        }
    }

    public Path getUploadDirectoryPath() {
        return Paths.get(this.uploadDirectory);
    }
    
    // Método principal con soporte binario persistente en Supabase PostgreSQL
    public Archivo guardarArchivo(String nombre, String descripcion, String tipo, Path filePath, Long usuarioId, int semana, byte[] fileBytes, String mimeType) {
        Archivo archivo = new Archivo();
        archivo.setNombre(nombre);
        archivo.setDescripcion(descripcion);
        archivo.setTipo(tipo);
        archivo.setUrl("uploads/" + (filePath != null ? filePath.getFileName().toString() : System.currentTimeMillis() + ".dat"));
        archivo.setUsuarioId(usuarioId);
        archivo.setSemana(semana);

        boolean guardado = archivoDAO.crearArchivo(archivo);
        if (guardado && archivo.getId() != null) {
            byte[] bytesToSave = fileBytes;
            if (bytesToSave == null && filePath != null && Files.exists(filePath)) {
                try {
                    bytesToSave = Files.readAllBytes(filePath);
                } catch (IOException ignored) {}
            }
            if (bytesToSave != null) {
                archivoDAO.guardarContenido(archivo.getId(), bytesToSave, mimeType);
            }
            return archivo;
        }
        return null;
    }

    // Sobrecarga estándar (lee del archivo en disco para persistir también en base de datos)
    public Archivo guardarArchivo(String nombre, String descripcion, String tipo, Path filePath, Long usuarioId, int semana) {
        byte[] fileBytes = null;
        if (filePath != null && Files.exists(filePath)) {
            try {
                fileBytes = Files.readAllBytes(filePath);
            } catch (IOException ignored) {}
        }
        return guardarArchivo(nombre, descripcion, tipo, filePath, usuarioId, semana, fileBytes, null);
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

    public ArchivoContenido obtenerContenido(Long archivoId) {
        return archivoDAO.obtenerContenido(archivoId);
    }

    public boolean guardarContenido(Long archivoId, byte[] datos, String mimeType) {
        return archivoDAO.guardarContenido(archivoId, datos, mimeType);
    }
    
    public boolean eliminarArchivo(Long id) throws IOException {
        Archivo archivo = archivoDAO.buscarPorId(id);
        
        if (archivo != null) {
            Path rutaArchivo = obtenerRutaArchivo(archivo.getUrl());
            if (rutaArchivo != null) {
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

    public String obtenerExtension(String nombreArchivo) {
        if (nombreArchivo == null) return "";
        int puntoIndex = nombreArchivo.lastIndexOf('.');
        if (puntoIndex > 0) {
            return nombreArchivo.substring(puntoIndex);
        }
        return "";
    }
}
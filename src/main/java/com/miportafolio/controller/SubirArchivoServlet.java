package com.miportafolio.controller;

import com.miportafolio.model.Usuario;
import com.miportafolio.service.StorageService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

@WebServlet("/subir-archivo")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize = 10 * 1024 * 1024,        // 10 MB
    maxRequestSize = 15 * 1024 * 1024      // 15 MB
)
public class SubirArchivoServlet extends HttpServlet {
    private StorageService storageService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        storageService = new StorageService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        try {
            request.setCharacterEncoding("UTF-8");
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            String tipo = request.getParameter("tipo");
            
            // Captura y validación de la semana académica
            String semanaParam = request.getParameter("semana");
            int semana = 1;
            if (semanaParam != null && !semanaParam.trim().isEmpty()) {
                try {
                    semana = Integer.parseInt(semanaParam.trim());
                } catch (NumberFormatException e) {
                    semana = 1;
                }
            }
            
            Part filePart = request.getPart("archivo");
            String fileName = (filePart != null) ? filePart.getSubmittedFileName() : null;
            
            if (fileName != null && !fileName.trim().isEmpty()) {
                // Limpiar nombre de archivo (evitar directory traversal)
                fileName = new File(fileName).getName();
                
                // Usar directorio centralizado gestionado por StorageService
                Path uploadDirPath = storageService.getUploadDirectoryPath();
                File uploadDirFile = uploadDirPath.toFile();
                if (!uploadDirFile.exists()) {
                    uploadDirFile.mkdirs();
                }
                
                // Guardar archivo en disco
                Path filePath = uploadDirPath.resolve(fileName);
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
                }
                
                if (nombre == null || nombre.trim().isEmpty()) {
                    nombre = fileName;
                }
                if (tipo == null || tipo.trim().isEmpty()) {
                    tipo = obtenerTipoPorExtension(fileName);
                }
                
                // Guardado en la base de datos Supabase
                var archivo = storageService.guardarArchivo(
                    nombre, 
                    descripcion != null ? descripcion : "", 
                    tipo != null ? tipo : "otro", 
                    filePath, 
                    usuario.getId(),
                    semana
                );
                
                if (archivo != null) {
                    response.sendRedirect(request.getContextPath() + "/dashboard.jsp?mensaje=archivo_subido");
                } else {
                    request.setAttribute("error", "Error al guardar el registro del archivo en la base de datos.");
                    request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "No se seleccionó ningún archivo para subir.");
                request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error del servidor al subir archivo: " + e.getMessage());
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
        }
    }
    
    private String obtenerTipoPorExtension(String nombreArchivo) {
        String extension = nombreArchivo.toLowerCase();
        if (extension.endsWith(".jpg") || extension.endsWith(".jpeg") || extension.endsWith(".png") || extension.endsWith(".gif") || extension.endsWith(".webp")) {
            return "imagen";
        } else if (extension.endsWith(".pdf")) {
            return "pdf";
        } else if (extension.endsWith(".doc") || extension.endsWith(".docx") || extension.endsWith(".txt")) {
            return "documento";
        }
        return "otro";
    }
}
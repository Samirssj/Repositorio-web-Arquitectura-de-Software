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

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/subir-archivo")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize = 30 * 1024 * 1024,        // 30 MB por archivo
    maxRequestSize = 100 * 1024 * 1024     // 100 MB tamaño total lote
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
            
            // Recoger todas las partes que correspondan a archivos cargados
            List<Part> fileParts = new ArrayList<>();
            for (Part part : request.getParts()) {
                if (part != null && part.getSubmittedFileName() != null && !part.getSubmittedFileName().trim().isEmpty()) {
                    fileParts.add(part);
                }
            }
            
            if (fileParts.isEmpty()) {
                request.setAttribute("error", "No se seleccionó ningún archivo para subir. Por favor selecciona uno o más archivos.");
                request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
                return;
            }
            
            // Usar directorio centralizado gestionado por StorageService
            Path uploadDirPath = storageService.getUploadDirectoryPath();
            File uploadDirFile = uploadDirPath.toFile();
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs();
            }
            
            int archivosGuardados = 0;
            boolean multipleArchivos = fileParts.size() > 1;
            
            for (Part filePart : fileParts) {
                String originalFileName = new File(filePart.getSubmittedFileName()).getName();
                if (originalFileName.trim().isEmpty()) {
                    continue;
                }
                
                // Nombre limpio y libre de colisiones en disco
                String cleanName = originalFileName.replaceAll("[^a-zA-Z0-9._-]", "_");
                String uniqueDiskName = System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 6) + "_" + cleanName;
                
                // Guardar archivo en disco
                Path filePath = uploadDirPath.resolve(uniqueDiskName);
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
                }
                
                // Determinar el nombre/título para mostrar
                String baseName = originalFileName;
                int dotIdx = originalFileName.lastIndexOf('.');
                if (dotIdx > 0) {
                    baseName = originalFileName.substring(0, dotIdx);
                }
                
                String itemNombre;
                if (nombre != null && !nombre.trim().isEmpty()) {
                    if (multipleArchivos) {
                        itemNombre = nombre.trim() + " - " + baseName;
                    } else {
                        itemNombre = nombre.trim();
                    }
                } else {
                    itemNombre = baseName;
                }
                
                // Determinar el tipo de archivo (auto por extensión o por selección)
                String itemTipo = obtenerTipoPorExtension(originalFileName);
                if (tipo != null && !tipo.trim().isEmpty() && !"auto".equalsIgnoreCase(tipo) && !multipleArchivos) {
                    itemTipo = tipo;
                }
                
                // Guardado en la base de datos Supabase
                var archivo = storageService.guardarArchivo(
                    itemNombre, 
                    descripcion != null ? descripcion : "", 
                    itemTipo, 
                    filePath, 
                    usuario.getId(),
                    semana
                );
                
                if (archivo != null) {
                    archivosGuardados++;
                }
            }
            
            if (archivosGuardados > 0) {
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp?mensaje=archivos_subidos&count=" + archivosGuardados + "&semana=" + semana);
            } else {
                request.setAttribute("error", "Error al registrar los archivos en la base de datos.");
                request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error del servidor al subir archivos: " + e.getMessage());
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
        }
    }
    
    private String obtenerTipoPorExtension(String nombreArchivo) {
        String extension = nombreArchivo.toLowerCase();
        if (extension.endsWith(".jpg") || extension.endsWith(".jpeg") || extension.endsWith(".png") || extension.endsWith(".gif") || extension.endsWith(".webp") || extension.endsWith(".svg")) {
            return "imagen";
        } else if (extension.endsWith(".pdf")) {
            return "pdf";
        } else if (extension.endsWith(".doc") || extension.endsWith(".docx") || extension.endsWith(".txt") || extension.endsWith(".xls") || extension.endsWith(".xlsx") || extension.endsWith(".ppt") || extension.endsWith(".pptx")) {
            return "documento";
        }
        return "otro";
    }
}
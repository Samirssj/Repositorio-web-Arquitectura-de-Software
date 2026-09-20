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
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@WebServlet("/subir-archivo")
@MultipartConfig
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
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        try {
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            String tipo = request.getParameter("tipo");
            
            // CAPTURA Y VALIDACIÓN DE LA SEMANA
            String semanaParam = request.getParameter("semana");
            int semana = 1; // Valor predeterminado
            if (semanaParam != null && !semanaParam.trim().isEmpty()) {
                try {
                    semana = Integer.parseInt(semanaParam.trim());
                } catch (NumberFormatException e) {
                    semana = 1;
                }
            }
            
            Part filePart = request.getPart("archivo");
            String fileName = filePart.getSubmittedFileName();
            
            if (fileName != null && !fileName.isEmpty()) {
                // Crear directorio de uploads si no existe
                String uploadDir = getServletContext().getRealPath("/uploads");
                File uploadDirFile = new File(uploadDir);
                if (!uploadDirFile.exists()) {
                    uploadDirFile.mkdirs();
                }
                
                // Guardar archivo en disco
                Path filePath = Paths.get(uploadDir, fileName);
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
                }
                
                if (nombre == null || nombre.trim().isEmpty()) {
                    nombre = fileName;
                }
                if (tipo == null || tipo.trim().isEmpty()) {
                    tipo = obtenerTipoPorExtension(fileName);
                }
                
                // GUARDADO CON LA SEMANA INCLUIDA
                var archivo = storageService.guardarArchivo(
                    nombre, 
                    descripcion != null ? descripcion : "", 
                    tipo != null ? tipo : "otro", 
                    filePath, 
                    usuario.getId(),
                    semana // <--- Pasa el entero de la semana
                );
                
                if (archivo != null) {
                    response.sendRedirect("dashboard.jsp?mensaje=archivo_subido");
                } else {
                    request.setAttribute("error", "Error al guardar el archivo en la base de datos.");
                    request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "No se seleccionó ningún archivo.");
                request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error del servidor: " + e.getMessage());
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
        }
    }
    
    private String obtenerTipoPorExtension(String nombreArchivo) {
        String extension = nombreArchivo.toLowerCase();
        if (extension.endsWith(".jpg") || extension.endsWith(".jpeg") || extension.endsWith(".png")) {
            return "imagen";
        } else if (extension.endsWith(".pdf")) {
            return "pdf";
        } else if (extension.endsWith(".doc") || extension.endsWith(".docx")) {
            return "documento";
        }
        return "otro";
    }

}
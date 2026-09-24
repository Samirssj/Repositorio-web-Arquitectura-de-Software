package com.miportafolio.controller;

import com.miportafolio.model.Archivo;
import com.miportafolio.model.Usuario;
import com.miportafolio.service.StorageService;
import com.miportafolio.util.SessionUtil;
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
import java.util.UUID;

@WebServlet("/editar-archivo")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize = 30 * 1024 * 1024,        // 30 MB
    maxRequestSize = 50 * 1024 * 1024      // 50 MB
)
public class EditarArchivoServlet extends HttpServlet {
    private StorageService storageService;

    @Override
    public void init() throws ServletException {
        super.init();
        storageService = new StorageService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Usuario usuario = SessionUtil.getUsuarioAutenticado(request);
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=sesion_requerida");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            return;
        }

        try {
            Long id = Long.parseLong(idParam.trim());
            Archivo archivo = storageService.obtenerArchivo(id);
            if (archivo != null) {
                request.setAttribute("archivo", archivo);
                request.getRequestDispatcher("/editar_trabajo.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=archivo_no_encontrado");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Usuario usuario = SessionUtil.getUsuarioAutenticado(request);
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=sesion_requerida");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=id_invalido");
            return;
        }

        try {
            Long id = Long.parseLong(idParam.trim());
            Archivo archivo = storageService.obtenerArchivo(id);
            if (archivo == null) {
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=archivo_no_encontrado");
                return;
            }

            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            String semanaParam = request.getParameter("semana");
            String tipo = request.getParameter("tipo");

            if (nombre != null && !nombre.trim().isEmpty()) {
                archivo.setNombre(nombre.trim());
            }

            if (descripcion != null) {
                archivo.setDescripcion(descripcion.trim());
            }

            if (semanaParam != null && !semanaParam.trim().isEmpty()) {
                try {
                    int semana = Integer.parseInt(semanaParam.trim());
                    if (semana >= 1 && semana <= 16) {
                        archivo.setSemana(semana);
                    }
                } catch (NumberFormatException e) {
                    // Mantener semana actual
                }
            }

            // Manejo de reemplazo de archivo si el usuario subió uno nuevo
            Part filePart = null;
            try {
                filePart = request.getPart("nuevoArchivo");
            } catch (Exception ignored) {}

            byte[] newFileBytes = null;
            String newContentType = null;
            if (filePart != null && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().trim().isEmpty()) {
                String originalFileName = new File(filePart.getSubmittedFileName()).getName();
                String cleanName = originalFileName.replaceAll("[^a-zA-Z0-9._-]", "_");
                String uniqueDiskName = System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 6) + "_" + cleanName;

                try (InputStream input = filePart.getInputStream()) {
                    newFileBytes = input.readAllBytes();
                }
                newContentType = filePart.getContentType();

                Path uploadDirPath = storageService.getUploadDirectoryPath();
                Path newFilePath = uploadDirPath.resolve(uniqueDiskName);

                try {
                    Files.write(newFilePath, newFileBytes);
                } catch (Exception ignored) {}

                // Actualizar la URL relativa en la base de datos
                archivo.setUrl("uploads/" + uniqueDiskName);

                // Si el tipo es automático, calcularlo por la nueva extensión
                if (tipo == null || tipo.trim().isEmpty() || "auto".equalsIgnoreCase(tipo)) {
                    archivo.setTipo(obtenerTipoPorExtension(originalFileName));
                } else {
                    archivo.setTipo(tipo);
                }
            } else {
                // No se reemplazó el archivo; actualizar tipo si se seleccionó uno explícito distinto de auto
                if (tipo != null && !tipo.trim().isEmpty() && !"auto".equalsIgnoreCase(tipo)) {
                    archivo.setTipo(tipo);
                }
            }

            boolean actualizado = storageService.actualizarArchivo(archivo);
            if (actualizado) {
                if (newFileBytes != null) {
                    storageService.guardarContenido(archivo.getId(), newFileBytes, newContentType);
                }
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp?mensaje=archivo_editado&semana=" + archivo.getSemana());
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=error_al_actualizar");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    private String obtenerTipoPorExtension(String nombreArchivo) {
        String extension = nombreArchivo.toLowerCase();
        if (extension.endsWith(".jpg") || extension.endsWith(".jpeg") || extension.endsWith(".png") || extension.endsWith(".gif") || extension.endsWith(".webp") || extension.endsWith(".svg")) {
            return "imagen";
        } else if (extension.endsWith(".pdf")) {
            return "pdf";
        } else if (extension.endsWith(".doc") || extension.endsWith(".docx") || extension.endsWith(".txt") || extension.endsWith(".xls") || extension.endsWith(".xlsx") || extension.endsWith(".ppt") || extension.endsWith(".pptx") || extension.endsWith(".zip") || extension.endsWith(".rar") || extension.endsWith(".7z") || extension.endsWith(".java") || extension.endsWith(".py") || extension.endsWith(".c") || extension.endsWith(".cpp") || extension.endsWith(".sql") || extension.endsWith(".md")) {
            return "documento";
        }
        return "documento";
    }
}

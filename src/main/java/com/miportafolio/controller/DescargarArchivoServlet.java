package com.miportafolio.controller;

import com.miportafolio.model.Archivo;
import com.miportafolio.model.ArchivoContenido;
import com.miportafolio.service.StorageService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet("/descargar-archivo")
public class DescargarArchivoServlet extends HttpServlet {
    private StorageService storageService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        storageService = new StorageService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de archivo no proporcionado.");
            return;
        }

        try {
            Long id = Long.parseLong(idParam.trim());
            Archivo archivo = storageService.obtenerArchivo(id);
            
            if (archivo == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Registro de archivo no encontrado.");
                return;
            }

            byte[] bytes = null;
            String mimeType = null;
            Path rutaArchivo = storageService.obtenerRutaArchivo(archivo.getUrl());

            // 1. Intentar servir desde el sistema de archivos local / caché
            if (rutaArchivo != null && Files.exists(rutaArchivo)) {
                try {
                    bytes = Files.readAllBytes(rutaArchivo);
                } catch (IOException ignored) {}
            }

            // 2. Si no está en webapps/uploads, buscar en el contexto WAR (src/main/webapp/uploads)
            if (bytes == null && archivo.getUrl() != null) {
                try {
                    String contextPath = getServletContext().getRealPath("/" + archivo.getUrl());
                    if (contextPath != null) {
                        Path pContext = Paths.get(contextPath);
                        if (Files.exists(pContext)) {
                            bytes = Files.readAllBytes(pContext);
                        }
                    }
                } catch (Exception ignored) {}
            }

            // 3. Si no existe físicamente en el servidor (ej: despliegue en Vercel/Docker),
            // recuperar los bytes directamente de Supabase PostgreSQL (archivo_contenido)
            if (bytes == null) {
                ArchivoContenido contenido = storageService.obtenerContenido(id);
                if (contenido != null && contenido.getDatos() != null && contenido.getDatos().length > 0) {
                    bytes = contenido.getDatos();
                    mimeType = contenido.getMimeType();

                    // Guardar en la caché del disco local si la carpeta es escribible
                    if (rutaArchivo != null) {
                        try {
                            if (rutaArchivo.getParent() != null && !Files.exists(rutaArchivo.getParent())) {
                                Files.createDirectories(rutaArchivo.getParent());
                            }
                            Files.write(rutaArchivo, bytes);
                        } catch (Exception ignored) {}
                    }
                }
            }

            // Si no se encontró ni en disco ni en base de datos
            if (bytes == null || bytes.length == 0) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "El archivo físico no se encuentra disponible en el servidor ni en la base de datos.");
                return;
            }

            // Determinar MIME type
            if (mimeType == null || mimeType.trim().isEmpty() || "application/octet-stream".equals(mimeType)) {
                mimeType = getServletContext().getMimeType(archivo.getUrl());
                if (mimeType == null) {
                    mimeType = getServletContext().getMimeType(archivo.getNombre());
                }
                if (mimeType == null) {
                    if ("imagen".equalsIgnoreCase(archivo.getTipo())) {
                        String ext = storageService.obtenerExtension(archivo.getUrl()).toLowerCase();
                        if (ext.contains("png")) mimeType = "image/png";
                        else if (ext.contains("webp")) mimeType = "image/webp";
                        else if (ext.contains("gif")) mimeType = "image/gif";
                        else if (ext.contains("svg")) mimeType = "image/svg+xml";
                        else mimeType = "image/jpeg";
                    } else if ("pdf".equalsIgnoreCase(archivo.getTipo())) {
                        mimeType = "application/pdf";
                    } else {
                        mimeType = "application/octet-stream";
                    }
                }
            }

            response.setContentType(mimeType);

            // Preparar nombre de archivo con extensión apropiada para descarga
            String nombreDescarga = archivo.getNombre().replace("\"", "").trim();
            String extension = storageService.obtenerExtension(archivo.getUrl());
            if (extension != null && !extension.trim().isEmpty() && !nombreDescarga.toLowerCase().endsWith(extension.toLowerCase())) {
                nombreDescarga += extension;
            }

            // Determinar si es inline o attachment
            String modo = request.getParameter("modo");
            String disposition = "inline";
            if ("descargar".equalsIgnoreCase(modo)) {
                disposition = "attachment";
            } else if (!mimeType.startsWith("image/") && !mimeType.equals("application/pdf")) {
                disposition = "attachment";
            }

            response.setHeader("Content-Disposition", disposition + "; filename=\"" + java.net.URLEncoder.encode(nombreDescarga, "UTF-8").replace("+", "%20") + "\"; filename*=UTF-8''" + java.net.URLEncoder.encode(nombreDescarga, "UTF-8").replace("+", "%20"));
            response.setHeader("Cache-Control", "public, max-age=86400");
            response.setContentLength(bytes.length);

            try (OutputStream out = response.getOutputStream()) {
                out.write(bytes);
                out.flush();
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Identificador de archivo inválido.");
        }
    }
}

package com.miportafolio.controller;

import com.miportafolio.model.Archivo;
import com.miportafolio.service.StorageService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;

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
            
            if (archivo != null) {
                Path rutaArchivo = storageService.obtenerRutaArchivo(archivo.getUrl());
                
                if (rutaArchivo != null && Files.exists(rutaArchivo)) {
                    String mimeType = getServletContext().getMimeType(archivo.getNombre());
                    if (mimeType == null) {
                        if ("pdf".equalsIgnoreCase(archivo.getTipo())) {
                            mimeType = "application/pdf";
                        } else if ("imagen".equalsIgnoreCase(archivo.getTipo())) {
                            mimeType = "image/jpeg";
                        } else {
                            mimeType = "application/octet-stream";
                        }
                    }
                    response.setContentType(mimeType);
                    
                    // Si se solicita expresamente descargar o no es visualizable inline
                    String modo = request.getParameter("modo");
                    String disposition = "inline";
                    if ("descargar".equalsIgnoreCase(modo)) {
                        disposition = "attachment";
                    } else if (!mimeType.startsWith("image/") && !mimeType.equals("application/pdf")) {
                        disposition = "attachment";
                    }

                    response.setHeader("Content-Disposition", 
                        disposition + "; filename=\"" + archivo.getNombre().replace("\"", "") + "\"");
                    response.setContentLengthLong(Files.size(rutaArchivo));
                    
                    try (OutputStream out = response.getOutputStream()) {
                        Files.copy(rutaArchivo, out);
                        out.flush();
                    }
                    return;
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "El archivo físico no se encuentra disponible en el servidor.");
                    return;
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Registro de archivo no encontrado.");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Identificador de archivo inválido.");
        }
    }
}

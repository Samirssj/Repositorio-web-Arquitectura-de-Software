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
        Long id = Long.parseLong(request.getParameter("id"));
        
        Archivo archivo = storageService.obtenerArchivo(id);
        
        if (archivo != null) {
            Path rutaArchivo = storageService.obtenerRutaArchivo(archivo.getUrl());
            
            if (Files.exists(rutaArchivo)) {
                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition", 
                    "attachment; filename=\"" + archivo.getNombre() + "\"");
                
                try (OutputStream out = response.getOutputStream()) {
                    Files.copy(rutaArchivo, out);
                    out.flush();
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Archivo no encontrado");
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Archivo no encontrado");
        }
    }
}

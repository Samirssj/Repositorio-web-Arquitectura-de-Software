package com.miportafolio.controller;

import com.miportafolio.model.Archivo;
import com.miportafolio.model.Usuario;
import com.miportafolio.service.StorageService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

@WebServlet("/archivos")
public class ArchivoServlet extends HttpServlet {
    private StorageService storageService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        storageService = new StorageService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        String action = request.getParameter("action");
        
        if ("listar".equals(action)) {
            List<Archivo> archivos = storageService.listarArchivosPorUsuario(usuario.getId());
            request.setAttribute("archivos", archivos);
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
        } else if ("ver".equals(action)) {
            Long id = Long.parseLong(request.getParameter("id"));
            Archivo archivo = storageService.obtenerArchivo(id);
            
            if (archivo != null) {
                request.setAttribute("archivo", archivo);
                request.getRequestDispatcher("/archivo_detalle.jsp").forward(request, response);
            } else {
                response.sendRedirect("dashboard?error=archivo_no_encontrado");
            }
        } else {
            List<Archivo> archivos = storageService.listarArchivosPorUsuario(usuario.getId());
            request.setAttribute("archivos", archivos);
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
        }
    }
}

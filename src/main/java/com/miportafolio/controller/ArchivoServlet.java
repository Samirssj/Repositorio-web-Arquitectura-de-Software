package com.miportafolio.controller;

import com.miportafolio.model.Archivo;
import com.miportafolio.model.Usuario;
import com.miportafolio.service.StorageService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
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
            response.sendRedirect("login.jsp");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String action = request.getParameter("action");
        
        if ("eliminar".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                try {
                    Long id = Long.parseLong(idParam);
                    storageService.eliminarArchivo(id);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect("dashboard.jsp");
            return;
        } 
        
        if ("ver".equals(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                Archivo archivo = storageService.obtenerArchivo(id);
                
                if (archivo != null) {
                    request.setAttribute("archivo", archivo);
                    request.getRequestDispatcher("/archivo_detalle.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
            response.sendRedirect("dashboard.jsp?error=archivo_no_encontrado");
            return;
        }
        
        // Por defecto: Listar archivos y redirigir al panel de administración
        List<Archivo> archivos;
        if ("admin".equalsIgnoreCase(usuario.getRol())) {
            archivos = storageService.listarTodosArchivos();
        } else {
            archivos = storageService.listarArchivosPorUsuario(usuario.getId());
        }
        request.setAttribute("archivos", archivos);
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
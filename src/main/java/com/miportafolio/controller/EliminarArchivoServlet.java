package com.miportafolio.controller;

import com.miportafolio.service.StorageService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/eliminar-archivo")
public class EliminarArchivoServlet extends HttpServlet {
    private StorageService storageService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        storageService = new StorageService();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login");
            return;
        }
        
        Long id = Long.parseLong(request.getParameter("id"));
        
        try {
            boolean eliminado = storageService.eliminarArchivo(id);
            
            if (eliminado) {
                response.sendRedirect("dashboard?mensaje=archivo_eliminado");
            } else {
                response.sendRedirect("dashboard?error=no_se_pudo_eliminar");
            }
        } catch (IOException e) {
            e.printStackTrace();
            response.sendRedirect("dashboard?error=error_al_eliminar");
        }
    }
}

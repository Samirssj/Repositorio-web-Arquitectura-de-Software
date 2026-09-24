package com.miportafolio.controller;

import com.miportafolio.model.Usuario;
import com.miportafolio.service.StorageService;
import com.miportafolio.util.SessionUtil;
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
        Usuario usuario = SessionUtil.getUsuarioAutenticado(request);
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=sesion_requerida");
            return;
        }
        
        Long id = Long.parseLong(request.getParameter("id"));
        
        try {
            boolean eliminado = storageService.eliminarArchivo(id);
            
            if (eliminado) {
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp?mensaje=archivo_eliminado");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=no_se_pudo_eliminar");
            }
        } catch (IOException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=error_al_eliminar");
        }
    }
}


package com.miportafolio.controller;

import com.miportafolio.model.Archivo;
import com.miportafolio.model.Usuario;
import com.miportafolio.service.StorageService;
import com.miportafolio.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
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


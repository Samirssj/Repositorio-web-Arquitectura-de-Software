package com.miportafolio.controller;

import com.miportafolio.model.Archivo;
import com.miportafolio.model.Usuario;
import com.miportafolio.service.StorageService;
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

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        List<Archivo> archivos = storageService.listarArchivosPorUsuario(usuario.getId());

        request.setAttribute("archivos", archivos);
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}

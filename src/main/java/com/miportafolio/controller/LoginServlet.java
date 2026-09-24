package com.miportafolio.controller;

import com.miportafolio.model.Usuario;
import com.miportafolio.service.AuthService;
import com.miportafolio.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private AuthService authService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.authService = new AuthService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Usuario usuario = SessionUtil.getUsuarioAutenticado(request);
        
        // Si el usuario ya está autenticado, redirigir directo al dashboard
        if (usuario != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            return;
        }
        
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Todos los campos son obligatorios.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        Usuario usuarioAutenticado = authService.autenticar(email, password);

        if (usuarioAutenticado != null) {
            // Inicia sesión tanto en memoria (HttpSession) como en cookie segura (SessionUtil)
            SessionUtil.iniciarSesion(request, response, usuarioAutenticado);
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        } else {
            request.setAttribute("error", "Conflicto con el correo electrónico o la contraseña. Inténtalo de nuevo.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
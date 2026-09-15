package com.miportafolio.controller;

import com.miportafolio.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/registro")
public class RegistroServlet extends HttpServlet {
    private AuthService authService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/registro.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String nombre = request.getParameter("nombre");
        String rol = request.getParameter("rol");
        
        if (email == null || email.isEmpty() || password == null || password.isEmpty() 
                || nombre == null || nombre.isEmpty()) {
            request.setAttribute("error", "Todos los campos son obligatorios");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }
        
        if (rol == null || rol.isEmpty()) {
            rol = "usuario"; // Rol por defecto
        }
        
        boolean registrado = authService.registrar(email, password, nombre, rol);
        
        if (registrado) {
            response.sendRedirect("login?registro=exitoso");
        } else {
            request.setAttribute("error", "El email ya está registrado");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
        }
    }
}

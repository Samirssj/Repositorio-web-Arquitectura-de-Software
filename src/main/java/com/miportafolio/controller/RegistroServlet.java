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
        request.setCharacterEncoding("UTF-8");
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String nombre = request.getParameter("nombre");
        
        // Validar que ningún campo sea nulo o esté en blanco
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty() || 
            nombre == null || nombre.trim().isEmpty()) {
            request.setAttribute("error", "Todos los campos son obligatorios.");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }
        
        // Invocar registro con rol "usuario" (el sistema asignará admin automáticamente)
        boolean registrado = authService.registrar(email, password, nombre, "usuario");
        
        if (registrado) {
            response.sendRedirect("login.jsp?registroExitoso=true");
        } else {
            request.setAttribute("error", "El correo electrónico ya se encuentra registrado.");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
        }
    }
}

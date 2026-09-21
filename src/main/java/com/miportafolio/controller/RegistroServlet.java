package com.miportafolio.controller;

import com.miportafolio.service.AuthService;
import com.miportafolio.service.AuthService.ResultadoRegistro;
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
        
        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty() 
                || nombre == null || nombre.trim().isEmpty()) {
            request.setAttribute("error", "Todos los campos son obligatorios");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }
        
        ResultadoRegistro resultado = authService.registrar(email, password, nombre);
        
        if (resultado == ResultadoRegistro.EXITO) {
            response.sendRedirect("login?registro=exitoso");
            return;
        }
        
        request.setAttribute("error", mensajeDeError(resultado));
        request.getRequestDispatcher("/registro.jsp").forward(request, response);
    }
    
    private static String mensajeDeError(ResultadoRegistro resultado) {
        switch (resultado) {
            case EMAIL_DUPLICADO:
                return "El correo electrónico ya se encuentra registrado";
            case ROL_NO_PERMITIDO:
                return "La base de datos rechazó el registro (restricción de rol/correo)";
            case ERROR_CONEXION:
                return "No se pudo conectar a la base de datos. Revisa la URL/credenciales de Supabase en el servidor";
            default:
                return "Error interno al guardar el usuario. Revisa los logs del servidor";
        }
    }
}

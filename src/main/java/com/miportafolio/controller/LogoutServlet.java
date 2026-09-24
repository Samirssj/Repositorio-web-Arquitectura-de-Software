package com.miportafolio.controller;

import com.miportafolio.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        SessionUtil.cerrarSesion(request, response);
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
package com.miportafolio.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/visitar")
public class VisitarServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String url = request.getParameter("url");
        
        if (url != null && !url.isEmpty()) {
            response.sendRedirect(url);
        } else {
            response.sendRedirect("index.jsp");
        }
    }
}

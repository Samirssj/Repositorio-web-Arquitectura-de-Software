package com.miportafolio.controller;

import com.miportafolio.dao.ArchivoDAO;
import com.miportafolio.model.Archivo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("")
public class IndexServlet extends HttpServlet {
    private ArchivoDAO archivoDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        archivoDAO = new ArchivoDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // La portada también debe poder mostrarse antes de configurar Supabase.
        List<Archivo> proyectos;
        try {
            proyectos = archivoDAO.listarTodos();
        } catch (RuntimeException | LinkageError exception) {
            proyectos = List.of();
        }
        request.setAttribute("proyectos", proyectos);
        
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}

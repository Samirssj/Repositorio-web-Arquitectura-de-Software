package com.miportafolio.servlet;

import com.miportafolio.dao.ArchivoDAO;
import com.miportafolio.model.Archivo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/semana")
public class SemanaServlet extends HttpServlet {

    private ArchivoDAO archivoDAO;

    @Override
    public void init() throws ServletException {
        // Inicialización segura de la capa de acceso a datos
        this.archivoDAO = new ArchivoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String semanaParam = request.getParameter("num");
        int numeroSemana = 1; // Valor por defecto

        // Validación anti-errores para la conversión de número
        if (semanaParam != null && !semanaParam.trim().isEmpty()) {
            try {
                numeroSemana = Integer.parseInt(semanaParam.trim());
            } catch (NumberFormatException e) {
                numeroSemana = 1;
            }
        }

        List<Archivo> recursosSemana;
        try {
            // Consulta a Supabase/Base de Datos filtrando por la semana seleccionada
            recursosSemana = archivoDAO.obtenerArchivosPorSemana(numeroSemana);
        } catch (Exception e) {
            e.printStackTrace();
            recursosSemana = new ArrayList<>(); // Evita mandar atributos nulos a la vista JSP
            request.setAttribute("error", "Ocurrió un error al cargar los recursos de la semana.");
        }

        // Asignación de atributos a la vista
        request.setAttribute("numeroSemana", numeroSemana);
        request.setAttribute("recursos", recursosSemana);

        // Redirección con ruta absoluta hacia semana.jsp
        request.getRequestDispatcher("/semana.jsp").forward(request, response);
    }
}
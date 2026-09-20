<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.miportafolio.model.Archivo" %>
<%@ page import="com.miportafolio.dao.ArchivoDAO" %>
<%
    Integer numeroSemana = (Integer) request.getAttribute("numeroSemana");
    if (numeroSemana == null) {
        String numParam = request.getParameter("num");
        numeroSemana = (numParam != null && !numParam.trim().isEmpty()) ? Integer.parseInt(numParam.trim()) : 1;
    }

    List<Archivo> recursos = (List<Archivo>) request.getAttribute("recursos");
    
    // Respaldo: si recursos viene nulo (porque se accedió al JSP directo), consulta la BD
    if (recursos == null) {
        ArchivoDAO dao = new ArchivoDAO();
        recursos = dao.obtenerArchivosPorSemana(numeroSemana);
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Semana <%= String.format("%02d", numeroSemana) %> | Academia</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script>
        (function () {
            const savedTheme = localStorage.getItem("academia-theme") || "dark";
            document.documentElement.setAttribute("data-theme", savedTheme);
        })();
    </script>
</head>
<body>

<div id="sidebarOverlay" class="sidebar-overlay"></div>

<header class="site-header">
    <nav class="site-nav">
        <div class="nav-left">
            <button type="button" id="menuToggle" class="menu-toggle" aria-label="Abrir menú">☰</button>
        </div>

        <a class="brand" href="${pageContext.request.contextPath}/index.jsp">
            <img src="https://www.sigc.gestorinfo.upla.edu.pe/storage/per/logo.png" alt="Logo UPLA" class="brand-mark-img">
            <span class="brand-text">UPLA</span>
        </a>

        <ul class="nav-links desktop-only">
            <li><a href="${pageContext.request.contextPath}/index.jsp">Inicio</a></li>
            <li><a class="active" href="${pageContext.request.contextPath}/unidades.jsp">Unidades</a></li>
            <li><a href="${pageContext.request.contextPath}/acerca.jsp">Acerca de mí</a></li>
        </ul>

        <div class="nav-actions">
            <button type="button" id="themeToggle" class="theme-toggle" aria-label="Cambiar tema">
                <span class="theme-icon">🌙</span>
            </button>
            <div class="avatar">SR</div>
        </div>
    </nav>
</header>

<aside id="mobileSidebar" class="mobile-sidebar">
    <div class="sidebar-header">
        <span class="sidebar-title">Menú</span>
        <button type="button" id="closeSidebar" class="close-sidebar-btn" aria-label="Cerrar menú">✕</button>
    </div>
    
    <ul class="sidebar-nav">
        <li><a href="${pageContext.request.contextPath}/index.jsp">🏠 Inicio</a></li>
        <li><a class="active" href="${pageContext.request.contextPath}/unidades.jsp">📚 Unidades</a></li>
        <li><a href="${pageContext.request.contextPath}/acerca.jsp">👤 Acerca de mí</a></li>
        <li><a href="${pageContext.request.contextPath}/login.jsp">🔐 Administración</a></li>
    </ul>
</aside>

<main class="page-shell">
    <div style="margin-bottom: 24px;">
        <span class="section-label">RECURSOS ACADÉMICOS</span>
        <h1 class="page-title">Semana <%= String.format("%02d", numeroSemana) %></h1>
    </div>

    <div class="unit-detail-layout">
        <!-- BARRA LATERAL DE NAVEGACIÓN ENTRE SEMANAS -->
        <aside class="sidebar-weeks">
            <h4>Semanas de Clase</h4>
            <ul class="week-menu">
                <% for (int i = 1; i <= 4; i++) { %>
                    <li>
                        <a href="semana?num=<%= i %>" class="<%= (i == numeroSemana) ? "active" : "" %>">
                            <span>W<%= i %></span> · Semana <%= String.format("%02d", i) %>
                        </a>
                    </li>
                <% } %>
            </ul>
        </aside>

        <!-- CONTENIDO DINÁMICO DESDE LA BASE DE DATOS -->
        <section class="weeks-content">
            <% if (recursos != null && !recursos.isEmpty()) { 
                for (Archivo recurso : recursos) { %>
                    <article class="week-content-card">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px; gap: 12px; flex-wrap: wrap;">
                            <div>
                                <span class="section-label"><%= recurso.getTipo().toUpperCase() %></span>
                                <h3 style="margin-top: 4px;"><%= recurso.getNombre() %></h3>
                            </div>
                            <a href="<%= recurso.getUrl() %>" target="_blank" class="btn btn-primary" style="font-size: 12px;">
                                Descargar / Ver recurso →
                            </a>
                        </div>
                        <p style="color: var(--muted); font-size: 13px;">
                            <%= recurso.getDescripcion() != null ? recurso.getDescripcion() : "Sin descripción disponible." %>
                        </p>
                    </article>
            <%   } 
               } else { %>
                    <article class="week-content-card" style="text-align: center; padding: 40px;">
                        <h3>No hay materiales cargados para esta semana</h3>
                        <p style="color: var(--muted); margin-top: 8px;">
                            Los recursos subidos desde el <a href="dashboard.jsp" style="color: var(--blue); font-weight: 700;">panel de administración</a> aparecerán aquí.
                        </p>
                    </article>
            <% } %>
        </section>
    </div>
</main>

<footer class="site-footer">
    <div class="site-footer-inner">
        <div class="footer-brand">
            <a class="brand" href="${pageContext.request.contextPath}/index.jsp">
                <img src="https://www.sigc.gestorinfo.upla.edu.pe/storage/per/logo.png" alt="Logo UPLA" class="brand-mark-img">
                <span class="brand-text">UPLA</span>
            </a>
            <p style="margin-top: 8px;">Aprender haciendo.</p>
        </div>
        <div class="footer-column">
            <h4>Navegación</h4>
            <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
            <a href="${pageContext.request.contextPath}/unidades.jsp">Unidades</a>
            <a href="${pageContext.request.contextPath}/acerca.jsp">Acerca de mí</a>
        </div>
        <div class="footer-column">
            <h4>Gestión</h4>
            <a href="${pageContext.request.contextPath}/login.jsp">Iniciar sesión</a>
            <a href="${pageContext.request.contextPath}/dashboard.jsp">Administración</a>
        </div>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/js/theme.js"></script>
</body>
</html>
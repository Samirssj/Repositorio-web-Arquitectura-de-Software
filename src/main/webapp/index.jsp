<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.miportafolio.model.SilaboData" %>
<%@ page import="com.miportafolio.model.SilaboData.UnidadInfo" %>
<%@ page import="com.miportafolio.model.SilaboData.SemanaInfo" %>
<%@ page import="com.miportafolio.dao.ArchivoDAO" %>
<%
    List<UnidadInfo> unidades = SilaboData.getUnidades();
    ArchivoDAO archivoDAO = new ArchivoDAO();
    Map<Integer, Integer> conteos = archivoDAO.contarArchivosPorTodasLasSemanas();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Academia | Repositorio de Software</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
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
            <li><a class="active" href="${pageContext.request.contextPath}/index.jsp">Inicio</a></li>
            <li><a href="${pageContext.request.contextPath}/unidades.jsp">Unidades</a></li>
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
        <li><a class="active" href="${pageContext.request.contextPath}/index.jsp">🏠 Inicio</a></li>
        <li><a href="${pageContext.request.contextPath}/unidades.jsp">📚 Unidades</a></li>
        <li><a href="${pageContext.request.contextPath}/acerca.jsp">👤 Acerca de mí</a></li>
        <li><a href="${pageContext.request.contextPath}/login.jsp">🔐 Administración</a></li>
    </ul>
</aside>

<main class="page-shell">
    <section class="hero-panel">
        <div class="hero-grid">
            <div class="hero-content">
                <span class="eyebrow">PORTAFOLIO ACADÉMICO</span>
                <h1>Aprender, crear y compartir.</h1>
                <p>Repositorio centralizado para arquitectura de software, gestión de proyectos y recursos académicos de ingeniería.</p>
                
                <div class="hero-actions">
                    <a href="unidades.jsp" class="btn btn-primary">Explorar unidades</a>
                    <a href="acerca.jsp" class="btn btn-ghost">Conocerme</a>
                </div>
            </div>
        </div>
    </section>

    <!-- SECCIÓN DE UNIDADES: ESTRUCTURA EXACTA DE LA IMAGEN CON PROGRESO DINÁMICO -->
    <section class="projects-section">
        <div class="section-heading">
            <div>
                <span class="section-label">RUTA DE APRENDIZAJE</span>
                <h2>Unidades del Curso</h2>
            </div>
            <a href="unidades.jsp" class="section-link">Ver todo el sílabo →</a>
        </div>

        <div class="unit-cards-grid">
            <% for (UnidadInfo u : unidades) { 
                int totalSemanas = u.getSemanas().size();
                int semanasCompletadas = 0;
                for (SemanaInfo s : u.getSemanas()) {
                    if (conteos.getOrDefault(s.getNumero(), 0) > 0) {
                        semanasCompletadas++;
                    }
                }
                int porcentaje = (totalSemanas > 0) ? (semanasCompletadas * 100 / totalSemanas) : 0;
            %>
                <a href="${pageContext.request.contextPath}/unidades.jsp#unidad-<%= u.getNumeroRomano().toLowerCase() %>" class="unit-card-item">
                    <div>
                        <div class="unit-card-top">
                            <span class="unit-card-tag">UNIDAD <%= u.getNumero() %></span>
                            <span class="unit-card-status"><%= porcentaje %>% Completado</span>
                        </div>
                        <h3 class="unit-card-title">Unidad <%= u.getNumero() %>: <%= u.getTitulo() %></h3>
                        <p class="unit-card-desc"><%= u.getCapacidad() %></p>
                    </div>

                    <div class="unit-card-footer">
                        <div class="unit-progress-text">
                            <span class="unit-progress-label">Progreso de la unidad</span>
                            <span class="unit-progress-ratio"><%= semanasCompletadas %>/<%= totalSemanas %> semanas</span>
                        </div>
                        <div class="unit-progress-track">
                            <div class="unit-progress-bar" style="width: <%= porcentaje %>%;"></div>
                        </div>
                    </div>
                </a>
            <% } %>
        </div>
    </section>
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
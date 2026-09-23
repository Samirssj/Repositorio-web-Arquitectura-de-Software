<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.miportafolio.model.Archivo" %>
<%@ page import="com.miportafolio.dao.ArchivoDAO" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Academia | Repositorio de Software</title>
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

    <section class="projects-section">
        <div class="section-heading">
            <div>
                <span class="section-label">PORTAFOLIO</span>
                <h2>Proyectos destacados</h2>
            </div>
            <a href="unidades.jsp" class="section-link">Ver todo →</a>
        </div>

        <%
            List<Archivo> proyectos = (List<Archivo>) request.getAttribute("proyectos");
            if (proyectos == null) {
                ArchivoDAO dao = new ArchivoDAO();
                proyectos = dao.listarTodos();
            }
            if (proyectos != null && !proyectos.isEmpty()) {
        %>
        <div class="project-grid">
            <%
                int limite = Math.min(proyectos.size(), 8);
                for (int i = 0; i < limite; i++) {
                    Archivo proyecto = proyectos.get(i);
            %>
            <article class="project-card" style="display: flex; flex-direction: column; justify-content: space-between;">
                <div>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                        <span class="project-type" style="background: rgba(49, 94, 251, 0.15); color: var(--blue); padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: 800; text-transform: uppercase;">
                            <%= proyecto.getTipo() %>
                        </span>
                        <span style="font-size: 11px; font-weight: 700; color: var(--muted);">
                            Semana <%= String.format("%02d", proyecto.getSemana()) %>
                        </span>
                    </div>
                    <h3 class="project-title" style="margin-bottom: 8px; font-size: 16px;"><%= proyecto.getNombre() %></h3>
                    <p class="project-description" style="color: var(--muted); font-size: 13px; line-height: 1.5; margin-bottom: 16px;">
                        <%= (proyecto.getDescripcion() != null && !proyecto.getDescripcion().trim().isEmpty()) 
                                ? proyecto.getDescripcion() 
                                : "Recurso académico disponible para consulta." %>
                    </p>
                </div>
                <div style="margin-top: auto; padding-top: 12px; border-top: 1px solid var(--line); display: flex; justify-content: space-between; align-items: center;">
                    <a href="${pageContext.request.contextPath}/descargar-archivo?id=<%= proyecto.getId() %>" target="_blank" style="color: var(--blue); font-weight: 700; font-size: 12px; text-decoration: none;">
                        Ver recurso →
                    </a>
                    <a href="${pageContext.request.contextPath}/semana?num=<%= proyecto.getSemana() %>" style="color: var(--muted); font-size: 11px; text-decoration: none;">
                        Semana <%= proyecto.getSemana() %>
                    </a>
                </div>
            </article>
            <% } %>
        </div>
        <% } else { %>
        <div class="no-projects" style="text-align: center; padding: 40px; background: var(--surface); border-radius: 12px; border: 1px dashed var(--line);">
            <h3>Aún no hay proyectos publicados</h3>
            <p style="color: var(--muted);">Los archivos subidos desde la administración aparecerán aquí.</p>
        </div>
        <% } %>
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
<!-- CDN Oficial del Cliente JS de Supabase -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-client@2"></script>

<!-- Tus archivos de configuración y lógica -->
<script src="${pageContext.request.contextPath}/js/config.js"></script>
<script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
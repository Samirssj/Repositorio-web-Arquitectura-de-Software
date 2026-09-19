<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.miportafolio.model.Archivo" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Academia | Repositorio de Software</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <script>
        (function () {
            const theme = localStorage.getItem("academia-theme") || "dark";
            document.documentElement.setAttribute("data-theme", theme);
        })();
    </script>
</head>
<body>

<header class="site-header">
    <nav class="site-nav">
       <!-- LOGO CON IMAGEN INSTITUCIONAL -->
        <a class="brand" href="${pageContext.request.contextPath}/index.jsp">
            <img src="https://www.sigc.gestorinfo.upla.edu.pe/storage/per/logo.png" alt="Logo UPLA" class="brand-mark-img" style="height: 36px; margin-right: 8px;">
            <span>Universidad Peruana los Andes</span>
        </a>

        <ul class="nav-links">
            <li><a class="active" href="${pageContext.request.contextPath}/index.jsp">Inicio</a></li>
            <li><a href="${pageContext.request.contextPath}/unidades.jsp">Unidades</a></li>
            <li><a href="${pageContext.request.contextPath}/acerca.jsp">Acerca de mí</a></li>
        </ul>

        <div class="nav-actions">
            <button type="button" id="themeToggle" class="theme-toggle">
                <span class="theme-icon">🌙</span>
                <span class="theme-label">Tema</span>
            </button>
            <div class="avatar">SR</div>
        </div>
    </nav>
</header>

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
            if (proyectos != null && !proyectos.isEmpty()) {
        %>
        <div class="project-grid">
            <%
                int limite = Math.min(proyectos.size(), 4);
                for (int i = 0; i < limite; i++) {
                    Archivo proyecto = proyectos.get(i);
            %>
            <article class="project-card">
                <span class="project-type"><%= proyecto.getTipo() %></span>
                <h3 class="project-title"><%= proyecto.getNombre() %></h3>
                <p class="project-description">
                    <%= proyecto.getDescripcion() != null ? proyecto.getDescripcion() : "Sin descripción disponible." %>
                </p>
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
            <a class="brand" href="index.jsp">
                <span class="brand-mark">&lt;/&gt;</span>
                <span>ACADEMIA</span>
            </a>
            <p>Portafolio personal de Ingeniería de Sistemas y Computación.</p>
        </div>
        <div class="footer-column">
            <h4>Navegación</h4>
            <a href="index.jsp">Inicio</a>
            <a href="unidades.jsp">Unidades</a>
            <a href="acerca.jsp">Acerca de mí</a>
        </div>
        <div class="footer-column">
            <h4>Gestión</h4>
            <a href="login.jsp">Iniciar sesión</a>
            <a href="dashboard.jsp">Administración</a>
        </div>
    </div>
</footer>

<script src="js/theme.js"></script>
</body>
</html>
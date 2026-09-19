<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acerca de mí | Academia</title>
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

<header class="site-header">
    <nav class="site-nav">
        <a class="brand" href="${pageContext.request.contextPath}/index.jsp">
            <img src="https://www.sigc.gestorinfo.upla.edu.pe/storage/per/logo.png" alt="Logo UPLA" class="brand-mark-img" style="height: 36px; margin-right: 8px;">
            <span>Universidad Peruana los Andes</span>
        </a>

        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/index.jsp">Inicio</a></li>
            <li><a href="${pageContext.request.contextPath}/unidades.jsp">Unidades</a></li>
            <li><a class="active" href="${pageContext.request.contextPath}/acerca.jsp">Acerca de mí</a></li>
        </ul>

        <div class="nav-actions">
            <button type="button" id="themeToggle" class="theme-toggle">
                <span class="theme-icon">🌙</span>
                <span class="theme-label">Tema</span>
            </button>
            <a href="login.jsp" class="btn btn-primary" style="font-size: 12px; min-height: 34px;">Administrar</a>
        </div>
    </nav>
</header>

<main class="page-shell">
    <div style="margin-bottom: 24px;">
        <span class="section-label">PERFIL ACADÉMICO</span>
        <h1 style="font-size: 32px; font-weight: 800; margin-top: 4px;">Aprender haciendo.</h1>
        <p style="color: var(--muted); font-size: 14px; margin-top: 6px;">
            Este portafolio reúne mis proyectos, recursos y avances mientras desarrollo mis habilidades técnicas.
        </p>
    </div>

    <div class="about-layout">
        <article class="content-panel">
            <div class="profile-block">
                <div class="profile-avatar">S</div>
                <div>
                    <h2 style="font-size: 20px; font-weight: 800;">Samir Rojas</h2>
                    <span style="color: var(--blue); font-size: 12px; font-weight: 700;">Estudiante · Ingeniería de Sistemas</span>
                </div>
            </div>

            <p style="color: var(--muted); line-height: 1.7; font-size: 14px;">
                Mi objetivo es seguir fortaleciendo mis conocimientos en desarrollo web, bases de datos, redes, algoritmos y diseño de interfaces.
            </p>

            <div style="margin-top: 24px;">
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">Ver mis proyectos</a>
            </div>
        </article>

        <aside class="content-panel">
            <span class="section-label">LO QUE ESTOY APRENDIENDO</span>
            <h3 style="font-size: 18px; font-weight: 800; margin-top: 6px; margin-bottom: 16px;">Herramientas y habilidades</h3>
            
            <ul class="skill-list">
                <li>Java y Jakarta EE</li>
                <li>HTML y CSS</li>
                <li>PostgreSQL</li>
                <li>Supabase</li>
                <li>Algoritmos</li>
                <li>Git y Maven</li>
                <li>Redes y Packet Tracer</li>
                <li>UI/UX</li>
            </ul>
        </aside>
    </div>
</main>

<footer class="site-footer">
    <div class="site-footer-inner">
        <div class="footer-brand">
            <a class="brand" href="${pageContext.request.contextPath}/index.jsp">
                <span class="brand-mark">&lt;/&gt;</span>
                <span>ACADEMIA</span>
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
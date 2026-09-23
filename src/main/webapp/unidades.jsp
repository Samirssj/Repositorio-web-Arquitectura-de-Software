<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unidades | Academia</title>
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
    <div style="margin-bottom: 28px;">
        <span class="section-label">RUTA DE APRENDIZAJE</span>
        <h1 class="page-title">Unidad 1 — Fundamentos</h1>
        <p class="page-lead">
            Introducción a los fundamentos, estructuras de datos y análisis algorítmico.
        </p>
    </div>

    <div class="unit-detail-layout">
        <aside class="sidebar-weeks">
            <h4>Semanas de Clase</h4>
            <ul class="week-menu">
                <li><a href="#sem1" class="active"><span>W1</span> · Introducción a Algoritmos</a></li>
                <li><a href="#sem2"><span>W2</span> · Estructuras de Datos</a></li>
                <li><a href="#sem3"><span>W3</span> · Complejidad Computacional</a></li>
                <li><a href="#sem4"><span>W4</span> · Grafos y Árboles</a></li>
            </ul>
        </aside>

        <section class="weeks-content">
            <article class="week-content-card" id="sem1">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
                    <div>
                        <span class="section-label">SEMANA 01</span>
                        <h3>Introducción a Algoritmos</h3>
                    </div>
                    <span style="background: var(--blue-soft); color: var(--blue); font-size: 11px; font-weight: 800; padding: 4px 10px; border-radius: 6px;">
                        Completado
                    </span>
                </div>
                <p style="color: var(--muted); font-size: 13px; margin-bottom: 20px;">
                    Conceptos iniciales, notación asintótica y metodologías para la resolución lógica de problemas.
                </p>
                <a href="${pageContext.request.contextPath}/semana?num=1" class="btn btn-primary">
                    Ver recursos y materiales →
                </a>
            </article>

            <article class="week-content-card" id="sem2">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
                    <div>
                        <span class="section-label">SEMANA 02</span>
                        <h3>Estructuras de Datos Fundamental</h3>
                    </div>
                    <span style="background: var(--blue-soft); color: var(--blue); font-size: 11px; font-weight: 800; padding: 4px 10px; border-radius: 6px;">
                        Completado
                    </span>
                </div>
                <p style="color: var(--muted); font-size: 13px; margin-bottom: 20px;">
                    Listas enlazadas, pilas, colas y su implementación en Java EE / Jakarta EE.
                </p>
                <a href="${pageContext.request.contextPath}/semana?num=2" class="btn btn-primary">
                    Ver recursos y materiales →
                </a>
            </article>

            <article class="week-content-card" id="sem3">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
                    <div>
                        <span class="section-label">SEMANA 03</span>
                        <h3>Complejidad Computacional</h3>
                    </div>
                </div>
                <p style="color: var(--muted); font-size: 13px; margin-bottom: 20px;">
                    Análisis de eficiencia temporal y espacial utilizando la notación Big-O.
                </p>
                <a href="${pageContext.request.contextPath}/semana?num=3" class="btn btn-primary">
                    Ver recursos y materiales →
                </a>
            </article>

            <article class="week-content-card" id="sem4">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
                    <div>
                        <span class="section-label">SEMANA 04</span>
                        <h3>Grafos y Árboles</h3>
                    </div>
                </div>
                <p style="color: var(--muted); font-size: 13px; margin-bottom: 20px;">
                    Representación matricial, listas de adyacencia y algoritmos de búsqueda (BFS y DFS).
                </p>
                <a href="${pageContext.request.contextPath}/semana?num=4" class="btn btn-primary">
                    Ver recursos y materiales →
                </a>
            </article>
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
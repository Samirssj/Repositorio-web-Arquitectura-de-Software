<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unidades | Academia</title>
    
    <!-- FUENTES Y CSS GLOBAL -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <!-- Carga preventiva del tema para evitar parpadeos -->
    <script>
        (function () {
            const savedTheme = localStorage.getItem("academia-theme") || "light";
            document.documentElement.setAttribute("data-theme", savedTheme);
        })();
    </script>
</head>
<body>

<!-- =========================================================
     HEADER UNIFICADO
========================================================= -->
<header class="site-header">
    <nav class="site-nav">
        <!-- LOGO -->
        <a class="brand" href="${pageContext.request.contextPath}/index.jsp">
            <span class="brand-mark">A</span>
            <span>ACADEMIA</span>
        </a>

        <!-- NAVEGACIÓN PRINCIPAL -->
        <ul class="nav-links">
            <li>
                <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
            </li>
            <li>
                <a class="active" href="${pageContext.request.contextPath}/unidades.jsp">Unidades</a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/acerca.jsp">Acerca de mí</a>
            </li>
        </ul>

        <!-- ACCIONES Y USUARIO -->
        <div class="nav-actions">
            <!-- BOTÓN CAMBIO DE TEMA (COMPATIBLE CON theme.js) -->
            <button type="button" id="themeToggle" class="theme-toggle" aria-label="Cambiar tema">
                <span class="theme-icon">☾</span>
                <span class="theme-label">Modo oscuro</span>
            </button>

            <div class="nav-user-info">
                <span>Área académica</span>
            </div>

            <div class="avatar">
                S
            </div>
        </div>
    </nav>
</header>

<!-- =========================================================
     CONTENIDO PRINCIPAL: DETALLE DE UNIDAD (2 COLUMNAS)
========================================================= -->
<main class="page-shell">
    
    <!-- ENCABEZADO DE PÁGINA -->
    <div style="margin-bottom: 28px;">
        <span class="section-label">RUTA DE APRENDIZAJE</span>
        <h1 class="page-title">Unidad 1 — Fundamentos</h1>
        <p class="page-lead">
            Introducción a los fundamentos, estructuras de datos y análisis algorítmico.
        </p>
    </div>

    <!-- ESTRUCTURA DE 2 COLUMNAS COMO EN LA MAQUETA -->
    <div class="unit-detail-layout">
        
        <!-- COLUMNA 1: MENÚ LATERAL DE SEMANAS -->
        <aside class="sidebar-weeks">
            <h4>Semanas de Clase</h4>
            <ul class="week-menu">
                <li>
                    <a href="#sem1" class="active">
                        <span>W1</span> · Introducción a Algoritmos
                    </a>
                </li>
                <li>
                    <a href="#sem2">
                        <span>W2</span> · Estructuras de Datos
                    </a>
                </li>
                <li>
                    <a href="#sem3">
                        <span>W3</span> · Complejidad Computacional
                    </a>
                </li>
                <li>
                    <a href="#sem4">
                        <span>W4</span> · Grafos y Árboles
                    </a>
                </li>
            </ul>
        </aside>

        <!-- COLUMNA 2: CONTENIDOS Y RECURSOS -->
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
                <a href="${pageContext.request.contextPath}/semana.jsp?id=1" class="btn btn-primary">
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
                <a href="${pageContext.request.contextPath}/semana.jsp?id=2" class="btn btn-primary">
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
                <a href="${pageContext.request.contextPath}/semana.jsp?id=3" class="btn btn-primary">
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
                <a href="${pageContext.request.contextPath}/semana.jsp?id=4" class="btn btn-primary">
                    Ver recursos y materiales →
                </a>
            </article>

        </section>

    </div>

</main>

<!-- =========================================================
     FOOTER UNIFICADO
========================================================= -->
<footer class="site-footer">
    <div class="site-footer-inner">
        <div class="footer-brand">
            <a class="brand" href="${pageContext.request.contextPath}/index.jsp">
                <span class="brand-mark">A</span>
                <span>ACADEMIA</span>
            </a>
            <p>
                Portafolio académico personal.<br>
                Aprender, crear y compartir.
            </p>
        </div>

        <div class="footer-column">
            <h4>Navegación</h4>
            <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
            <a href="${pageContext.request.contextPath}/unidades.jsp">Unidades</a>
            <a href="${pageContext.request.contextPath}/acerca.jsp">Acerca de mí</a>
        </div>

        <div class="footer-column">
            <h4>Portafolio</h4>
            <a href="${pageContext.request.contextPath}/login.jsp">Iniciar sesión</a>
            <a href="${pageContext.request.contextPath}/dashboard.jsp">Administración</a>
        </div>

        <div class="footer-column">
            <h4>Información</h4>
            <span>Ingeniería de Sistemas</span>
            <span>y Computación</span>
            <span>2026</span>
        </div>
    </div>

    <div class="footer-bottom">
        <div class="site-footer-inner">
            <span>© 2026 Mi Portafolio</span>
            <span>Hecho para aprender haciendo.</span>
        </div>
    </div>
</footer>

<!-- SCRIPT DE TEMA (SIN NINGÚN CAMBIO A TU JS) -->
<script src="${pageContext.request.contextPath}/js/theme.js"></script>

</body>
</html>
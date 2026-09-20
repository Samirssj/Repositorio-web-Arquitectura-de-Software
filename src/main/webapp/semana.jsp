<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recursos de la Semana | Academia</title>
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
        <li><a href="${pageContext.request.contextPath}/index.jsp">🏠 Inicio</a></li>
        <li><a href="${pageContext.request.contextPath}/unidades.jsp">📚 Unidades</a></li>
        <li><a href="${pageContext.request.contextPath}/acerca.jsp">👤 Acerca de mí</a></li>
        <li><a href="${pageContext.request.contextPath}/login.jsp">🔐 Administración</a></li>
    </ul>
</aside>

<main class="page-shell">
    <div style="margin-bottom: 24px;">
        <span class="section-label">UNIDAD 1 · SEMANA 01</span>
        <h1 class="page-title">Introducción a Algoritmos</h1>
    </div>

    <div class="unit-detail-layout">
        <aside class="sidebar-weeks">
            <h4>Materiales Disponibles</h4>
            <ul class="week-menu">
                <li><a href="#" class="active">📄 Guía de Laboratorio 01.pdf</a></li>
                <li><a href="#">📊 Diapositivas - Lógica.pdf</a></li>
                <li><a href="#">📝 Ejercicios Resueltos.docx</a></li>
            </ul>
        </aside>

        <section class="week-content-card">
            <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--line); padding-bottom: 16px; margin-bottom: 20px;">
                <div>
                    <h3>Guía de Laboratorio 01 — Algoritmos Básicos</h3>
                    <p style="color: var(--muted); font-size: 12px; margin-top: 4px;">Publicado el 15 de Septiembre, 2026</p>
                </div>
                <a href="#" class="btn btn-primary" style="font-size: 12px;">Descargar PDF ↓</a>
            </div>

            <div style="line-height: 1.8; color: var(--ink);">
                <h4>1. Objetivos de la Práctica</h4>
                <p style="color: var(--muted); margin-bottom: 16px;">
                    Comprender la construcción de pseudocódigo, diagramas de flujo y análisis asintótico inicial mediante ejemplos prácticos.
                </p>
                
                <h4>2. Indicaciones</h4>
                <p style="color: var(--muted); margin-bottom: 16px;">
                    Diseñar e implementar los ejercicios propuestos en el entorno de desarrollo y verificar la complejidad temporal solicitada.
                </p>
            </div>
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
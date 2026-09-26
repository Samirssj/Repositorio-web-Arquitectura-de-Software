<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.miportafolio.model.Archivo" %>
<%@ page import="com.miportafolio.model.Usuario" %>
<%@ page import="com.miportafolio.util.SessionUtil" %>
<%
    Archivo archivo = (Archivo) request.getAttribute("archivo");
    if (archivo == null) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=archivo_no_encontrado");
        return;
    }
    Usuario usuarioSesion = SessionUtil.getUsuarioAutenticado(request);
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= archivo.getNombre() %> | Detalle de Recurso</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3.6">
    <script>
        (function () {
            document.documentElement.setAttribute("data-theme", "dark");
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
            <div class="avatar"><%= usuarioSesion != null ? "AD" : "SR" %></div>
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
        <span class="section-label">DETALLE DEL ARCHIVO</span>
        <h1 style="font-size: 28px; font-weight: 800; margin-top: 4px;"><%= archivo.getNombre() %></h1>
    </div>

    <div style="max-width: 800px; margin: 0 auto;">
        <article class="content-panel" style="padding: 32px;">
            <div style="display: flex; gap: 12px; margin-bottom: 16px; flex-wrap: wrap; align-items: center;">
                <span style="background: rgba(0, 64, 255, 0.2); color: #00f7ff; border: 1px solid rgba(0, 64, 255, 0.4); padding: 4px 12px; border-radius: 6px; font-size: 12px; font-weight: 800;">
                    <%= archivo.getTipo().toUpperCase() %>
                </span>
                <span style="background: var(--surface-soft); padding: 4px 12px; border-radius: 6px; font-size: 12px; font-weight: 700; color: var(--ink);">
                    Semana <%= archivo.getSemana() %>
                </span>
                <% if (archivo.getCreatedAt() != null) { %>
                    <span style="color: var(--muted); font-size: 12px;">
                        Subido el: <%= archivo.getCreatedAt().toString().replace("T", " ").substring(0, 16) %>
                    </span>
                <% } %>
            </div>

            <h3 style="font-size: 16px; font-weight: 700; margin-bottom: 8px;">Descripción</h3>
            <p style="color: var(--muted); line-height: 1.7; font-size: 14px; margin-bottom: 28px; background: var(--surface-soft); padding: 16px; border-radius: 8px;">
                <%= (archivo.getDescripcion() != null && !archivo.getDescripcion().trim().isEmpty()) 
                        ? archivo.getDescripcion() 
                        : "Sin descripción proporcionada para este archivo." %>
            </p>

            <div style="display: flex; gap: 16px; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/descargar-archivo?id=<%= archivo.getId() %>" target="_blank" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                    <span>📥</span> Abrir / Ver Archivo
                </a>
                <a href="${pageContext.request.contextPath}/editar_trabajo.jsp?id=<%= archivo.getId() %>" class="btn" style="background: rgba(0, 64, 255, 0.18); color: #00f7ff; border: 1px solid #0040ff; padding: 10px 18px; border-radius: 8px; font-weight: 700; font-size: 13px; text-decoration: none; display: inline-flex; align-items: center; gap: 6px;">
                    ✏️ Editar Trabajo
                </a>
                <a href="${pageContext.request.contextPath}/descargar-archivo?id=<%= archivo.getId() %>&modo=descargar" class="btn" style="background: var(--surface-soft); color: var(--ink); border: 1px solid var(--line); padding: 10px 18px; border-radius: 8px; font-weight: 700; font-size: 13px; text-decoration: none;">
                    💾 Descargar al Disco
                </a>
                <a href="${pageContext.request.contextPath}/dashboard.jsp" class="btn" style="background: transparent; color: var(--muted); padding: 10px 18px; font-size: 13px; text-decoration: none;">
                    ← Volver al Dashboard
                </a>
            </div>
        </article>
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

<script src="${pageContext.request.contextPath}/js/theme.js?v=2.0"></script>
</body>
</html>

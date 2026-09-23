<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.miportafolio.model.Archivo" %>
<%@ page import="com.miportafolio.model.Usuario" %>
<%@ page import="com.miportafolio.service.StorageService" %>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    if (usuarioSesion == null || !"admin".equals(usuarioSesion.getRol())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Carga de respaldo si se entra a la página directamente
    List<Archivo> archivos = (List<Archivo>) request.getAttribute("archivos");
    if (archivos == null) {
        StorageService service = new StorageService();
        archivos = service.listarArchivosPorUsuario(usuarioSesion.getId());
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administración | Academia</title>
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
        <li><a class="active" href="${pageContext.request.contextPath}/dashboard.jsp">🔐 Administración</a></li>
    </ul>
</aside>

<div class="page-shell">
    <main class="dashboard-main">
        <div style="margin-bottom: 24px;">
            <h1>Gestión de Contenido Académico</h1>
            <p style="color: var(--muted); font-size: 14px;">Sube recursos a la base de datos Supabase y gestiona los archivos del repositorio.</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div style="padding: 12px; background: rgba(239, 68, 68, 0.1); border: 1px solid #ef4444; color: #ef4444; border-radius: 8px; margin-bottom: 16px;">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <% if ("archivo_subido".equals(request.getParameter("mensaje"))) { %>
            <div style="padding: 12px; background: rgba(34, 197, 94, 0.1); border: 1px solid #22c55e; color: #22c55e; border-radius: 8px; margin-bottom: 16px;">
                ¡Archivo subido y asignado a la semana correctamente!
            </div>
        <% } %>

        <div class="dashboard-content">
            <section class="content-panel">
                <h3 style="margin-bottom: 16px;">Subir Nuevo Recurso</h3>
                
                <form action="${pageContext.request.contextPath}/subir-archivo" method="POST" enctype="multipart/form-data">
                    <div class="form-group" style="margin-bottom: 12px;">
                        <label style="display: block; font-weight: 700; margin-bottom: 4px;">Título del Archivo / Proyecto</label>
                        <input type="text" name="nombre" placeholder="Ej. Guía 1 - Algoritmos" required style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink);">
                    </div>

                    <div class="form-group" style="margin-bottom: 12px;">
                        <label style="display: block; font-weight: 700; margin-bottom: 4px;">Descripción Breve</label>
                        <textarea name="descripcion" rows="3" placeholder="Ingresa un resumen del contenido..." style="width: 100%; border-radius: 8px; padding: 10px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink);"></textarea>
                    </div>

                    <!-- NUEVO CAMPO: SELECCIÓN DE SEMANA -->
                    <div class="form-group" style="margin-bottom: 12px;">
                        <label style="display: block; font-weight: 700; margin-bottom: 4px;">Semana Académica</label>
                        <select name="semana" required style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink);">
                            <% for (int i = 1; i <= 16; i++) { %>
                                <option value="<%= i %>">Semana <%= String.format("%02d", i) %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label style="display: block; font-weight: 700; margin-bottom: 4px;">Categoría / Tipo de Archivo</label>
                        <select name="tipo" style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink);">
                            <option value="pdf">Documento PDF</option>
                            <option value="documento">Documento Word / Texto</option>
                            <option value="imagen">Imagen / Diagrama</option>
                        </select>
                    </div>

                    <div class="drop-zone" onclick="document.getElementById('fileInput').click();">
                        <div class="drop-zone-icon">📁</div>
                        <p style="font-weight: 700; font-size: 13px;">Arrastra un archivo aquí o haz clic para examinar</p>
                        <p style="color: var(--muted); font-size: 11px;">Formatos: PDF, DOCX, PNG, JPG</p>
                        <input type="file" id="fileInput" name="archivo" style="display: none;" required>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 16px;">Guardar y Publicar</button>
                </form>
            </section>

            <section class="content-panel" style="margin-top: 24px;">
                <h3 style="margin-bottom: 16px;">Repositorio Activo</h3>
                
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; font-size: 13px;">
                        <thead>
                            <tr style="border-bottom: 1px solid var(--line); text-align: left;">
                                <th style="padding: 10px;">Nombre</th>
                                <th style="padding: 10px;">Semana</th>
                                <th style="padding: 10px;">Tipo</th>
                                <th style="padding: 10px;">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (archivos != null && !archivos.isEmpty()) {
                                    for (Archivo arch : archivos) {
                            %>
                            <tr style="border-bottom: 1px solid var(--line);">
                                <td style="padding: 10px;"><%= arch.getNombre() %></td>
                                <td style="padding: 10px;"><strong>Semana <%= arch.getSemana() %></strong></td>
                                <td style="padding: 10px;"><span style="color: var(--blue); font-weight: 700;"><%= arch.getTipo().toUpperCase() %></span></td>
                                <td style="padding: 10px;">
                                    <a href="${pageContext.request.contextPath}/archivos?action=ver&id=<%= arch.getId() %>" style="color: var(--blue); font-weight: 700; margin-right: 12px;">Ver</a>
                                    <a href="${pageContext.request.contextPath}/archivos?action=eliminar&id=<%= arch.getId() %>" style="color: var(--red); font-weight: 700;" onclick="return confirm('¿Eliminar archivo?');">Eliminar</a>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="4" style="text-align: center; color: var(--muted); padding: 20px;">No hay archivos en la base de datos.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
    </main>
</div>

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
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.miportafolio.model.Archivo" %>
<%@ page import="com.miportafolio.model.Usuario" %>
<%@ page import="com.miportafolio.model.SilaboData" %>
<%@ page import="com.miportafolio.util.SessionUtil" %>
<%
    Usuario usuarioSesion = SessionUtil.getUsuarioAutenticado(request);
    if (usuarioSesion == null || !"admin".equals(usuarioSesion.getRol())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=sesion_requerida");
        return;
    }


    Archivo archivo = (Archivo) request.getAttribute("archivo");
    if (archivo == null) {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            com.miportafolio.service.StorageService service = new com.miportafolio.service.StorageService();
            archivo = service.obtenerArchivo(Long.parseLong(idParam.trim()));
        }
    }

    if (archivo == null) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=archivo_no_encontrado");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Trabajo: <%= archivo.getNombre() %> | Administración UPLA</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3.5">
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
            <div class="avatar">AD</div>
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

<main class="page-shell">
    <div style="max-width: 760px; margin: 0 auto;">
        <div style="margin-bottom: 24px;">
            <a href="${pageContext.request.contextPath}/dashboard.jsp" style="color: #00f7ff; font-size: 13px; font-weight: 700; text-decoration: none;">← Volver al Panel de Administración</a>
            <h1 style="font-size: 26px; font-weight: 800; margin-top: 10px; color: #ffffff;">Editar Trabajo Académico</h1>
            <p style="color: var(--muted); font-size: 14px;">Modifica el nombre, descripción, semana asignada o reemplaza el archivo.</p>
        </div>

        <article class="content-panel" style="padding: 32px; background: rgba(20, 20, 26, 0.88); border: 1px solid rgba(0, 64, 255, 0.3); border-radius: 18px; box-shadow: 0 15px 35px rgba(0,0,0,0.8), 0 0 25px rgba(0, 64, 255, 0.2); backdrop-filter: blur(14px);">
            <form action="${pageContext.request.contextPath}/editar-archivo" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="id" value="<%= archivo.getId() %>">

                <div class="form-group" style="margin-bottom: 16px;">
                    <label style="display: block; font-weight: 700; margin-bottom: 6px; font-size: 13px;">Título del Trabajo / Proyecto</label>
                    <input type="text" name="nombre" value="<%= archivo.getNombre() %>" required style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink); font-size: 14px;">
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label style="display: block; font-weight: 700; margin-bottom: 6px; font-size: 13px;">Descripción o Notas</label>
                    <textarea name="descripcion" rows="4" style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink); font-size: 14px;"><%= (archivo.getDescripcion() != null) ? archivo.getDescripcion() : "" %></textarea>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px;">
                    <div class="form-group">
                        <label style="display: block; font-weight: 700; margin-bottom: 6px; font-size: 13px;">Semana Asignada (1 a 16)</label>
                        <select name="semana" style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink); font-size: 14px;">
                            <% for (int i = 1; i <= 16; i++) { 
                                boolean sel = (i == archivo.getSemana());
                            %>
                                <option value="<%= i %>" <%= sel ? "selected" : "" %>>Semana <%= String.format("%02d", i) %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label style="display: block; font-weight: 700; margin-bottom: 6px; font-size: 13px;">Tipo de Archivo</label>
                        <select name="tipo" style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink); font-size: 14px;">
                            <option value="auto">Detección automática</option>
                            <option value="imagen" <%= "imagen".equalsIgnoreCase(archivo.getTipo()) ? "selected" : "" %>>Imagen / Diagrama</option>
                            <option value="pdf" <%= "pdf".equalsIgnoreCase(archivo.getTipo()) ? "selected" : "" %>>Documento PDF</option>
                            <option value="documento" <%= "documento".equalsIgnoreCase(archivo.getTipo()) ? "selected" : "" %>>Documento Word / Código</option>
                        </select>
                    </div>
                </div>

                <!-- ARCHIVO ACTUAL Y OPCIÓN DE REEMPLAZO -->
                <div style="background: var(--surface-soft); border: 1px solid var(--line); padding: 16px; border-radius: 10px; margin-bottom: 24px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                        <span style="font-size: 12px; font-weight: 700; color: var(--muted); text-transform: uppercase;">Archivo Actual:</span>
                        <a href="${pageContext.request.contextPath}/descargar-archivo?id=<%= archivo.getId() %>" target="_blank" style="font-size: 12px; font-weight: 700; color: #00f7ff; text-decoration: none;">👁️ Ver archivo actual ↗</a>
                    </div>
                    <div style="font-size: 13px; font-family: 'JetBrains Mono', monospace; color: var(--ink); word-break: break-all; margin-bottom: 12px;">
                        <%= archivo.getUrl() %>
                    </div>

                    <label style="display: block; font-weight: 700; margin-bottom: 6px; font-size: 13px;">Reemplazar Archivo (Opcional)</label>
                    <input type="file" name="nuevoArchivo" style="width: 100%; padding: 10px; border-radius: 8px; border: 1px dashed var(--line); background: var(--surface); color: var(--ink); font-size: 13px;">
                    <span style="color: var(--muted); font-size: 11px; display: block; margin-top: 4px;">Deja este campo vacío si deseas conservar el archivo actual sin cambios.</span>
                </div>

                <div style="display: flex; gap: 12px; justify-content: flex-end;">
                    <a href="${pageContext.request.contextPath}/dashboard.jsp" class="btn" style="background: var(--surface-soft); color: var(--ink); border: 1px solid var(--line); padding: 10px 20px; border-radius: 8px; font-weight: 700; font-size: 13px; text-decoration: none;">Cancelar</a>
                    <button type="submit" class="btn btn-primary" style="padding: 10px 24px; font-size: 13px; font-weight: 700;">💾 Guardar Cambios</button>
                </div>
            </form>
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

<script src="${pageContext.request.contextPath}/js/theme.js"></script>
</body>
</html>

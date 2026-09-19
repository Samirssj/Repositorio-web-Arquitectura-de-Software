<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.miportafolio.model.Archivo" %>
<%
    // Verificación básica de sesión para administrador
    com.miportafolio.model.Usuario usuarioSesion = (com.miportafolio.model.Usuario) session.getAttribute("usuario");
    if (usuarioSesion == null || !"admin".equals(usuarioSesion.getRol())) {
        response.sendRedirect("login.jsp");
        return;
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

<div class="dashboard-layout">
    <!-- BARRA LATERAL (SIDEBAR ADMIN SEGÚN FIGMA) -->
    <aside class="dashboard-sidebar">
        <a class="brand" href="${pageContext.request.contextPath}/index.jsp">
            <img src="https://www.sigc.gestorinfo.upla.edu.pe/storage/per/logo.png" alt="Logo UPLA" class="brand-mark-img" style="height: 36px; margin-right: 8px;">
            <span>Universidad Peruana los Andes</span>
        </a>

        <div class="sidebar-label">Panel Admin</div>
        <a href="dashboard.jsp" class="sidebar-link active">Gestión de Archivos</a>
        <a href="index.jsp" class="sidebar-link">Ver Sitio Público</a>

        <div class="sidebar-label" style="margin-top: 40px;">Cuenta</div>
        <span class="sidebar-link" style="color: #94a3b8; font-size: 11px;"><%= usuarioSesion.getEmail() %></span>
        <a href="LogoutServlet" class="sidebar-link" style="color: #ef7180;">Cerrar Sesión</a>
    </aside>

    <!-- ÁREA PRINCIPAL DEL DASHBOARD -->
    <main class="dashboard-main">
        <div class="dashboard-top">
            <div>
                <h1>Gestión de Contenido Académico</h1>
                <p>Sube recursos a la base de datos Supabase y gestiona los archivos del repositorio.</p>
            </div>
            <button type="button" id="themeToggle" class="theme-toggle">
                <span class="theme-icon">🌙</span>
            </button>
        </div>

        <div class="dashboard-content">
            <!-- Formulario de Subida con Drag & Drop -->
            <section class="upload-section">
                <h3>Subir Nuevo Recurso</h3>
                
                <form action="${pageContext.request.contextPath}/subir-archivo" method="POST" enctype="multipart/form-data">
                    <div class="form-group">
                        <label>Título del Archivo / Proyecto</label>
                        <input type="text" name="nombre" placeholder="Ej. Guía 1 - Algoritmos" required>
                    </div>

                    <div class="form-group">
                        <label>Descripción Breve</label>
                        <textarea name="descripcion" rows="3" placeholder="Ingresa un resumen del contenido..." style="width: 100%; border-radius: 6px; padding: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink);"></textarea>
                    </div>

                    <div class="form-group">
                        <label>Categoría / Tipo de Archivo</label>
                        <select name="tipo">
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

            <!-- Tabla de Archivos Subidos -->
            <section class="files-section">
                <h3>Repositorio Activo</h3>
                
                <table class="files-table">
                    <thead>
                        <tr>
                            <th>Nombre</th>
                            <th>Tipo</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Archivo> archivos = (List<Archivo>) request.getAttribute("archivos");
                            if (archivos != null && !archivos.isEmpty()) {
                                for (Archivo arch : archivos) {
                        %>
                        <tr>
                            <td><%= arch.getNombre() %></td>
                            <td><span style="color: var(--blue); font-weight: 700;"><%= arch.getTipo().toUpperCase() %></span></td>
                            <td>
                                <a href="ArchivoServlet?action=eliminar&id=<%= arch.getId() %>" class="btn btn-danger btn-small" onclick="return confirm('¿Eliminar archivo?');">Eliminar</a>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="3" style="text-align: center; color: var(--muted); padding: 20px;">No hay archivos en la base de datos.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </section>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/js/theme.js"></script>
</body>
</html>
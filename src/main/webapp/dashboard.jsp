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
        archivos = service.listarTodosArchivos();
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

        <% if ("archivo_subido".equals(request.getParameter("mensaje")) || "archivos_subidos".equals(request.getParameter("mensaje"))) { 
            String countParam = request.getParameter("count");
            String semParam = request.getParameter("semana");
            String countText = (countParam != null && !countParam.trim().isEmpty()) ? countParam + " trabajo(s)" : "archivo(s)";
            String semText = (semParam != null && !semParam.trim().isEmpty()) ? " a la Semana " + semParam : " a la semana seleccionada";
        %>
            <div style="padding: 14px 18px; background: rgba(34, 197, 94, 0.12); border: 1px solid #22c55e; color: #22c55e; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 10px;">
                <span>✓ <strong>¡Éxito!</strong> Se subieron y asignaron correctamente <%= countText %><%= semText %>.</span>
                <% if (semParam != null && !semParam.trim().isEmpty()) { %>
                    <a href="${pageContext.request.contextPath}/semana?num=<%= semParam %>" target="_blank" style="color: #22c55e; font-weight: 700; text-decoration: underline; font-size: 13px;">Ver en Semana <%= semParam %> →</a>
                <% } %>
            </div>
        <% } %>

        <div class="dashboard-content">
            <section class="content-panel">
                <h3 style="margin-bottom: 16px;">Subir Trabajos / Recursos Académicos</h3>
                <p style="color: var(--muted); font-size: 13px; margin-bottom: 16px;">Puedes seleccionar y subir varios archivos a la vez para la misma semana (guías, diapositivas, códigos, diagramas, etc.).</p>
                
                <form action="${pageContext.request.contextPath}/subir-archivo" method="POST" enctype="multipart/form-data" id="uploadForm">
                    <div class="form-group" style="margin-bottom: 12px;">
                        <label style="display: block; font-weight: 700; margin-bottom: 4px;">Título del Proyecto o Prefijo (Opcional si subes varios)</label>
                        <input type="text" name="nombre" id="nombreInput" placeholder="Ej. Guía 1 - Algoritmos (O deja vacío para usar el nombre del archivo)" style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink);">
                    </div>

                    <div class="form-group" style="margin-bottom: 12px;">
                        <label style="display: block; font-weight: 700; margin-bottom: 4px;">Descripción o Notas del Trabajo</label>
                        <textarea name="descripcion" rows="3" placeholder="Ingresa un resumen o contexto de los recursos..." style="width: 100%; border-radius: 8px; padding: 10px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink);"></textarea>
                    </div>

                    <!-- SELECCIÓN DE SEMANA: SOPORTA MÚLTIPLES TRABAJOS POR SEMANA -->
                    <div class="form-group" style="margin-bottom: 12px;">
                        <label style="display: block; font-weight: 700; margin-bottom: 4px;">Semana Académica Asignada</label>
                        <select name="semana" id="semanaSelect" required style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink);">
                            <% for (int i = 1; i <= 16; i++) { %>
                                <option value="<%= i %>">Semana <%= String.format("%02d", i) %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 16px;">
                        <label style="display: block; font-weight: 700; margin-bottom: 4px;">Categoría Predeterminada</label>
                        <select name="tipo" style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink);">
                            <option value="auto">Detección automática por extensión</option>
                            <option value="pdf">Documento PDF</option>
                            <option value="documento">Documento Word / Texto</option>
                            <option value="imagen">Imagen / Diagrama</option>
                        </select>
                    </div>

                    <div class="drop-zone" id="dropZone" onclick="document.getElementById('fileInput').click();" style="cursor: pointer; border: 2px dashed var(--line); border-radius: 12px; padding: 24px; text-align: center; transition: all 0.2s;">
                        <div class="drop-zone-icon" style="font-size: 36px; margin-bottom: 8px;">📁</div>
                        <p id="dropZoneTitle" style="font-weight: 700; font-size: 14px; margin-bottom: 4px;">Arrastra uno o varios archivos aquí o haz clic para examinar</p>
                        <p style="color: var(--muted); font-size: 12px; margin-bottom: 8px;">Puedes seleccionar múltiples archivos en una sola subida (PDF, DOCX, PNG, JPG)</p>
                        <div id="fileListPreview" style="margin-top: 12px; display: none; text-align: left; background: var(--surface); padding: 12px; border-radius: 8px; border: 1px solid var(--line); font-size: 12px;"></div>
                        <input type="file" id="fileInput" name="archivos" multiple style="display: none;">
                    </div>

                    <button type="submit" id="submitBtn" class="btn btn-primary" style="width: 100%; margin-top: 16px;">Guardar y Publicar Trabajo(s)</button>
                </form>
            </section>

            <section class="content-panel" style="margin-top: 24px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; flex-wrap: wrap; gap: 10px;">
                    <h3 style="margin: 0;">Repositorio Activo (<span id="totalCount"><%= (archivos != null) ? archivos.size() : 0 %></span> trabajos)</h3>
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <label for="filtroSemana" style="font-size: 13px; font-weight: 700; color: var(--muted);">Filtrar por semana:</label>
                        <select id="filtroSemana" onchange="filtrarSemana(this.value)" style="padding: 6px 12px; border-radius: 6px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink); font-size: 13px;">
                            <option value="todas">Todas las semanas</option>
                            <% for (int i = 1; i <= 16; i++) { %>
                                <option value="<%= i %>">Semana <%= String.format("%02d", i) %></option>
                            <% } %>
                        </select>
                    </div>
                </div>
                
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; font-size: 13px;" id="tablaArchivos">
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
                            <tr class="fila-archivo" data-semana="<%= arch.getSemana() %>" style="border-bottom: 1px solid var(--line);">
                                <td style="padding: 10px;">
                                    <strong><%= arch.getNombre() %></strong>
                                    <% if (arch.getDescripcion() != null && !arch.getDescripcion().trim().isEmpty()) { %>
                                        <div style="color: var(--muted); font-size: 11px; margin-top: 2px;"><%= arch.getDescripcion() %></div>
                                    <% } %>
                                </td>
                                <td style="padding: 10px;">
                                    <a href="${pageContext.request.contextPath}/semana?num=<%= arch.getSemana() %>" target="_blank" style="color: var(--ink); text-decoration: none;">
                                        <span style="background: rgba(49, 94, 251, 0.1); color: var(--blue); padding: 3px 8px; border-radius: 4px; font-weight: 700; font-size: 11px;">
                                            Semana <%= String.format("%02d", arch.getSemana()) %> ↗
                                        </span>
                                    </a>
                                </td>
                                <td style="padding: 10px;"><span style="color: var(--blue); font-weight: 700;"><%= arch.getTipo().toUpperCase() %></span></td>
                                <td style="padding: 10px; white-space: nowrap;">
                                    <a href="${pageContext.request.contextPath}/archivos?action=ver&id=<%= arch.getId() %>" style="color: var(--blue); font-weight: 700; margin-right: 12px;">Ver</a>
                                    <a href="${pageContext.request.contextPath}/descargar-archivo?id=<%= arch.getId() %>" target="_blank" style="color: var(--muted); font-weight: 600; margin-right: 12px;">Descargar</a>
                                    <a href="${pageContext.request.contextPath}/archivos?action=eliminar&id=<%= arch.getId() %>" style="color: var(--red); font-weight: 700;" onclick="return confirm('¿Eliminar este trabajo?');">Eliminar</a>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr id="filaVacia">
                                <td colspan="4" style="text-align: center; color: var(--muted); padding: 20px;">No hay archivos en la base de datos.</td>
                            </tr>
                            <% } %>
                            <tr id="sinCoincidencias" style="display: none;">
                                <td colspan="4" style="text-align: center; color: var(--muted); padding: 20px;">No hay trabajos subidos para la semana seleccionada.</td>
                            </tr>
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
<script>
    const fileInput = document.getElementById('fileInput');
    const dropZone = document.getElementById('dropZone');
    const dropZoneTitle = document.getElementById('dropZoneTitle');
    const fileListPreview = document.getElementById('fileListPreview');
    const uploadForm = document.getElementById('uploadForm');

    if (fileInput) {
        fileInput.addEventListener('change', updateFileList);
    }

    if (dropZone) {
        dropZone.addEventListener('dragover', (e) => {
            e.preventDefault();
            dropZone.style.borderColor = 'var(--blue)';
            dropZone.style.background = 'rgba(49, 94, 251, 0.05)';
        });
        dropZone.addEventListener('dragleave', (e) => {
            e.preventDefault();
            dropZone.style.borderColor = 'var(--line)';
            dropZone.style.background = 'transparent';
        });
        dropZone.addEventListener('drop', (e) => {
            e.preventDefault();
            dropZone.style.borderColor = 'var(--line)';
            dropZone.style.background = 'transparent';
            if (e.dataTransfer.files && e.dataTransfer.files.length > 0) {
                fileInput.files = e.dataTransfer.files;
                updateFileList();
            }
        });
    }

    function updateFileList() {
        const files = fileInput.files;
        if (!files || files.length === 0) {
            dropZoneTitle.textContent = "Arrastra uno o varios archivos aquí o haz clic para examinar";
            fileListPreview.style.display = 'none';
            fileListPreview.innerHTML = '';
            return;
        }
        dropZoneTitle.innerHTML = `<strong>${files.length} archivo(s) seleccionado(s)</strong>`;
        let html = '<div style="font-weight:700; margin-bottom:6px; color:var(--blue);">Archivos listos para subir:</div><ul style="padding-left:18px; margin:0;">';
        for (let i = 0; i < files.length; i++) {
            const sizeKB = (files[i].size / 1024).toFixed(1);
            html += `<li><strong>${files[i].name}</strong> <span style="color:var(--muted);">(${sizeKB} KB)</span></li>`;
        }
        html += '</ul>';
        fileListPreview.innerHTML = html;
        fileListPreview.style.display = 'block';
    }

    if (uploadForm) {
        uploadForm.addEventListener('submit', (e) => {
            if (!fileInput.files || fileInput.files.length === 0) {
                e.preventDefault();
                alert('Por favor selecciona al menos un archivo para subir.');
            }
        });
    }

    function filtrarSemana(semana) {
        const filas = document.querySelectorAll('.fila-archivo');
        const sinCoincidencias = document.getElementById('sinCoincidencias');
        let visibles = 0;

        filas.forEach(fila => {
            const filaSemana = fila.getAttribute('data-semana');
            if (semana === 'todas' || filaSemana === semana) {
                fila.style.display = '';
                visibles++;
            } else {
                fila.style.display = 'none';
            }
        });

        if (sinCoincidencias) {
            sinCoincidencias.style.display = (visibles === 0 && filas.length > 0) ? '' : 'none';
        }
    }
</script>
</body>
</html>
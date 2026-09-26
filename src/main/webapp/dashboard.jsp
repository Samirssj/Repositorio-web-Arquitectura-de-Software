<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.miportafolio.model.Archivo" %>
<%@ page import="com.miportafolio.model.Usuario" %>
<%@ page import="com.miportafolio.service.StorageService" %>
<%@ page import="com.miportafolio.util.SessionUtil" %>
<%
    Usuario usuarioSesion = SessionUtil.getUsuarioAutenticado(request);
    if (usuarioSesion == null || !"admin".equals(usuarioSesion.getRol())) {
        response.sendRedirect("login.jsp?error=sesion_requerida");
        return;
    }


    // Carga de respaldo si se entra a la página directamente
    List<Archivo> archivos = (List<Archivo>) request.getAttribute("archivos");
    if (archivos == null) {
        StorageService service = new StorageService();
        archivos = service.listarTodosArchivos();
    }

    String paramSem = request.getParameter("semana");
    int defaultSem = 3;
    if (paramSem != null && !paramSem.trim().isEmpty()) {
        try { defaultSem = Integer.parseInt(paramSem.trim()); } catch (Exception ignored) {}
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administración | Academia</title>
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
            <p style="color: var(--muted); font-size: 14px;">Sube y edita recursos (imágenes, documentos, guías, códigos) asignados a cualquier semana (1 a 16).</p>
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

        <% if ("archivo_editado".equals(request.getParameter("mensaje"))) { 
            String semParam = request.getParameter("semana");
        %>
            <div style="padding: 14px 18px; background: rgba(34, 197, 94, 0.12); border: 1px solid #22c55e; color: #22c55e; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 10px;">
                <span>✓ <strong>¡Éxito!</strong> El trabajo académico fue modificado y guardado correctamente.</span>
                <% if (semParam != null && !semParam.trim().isEmpty()) { %>
                    <a href="${pageContext.request.contextPath}/semana?num=<%= semParam %>" target="_blank" style="color: #22c55e; font-weight: 700; text-decoration: underline; font-size: 13px;">Ver en Semana <%= semParam %> →</a>
                <% } %>
            </div>
        <% } %>

        <div class="dashboard-content">
            <!-- PANEL DE SUBIDA: SOPORTA IMÁGENES Y DOCUMENTOS EN CUALQUIER SEMANA -->
            <section class="content-panel">
                <h3 style="margin-bottom: 12px;">📤 Subir Trabajos / Recursos Académicos</h3>
                <p style="color: var(--muted); font-size: 13px; margin-bottom: 16px;">
                    Puedes subir <strong>imágenes</strong> (PNG, JPG, SVG, WebP) y <strong>documentos</strong> (PDF, Word, TXT, ZIP, código) a <strong>cualquier semana académica (1 a 16)</strong>, de forma individual o múltiple.
                </p>
                
                <form action="${pageContext.request.contextPath}/subir-archivo" method="POST" enctype="multipart/form-data" id="uploadForm">
                    <div class="form-group" style="margin-bottom: 12px;">
                        <label style="display: block; font-weight: 700; margin-bottom: 4px;">Título del Proyecto o Prefijo (Opcional si subes varios)</label>
                        <input type="text" name="nombre" id="nombreInput" placeholder="Ej. Diagrama de Arquitectura / Guía Práctica (O deja vacío para usar el nombre del archivo)" style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink);">
                    </div>

                    <div class="form-group" style="margin-bottom: 12px;">
                        <label style="display: block; font-weight: 700; margin-bottom: 4px;">Descripción o Notas del Trabajo</label>
                        <textarea name="descripcion" rows="3" placeholder="Ingresa un resumen o contexto de los recursos..." style="width: 100%; border-radius: 8px; padding: 10px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink);"></textarea>
                    </div>

                    <!-- SELECCIÓN DE CUALQUIER SEMANA: 1 A 16 -->
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 16px;">
                        <div class="form-group">
                            <label style="display: block; font-weight: 700; margin-bottom: 4px;">Semana Académica Asignada</label>
                            <select name="semana" id="semanaSelect" required style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink);">
                                <% for (int i = 1; i <= 16; i++) { %>
                                    <option value="<%= i %>" <%= (i == defaultSem ? "selected" : "") %>>Semana <%= String.format("%02d", i) %></option>
                                <% } %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label style="display: block; font-weight: 700; margin-bottom: 4px;">Modo de Carga</label>
                            <div style="padding: 10px; border-radius: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink); font-size: 13px; font-weight: 600;">
                                ✨ Carga simultánea múltiple (Imagen + Documento)
                            </div>
                        </div>
                    </div>

                    <!-- CASILLAS DUALES INDEPENDIENTES PARA IMAGEN Y DOCUMENTO -->
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 16px; margin-bottom: 16px;">
                        
                        <!-- CASILLA 1: IMAGEN / INFOGRAFÍA -->
                        <div style="background: var(--surface-soft); border: 2px dashed var(--line); border-radius: 12px; padding: 18px; text-align: center; position: relative;" id="boxImagen">
                            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px;">
                                <span style="font-weight: 700; font-size: 13px; color: var(--ink); display: flex; align-items: center; gap: 6px;">
                                    <span>🖼️</span> 1. Imagen / Infografía
                                </span>
                                <span style="font-size: 10px; background: rgba(0, 64, 255, 0.18); color: #00f7ff; padding: 2px 7px; border-radius: 4px; font-weight: 700; border: 1px solid rgba(0, 64, 255, 0.35);">PNG, JPG, WebP</span>
                            </div>

                            <div id="dropImagenArea" onclick="document.getElementById('inputImagen').click();" style="cursor: pointer; padding: 14px 8px; border-radius: 8px; transition: all 0.2s;">
                                <div id="placeholderImagen">
                                    <div style="font-size: 32px; margin-bottom: 6px;">📸</div>
                                    <p style="margin: 0 0 4px 0; font-size: 13px; font-weight: 700; color: var(--ink);">Elegir Imagen o Diagrama</p>
                                    <span style="font-size: 11px; color: var(--muted);">o arrastra la imagen aquí</span>
                                </div>
                                <div id="previewImagen" style="display: none; align-items: center; gap: 10px; text-align: left; background: var(--surface); padding: 8px 10px; border-radius: 8px; border: 1px solid var(--line);">
                                    <img id="imgThumb" src="" alt="Vista previa" style="width: 48px; height: 48px; object-fit: cover; border-radius: 6px; flex-shrink: 0;">
                                    <div style="flex: 1; min-width: 0;">
                                        <div id="imgName" style="font-weight: 700; font-size: 12px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; color: var(--ink);"></div>
                                        <div id="imgSize" style="font-size: 11px; color: var(--muted);"></div>
                                    </div>
                                    <button type="button" onclick="quitarImagen(event)" style="background: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239,68,68,0.2); color: #ef4444; border-radius: 6px; padding: 4px 8px; font-size: 12px; cursor: pointer;" title="Eliminar de la selección">✕</button>
                                </div>
                            </div>
                            <input type="file" id="inputImagen" name="archivo_imagen" accept="image/*,.png,.jpg,.jpeg,.webp,.svg" style="display: none;">
                        </div>

                        <!-- CASILLA 2: DOCUMENTO / INFORME TÉCNICO -->
                        <div style="background: var(--surface-soft); border: 2px dashed var(--line); border-radius: 12px; padding: 18px; text-align: center; position: relative;" id="boxDoc">
                            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px;">
                                <span style="font-weight: 700; font-size: 13px; color: var(--ink); display: flex; align-items: center; gap: 6px;">
                                    <span>📄</span> 2. Documento / Informe
                                </span>
                                <span style="font-size: 10px; background: rgba(239, 68, 68, 0.15); color: #ef4444; padding: 2px 6px; border-radius: 4px; font-weight: 700;">PDF, Word, ZIP</span>
                            </div>

                            <div id="dropDocArea" onclick="document.getElementById('inputDoc').click();" style="cursor: pointer; padding: 14px 8px; border-radius: 8px; transition: all 0.2s;">
                                <div id="placeholderDoc">
                                    <div style="font-size: 32px; margin-bottom: 6px;">📑</div>
                                    <p style="margin: 0 0 4px 0; font-size: 13px; font-weight: 700; color: var(--ink);">Elegir Documento o PDF</p>
                                    <span style="font-size: 11px; color: var(--muted);">o arrastra el documento aquí</span>
                                </div>
                                <div id="previewDoc" style="display: none; align-items: center; gap: 10px; text-align: left; background: var(--surface); padding: 8px 10px; border-radius: 8px; border: 1px solid var(--line);">
                                    <div id="docIcon" style="font-size: 28px; flex-shrink: 0;">📄</div>
                                    <div style="flex: 1; min-width: 0;">
                                        <div id="docName" style="font-weight: 700; font-size: 12px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; color: var(--ink);"></div>
                                        <div id="docSize" style="font-size: 11px; color: var(--muted);"></div>
                                    </div>
                                    <button type="button" onclick="quitarDoc(event)" style="background: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239,68,68,0.2); color: #ef4444; border-radius: 6px; padding: 4px 8px; font-size: 12px; cursor: pointer;" title="Eliminar de la selección">✕</button>
                                </div>
                            </div>
                            <input type="file" id="inputDoc" name="archivo_documento" accept=".pdf,.doc,.docx,.txt,.zip,.rar,.7z,.java,.py,.sql,.ppt,.pptx" style="display: none;">
                        </div>
                    </div>

                    <!-- CASILLA 3: MÁS ARCHIVOS ADICIONALES (OPCIONAL) -->
                    <details style="margin-bottom: 16px; background: var(--surface-soft); border: 1px solid var(--line); border-radius: 8px; padding: 10px 14px;">
                        <summary style="cursor: pointer; font-weight: 600; font-size: 13px; color: var(--muted); outline: none;">
                            ➕ ¿Quieres adjuntar más archivos a la misma semana? (Opcional)
                        </summary>
                        <div style="margin-top: 10px;">
                            <input type="file" id="inputExtras" name="archivos_extra" multiple style="width: 100%; font-size: 13px; color: var(--ink);">
                            <span style="font-size: 11px; color: var(--muted); display: block; margin-top: 4px;">Selecciona múltiples archivos adicionales si lo requieres.</span>
                        </div>
                    </details>

                    <!-- RESUMEN DINÁMICO EN TIEMPO REAL -->
                    <div id="resumenUpload" style="display: none; padding: 12px 16px; background: rgba(0, 64, 255, 0.15); border: 1px solid rgba(0, 64, 255, 0.4); border-radius: 8px; margin-bottom: 16px; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 8px;">
                        <span id="resumenTexto" style="font-size: 13px; font-weight: 700; color: #00f7ff;"></span>
                        <span style="font-size: 12px; color: var(--muted);">Listos para guardar en Supabase</span>
                    </div>

                    <button type="submit" id="submitBtn" class="btn btn-primary" style="width: 100%; padding: 14px; font-size: 15px; font-weight: 700;">
                        🚀 Guardar y Publicar Recursos en la Semana
                    </button>
                </form>
            </section>

            <!-- PANEL DE LISTADO Y GESTIÓN CON OPCIÓN DE EDICIÓN -->
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
                                        String descSegura = (arch.getDescripcion() != null) ? arch.getDescripcion().replace("'", "\\'").replace("\"", "&quot;").replace("\n", " ") : "";
                                        String nomSeguro = arch.getNombre().replace("'", "\\'").replace("\"", "&quot;");
                                        String urlSegura = arch.getUrl().replace("'", "\\'");
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
                                        <span style="background: rgba(0, 64, 255, 0.18); color: #00f7ff; border: 1px solid rgba(0, 64, 255, 0.35); padding: 3px 8px; border-radius: 4px; font-weight: 700; font-size: 11px;">
                                            Semana <%= String.format("%02d", arch.getSemana()) %> ↗
                                        </span>
                                    </a>
                                </td>
                                <td style="padding: 10px;"><span style="color: #00f7ff; font-weight: 700;"><%= arch.getTipo().toUpperCase() %></span></td>
                                <td style="padding: 10px; white-space: nowrap;">
                                    <!-- BOTÓN EDITAR -->
                                    <button type="button" onclick="abrirModalEditar('<%= arch.getId() %>', '<%= nomSeguro %>', '<%= descSegura %>', '<%= arch.getSemana() %>', '<%= arch.getTipo() %>', '<%= urlSegura %>')" style="background: none; border: none; color: #00f7ff; font-weight: 700; cursor: pointer; padding: 0; margin-right: 12px; font-size: 13px;" title="Editar este trabajo">
                                        ✏️ Editar
                                    </button>
                                    <a href="${pageContext.request.contextPath}/archivos?action=ver&id=<%= arch.getId() %>" style="color: var(--ink); font-weight: 600; margin-right: 12px;">Ver</a>
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

<!-- MODAL PARA EDITAR TRABAJOS DIRECTAMENTE -->
<div id="editModal" class="media-modal" onclick="cerrarModalEditar(event)">
    <div class="media-modal-card" onclick="event.stopPropagation()" style="width: 100%; max-width: 580px; padding: 24px;">
        <button class="media-modal-close" onclick="cerrarModalEditar()" title="Cerrar (Esc)">✕</button>
        <div style="margin-bottom: 16px; border-bottom: 1px solid var(--line); padding-bottom: 10px;">
            <h3 style="margin: 0; font-size: 18px; color: var(--ink);">✏️ Editar Trabajo Académico</h3>
            <span style="font-size: 12px; color: var(--muted);">Modifica el nombre, descripción, semana asignada o reemplaza el archivo</span>
        </div>

        <form action="${pageContext.request.contextPath}/editar-archivo" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="id" id="editId">

            <div class="form-group" style="margin-bottom: 14px;">
                <label style="display: block; font-weight: 700; margin-bottom: 4px; font-size: 12px;">Título del Trabajo / Archivo</label>
                <input type="text" name="nombre" id="editNombre" required style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink); font-size: 13px;">
            </div>

            <div class="form-group" style="margin-bottom: 14px;">
                <label style="display: block; font-weight: 700; margin-bottom: 4px; font-size: 12px;">Descripción o Notas</label>
                <textarea name="descripcion" id="editDescripcion" rows="3" style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink); font-size: 13px;"></textarea>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 14px;">
                <div class="form-group">
                    <label style="display: block; font-weight: 700; margin-bottom: 4px; font-size: 12px;">Semana Asignada (1 a 16)</label>
                    <select name="semana" id="editSemana" style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink); font-size: 13px;">
                        <% for (int i = 1; i <= 16; i++) { %>
                            <option value="<%= i %>">Semana <%= String.format("%02d", i) %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label style="display: block; font-weight: 700; margin-bottom: 4px; font-size: 12px;">Tipo / Categoría</label>
                    <select name="tipo" id="editTipo" style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--line); background: var(--surface-soft); color: var(--ink); font-size: 13px;">
                        <option value="auto">Detección automática</option>
                        <option value="imagen">Imagen / Diagrama</option>
                        <option value="pdf">Documento PDF</option>
                        <option value="documento">Documento Word / Código</option>
                    </select>
                </div>
            </div>

            <div style="background: var(--surface-soft); border: 1px solid var(--line); padding: 12px; border-radius: 8px; margin-bottom: 20px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                    <span style="font-size: 11px; font-weight: 700; color: var(--muted); text-transform: uppercase;">Archivo actual:</span>
                    <a id="editCurrentFileLink" href="#" target="_blank" style="font-size: 11px; font-weight: 700; color: #00f7ff; text-decoration: none;">Ver actual ↗</a>
                </div>
                <div id="editCurrentFilePath" style="font-size: 12px; font-family: 'JetBrains Mono', monospace; color: var(--ink); word-break: break-all; margin-bottom: 8px;"></div>
                
                <label style="display: block; font-weight: 700; margin-bottom: 4px; font-size: 12px;">Reemplazar archivo (Opcional):</label>
                <input type="file" name="nuevoArchivo" style="width: 100%; font-size: 12px;">
                <span style="font-size: 11px; color: var(--muted); display: block; margin-top: 3px;">Deja vacío si deseas conservar el archivo actual.</span>
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 10px;">
                <button type="button" onclick="cerrarModalEditar()" class="btn" style="background: var(--surface-soft); color: var(--ink); border: 1px solid var(--line); padding: 8px 16px; border-radius: 6px; font-size: 12px; font-weight: 700;">Cancelar</button>
                <button type="submit" class="btn btn-primary" style="padding: 8px 18px; font-size: 12px; font-weight: 700;">💾 Guardar Cambios</button>
            </div>
        </form>
    </div>
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
    const inputImagen = document.getElementById('inputImagen');
    const inputDoc = document.getElementById('inputDoc');
    const inputExtras = document.getElementById('inputExtras');
    const semanaSelect = document.getElementById('semanaSelect');
    const uploadForm = document.getElementById('uploadForm');

    const placeholderImagen = document.getElementById('placeholderImagen');
    const previewImagen = document.getElementById('previewImagen');
    const imgThumb = document.getElementById('imgThumb');
    const imgName = document.getElementById('imgName');
    const imgSize = document.getElementById('imgSize');
    const boxImagen = document.getElementById('boxImagen');

    const placeholderDoc = document.getElementById('placeholderDoc');
    const previewDoc = document.getElementById('previewDoc');
    const docIcon = document.getElementById('docIcon');
    const docName = document.getElementById('docName');
    const docSize = document.getElementById('docSize');
    const boxDoc = document.getElementById('boxDoc');

    const resumenUpload = document.getElementById('resumenUpload');
    const resumenTexto = document.getElementById('resumenTexto');

    function actualizarResumen() {
        const hasImg = inputImagen.files && inputImagen.files.length > 0;
        const hasDoc = inputDoc.files && inputDoc.files.length > 0;
        const extrasCount = (inputExtras && inputExtras.files) ? inputExtras.files.length : 0;
        const semVal = semanaSelect ? semanaSelect.value : "1";
        const semPadded = String(semVal).padStart(2, '0');

        const total = (hasImg ? 1 : 0) + (hasDoc ? 1 : 0) + extrasCount;
        if (total === 0) {
            resumenUpload.style.display = 'none';
            return;
        }

        const partes = [];
        if (hasImg) partes.push("1 imagen (" + inputImagen.files[0].name + ")");
        if (hasDoc) partes.push("1 documento (" + inputDoc.files[0].name + ")");
        if (extrasCount > 0) partes.push(extrasCount + " archivo(s) adicional(es)");

        resumenTexto.textContent = "✓ " + total + " archivo(s) listo(s): " + partes.join(" + ") + " → Asignado a Semana " + semPadded;
        resumenUpload.style.display = 'flex';
    }

    if (inputImagen) {
        inputImagen.addEventListener('change', () => {
            if (inputImagen.files && inputImagen.files[0]) {
                const file = inputImagen.files[0];
                imgName.textContent = file.name;
                imgSize.textContent = (file.size / 1024).toFixed(1) + " KB";
                imgThumb.src = URL.createObjectURL(file);
                placeholderImagen.style.display = 'none';
                previewImagen.style.display = 'flex';
                boxImagen.style.borderColor = 'var(--blue)';
            } else {
                quitarImagen();
            }
            actualizarResumen();
        });
    }

    function quitarImagen(e) {
        if (e) e.stopPropagation();
        inputImagen.value = "";
        placeholderImagen.style.display = 'block';
        previewImagen.style.display = 'none';
        imgThumb.src = "";
        boxImagen.style.borderColor = 'var(--line)';
        actualizarResumen();
    }

    if (inputDoc) {
        inputDoc.addEventListener('change', () => {
            if (inputDoc.files && inputDoc.files[0]) {
                const file = inputDoc.files[0];
                docName.textContent = file.name;
                docSize.textContent = (file.size / 1024).toFixed(1) + " KB";
                const ext = file.name.split('.').pop().toLowerCase();
                if (ext === 'pdf') docIcon.textContent = '📄';
                else if (['doc', 'docx'].includes(ext)) docIcon.textContent = '📘';
                else if (['zip', 'rar', '7z'].includes(ext)) docIcon.textContent = '📦';
                else docIcon.textContent = '📝';
                placeholderDoc.style.display = 'none';
                previewDoc.style.display = 'flex';
                boxDoc.style.borderColor = 'var(--blue)';
            } else {
                quitarDoc();
            }
            actualizarResumen();
        });
    }

    function quitarDoc(e) {
        if (e) e.stopPropagation();
        inputDoc.value = "";
        placeholderDoc.style.display = 'block';
        previewDoc.style.display = 'none';
        boxDoc.style.borderColor = 'var(--line)';
        actualizarResumen();
    }

    if (inputExtras) {
        inputExtras.addEventListener('change', actualizarResumen);
    }
    if (semanaSelect) {
        semanaSelect.addEventListener('change', actualizarResumen);
    }

    // Drag and drop interactivo con clasificación automática
    function setupDropBox(box, input, isImg) {
        if (!box || !input) return;
        box.addEventListener('dragover', (e) => {
            e.preventDefault();
            box.style.borderColor = '#0040ff';
            box.style.background = 'rgba(0, 64, 255, 0.15)';
        });
        box.addEventListener('dragleave', (e) => {
            e.preventDefault();
            box.style.borderColor = 'var(--line)';
            box.style.background = 'var(--surface-soft)';
        });
        box.addEventListener('drop', (e) => {
            e.preventDefault();
            box.style.borderColor = 'var(--line)';
            box.style.background = 'var(--surface-soft)';
            if (e.dataTransfer.files && e.dataTransfer.files.length > 0) {
                const files = Array.from(e.dataTransfer.files);
                const imgFile = files.find(f => f.type.startsWith('image/') || /\.(png|jpg|jpeg|webp|svg)$/i.test(f.name));
                const docFile = files.find(f => !f.type.startsWith('image/') && !/\.(png|jpg|jpeg|webp|svg)$/i.test(f.name));

                if (imgFile && (!inputImagen.files || inputImagen.files.length === 0 || isImg)) {
                    const dt = new DataTransfer();
                    dt.items.add(imgFile);
                    inputImagen.files = dt.files;
                    inputImagen.dispatchEvent(new Event('change'));
                }
                if (docFile && (!inputDoc.files || inputDoc.files.length === 0 || !isImg)) {
                    const dt = new DataTransfer();
                    dt.items.add(docFile);
                    inputDoc.files = dt.files;
                    inputDoc.dispatchEvent(new Event('change'));
                }
            }
        });
    }

    setupDropBox(boxImagen, inputImagen, true);
    setupDropBox(boxDoc, inputDoc, false);

    if (uploadForm) {
        uploadForm.addEventListener('submit', (e) => {
            const hasImg = inputImagen.files && inputImagen.files.length > 0;
            const hasDoc = inputDoc.files && inputDoc.files.length > 0;
            const hasExtras = inputExtras.files && inputExtras.files.length > 0;

            if (!hasImg && !hasDoc && !hasExtras) {
                e.preventDefault();
                alert('Por favor selecciona al menos una imagen o un documento para subir.');
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

    function abrirModalEditar(id, nombre, descripcion, semana, tipo, url) {
        document.getElementById('editId').value = id;
        document.getElementById('editNombre').value = nombre;
        document.getElementById('editDescripcion').value = descripcion;
        document.getElementById('editSemana').value = semana;
        document.getElementById('editTipo').value = tipo || 'auto';
        document.getElementById('editCurrentFilePath').textContent = url;
        document.getElementById('editCurrentFileLink').href = '${pageContext.request.contextPath}/descargar-archivo?id=' + id;
        
        const modal = document.getElementById('editModal');
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    function cerrarModalEditar(e) {
        const modal = document.getElementById('editModal');
        if (!e || e.target === modal || e.target.classList.contains('media-modal-close') || e.target.tagName === 'BUTTON') {
            modal.classList.remove('active');
            document.body.style.overflow = '';
        }
    }

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            const editModal = document.getElementById('editModal');
            if (editModal && editModal.classList.contains('active')) {
                cerrarModalEditar();
            }
        }
    });
</script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.miportafolio.model.Archivo" %>
<%@ page import="com.miportafolio.dao.ArchivoDAO" %>
<%@ page import="com.miportafolio.model.SilaboData" %>
<%@ page import="com.miportafolio.model.SilaboData.UnidadInfo" %>
<%@ page import="com.miportafolio.model.SilaboData.SemanaInfo" %>
<%
    Integer numeroSemana = (Integer) request.getAttribute("numeroSemana");
    if (numeroSemana == null) {
        String numParam = request.getParameter("num");
        numeroSemana = (numParam != null && !numParam.trim().isEmpty()) ? Integer.parseInt(numParam.trim()) : 1;
    }

    List<Archivo> recursos = (List<Archivo>) request.getAttribute("recursos");
    if (recursos == null) {
        ArchivoDAO dao = new ArchivoDAO();
        recursos = dao.obtenerArchivosPorSemana(numeroSemana);
    }

    SemanaInfo infoSemana = SilaboData.getSemana(numeroSemana);
    UnidadInfo infoUnidad = SilaboData.getUnidadDeSemana(numeroSemana);
    List<UnidadInfo> todasUnidades = SilaboData.getUnidades();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Semana <%= String.format("%02d", numeroSemana) %> | <%= infoSemana.getTitulo() %> | UPLA</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3.6">
    <script>
        (function () {
            document.documentElement.setAttribute("data-theme", "dark");
        })();
    </script>
    <style>
        .sidebar-unit-title {
            font-size: 11px;
            font-weight: 800;
            color: #00f7ff;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 14px;
            margin-bottom: 6px;
            padding: 4px 10px;
            background: rgba(0, 64, 255, 0.18);
            border: 1px solid rgba(0, 64, 255, 0.35);
            border-radius: 6px;
        }
        .week-menu li a {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
            padding: 8px 12px;
            border-radius: 8px;
            text-decoration: none;
            color: var(--ink);
            transition: all 0.2s ease;
        }
        .week-menu li a:hover {
            background: rgba(255, 255, 255, 0.06);
            color: #00f7ff;
        }
        .week-menu li a.active {
            background: rgba(0, 64, 255, 0.2);
            color: #ffffff;
            font-weight: 700;
            border-left: 3px solid #0040ff;
            box-shadow: 0 0 12px rgba(0, 64, 255, 0.25);
        }
    </style>
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
    <div class="unit-detail-layout" style="align-items: flex-start; gap: 28px;">
        
        <!-- BARRA LATERAL: 4 UNIDADES DEL SÍLABO -->
        <aside class="sidebar-weeks" style="width: 290px; flex-shrink: 0; background: var(--surface); padding: 18px; border-radius: 12px; border: 1px solid var(--line);">
            <div style="margin-bottom: 12px; padding-bottom: 10px; border-bottom: 1px solid var(--line);">
                <span class="section-label" style="font-size: 10px;">SÍLABO 2026-I</span>
                <h4 style="margin: 4px 0 0; font-size: 14px;">4 Unidades · 16 Semanas</h4>
            </div>

            <div style="max-height: 720px; overflow-y: auto; padding-right: 4px;">
                <% for (UnidadInfo u : todasUnidades) { %>
                    <div class="sidebar-unit-title">
                        UNIDAD <%= u.getNumeroRomano() %> (SEM. <%= u.getSemanas().get(0).getNumero() %> - <%= u.getSemanas().get(3).getNumero() %>)
                    </div>
                    <ul class="week-menu" style="list-style: none; padding: 0; margin: 0 0 10px 0;">
                        <% for (SemanaInfo s : u.getSemanas()) { 
                            boolean esActiva = (s.getNumero() == numeroSemana);
                            String claseActiva = esActiva ? "active" : "";
                        %>
                            <li style="margin-bottom: 3px;">
                                <a href="semana?num=<%= s.getNumero() %>" class="<%= claseActiva %>" title="<%= s.getTitulo() %>">
                                    <span style="font-family: 'JetBrains Mono', monospace; font-weight: 700; font-size: 11px;">W<%= String.format("%02d", s.getNumero()) %></span>
                                    <span style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%= s.getTitulo() %></span>
                                </a>
                            </li>
                        <% } %>
                    </ul>
                <% } %>
            </div>
        </aside>

        <!-- SECCIÓN PRINCIPAL: ESTRUCTURA SEGÚN DISEÑO SOLICITADO, CON ESTILO NATIVO -->
        <section class="weeks-content" style="flex: 1; min-width: 0;">
            <div class="attachment-header">
                <div class="session-date-badge">
                    <span>📅</span> 2026-09-20
                </div>

                <h1 style="font-size: 24px; font-weight: 800; margin: 0 0 10px 0; color: var(--ink);">
                    <% if (numeroSemana == 1) { %>
                        Infografias Session01
                    <% } else { %>
                        Semana <%= String.format("%02d", numeroSemana) %>: <%= infoSemana.getTitulo() %>
                    <% } %>
                </h1>

                <p style="color: var(--muted); font-size: 14px; line-height: 1.6; margin: 0 0 20px 0; max-width: 800px;">
                    <% if (numeroSemana == 1) { %>
                        Elaborar infografias de arquitectura de software, estándares y atributos de calidad, de los puntos del 1-7 de la Sesion01_ArquitecturaSw_2026.
                    <% } else { %>
                        <%= infoSemana.getDesempeno() %>
                    <% } %>
                </p>

                <div class="attachment-subtitle">
                    <span style="font-size: 15px;">📎</span> ARCHIVOS ADJUNTOS
                </div>
            </div>

            <!-- CUADRÍCULA DE TARJETAS EN 4 COLUMNAS (ESTRUCTURA DE LA CAPTURA) -->
            <% if (recursos != null && !recursos.isEmpty()) { %>
                <div class="attachment-grid">
                    <% for (Archivo recurso : recursos) { %>
                        <article class="attachment-card">
                            <div class="attachment-thumb" onclick="abrirVisor('${pageContext.request.contextPath}/descargar-archivo?id=<%= recurso.getId() %>', '<%= recurso.getNombre().replace("'", "\\'") %>', '<%= recurso.getTipo() %>')" title="Clic para ampliar <%= recurso.getNombre() %>">
                                <% 
                                    String urlLower = (recurso.getUrl() != null) ? recurso.getUrl().toLowerCase() : "";
                                    String nomLower = (recurso.getNombre() != null) ? recurso.getNombre().toLowerCase() : "";
                                    if ("imagen".equalsIgnoreCase(recurso.getTipo())) { 
                                %>
                                    <img src="${pageContext.request.contextPath}/descargar-archivo?id=<%= recurso.getId() %>" alt="<%= recurso.getNombre() %>" loading="lazy">
                                <% } else if ("pdf".equalsIgnoreCase(recurso.getTipo()) || urlLower.endsWith(".pdf") || nomLower.contains("pdf")) { %>
                                    <div style="text-align: center; color: #ef4444; padding: 16px;">
                                        <div style="font-size: 38px; margin-bottom: 4px;">📄</div>
                                        <span style="font-size: 11px; font-weight: 700; color: #ef4444; text-transform: uppercase;">DOCUMENTO PDF</span>
                                    </div>
                                <% } else if (urlLower.endsWith(".doc") || urlLower.endsWith(".docx") || nomLower.contains("word") || nomLower.contains("informe")) { %>
                                    <div style="text-align: center; color: #0040ff; padding: 16px;">
                                        <div style="font-size: 38px; margin-bottom: 4px;">📘</div>
                                        <span style="font-size: 11px; font-weight: 700; color: #0040ff; text-transform: uppercase;">DOCUMENTO WORD</span>
                                    </div>
                                <% } else if (urlLower.endsWith(".zip") || urlLower.endsWith(".rar") || urlLower.endsWith(".7z")) { %>
                                    <div style="text-align: center; color: #eab308; padding: 16px;">
                                        <div style="font-size: 38px; margin-bottom: 4px;">📦</div>
                                        <span style="font-size: 11px; font-weight: 700; color: #eab308; text-transform: uppercase;">PAQUETE COMPRIMIDO</span>
                                    </div>
                                <% } else { %>
                                    <div style="text-align: center; color: var(--blue); padding: 16px;">
                                        <div style="font-size: 38px; margin-bottom: 4px;">📝</div>
                                        <span style="font-size: 11px; font-weight: 700; color: var(--blue); text-transform: uppercase;">DOCUMENTO ADJUNTO</span>
                                    </div>
                                <% } %>
                            </div>

                            <h3 class="attachment-title"><%= recurso.getNombre() %></h3>

                            <div class="attachment-actions">
                                <button type="button" class="btn-view" onclick="abrirVisor('${pageContext.request.contextPath}/descargar-archivo?id=<%= recurso.getId() %>', '<%= recurso.getNombre().replace("'", "\\'") %>', '<%= recurso.getTipo() %>')">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                        <circle cx="12" cy="12" r="3"></circle>
                                    </svg>
                                    Ver
                                </button>
                                <a href="${pageContext.request.contextPath}/descargar-archivo?id=<%= recurso.getId() %>&modo=descargar" class="btn-download">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                        <polyline points="7 10 12 15 17 10"></polyline>
                                        <line x1="12" y1="15" x2="12" y2="3"></line>
                                    </svg>
                                    Descargar
                                </a>
                            </div>
                        </article>
                    <% } %>
                </div>
            <% } else { %>
                <div class="attachment-card" style="text-align: center; padding: 48px 24px;">
                    <div style="font-size: 42px; margin-bottom: 12px;">📁</div>
                    <h3 style="font-size: 18px; margin-bottom: 8px; color: var(--ink);">No hay archivos cargados para esta semana</h3>
                    <p style="color: var(--muted); font-size: 13px; max-width: 500px; margin: 0 auto 20px;">
                        Los materiales de la <strong><%= infoSemana.getTitulo() %></strong> que subas desde el panel de administración aparecerán organizados aquí con este mismo formato.
                    </p>
                    <a href="${pageContext.request.contextPath}/dashboard.jsp" class="btn btn-primary" style="font-size: 13px; display: inline-block;">
                        Subir recursos a Semana <%= String.format("%02d", numeroSemana) %> →
                    </a>
                </div>
            <% } %>
        </section>
    </div>
</main>

<!-- MODAL / LIGHTBOX PARA VISUALIZAR EN ALTA DEFINICIÓN (DISEÑO LIMPIO) -->
<div id="mediaModal" class="media-modal" onclick="cerrarVisor(event)">
    <div class="media-modal-card" onclick="event.stopPropagation()">
        <button class="media-modal-close" onclick="cerrarVisor()" title="Cerrar (Esc)">✕</button>
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px; border-bottom: 1px solid var(--line); padding-bottom: 10px;">
            <h4 id="modalTitle" style="color: var(--ink); margin: 0; font-size: 16px; font-weight: 700;"></h4>
            <span style="font-size: 12px; color: var(--muted); font-weight: 600;">Semana <%= String.format("%02d", numeroSemana) %></span>
        </div>
        <div id="modalBody" style="text-align: center; overflow: auto; max-height: 75vh; display: flex; align-items: center; justify-content: center; background: var(--surface-soft); padding: 12px; border-radius: 8px; border: 1px solid var(--line);">
            <!-- Contenido dinámico (imagen o visor) -->
        </div>
        <div style="margin-top: 14px; display: flex; justify-content: space-between; align-items: center;">
            <span style="color: var(--muted); font-size: 12px;">Presiona ESC o haz clic fuera para cerrar</span>
            <a id="modalDownloadBtn" href="#" class="btn-download" style="padding: 8px 16px;">
                📥 Descargar archivo
            </a>
        </div>
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

<script src="${pageContext.request.contextPath}/js/theme.js?v=2.0"></script>
<script>
    const modal = document.getElementById('mediaModal');
    const modalTitle = document.getElementById('modalTitle');
    const modalBody = document.getElementById('modalBody');
    const modalDownloadBtn = document.getElementById('modalDownloadBtn');

    function abrirVisor(url, titulo, tipo) {
        modalTitle.textContent = titulo;
        modalDownloadBtn.href = url + '&modo=descargar';
        modalBody.innerHTML = '';

        if (tipo === 'imagen' || url.match(/\.(png|jpg|jpeg|gif|webp|svg)$/i)) {
            const img = document.createElement('img');
            img.src = url;
            img.alt = titulo;
            img.className = 'media-modal-img';
            modalBody.appendChild(img);
        } else if (tipo === 'pdf' || url.toLowerCase().includes('.pdf')) {
            const iframe = document.createElement('iframe');
            iframe.src = url;
            iframe.style.width = '85vw';
            iframe.style.height = '70vh';
            iframe.style.border = 'none';
            modalBody.appendChild(iframe);
        } else {
            const container = document.createElement('div');
            container.style.cssText = 'padding: 40px 20px; text-align: center; max-width: 500px; margin: 0 auto;';
            container.innerHTML = `
                <div style="font-size: 52px; margin-bottom: 14px;">📘</div>
                <h3 style="margin-bottom: 8px; color: var(--ink); font-size: 18px;">\${titulo}</h3>
                <p style="color: var(--muted); font-size: 13px; line-height: 1.5; margin: 0 0 24px 0;">
                    Este recurso está listo para ser descargado y consultado directamente en tu computadora.
                </p>
                <a href="\${url}&modo=descargar" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px; padding: 12px 24px; font-size: 14px; text-decoration: none;">
                    📥 Descargar Archivo Completo
                </a>
            `;
            modalBody.appendChild(container);
        }

        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    function cerrarVisor(e) {
        if (!e || e.target === modal || e.target.classList.contains('media-modal-close')) {
            modal.classList.remove('active');
            document.body.style.overflow = '';
            modalBody.innerHTML = '';
        }
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && modal.classList.contains('active')) {
            cerrarVisor();
        }
    });
</script>
</body>
</html>
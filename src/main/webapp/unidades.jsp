<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.miportafolio.model.SilaboData" %>
<%@ page import="com.miportafolio.model.SilaboData.UnidadInfo" %>
<%@ page import="com.miportafolio.model.SilaboData.SemanaInfo" %>
<%@ page import="com.miportafolio.dao.ArchivoDAO" %>
<%
    List<UnidadInfo> unidades = SilaboData.getUnidades();
    ArchivoDAO archivoDAO = new ArchivoDAO();
    Map<Integer, Integer> conteos = archivoDAO.contarArchivosPorTodasLasSemanas();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unidades y Semanas | Arquitectura de Software | UPLA</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3.5">
    <script>
        (function () {
            document.documentElement.setAttribute("data-theme", "dark");
        })();
    </script>
    <style>
        .unit-nav-bar {
            display: flex;
            gap: 10px;
            overflow-x: auto;
            padding-bottom: 8px;
            margin-bottom: 32px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .unit-nav-btn {
            padding: 8px 18px;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: var(--ink);
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            white-space: nowrap;
            transition: all 0.2s ease;
        }
        .unit-nav-btn:hover {
            border-color: #0040ff;
            background: rgba(0, 64, 255, 0.18);
            color: #00f7ff;
            box-shadow: 0 0 12px rgba(0, 64, 255, 0.3);
        }
        .unit-block {
            background: rgba(20, 20, 26, 0.85);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 28px;
            margin-bottom: 40px;
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
            box-shadow: var(--shadow-small);
        }
        .unit-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(0, 64, 255, 0.18);
            color: #00f7ff;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            padding: 5px 14px;
            border-radius: 20px;
            border: 1px solid rgba(0, 64, 255, 0.4);
            margin-bottom: 12px;
            box-shadow: 0 0 10px rgba(0, 64, 255, 0.2);
        }
        .unit-title-head {
            font-size: 22px;
            font-weight: 800;
            margin: 0 0 10px 0;
            color: #ffffff;
            line-height: 1.3;
        }
        .unit-capacidad-box {
            background: rgba(255, 255, 255, 0.04);
            border-left: 4px solid #0040ff;
            padding: 12px 16px;
            border-radius: 0 10px 10px 0;
            margin-bottom: 24px;
            font-size: 13px;
            color: var(--muted);
            line-height: 1.5;
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            border-right: 1px solid rgba(255, 255, 255, 0.05);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        .weeks-cards-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
        }
        @media (max-width: 1200px) {
            .weeks-cards-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 600px) {
            .weeks-cards-grid {
                grid-template-columns: 1fr;
            }
        }
        .week-item-card {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 14px;
            padding: 18px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.25s ease;
        }
        .week-item-card:hover {
            border-color: #0040ff;
            transform: translateY(-3px);
            box-shadow: 0 8px 25px -8px rgba(0, 64, 255, 0.4), 0 0 15px rgba(0, 64, 255, 0.2);
        }
        .week-number-tag {
            font-family: 'JetBrains Mono', monospace;
            font-size: 11px;
            font-weight: 700;
            color: #00f7ff;
            margin-bottom: 8px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .resource-count-badge {
            font-size: 10px;
            padding: 2px 7px;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.06);
            color: var(--muted);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .resource-count-badge.has-files {
            background: rgba(0, 64, 255, 0.2);
            color: #00f7ff;
            border-color: rgba(0, 64, 255, 0.4);
            font-weight: 700;
            box-shadow: 0 0 10px rgba(0, 64, 255, 0.35);
        }
        .week-title {
            font-size: 14px;
            font-weight: 700;
            color: #ffffff;
            margin: 0 0 10px 0;
            line-height: 1.35;
        }
        .week-desempeno {
            font-size: 12px;
            color: var(--muted);
            line-height: 1.5;
            margin: 0 0 16px 0;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .week-btn-enter {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            width: 100%;
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            text-decoration: none;
            background: var(--surface);
            color: var(--ink);
            border: 1px solid var(--line);
            transition: all 0.2s ease;
            margin-top: auto;
        }
        .week-btn-enter:hover {
            background: var(--blue);
            color: white;
            border-color: var(--blue);
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
    <div style="margin-bottom: 24px;">
        <span class="section-label">SÍLABO OFICIAL · CÓDIGO 332181</span>
        <h1 class="page-title" style="margin-bottom: 8px;">Arquitectura de Software</h1>
        <p class="page-lead" style="margin-bottom: 0;">
            Estructuración curricular en <strong>4 Unidades Temáticas</strong> y <strong>16 Semanas Académicas</strong> con sus respectivas capacidades, desempeños y materiales de clase.
        </p>
    </div>

    <!-- NAVEGACIÓN RÁPIDA POR UNIDADES -->
    <nav class="unit-nav-bar" aria-label="Navegación de unidades">
        <% for (UnidadInfo u : unidades) { %>
            <a href="#unidad-<%= u.getNumeroRomano().toLowerCase() %>" class="unit-nav-btn">
                Unidad <%= u.getNumeroRomano() %> (Semanas <%= u.getSemanas().get(0).getNumero() %> - <%= u.getSemanas().get(3).getNumero() %>)
            </a>
        <% } %>
    </nav>

    <!-- RENDERIZADO DE LAS 4 UNIDADES (4 SEMANAS CADA UNA = 16 SEMANAS) -->
    <% for (UnidadInfo u : unidades) { %>
        <section class="unit-block" id="unidad-<%= u.getNumeroRomano().toLowerCase() %>">
            <span class="unit-badge">UNIDAD <%= u.getNumeroRomano() %></span>
            <h2 class="unit-title-head"><%= u.getTitulo() %></h2>
            
            <div class="unit-capacidad-box">
                <strong style="color: var(--ink);">Capacidad / Competencia:</strong><br>
                <%= u.getCapacidad() %>
            </div>

            <!-- CUADRÍCULA DE LAS 4 SEMANAS DE ESTA UNIDAD -->
            <div class="weeks-cards-grid">
                <% for (SemanaInfo s : u.getSemanas()) { 
                    int cant = conteos.getOrDefault(s.getNumero(), 0);
                    boolean tieneArchivos = cant > 0;
                %>
                    <article class="week-item-card">
                        <div>
                            <div class="week-number-tag">
                                <span>SEMANA <%= String.format("%02d", s.getNumero()) %></span>
                                <span class="resource-count-badge <%= tieneArchivos ? "has-files" : "" %>">
                                    <%= cant %> <%= (cant == 1) ? "recurso" : "recursos" %>
                                </span>
                            </div>
                            <h3 class="week-title"><%= s.getTitulo() %></h3>
                            <p class="week-desempeno" title="<%= s.getDesempeno() %>"><%= s.getDesempeno() %></p>
                        </div>
                        <a href="${pageContext.request.contextPath}/semana?num=<%= s.getNumero() %>" class="week-btn-enter">
                            Ver trabajos y sesión →
                        </a>
                    </article>
                <% } %>
            </div>
        </section>
    <% } %>
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
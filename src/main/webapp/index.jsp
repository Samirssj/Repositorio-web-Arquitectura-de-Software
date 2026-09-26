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
    <title>Arquitectura de Software | Portafolio Académico UPLA</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3.6">
    <style>
        /* ============================================================
           ESTILOS ESPECÍFICOS: PRESENTACIÓN DEL CURSO (ESTILO SAMIR SABIEL)
           ============================================================ */
        .course-hero {
            position: relative;
            background: linear-gradient(135deg, #000000 0%, #030c27 45%, #081745 100%);
            border: 1px solid rgba(0, 64, 255, 0.35);
            border-radius: 24px;
            padding: 44px;
            color: #ffffff;
            box-shadow: 0 20px 45px -15px rgba(0, 0, 0, 0.8), 0 0 35px rgba(0, 64, 255, 0.25);
            margin-bottom: 40px;
            overflow: hidden;
            backdrop-filter: blur(16px);
        }

        .course-hero::before {
            content: '';
            position: absolute;
            top: -120px;
            right: -120px;
            width: 400px;
            height: 400px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(0, 64, 255, 0.3) 0%, transparent 70%);
            pointer-events: none;
        }

        .course-hero::after {
            content: '';
            position: absolute;
            bottom: -100px;
            left: -100px;
            width: 350px;
            height: 350px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(0, 247, 255, 0.18) 0%, transparent 70%);
            pointer-events: none;
        }

        .hero-layout {
            display: grid;
            grid-template-columns: 1.25fr 0.95fr;
            gap: 40px;
            align-items: center;
            position: relative;
            z-index: 2;
        }

        @media (max-width: 960px) {
            .hero-layout {
                grid-template-columns: 1fr;
                gap: 32px;
            }
            .course-hero {
                padding: 30px 24px;
            }
        }

        .hero-badge-container {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 16px;
        }

        .hero-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 12px;
            background: rgba(0, 64, 255, 0.18);
            border: 1px solid rgba(0, 64, 255, 0.45);
            border-radius: 999px;
            font-size: 11px;
            font-weight: 800;
            color: #00f7ff;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            box-shadow: 0 0 10px rgba(0, 64, 255, 0.25);
        }

        .hero-pill-secondary {
            background: rgba(255, 255, 255, 0.06);
            border-color: rgba(255, 255, 255, 0.15);
            color: #cbd5e1;
            box-shadow: none;
        }

        .pulse-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #00f7ff;
            box-shadow: 0 0 8px #00f7ff;
            animation: pulse-dot-anim 2s infinite;
        }

        @keyframes pulse-dot-anim {
            0% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(0, 247, 255, 0.7); }
            70% { transform: scale(1.1); box-shadow: 0 0 0 6px rgba(0, 247, 255, 0); }
            100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(0, 247, 255, 0); }
        }

        .hero-title {
            font-size: clamp(2.1rem, 3.6vw, 3rem);
            font-weight: 800;
            line-height: 1.15;
            color: #ffffff;
            margin-bottom: 8px;
            letter-spacing: -0.02em;
        }

        .hero-title-accent {
            background: linear-gradient(90deg, #00f7ff, #0040ff, #38bdf8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero-subtitle {
            font-size: 15px;
            font-weight: 700;
            color: #00f7ff;
            margin-bottom: 14px;
            text-shadow: 0 0 10px rgba(0, 247, 255, 0.3);
        }

        .hero-description {
            color: #94a3b8;
            font-size: 14px;
            line-height: 1.7;
            max-width: 620px;
            margin-bottom: 24px;
        }

        .hero-cta-group {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 28px;
        }

        .btn-glow {
            background: #0040ff;
            color: white;
            padding: 12px 24px;
            font-weight: 700;
            font-size: 14px;
            border-radius: 12px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.25s ease;
            box-shadow: 0 0 25px rgba(0, 64, 255, 0.55);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .btn-glow:hover {
            transform: translateY(-2px);
            background: #1f57ff;
            box-shadow: 0 0 35px rgba(0, 64, 255, 0.85);
            color: white;
        }

        .btn-outline-glass {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid #333333;
            color: #f1f5f9;
            padding: 12px 22px;
            font-weight: 700;
            font-size: 14px;
            border-radius: 12px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.25s ease;
            backdrop-filter: blur(8px);
        }

        .btn-outline-glass:hover {
            background: rgba(0, 64, 255, 0.18);
            border-color: #0040ff;
            color: #00f7ff;
            box-shadow: 0 0 15px rgba(0, 64, 255, 0.3);
            transform: translateY(-2px);
        }

        /* KPIs del curso en el Hero */
        .hero-stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        @media (max-width: 600px) {
            .hero-stats-row {
                grid-template-columns: repeat(2, 1fr);
                gap: 12px;
            }
        }

        .stat-item {
            background: rgba(14, 18, 28, 0.75);
            border: 1px solid rgba(0, 64, 255, 0.25);
            border-radius: 14px;
            padding: 10px 14px;
            transition: all 0.2s ease;
        }

        .stat-item:hover {
            border-color: rgba(0, 64, 255, 0.5);
            box-shadow: 0 0 15px rgba(0, 64, 255, 0.25);
        }

        .stat-number {
            font-family: 'JetBrains Mono', monospace;
            font-size: 22px;
            font-weight: 800;
            color: #00f7ff;
            line-height: 1.1;
            text-shadow: 0 0 10px rgba(0, 247, 255, 0.4);
        }

        .stat-label {
            font-size: 11px;
            font-weight: 600;
            color: #94a3b8;
            margin-top: 2px;
        }

        /* Tarjeta Blueprint de Arquitectura (Columna Derecha) */
        .blueprint-card {
            background: rgba(14, 18, 28, 0.88);
            border: 1px solid rgba(0, 64, 255, 0.35);
            border-radius: 20px;
            padding: 24px;
            backdrop-filter: blur(16px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.6), 0 0 25px rgba(0, 64, 255, 0.2);
            position: relative;
        }

        .blueprint-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 14px;
            margin-bottom: 16px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }

        .terminal-dots {
            display: flex;
            gap: 6px;
        }

        .t-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
        }
        .t-red { background: #ef4444; }
        .t-yellow { background: #f59e0b; }
        .t-green { background: #00f7ff; }

        .blueprint-title {
            font-family: 'JetBrains Mono', monospace;
            font-size: 12px;
            color: #94a3b8;
            font-weight: 600;
        }

        .arch-stack-layers {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .stack-layer {
            background: rgba(20, 24, 36, 0.85);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            padding: 10px 14px;
            transition: all 0.25s ease;
            position: relative;
            overflow: hidden;
        }

        .stack-layer::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
        }

        .stack-layer-4::before { background: #a855f7; }
        .stack-layer-3::before { background: #00f7ff; }
        .stack-layer-2::before { background: #0040ff; }
        .stack-layer-1::before { background: #10b981; }

        .stack-layer:hover {
            transform: translateX(4px);
            background: rgba(26, 32, 48, 0.95);
            border-color: #0040ff;
            box-shadow: 0 0 15px rgba(0, 64, 255, 0.3);
        }

        .layer-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 4px;
        }

        .layer-name {
            font-size: 12px;
            font-weight: 800;
            color: #f8fafc;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .layer-unit-tag {
            font-size: 10px;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 999px;
            background: rgba(0, 64, 255, 0.2);
            color: #00f7ff;
            border: 1px solid rgba(0, 64, 255, 0.35);
        }

        .layer-techs {
            font-family: 'JetBrains Mono', monospace;
            font-size: 11px;
            color: #94a3b8;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* SECCIÓN DE PILARES FORMATIVOS */
        .pillars-section {
            margin-bottom: 48px;
        }

        .pillars-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .pillar-card {
            background: rgba(20, 20, 26, 0.85);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 18px;
            padding: 24px;
            box-shadow: var(--shadow-small);
            transition: all 0.25s ease;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
        }

        .pillar-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 35px -10px rgba(0, 64, 255, 0.4), 0 0 25px rgba(0, 64, 255, 0.2);
            border-color: #0040ff;
        }

        .pillar-icon-box {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            background: rgba(0, 64, 255, 0.18);
            color: #00f7ff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            margin-bottom: 16px;
            border: 1px solid rgba(0, 64, 255, 0.35);
            box-shadow: 0 0 15px rgba(0, 64, 255, 0.25);
        }

        .pillar-title {
            font-size: 16px;
            font-weight: 800;
            color: #ffffff;
            margin-bottom: 8px;
            line-height: 1.3;
        }

        .pillar-desc {
            font-size: 13px;
            color: var(--muted);
            line-height: 1.6;
        }

        .pillar-badge {
            display: inline-block;
            margin-top: 12px;
            font-size: 11px;
            font-weight: 700;
            color: #00f7ff;
        }

        /* FICHA RESUMEN DEL CURSO */
        .course-meta-bar {
            background: rgba(20, 20, 26, 0.85);
            border: 1px solid rgba(0, 64, 255, 0.25);
            border-radius: 18px;
            padding: 20px 28px;
            display: flex;
            justify-content: space-around;
            align-items: center;
            gap: 20px;
            margin-bottom: 44px;
            box-shadow: 0 10px 30px -10px rgba(0, 64, 255, 0.25);
            flex-wrap: wrap;
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .meta-icon {
            font-size: 24px;
        }

        .meta-title {
            font-size: 11px;
            font-weight: 800;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .meta-val {
            font-size: 14px;
            font-weight: 800;
            color: #ffffff;
        }
    </style>
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
            <li><a class="active" href="${pageContext.request.contextPath}/index.jsp">Inicio</a></li>
            <li><a href="${pageContext.request.contextPath}/unidades.jsp">Unidades</a></li>
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
        <li><a class="active" href="${pageContext.request.contextPath}/index.jsp">🏠 Inicio</a></li>
        <li><a href="${pageContext.request.contextPath}/unidades.jsp">📚 Unidades</a></li>
        <li><a href="${pageContext.request.contextPath}/acerca.jsp">👤 Acerca de mí</a></li>
        <li><a href="${pageContext.request.contextPath}/login.jsp">🔐 Administración</a></li>
    </ul>
</aside>

<main class="page-shell">

    <!-- ============================================================
         HERO PRINCIPAL: PRESENTACIÓN MODERNA Y LLAMATIVA DEL CURSO
         ============================================================ -->
    <section class="course-hero">
        <div class="hero-layout">
            <div>
                <div class="hero-badge-container">
                    <span class="hero-pill">
                        <span class="pulse-dot"></span>
                        Asignatura Profesional · VIII Ciclo
                    </span>
                    <span class="hero-pill hero-pill-secondary">Código: 332181</span>
                    <span class="hero-pill hero-pill-secondary">Ingeniería de Sistemas</span>
                </div>

                <h1 class="hero-title">
                    Arquitectura de <span class="hero-title-accent">Software</span>
                </h1>

                <div class="hero-subtitle">
                    Universidad Peruana Los Andes · Facultad de Ingeniería
                </div>

                <p class="hero-description">
                    Espacio académico universitario y repositorio de recursos enfocado en el diseño, modelado orientado a objetos con UML, comunicación e integración de sistemas, y frameworks empresariales bajo estándares internacionales (ISO/IEC 25010 y IEEE 42010).
                </p>

                <div class="hero-cta-group">
                    <a href="#unidades-curso" class="btn-glow">
                        <span>📚</span>
                        <span>Explorar Unidades del Curso</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/unidades.jsp" class="btn-outline-glass">
                        <span>📄</span>
                        <span>Ver Sílabo Completo (16 Semanas)</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/acerca.jsp" class="btn-outline-glass">
                        <span>👤</span>
                        <span>Acerca del Autor</span>
                    </a>
                </div>

                <div class="hero-stats-row">
                    <div class="stat-item">
                        <div class="stat-number">16</div>
                        <div class="stat-label">Semanas Académicas</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">4</div>
                        <div class="stat-label">Unidades Temáticas</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">100%</div>
                        <div class="stat-label">Cobertura de Sílabo</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">ABP</div>
                        <div class="stat-label">Metodología de Proyectos</div>
                    </div>
                </div>
            </div>

            <!-- Columna Derecha: Stack y Blueprint Arquitectónico -->
            <div>
                <div class="blueprint-card">
                    <div class="blueprint-header">
                        <div class="terminal-dots">
                            <span class="t-dot t-red"></span>
                            <span class="t-dot t-yellow"></span>
                            <span class="t-dot t-green"></span>
                        </div>
                        <span class="blueprint-title">blueprint_arquitectura.json</span>
                    </div>

                    <div class="arch-stack-layers">
                        <div class="stack-layer stack-layer-4">
                            <div class="layer-top">
                                <span class="layer-name">⚡ Capa 4: Frameworks & Despliegue</span>
                                <span class="layer-unit-tag">Unidad IV</span>
                            </div>
                            <div class="layer-techs">Jakarta EE · Spring · Microservicios · Docker · Métricas</div>
                        </div>

                        <div class="stack-layer stack-layer-3">
                            <div class="layer-top">
                                <span class="layer-name">🔄 Capa 3: Comunicación e Integración</span>
                                <span class="layer-unit-tag">Unidad III</span>
                            </div>
                            <div class="layer-techs">REST APIs · WebSockets · Protocolos · Interoperabilidad</div>
                        </div>

                        <div class="stack-layer stack-layer-2">
                            <div class="layer-top">
                                <span class="layer-name">📐 Capa 2: Modelado POO & UML</span>
                                <span class="layer-unit-tag">Unidad II</span>
                            </div>
                            <div class="layer-techs">SOLID · Diagramas UML · Componentes · Bajo Acoplamiento</div>
                        </div>

                        <div class="stack-layer stack-layer-1">
                            <div class="layer-top">
                                <span class="layer-name">🏛️ Capa 1: Fundamentos & Estándares</span>
                                <span class="layer-unit-tag">Unidad I</span>
                            </div>
                            <div class="layer-techs">ISO/IEC 25010 · IEEE 42010 · Patrones MVC / Capas</div>
                        </div>
                    </div>

                    <div style="margin-top: 14px; padding-top: 12px; border-top: 1px solid rgba(255,255,255,0.08); display: flex; justify-content: space-between; align-items: center; font-size: 11px; color: #94a3b8;">
                        <span>Enfoque: Calidad & Escalabilidad</span>
                        <span style="color: #38bdf8; font-weight: 700;">Malla Curricular UPLA 2026</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ============================================================
         BARRA METADATA DEL CURSO
         ============================================================ -->
    <div class="course-meta-bar">
        <div class="meta-item">
            <span class="meta-icon">🏛️</span>
            <div>
                <div class="meta-title">Universidad</div>
                <div class="meta-val">Peruana Los Andes (UPLA)</div>
            </div>
        </div>

        <div class="meta-item">
            <span class="meta-icon">💻</span>
            <div>
                <div class="meta-title">Escuela Profesional</div>
                <div class="meta-val">Ingeniería de Sistemas y Computación</div>
            </div>
        </div>

        <div class="meta-item">
            <span class="meta-icon">🎓</span>
            <div>
                <div class="meta-title">Semestre</div>
                <div class="meta-val">VIII Ciclo Académico</div>
            </div>
        </div>

        <div class="meta-item">
            <span class="meta-icon">📋</span>
            <div>
                <div class="meta-title">Metodología</div>
                <div class="meta-val">Aprendizaje Basado en Proyectos (ABP)</div>
            </div>
        </div>
    </div>

    <!-- ============================================================
         PILARES DE LA ASIGNATURA
         ============================================================ -->
    <section class="pillars-section">
        <div class="section-heading">
            <div>
                <span class="section-label">COMPETENCIAS FORMATIVAS</span>
                <h2 style="font-size: 26px; font-weight: 800;">Pilares de la Arquitectura de Software</h2>
            </div>
            <a href="${pageContext.request.contextPath}/acerca.jsp" class="section-link">Conocer al autor →</a>
        </div>

        <div class="pillars-grid">
            <article class="pillar-card">
                <div class="pillar-icon-box">🏛️</div>
                <h3 class="pillar-title">Estándares y Calidad</h3>
                <p class="pillar-desc">
                    Dominio de las normas internacionales <strong>ISO/IEC 25010</strong> y <strong>IEEE 42010</strong>. Evaluación de atributos de calidad como mantenibilidad, rendimiento, seguridad y tolerancia a fallos.
                </p>
                <span class="pillar-badge">Unidad I · Semanas 1 a 4</span>
            </article>

            <article class="pillar-card">
                <div class="pillar-icon-box">📐</div>
                <h3 class="pillar-title">Modelado con UML y POO</h3>
                <p class="pillar-desc">
                    Aplicación de principios <strong>SOLID</strong>, alta cohesión y bajo acoplamiento. Representación lógica y física mediante diagramas de clases, paquetes, componentes y casos de uso.
                </p>
                <span class="pillar-badge">Unidad II · Semanas 5 a 8</span>
            </article>

            <article class="pillar-card">
                <div class="pillar-icon-box">🔄</div>
                <h3 class="pillar-title">Comunicación e Integración</h3>
                <p class="pillar-desc">
                    Diseño de interfaces de intercambio de datos, <strong>APIs RESTful</strong>, transmisión segura y desacoplada mediante protocolos de mensajería para sistemas distribuidos.
                </p>
                <span class="pillar-badge">Unidad III · Semanas 9 a 12</span>
            </article>

            <article class="pillar-card">
                <div class="pillar-icon-box">⚡</div>
                <h3 class="pillar-title">Frameworks y Despliegue</h3>
                <p class="pillar-desc">
                    Implementación de arquitecturas modernas utilizando tecnologías líderes como <strong>Jakarta EE</strong> y <strong>Spring</strong>, pruebas de carga y optimización estructural continua.
                </p>
                <span class="pillar-badge">Unidad IV · Semanas 13 a 16</span>
            </article>
        </div>
    </section>

    <!-- ============================================================
         SECCIÓN DE UNIDADES: RUTA DE APRENDIZAJE Y PROGRESO DINÁMICO
         ============================================================ -->
    <section id="unidades-curso" class="projects-section">
        <div class="section-heading">
            <div>
                <span class="section-label">PLAN DE ESTUDIOS OFICIAL</span>
                <h2 style="font-size: 26px; font-weight: 800;">Ruta de Aprendizaje y Entregables</h2>
            </div>
            <a href="${pageContext.request.contextPath}/unidades.jsp" class="section-link">Ver las 16 semanas detalladas →</a>
        </div>

        <div class="unit-cards-grid">
            <% for (UnidadInfo u : unidades) { 
                int totalSemanas = u.getSemanas().size();
                int semanasCompletadas = 0;
                for (SemanaInfo s : u.getSemanas()) {
                    if (conteos.getOrDefault(s.getNumero(), 0) > 0) {
                        semanasCompletadas++;
                    }
                }
                int porcentaje = (totalSemanas > 0) ? (semanasCompletadas * 100 / totalSemanas) : 0;
            %>
                <a href="${pageContext.request.contextPath}/unidades.jsp#unidad-<%= u.getNumeroRomano().toLowerCase() %>" class="unit-card-item">
                    <div>
                        <div class="unit-card-top">
                            <span class="unit-card-tag">UNIDAD <%= u.getNumeroRomano() %></span>
                            <span class="unit-card-status"><%= porcentaje %>% Completado</span>
                        </div>
                        <h3 class="unit-card-title">Unidad <%= u.getNumero() %>: <%= u.getTitulo() %></h3>
                        <p class="unit-card-desc"><%= u.getCapacidad() %></p>
                    </div>

                    <div class="unit-card-footer">
                        <div class="unit-progress-text">
                            <span class="unit-progress-label">Progreso de entregables</span>
                            <span class="unit-progress-ratio"><%= semanasCompletadas %>/<%= totalSemanas %> semanas</span>
                        </div>
                        <div class="unit-progress-track">
                            <div class="unit-progress-bar" style="width: <%= porcentaje %>%;"></div>
                        </div>
                    </div>
                </a>
            <% } %>
        </div>
    </section>
</main>

<footer class="site-footer">
    <div class="site-footer-inner">
        <div class="footer-brand">
            <a class="brand" href="${pageContext.request.contextPath}/index.jsp">
                <img src="https://www.sigc.gestorinfo.upla.edu.pe/storage/per/logo.png" alt="Logo UPLA" class="brand-mark-img">
                <span class="brand-text">UPLA</span>
            </a>
            <p style="margin-top: 8px;">Arquitectura de Software · Escuela Profesional de Ingeniería de Sistemas y Computación</p>
        </div>
        <div class="footer-column">
            <h4>Navegación</h4>
            <a href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
            <a href="${pageContext.request.contextPath}/unidades.jsp">Unidades y Semanas</a>
            <a href="${pageContext.request.contextPath}/acerca.jsp">Acerca de mí</a>
        </div>
        <div class="footer-column">
            <h4>Gestión</h4>
            <a href="${pageContext.request.contextPath}/login.jsp">Iniciar sesión</a>
            <a href="${pageContext.request.contextPath}/dashboard.jsp">Panel de Administración</a>
        </div>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/js/theme.js?v=2.0"></script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acerca de mí | Academia - UPLA</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3.6">
    <script>
        (function () {
            document.documentElement.setAttribute("data-theme", "dark");
        })();
    </script>
    <style>
        .about-grid {
            display: grid;
            grid-template-columns: 1fr 340px;
            gap: 28px;
            align-items: start;
        }

        @media (max-width: 960px) {
            .about-grid {
                grid-template-columns: 1fr;
            }
        }

        .profile-card {
            background: rgba(20, 20, 26, 0.85);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 36px;
            box-shadow: 0 10px 30px -10px rgba(0, 64, 255, 0.3);
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
        }

        .profile-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #0040ff, #00f7ff);
        }

        .profile-header-flex {
            display: flex;
            gap: 28px;
            align-items: center;
            margin-bottom: 28px;
        }

        @media (max-width: 640px) {
            .profile-header-flex {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }
        }

        .profile-img-wrapper {
            position: relative;
            flex-shrink: 0;
        }

        .profile-img {
            width: 150px;
            height: 195px;
            object-fit: cover;
            object-position: center top;
            border-radius: 18px;
            border: 3px solid #0040ff;
            box-shadow: 0 12px 28px rgba(0, 64, 255, 0.35);
            display: block;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .profile-img:hover {
            transform: scale(1.03);
            box-shadow: 0 16px 36px rgba(0, 64, 255, 0.5);
        }

        .profile-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 14px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 800;
            background: rgba(0, 64, 255, 0.18);
            color: #00f7ff;
            border: 1px solid rgba(0, 64, 255, 0.4);
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-bottom: 10px;
            box-shadow: 0 0 10px rgba(0, 64, 255, 0.2);
        }

        .profile-name {
            font-size: 28px;
            font-weight: 800;
            color: #ffffff;
            line-height: 1.2;
            margin-bottom: 8px;
        }

        .profile-tagline {
            color: #00f7ff;
            font-size: 14px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 8px;
            text-shadow: 0 0 10px rgba(0, 247, 255, 0.3);
        }

        @media (max-width: 640px) {
            .profile-tagline {
                justify-content: center;
            }
        }

        .profile-bio-text {
            color: var(--ink-soft);
            font-size: 15px;
            line-height: 1.85;
            margin-top: 10px;
            margin-bottom: 28px;
            background: rgba(255, 255, 255, 0.04);
            padding: 22px 24px;
            border-radius: 14px;
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-left: 4px solid #0040ff;
        }

        .highlights-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-top: 24px;
            padding-top: 24px;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
        }

        .highlight-card {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 14px;
            padding: 16px 18px;
            transition: all 0.2s ease;
        }

        .highlight-card:hover {
            transform: translateY(-2px);
            border-color: #0040ff;
            box-shadow: 0 0 15px rgba(0, 64, 255, 0.25);
        }

        .highlight-icon {
            font-size: 22px;
            margin-bottom: 8px;
            display: block;
        }

        .highlight-title {
            font-size: 13px;
            font-weight: 800;
            color: #ffffff;
            margin-bottom: 4px;
        }

        .highlight-desc {
            font-size: 12px;
            color: var(--muted);
            line-height: 1.5;
        }

        .sidebar-card {
            background: rgba(20, 20, 26, 0.85);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 18px;
            padding: 26px;
            box-shadow: var(--shadow-small);
            margin-bottom: 22px;
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
        }

        .skills-pills {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 14px;
        }

        .skill-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            color: var(--ink);
            transition: all 0.2s ease;
        }

        .skill-pill:hover {
            border-color: #0040ff;
            background: rgba(0, 64, 255, 0.18);
            color: #00f7ff;
            box-shadow: 0 0 10px rgba(0, 64, 255, 0.3);
            transform: translateY(-1px);
        }

        .info-row {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            margin-top: 14px;
            font-size: 13px;
            line-height: 1.5;
        }

        .info-row-icon {
            font-size: 16px;
            flex-shrink: 0;
            margin-top: 2px;
        }
    </style>
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
            <li><a class="active" href="${pageContext.request.contextPath}/acerca.jsp">Acerca de mí</a></li>
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
        <li><a href="${pageContext.request.contextPath}/unidades.jsp">📚 Unidades</a></li>
        <li><a class="active" href="${pageContext.request.contextPath}/acerca.jsp">👤 Acerca de mí</a></li>
        <li><a href="${pageContext.request.contextPath}/login.jsp">🔐 Administración</a></li>
    </ul>
</aside>

<main class="page-shell">
    <div style="margin-bottom: 28px;">
        <span class="section-label">PERFIL ACADÉMICO</span>
        <h1 style="font-size: 34px; font-weight: 800; margin-top: 6px; letter-spacing: -0.02em;">Acerca de mí</h1>
        <p style="color: var(--muted); font-size: 15px; margin-top: 6px;">
            Conoce más sobre mi trayectoria académica, intereses técnicos y los objetivos de este repositorio.
        </p>
    </div>

    <div class="about-grid">
        <!-- Tarjeta Principal de Perfil -->
        <article class="profile-card">
            <div class="profile-header-flex">
                <div class="profile-img-wrapper">
                    <img src="${pageContext.request.contextPath}/img/perfil.jpg" alt="Foto de perfil Samir Rojas" class="profile-img">
                </div>
                <div>
                    <span class="profile-badge">🎓 Estudiante Universitario</span>
                    <h2 class="profile-name">Samir Rojas</h2>
                    <div class="profile-tagline">
                        <span>Universidad Peruana Los Andes (UPLA)</span>
                        <span>•</span>
                        <span>Ingeniería de Sistemas</span>
                    </div>
                </div>
            </div>

            <!-- Texto solicitado por el usuario -->
            <div class="profile-bio-text">
                ¡Hola! Soy Samir Rojas, estudiante de la Universidad Peruana Los Andes, apasionado por la programación y el desarrollo tecnológico. En este blog comparto mis trabajos universitarios, proyectos de programación y herramientas que utilizo en mi formación académica. Mi objetivo es crear un espacio donde otros estudiantes puedan acceder libremente a recursos educativos y materiales de estudio. Especializado en desarrollo web, bases de datos y programación orientada a objetos. Siempre en búsqueda de nuevas tecnologías y metodologías que enriquezcan mi aprendizaje.
            </div>

            <div class="highlights-grid">
                <div class="highlight-card">
                    <span class="highlight-icon">🌐</span>
                    <div class="highlight-title">Desarrollo Web</div>
                    <div class="highlight-desc">Arquitectura MVC, JSP, Servlets, HTML5 semántico y CSS responsive.</div>
                </div>
                <div class="highlight-card">
                    <span class="highlight-icon">☕</span>
                    <div class="highlight-title">Java & POO</div>
                    <div class="highlight-desc">Programación orientada a objetos, JDBC, Maven y Jakarta EE.</div>
                </div>
                <div class="highlight-card">
                    <span class="highlight-icon">🗄️</span>
                    <div class="highlight-title">Bases de Datos</div>
                    <div class="highlight-desc">PostgreSQL relacional, Supabase en la nube y persistencia de datos.</div>
                </div>
            </div>

            <div style="margin-top: 30px; display: flex; gap: 12px; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary" style="padding: 10px 22px; font-weight: 700; text-decoration: none;">Explorar proyectos</a>
                <a href="${pageContext.request.contextPath}/unidades.jsp" class="btn btn-outline" style="padding: 10px 22px; font-weight: 700; text-decoration: none;">Ver unidades académicas</a>
            </div>
        </article>

        <!-- Barra lateral -->
        <aside>
            <div class="sidebar-card">
                <span class="section-label">DATOS ACADÉMICOS</span>
                <h3 style="font-size: 18px; font-weight: 800; margin-top: 6px; margin-bottom: 16px;">Institución</h3>

                <div class="info-row">
                    <span class="info-row-icon">🏛️</span>
                    <div>
                        <strong style="color: var(--ink);">Universidad:</strong><br>
                        <span style="color: var(--muted);">Universidad Peruana Los Andes</span>
                    </div>
                </div>

                <div class="info-row">
                    <span class="info-row-icon">💻</span>
                    <div>
                        <strong style="color: var(--ink);">Carrera:</strong><br>
                        <span style="color: var(--muted);">Ingeniería de Sistemas y Computación</span>
                    </div>
                </div>

                <div class="info-row">
                    <span class="info-row-icon">🎯</span>
                    <div>
                        <strong style="color: var(--ink);">Enfoque:</strong><br>
                        <span style="color: var(--muted);">Arquitectura de Software y Recursos Libres</span>
                    </div>
                </div>
            </div>

            <div class="sidebar-card">
                <span class="section-label">TECNOLOGÍAS</span>
                <h3 style="font-size: 18px; font-weight: 800; margin-top: 6px; margin-bottom: 12px;">Habilidades & Stack</h3>

                <div class="skills-pills">
                    <span class="skill-pill">☕ Java</span>
                    <span class="skill-pill">🚀 Jakarta EE</span>
                    <span class="skill-pill">🗄️ PostgreSQL</span>
                    <span class="skill-pill">⚡ Supabase</span>
                    <span class="skill-pill">🌐 HTML5 / CSS3</span>
                    <span class="skill-pill">📜 JavaScript</span>
                    <span class="skill-pill">📦 Maven</span>
                    <span class="skill-pill">🐙 Git & GitHub</span>
                    <span class="skill-pill">🐳 Docker</span>
                    <span class="skill-pill">📡 Packet Tracer</span>
                </div>
            </div>
        </aside>
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
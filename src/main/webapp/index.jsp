<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.miportafolio.model.Archivo" %>

<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Academia | Mi Portafolio</title>

    <!-- FUENTE -->
    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

    <!-- CSS -->
    <link rel="stylesheet"
          href="css/style.css">

    <!-- Aplicar tema antes de mostrar la página -->
    <script>

        (function () {

            const theme =
                localStorage.getItem("academia-theme");

            if (theme === "dark") {

                document.documentElement
                    .setAttribute(
                        "data-theme",
                        "dark"
                    );

            } else {

                document.documentElement
                    .setAttribute(
                        "data-theme",
                        "light"
                    );

            }

        })();

    </script>

</head>


<body>


<!-- =========================================================
     HEADER
========================================================= -->

<header class="site-header">


    <nav class="site-nav">


        <!-- LOGO -->

        <a class="brand"
           href="index.jsp">

            <span class="brand-mark">
                A
            </span>

            <span>
                ACADEMIA
            </span>

        </a>


        <!-- NAVEGACIÓN -->

        <ul class="nav-links">

            <li>

                <a class="active"
                   href="index.jsp">

                    Inicio

                </a>

            </li>


            <li>

                <a href="unidades.jsp">

                    Unidades

                </a>

            </li>


            <li>

                <a href="acerca.jsp">

                    Acerca de mí

                </a>

            </li>

        </ul>


        <!-- ACCIONES -->

        <div class="nav-actions">


            <!-- BOTÓN TEMA -->

            <button
                type="button"
                id="themeToggle"
                class="theme-toggle"
                aria-label="Cambiar tema"
                title="Cambiar tema">

                <span class="theme-icon">
                    ☾
                </span>

                <span class="theme-label">
                    Modo oscuro
                </span>

            </button>


            <!-- INFORMACIÓN USUARIO -->

            <div class="nav-user-info">

                <span>
                    Portafolio personal
                </span>

            </div>


            <div class="avatar">
                S
            </div>


        </div>


    </nav>


</header>



<!-- =========================================================
     CONTENIDO
========================================================= -->

<main class="page-shell">


    <!-- =====================================================
         HERO
    ====================================================== -->

    <section class="hero-panel">


        <div class="hero-grid">


            <div class="hero-content">


                <span class="eyebrow">

                    PORTAFOLIO ACADÉMICO

                </span>


                <h1>

                    Aprender,
                    <br>
                    crear y compartir.

                </h1>


                <p>

                    Un espacio para organizar mis proyectos,
                    unidades y recursos de aprendizaje
                    en un solo lugar.

                </p>


                <div class="hero-actions">


                    <a href="unidades.jsp"
                       class="btn btn-primary">

                        Explorar unidades

                    </a>


                    <a href="acerca.jsp"
                       class="btn btn-ghost">

                        Conocerme

                    </a>


                </div>


                <div class="hero-meta">

                    Ingeniería de Sistemas y Computación
                    <span>·</span>
                    Portafolio académico

                </div>


            </div>


            <!-- DECORACIÓN TECNOLÓGICA -->

            <div class="hero-decoration">

                <div class="circle circle-one"></div>

                <div class="circle circle-two"></div>

                <div class="circle circle-three"></div>

                <div class="tech-line line-one"></div>

                <div class="tech-line line-two"></div>

                <div class="tech-line line-three"></div>

                <div class="tech-node node-one"></div>

                <div class="tech-node node-two"></div>

                <div class="tech-node node-three"></div>

            </div>


        </div>


    </section>



    <!-- =====================================================
         PROYECTOS
    ====================================================== -->

    <section class="projects-section">


        <div class="section-heading">


            <div>

                <span class="section-label">

                    PORTAFOLIO

                </span>


                <h2>

                    Proyectos destacados

                </h2>


                <p>

                    Una selección de trabajos recientes.

                </p>

            </div>


            <a href="unidades.jsp"
               class="section-link">

                Ver todo →

            </a>


        </div>



        <%

            List<Archivo> proyectos =
                (List<Archivo>)
                request.getAttribute("proyectos");


            if (proyectos != null &&
                !proyectos.isEmpty()) {

        %>


        <div class="project-grid">


            <%

                int limite =
                    Math.min(
                        proyectos.size(),
                        4
                    );


                for (
                    int i = 0;
                    i < limite;
                    i++
                ) {

                    Archivo proyecto =
                        proyectos.get(i);

            %>


            <article class="project-card">


                <div class="project-card-top">


                    <div class="project-icon">


                        <%

                            if (
                                "imagen".equals(
                                    proyecto.getTipo()
                                )
                            ) {

                        %>

                            <span>IMG</span>

                        <%

                            } else if (
                                "pdf".equals(
                                    proyecto.getTipo()
                                )
                            ) {

                        %>

                            <span>PDF</span>

                        <%

                            } else if (
                                "documento".equals(
                                    proyecto.getTipo()
                                )
                            ) {

                        %>

                            <span>DOC</span>

                        <%

                            } else {

                        %>

                            <span>FILE</span>

                        <%

                            }

                        %>


                    </div>


                    <span class="project-type">

                        <%= proyecto.getTipo() %>

                    </span>


                </div>


                <h3 class="project-title">

                    <%= proyecto.getNombre() %>

                </h3>


                <p class="project-description">

                    <%=

                        proyecto.getDescripcion() != null &&
                        !proyecto.getDescripcion().isEmpty()

                        ?

                        proyecto.getDescripcion()

                        :

                        "Sin descripción disponible."

                    %>

                </p>


                <div class="project-meta">


                    <span>

                        Recurso académico

                    </span>


                    <span class="project-date">

                        <%=

                            proyecto.getCreatedAt() != null

                            ?

                            proyecto.getCreatedAt()
                                    .toLocalDate()

                            :

                            ""

                        %>

                    </span>


                </div>


            </article>


            <%

                }

            %>


        </div>


        <%

            } else {

        %>


        <div class="no-projects">


            <div class="empty-icon">
                +
            </div>


            <h3>

                Aún no hay proyectos publicados

            </h3>


            <p>

                Los proyectos que publiques
                aparecerán aquí.

            </p>


        </div>


        <%

            }

        %>


    </section>



    <!-- =====================================================
         CARACTERÍSTICAS
    ====================================================== -->

    <section class="feature-section">


        <div class="section-heading">


            <div>

                <span class="section-label">

                    ORGANIZACIÓN

                </span>


                <h2>

                    Todo en un solo lugar

                </h2>


                <p>

                    Una estructura sencilla para consultar
                    tu contenido académico.

                </p>

            </div>


        </div>



        <div class="feature-grid">


            <article class="feature-card">


                <span class="feature-number">
                    01
                </span>


                <h3>

                    Unidades

                </h3>


                <p>

                    Organiza tus contenidos académicos
                    por unidades de estudio.

                </p>


                <a href="unidades.jsp">

                    Explorar →

                </a>


            </article>



            <article class="feature-card">


                <span class="feature-number">
                    02
                </span>


                <h3>

                    Recursos

                </h3>


                <p>

                    Centraliza documentos, imágenes,
                    PDF y otros materiales.

                </p>


                <a href="unidades.jsp">

                    Ver recursos →

                </a>


            </article>



            <article class="feature-card">


                <span class="feature-number">
                    03
                </span>


                <h3>

                    Sobre mí

                </h3>


                <p>

                    Conoce mi perfil, formación,
                    habilidades y proyectos.

                </p>


                <a href="acerca.jsp">

                    Conocerme →

                </a>


            </article>


        </div>


    </section>


</main>



<!-- =========================================================
     FOOTER
========================================================= -->

<footer class="site-footer">


    <div class="site-footer-inner">


        <div class="footer-brand">


            <a class="brand"
               href="index.jsp">

                <span class="brand-mark">
                    A
                </span>

                <span>
                    ACADEMIA
                </span>

            </a>


            <p>

                Portafolio académico personal.

                <br>

                Aprender, crear y compartir.

            </p>


        </div>



        <div class="footer-column">


            <h4>
                Navegación
            </h4>


            <a href="index.jsp">
                Inicio
            </a>


            <a href="unidades.jsp">
                Unidades
            </a>


            <a href="acerca.jsp">
                Acerca de mí
            </a>


        </div>



        <div class="footer-column">


            <h4>
                Portafolio
            </h4>


            <a href="login.jsp">
                Iniciar sesión
            </a>


            <a href="registro.jsp">
                Crear cuenta
            </a>


            <a href="dashboard.jsp">
                Administración
            </a>


        </div>



        <div class="footer-column">


            <h4>
                Información
            </h4>


            <span>
                Ingeniería de Sistemas
            </span>


            <span>
                y Computación
            </span>


            <span>
                2026
            </span>


        </div>


    </div>



    <div class="footer-bottom">


        <div class="site-footer-inner">


            <span>
                © 2026 Mi Portafolio
            </span>


            <span>
                Hecho para aprender haciendo.
            </span>


        </div>


    </div>


</footer>



<!-- =========================================================
     JAVASCRIPT DEL TEMA
========================================================= -->

<script src="js/theme.js"></script>


</body>

</html>
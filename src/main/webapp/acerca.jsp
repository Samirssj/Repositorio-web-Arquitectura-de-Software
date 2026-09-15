<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es" data-theme="light">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Acerca de mí | Academia</title><link rel="stylesheet" href="css/style.css"></head>
<body>
<header class="topbar"><div class="container topbar-inner">
<a class="brand" href="${pageContext.request.contextPath}/"><span class="brand-mark">A</span> ACADEMIA</a>
<nav class="main-nav"><a href="${pageContext.request.contextPath}/">Inicio</a><a href="unidades.jsp">Unidades</a><a class="active" href="acerca.jsp">Acerca de mí</a></nav>
<div class="user-area"><div class="user-copy"><strong>Mi Portafolio</strong><span>Perfil académico</span></div><button class="theme-toggle" data-theme-toggle><span class="moon">☾</span><span class="sun">☀</span></button><span class="avatar">A</span></div>
</div></header>
<main class="container page">
<div class="page-heading"><span class="eyebrow">Perfil académico</span><h1>Acerca de mí</h1><p>Una breve presentación de la persona detrás de este portafolio.</p></div>
<section class="about-grid">
<article class="card about-card"><div class="profile"><div class="profile-avatar">S</div><div><h2>Samir</h2><span>Estudiante · Ingeniería de Sistemas y Computación</span></div></div>
<p>Este portafolio reúne mis trabajos, proyectos, materiales y evidencias de aprendizaje en un solo espacio.</p>
<p>Mi objetivo es seguir fortaleciendo mis conocimientos en desarrollo web, bases de datos, redes, algoritmos y diseño de interfaces.</p>
<a class="btn btn-primary" href="${pageContext.request.contextPath}/">Ver mis proyectos</a></article>
<aside class="card about-card"><span class="eyebrow">Lo que estoy aprendiendo</span><h2 style="font-size:13px;margin:7px 0">Herramientas y habilidades</h2>
<ul class="skills"><li>Java y Jakarta EE</li><li>HTML y CSS</li><li>PostgreSQL</li><li>Supabase</li><li>Algoritmos</li><li>Git y Maven</li><li>Redes y Packet Tracer</li><li>UI/UX</li></ul></aside>
</section>
</main>
<footer class="footer"><div class="container footer-inner"><div><div class="brand"><span class="brand-mark">A</span> ACADEMIA</div><p>Aprender haciendo.</p></div><div class="footer-links"><span>Inicio</span><span>Unidades</span><span>Proyectos</span><span>Perfil</span></div></div></footer>
<script src="js/theme.js"></script>
</body></html>

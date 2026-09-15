<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es" data-theme="light">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Unidades | Academia</title><link rel="stylesheet" href="css/style.css"></head>
<body>
<header class="topbar"><div class="container topbar-inner">
  <a class="brand" href="${pageContext.request.contextPath}/"><span class="brand-mark">A</span> ACADEMIA</a>
  <nav class="main-nav"><a href="${pageContext.request.contextPath}/">Inicio</a><a class="active" href="unidades.jsp">Unidades</a><a href="acerca.jsp">Acerca de mí</a></nav>
  <div class="user-area"><div class="user-copy"><strong>Mi Portafolio</strong><span>Área académica</span></div><button class="theme-toggle" data-theme-toggle><span class="moon">☾</span><span class="sun">☀</span></button><span class="avatar">A</span></div>
</div></header>

<main class="container page">
  <div class="page-heading"><span class="eyebrow">Ruta de aprendizaje</span><h1>Unidad 1 — Fundamentos</h1><p>Introducción a los fundamentos, estructuras y metodologías que sostienen el aprendizaje.</p></div>
  <div class="unit-layout">
    <aside class="card info-card">
      <span class="eyebrow">Información de la unidad</span><h3>Fundamentos</h3>
      <ul class="info-list">
        <li><span>Semanas</span><strong>4</strong></li><li><span>Materiales</span><strong>12</strong></li><li><span>Avance</span><strong>100%</strong></li><li><span>Estado</span><strong style="color:var(--success)">Completada</strong></li>
      </ul>
      <a class="btn btn-primary" style="width:100%;margin-top:16px" href="semana.jsp">Continuar →</a>
    </aside>
    <section class="week-list">
      <a class="week-row" href="semana.jsp"><span class="week-number">W1</span><div><h3>Semana 1: Introducción a Algoritmos</h3><p>Conceptos iniciales, notación y resolución de problemas.</p></div><span class="week-action">Ver contenido →</span></a>
      <a class="week-row" href="semana.jsp"><span class="week-number">W2</span><div><h3>Semana 2: Estructuras de Datos</h3><p>Organización de información y estructuras fundamentales.</p></div><span class="week-action">Ver contenido →</span></a>
      <a class="week-row" href="semana.jsp"><span class="week-number">W3</span><div><h3>Semana 3: Complejidad Computacional</h3><p>Análisis de eficiencia y comportamiento de algoritmos.</p></div><span class="week-action">Ver contenido →</span></a>
      <a class="week-row" href="semana.jsp"><span class="week-number">W4</span><div><h3>Semana 4: Grafos y Árboles</h3><p>Representación, recorridos y aplicaciones prácticas.</p></div><span class="week-action">Ver contenido →</span></a>
    </section>
  </div>
</main>
<footer class="footer"><div class="container footer-inner"><div><div class="brand"><span class="brand-mark">A</span> ACADEMIA</div><p>Portafolio académico.</p></div><div class="footer-links"><span>Inicio</span><span>Unidades</span><span>Acerca de mí</span><span>Contacto</span></div></div></footer>
<script src="js/theme.js"></script>
</body></html>

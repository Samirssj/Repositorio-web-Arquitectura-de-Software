<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es" data-theme="light">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Semana 1 | Academia</title><link rel="stylesheet" href="css/style.css"></head>
<body>
<header class="topbar"><div class="container topbar-inner">
<a class="brand" href="${pageContext.request.contextPath}/"><span class="brand-mark">A</span> ACADEMIA</a>
<nav class="main-nav"><a href="${pageContext.request.contextPath}/">Inicio</a><a class="active" href="unidades.jsp">Unidades</a><a href="acerca.jsp">Acerca de mí</a></nav>
<div class="user-area"><div class="user-copy"><strong>Mi Portafolio</strong><span>Semana 1</span></div><button class="theme-toggle" data-theme-toggle><span class="moon">☾</span><span class="sun">☀</span></button><span class="avatar">A</span></div>
</div></header>
<main class="container page">
<div class="page-heading"><span class="eyebrow">Unidad 1 · Semana 1</span><h1>Semana 1: Introducción a Algoritmos</h1><p>Material de clase y contenido de aprendizaje de la semana.</p></div>
<div class="material-layout">
<aside class="card material-list">
<div class="eyebrow" style="padding:8px">Materiales de clase</div>
<div class="material-item active"><span class="file-icon">PDF</span><span>Conceptos_Algoritmos.pdf</span></div>
<div class="material-item"><span class="file-icon">PDF</span><span>Fundamentos_Notacion.pdf</span></div>
<div class="material-item"><span class="file-icon">DOC</span><span>Guia_Ejercicios.docx</span></div>
<div class="material-item"><span class="file-icon">PDF</span><span>Ejemplos_Resolucion.pdf</span></div>
</aside>
<section class="card lesson-card">
<div class="lesson-head"><div><h2>TEMA 1.1: NOTACIÓN ASINTÓTICA Y COMPLEJIDAD</h2><p>Semana 1 · Fundamentos de algoritmia</p></div><span class="badge badge-blue">En curso</span></div>
<div class="lesson-body"><h3>Introducción</h3><p>La complejidad de un algoritmo permite determinar de forma aproximada el crecimiento de los recursos necesarios cuando aumenta el tamaño de la entrada.</p><p>Para comparar soluciones se utilizan notaciones asintóticas como <strong>O grande</strong>, que describe una cota superior del crecimiento.</p><div class="callout"><strong>Concepto clave:</strong> la complejidad temporal analiza cómo aumenta el tiempo de ejecución en función del tamaño de los datos.</div><p>Ejemplo de representación:</p><div class="code-line">T(n) = 3n² + 2n + 1&nbsp;&nbsp; → &nbsp;&nbsp;O(n²)</div></div>
</section>
</div>
</main>
<footer class="footer"><div class="container footer-inner"><div><div class="brand"><span class="brand-mark">A</span> ACADEMIA</div><p>Material académico.</p></div><div class="footer-links"><span>Unidad 1</span><span>Semana 1</span><span>Recursos</span><span>Acerca de mí</span></div></div></footer>
<script src="js/theme.js"></script>
</body></html>

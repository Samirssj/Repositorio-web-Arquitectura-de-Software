<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es" data-theme="dark">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Iniciar sesión | Academia</title><link rel="stylesheet" href="css/style.css"></head>
<body>
<div class="auth-page"><div class="auth-toolbar"><button class="theme-toggle" data-theme-toggle><span class="moon">☾</span><span class="sun">☀</span></button></div>
<div class="auth-card"><a class="auth-brand" href="${pageContext.request.contextPath}/"><span class="brand-mark">A</span> ACADEMIA</a>
<h1>Iniciar sesión</h1><p class="intro">Accede a tu espacio para gestionar tu portafolio y recursos académicos.</p>
<% if (request.getAttribute("error") != null) { %><div class="alert alert-error"><%= request.getAttribute("error") %></div><% } %>
<% if ("exitoso".equals(request.getParameter("registro"))) { %><div class="alert alert-success">Registro exitoso. Ahora puedes iniciar sesión.</div><% } %>
<form action="login" method="post">
<div class="form-group"><label for="email">Correo electrónico</label><input class="form-control" type="email" id="email" name="email" placeholder="correo@ejemplo.com" required></div>
<div class="form-group"><label for="password">Contraseña</label><input class="form-control" type="password" id="password" name="password" placeholder="••••••••" required></div>
<button class="btn btn-primary" type="submit">Iniciar sesión</button>
</form>
<p class="auth-links">¿No tienes una cuenta? <a href="registro.jsp">Crear cuenta</a></p><p class="auth-links"><a href="${pageContext.request.contextPath}/">← Volver al inicio</a></p>
</div></div><script src="js/theme.js"></script></body></html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es" data-theme="dark">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Crear cuenta | Academia</title><link rel="stylesheet" href="css/style.css"></head>
<body>
<div class="auth-page"><div class="auth-toolbar"><button class="theme-toggle" data-theme-toggle><span class="moon">☾</span><span class="sun">☀</span></button></div>
<div class="auth-card"><a class="auth-brand" href="${pageContext.request.contextPath}/"><span class="brand-mark">A</span> ACADEMIA</a>
<h1>Crear cuenta</h1><p class="intro">Crea tu acceso para administrar los recursos de tu portafolio.</p>
<% if (request.getAttribute("error") != null) { %><div class="alert alert-error"><%= request.getAttribute("error") %></div><% } %>
<form action="registro" method="post">
<div class="form-group"><label for="nombre">Nombre completo</label><input class="form-control" type="text" id="nombre" name="nombre" required></div>
<div class="form-group"><label for="email">Correo electrónico</label><input class="form-control" type="email" id="email" name="email" required></div>
<div class="form-group"><label for="password">Contraseña</label><input class="form-control" type="password" id="password" name="password" required></div>
<button class="btn btn-primary" type="submit">Crear cuenta</button>
</form>
<p class="auth-links">¿Ya tienes cuenta? <a href="login.jsp">Iniciar sesión</a></p><p class="auth-links"><a href="${pageContext.request.contextPath}/">← Volver al inicio</a></p>
</div></div><script src="js/theme.js"></script></body></html>

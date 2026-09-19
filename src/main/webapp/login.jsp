<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión | Academia</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script>
        (function () {
            const savedTheme = localStorage.getItem("academia-theme") || "dark";
            document.documentElement.setAttribute("data-theme", savedTheme);
        })();
    </script>
</head>
<body>

<div class="auth-page">
    <div class="login-box">
        <div class="auth-brand">&lt;/&gt; ACADEMIA ADMIN</div>
        <h1>Iniciar sesión</h1>
        <p style="color: var(--muted); font-size: 13px; margin-bottom: 24px;">
            Accede a tu espacio para gestionar tu portafolio y recursos académicos.
        </p>

        <% if (request.getAttribute("error") != null) { %>
            <div style="background: rgba(239, 113, 128, 0.15); border: 1px solid #ef7180; color: #ef7180; padding: 10px; border-radius: 8px; font-size: 12px; margin-bottom: 16px;">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="LoginServlet" method="POST">
            <div class="form-group">
                <label>Correo electrónico</label>
                <input type="email" name="email" placeholder="correo@ejemplo.com" required>
            </div>

            <div class="form-group">
                <label>Contraseña</label>
                <input type="password" name="password" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 10px; min-height: 42px;">
                Iniciar sesión
            </button>
        </form>

        <div style="margin-top: 20px; text-align: center;">
            <a href="index.jsp" style="color: var(--blue); font-size: 12px; font-weight: 700;">← Volver al inicio</a>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/theme.js"></script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro | Academia</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Estilos específicos para el registro con soporte completo de tema oscuro */
        .auth-brand {
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.15em;
            color: var(--blue);
            margin-bottom: 16px;
            text-transform: uppercase;
        }

        .login-box input[type="text"],
        .login-box input[type="email"],
        .login-box input[type="password"] {
            transition: all 0.2s ease;
        }

        .login-box input[type="text"]:focus,
        .login-box input[type="email"]:focus,
        .login-box input[type="password"]:focus {
            border-color: var(--blue);
            box-shadow: 0 0 0 3px rgba(49, 94, 251, 0.1);
        }

        .login-box .btn-primary {
            width: 100%;
            margin-top: 8px;
            height: 44px;
            font-size: 14px;
            font-weight: 700;
            background: var(--blue);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .login-box .btn-primary:hover {
            background: var(--blue-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(49, 94, 251, 0.3);
        }

        .login-box .btn-primary:active {
            transform: translateY(0);
        }

        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 13px;
            font-weight: 600;
        }

        .alert-error {
            background: rgba(235, 102, 116, 0.1);
            border: 1px solid var(--red);
            color: var(--red);
        }

        .alert-success {
            background: rgba(34, 197, 94, 0.1);
            border: 1px solid #22c55e;
            color: #22c55e;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: var(--blue);
            font-size: 12px;
            font-weight: 700;
            text-decoration: none;
            transition: opacity 0.2s ease;
        }

        .back-link:hover {
            opacity: 0.8;
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

<div class="auth-page">
    <div class="login-box">
        <div class="auth-brand">&lt;/&gt; ACADEMIA REGISTRO</div>
        <h1>Crear Cuenta</h1>
        <p style="color: var(--muted); font-size: 13px; margin-bottom: 24px;">
            Regístrate para gestionar tu portafolio y recursos académicos.
        </p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <% if ("true".equals(request.getParameter("registroExitoso"))) { %>
            <div class="alert alert-success">
                ¡Registro exitoso! Ahora puedes iniciar sesión.
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/registro" method="POST">
            <div class="form-group">
                <label for="nombre">Nombre Completo</label>
                <input id="nombre" type="text" name="nombre" placeholder="Tu nombre completo" required>
            </div>
            <div class="form-group">
                <label for="email">Correo electrónico</label>
                <input id="email" type="email" name="email" placeholder="correo@ejemplo.com" required>
            </div>
            <div class="form-group">
                <label for="password">Contraseña</label>
                <input id="password" type="password" name="password" placeholder="********" required>
            </div>
            <button type="submit" class="btn btn-primary">Registrarse</button>
        </form>

        <div style="text-align: center;">
            <a href="login.jsp" class="back-link">← Ya tengo una cuenta (Iniciar sesión)</a>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/theme.js"></script>
</body>
</html>
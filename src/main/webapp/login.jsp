<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión | Academia</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3.5">
    <style>
        .auth-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px 16px;
            background-color: #000000;
            background-image: linear-gradient(180deg, #000000, #00175cbf 15%, #0040ff66 45%, #0040ff66 55%, #00175cbf 85%, #000000);
            background-size: 100% 200%;
            animation: gradient-move-y 15s ease infinite alternate;
        }

        .login-box {
            width: 100%;
            max-width: 420px;
            padding: 38px 32px;
            background: rgba(20, 20, 26, 0.88);
            border: 1px solid rgba(0, 64, 255, 0.35);
            border-radius: 20px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.8), 0 0 35px rgba(0, 64, 255, 0.25);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
        }

        .auth-brand {
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.15em;
            color: #00f7ff;
            margin-bottom: 16px;
            text-transform: uppercase;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            background: rgba(0, 64, 255, 0.18);
            border: 1px solid rgba(0, 64, 255, 0.35);
            border-radius: 6px;
        }

        .login-box h1 {
            color: #ffffff;
            font-size: 24px;
            font-weight: 800;
            margin-bottom: 6px;
        }

        .login-box label {
            color: #cbd5e1;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 6px;
            display: block;
        }

        .login-box input[type="email"],
        .login-box input[type="password"] {
            width: 100%;
            padding: 12px 14px;
            background: #000000;
            border: 1px solid rgba(0, 64, 255, 0.3);
            border-radius: 10px;
            color: #ffffff;
            font-size: 14px;
            outline: none;
            transition: all 0.2s ease;
        }

        .login-box input[type="email"]:focus,
        .login-box input[type="password"]:focus {
            border-color: #0040ff;
            box-shadow: 0 0 16px rgba(0, 64, 255, 0.45);
        }

        .login-box .btn-primary {
            width: 100%;
            margin-top: 10px;
            height: 46px;
            font-size: 14px;
            font-weight: 800;
            background: #0040ff;
            color: #ffffff;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.25s ease;
            box-shadow: 0 0 20px rgba(0, 64, 255, 0.45);
        }

        .login-box .btn-primary:hover {
            background: #1f57ff;
            transform: translateY(-2px);
            box-shadow: 0 0 30px rgba(0, 64, 255, 0.7);
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
            background: rgba(239, 68, 68, 0.12);
            border: 1px solid var(--red);
            color: var(--red);
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #00f7ff;
            font-size: 12px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .back-link:hover {
            color: #ffffff;
            text-shadow: 0 0 10px rgba(0, 247, 255, 0.5);
            transform: translateX(-2px);
        }
    </style>
    <script>
        (function () {
            document.documentElement.setAttribute("data-theme", "dark");
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
            <div class="alert alert-error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <% if ("sesion_requerida".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error" style="background: rgba(245, 158, 11, 0.1); border: 1px solid #f59e0b; color: #f59e0b;">
                Tu sesión ha expirado o necesitas iniciar sesión como administrador para acceder al panel.
            </div>
        <% } %>

        <% if ("true".equals(request.getParameter("registroExitoso")) || "exitoso".equals(request.getParameter("registro"))) { %>
            <div class="alert alert-success" style="background: rgba(34, 197, 94, 0.1); border: 1px solid #22c55e; color: #22c55e; margin-bottom: 20px; padding: 12px 16px; border-radius: 8px; font-size: 13px; font-weight: 600;">
                ¡Cuenta registrada exitosamente! Ya puedes iniciar sesión con tus credenciales.
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="POST">
            <div class="form-group">
                <label for="email">Correo electrónico</label>
                <input id="email" type="email" name="email" placeholder="correo@ejemplo.com" required>
            </div>
            <div class="form-group">
                <label for="password">Contraseña</label>
                <input id="password" type="password" name="password" placeholder="********" required>
            </div>
            <button type="submit" class="btn btn-primary">Iniciar sesión</button>
        </form>

        <div style="text-align: center; margin-top: 16px;">
            <p style="font-size: 13px; color: var(--muted); margin-bottom: 12px;">
                ¿No tienes una cuenta? <a href="registro.jsp" style="color: #00f7ff; font-weight: 700; text-decoration: none;">Regístrate aquí</a>
            </p>
            <a href="index.jsp" class="back-link">← Volver al inicio</a>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/theme.js"></script>
</body>
</html>
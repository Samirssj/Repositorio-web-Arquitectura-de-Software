package com.miportafolio.util;

import com.miportafolio.config.DatabaseConfig;
import com.miportafolio.dao.UsuarioDAO;
import com.miportafolio.model.Usuario;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Base64;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utilidad de gestión de sesiones híbrida (HttpSession + Cookie segura firmada con HMAC).
 * Garantiza autenticación persistente y confiable en entornos locales y en plataformas
 * serverless / multi-contenedor como Vercel donde las instancias no comparten memoria RAM.
 */
public class SessionUtil {
    private static final Logger LOGGER = Logger.getLogger(SessionUtil.class.getName());
    public static final String COOKIE_NAME = "PORTAFOLIO_AUTH";
    public static final String SESSION_ATTR_USUARIO = "usuario";
    private static final long EXPIRATION_MS = 7L * 24 * 60 * 60 * 1000; // 7 días

    private static byte[] secretKeyBytes;

    static {
        try {
            // Clave secreta fija y determinista basada en el password de BD y salt seguro
            String seed = "MiPortafolio-Academia-SecretSalt-2026-" + DatabaseConfig.getPassword();
            MessageDigest sha = MessageDigest.getInstance("SHA-256");
            secretKeyBytes = sha.digest(seed.getBytes(StandardCharsets.UTF_8));
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al inicializar clave secreta para sesiones", e);
            secretKeyBytes = "FallbackKey-MiPortafolio-2026-Secure123".getBytes(StandardCharsets.UTF_8);
        }
    }

    /**
     * Inicia sesión tanto en el objeto HttpSession (para acceso local ultrarrápido)
     * como en una cookie persistente HTTP-Only con firma criptográfica HMAC-SHA256
     * (esencial para plataformas serverless como Vercel donde las instancias no comparten RAM).
     */
    public static void iniciarSesion(HttpServletRequest request, HttpServletResponse response, Usuario usuario) {
        if (usuario == null) return;

        // 1. Guardar en memoria (HttpSession)
        HttpSession session = request.getSession(true);
        session.setAttribute(SESSION_ATTR_USUARIO, usuario);

        // 2. Generar token firmado
        String token = generarToken(usuario.getId());
        if (token == null) return;

        boolean isHttps = esHttps(request);

        // 3. Crear cookie estándar
        Cookie cookie = new Cookie(COOKIE_NAME, token);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge((int) (EXPIRATION_MS / 1000));
        if (isHttps) {
            cookie.setSecure(true);
        }
        response.addCookie(cookie);

        // 4. Establecer cabecera Set-Cookie con SameSite=Lax para máxima compatibilidad moderna
        String sameSiteSuffix = isHttps ? "; Secure; SameSite=Lax" : "; SameSite=Lax";
        String headerVal = String.format("%s=%s; Path=/; Max-Age=%d; HttpOnly%s",
                COOKIE_NAME,
                token,
                (int) (EXPIRATION_MS / 1000),
                sameSiteSuffix);
        response.addHeader("Set-Cookie", headerVal);
    }

    /**
     * Obtiene el usuario autenticado.
     * Verifica primero la sesión en memoria; si no está o la instancia se reinició/escaló en Vercel,
     * valida la firma del token de la cookie y reconstituye el usuario desde la base de datos.
     */
    public static Usuario getUsuarioAutenticado(HttpServletRequest request) {
        if (request == null) return null;

        // 1. Verificar HttpSession
        HttpSession session = request.getSession(false);
        if (session != null) {
            Usuario u = (Usuario) session.getAttribute(SESSION_ATTR_USUARIO);
            if (u != null) {
                return u;
            }
        }

        // 2. Si no hay sesión o expiró en RAM, verificar la cookie persistente
        Cookie[] cookies = request.getCookies();
        if (cookies == null) return null;

        String token = null;
        for (Cookie c : cookies) {
            if (COOKIE_NAME.equals(c.getName())) {
                token = c.getValue();
                break;
            }
        }

        if (token == null || token.trim().isEmpty()) {
            return null;
        }

        Long userId = validarTokenYObtenerUserId(token);
        if (userId == null) {
            return null;
        }

        try {
            UsuarioDAO dao = new UsuarioDAO();
            Usuario usuario = dao.buscarPorId(userId);
            if (usuario != null) {
                // Rehidratar la sesión en la instancia actual
                HttpSession newSession = request.getSession(true);
                newSession.setAttribute(SESSION_ATTR_USUARIO, usuario);
                return usuario;
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error al recuperar usuario por ID desde la cookie", e);
        }

        return null;
    }

    /**
     * Cierra la sesión activa invalidando la HttpSession y expirando la cookie.
     */
    public static void cerrarSesion(HttpServletRequest request, HttpServletResponse response) {
        if (request != null) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
        }

        if (response != null) {
            Cookie cookie = new Cookie(COOKIE_NAME, "");
            cookie.setPath("/");
            cookie.setHttpOnly(true);
            cookie.setMaxAge(0);
            response.addCookie(cookie);

            boolean isHttps = (request != null && esHttps(request));
            String sameSiteSuffix = isHttps ? "; Secure; SameSite=Lax" : "; SameSite=Lax";
            response.addHeader("Set-Cookie", COOKIE_NAME + "=; Path=/; Max-Age=0; HttpOnly" + sameSiteSuffix);
        }
    }

    public static String generarToken(Long userId) {
        if (userId == null) return null;
        long now = System.currentTimeMillis();
        String payload = userId + ":" + now;
        String signature = firmarHmac(payload);
        if (signature == null) return null;

        String full = payload + ":" + signature;
        return Base64.getUrlEncoder().withoutPadding().encodeToString(full.getBytes(StandardCharsets.UTF_8));
    }

    public static Long validarTokenYObtenerUserId(String tokenBase64) {
        try {
            byte[] decoded = Base64.getUrlDecoder().decode(tokenBase64);
            String raw = new String(decoded, StandardCharsets.UTF_8);
            String[] parts = raw.split(":");
            if (parts.length != 3) {
                return null;
            }

            long userId = Long.parseLong(parts[0]);
            long timestamp = Long.parseLong(parts[1]);
            String expectedPayload = userId + ":" + timestamp;
            String signature = parts[2];

            // Comprobar expiración (7 días) y permitir 1 minuto de reloj desfasado hacia adelante
            long now = System.currentTimeMillis();
            if (now - timestamp > EXPIRATION_MS || timestamp > now + 60000L) {
                LOGGER.info("Token de sesión expirado para usuario ID: " + userId);
                return null;
            }

            // Comprobar firma HMAC
            String expectedSig = firmarHmac(expectedPayload);
            if (expectedSig != null && MessageDigest.isEqual(
                    signature.getBytes(StandardCharsets.UTF_8),
                    expectedSig.getBytes(StandardCharsets.UTF_8))) {
                return userId;
            }
        } catch (Exception e) {
            LOGGER.log(Level.FINE, "Token de sesión inválido", e);
        }
        return null;
    }

    private static String firmarHmac(String data) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKey = new SecretKeySpec(secretKeyBytes, "HmacSHA256");
            mac.init(secretKey);
            byte[] hmacBytes = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            return bytesToHex(hmacBytes);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al calcular HMAC", e);
            return null;
        }
    }

    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder(bytes.length * 2);
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    public static boolean esHttps(HttpServletRequest request) {
        if (request == null) return false;
        if (request.isSecure()) return true;
        String proto = request.getHeader("X-Forwarded-Proto");
        if (proto != null && "https".equalsIgnoreCase(proto.trim())) return true;
        String forwarded = request.getHeader("Forwarded");
        if (forwarded != null && forwarded.toLowerCase().contains("proto=https")) return true;
        StringBuffer url = request.getRequestURL();
        return url != null && url.toString().startsWith("https://");
    }
}

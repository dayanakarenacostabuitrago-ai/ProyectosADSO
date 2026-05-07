package co.sena.cimm.adso.saludboyaca.servlet;

import co.sena.cimm.adso.saludboyaca.dao.OTPTokenDAO;
import co.sena.cimm.adso.saludboyaca.dao.UsuarioDAO;
import co.sena.cimm.adso.saludboyaca.dto.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

@WebServlet("/recuperar")
public class RecuperarPasswordServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final OTPTokenDAO otpDAO = new OTPTokenDAO();

    // ── Sesion keys ───────────────────────────────────────────────
    private static final String SK_USR = "recuperar_usuario";
    private static final String SK_PASO = "recuperar_paso";

    // ── Brevo config (misma que LoginServlet) ─────────────────────
    private static final String BREVO_API_KEY = System.getenv("BREVO_API_KEY");
    private static final String REMITENTE = "dayanakarenacostabuitrago@gmail.com";

    // ─────────────────────────────────────────────────────────────
    // GET
    // ─────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String paso = req.getParameter("paso");
        if (paso == null)
            paso = "solicitar";

        HttpSession session = req.getSession(false);

        switch (paso) {

            case "solicitar":
                // Limpiar cualquier flujo previo
                if (session != null) {
                    session.removeAttribute(SK_USR);
                    session.removeAttribute(SK_PASO);
                }
                forward(req, res, "solicitar", null, null);
                break;

            case "verificar":
                // Solo si ya se solicito el codigo
                if (!pasoValido(session, "verificar")) {
                    res.sendRedirect(req.getContextPath() + "/recuperar?paso=solicitar");
                    return;
                }
                forward(req, res, "verificar", null, null);
                break;

            case "nueva":
                if (!pasoValido(session, "nueva")) {
                    res.sendRedirect(req.getContextPath() + "/recuperar?paso=solicitar");
                    return;
                }
                forward(req, res, "nueva", null, null);
                break;

            default:
                res.sendRedirect(req.getContextPath() + "/recuperar?paso=solicitar");
        }
    }

    // ─────────────────────────────────────────────────────────────
    // POST
    // ─────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String paso = req.getParameter("paso");
        if (paso == null)
            paso = "solicitar";

        switch (paso) {
            case "solicitar":
                procesarSolicitud(req, res);
                break;
            case "verificar":
                procesarVerificacion(req, res);
                break;
            case "nueva":
                procesarNuevaPassword(req, res);
                break;
            default:
                res.sendRedirect(req.getContextPath() + "/recuperar?paso=solicitar");
        }
    }

    // ─────────────────────────────────────────────────────────────
    // PASO 1 — Buscar email y enviar codigo
    // ─────────────────────────────────────────────────────────────
    private void procesarSolicitud(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            forward(req, res, "solicitar", "Ingresa tu correo electronico.", null);
            return;
        }
        email = email.trim().toLowerCase();

        Usuario u = usuarioDAO.buscarPorEmail(email);
        if (u == null) {
            // Mensaje neutral — no revelar si el email existe o no (seguridad)
            forward(req, res, "solicitar", null,
                    "Si el correo esta registrado, recibiras un codigo en breve.");
            return;
        }

        // Generar y enviar codigo OTP de 6 digitos
        String codigo = String.valueOf((int) (Math.random() * 900000) + 100000);

        // Enviar correo via Brevo (igual que LoginServlet)
        boolean enviado = enviarCorreoBrevo(u.getEmail(), u.getNombres(), codigo);

        if (!enviado) {
            forward(req, res, "solicitar",
                "No se pudo enviar el codigo. Intenta de nuevo mas tarde.", null);
            return;
        }

        // Guardar en BD solo si se envio el correo
        otpDAO.insertar(u.getIdUsuario(), codigo);

        // Guardar estado en sesion (nunca exponer el ID directamente en la URL)
        HttpSession session = req.getSession();
        session.setAttribute(SK_USR, u);
        session.setAttribute(SK_PASO, "verificar");

        // Mostrar email enmascarado al usuario
        req.setAttribute("emailMasked", enmascararEmail(u.getEmail()));
        forward(req, res, "verificar", null,
                "Codigo enviado a " + enmascararEmail(u.getEmail()));
    }

    // ─────────────────────────────────────────────────────────────
    // PASO 2 — Verificar codigo OTP
    // ─────────────────────────────────────────────────────────────
    private void procesarVerificacion(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!pasoValido(session, "verificar")) {
            res.sendRedirect(req.getContextPath() + "/recuperar?paso=solicitar");
            return;
        }

        Usuario u = (Usuario) session.getAttribute(SK_USR);
        String codigo = req.getParameter("codigo");

        if (codigo == null || codigo.trim().isEmpty()) {
            req.setAttribute("emailMasked", enmascararEmail(u.getEmail()));
            forward(req, res, "verificar", "Ingresa el codigo de 6 digitos.", null);
            return;
        }

        boolean valido = otpDAO.validar(u.getIdUsuario(), codigo.trim());
        if (!valido) {
            req.setAttribute("emailMasked", enmascararEmail(u.getEmail()));
            forward(req, res, "verificar", "Codigo incorrecto o expirado. Intentelo de nuevo.", null);
            return;
        }

        // Codigo correcto -> avanzar a nueva contrasena
        session.setAttribute(SK_PASO, "nueva");
        forward(req, res, "nueva", null, null);
    }

    // ─────────────────────────────────────────────────────────────
    // PASO 3 — Guardar nueva contrasena
    // ─────────────────────────────────────────────────────────────
    private void procesarNuevaPassword(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (!pasoValido(session, "nueva")) {
            res.sendRedirect(req.getContextPath() + "/recuperar?paso=solicitar");
            return;
        }

        String nueva = req.getParameter("password");
        String confirmar = req.getParameter("confirmar");

        if (nueva == null || nueva.trim().length() < 6) {
            forward(req, res, "nueva", "La contrasena debe tener al menos 6 caracteres.", null);
            return;
        }
        if (!nueva.equals(confirmar)) {
            forward(req, res, "nueva", "Las contrasenas no coinciden.", null);
            return;
        }

        Usuario u = (Usuario) session.getAttribute(SK_USR);
        boolean ok = usuarioDAO.actualizarPassword(u.getIdUsuario(), nueva.trim());

        // Limpiar sesion de recuperacion siempre
        session.removeAttribute(SK_USR);
        session.removeAttribute(SK_PASO);

        if (ok) {
            // Redirigir al login con mensaje de exito
            res.sendRedirect(req.getContextPath() + "/login?recuperado=ok");
        } else {
            forward(req, res, "nueva", "Error al actualizar la contrasena. Intenta de nuevo.", null);
        }
    }

    // ─────────────────────────────────────────────────────────────
    // BREVO API — Enviar correo de recuperacion
    // ─────────────────────────────────────────────────────────────
    private boolean enviarCorreoBrevo(String destino, String nombre, String codigo) {

        if (BREVO_API_KEY == null || BREVO_API_KEY.trim().isEmpty()) {
            System.err.println("[RecuperarPasswordServlet] ERROR: BREVO_API_KEY no configurada.");
            return false;
        }

        try {
            URL url = new URL("https://api.brevo.com/v3/smtp/email");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("accept", "application/json");
            conn.setRequestProperty("api-key", BREVO_API_KEY);
            conn.setRequestProperty("content-type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);

            String htmlContent = "<!DOCTYPE html>" +
                "<html><head><meta charset='UTF-8'></head><body>" +
                "<div style='font-family:Arial,sans-serif;max-width:600px;margin:0 auto;'>" +
                "<div style='background:#2d5a47;padding:24px;text-align:center;border-radius:12px 12px 0 0;'>" +
                "<h2 style='color:#fff;margin:0;'>SaludBoyaca</h2>" +
                "</div>" +
                "<div style='background:#fff;border:1px solid #dce9e4;border-top:none;padding:32px;border-radius:0 0 12px 12px;'>" +
                "<p style='color:#1a2e26;font-size:16px;'>Hola <strong>" + nombre + "</strong>,</p>" +
                "<p style='color:#4a6258;font-size:14px;line-height:1.6;'>Recibimos una solicitud para recuperar tu contrasena en SaludBoyaca.</p>" +
                "<p style='color:#4a6258;font-size:14px;'>Tu codigo de verificacion es:</p>" +
                "<div style='text-align:center;margin:28px 0;'>" +
                "<span style='font-size:36px;font-weight:900;letter-spacing:8px;color:#2d5a47;" +
                "background:#e8f2ee;padding:16px 32px;border-radius:12px;display:inline-block;'>" + codigo + "</span>" +
                "</div>" +
                "<p style='color:#7a9a8e;font-size:13px;'>Este codigo es valido por <strong>5 minutos</strong>.</p>" +
                "<p style='color:#7a9a8e;font-size:13px;'>Si no solicitaste este codigo, ignora este mensaje.</p>" +
                "<hr style='border:none;border-top:1px solid #dce9e4;margin:24px 0;'>" +
                "<p style='color:#aab8b3;font-size:12px;text-align:center;'> 2025 SaludBoyaca</p>" +
                "</div></div></body></html>";

            String json = "{" +
                "\"sender\":{\"name\":\"SaludBoyaca\",\"email\":\"" + REMITENTE + "\"}," +
                "\"to\":[{\"email\":\"" + destino + "\",\"name\":\"" + nombre + "\"}]," +
                "\"subject\":\"Recuperar contrasena - SaludBoyaca\"," +
                "\"htmlContent\":" + escapeJson(htmlContent) + "," +
                "\"textContent\":\"Tu codigo de recuperacion es: " + codigo + ". Valido por 5 minutos.\"" +
                "}";

            try (OutputStream os = conn.getOutputStream()) {
                os.write(json.getBytes(StandardCharsets.UTF_8));
            }

            int responseCode = conn.getResponseCode();

            StringBuilder response = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(
                        responseCode >= 200 && responseCode < 300
                            ? conn.getInputStream()
                            : conn.getErrorStream(),
                        StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
            }

            if (responseCode == 201) {
                System.out.println("[RecuperarPasswordServlet] Correo enviado a: " + destino);
                return true;
            } else {
                System.err.println("[RecuperarPasswordServlet] Error Brevo - Codigo: " + responseCode);
                System.err.println("[RecuperarPasswordServlet] Respuesta: " + response);
                return false;
            }

        } catch (Exception e) {
            System.err.println("[RecuperarPasswordServlet] Error enviando correo: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Helper para escapar JSON
    private String escapeJson(String s) {
        return "\"" + s.replace("\\", "\\\\")
                       .replace("\"", "\\\"")
                       .replace("\n", "\\n")
                       .replace("\r", "\\r") + "\"";
    }

    // ─────────────────────────────────────────────────────────────
    // HELPER — forward a la vista
    // ─────────────────────────────────────────────────────────────
    private void forward(HttpServletRequest req, HttpServletResponse res,
            String paso, String error, String info)
            throws ServletException, IOException {

        req.setAttribute("paso", paso);
        if (error != null)
            req.setAttribute("errorMsg", error);
        if (info != null)
            req.setAttribute("infoMsg", info);
        req.getRequestDispatcher("/views/recuperar_password.jsp").forward(req, res);
    }

    // ─────────────────────────────────────────────────────────────
    // HELPER — Verificar que el paso de la sesion coincide
    // ─────────────────────────────────────────────────────────────
    private boolean pasoValido(HttpSession session, String pasoEsperado) {
        if (session == null)
            return false;
        return pasoEsperado.equals(session.getAttribute(SK_PASO))
                && session.getAttribute(SK_USR) != null;
    }

    // ─────────────────────────────────────────────────────────────
    // HELPER — Enmascarar email
    // ─────────────────────────────────────────────────────────────
    private String enmascararEmail(String email) {
        if (email == null || !email.contains("@"))
            return "***";
        String[] p = email.split("@");
        String local = p[0];
        String dom = p[1];
        if (local.length() <= 3)
            return local + "***@" + dom;
        return local.substring(0, 3) + "***@" + dom;
    }
}
package co.sena.cimm.adso.saludboyaca.servlet;

import co.sena.cimm.adso.saludboyaca.dao.OTPTokenDAO;
import co.sena.cimm.adso.saludboyaca.dao.UsuarioDAO;
import co.sena.cimm.adso.saludboyaca.dto.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;


@WebServlet("/recuperar")
public class RecuperarPasswordServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final OTPTokenDAO otpDAO = new OTPTokenDAO();

    // ── Sesion keys ───────────────────────────────────────────────
    private static final String SK_USR = "recuperar_usuario";
    private static final String SK_PASO = "recuperar_paso";

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
                // Solo si ya se solicitó el código
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
    // PASO 1 — Buscar email y enviar código
    // ─────────────────────────────────────────────────────────────
    private void procesarSolicitud(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            forward(req, res, "solicitar", "Ingresa tu correo electrónico.", null);
            return;
        }
        email = email.trim().toLowerCase();

        Usuario u = usuarioDAO.buscarPorEmail(email);
        if (u == null) {
            // Mensaje neutro — no revelar si el email existe o no (seguridad)
            forward(req, res, "solicitar", null,
                    "Si el correo está registrado, recibirás un código en breve.");
            return;
        }

        // Generar y enviar código OTP de 6 dígitos
        String codigo = String.valueOf((int) (Math.random() * 900000) + 100000);
        otpDAO.insertar(u.getIdUsuario(), codigo);
        enviarCorreoRecuperacion(u.getEmail(), u.getNombres(), codigo);

        // Guardar estado en sesión (nunca exponer el ID directamente en la URL)
        HttpSession session = req.getSession();
        session.setAttribute(SK_USR, u);
        session.setAttribute(SK_PASO, "verificar");

        // Mostrar email enmascarado al usuario
        req.setAttribute("emailMasked", enmascararEmail(u.getEmail()));
        forward(req, res, "verificar", null,
                "Código enviado a " + enmascararEmail(u.getEmail()));
    }

    // ─────────────────────────────────────────────────────────────
    // PASO 2 — Verificar código OTP
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
            forward(req, res, "verificar", "Ingresa el código de 6 dígitos.", null);
            return;
        }

        boolean valido = otpDAO.validar(u.getIdUsuario(), codigo.trim());
        if (!valido) {
            req.setAttribute("emailMasked", enmascararEmail(u.getEmail()));
            forward(req, res, "verificar", "Código incorrecto o expirado. Inténtalo de nuevo.", null);
            return;
        }

        // Código correcto → avanzar a nueva contraseña
        session.setAttribute(SK_PASO, "nueva");
        forward(req, res, "nueva", null, null);
    }

    // ─────────────────────────────────────────────────────────────
    // PASO 3 — Guardar nueva contraseña
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
            forward(req, res, "nueva", "La contraseña debe tener al menos 6 caracteres.", null);
            return;
        }
        if (!nueva.equals(confirmar)) {
            forward(req, res, "nueva", "Las contraseñas no coinciden.", null);
            return;
        }

        Usuario u = (Usuario) session.getAttribute(SK_USR);
        boolean ok = usuarioDAO.actualizarPassword(u.getIdUsuario(), nueva.trim());

        // Limpiar sesión de recuperación siempre
        session.removeAttribute(SK_USR);
        session.removeAttribute(SK_PASO);

        if (ok) {
            // Redirigir al login con mensaje de éxito
            res.sendRedirect(req.getContextPath() + "/login?recuperado=ok");
        } else {
            forward(req, res, "nueva", "Error al actualizar la contraseña. Intenta de nuevo.", null);
        }
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
    // HELPER — Verificar que el paso de la sesión coincide
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

    // ─────────────────────────────────────────────────────────────
    // HELPER — Enviar correo de recuperación
    // ─────────────────────────────────────────────────────────────
    private void enviarCorreoRecuperacion(String destino, String nombre, String codigo) {

        final String remitente  = "dayanakarenacostabuitrago@gmail.com";
        final String BREVO_API_KEY = System.getenv("BREVO_API_KEY");

        try {
            java.net.URL url = new java.net.URL("https://api.brevo.com/v3/smtp/email");
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("accept", "application/json");
            conn.setRequestProperty("api-key", BREVO_API_KEY);
            conn.setRequestProperty("content-type", "application/json");
            conn.setDoOutput(true);

            String html = "<div style='font-family:sans-serif;max-width:520px;margin:auto;'>"
                + "<div style='background:linear-gradient(135deg,#2d5a47,#4d7a68);padding:28px;border-radius:14px 14px 0 0;'>"
                + "<h2 style='color:#fff;margin:0;font-size:1.2rem;'>&#128274; Recuperaci&#243;n de contrase&#241;a</h2>"
                + "<p style='color:rgba(255,255,255,.75);margin:4px 0 0;font-size:.85rem;'>SaludBoyac&#225;</p>"
                + "</div>"
                + "<div style='background:#fff;border:1px solid #dce9e4;border-top:none;padding:32px;border-radius:0 0 14px 14px;'>"
                + "<p style='color:#1a2e26;'>Hola <strong>" + nombre + "</strong>,</p>"
                + "<p style='color:#4a6258;'>Tu c&#243;digo de verificaci&#243;n para recuperar tu contrase&#241;a es:</p>"
                + "<div style='text-align:center;margin:28px 0;'>"
                + "<span style='font-size:2.6rem;font-weight:900;letter-spacing:.4em;color:#2d5a47;"
                + "background:#e8f2ee;padding:16px 32px;border-radius:14px;display:inline-block;'>"
                + codigo + "</span></div>"
                + "<p style='color:#9a7200;font-size:.85rem;background:#fff8e1;padding:10px 14px;border-radius:8px;border:1px solid #f0d080;'>"
                + "&#9201; V&#225;lido por <strong>5 minutos</strong>. Si no solicitaste este c&#243;digo, ignora este mensaje.</p>"
                + "<hr style='border:none;border-top:1px solid #dce9e4;margin:20px 0;'>"
                + "<p style='color:#aab8b3;font-size:.75rem;'>&#169; 2025 SaludBoyac&#225;</p>"
                + "</div></div>";

            // Escapar comillas para JSON
            String htmlEscaped = html.replace("\\", "\\\\").replace("\"", "\\\"");

            String json = "{"
                + "\"sender\":{\"name\":\"SaludBoyaca\",\"email\":\"" + remitente + "\"},"
                + "\"to\":[{\"email\":\"" + destino + "\"}],"
                + "\"subject\":\"Recuperar contrase\\u00f1a \\u2014 SaludBoyac\\u00e1\","
                + "\"htmlContent\":\"" + htmlEscaped + "\""
                + "}";

            try (java.io.OutputStream os = conn.getOutputStream()) {
                os.write(json.getBytes("UTF-8"));
            }

            int responseCode = conn.getResponseCode();
            if (responseCode == 201) {
                System.out.println("[RecuperarPasswordServlet] Correo enviado a: " + destino);
            } else {
                System.err.println("[RecuperarPasswordServlet] Error Brevo API: " + responseCode);
            }

        } catch (Exception e) {
            System.err.println("[RecuperarPasswordServlet] Error enviando correo: " + e.getMessage());
        }
    }
}

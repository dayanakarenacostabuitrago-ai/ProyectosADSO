package co.sena.cimm.adso.saludboyaca.servlet;

import co.sena.cimm.adso.saludboyaca.dao.OTPTokenDAO;
import co.sena.cimm.adso.saludboyaca.dao.UsuarioDAO;
import co.sena.cimm.adso.saludboyaca.dto.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private OTPTokenDAO otpDAO = new OTPTokenDAO();

    // ── GET /login ───────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null
                && session.getAttribute("usuario") != null
                && Boolean.TRUE.equals(session.getAttribute("otpVerificado"))) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    // ── POST /login ──────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Usuario u = usuarioDAO.validarLogin(username, password);

        if (u != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioTemp", u);
            session.setAttribute("otpVerificado", false);

            // Generar OTP y enviarlo
            String otp = String.valueOf((int) (Math.random() * 900000) + 100000);
            otpDAO.insertar(u.getIdUsuario(), otp);
            enviarCorreo(u.getEmail(), otp);

            // Volver al login.jsp CON emailMasked para activar las cajas OTP
            request.setAttribute("emailMasked", enmascararEmail(u.getEmail()));
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);

        } else {
            request.setAttribute("error", "Usuario o contraseña incorrectos");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }

    // ── ENMASCARAR EMAIL ─────────────────────────────────────────
    private String enmascararEmail(String email) {
        if (email == null || !email.contains("@"))
            return "***";
        String[] partes = email.split("@");
        String local = partes[0];
        String dominio = partes[1];
        if (local.length() <= 3)
            return local + "***@" + dominio;
        return local.substring(0, 3) + "***@" + dominio;
    }

    // ── ENVÍO DE CORREO ──────────────────────────────────────────
    private void enviarCorreo(String destino, String otp) {
        final String remitente = "dayanakarenacostabuitrago@gmail.com";
        final String BREVO_API_KEY = System.getenv("BREVO_API_KEY");

        try {
            java.net.URL url = new java.net.URL("https://api.brevo.com/v3/smtp/email");
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("accept", "application/json");
            conn.setRequestProperty("api-key", BREVO_API_KEY);
            conn.setRequestProperty("content-type", "application/json");
            conn.setDoOutput(true);

            String json = "{"
                + "\"sender\":{\"name\":\"SaludBoyaca\",\"email\":\"" + remitente + "\"},"
                + "\"to\":[{\"email\":\"" + destino + "\"}],"
                + "\"subject\":\"Código de verificación - SaludBoyacá\","
                + "\"textContent\":\"Tu código OTP es: " + otp + "\\n\\nVálido por 5 minutos.\""
                + "}";

            try (java.io.OutputStream os = conn.getOutputStream()) {
                os.write(json.getBytes("UTF-8"));
            }

            int responseCode = conn.getResponseCode();
            if (responseCode != 201) {
                System.err.println("[LoginServlet] Error Brevo API: " + responseCode);
            }

        } catch (Exception e) {
            System.err.println("[LoginServlet] Error enviando correo: " + e.getMessage());
        }
    }
}
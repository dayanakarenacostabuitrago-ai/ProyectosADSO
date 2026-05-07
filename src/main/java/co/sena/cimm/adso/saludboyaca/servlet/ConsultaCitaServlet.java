package co.sena.cimm.adso.saludboyaca.servlet;

import co.sena.cimm.adso.saludboyaca.dao.ConsultaCitaDAO;
import co.sena.cimm.adso.saludboyaca.dao.PacienteDAO;
import co.sena.cimm.adso.saludboyaca.dto.Cita;
import co.sena.cimm.adso.saludboyaca.dto.Paciente;
import co.sena.cimm.adso.saludboyaca.util.PDFGenerator;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.net.*;
import java.util.List;

import org.json.JSONObject;

@WebServlet("/consulta_cita")
public class ConsultaCitaServlet extends HttpServlet {

    private ConsultaCitaDAO dao;
    private PacienteDAO pacienteDAO;

    private static final String SECRET_KEY = "6LezKbssAAAAABxsDh4NNGRk_SlPpsshbd06nw-A";

    @Override
    public void init() {
        dao = new ConsultaCitaDAO();
        pacienteDAO = new PacienteDAO();
    }

    // ── GET: mostrar formulario limpio O generar PDF comprobante ─────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String accion = req.getParameter("accion");

        if ("pdf".equals(accion)) {
            String idParam = req.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de cita no especificado.");
                return;
            }
            try {
                int idCita = Integer.parseInt(idParam.trim());
                Cita cita = dao.buscarPorIdCompleto(idCita);
                if (cita == null) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Cita no encontrada.");
                    return;
                }
                resp.setContentType("application/pdf");
                resp.setHeader("Content-Disposition",
                        "inline; filename=\"comprobante_cita_" + idCita + ".pdf\"");
                PDFGenerator.generarComprobante(cita, resp.getOutputStream());
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de cita invalido.");
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Error al generar el comprobante.");
            }
            return;
        }

        req.getRequestDispatcher("/views/consulta_cita.jsp").forward(req, resp);
    }

    // ── POST: procesar búsqueda ──────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Validar reCAPTCHA (solo si llega el token)
        String captchaToken = req.getParameter("g-recaptcha-response");
        if (captchaToken != null && !captchaToken.isEmpty()) {
            if (!verificarCaptcha(captchaToken)) {
                req.setAttribute("error", "Verificación reCAPTCHA fallida. Inténtalo de nuevo.");
                req.getRequestDispatcher("/views/consulta_cita.jsp").forward(req, resp);
                return;
            }
        }

        // 2. Obtener y validar documento
        String documento = req.getParameter("documento");
        if (documento == null || documento.trim().isEmpty()) {
            req.setAttribute("error", "Por favor ingresa tu número de documento.");
            req.getRequestDispatcher("/views/consulta_cita.jsp").forward(req, resp);
            return;
        }
        documento = documento.trim();

        // Siempre poner documentoBuscado — el JSP lo usa en TODOS los casos
        req.setAttribute("documentoBuscado", documento);

        try {
            // 3. Verificar si el paciente existe
            Paciente paciente = pacienteDAO.buscarPorDocumento(documento);

            if (paciente == null) {
                req.setAttribute("noRegistrado", true);
                req.getRequestDispatcher("/views/consulta_cita.jsp").forward(req, resp);
                return;
            }

            // 4. Buscar sus citas
            List<Cita> citas = dao.consultarPorDocumento(documento);

            if (citas == null || citas.isEmpty()) {
                // Existe pero sin citas
                req.setAttribute("sinCitas", true);
                req.setAttribute("pacienteNombre", paciente.getNombres());
                req.setAttribute("pacienteApellido", paciente.getApellidos());
            } else {
                // Con citas — nombre y doc. vienen dentro de cada objeto Cita
                req.setAttribute("citas", citas);
            }

            req.getRequestDispatcher("/views/consulta_cita.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error al consultar. Por favor intenta de nuevo.");
            req.getRequestDispatcher("/views/consulta_cita.jsp").forward(req, resp);
        }
    }

    // ── Verificación reCAPTCHA ───────────────────────────────────────
    private boolean verificarCaptcha(String captchaResponse) {
        try {
            URL url = new URL("https://www.google.com/recaptcha/api/siteverify");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);

            String params = "secret=" + URLEncoder.encode(SECRET_KEY, "UTF-8")
                    + "&response=" + URLEncoder.encode(captchaResponse, "UTF-8");

            try (OutputStream os = conn.getOutputStream()) {
                os.write(params.getBytes("UTF-8"));
            }

            StringBuilder sb = new StringBuilder();
            try (BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream()))) {
                String line;
                while ((line = in.readLine()) != null)
                    sb.append(line);
            }

            return new JSONObject(sb.toString()).getBoolean("success");

        } catch (Exception e) {
            e.printStackTrace();
            return true; // si Google falla, no bloqueamos al usuario
        }
    }
}
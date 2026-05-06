package co.sena.cimm.adso.saludboyaca.servlet;

import co.sena.cimm.adso.saludboyaca.dao.OTPTokenDAO;
import co.sena.cimm.adso.saludboyaca.dto.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/otp")
public class OTPServlet extends HttpServlet {

    private OTPTokenDAO otpDAO = new OTPTokenDAO();

    // ── GET /otp?accion=generar → reenvío de código ──────────────
    // (solo usado desde el botón "Reenviar código" via fetch JS)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        HttpSession session = request.getSession(false);

        if (!"generar".equals(accion) || session == null
                || session.getAttribute("usuarioTemp") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Solo devolver 200 OK — el JS del login.jsp reinicia el timer
        response.setStatus(HttpServletResponse.SC_OK);
    }

    // ── POST /otp?accion=validar → verifica el código ────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (!"validar".equals(accion)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Usuario u = (Usuario) session.getAttribute("usuarioTemp");
        String otpIngresado = request.getParameter("otpCodigo");

        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        boolean valido = otpDAO.validar(u.getIdUsuario(), otpIngresado);

        if (valido) {
            // OTP correcto → sesión autenticada
            session.removeAttribute("usuarioTemp");
            session.setAttribute("usuario", u);
            session.setAttribute("idUsuario", u.getIdUsuario());
            session.setAttribute("usuarioNombre", u.getNombres() + " " + u.getApellidos());
            session.setAttribute("usuarioRol", u.getRol());
            session.setAttribute("otpVerificado", true);
            response.sendRedirect(request.getContextPath() + "/dashboard");

        } else {
            // OTP incorrecto → volver al login.jsp (NO a otp_verificacion.jsp)
            request.setAttribute("otpError", "Código inválido o expirado. Inténtalo de nuevo.");
            request.setAttribute("emailMasked", enmascararEmail(u.getEmail()));
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }

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
}
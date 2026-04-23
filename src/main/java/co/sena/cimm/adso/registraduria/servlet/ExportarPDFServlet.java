package co.sena.cimm.adso.registraduria.servlet;

import co.sena.cimm.adso.registraduria.dao.ConsultaMesaDAO;
import co.sena.cimm.adso.registraduria.dao.ConsultaMesaDAOImpl;
import co.sena.cimm.adso.registraduria.model.Ciudadano;
import co.sena.cimm.adso.registraduria.service.PDFCorreoService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/exportarPDF")
public class ExportarPDFServlet extends HttpServlet {

    private final ConsultaMesaDAO consultaMesaDAO = new ConsultaMesaDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String documento = request.getParameter("documento");
        String enviarCorreo = request.getParameter("enviarCorreo");
        // correoDestino es opcional: si viene vacio se usa el correo registrado en la
        // BD
        String correoDestino = request.getParameter("correoDestino");

        try {
            Ciudadano ciudadano = consultaMesaDAO.consultarPorDocumento(documento);

            if (ciudadano == null) {
                response.sendRedirect(request.getContextPath() + "/consultaMesa?error=Ciudadano+no+encontrado");
                return;
            }

            byte[] pdfBytes = PDFCorreoService.generarPDFBytes(ciudadano);

            // ── MODO DESCARGA DIRECTA ─────────────────────────────────────
            if (enviarCorreo == null || !enviarCorreo.equals("true")) {
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition",
                        "attachment; filename=mesa_votacion_" + ciudadano.getNumeroDocumento() + ".pdf");
                response.getOutputStream().write(pdfBytes);
                response.getOutputStream().flush();
                return;
            }

            // ── MODO ENVIO POR CORREO ─────────────────────────────────────
            // Si no se pasa correoDestino, usar el correo registrado en la BD
            String destinatario = (correoDestino != null && !correoDestino.isBlank())
                    ? correoDestino.trim()
                    : (ciudadano.getCorreo() != null ? ciudadano.getCorreo().trim() : null);

            if (destinatario == null || destinatario.isBlank()) {
                request.setAttribute("resultado", ciudadano);
                request.setAttribute("error",
                        "No hay correo electronico disponible. Registra uno en la Registraduria.");
                request.getRequestDispatcher("/WEB-INF/vistas/consulta/consultaMesa.jsp").forward(request, response);
                return;
            }

            try {
                PDFCorreoService.enviarCorreoConPDF(destinatario, ciudadano, pdfBytes);
                request.setAttribute("resultado", ciudadano);
                request.setAttribute("mensajeCorreo",
                        "Comprobante enviado exitosamente a <strong>" + destinatario
                                + "</strong>. Recuerda que la clave del PDF es tu numero de documento.");
                request.getRequestDispatcher("/WEB-INF/vistas/consulta/consultaMesa.jsp").forward(request, response);

            } catch (Exception mailEx) {
                mailEx.printStackTrace();
                request.setAttribute("resultado", ciudadano);
                request.setAttribute("errorCorreo", "No se pudo enviar el correo: " + mailEx.getMessage());
                request.getRequestDispatcher("/WEB-INF/vistas/consulta/consultaMesa.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/consultaMesa?error=Error+al+generar+PDF:+" + e.getMessage());
        }
    }
}

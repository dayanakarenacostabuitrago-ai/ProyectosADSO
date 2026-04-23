package co.sena.cimm.adso.registraduria.servlet;

import co.sena.cimm.adso.registraduria.dao.DocumentoDAO;
import co.sena.cimm.adso.registraduria.dao.DocumentoDAOImpl;
import co.sena.cimm.adso.registraduria.model.DocumentoExpedido;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet para el módulo de Reportes.
 * Mapea /reportes y /reportes/vencidos
 */
@WebServlet(urlPatterns = {"/reportes", "/reportes/*"})
public class ReportesServlet extends HttpServlet {

    private DocumentoDAO documentoDAO;

    @Override
    public void init() throws ServletException {
        documentoDAO = new DocumentoDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Determinar sub-acción desde pathInfo o parámetro
        String pathInfo = req.getPathInfo();   // e.g. "/vencidos"
        String accion   = req.getParameter("accion");

        // /reportes  o  /reportes/vencidos  →  reporte de vencidos
        boolean esVencidos = pathInfo == null
                || pathInfo.equals("/")
                || pathInfo.equals("/vencidos")
                || "vencidos".equals(accion);

        if (esVencidos) {
            mostrarVencidos(req, resp);
        } else {
            mostrarVencidos(req, resp); // única vista por ahora
        }
    }

    private void mostrarVencidos(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<DocumentoExpedido> vencidos = documentoDAO.listarVencidos();
            List<DocumentoExpedido> proximos = documentoDAO.listarProximosAVencer();

            req.setAttribute("vencidos",     vencidos);
            req.setAttribute("proximos",     proximos);
            req.setAttribute("fechaActual",  LocalDate.now().toString());
            req.setAttribute("currentPage",  "vencidos");

            req.getRequestDispatcher("/WEB-INF/vistas/documentos/vencidos.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error al generar reporte de vencidos: " + e.getMessage(), e);
        }
    }
}
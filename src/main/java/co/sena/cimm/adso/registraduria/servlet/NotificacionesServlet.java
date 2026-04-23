package co.sena.cimm.adso.registraduria.servlet;

import co.sena.cimm.adso.registraduria.dao.SolicitudDAO;
import co.sena.cimm.adso.registraduria.dao.SolicitudDAOimpl;
import co.sena.cimm.adso.registraduria.model.SolicitudCiudadano;
import co.sena.cimm.adso.registraduria.model.Usuario;
import co.sena.cimm.adso.registraduria.service.PDFCorreoService;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * Servlet administrativo (con login) para gestionar notificaciones/solicitudes.
 * GET /notificaciones → listado
 * POST /notificaciones → responder (aceptar o rechazar)
 */
@WebServlet("/notificaciones")
public class NotificacionesServlet extends HttpServlet {

    private SolicitudDAO solicitudDao;

    @Override
    public void init() {
        solicitudDao = new SolicitudDAOimpl();
    }

    /* ── GET: listar solicitudes ─────────────────────────────────── */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            List<SolicitudCiudadano> lista = solicitudDao.listarTodas();
            int pendientes = solicitudDao.contarPendientes();

            req.setAttribute("solicitudes", lista);
            req.setAttribute("totalPendientes", pendientes);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorCarga", "Error al cargar las solicitudes: " + e.getMessage());
        }

        req.getRequestDispatcher("/WEB-INF/vistas/notificaciones/listado.jsp")
                .forward(req, resp);
    }

    /* ── POST: aceptar o rechazar ────────────────────────────────── */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String idStr = req.getParameter("id");
        String accion = req.getParameter("accion"); // "ACEPTADA" o "RECHAZADA"
        String respuesta = req.getParameter("respuesta");

        if (idStr == null || accion == null ||
                (!accion.equals("ACEPTADA") && !accion.equals("RECHAZADA"))) {
            resp.sendRedirect(req.getContextPath() + "/notificaciones?error=parametros");
            return;
        }

        int id = Integer.parseInt(idStr);

        try {
            SolicitudCiudadano sol = solicitudDao.buscarPorId(id);
            if (sol == null) {
                resp.sendRedirect(req.getContextPath() + "/notificaciones?error=noEncontrada");
                return;
            }

            // Nombre del admin que responde
            HttpSession session = req.getSession(false);
            String adminNombre = "Administrador";
            if (session != null && session.getAttribute("usuario") != null) {
                Usuario u = (Usuario) session.getAttribute("usuario");
                adminNombre = u.getNombreCompleto() != null ? u.getNombreCompleto() : u.getUsername();
            }

            solicitudDao.responder(id, accion,
                    respuesta != null ? respuesta.trim() : "", adminNombre);

            // Enviar correo al ciudadano
            try {
                sol.setEstado(accion);
                sol.setRespuestaAdmin(respuesta != null ? respuesta.trim() : "");
                sol.setAdminRespondio(adminNombre);
                PDFCorreoService.enviarCorreoRespuestaSolicitud(sol.getCorreo(), sol);
            } catch (Exception mailEx) {
                mailEx.printStackTrace();
            }

            resp.sendRedirect(req.getContextPath() + "/notificaciones?ok=" + accion.toLowerCase());

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/notificaciones?error=general");
        }
    }
}

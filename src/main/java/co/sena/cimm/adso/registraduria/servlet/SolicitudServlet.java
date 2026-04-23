package co.sena.cimm.adso.registraduria.servlet;

import co.sena.cimm.adso.registraduria.dao.ConsultaMesaDAO;
import co.sena.cimm.adso.registraduria.dao.ConsultaMesaDAOImpl;
import co.sena.cimm.adso.registraduria.dao.SolicitudDAO;
import co.sena.cimm.adso.registraduria.dao.SolicitudDAOimpl;
import co.sena.cimm.adso.registraduria.model.Ciudadano;
import co.sena.cimm.adso.registraduria.model.SolicitudCiudadano;
import co.sena.cimm.adso.registraduria.service.PDFCorreoService;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/solicitud")
public class SolicitudServlet extends HttpServlet {

    private ConsultaMesaDAO consultaDao;
    private SolicitudDAO solicitudDao;

    @Override
    public void init() {
        consultaDao = new ConsultaMesaDAOImpl();
        solicitudDao = new SolicitudDAOimpl();
    }

    /* ── GET ─────────────────────────────────────────────────────── */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String doc = req.getParameter("doc");

        if (doc != null && !doc.isBlank()) {
            doc = doc.trim();
            try {
                Ciudadano c = consultaDao.consultarPorDocumento(doc);
                if (c != null) {
                    req.setAttribute("ciudadano", c);
                } else {
                    req.setAttribute("errorBusqueda",
                            "No se encontró ningún ciudadano con el documento <strong>" + doc + "</strong>. "
                                    + "Verifique el número e intente de nuevo.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                req.setAttribute("errorBusqueda", "Error al buscar el ciudadano: " + e.getMessage());
            }
            req.setAttribute("docBuscado", doc);
        }

        req.getRequestDispatcher("/WEB-INF/vistas/solicitud/formulario.jsp")
                .forward(req, resp);
    }

    /* ── POST ────────────────────────────────────────────────────── */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // Leer todos los parámetros
        String doc         = req.getParameter("numeroDocumento");
        String nombres     = req.getParameter("nombres");
        String apellidos   = req.getParameter("apellidos");
        String correo      = req.getParameter("correo");
        String telefono    = req.getParameter("telefono");
        String tipo        = req.getParameter("tipoSolicitud");
        String descripcion = req.getParameter("descripcion");

        // LOG de debug — quitar después de confirmar que funciona
        System.out.println("=== POST /solicitud ===");
        System.out.println("  numeroDocumento : [" + doc + "]");
        System.out.println("  nombres         : [" + nombres + "]");
        System.out.println("  apellidos       : [" + apellidos + "]");
        System.out.println("  correo          : [" + correo + "]");
        System.out.println("  tipoSolicitud   : [" + tipo + "]");
        System.out.println("  descripcion     : [" + descripcion + "]");

        // ── Helper: re-cargar ciudadano y redirigir al formulario con error ──
        // Se usa en cada punto de fallo para que el formulario no quede en blanco.

        // Validación básica
        if (doc == null || doc.isBlank()) {
            reenviarConError(req, resp, doc, "Falta el número de documento. Por favor busca tu información primero.");
            return;
        }
        if (correo == null || correo.isBlank()) {
            reenviarConError(req, resp, doc, "El correo electrónico es obligatorio.");
            return;
        }
        if (tipo == null || tipo.isBlank()) {
            reenviarConError(req, resp, doc, "Debes seleccionar un tipo de solicitud.");
            return;
        }
        if (descripcion == null || descripcion.isBlank()) {
            reenviarConError(req, resp, doc, "La descripción de la solicitud es obligatoria.");
            return;
        }

        // Construir objeto
        SolicitudCiudadano s = new SolicitudCiudadano();
        s.setNumeroDocumento(doc.trim());
        s.setNombres(nombres   != null ? nombres.trim()   : "");
        s.setApellidos(apellidos != null ? apellidos.trim() : "");
        s.setCorreo(correo.trim());
        s.setTelefono(telefono != null && !telefono.isBlank() ? telefono.trim() : null);
        s.setTipoSolicitud(tipo.trim());
        s.setDescripcion(descripcion.trim());

        // Guardar en BD
        int idGenerado;
        try {
            idGenerado = solicitudDao.guardar(s);
            s.setId(idGenerado);
            System.out.println("  ✅ Solicitud guardada con ID: " + idGenerado);
        } catch (Exception e) {
            e.printStackTrace();
            // Error de BD — mostrar el mensaje exacto para diagnosticar
            reenviarConError(req, resp, doc,
                    "Error al guardar en base de datos: " + e.getMessage()
                    + " — Causa: " + (e.getCause() != null ? e.getCause().getMessage() : "sin causa"));
            return;
        }

        // Correo de confirmación (fallo de correo NO interrumpe el flujo)
        try {
            PDFCorreoService.enviarCorreoSolicitudRecibida(correo.trim(), s);
            System.out.println("  ✅ Correo de confirmación enviado a: " + correo.trim());
        } catch (Exception mailEx) {
            // Solo log — no bloquea
            System.out.println("  ⚠️ Fallo al enviar correo (no crítico): " + mailEx.getMessage());
            mailEx.printStackTrace();
        }

        // Éxito
        req.setAttribute("solicitudEnviada", true);
        req.setAttribute("solicitudId", idGenerado);
        req.setAttribute("correoConfirmacion", correo.trim());
        req.getRequestDispatcher("/WEB-INF/vistas/solicitud/formulario.jsp").forward(req, resp);
    }

    /**
     * Re-carga el ciudadano desde la BD y reenvía al formulario con el mensaje de error dado.
     * Así el formulario nunca queda en blanco y el error siempre es visible.
     */
    private void reenviarConError(HttpServletRequest req, HttpServletResponse resp,
                                  String doc, String mensajeError)
            throws ServletException, IOException {

        System.out.println("  ❌ Error de validación/guardado: " + mensajeError);
        req.setAttribute("errorEnvio", mensajeError);
        req.setAttribute("docBuscado", doc);

        if (doc != null && !doc.isBlank()) {
            try {
                Ciudadano c = consultaDao.consultarPorDocumento(doc.trim());
                if (c != null) req.setAttribute("ciudadano", c);
            } catch (Exception ignored) {
                System.out.println("  ⚠️ No se pudo recargar ciudadano: " + ignored.getMessage());
            }
        }

        req.getRequestDispatcher("/WEB-INF/vistas/solicitud/formulario.jsp").forward(req, resp);
    }
}
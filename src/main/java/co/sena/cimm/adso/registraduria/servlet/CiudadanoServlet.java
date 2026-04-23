package co.sena.cimm.adso.registraduria.servlet;

import co.sena.cimm.adso.registraduria.dao.CiudadanoDAO;
import co.sena.cimm.adso.registraduria.dao.CiudadanoDAOImpl;
import co.sena.cimm.adso.registraduria.dao.MesaDAO;
import co.sena.cimm.adso.registraduria.dao.MesaDAOImpl;
import co.sena.cimm.adso.registraduria.model.Ciudadano;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/ciudadanos")
public class CiudadanoServlet extends HttpServlet {

    private CiudadanoDAO ciudadanoDAO;
    private MesaDAO mesaDAO;
    private DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Override
    public void init() {
        ciudadanoDAO = new CiudadanoDAOImpl();
        mesaDAO = new MesaDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null)
            action = "list";

        try {
            switch (action) {
                case "new":
                    mostrarFormulario(req, resp);
                    break;
                case "edit":
                    mostrarFormularioEditar(req, resp);
                    break;
                case "delete":
                    eliminarCiudadano(req, resp);
                    break;
                case "search":
                    buscarCiudadanos(req, resp);
                    break;
                default:
                    listarCiudadanos(req, resp);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        try {
            if ("create".equals(action)) {
                crearCiudadano(req, resp);
            } else if ("update".equals(action)) {
                actualizarCiudadano(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/ciudadanos");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // ── LISTAR ──────────────────────────────────────────────────────────────
    private void listarCiudadanos(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        req.setAttribute("ciudadanos", ciudadanoDAO.listarTodos());
        req.setAttribute("mesas", mesaDAO.listarTodas()); // necesario para los modales
        req.getRequestDispatcher("/WEB-INF/vistas/ciudadanos/listado.jsp").forward(req, resp);
    }

    // ── FORMULARIO NUEVO ────────────────────────────────────────────────────
    private void mostrarFormulario(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        req.setAttribute("ciudadano", new Ciudadano());
        req.setAttribute("accion", "create");
        req.setAttribute("mesas", mesaDAO.listarTodas()); // <-- carga mesas
        req.getRequestDispatcher("/WEB-INF/vistas/ciudadanos/formulario.jsp").forward(req, resp);
    }

    // ── FORMULARIO EDITAR ───────────────────────────────────────────────────
    private void mostrarFormularioEditar(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        Ciudadano ciudadano = ciudadanoDAO.buscarPorId(id);

        if (ciudadano != null) {
            req.setAttribute("ciudadano", ciudadano);
            req.setAttribute("accion", "update");
            req.setAttribute("mesas", mesaDAO.listarTodas()); // <-- carga mesas
            req.getRequestDispatcher("/WEB-INF/vistas/ciudadanos/formulario.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/ciudadanos?error=Ciudadano+no+encontrado");
        }
    }

    // ── CREAR ────────────────────────────────────────────────────────────────
    private void crearCiudadano(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        String documento = req.getParameter("numeroDocumento");

        if (ciudadanoDAO.existeDocumento(documento)) {
            req.setAttribute("error", "Ya existe un ciudadano con ese numero de documento");
            req.setAttribute("ciudadano", construirCiudadanoDesdeRequest(req));
            req.setAttribute("accion", "create");
            req.setAttribute("mesas", mesaDAO.listarTodas());
            req.getRequestDispatcher("/WEB-INF/vistas/ciudadanos/formulario.jsp").forward(req, resp);
            return;
        }

        Ciudadano c = construirCiudadanoDesdeRequest(req);

        if (ciudadanoDAO.insertar(c)) {
            resp.sendRedirect(req.getContextPath() + "/ciudadanos?mensaje=Ciudadano+creado+exitosamente");
        } else {
            req.setAttribute("error", "Error al crear el ciudadano");
            req.setAttribute("ciudadano", c);
            req.setAttribute("accion", "create");
            req.setAttribute("mesas", mesaDAO.listarTodas());
            req.getRequestDispatcher("/WEB-INF/vistas/ciudadanos/formulario.jsp").forward(req, resp);
        }
    }

    // ── ACTUALIZAR ───────────────────────────────────────────────────────────
    private void actualizarCiudadano(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        int id = Integer.parseInt(req.getParameter("id"));
        Ciudadano c = construirCiudadanoDesdeRequest(req);
        c.setIdCiudadanos(id);

        if (ciudadanoDAO.actualizar(c)) {
            resp.sendRedirect(req.getContextPath() + "/ciudadanos?mensaje=Ciudadano+actualizado+exitosamente");
        } else {
            req.setAttribute("error", "Error al actualizar el ciudadano");
            req.setAttribute("ciudadano", c);
            req.setAttribute("accion", "update");
            req.setAttribute("mesas", mesaDAO.listarTodas());
            req.getRequestDispatcher("/WEB-INF/vistas/ciudadanos/formulario.jsp").forward(req, resp);
        }
    }

    // ── ELIMINAR ─────────────────────────────────────────────────────────────
    private void eliminarCiudadano(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));

        // Verificar si tiene documentos expedidos antes de intentar borrar
        if (ciudadanoDAO.tieneDocumentos(id)) {
            resp.sendRedirect(req.getContextPath() + "/ciudadanos?error=tiene_documentos&id=" + id);
            return;
        }

        if (ciudadanoDAO.eliminar(id)) {
            resp.sendRedirect(req.getContextPath() + "/ciudadanos?mensaje=Ciudadano+eliminado+exitosamente");
        } else {
            resp.sendRedirect(req.getContextPath() + "/ciudadanos?error=No+se+pudo+eliminar+el+ciudadano");
        }
    }

    // ── BUSCAR ───────────────────────────────────────────────────────────────
    private void buscarCiudadanos(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        String criterio = req.getParameter("criterio");

        if (criterio != null && !criterio.trim().isEmpty()) {
            req.setAttribute("ciudadanos", ciudadanoDAO.buscarPorNombre(criterio));
            req.setAttribute("criterioBusqueda", criterio);
        } else {
            listarCiudadanos(req, resp);
            return;
        }

        req.setAttribute("mesas", mesaDAO.listarTodas()); // necesario para los modales
        req.getRequestDispatcher("/WEB-INF/vistas/ciudadanos/listado.jsp").forward(req, resp);
    }

    // ── HELPER ───────────────────────────────────────────────────────────────
    private Ciudadano construirCiudadanoDesdeRequest(HttpServletRequest req) {
        Ciudadano c = new Ciudadano();

        c.setNumeroDocumento(req.getParameter("numeroDocumento"));
        c.setNombres(req.getParameter("nombres"));
        c.setApellidos(req.getParameter("apellidos"));

        String fechaStr = req.getParameter("fechaNacimiento");
        if (fechaStr != null && !fechaStr.isEmpty()) {
            c.setFechaNacimiento(LocalDate.parse(fechaStr, formatter));
        }

        c.setVeredaBarrio(req.getParameter("veredaBarrio"));
        c.setTelefono(req.getParameter("telefono"));
        c.setCorreo(req.getParameter("correo"));

        String idMesa = req.getParameter("idMesasVotacion");
        if (idMesa != null && !idMesa.isEmpty()) {
            c.setIdMesasVotacion(Integer.parseInt(idMesa));
        } else {
            c.setIdMesasVotacion(null); // explicitamente sin mesa
        }

        return c;
    }
}
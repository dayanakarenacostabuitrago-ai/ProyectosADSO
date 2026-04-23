package co.sena.cimm.adso.registraduria.servlet;

import co.sena.cimm.adso.registraduria.config.ConexionDB;
import co.sena.cimm.adso.registraduria.dao.ZonaVotacionDAO;
import co.sena.cimm.adso.registraduria.dao.ZonaVotacionDAOImpl;
import co.sena.cimm.adso.registraduria.model.ZonaVotacion;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/zonas")
public class ZonaServlet extends HttpServlet {

    private ZonaVotacionDAO dao;

    @Override
    public void init() {
        dao = new ZonaVotacionDAOImpl();
    }

    /** GET /zonas → listado, búsqueda, o formulario nuevo/editar */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");

        try {
            if ("nuevo".equals(accion)) {
                cargarCiudades(req);
                req.getRequestDispatcher("/WEB-INF/vistas/zonas/formulario.jsp").forward(req, resp);

            } else if ("editar".equals(accion)) {
                int id = Integer.parseInt(req.getParameter("id"));
                ZonaVotacion zona = dao.buscarPorId(id);
                if (zona == null) {
                    resp.sendRedirect(req.getContextPath() + "/zonas?msg=no_encontrada");
                    return;
                }
                req.setAttribute("zona", zona);
                cargarCiudades(req);
                req.getRequestDispatcher("/WEB-INF/vistas/zonas/formulario.jsp").forward(req, resp);

            } else if ("eliminar".equals(accion)) {
                int id = Integer.parseInt(req.getParameter("id"));
                if (dao.tieneMesas(id)) {
                    resp.sendRedirect(req.getContextPath() + "/zonas?error=tiene_mesas");
                } else {
                    dao.eliminar(id);
                    resp.sendRedirect(req.getContextPath() + "/zonas?msg=eliminada");
                }

            } else {
                // Listado con filtro por ciudad y búsqueda opcional
                String buscar = req.getParameter("buscar");
                String idCiudadParam = req.getParameter("idCiudad");
                List<ZonaVotacion> lista;
                if (idCiudadParam != null && !idCiudadParam.isBlank()) {
                    int idCiudad = Integer.parseInt(idCiudadParam.trim());
                    lista = dao.buscarPorCiudad(idCiudad);
                    req.setAttribute("ciudadFiltroId", idCiudad);
                } else if (buscar != null && !buscar.isBlank()) {
                    lista = dao.buscar(buscar.trim());
                    req.setAttribute("buscar", buscar.trim());
                } else {
                    lista = dao.listarTodas();
                }
                req.setAttribute("zonas", lista);
                cargarCiudades(req);
                req.getRequestDispatcher("/WEB-INF/vistas/zonas/listado.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.setAttribute("zonas", new ArrayList<>());
            try {
                cargarCiudades(req);
                req.getRequestDispatcher("/WEB-INF/vistas/zonas/listado.jsp").forward(req, resp);
            } catch (Exception ex) {
                throw new ServletException(ex);
            }
        }
    }

    /** POST /zonas → crear o actualizar */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");

        try {
            ZonaVotacion zona = new ZonaVotacion();
            zona.setNombreZona(req.getParameter("nombreZona").trim());
            zona.setPuestoVotacion(req.getParameter("puestoVotacion").trim());
            zona.setDireccion(req.getParameter("direccion").trim());

            String idCiud = req.getParameter("idCiudades");
            zona.setIdCiudades((idCiud != null && !idCiud.isBlank()) ? Integer.parseInt(idCiud) : null);

            // Validaciones básicas
            if (zona.getNombreZona().isEmpty() || zona.getPuestoVotacion().isEmpty()) {
                req.setAttribute("zona", zona);
                req.setAttribute("error", "El nombre de zona y el puesto de votación son obligatorios.");
                cargarCiudades(req);
                req.getRequestDispatcher("/WEB-INF/vistas/zonas/formulario.jsp").forward(req, resp);
                return;
            }

            if ("crear".equals(accion)) {
                dao.crear(zona);
                resp.sendRedirect(req.getContextPath() + "/zonas?msg=creada");
            } else {
                zona.setIdZonaVotacion(Integer.parseInt(req.getParameter("idZonaVotacion")));
                dao.actualizar(zona);
                resp.sendRedirect(req.getContextPath() + "/zonas?msg=actualizada");
            }

        } catch (Exception e) {
            req.setAttribute("error", "Error al guardar: " + e.getMessage());
            cargarCiudades(req);
            req.getRequestDispatcher("/WEB-INF/vistas/zonas/formulario.jsp").forward(req, resp);
        }
    }

    /** Carga el listado de ciudades para el <select> del formulario */
    private void cargarCiudades(HttpServletRequest req) {
        List<Object[]> ciudades = new ArrayList<>();
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement("SELECT idCiudades, nombre FROM ciudades ORDER BY nombre");
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ciudades.add(new Object[] { rs.getInt("idCiudades"), rs.getString("nombre") });
            }
        } catch (Exception ignored) {
        }
        req.setAttribute("ciudades", ciudades);
    }
}
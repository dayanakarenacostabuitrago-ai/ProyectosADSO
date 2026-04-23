package co.sena.cimm.adso.registraduria.servlet;

import co.sena.cimm.adso.registraduria.config.ConexionDB;
import co.sena.cimm.adso.registraduria.dao.MesaDAO;
import co.sena.cimm.adso.registraduria.dao.MesaDAOImpl;
import co.sena.cimm.adso.registraduria.model.Mesa;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/mesas")
public class MesaServlet extends HttpServlet {

    private MesaDAO dao;

    @Override
    public void init() {
        dao = new MesaDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");

        try {
            if ("eliminar".equals(accion)) {
                int id = Integer.parseInt(req.getParameter("id"));
                if (dao.tieneCiudadanos(id)) {
                    resp.sendRedirect(req.getContextPath() + "/mesas?error=tiene_ciudadanos");
                } else {
                    dao.eliminar(id);
                    resp.sendRedirect(req.getContextPath() + "/mesas?msg=eliminada");
                }
            } else {
                String buscar = req.getParameter("buscar");
                String idZonaParam = req.getParameter("idZona");
                List<Mesa> lista;
                if (idZonaParam != null && !idZonaParam.isBlank()) {
                    int idZona = Integer.parseInt(idZonaParam.trim());
                    lista = dao.buscarPorZona(idZona);
                    req.setAttribute("zonaFiltroId", idZona);
                } else if (buscar != null && !buscar.isBlank()) {
                    lista = dao.buscar(buscar.trim());
                    req.setAttribute("buscar", buscar.trim());
                } else {
                    lista = dao.listarTodas();
                }
                req.setAttribute("mesas", lista);
                cargarZonas(req);
                req.getRequestDispatcher("/WEB-INF/vistas/mesas/listado.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.setAttribute("mesas", new ArrayList<>());
            cargarZonas(req);
            req.getRequestDispatcher("/WEB-INF/vistas/mesas/listado.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");

        try {
            Mesa m = new Mesa();
            m.setIdZonaVotacion(Integer.parseInt(req.getParameter("idZonaVotacion")));
            m.setNumeroMesa(Integer.parseInt(req.getParameter("numeroMesa")));
            String cap = req.getParameter("capacidad");
            m.setCapacidad((cap != null && !cap.isBlank()) ? Integer.parseInt(cap) : 200);

            if ("crear".equals(accion)) {
                dao.crear(m);
                resp.sendRedirect(req.getContextPath() + "/mesas?msg=creada");
            } else {
                m.setIdMesasVotacion(Integer.parseInt(req.getParameter("idMesasVotacion")));
                dao.actualizar(m);
                resp.sendRedirect(req.getContextPath() + "/mesas?msg=actualizada");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/mesas?error=" + e.getMessage());
        }
    }

    private void cargarZonas(HttpServletRequest req) {
        List<Object[]> zonas = new ArrayList<>();
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con
                        .prepareStatement("SELECT idZonaVotacion, nombreZona FROM zonasVotacion ORDER BY nombreZona");
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                zonas.add(new Object[] { rs.getInt("idZonaVotacion"), rs.getString("nombreZona") });
        } catch (Exception ignored) {
        }
        req.setAttribute("zonas", zonas);
    }
}
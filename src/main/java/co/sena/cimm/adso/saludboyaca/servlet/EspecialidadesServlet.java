package co.sena.cimm.adso.saludboyaca.servlet;

import co.sena.cimm.adso.saludboyaca.dao.EspecialidadDAO;
import co.sena.cimm.adso.saludboyaca.dto.Especialidad;
import co.sena.cimm.adso.saludboyaca.dto.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/especialidad")
public class EspecialidadesServlet extends HttpServlet {

    private EspecialidadDAO especialidadDAO = new EspecialidadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario u = validarSesion(request, response);
        if (u == null)
            return;

        String accion = request.getParameter("accion");
        if (accion == null)
            accion = "listar";

        switch (accion) {

            case "listar":
                listar(request, response);
                break;

            case "eliminar":
                if (!validarRecepcionista(u, request, response))
                    return;
                eliminar(request, response);
                break;

            default:
                listar(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Usuario u = validarSesion(request, response);
        if (u == null)
            return;

        String accion = request.getParameter("accion");

        if ("insertar".equals(accion)) {
            if (!validarRecepcionista(u, request, response))
                return;
            insertar(request, response);
        }
    }

    // ================= MÉTODOS =================

    private void listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Especialidad> lista = especialidadDAO.listar();
        request.setAttribute("especialidades", lista);
        request.getRequestDispatcher("especialidad/lista.jsp").forward(request, response);
    }

    private void insertar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Especialidad e = new Especialidad();
        e.setNombre(request.getParameter("nombre"));
        e.setDescripcion(request.getParameter("descripcion"));

        especialidadDAO.insertar(e);

        response.sendRedirect("especialidad?accion=listar");
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        especialidadDAO.eliminar(id);

        response.sendRedirect("especialidad?accion=listar");
    }

    // ================= VALIDACIONES =================

    private Usuario validarSesion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Usuario u = (Usuario) request.getSession().getAttribute("usuario");

        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/login");
        }

        return u;
    }

    /** Devuelve true si el rol es RECEPCIONISTA, false (y redirige) si no. */
    private boolean validarRecepcionista(Usuario u, HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        if (!"RECEPCIONISTA".equals(u.getRol())) {
            response.sendRedirect(request.getContextPath() + "/error");
            return false;
        }
        return true;
    }
}

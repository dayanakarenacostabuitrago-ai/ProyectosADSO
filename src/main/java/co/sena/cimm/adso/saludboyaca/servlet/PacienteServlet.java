package co.sena.cimm.adso.saludboyaca.servlet;

import co.sena.cimm.adso.saludboyaca.dao.PacienteDAO;
import co.sena.cimm.adso.saludboyaca.dto.Paciente;
import co.sena.cimm.adso.saludboyaca.dto.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet(urlPatterns = { "/paciente", "/pacientes" })
public class PacienteServlet extends HttpServlet {

    private PacienteDAO pacienteDAO = new PacienteDAO();

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

            case "nuevo":
                if (!validarRecepcionista(u, request, response))
                    return;
                request.getRequestDispatcher("/views/pacientes/formulario.jsp").forward(request, response);
                break;

            case "editar":
                if (!validarRecepcionista(u, request, response))
                    return;
                editar(request, response);
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
            throws ServletException, IOException {

        Usuario u = validarSesion(request, response);
        if (u == null)
            return;

        String accion = request.getParameter("accion");

        if ("insertar".equals(accion)) {
            if (!validarRecepcionista(u, request, response))
                return;
            insertar(request, response);
        } else if ("actualizar".equals(accion)) {
            if (!validarRecepcionista(u, request, response))
                return;
            actualizar(request, response);
        }
    }

    // ================= MÉTODOS =================

    private void listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Paciente> lista = pacienteDAO.listar();
        request.setAttribute("pacientes", lista);
        request.getRequestDispatcher("/views/pacientes/lista.jsp").forward(request, response);
    }

    private void insertar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            Paciente p = obtenerPacienteDesdeRequest(request);
            pacienteDAO.insertar(p);
            request.getSession().setAttribute("flashMessage", "Paciente registrado correctamente.");
            request.getSession().setAttribute("flashType", "success");
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("pacientes?accion=listar");
    }

    private void actualizar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            Paciente p = obtenerPacienteDesdeRequest(request);
            p.setIdPaciente(Integer.parseInt(request.getParameter("idPaciente")));
            pacienteDAO.actualizar(p);
            request.getSession().setAttribute("flashMessage", "Paciente actualizado correctamente.");
            request.getSession().setAttribute("flashType", "success");
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("pacientes?accion=listar");
    }

    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Paciente p = pacienteDAO.buscarPorId(id);

        request.setAttribute("paciente", p);
        request.getRequestDispatcher("/views/pacientes/formulario.jsp").forward(request, response);
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        pacienteDAO.eliminar(id);
        request.getSession().setAttribute("flashMessage", "Paciente eliminado.");
        request.getSession().setAttribute("flashType", "warning");

        response.sendRedirect("pacientes?accion=listar");
    }

    // ================= UTILIDADES =================

    private Paciente obtenerPacienteDesdeRequest(HttpServletRequest request) throws Exception {

        Paciente p = new Paciente();

        p.setNombres(request.getParameter("nombres"));
        p.setApellidos(request.getParameter("apellidos"));
        p.setDocumento(request.getParameter("documento"));

        String fecha = request.getParameter("fechaNacimiento");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        p.setFechaNacimiento(sdf.parse(fecha));

        p.setTelefono(request.getParameter("telefono"));
        p.setEmail(request.getParameter("email"));
        p.setEps(request.getParameter("eps"));
        p.setVeredaBarrio(request.getParameter("veredaBarrio"));

        return p;
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

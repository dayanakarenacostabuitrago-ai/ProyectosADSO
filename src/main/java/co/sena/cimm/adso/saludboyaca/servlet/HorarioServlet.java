package co.sena.cimm.adso.saludboyaca.servlet;

import co.sena.cimm.adso.saludboyaca.dao.HorarioDAO;
import co.sena.cimm.adso.saludboyaca.dao.UsuarioDAO;
import co.sena.cimm.adso.saludboyaca.dto.Horario;
import co.sena.cimm.adso.saludboyaca.dto.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalTime;
import java.util.List;

@WebServlet(urlPatterns = { "/horario", "/horarios" })
public class HorarioServlet extends HttpServlet {

    private HorarioDAO horarioDAO = new HorarioDAO();
    private UsuarioDAO usuarioDAO = new UsuarioDAO();

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
                listar(request, response, u);
                break;

            case "nuevo":
                if (!validarRecepcionista(u, request, response))
                    return;
                cargarFormulario(request, response, null);
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

            case "porMedico":
                listarPorMedico(request, response, u);
                break;

            default:
                listar(request, response, u);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario u = validarSesion(request, response);
        if (u == null)
            return;

        if (!validarRecepcionista(u, request, response))
            return;

        String accion = request.getParameter("accion");

        switch (accion) {
            case "insertar":
                insertar(request, response);
                break;
            case "actualizar":
                actualizar(request, response);
                break;
        }
    }

    // ================= LISTAR =================

    private void listar(HttpServletRequest request, HttpServletResponse response, Usuario u)
            throws ServletException, IOException {

        List<Horario> lista;
        List<Usuario> medicos = usuarioDAO.listarMedicos();

        if ("MEDICO".equals(u.getRol())) {
            lista = horarioDAO.listarPorMedico(u.getIdUsuario());
        } else {
            // RECEPCIONISTA y ADMINISTRADOR: filtra por médico si viene parámetro
            String idParam = request.getParameter("idUsuario");
            if (idParam != null && !idParam.isEmpty()) {
                lista = horarioDAO.listarPorMedico(Integer.parseInt(idParam));
                request.setAttribute("medicoFiltrado", Integer.parseInt(idParam));
            } else {
                lista = horarioDAO.listarTodos();
            }
            request.setAttribute("medicos", medicos);
        }

        // Enriquecer cada horario con el nombre del médico
        for (Horario h : lista) {
            Usuario med = usuarioDAO.buscarPorId(h.getIdUsuario());
            if (med != null) {
                h.setNombreMedico(med.getNombres() + " " + med.getApellidos());
            }
        }

        request.setAttribute("horarios", lista);
        request.getRequestDispatcher("/views/horarios/lista.jsp").forward(request, response);
    }

    private void listarPorMedico(HttpServletRequest request, HttpServletResponse response, Usuario u)
            throws ServletException, IOException {
        listar(request, response, u);
    }

    // ================= FORMULARIO NUEVO =================

    private void cargarFormulario(HttpServletRequest request, HttpServletResponse response, Horario horario)
            throws ServletException, IOException {
        request.setAttribute("medicos", usuarioDAO.listarMedicos());
        request.setAttribute("horario", horario);
        request.getRequestDispatcher("/views/horarios/formulario.jsp").forward(request, response);
    }

    // ================= EDITAR =================

    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Horario h = horarioDAO.buscarPorId(id);
        cargarFormulario(request, response, h);
    }

    // ================= INSERTAR =================

    private void insertar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Horario h = mapearFormulario(request);
            horarioDAO.insertar(h);
            request.getSession().setAttribute("flashMessage", "✅ Horario creado correctamente.");
            request.getSession().setAttribute("flashType", "success");
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("horarios?accion=listar");
    }

    // ================= ACTUALIZAR =================

    private void actualizar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Horario h = mapearFormulario(request);
            h.setIdHorario(Integer.parseInt(request.getParameter("idHorario")));
            horarioDAO.actualizar(h);
            request.getSession().setAttribute("flashMessage", "✅ Horario actualizado correctamente.");
            request.getSession().setAttribute("flashType", "success");
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("horarios?accion=listar");
    }

    // ================= ELIMINAR =================

    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        horarioDAO.eliminar(id);
        request.getSession().setAttribute("flashMessage", "Horario eliminado.");
        request.getSession().setAttribute("flashType", "warning");
        response.sendRedirect("horarios?accion=listar");
    }

    // ================= HELPER =================

    private Horario mapearFormulario(HttpServletRequest req) {
        Horario h = new Horario();
        h.setIdUsuario(Integer.parseInt(req.getParameter("idUsuario")));
        h.setDiaSemana(Integer.parseInt(req.getParameter("diaSemana")));
        h.setHoraInicio(LocalTime.parse(req.getParameter("horaInicio")));
        h.setHoraFin(LocalTime.parse(req.getParameter("horaFin")));
        String maxStr = req.getParameter("maxCitas");
        h.setMaxCitas(maxStr != null && !maxStr.isEmpty() ? Integer.parseInt(maxStr) : 10);
        return h;
    }

    // ================= VALIDACIONES =================

    private Usuario validarSesion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Usuario u = (Usuario) request.getSession().getAttribute("usuario");
        if (u == null)
            response.sendRedirect(request.getContextPath() + "/login");
        return u;
    }

    private boolean validarRecepcionista(Usuario u, HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        if (!"RECEPCIONISTA".equals(u.getRol()) && !"ADMINISTRADOR".equals(u.getRol())) {
            request.setAttribute("errorMensaje",
                    "Acceso denegado: solo la RECEPCIONISTA o ADMINISTRADOR puede gestionar horarios.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            return false;
        }
        return true;
    }
}

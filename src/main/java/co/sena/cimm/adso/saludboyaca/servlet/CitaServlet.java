package co.sena.cimm.adso.saludboyaca.servlet;

import co.sena.cimm.adso.saludboyaca.dao.*;
import co.sena.cimm.adso.saludboyaca.dto.*;
import co.sena.cimm.adso.saludboyaca.util.PDFGenerator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@WebServlet(urlPatterns = { "/cita", "/citas" })
public class CitaServlet extends HttpServlet {

    private CitaDAO citaDAO = new CitaDAO();
    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private EspecialidadDAO especialidadDAO = new EspecialidadDAO();
    private HorarioDAO horarioDAO = new HorarioDAO();
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
                listar(request, response, u);
                break;

            case "nuevo":
                if (!validarRecepcionista(u, request, response))
                    return;
                cargarFormulario(request, response);
                break;

            case "editar":
                if (!validarRecepcionista(u, request, response))
                    return;
                editar(request, response);
                break;

            case "detalle":
                detalle(request, response);
                break;

            case "eliminar":
                if (!validarRecepcionista(u, request, response))
                    return;
                eliminar(request, response);
                break;

            case "exportarPDF":
                exportarPDF(request, response, u);
                break;

            case "medicosPorEspecialidad":
                medicosPorEspecialidad(request, response);
                break;

            case "horasDisponibles":
                horasDisponibles(request, response);
                break;

            case "diasDisponibles":
                diasDisponibles(request, response);
                break;

            default:
                listar(request, response, u);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        Usuario u = validarSesion(request, response);
        if (u == null)
            return;

        String accion = request.getParameter("accion");

        switch (accion) {

            case "insertar":
                if (!validarRecepcionista(u, request, response))
                    return;
                insertar(request, response, u);
                break;

            case "actualizar":
                if (!validarRecepcionista(u, request, response))
                    return;
                actualizar(request, response);
                break;

            case "cambiarEstado":
                if (!validarMedico(u, request, response))
                    return;
                cambiarEstado(request, response);
                break;
        }
    }

    // ================= LISTAR =================

    private void listar(HttpServletRequest request, HttpServletResponse response, Usuario u)
            throws ServletException, IOException {

        String filtroEstado = request.getParameter("filtroEstado");
        String filtroEspStr = request.getParameter("filtroEspecialidad");
        Integer filtroEsp = null;
        try { if (filtroEspStr != null && !filtroEspStr.isEmpty()) filtroEsp = Integer.parseInt(filtroEspStr); }
        catch (NumberFormatException ignored) {}

        List<Cita> lista;
        boolean usarFiltros = (filtroEstado != null && !filtroEstado.isEmpty()) || filtroEsp != null;

        switch (u.getRol()) {
            case "MEDICO":
                lista = citaDAO.listarPorMedico(u.getIdUsuario());
                break;
            case "RECEPCIONISTA":
            case "ADMINISTRADOR":
            case "ENFERMERO":
                lista = usarFiltros
                    ? citaDAO.listarConFiltros(filtroEsp, (filtroEstado != null && !filtroEstado.isEmpty()) ? filtroEstado : null)
                    : citaDAO.listarTodas();
                break;
            default:
                lista = new java.util.ArrayList<>();
        }

        request.setAttribute("citas", lista);
        request.setAttribute("especialidades", especialidadDAO.listar());
        request.setAttribute("filtroEstado", filtroEstado != null ? filtroEstado : "");
        request.setAttribute("filtroEspecialidad", filtroEspStr != null ? filtroEspStr : "");
        request.getRequestDispatcher("/views/citas/lista.jsp").forward(request, response);
    }

    // ================= INSERTAR =================

    private void insertar(HttpServletRequest request, HttpServletResponse response, Usuario u)
            throws IOException {

        try {
            Cita c = new Cita();

            c.setIdPaciente(Integer.parseInt(request.getParameter("idPaciente")));
            c.setIdUsuario(Integer.parseInt(request.getParameter("idUsuario")));
            c.setIdEspecialidad(Integer.parseInt(request.getParameter("idEspecialidad")));

            c.setFechaCita(java.sql.Date.valueOf(request.getParameter("fechaCita")));
            c.setHoraCita(LocalTime.parse(request.getParameter("horaCita")));

            c.setMotivo(request.getParameter("motivo"));
            c.setEstado("PROGRAMADA");
            c.setObservaciones(request.getParameter("observaciones"));

            c.setFechaRegistro(java.time.LocalDateTime.now());
            c.setIdRegistrador(u.getIdUsuario());

            citaDAO.insertar(c);
            request.getSession().setAttribute("flashMessage", "✅ Cita programada correctamente.");
            request.getSession().setAttribute("flashType", "success");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("flashMessage", "⚠️ Error al programar la cita.");
            request.getSession().setAttribute("flashType", "error");
        }

        response.sendRedirect("citas?accion=listar");
    }

    // ================= ACTUALIZAR =================

    private void actualizar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            Cita c = new Cita();

            c.setIdCita(Integer.parseInt(request.getParameter("idCita")));
            c.setIdPaciente(Integer.parseInt(request.getParameter("idPaciente")));
            c.setIdUsuario(Integer.parseInt(request.getParameter("idUsuario")));
            c.setIdEspecialidad(Integer.parseInt(request.getParameter("idEspecialidad"))); // ← AGREGAR ESTA LÍNEA

            c.setFechaCita(java.sql.Date.valueOf(request.getParameter("fechaCita")));
            c.setHoraCita(LocalTime.parse(request.getParameter("horaCita")));

            c.setMotivo(request.getParameter("motivo"));
            c.setObservaciones(request.getParameter("observaciones"));

            // IMPORTANTE: Mantener el estado existente o definirlo
            // Si no viene en el formulario, consulta la cita actual
            String estado = request.getParameter("estado");
            if (estado != null && !estado.isEmpty()) {
                c.setEstado(estado);
            } else {
                // Mantener el estado actual
                Cita citaExistente = citaDAO.buscarPorId(c.getIdCita());
                if (citaExistente != null) {
                    c.setEstado(citaExistente.getEstado());
                } else {
                    c.setEstado("PROGRAMADA"); // Valor por defecto válido
                }
            }

            citaDAO.actualizar(c);
            request.getSession().setAttribute("flashMessage", "u2705 Cita actualizada correctamente.");
            request.getSession().setAttribute("flashType", "success");

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("citas?accion=listar");
    }

    // ================= CAMBIAR ESTADO =================

    private void cambiarEstado(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("idCita"));
        String estado = request.getParameter("estado");

        citaDAO.cambiarEstado(id, estado);
        request.getSession().setAttribute("flashMessage", "Estado de cita actualizado.");
        request.getSession().setAttribute("flashType", "success");

        response.sendRedirect("citas?accion=listar");
    }

    // ================= ELIMINAR =================

    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        citaDAO.eliminar(id);
        request.getSession().setAttribute("flashMessage", "Cita eliminada.");
        request.getSession().setAttribute("flashType", "warning");

        response.sendRedirect("citas?accion=listar");
    }

    // ================= DETALLE =================

    private void detalle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Cita c = citaDAO.buscarPorId(id);

        if (c != null) {
            Paciente paciente = pacienteDAO.buscarPorId(c.getIdPaciente());
            Usuario medico = usuarioDAO.buscarPorId(c.getIdUsuario());
            Especialidad especialidad = especialidadDAO.buscarPorId(c.getIdEspecialidad());

            request.setAttribute("paciente", paciente);
            request.setAttribute("medico", medico);
            request.setAttribute("especialidad", especialidad);
        }

        request.setAttribute("cita", c);
        request.getRequestDispatcher("/views/citas/detalle.jsp").forward(request, response);
    }

    // ================= EXPORTAR PDF =================

    private void exportarPDF(HttpServletRequest request, HttpServletResponse response, Usuario u)
            throws IOException {

        List<Cita> citas;
        String titulo;

        if ("MEDICO".equals(u.getRol())) {
            citas = citaDAO.listarPorMedico(u.getIdUsuario());
            titulo = "Mis Citas — " + u.getNombres() + " " + u.getApellidos();
        } else if ("ADMINISTRADOR".equals(u.getRol())) {
            citas = citaDAO.listarTodas();
            titulo = "Todas las Citas del Sistema";
        } else {
            citas = citaDAO.listarPorEstado("PROGRAMADA");
            titulo = "Citas Pendientes";
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=\"citas.pdf\"");

        try (OutputStream out = response.getOutputStream()) {
            PDFGenerator.generarListaCitas(citas, titulo, pacienteDAO, usuarioDAO, especialidadDAO, out);
        }
    }

    // ================= FORMULARIO =================

    private void cargarFormulario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("especialidades", especialidadDAO.listar());
        request.setAttribute("pacientes", pacienteDAO.listar());
        request.getRequestDispatcher("/views/citas/formulario.jsp").forward(request, response);
    }

    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Cita c = citaDAO.buscarPorId(id);

        request.setAttribute("cita", c);
        request.setAttribute("especialidades", especialidadDAO.listar());
        request.setAttribute("pacientes", pacienteDAO.listar());

        // Precargar médicos de la especialidad de esta cita para el select
        if (c != null) {
            List<Usuario> medicosCita = usuarioDAO.listarMedicosPorEspecialidad(c.getIdEspecialidad());
            request.setAttribute("medicosCita", medicosCita);
        }

        request.getRequestDispatcher("/views/citas/formulario.jsp").forward(request, response);
    }

    // ================= AJAX =================

    private void medicosPorEspecialidad(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int idEspecialidad = Integer.parseInt(request.getParameter("idEspecialidad"));

        List<Usuario> medicos = usuarioDAO.listarMedicosPorEspecialidad(idEspecialidad);

        response.setContentType("application/json");
        String json = "[";

        for (int i = 0; i < medicos.size(); i++) {
            Usuario m = medicos.get(i);
            json += "{\"id\":" + m.getIdUsuario() +
                    ",\"nombre\":\"" + m.getNombres() + " " + m.getApellidos() + "\"}";
            if (i < medicos.size() - 1)
                json += ",";
        }

        json += "]";
        response.getWriter().write(json);
    }

    private void horasDisponibles(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
        System.out.println("fecha param: " + request.getParameter("fecha"));
        LocalDate fecha = LocalDate.parse(request.getParameter("fecha"));

        List<LocalTime> horas = horarioDAO.horasDisponibles(idUsuario, fecha);

        response.setContentType("application/json");
        String json = "[";

        for (int i = 0; i < horas.size(); i++) {
            json += "\"" + horas.get(i).toString() + "\"";
            if (i < horas.size() - 1)
                json += ",";
        }

        json += "]";
        response.getWriter().write(json);
    }

    private void diasDisponibles(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));

        List<Integer> dias = horarioDAO.diasConHorario(idUsuario);

        response.setContentType("application/json");
        String json = "[";
        for (int i = 0; i < dias.size(); i++) {
            json += dias.get(i);
            if (i < dias.size() - 1)
                json += ",";
        }
        json += "]";
        response.getWriter().write(json);
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

    /** Devuelve true si RECEPCIONISTA o ADMINISTRADOR, false y hace forward a error.jsp si no. */
    private boolean validarRecepcionista(Usuario u, HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        if (!"RECEPCIONISTA".equals(u.getRol()) && !"ADMINISTRADOR".equals(u.getRol())) {
            request.setAttribute("errorMensaje",
                    "Acceso denegado: solo la RECEPCIONISTA o ADMINISTRADOR puede realizar esta acci\u00f3n.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            return false;
        }
        return true;
    }

    /** Devuelve true si MEDICO, false y hace forward a error.jsp si no. */
    private boolean validarMedico(Usuario u, HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        if (!"MEDICO".equals(u.getRol())) {
            request.setAttribute("errorMensaje",
                    "Acceso denegado: solo el M\u00c9DICO puede realizar esta acci\u00f3n.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            return false;
        }
        return true;
    }
}
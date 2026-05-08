package co.sena.cimm.adso.saludboyaca.servlet;

import co.sena.cimm.adso.saludboyaca.dao.CitaDAO;
import co.sena.cimm.adso.saludboyaca.dao.HorarioDAO;
import co.sena.cimm.adso.saludboyaca.dao.PacienteDAO;
import co.sena.cimm.adso.saludboyaca.dao.UsuarioDAO;
import co.sena.cimm.adso.saludboyaca.dto.Cita;
import co.sena.cimm.adso.saludboyaca.dto.Horario;
import co.sena.cimm.adso.saludboyaca.dto.Paciente;
import co.sena.cimm.adso.saludboyaca.dto.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final CitaDAO citaDAO = new CitaDAO();
    private final PacienteDAO pacienteDAO = new PacienteDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final HorarioDAO horarioDAO = new HorarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession(false);
        Usuario u = session != null ? (Usuario) session.getAttribute("usuario") : null;

        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String rol = u.getRol() != null ? u.getRol().toUpperCase().trim() : "";

        switch (rol) {

            case "MEDICO":
                List<Cita> citasMedico = citaDAO.citasHoyMedico(u.getIdUsuario());
                enriquecerCitas(citasMedico);
                request.setAttribute("citasHoy", citasMedico);
                request.setAttribute("actividadJson", mapToJson(citaDAO.citasPorDiaMedico(u.getIdUsuario(), 14)));
                // totalPacientes = pacientes únicos del médico (aprox. citas totales únicas)
                List<Cita> todasMedico = citaDAO.listarPorMedico(u.getIdUsuario());
                java.util.Set<Integer> pacientesUnicos = new java.util.HashSet<>();
                for (Cita c : todasMedico) pacientesUnicos.add(c.getIdPaciente());
                request.setAttribute("totalPacientes", pacientesUnicos.size());
                break;

            case "RECEPCIONISTA":
                request.setAttribute("totalPacientes", pacienteDAO.totalPacientes());
                List<Cita> citasRecep = citaDAO.citasHoy();
                enriquecerCitas(citasRecep);
                request.setAttribute("citasHoy", citasRecep);
                request.setAttribute("citasPendientes", citaDAO.citasPendientes().size());
                request.setAttribute("actividadJson", mapToJson(citaDAO.citasPorDia(14)));
                request.setAttribute("totalCitasGeneral", citaDAO.totalCitas());
                break;

            case "ENFERMERO":
                List<Cita> citasEnf = citaDAO.listarTodas();
                enriquecerCitas(citasEnf);
                request.setAttribute("citasHoy", citasEnf);
                request.setAttribute("totalPacientes", pacienteDAO.totalPacientes());
                request.setAttribute("actividadJson", mapToJson(citaDAO.citasPorDia(14)));
                request.setAttribute("totalCitasGeneral", citaDAO.totalCitas());
                break;

            case "ADMINISTRADOR":
                try {
                    cargarEstadisticasAdmin(request);
                    request.setAttribute("rol", rol);
                    request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("errorMensaje", "Error al cargar dashboard: " + e.getMessage());
                    request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                }
                return;

            default:
                request.setAttribute("errorMensaje",
                        "Rol no reconocido: '" + u.getRol() + "'. Contacte al administrador.");
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return;
        }

        request.setAttribute("rol", rol);
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    // ── ESTADÍSTICAS COMPLETAS PARA ADMINISTRADOR ─────────────────
    private void cargarEstadisticasAdmin(HttpServletRequest request) {

        int totalUsuarios = usuarioDAO.listar().size();
        int totalPacientes = pacienteDAO.totalPacientes();
        int citasHoyCount = citaDAO.citasHoy().size();
        int totalCitas = citaDAO.totalCitas();
        int citasPendientes = citaDAO.citasPendientes().size();
        int totalMedicos = usuarioDAO.listarMedicos().size();

        request.setAttribute("totalUsuarios", totalUsuarios);
        request.setAttribute("totalPacientes", totalPacientes);
        request.setAttribute("citasHoyCount", citasHoyCount);
        request.setAttribute("totalCitas", totalCitas);
        request.setAttribute("citasPendientes", citasPendientes);
        request.setAttribute("totalMedicos", totalMedicos);

        // Distribución usuarios por rol
        Map<String, Integer> usuariosPorRol = usuarioDAO.contarPorRol();
        request.setAttribute("usuariosPorRolJson", mapToJson(usuariosPorRol));

        // Estado de citas
        Map<String, Integer> estadoCitas = citaDAO.contarPorEstado();
        request.setAttribute("estadoCitasJson", mapToJson(estadoCitas));

        // Citas por especialidad
        Map<String, Integer> citasPorEsp = citaDAO.citasPorEspecialidad();
        request.setAttribute("citasPorEspJson", mapToJson(citasPorEsp));

        // Citas últimos 6 meses
        Calendar cal = Calendar.getInstance();
        List<String> meses = new ArrayList<>();
        List<Integer> cantidades = new ArrayList<>();
        for (int i = 5; i >= 0; i--) {
            Calendar tmp = (Calendar) cal.clone();
            tmp.add(Calendar.MONTH, -i);
            int mes = tmp.get(Calendar.MONTH) + 1;
            int anio = tmp.get(Calendar.YEAR);
            String[] nombMes = { "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic" };
            meses.add(nombMes[mes - 1] + " " + anio);
            cantidades.add(citaDAO.citasPorMes(mes, anio).size());
        }
        request.setAttribute("mesesJson", toJsonArray(meses));
        request.setAttribute("cantidadesJson", cantidades.toString());

        // ── HORARIOS POR MÉDICO ──────────────────────────────────
        List<Usuario> medicos = usuarioDAO.listarMedicos();
        // Construir JSON: [ {id, nombre, horarios: [{dia, inicio, fin, max},...] }, ...
        // ]
        StringBuilder horariosJson = new StringBuilder("[");
        String[] diasNombre = { "", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo" };
        for (int m = 0; m < medicos.size(); m++) {
            Usuario med = medicos.get(m);
            List<Horario> horarios = horarioDAO.listarPorMedico(med.getIdUsuario());
            horariosJson.append("{")
                    .append("\"id\":").append(med.getIdUsuario()).append(",")
                    .append("\"nombre\":\"").append(med.getNombres()).append(" ").append(med.getApellidos())
                    .append("\",")
                    .append("\"horarios\":[");
            for (int h = 0; h < horarios.size(); h++) {
                Horario hor = horarios.get(h);
                int dia = hor.getDiaSemana();
                String diaNom = (dia >= 1 && dia <= 7) ? diasNombre[dia] : "Día " + dia;
                horariosJson.append("{")
                        .append("\"dia\":\"").append(diaNom).append("\",")
                        .append("\"inicio\":\"").append(hor.getHoraInicio()).append("\",")
                        .append("\"fin\":\"").append(hor.getHoraFin()).append("\",")
                        .append("\"max\":").append(hor.getMaxCitas())
                        .append("}");
                if (h < horarios.size() - 1)
                    horariosJson.append(",");
            }
            horariosJson.append("]}");
            if (m < medicos.size() - 1)
                horariosJson.append(",");
        }
        horariosJson.append("]");
        request.setAttribute("horariosJson", horariosJson.toString());
    }

    // ── HELPERS JSON ──────────────────────────────────────────────
    private String mapToJson(Map<String, Integer> map) {
        if (map == null || map.isEmpty())
            return "{}";
        StringBuilder sb = new StringBuilder("{");
        for (Map.Entry<String, Integer> e : map.entrySet()) {
            sb.append("\"").append(e.getKey().replace("\"", "")).append("\":").append(e.getValue()).append(",");
        }
        if (sb.charAt(sb.length() - 1) == ',')
            sb.setLength(sb.length() - 1);
        sb.append("}");
        return sb.toString();
    }

    private String toJsonArray(List<String> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            sb.append("\"").append(list.get(i)).append("\"");
            if (i < list.size() - 1)
                sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }

    // ── ENRIQUECER CITAS ──────────────────────────────────────────
    private void enriquecerCitas(List<Cita> citas) {
        for (Cita c : citas) {
            if (c.getPacienteNombre() == null || c.getPacienteNombre().isEmpty()) {
                Paciente p = pacienteDAO.buscarPorId(c.getIdPaciente());
                if (p != null) {
                    c.setPacienteNombre(p.getNombres());
                    c.setPacienteApellido(p.getApellidos());
                }
            }
            if (c.getMedicoNombre() == null || c.getMedicoNombre().isEmpty()) {
                Usuario med = usuarioDAO.buscarPorId(c.getIdUsuario());
                if (med != null) {
                    c.setMedicoNombre(med.getNombres());
                    c.setMedicoApellido(med.getApellidos());
                }
            }
        }
    }
}
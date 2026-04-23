package karen.adso.biblioteca.servlet;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import java.util.Date;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import karen.adso.biblioteca.util.Conexion;

/**
 * Responde peticiones AJAX del calendario del dashboard.
 *
 * GET /calendarioData?mes=M&anio=A → JSON con diasConVencimientos,
 * diasConPrestamos, prestamosVencidos, prestamosActivos
 *
 * GET /calendarioDia?dia=D&mes=M&anio=A → JSON con prestamos[], vencimientos[],
 * reservas[]
 */
@WebServlet(urlPatterns = {"/calendarioData", "/calendarioDia"})
public class CalendarioDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json; charset=UTF-8");
        resp.setHeader("Cache-Control", "no-cache");

        // Solo admins/bibliotecarios
        String tipoUsuario = (String) req.getSession().getAttribute("tipoUsuario");
        boolean esAdmin = "Administrativo".equals(tipoUsuario) || "Bibliotecario".equals(tipoUsuario);
        if (!esAdmin) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            resp.getWriter().write("{\"error\":\"Sin permisos\"}");
            return;
        }

        String path = req.getServletPath();

        if ("/calendarioData".equals(path)) {
            handleCalendarioData(req, resp);
        } else if ("/calendarioDia".equals(path)) {
            handleCalendarioDia(req, resp);
        } else {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write("{\"error\":\"Ruta no encontrada\"}");
        }
    }

    /* ═══════════════════════════════════════════════════════════════
       /calendarioData — datos del mes completo
    ═══════════════════════════════════════════════════════════════ */
    private void handleCalendarioData(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int mes, anio;
        try {
            mes = Integer.parseInt(req.getParameter("mes"));   // 0-based
            anio = Integer.parseInt(req.getParameter("anio"));
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Parámetros inválidos\"}");
            return;
        }

        // Primer y último día del mes
        Calendar cal = Calendar.getInstance();
        cal.set(anio, mes, 1, 0, 0, 0);
        cal.set(Calendar.MILLISECOND, 0);
        Date inicio = cal.getTime();

        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        Date fin = cal.getTime();

        Set<Integer> diasVencimientos = new TreeSet<>();
        Set<Integer> diasPrestamos = new TreeSet<>();
        int prestamosVencidos = 0;
        int prestamosActivos = 0;

        String sqlPrestamos
                = "SELECT DAY(fecha_prestamo) AS dia, "
                + "       DAY(fecha_devolucion_esperada) AS dia_venc, "
                + "       estado "
                + "FROM prestamos "
                + "WHERE (fecha_prestamo BETWEEN ? AND ?) "
                + "   OR (fecha_devolucion_esperada BETWEEN ? AND ?)";

        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sqlPrestamos)) {

            ps.setDate(1, new java.sql.Date(inicio.getTime()));
            ps.setDate(2, new java.sql.Date(fin.getTime()));
            ps.setDate(3, new java.sql.Date(inicio.getTime()));
            ps.setDate(4, new java.sql.Date(fin.getTime()));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String estado = rs.getString("estado");
                    int diaPrest = rs.getInt("dia");
                    int diaVenc = rs.getInt("dia_venc");

                    // Día de préstamo en el mes
                    if (diaPrest > 0) {
                        diasPrestamos.add(diaPrest);
                    }

                    if ("Activo".equalsIgnoreCase(estado)) {
                        prestamosActivos++;
                        // Si el día de vencimiento es en este mes
                        if (diaVenc > 0) {
                            diasPrestamos.add(diaVenc);
                        }
                    } else if ("Vencido".equalsIgnoreCase(estado) || "Atrasado".equalsIgnoreCase(estado)) {
                        prestamosVencidos++;
                        if (diaVenc > 0) {
                            diasVencimientos.add(diaVenc);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"" + escJson(e.getMessage()) + "\"}");
            return;
        }

        // Construir JSON manualmente (evita dependencia de Gson si no la tienes)
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"mes\":").append(mes).append(",");
        json.append("\"anio\":").append(anio).append(",");
        json.append("\"prestamosActivos\":").append(prestamosActivos).append(",");
        json.append("\"prestamosVencidos\":").append(prestamosVencidos).append(",");
        json.append("\"diasConVencimientos\":").append(listToJson(diasVencimientos)).append(",");
        json.append("\"diasConPrestamos\":").append(listToJson(diasPrestamos));
        json.append("}");

        resp.getWriter().write(json.toString());
    }

    /* ═══════════════════════════════════════════════════════════════
       /calendarioDia — detalle de un día específico
    ═══════════════════════════════════════════════════════════════ */
    private void handleCalendarioDia(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int dia, mes, anio;
        try {
            dia = Integer.parseInt(req.getParameter("dia"));
            mes = Integer.parseInt(req.getParameter("mes"));   // 0-based
            anio = Integer.parseInt(req.getParameter("anio"));
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Parámetros inválidos\"}");
            return;
        }

        // Rango del día
        Calendar cal = Calendar.getInstance();
        cal.set(anio, mes, dia, 0, 0, 0);
        cal.set(Calendar.MILLISECOND, 0);
        Date inicioDia = cal.getTime();
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        Date finDia = cal.getTime();

        List<Map<String, String>> prestamos = new ArrayList<>();
        List<Map<String, String>> vencimientos = new ArrayList<>();
        List<Map<String, String>> reservas = new ArrayList<>();

        // Préstamos activos cuya fecha de préstamo es hoy
        String sqlPrestHoy
                = "SELECT p.id, l.titulo, CONCAT(u.nombres,' ',u.apellidos) AS usuario, "
                + "       p.fecha_devolucion_esperada, p.estado "
                + "FROM prestamos p "
                + "JOIN libros l ON l.id = p.id_libro "
                + "JOIN usuarios u ON u.id = p.id_usuario "
                + "WHERE p.fecha_prestamo BETWEEN ? AND ? "
                + "ORDER BY p.id DESC";

        // Vencimientos del día
        String sqlVenc
                = "SELECT p.id, l.titulo, CONCAT(u.nombres,' ',u.apellidos) AS usuario, "
                + "       p.fecha_devolucion_esperada, p.estado "
                + "FROM prestamos p "
                + "JOIN libros l ON l.id = p.id_libro "
                + "JOIN usuarios u ON u.id = p.id_usuario "
                + "WHERE p.fecha_devolucion_esperada BETWEEN ? AND ? "
                + "ORDER BY p.id DESC";

        // Reservas del día (si tienes tabla reservas)
        String sqlReservas
                = "SELECT r.id, l.titulo, CONCAT(u.nombres,' ',u.apellidos) AS usuario, "
                + "       r.fecha_reserva, r.estado "
                + "FROM reservas r "
                + "JOIN libros l ON l.id = r.id_libro "
                + "JOIN usuarios u ON u.id = r.id_usuario "
                + "WHERE r.fecha_reserva BETWEEN ? AND ? "
                + "ORDER BY r.id DESC";

        SimpleDateFormat sdfCorto = new SimpleDateFormat("dd/MM/yyyy");

        try (Connection cn = Conexion.getConexion()) {

            // Préstamos iniciados hoy
            try (PreparedStatement ps = cn.prepareStatement(sqlPrestHoy)) {
                ps.setDate(1, new java.sql.Date(inicioDia.getTime()));
                ps.setDate(2, new java.sql.Date(finDia.getTime()));
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> m = new LinkedHashMap<>();
                        m.put("id", String.valueOf(rs.getInt("id")));
                        m.put("libro", rs.getString("titulo"));
                        m.put("usuario", rs.getString("usuario"));
                        m.put("titulo", rs.getString("titulo"));
                        m.put("descripcion", "Usuario: " + rs.getString("usuario"));
                        m.put("fecha", sdfCorto.format(rs.getDate("fecha_devolucion_esperada")));
                        m.put("estado", rs.getString("estado"));
                        prestamos.add(m);
                    }
                }
            }

            // Vencimientos hoy
            try (PreparedStatement ps = cn.prepareStatement(sqlVenc)) {
                ps.setDate(1, new java.sql.Date(inicioDia.getTime()));
                ps.setDate(2, new java.sql.Date(finDia.getTime()));
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> m = new LinkedHashMap<>();
                        m.put("id", String.valueOf(rs.getInt("id")));
                        m.put("libro", rs.getString("titulo"));
                        m.put("usuario", rs.getString("usuario"));
                        m.put("titulo", rs.getString("titulo"));
                        m.put("descripcion", "Usuario: " + rs.getString("usuario"));
                        m.put("fecha", sdfCorto.format(rs.getDate("fecha_devolucion_esperada")));
                        m.put("estado", rs.getString("estado"));
                        vencimientos.add(m);
                    }
                }
            }

            // Reservas (tabla puede no existir — ignorar error)
            try (PreparedStatement ps = cn.prepareStatement(sqlReservas)) {
                ps.setDate(1, new java.sql.Date(inicioDia.getTime()));
                ps.setDate(2, new java.sql.Date(finDia.getTime()));
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> m = new LinkedHashMap<>();
                        m.put("id", String.valueOf(rs.getInt("id")));
                        m.put("libro", rs.getString("titulo"));
                        m.put("usuario", rs.getString("usuario"));
                        m.put("titulo", rs.getString("titulo"));
                        m.put("descripcion", "Usuario: " + rs.getString("usuario"));
                        m.put("fecha", sdfCorto.format(rs.getDate("fecha_reserva")));
                        m.put("estado", rs.getString("estado"));
                        reservas.add(m);
                    }
                }
            } catch (SQLException ignored) {
                // La tabla reservas puede no existir en todas las instalaciones
            }

        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"" + escJson(e.getMessage()) + "\"}");
            return;
        }

        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"dia\":").append(dia).append(",");
        json.append("\"mes\":").append(mes).append(",");
        json.append("\"anio\":").append(anio).append(",");
        json.append("\"prestamos\":").append(mapsToJson(prestamos)).append(",");
        json.append("\"vencimientos\":").append(mapsToJson(vencimientos)).append(",");
        json.append("\"reservas\":").append(mapsToJson(reservas));
        json.append("}");

        resp.getWriter().write(json.toString());
    }

    /* ── Helpers JSON ── */
    private String listToJson(Collection<Integer> list) {
        StringBuilder sb = new StringBuilder("[");
        boolean first = true;
        for (int n : list) {
            if (!first) {
                sb.append(",");
            }
            sb.append(n);
            first = false;
        }
        sb.append("]");
        return sb.toString();
    }

    private String mapsToJson(List<Map<String, String>> list) {
        StringBuilder sb = new StringBuilder("[");
        boolean first = true;
        for (Map<String, String> m : list) {
            if (!first) {
                sb.append(",");
            }
            sb.append("{");
            boolean fi = true;
            for (Map.Entry<String, String> e : m.entrySet()) {
                if (!fi) {
                    sb.append(",");
                }
                sb.append("\"").append(escJson(e.getKey())).append("\":");
                sb.append("\"").append(escJson(e.getValue())).append("\"");
                fi = false;
            }
            sb.append("}");
            first = false;
        }
        sb.append("]");
        return sb.toString();
    }

    private String escJson(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}

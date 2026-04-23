package karen.adso.biblioteca.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import karen.adso.biblioteca.dao.LibroDAO;
import karen.adso.biblioteca.dao.MultaDAO;
import karen.adso.biblioteca.dao.PrestamoDAO;
import karen.adso.biblioteca.dao.UsuarioDAO;
import karen.adso.biblioteca.modelo.Usuario;
import karen.adso.biblioteca.util.Conexion;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    private final LibroDAO libroDAO = new LibroDAO();
    private final PrestamoDAO prestamoDAO = new PrestamoDAO();
    private final MultaDAO multaDAO = new MultaDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ── Verificar sesión y rol ────────────────────────────────────
        HttpSession sesion = req.getSession(false);
        Usuario usuario = (sesion == null) ? null : (Usuario) sesion.getAttribute("usuario");
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/loginServlet");
            return;
        }
        String tipo = (String) sesion.getAttribute("tipoUsuario");
        if (!"Administrativo".equals(tipo) && !"Bibliotecario".equals(tipo)) {
            resp.sendRedirect(req.getContextPath() + "/LibroServlet");
            return;
        }

        // ── KPIs básicos ────
        int totalLibros = 0;
        int librosDisp = 0;
        int librosEnPrestamo = 0;
        int totalPrestamos = 0;
        int prestamosActivos = 0;
        int totalMultas = 0;
        int multasPendientes = 0;
        double montoPendiente = 0.0;
        int totalUsuarios = 0;
        int usuariosActivos = 0;

        try {
            totalLibros = safeSize(libroDAO.listarTodos());
            librosDisp = safeSize(libroDAO.listarDisponibles());
            librosEnPrestamo = totalLibros - librosDisp;
            totalPrestamos = safeSize(prestamoDAO.listarTodos());
            prestamosActivos = safeSize(prestamoDAO.listarActivos());
            totalMultas = safeSize(multaDAO.listarTodos());
            multasPendientes = safeSize(multaDAO.listarPendientes());
            montoPendiente = safeSum(multaDAO.listarPendientes());
            totalUsuarios = safeSize(usuarioDAO.listarTodos());
            usuariosActivos = safeSize(usuarioDAO.listarActivos());
        } catch (Exception e) {
            System.err.println("Dashboard KPIs error: " + e.getMessage());
            e.printStackTrace();
        }

        // ── Top 5 libros más prestados ────────────────────────────────
        Map<String, Integer> topLibros = new LinkedHashMap<>();
        try (Connection cn = Conexion.getConexion()) {
            if (cn != null) {
                String sql = "SELECT l.titulo, COUNT(p.idPrestamo) AS total "
                        + "FROM prestamo p JOIN libro l ON p.idLibro = l.idLibro "
                        + "GROUP BY l.idLibro, l.titulo ORDER BY total DESC LIMIT 5";
                try (PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        topLibros.put(rs.getString("titulo"), rs.getInt("total"));
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Dashboard topLibros: " + e.getMessage());
        }

        // ── Préstamos por mes (COMPATIBLE CON TODAS LAS VERSIONES) ─────
        Map<String, Integer> prestamosMes = new LinkedHashMap<>();
        try (Connection cn = Conexion.getConexion()) {
            if (cn != null) {
                // Versión compatible: usar YEAR() y MONTH() en lugar de DATE_FORMAT
                String sql = "SELECT YEAR(fechaPrestamo) as anio, "
                        + "MONTH(fechaPrestamo) as mes, "
                        + "COUNT(*) AS total "
                        + "FROM prestamo "
                        + "WHERE fechaPrestamo >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) "
                        + "GROUP BY YEAR(fechaPrestamo), MONTH(fechaPrestamo) "
                        + "ORDER BY anio ASC, mes ASC";

                try (PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int anio = rs.getInt("anio");
                        int mes = rs.getInt("mes");
                        String mesStr = getNombreMes(mes) + " " + anio;
                        prestamosMes.put(mesStr, rs.getInt("total"));
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Dashboard prestamosMes: " + e.getMessage());
            e.printStackTrace();

            // Si falla, intentar versión más simple sin DATE_SUB
            try (Connection cn = Conexion.getConexion()) {
                if (cn != null) {
                    String sqlSimple = "SELECT YEAR(fechaPrestamo) as anio, "
                            + "MONTH(fechaPrestamo) as mes, "
                            + "COUNT(*) AS total FROM prestamo "
                            + "GROUP BY YEAR(fechaPrestamo), MONTH(fechaPrestamo) "
                            + "ORDER BY anio DESC, mes DESC LIMIT 6";
                    try (PreparedStatement ps = cn.prepareStatement(sqlSimple); ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            int anio = rs.getInt("anio");
                            int mes = rs.getInt("mes");
                            String mesStr = getNombreMes(mes) + " " + anio;
                            prestamosMes.put(mesStr, rs.getInt("total"));
                        }
                    }
                }
            } catch (SQLException e2) {
                System.err.println("Dashboard prestamosMes (fallback 2): " + e2.getMessage());
            }
        }

        // ── Multas pagadas en los últimos 30 días ─────────────────────
        int multasPagadasMes = 0;
        try (Connection cn = Conexion.getConexion()) {
            if (cn != null) {
                String sql = "SELECT COUNT(*) FROM multa "
                        + "WHERE estado IN ('Pagada','Pagado') "
                        + "AND fechaGeneracion >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)";
                try (PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        multasPagadasMes = rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Dashboard multasPagadasMes: " + e.getMessage());
        }

        // ── Préstamos vencidos ────────────────────────────────────────
        int prestamosVencidos = 0;
        try (Connection cn = Conexion.getConexion()) {
            if (cn != null) {
                String sql = "SELECT COUNT(*) FROM prestamo "
                        + "WHERE estado IN ('En curso','Activo') "
                        + "AND fechaDevolucion < NOW()";
                try (PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        prestamosVencidos = rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Dashboard vencidos: " + e.getMessage());
        }

        // ── Pasar atributos a la vista ────────────────────────────────
        req.setAttribute("totalLibros", totalLibros);
        req.setAttribute("librosDisp", librosDisp);
        req.setAttribute("librosEnPrestamo", librosEnPrestamo);
        req.setAttribute("totalPrestamos", totalPrestamos);
        req.setAttribute("prestamosActivos", prestamosActivos);
        req.setAttribute("prestamosVencidos", prestamosVencidos);
        req.setAttribute("totalMultas", totalMultas);
        req.setAttribute("multasPendientes", multasPendientes);
        req.setAttribute("montoPendiente", montoPendiente);
        req.setAttribute("multasPagadasMes", multasPagadasMes);
        req.setAttribute("totalUsuarios", totalUsuarios);
        req.setAttribute("usuariosActivos", usuariosActivos);
        req.setAttribute("topLibros", topLibros);
        req.setAttribute("prestamosMes", prestamosMes);

        req.getRequestDispatcher("/WEB-INF/vistas/dashboard.jsp").forward(req, resp);
    }

    // Helper para convertir número de mes a nombre
    private String getNombreMes(int mes) {
        String[] meses = {"Ene", "Feb", "Mar", "Abr", "May", "Jun",
            "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"};
        return (mes >= 1 && mes <= 12) ? meses[mes - 1] : String.valueOf(mes);
    }

    // ── Helpers para evitar NullPointerException ─────────────────────
    private int safeSize(java.util.List<?> lista) {
        return (lista == null) ? 0 : lista.size();
    }

    private double safeSum(java.util.List<?> lista) {
        if (lista == null) {
            return 0.0;
        }
        try {
            return lista.stream()
                    .filter(m -> m instanceof karen.adso.biblioteca.modelo.Multa)
                    .mapToDouble(m -> ((karen.adso.biblioteca.modelo.Multa) m).getMonto())
                    .sum();
        } catch (Exception e) {
            return 0.0;
        }
    }
}

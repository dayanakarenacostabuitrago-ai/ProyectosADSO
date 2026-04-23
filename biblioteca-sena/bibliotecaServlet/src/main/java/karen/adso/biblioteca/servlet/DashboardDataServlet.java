package karen.adso.biblioteca.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import karen.adso.biblioteca.util.Conexion;


@WebServlet("/dashboardData")
public class DashboardDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-cache");

        // ── KPIs básicos ──────────────────────────────────────────────
        int libros = 0;
        int librosDisp = 0;
        int prestamos = 0;
        int prestamosActivos = 0;
        int prestamosVenc = 0;
        int usuarios = 0;
        int usuariosActivos = 0;
        int multas = 0;
        int multasPend = 0;
        int multasPagadas = 0;
        double montoPend = 0.0;

        // ── Arrays para gráficas ──────────────────────────────────────
        StringBuilder topLibrosLabels = new StringBuilder();
        StringBuilder topLibrosData = new StringBuilder();
        StringBuilder mesesLabels = new StringBuilder();
        StringBuilder mesesData = new StringBuilder();
        StringBuilder disponLabels = new StringBuilder();
        StringBuilder disponData = new StringBuilder();

        try (Connection cn = Conexion.getConexion()) {
            if (cn != null) {

                // Total libros
                try (PreparedStatement ps = cn.prepareStatement("SELECT COUNT(*) FROM libro"); ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        libros = rs.getInt(1);
                    }
                }
                // Libros disponibles
                try (PreparedStatement ps = cn.prepareStatement("SELECT COUNT(*) FROM libro WHERE disponible = 1"); ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        librosDisp = rs.getInt(1);
                    }
                }
                // Total préstamos
                try (PreparedStatement ps = cn.prepareStatement("SELECT COUNT(*) FROM prestamo"); ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        prestamos = rs.getInt(1);
                    }
                }
                // Préstamos activos
                try (PreparedStatement ps = cn.prepareStatement("SELECT COUNT(*) FROM prestamo WHERE estado IN ('En curso','Activo')"); ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        prestamosActivos = rs.getInt(1);
                    }
                }
                // Préstamos vencidos
                try (PreparedStatement ps = cn.prepareStatement(
                        "SELECT COUNT(*) FROM prestamo WHERE estado IN ('En curso','Activo') AND fechaDevolucion < NOW()"); ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        prestamosVenc = rs.getInt(1);
                    }
                }
                // Total usuarios
                try (PreparedStatement ps = cn.prepareStatement("SELECT COUNT(*) FROM usuario"); ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        usuarios = rs.getInt(1);
                    }
                }
                // Usuarios activos
                try (PreparedStatement ps = cn.prepareStatement("SELECT COUNT(*) FROM usuario WHERE estado = 'Activo'"); ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        usuariosActivos = rs.getInt(1);
                    }
                }
                // Total multas
                try (PreparedStatement ps = cn.prepareStatement("SELECT COUNT(*) FROM multa"); ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        multas = rs.getInt(1);
                    }
                }
                // Multas pendientes + monto
                try (PreparedStatement ps = cn.prepareStatement(
                        "SELECT COUNT(*), COALESCE(SUM(monto),0) FROM multa WHERE estado IN ('Pendiente','Pendiente')"); ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        multasPend = rs.getInt(1);
                        montoPend = rs.getDouble(2);
                    }
                }
                multasPagadas = multas - multasPend;

                // ── Top 5 libros más prestados ────────────────────────
                try (PreparedStatement ps = cn.prepareStatement(
                        "SELECT l.titulo, COUNT(p.idPrestamo) AS total "
                        + "FROM prestamo p JOIN libro l ON p.idLibro = l.idLibro "
                        + "GROUP BY l.idLibro, l.titulo ORDER BY total DESC LIMIT 5"); ResultSet rs = ps.executeQuery()) {
                    boolean first = true;
                    while (rs.next()) {
                        if (!first) {
                            topLibrosLabels.append(",");
                            topLibrosData.append(",");
                        }
                        String titulo = rs.getString("titulo").replace("\"", "\\\"");
                        topLibrosLabels.append("\"").append(titulo.length() > 20 ? titulo.substring(0, 20) + "…" : titulo).append("\"");
                        topLibrosData.append(rs.getInt("total"));
                        first = false;
                    }
                } catch (Exception e) {
                    System.err.println("topLibros: " + e.getMessage());
                }

                // ── Préstamos últimos 6 meses ─────────────────────────
                try (PreparedStatement ps = cn.prepareStatement(
                        "SELECT YEAR(fechaPrestamo) as anio, MONTH(fechaPrestamo) as mes, COUNT(*) AS total "
                        + "FROM prestamo WHERE fechaPrestamo >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) "
                        + "GROUP BY YEAR(fechaPrestamo), MONTH(fechaPrestamo) ORDER BY anio ASC, mes ASC"); ResultSet rs = ps.executeQuery()) {
                    boolean first = true;
                    String[] nombresMes = {"Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"};
                    while (rs.next()) {
                        if (!first) {
                            mesesLabels.append(",");
                            mesesData.append(",");
                        }
                        int m = rs.getInt("mes");
                        mesesLabels.append("\"").append(nombresMes[m - 1]).append(" ").append(rs.getInt("anio")).append("\"");
                        mesesData.append(rs.getInt("total"));
                        first = false;
                    }
                } catch (Exception e) {
                    System.err.println("prestamosMes: " + e.getMessage());
                }

            }
        } catch (Exception e) {
            System.err.println("DashboardDataServlet error: " + e.getMessage());
        }

        // Disponibilidad para donut
        int librosEnPrestamo = libros - librosDisp;
        disponLabels.append("\"Disponibles\",\"En préstamo\"");
        disponData.append(librosDisp).append(",").append(librosEnPrestamo);

        // ── Construir JSON ────────────────────────────────────────────
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"libros\":").append(libros).append(",");
        json.append("\"librosDisp\":").append(librosDisp).append(",");
        json.append("\"librosEnPrestamo\":").append(librosEnPrestamo).append(",");
        json.append("\"prestamos\":").append(prestamos).append(",");
        json.append("\"prestamosActivos\":").append(prestamosActivos).append(",");
        json.append("\"prestamosVencidos\":").append(prestamosVenc).append(",");
        json.append("\"usuarios\":").append(usuarios).append(",");
        json.append("\"usuariosActivos\":").append(usuariosActivos).append(",");
        json.append("\"multas\":").append(multas).append(",");
        json.append("\"multasPendientes\":").append(multasPend).append(",");
        json.append("\"multasPagadas\":").append(multasPagadas).append(",");
        json.append("\"montoPendiente\":").append(montoPend).append(",");
        json.append("\"topLibrosLabels\":[").append(topLibrosLabels).append("],");
        json.append("\"topLibrosData\":[").append(topLibrosData).append("],");
        json.append("\"mesesLabels\":[").append(mesesLabels).append("],");
        json.append("\"mesesData\":[").append(mesesData).append("],");
        json.append("\"disponLabels\":[").append(disponLabels).append("],");
        json.append("\"disponData\":[").append(disponData).append("]");
        json.append("}");

        try (PrintWriter out = resp.getWriter()) {
            out.print(json.toString());
            out.flush();
        }
    }
}

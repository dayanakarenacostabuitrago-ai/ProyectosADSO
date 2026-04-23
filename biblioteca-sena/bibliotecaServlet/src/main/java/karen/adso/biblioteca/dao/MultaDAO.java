package karen.adso.biblioteca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import karen.adso.biblioteca.modelo.Multa;
import karen.adso.biblioteca.util.Conexion;

public class MultaDAO {

    private static final String SELECT_BASE
            = "SELECT m.*, l.titulo AS tituloLibro,"
            + " u.nombres AS nombreUsuario, u.apellidos AS apellidoUsuario"
            + " FROM multa m"
            + " JOIN prestamo p ON m.idPrestamo = p.idPrestamo"
            + " JOIN libro l ON p.idLibro = l.idLibro"
            + " JOIN usuario u ON p.idUsuario = u.idUsuario";

    public List<Multa> listarTodos() {
        List<Multa> lista = new ArrayList<>();
        String sql = SELECT_BASE + " ORDER BY m.fechaGeneracion DESC";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("ERROR listarTodos multas: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    public List<Multa> listarPendientes() {
        List<Multa> lista = new ArrayList<>();
        String sql = SELECT_BASE + " WHERE m.estado = 'Pendiente' ORDER BY m.fechaGeneracion ASC";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("ERROR listarPendientes: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    public Multa buscarPorId(int id) {
        String sql = SELECT_BASE + " WHERE m.idMulta = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapear(rs);
            }
        } catch (SQLException e) {
            System.err.println("ERROR buscarPorId multa: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public Multa buscarPorIdPrestamo(int idPrestamo) {
        String sql = SELECT_BASE + " WHERE m.idPrestamo = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idPrestamo);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapear(rs);
            }
        } catch (SQLException e) {
            System.err.println("ERROR buscarPorIdPrestamo: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertar(Multa m) {
        String sql = "INSERT INTO multa (idPrestamo, monto, fechaGeneracion, fechaPago, estado)"
                + " VALUES (?, ?, CURDATE(), NULL, ?)";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, m.getIdPrestamo());
            ps.setDouble(2, m.getMonto());
            // Estado siempre "Pendiente" al insertar
            ps.setString(3, "Pendiente");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR insertar multa: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean actualizar(Multa m) {
        String sql = "UPDATE multa SET monto = ?, estado = ? WHERE idMulta = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setDouble(1, m.getMonto());
            ps.setString(2, m.getEstado());
            ps.setInt(3, m.getIdMulta());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR actualizar multa: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean registrarPago(int id, String fechaPago) {
        String sql = "UPDATE multa SET fechaPago = ?, estado = 'Pagado' WHERE idMulta = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(fechaPago + " 00:00:00"));
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR registrarPago: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM multa WHERE idMulta = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR eliminar multa: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public List<Multa> listarPorUsuario(int idUsuario) {
        List<Multa> lista = new ArrayList<>();
        String sql = "SELECT m.*, p.idUsuario, l.titulo AS tituloLibro,"
                + " u.nombres AS nombreUsuario, u.apellidos AS apellidoUsuario"
                + " FROM multa m"
                + " JOIN prestamo p ON m.idPrestamo = p.idPrestamo"
                + " JOIN libro l ON p.idLibro = l.idLibro"
                + " JOIN usuario u ON p.idUsuario = u.idUsuario"
                + " WHERE p.idUsuario = ?"
                + " ORDER BY m.fechaGeneracion DESC";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("ERROR listarPorUsuario multas: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    private Multa mapear(ResultSet rs) throws SQLException {
        Multa m = new Multa();
        m.setIdMulta(rs.getInt("idMulta"));
        m.setIdPrestamo(rs.getInt("idPrestamo"));
        m.setMonto(rs.getDouble("monto"));
        m.setEstado(rs.getString("estado"));
        try {
            Timestamp fg = rs.getTimestamp("fechaGeneracion");
            if (fg != null) {
                m.setFechaGeneracion(fg);
            }
        } catch (Exception ignored) {
        }
        try {
            Timestamp fp = rs.getTimestamp("fechaPago");
            if (fp != null) {
                m.setFechaPago(fp);
            }
        } catch (Exception ignored) {
        }
        // Campos de JOIN (pueden no existir en todas las queries)
        try { m.setTituloLibro(rs.getString("tituloLibro")); } catch (Exception ignored) {}
        try { m.setNombreUsuario(rs.getString("nombreUsuario")); } catch (Exception ignored) {}
        try { m.setApellidoUsuario(rs.getString("apellidoUsuario")); } catch (Exception ignored) {}
        return m;
    }
}

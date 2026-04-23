package karen.adso.biblioteca.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import karen.adso.biblioteca.modelo.Reserva;
import karen.adso.biblioteca.util.Conexion;

public class ReservaDAO {

    private static final String SELECT_BASE
            = "SELECT r.*, l.titulo AS tituloLibro, "
            + "u.nombres AS nombreUsuario, u.apellidos AS apellidoUsuario, u.email AS emailUsuario "
            + "FROM reserva r "
            + "JOIN libro l ON r.idLibro = l.idLibro "
            + "JOIN usuario u ON r.idUsuario = u.idUsuario";

    /**
     * Lista todas las reservas ordenadas de más reciente a más antigua.
     */
    public List<Reserva> listarTodas() {
        List<Reserva> lista = new ArrayList<>();
        String sql = SELECT_BASE + " ORDER BY r.fechaReserva DESC";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("ERROR listarTodas reservas: " + e.getMessage());
        }
        return lista;
    }

    /**
     * Reservas de un usuario específico.
     */
    public List<Reserva> listarPorUsuario(int idUsuario) {
        List<Reserva> lista = new ArrayList<>();
        String sql = SELECT_BASE + " WHERE r.idUsuario = ? ORDER BY r.fechaReserva DESC";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("ERROR listarPorUsuario reservas: " + e.getMessage());
        }
        return lista;
    }

    /**
     * Reservas pendientes de un libro (para lista de espera).
     */
    public List<Reserva> listarPendientesPorLibro(int idLibro) {
        List<Reserva> lista = new ArrayList<>();
        String sql = SELECT_BASE
                + " WHERE r.idLibro = ? AND r.estado = 'Pendiente' ORDER BY r.fechaReserva ASC";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idLibro);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("ERROR listarPendientesPorLibro: " + e.getMessage());
        }
        return lista;
    }

    /**
     * Verifica si un usuario ya tiene una reserva pendiente para el mismo
     * libro.
     */
    public boolean existeReservaPendiente(int idLibro, int idUsuario) {
        String sql = "SELECT COUNT(*) FROM reserva WHERE idLibro = ? AND idUsuario = ? AND estado = 'Pendiente'";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idLibro);
            ps.setInt(2, idUsuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("ERROR existeReservaPendiente: " + e.getMessage());
        }
        return false;
    }

    /**
     * Inserta una nueva reserva. Devuelve el id generado, o -1 si falla.
     */
    public int insertar(Reserva r) {
        String sql = "INSERT INTO reserva (idLibro, idUsuario, estado) VALUES (?, ?, 'Pendiente')";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, r.getIdLibro());
            ps.setInt(2, r.getIdUsuario());
            if (ps.executeUpdate() > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR insertar reserva: " + e.getMessage());
        }
        return -1;
    }

    /**
     * Cambia el estado de una reserva (Pendiente / Lista / Cancelada).
     */
    public boolean actualizarEstado(int idReserva, String estado) {
        String sql = "UPDATE reserva SET estado = ? WHERE idReserva = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, estado);
            ps.setInt(2, idReserva);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR actualizarEstado reserva: " + e.getMessage());
        }
        return false;
    }

    /**
     * Cancela (elimina) una reserva.
     */
    public boolean cancelar(int idReserva) {
        String sql = "DELETE FROM reserva WHERE idReserva = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idReserva);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR cancelar reserva: " + e.getMessage());
        }
        return false;
    }

    /**
     * Busca una reserva por su id (con JOIN).
     */
    public Reserva buscarPorId(int idReserva) {
        String sql = SELECT_BASE + " WHERE r.idReserva = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idReserva);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapear(rs);
            }
        } catch (SQLException e) {
            System.err.println("ERROR buscarPorId reserva: " + e.getMessage());
        }
        return null;
    }

    /**
     * Devuelve los préstamos que vencen mañana. Lo usa el job de notificaciones
     * (NotificacionListener).
     */
    public List<karen.adso.biblioteca.modelo.Prestamo> prestamosPorVencer() {
        List<karen.adso.biblioteca.modelo.Prestamo> lista = new ArrayList<>();
        String sql
                = "SELECT p.*, l.titulo AS tituloLibro, "
                + "u.nombres AS nombreUsuario, u.apellidos AS apellidoUsuario, u.email AS emailUsuario "
                + "FROM prestamo p "
                + "JOIN libro l ON p.idLibro = l.idLibro "
                + "JOIN usuario u ON p.idUsuario = u.idUsuario "
                + "WHERE p.estado IN ('En curso','Activo') "
                + "AND DATE(p.fechaDevolucion) = DATE(DATE_ADD(NOW(), INTERVAL 1 DAY))";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                karen.adso.biblioteca.modelo.Prestamo p = new karen.adso.biblioteca.modelo.Prestamo();
                p.setIdPrestamo(rs.getInt("idPrestamo"));
                p.setIdLibro(rs.getInt("idLibro"));
                p.setIdUsuario(rs.getInt("idUsuario"));
                p.setTituloLibro(rs.getString("tituloLibro"));
                p.setNombreUsuario(rs.getString("nombreUsuario"));
                p.setApellidoUsuario(rs.getString("apellidoUsuario"));
                p.setFechaDevolucion(rs.getTimestamp("fechaDevolucion"));
                // Reutilizamos campo imagen para guardar el email temporalmente
                p.setImagen(rs.getString("emailUsuario"));
                lista.add(p);
            }
        } catch (SQLException e) {
            System.err.println("ERROR prestamosPorVencer: " + e.getMessage());
        }
        return lista;
    }

    // ── Mapeo privado ─────────────────────────────────────
    private Reserva mapear(ResultSet rs) throws SQLException {
        Reserva r = new Reserva();
        r.setIdReserva(rs.getInt("idReserva"));
        r.setIdLibro(rs.getInt("idLibro"));
        r.setIdUsuario(rs.getInt("idUsuario"));
        r.setFechaReserva(rs.getTimestamp("fechaReserva"));
        r.setEstado(rs.getString("estado"));
        try {
            r.setTituloLibro(rs.getString("tituloLibro"));
        } catch (Exception ignored) {
        }
        try {
            r.setNombreUsuario(rs.getString("nombreUsuario"));
        } catch (Exception ignored) {
        }
        try {
            r.setApellidoUsuario(rs.getString("apellidoUsuario"));
        } catch (Exception ignored) {
        }
        try {
            r.setEmailUsuario(rs.getString("emailUsuario"));
        } catch (Exception ignored) {
        }
        return r;
    }
}

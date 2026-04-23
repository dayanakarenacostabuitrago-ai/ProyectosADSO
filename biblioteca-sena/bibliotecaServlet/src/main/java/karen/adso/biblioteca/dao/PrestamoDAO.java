package karen.adso.biblioteca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import karen.adso.biblioteca.modelo.Prestamo;
import karen.adso.biblioteca.util.Conexion;

public class PrestamoDAO {

    private static final String SELECT_BASE
            = "SELECT p.*, l.titulo AS tituloLibro, l.isbn AS isbnLibro,"
            + " u.nombres AS nombreUsuario, u.apellidos AS apellidoUsuario"
            + " FROM prestamo p"
            + " JOIN libro l ON p.idLibro = l.idLibro"
            + " JOIN usuario u ON p.idUsuario = u.idUsuario";

    public List<Prestamo> listarTodos() {
        List<Prestamo> lista = new ArrayList<>();
        String sql = SELECT_BASE + " ORDER BY p.fechaPrestamo DESC";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("ERROR listarTodos prestamos: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    public List<Prestamo> listarActivos() {
        List<Prestamo> lista = new ArrayList<>();
        String sql = SELECT_BASE + " WHERE p.estado IN ('En curso','Activo') ORDER BY p.fechaDevolucion ASC";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("ERROR listarActivos: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    public Prestamo buscarPorId(int id) {
        String sql = SELECT_BASE + " WHERE p.idPrestamo = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapear(rs);
            }
        } catch (SQLException e) {
            System.err.println("ERROR buscarPorId prestamo: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertarPrestamo(Prestamo p) {
        String sql = "INSERT INTO prestamo"
                + " (idLibro, idUsuario, fechaPrestamo, fechaDevolucion, estado)"
                + " VALUES (?, ?, ?, ?, ?)";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, p.getIdLibro());
            ps.setInt(2, p.getIdUsuario());
            ps.setTimestamp(3, p.getFechaPrestamo() != null ? p.getFechaPrestamo() : new Timestamp(System.currentTimeMillis()));
            ps.setTimestamp(4, p.getFechaDevolucion());
            ps.setString(5, p.getEstado() != null ? p.getEstado() : "En curso");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR insertarPrestamo: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean registrarDevolucion(int id, String fechaDevolucionReal, String imagen) {
        String sql = "UPDATE prestamo SET fechaDevolucionReal = ?, estado = 'Devuelto', imagen = ? WHERE idPrestamo = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(fechaDevolucionReal + " 00:00:00"));
            ps.setString(2, imagen);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR registrarDevolucion: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean actualizarEstadoAdmin(int id, String estado) {
        String sql = "UPDATE prestamo SET estado = ? WHERE idPrestamo = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, estado);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR actualizarEstadoAdmin: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM prestamo WHERE idPrestamo = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR eliminar prestamo: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean actualizarEstado(int id, String estado) {
        String sql = "UPDATE prestamo SET estado = ? WHERE idPrestamo = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, estado);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR actualizarEstado prestamo: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public List<Prestamo> listarPorUsuario(int idUsuario) {
        List<Prestamo> lista = new ArrayList<>();
        String sql = SELECT_BASE + " WHERE p.idUsuario = ? ORDER BY p.fechaPrestamo DESC";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("ERROR listarPorUsuario: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    private Prestamo mapear(ResultSet rs) throws SQLException {
        Prestamo p = new Prestamo();
        p.setIdPrestamo(rs.getInt("idPrestamo"));
        p.setIdLibro(rs.getInt("idLibro"));
        p.setIdUsuario(rs.getInt("idUsuario"));
        p.setEstado(rs.getString("estado"));
        try {
            p.setTituloLibro(rs.getString("tituloLibro"));
        } catch (Exception ignored) {
        }
        try {
            p.setNombreUsuario(rs.getString("nombreUsuario"));
        } catch (Exception ignored) {
        }
        try {
            p.setApellidoUsuario(rs.getString("apellidoUsuario"));
        } catch (Exception ignored) {
        }
        try {
            Timestamp fp = rs.getTimestamp("fechaPrestamo");
            if (fp != null && fp.getTime() > 0) {
                p.setFechaPrestamo(fp);
            }
        } catch (Exception ignored) {
        }
        try {
            Timestamp fd = rs.getTimestamp("fechaDevolucion");
            if (fd != null && fd.getTime() > 0) {
                p.setFechaDevolucion(fd);
            }
        } catch (Exception ignored) {
        }
        try {
            Timestamp fdr = rs.getTimestamp("fechaDevolucionReal");
            if (fdr != null && fdr.getTime() > 0) {
                p.setFechaDevolucionReal(fdr);
            }
        } catch (Exception ignored) {
        }
        try {
            p.setImagen(rs.getString("imagen"));
        } catch (Exception ignored) {
        }
        return p;
    }
}

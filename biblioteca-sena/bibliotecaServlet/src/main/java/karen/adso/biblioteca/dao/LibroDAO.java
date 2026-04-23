package karen.adso.biblioteca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import karen.adso.biblioteca.modelo.Libro;
import karen.adso.biblioteca.util.Conexion;

public class LibroDAO {

    private static final String SELECT_BASE
            = " SELECT l.*, e.nombre AS editorial, c.nombre AS categoria"
            + " FROM libro l"
            + " JOIN editorial e ON l.idEditorial = e.idEditorial"
            + " JOIN categoria c ON l.idCategoria = c.idCategoria ";

    public List<Libro> listarTodos() {
        List<Libro> lista = new ArrayList<>();
        String sql = SELECT_BASE + "ORDER BY l.titulo";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("ERROR listarTodos libros: " + e.getMessage());
        }
        return lista;
    }

    public List<Libro> listarDisponibles() {
        List<Libro> lista = new ArrayList<>();
        String sql = SELECT_BASE + "WHERE l.disponible = 1 ORDER BY l.titulo";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("ERROR listarDisponibles: " + e.getMessage());
        }
        return lista;
    }

    public Libro buscarPorId(int id) {
        String sql = SELECT_BASE + "WHERE l.idLibro = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapear(rs);
            }
        } catch (SQLException e) {
            System.err.println("ERROR buscarPorId libro: " + e.getMessage());
        }
        return null;
    }

    public boolean insertar(Libro l) {
        String sql = "INSERT INTO libro (titulo, isbn, `añoPublicacion`, numPaginas, idEditorial, disponible, idCategoria, imagen)"
                + " VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, l.getTitulo());
            ps.setString(2, l.getIsbn());
            if (l.getAñoPublicacion() > 0) {
                ps.setString(3, String.valueOf(l.getAñoPublicacion()));
            } else {
                ps.setNull(3, java.sql.Types.VARCHAR);
            }
            ps.setString(4, l.getNumPaginas());
            ps.setInt(5, l.getIdEditorial());
            ps.setInt(6, l.getDisponible());
            ps.setInt(7, l.getIdCategoria());
            ps.setString(8, l.getImagen()); // puede ser null si no subio imagen
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR insertar libro: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean actualizar(Libro l) {
        String sql = "UPDATE libro SET titulo=?, isbn=?, `añoPublicacion`=?, numPaginas=?, "
                + "idEditorial=?, disponible=?, idCategoria=?, imagen=? WHERE idLibro=?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, l.getTitulo());
            ps.setString(2, l.getIsbn());
            if (l.getAñoPublicacion() > 0) {
                ps.setString(3, String.valueOf(l.getAñoPublicacion()));
            } else {
                ps.setNull(3, java.sql.Types.VARCHAR);
            }
            ps.setString(4, l.getNumPaginas());
            ps.setInt(5, l.getIdEditorial());
            ps.setInt(6, l.getDisponible());
            ps.setInt(7, l.getIdCategoria());
            ps.setString(8, l.getImagen());
            ps.setInt(9, l.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR actualizar libro: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM libro WHERE idLibro=?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR eliminar libro: " + e.getMessage());
        }
        return false;
    }

    public boolean actualizarEstado(int id, int disponible) {
        String sql = "UPDATE libro SET disponible=? WHERE idLibro=?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, disponible);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ERROR actualizarEstado libro: " + e.getMessage());
        }
        return false;
    }

    private Libro mapear(ResultSet rs) throws SQLException {
        Libro l = new Libro();
        l.setId(rs.getInt("idLibro"));
        l.setTitulo(rs.getString("titulo"));
        l.setIsbn(rs.getString("isbn"));
        l.setAñoPublicacion(rs.getInt("añoPublicacion"));
        l.setNumPaginas(rs.getString("numPaginas"));
        l.setIdEditorial(rs.getInt("idEditorial"));
        l.setIdCategoria(rs.getInt("idCategoria"));
        l.setDisponible(rs.getInt("disponible"));
        try {
            l.setImagen(rs.getString("imagen"));
        } catch (Exception ignored) {
        }
        try {
            l.setEditorialNombre(rs.getString("editorial"));
        } catch (Exception ignored) {
        }
        try {
            l.setCategoriaNombre(rs.getString("categoria"));
        } catch (Exception ignored) {
        }
        return l;
    }
}

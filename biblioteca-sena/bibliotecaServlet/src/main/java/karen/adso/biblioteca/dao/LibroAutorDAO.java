
package karen.adso.biblioteca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import karen.adso.biblioteca.modelo.LibroAutor;
import karen.adso.biblioteca.util.Conexion;


public class LibroAutorDAO {
      private static final String SELECT_BASE =
            "SELECT la.idLibroAutor, la.idLibro, la.idAutor, l.titulo AS titulo, l.añoPublicacion, a.nombres AS nombreAutor, a.apellidos AS apellidoAutor FROM libroautor la JOIN autor a ON a.idAutor = la.idAutor JOIN libro l ON l.idLibro = la.idLibro";

    public List<LibroAutor> listarTodos() {
        List<LibroAutor> lista = new ArrayList<>();
        
        String sql = SELECT_BASE + "ORDER BY a.nombre";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<LibroAutor> listarDisponibles() {
        List<LibroAutor> lista = new ArrayList<>();
        String sql = SELECT_BASE + "WHERE l.disponible = 1 ORDER BY l.titulo";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public LibroAutor buscarPorId(int id) {
        String sql = SELECT_BASE + "WHERE la.idLibroAutor = ?";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapear(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertar(LibroAutor la) {
        String sql = "INSERT INTO libroautor (idLibro, idAutor) VALUES (?, ?)";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, la.getIdLibro());
            ps.setInt(2, la.getIdAutor());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean actualizar(LibroAutor la) {
        String sql = "UPDATE libroautor SET idLibro=?, idAutor=? WHERE idLibroAutor=?";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, la.getIdLibro());
            ps.setInt(2, la.getIdAutor());
            ps.setInt(3, la.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM libroautor WHERE idLibroAutor=?";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private LibroAutor mapear(ResultSet rs) throws SQLException {
        LibroAutor la = new LibroAutor();
        la.setId(rs.getInt("idLibroAutor"));
        la.setIdAutor(rs.getInt("idAutor"));
        la.setIdLibro(rs.getInt("idLibro"));
       
        return la;
    }
}

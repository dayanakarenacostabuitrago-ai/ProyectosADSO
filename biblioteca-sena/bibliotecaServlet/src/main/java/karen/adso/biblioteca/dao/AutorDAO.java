
package karen.adso.biblioteca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import karen.adso.biblioteca.modelo.Autor;
import karen.adso.biblioteca.util.Conexion;


public class AutorDAO {
    private static final String SELECT_BASE = "SELECT * FROM autor ";

    public List<Autor> listarTodos() {
        List<Autor> lista = new ArrayList<>();
        String sql = "SELECT * FROM autor ORDER BY apellidos, nombres";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Autor buscarPorId(int id) {
        String sql = SELECT_BASE + " WHERE idAutor = ?";
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

    public boolean insertar(Autor A) {
        String sql = "INSERT INTO autor (nombres, apellidos, nacionalidad, fechaNacimiento)"
                   + " VALUES (?, ?, ?, ?)";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, A.getNombre());
            ps.setString(2, A.getApellido());
            ps.setString(3, A.getNacionalidad());
            ps.setDate(4, A.getFechaNacimiento());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean actualizar(Autor A) {
        String sql = "UPDATE autor SET nombres=?, apellidos=?, nacionalidad=?, fechaNacimiento=? WHERE idAutor=?";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, A.getNombre());
            ps.setString(2, A.getApellido());
            ps.setString(3, A.getNacionalidad());
            ps.setDate(4, A.getFechaNacimiento());
            ps.setInt(5, A.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM autor WHERE idAutor=?";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Autor mapear(ResultSet rs) throws SQLException {
        Autor A = new Autor();
        A.setId(rs.getInt("idAutor"));
        A.setNombre(rs.getString("nombres"));
        A.setApellido(rs.getString("apellidos"));
        A.setNacionalidad(rs.getString("nacionalidad"));
        A.setFechaNacimiento(rs.getDate("fechaNacimiento"));
        return A;
    }
}


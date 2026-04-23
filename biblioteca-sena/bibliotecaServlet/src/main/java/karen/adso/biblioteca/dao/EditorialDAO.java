
package karen.adso.biblioteca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import karen.adso.biblioteca.modelo.Editorial;
import karen.adso.biblioteca.util.Conexion;


public class EditorialDAO {
    public List<Editorial> listarTodos() {
        List<Editorial> lista = new ArrayList<>();
        String sql = "SELECT * FROM editorial ORDER BY nombre";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Editorial buscarPorId(int id) {
        String sql = "SELECT * FROM editorial WHERE idEditorial = ?";
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

    public boolean insertar(Editorial e) {
        String sql = "INSERT INTO editorial (nombre, pais,sitioWeb) VALUES (?, ? , ?)";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, e.getNombre());
            ps.setString(2, e.getPais());
            ps.setString(3, e.getSitioWeb());
            return ps.executeUpdate() > 0;
        } catch (SQLException se) {
            se.printStackTrace();
        }
        return false;
    }
    
    public boolean actualizar(Editorial e) {
        String sql = "UPDATE editorial SET nombre=?, pais=? , sitioWeb=? WHERE idEditorial=?";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, e.getNombre());
            ps.setString(2, e.getPais());
            ps.setString(3, e.getSitioWeb());
            ps.setInt(4, e.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException se) {
            se.printStackTrace();
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM editorial WHERE idEditorial=?";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Editorial mapear(ResultSet rs) throws SQLException {
        Editorial e = new Editorial();
        e.setId(rs.getInt("idEditorial"));
        e.setNombre(rs.getString("nombre"));
        e.setPais(rs.getString("pais"));
        e.setSitioWeb(rs.getString("sitioWeb"));

        return e;
    }
}

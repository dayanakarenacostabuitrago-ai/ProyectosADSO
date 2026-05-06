package co.sena.cimm.adso.saludboyaca.dao;

import co.sena.cimm.adso.saludboyaca.dto.Especialidad;
import co.sena.cimm.adso.saludboyaca.model.Conexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EspecialidadDAO {

    // ✅ INSERTAR
    public void insertar(Especialidad e) {
        String sql = "INSERT INTO especialidades (nombre, descripcion) VALUES (?,?)";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, e.getNombre());
            ps.setString(2, e.getDescripcion());
            ps.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    // ✅ ELIMINAR
    public void eliminar(int id) {
        String sql = "DELETE FROM especialidades WHERE \"idEspecialidad\"=?";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    // ✅ LISTAR TODAS
    public List<Especialidad> listar() {
        List<Especialidad> lista = new ArrayList<>();
        String sql = "SELECT * FROM especialidades";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return lista;
    }

    // ✅ BUSCAR POR ID
    public Especialidad buscarPorId(int id) {
        String sql = "SELECT * FROM especialidades WHERE \"idEspecialidad\"=?";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapear(rs);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // 🔧 MAPEAR
    private Especialidad mapear(ResultSet rs) throws SQLException {
        Especialidad e = new Especialidad();
        e.setIdEspecialidad(rs.getInt("idEspecialidad"));
        e.setNombre(rs.getString("nombre"));
        e.setDescripcion(rs.getString("descripcion"));
        return e;
    }
}
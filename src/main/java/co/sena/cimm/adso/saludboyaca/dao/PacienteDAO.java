package co.sena.cimm.adso.saludboyaca.dao;

import co.sena.cimm.adso.saludboyaca.dto.Paciente;
import co.sena.cimm.adso.saludboyaca.model.Conexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PacienteDAO {

    // ✅ INSERTAR
    public void insertar(Paciente p) {
        String sql = "INSERT INTO pacientes (nombres, apellidos, documento, \"fechaNacimiento\", telefono, email, eps, \"veredaBarrio\") VALUES (?,?,?,?,?,?,?,?)";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getNombres());
            ps.setString(2, p.getApellidos());
            ps.setString(3, p.getDocumento());
            ps.setDate(4, new java.sql.Date(p.getFechaNacimiento().getTime()));
            ps.setString(5, p.getTelefono());
            ps.setString(6, p.getEmail());
            ps.setString(7, p.getEps());
            ps.setString(8, p.getVeredaBarrio());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ ACTUALIZAR
    public void actualizar(Paciente p) {
        String sql = "UPDATE pacientes SET nombres=?, apellidos=?, documento=?, \"fechaNacimiento\"=?, telefono=?, email=?, eps=?, \"veredaBarrio\"=? WHERE \"idPaciente\"=?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getNombres());
            ps.setString(2, p.getApellidos());
            ps.setString(3, p.getDocumento());
            ps.setDate(4, new java.sql.Date(p.getFechaNacimiento().getTime()));
            ps.setString(5, p.getTelefono());
            ps.setString(6, p.getEmail());
            ps.setString(7, p.getEps());
            ps.setString(8, p.getVeredaBarrio());
            ps.setInt(9, p.getIdPaciente());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ ELIMINAR
    public void eliminar(int id) {
        String sql = "DELETE FROM pacientes WHERE \"idPaciente\"=?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ LISTAR
    public List<Paciente> listar() {
        List<Paciente> lista = new ArrayList<>();
        String sql = "SELECT * FROM pacientes";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ✅ BUSCAR POR ID
    public Paciente buscarPorId(int id) {
        String sql = "SELECT * FROM pacientes WHERE \"idPaciente\"=?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapear(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ BUSCAR POR DOCUMENTO
    public Paciente buscarPorDocumento(String documento) {
        String sql = "SELECT * FROM pacientes WHERE documento=?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, documento);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapear(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ TOTAL PACIENTES
    public int totalPacientes() {
        String sql = "SELECT COUNT(*) FROM pacientes";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 🔧 MAPEAR
    private Paciente mapear(ResultSet rs) throws SQLException {
        Paciente p = new Paciente();
        p.setIdPaciente(rs.getInt("idPaciente"));
        p.setNombres(rs.getString("nombres"));
        p.setApellidos(rs.getString("apellidos"));
        p.setDocumento(rs.getString("documento"));
        p.setFechaNacimiento(rs.getDate("fechaNacimiento"));
        p.setTelefono(rs.getString("telefono"));
        p.setEmail(rs.getString("email"));
        p.setEps(rs.getString("eps"));
        p.setVeredaBarrio(rs.getString("veredaBarrio"));
        return p;
    }
}
package co.sena.cimm.adso.registraduria.dao;

import co.sena.cimm.adso.registraduria.config.ConexionDB;
import co.sena.cimm.adso.registraduria.model.Ciudadano;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CiudadanoDAOImpl implements CiudadanoDAO {

    @Override
    public List<Ciudadano> listarTodos() throws Exception {
        String sql = "SELECT c.*, m.numeroMesa FROM ciudadanos c " +
                "LEFT JOIN mesasVotacion m ON c.idMesasVotacion = m.idMesasVotacion " +
                "ORDER BY c.apellidos, c.nombres";

        List<Ciudadano> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapear(rs));
            }
        }
        return lista;
    }

    @Override
    public Ciudadano buscarPorId(int id) throws Exception {
        String sql = "SELECT c.*, m.numeroMesa FROM ciudadanos c " +
                "LEFT JOIN mesasVotacion m ON c.idMesasVotacion = m.idMesasVotacion " +
                "WHERE c.idCiudadanos = ?";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        }
        return null;
    }

    @Override
    public Ciudadano buscarPorDocumento(String numeroDocumento) throws Exception {
        String sql = "SELECT c.*, m.numeroMesa FROM ciudadanos c " +
                "LEFT JOIN mesasVotacion m ON c.idMesasVotacion = m.idMesasVotacion " +
                "WHERE c.numeroDocumento = ?";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, numeroDocumento);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        }
        return null;
    }

    @Override
    public List<Ciudadano> buscarPorNombre(String nombre) throws Exception {
        String sql = "SELECT c.*, m.numeroMesa FROM ciudadanos c " +
                "LEFT JOIN mesasVotacion m ON c.idMesasVotacion = m.idMesasVotacion " +
                "WHERE c.nombres LIKE ? OR c.apellidos LIKE ? " +
                "ORDER BY c.apellidos, c.nombres";

        List<Ciudadano> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            String patron = "%" + nombre + "%";
            ps.setString(1, patron);
            ps.setString(2, patron);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }
        return lista;
    }

    @Override
    public boolean insertar(Ciudadano c) throws Exception {
        String sql = "INSERT INTO ciudadanos (numeroDocumento, nombres, apellidos, " +
                "fechaNacimiento, veredaBarrio, telefono, correo, idMesasVotacion, fechaRegistro) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, c.getNumeroDocumento());
            ps.setString(2, c.getNombres());
            ps.setString(3, c.getApellidos());
            ps.setDate(4, Date.valueOf(c.getFechaNacimiento()));
            ps.setString(5, c.getVeredaBarrio());
            ps.setString(6, c.getTelefono());
            ps.setString(7, c.getCorreo());

            if (c.getIdMesasVotacion() != null) {
                ps.setInt(8, c.getIdMesasVotacion());
            } else {
                ps.setNull(8, Types.INTEGER);
            }

            ps.setTimestamp(9, Timestamp.valueOf(LocalDateTime.now()));

            int filas = ps.executeUpdate();

            if (filas > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        c.setIdCiudadanos(rs.getInt(1));
                    }
                }
            }

            return filas > 0;
        }
    }

    @Override
    public boolean actualizar(Ciudadano c) throws Exception {
        String sql = "UPDATE ciudadanos SET numeroDocumento = ?, nombres = ?, apellidos = ?, " +
                "fechaNacimiento = ?, veredaBarrio = ?, telefono = ?, correo = ?, " +
                "idMesasVotacion = ? WHERE idCiudadanos = ?";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, c.getNumeroDocumento());
            ps.setString(2, c.getNombres());
            ps.setString(3, c.getApellidos());
            ps.setDate(4, Date.valueOf(c.getFechaNacimiento()));
            ps.setString(5, c.getVeredaBarrio());
            ps.setString(6, c.getTelefono());
            ps.setString(7, c.getCorreo());

            if (c.getIdMesasVotacion() != null) {
                ps.setInt(8, c.getIdMesasVotacion());
            } else {
                ps.setNull(8, Types.INTEGER);
            }

            ps.setInt(9, c.getIdCiudadanos());

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean eliminar(int id) throws Exception {
        String sql = "DELETE FROM ciudadanos WHERE idCiudadanos = ?";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean existeDocumento(String numeroDocumento) throws Exception {
        String sql = "SELECT COUNT(*) FROM ciudadanos WHERE numeroDocumento = ?";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, numeroDocumento);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    @Override
    public List<Ciudadano> listarConMesaAsignada() throws Exception {
        String sql = "SELECT c.*, m.numeroMesa FROM ciudadanos c " +
                "INNER JOIN mesasVotacion m ON c.idMesasVotacion = m.idMesasVotacion " +
                "ORDER BY c.apellidos, c.nombres";

        List<Ciudadano> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapear(rs));
            }
        }
        return lista;
    }

    private Ciudadano mapear(ResultSet rs) throws SQLException {
        Ciudadano c = new Ciudadano();

        c.setIdCiudadanos(rs.getInt("idCiudadanos"));
        c.setNumeroDocumento(rs.getString("numeroDocumento"));
        c.setNombres(rs.getString("nombres"));
        c.setApellidos(rs.getString("apellidos"));

        Date fechaNac = rs.getDate("fechaNacimiento");
        if (fechaNac != null) {
            c.setFechaNacimiento(fechaNac.toLocalDate());
        }

        c.setVeredaBarrio(rs.getString("veredaBarrio"));
        c.setTelefono(rs.getString("telefono"));
        c.setCorreo(rs.getString("correo"));

        int idMesa = rs.getInt("idMesasVotacion");
        c.setIdMesasVotacion(rs.wasNull() ? null : idMesa);

        Timestamp fechaReg = rs.getTimestamp("fechaRegistro");
        if (fechaReg != null) {
            c.setFechaRegistro(fechaReg.toLocalDateTime());
        }

        int numeroMesa = rs.getInt("numeroMesa");
        c.setNumeroMesa(rs.wasNull() ? null : numeroMesa);

        return c;
    }

    @Override
    public boolean tieneDocumentos(int id) throws Exception {
        String sql = "SELECT COUNT(*) FROM documentosExpedidos WHERE idCiudadanos = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        }
        return false;
    }
}
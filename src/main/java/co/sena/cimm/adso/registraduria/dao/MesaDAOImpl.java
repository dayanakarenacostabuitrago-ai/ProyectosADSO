package co.sena.cimm.adso.registraduria.dao;

import co.sena.cimm.adso.registraduria.config.ConexionDB;
import co.sena.cimm.adso.registraduria.model.Mesa;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MesaDAOImpl implements MesaDAO {

    private static final String BASE_SQL = "SELECT m.idMesasVotacion, m.idZonaVotacion, m.numeroMesa, m.capacidad, " +
            "z.nombreZona, " +
            "(SELECT COUNT(*) FROM ciudadanos c WHERE c.idMesasVotacion = m.idMesasVotacion) AS totalCiudadanos " +
            "FROM mesasVotacion m " +
            "LEFT JOIN zonasVotacion z ON m.idZonaVotacion = z.idZonaVotacion ";

    @Override
    public List<Mesa> listarTodas() throws Exception {
        String sql = BASE_SQL + "ORDER BY z.nombreZona, m.numeroMesa";
        List<Mesa> lista = new ArrayList<>();
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                lista.add(mapear(rs));
        }
        return lista;
    }

    @Override
    public List<Mesa> buscar(String termino) throws Exception {
        String sql = BASE_SQL +
                "WHERE z.nombreZona LIKE ? OR CAST(m.numeroMesa AS NVARCHAR) LIKE ? " +
                "ORDER BY z.nombreZona, m.numeroMesa";
        List<Mesa> lista = new ArrayList<>();
        String t = "%" + termino + "%";
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, t);
            ps.setString(2, t);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapear(rs));
            }
        }
        return lista;
    }

    @Override
    public Mesa buscarPorId(int id) throws Exception {
        String sql = BASE_SQL + "WHERE m.idMesasVotacion = ?";
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapear(rs);
            }
        }
        return null;
    }

    @Override
    public void crear(Mesa m) throws Exception {
        String sql = "INSERT INTO mesasVotacion (idZonaVotacion, numeroMesa, capacidad) VALUES (?, ?, ?)";
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, m.getIdZonaVotacion());
            ps.setInt(2, m.getNumeroMesa());
            ps.setInt(3, m.getCapacidad() != null ? m.getCapacidad() : 200);
            ps.executeUpdate();
        }
    }

    @Override
    public void actualizar(Mesa m) throws Exception {
        String sql = "UPDATE mesasVotacion SET idZonaVotacion=?, numeroMesa=?, capacidad=? WHERE idMesasVotacion=?";
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, m.getIdZonaVotacion());
            ps.setInt(2, m.getNumeroMesa());
            ps.setInt(3, m.getCapacidad() != null ? m.getCapacidad() : 200);
            ps.setInt(4, m.getIdMesasVotacion());
            ps.executeUpdate();
        }
    }

    @Override
    public void eliminar(int id) throws Exception {
        String sql = "DELETE FROM mesasVotacion WHERE idMesasVotacion = ?";
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    @Override
    public boolean tieneCiudadanos(int id) throws Exception {
        String sql = "SELECT COUNT(*) FROM ciudadanos WHERE idMesasVotacion = ?";
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    @Override
    public List<Mesa> buscarPorZona(int idZona) throws Exception {
        String sql = BASE_SQL +
                "WHERE m.idZonaVotacion = ? " +
                "ORDER BY m.numeroMesa";
        List<Mesa> lista = new ArrayList<>();
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idZona);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapear(rs));
            }
        }
        return lista;
    }

    private Mesa mapear(ResultSet rs) throws SQLException {
        Mesa m = new Mesa();
        m.setIdMesasVotacion(rs.getInt("idMesasVotacion"));
        m.setIdZonaVotacion(rs.getInt("idZonaVotacion"));
        m.setNumeroMesa(rs.getInt("numeroMesa"));
        m.setCapacidad(rs.getInt("capacidad"));
        m.setNombreZona(rs.getString("nombreZona"));
        m.setTotalCiudadanos(rs.getInt("totalCiudadanos"));
        return m;
    }
}
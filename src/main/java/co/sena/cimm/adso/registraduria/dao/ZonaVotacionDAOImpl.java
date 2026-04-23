package co.sena.cimm.adso.registraduria.dao;

import co.sena.cimm.adso.registraduria.config.ConexionDB;
import co.sena.cimm.adso.registraduria.model.ZonaVotacion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ZonaVotacionDAOImpl implements ZonaVotacionDAO {

    private static final String BASE_SQL = "SELECT z.idZonaVotacion, z.nombreZona, z.puestoVotacion, z.direccion, z.idCiudades, "
            +
            "ci.nombre AS ciudadNombre, " +
            "(SELECT COUNT(*) FROM mesasVotacion m WHERE m.idZonaVotacion = z.idZonaVotacion) AS totalMesas " +
            "FROM zonasVotacion z " +
            "LEFT JOIN ciudades ci ON z.idCiudades = ci.idCiudades ";

    @Override
    public List<ZonaVotacion> listarTodas() throws Exception {
        String sql = BASE_SQL + "ORDER BY z.nombreZona";
        List<ZonaVotacion> lista = new ArrayList<>();
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                lista.add(mapear(rs));
        }
        return lista;
    }

    @Override
    public List<ZonaVotacion> buscar(String termino) throws Exception {
        String sql = BASE_SQL +
                "WHERE z.nombreZona LIKE ? OR z.puestoVotacion LIKE ? OR z.direccion LIKE ? " +
                "ORDER BY z.nombreZona";
        List<ZonaVotacion> lista = new ArrayList<>();
        String t = "%" + termino + "%";
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, t);
            ps.setString(2, t);
            ps.setString(3, t);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapear(rs));
            }
        }
        return lista;
    }

    @Override
    public ZonaVotacion buscarPorId(int id) throws Exception {
        String sql = BASE_SQL + "WHERE z.idZonaVotacion = ?";
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
    public void crear(ZonaVotacion zona) throws Exception {
        String sql = "INSERT INTO zonasVotacion (nombreZona, puestoVotacion, direccion, idCiudades) VALUES (?, ?, ?, ?)";
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, zona.getNombreZona());
            ps.setString(2, zona.getPuestoVotacion());
            ps.setString(3, zona.getDireccion());
            if (zona.getIdCiudades() != null)
                ps.setInt(4, zona.getIdCiudades());
            else
                ps.setNull(4, Types.INTEGER);
            ps.executeUpdate();
        }
    }

    @Override
    public void actualizar(ZonaVotacion zona) throws Exception {
        String sql = "UPDATE zonasVotacion SET nombreZona=?, puestoVotacion=?, direccion=?, idCiudades=? WHERE idZonaVotacion=?";
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, zona.getNombreZona());
            ps.setString(2, zona.getPuestoVotacion());
            ps.setString(3, zona.getDireccion());
            if (zona.getIdCiudades() != null)
                ps.setInt(4, zona.getIdCiudades());
            else
                ps.setNull(4, Types.INTEGER);
            ps.setInt(5, zona.getIdZonaVotacion());
            ps.executeUpdate();
        }
    }

    @Override
    public void eliminar(int id) throws Exception {
        String sql = "DELETE FROM zonasVotacion WHERE idZonaVotacion = ?";
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    @Override
    public boolean tieneMesas(int id) throws Exception {
        String sql = "SELECT COUNT(*) FROM mesasVotacion WHERE idZonaVotacion = ?";
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
    public List<ZonaVotacion> buscarPorCiudad(int idCiudad) throws Exception {
        String sql = BASE_SQL +
                "WHERE z.idCiudades = ? " +
                "ORDER BY z.nombreZona";
        List<ZonaVotacion> lista = new ArrayList<>();
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCiudad);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapear(rs));
            }
        }
        return lista;
    }

    @Override
    public List<Object[]> listarCiudades() throws Exception {
        String sql = "SELECT idCiudades, nombre FROM ciudades ORDER BY nombre";
        List<Object[]> lista = new ArrayList<>();
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new Object[] { rs.getInt(1), rs.getString(2) });
            }
        }
        return lista;
    }

    private ZonaVotacion mapear(ResultSet rs) throws SQLException {
        ZonaVotacion z = new ZonaVotacion();
        z.setIdZonaVotacion(rs.getInt("idZonaVotacion"));
        z.setNombreZona(rs.getString("nombreZona"));
        z.setPuestoVotacion(rs.getString("puestoVotacion"));
        z.setDireccion(rs.getString("direccion"));
        int idCiud = rs.getInt("idCiudades");
        z.setIdCiudades(rs.wasNull() ? null : idCiud);
        z.setCiudadNombre(rs.getString("ciudadNombre"));
        z.setTotalMesas(rs.getInt("totalMesas"));
        return z;
    }
}
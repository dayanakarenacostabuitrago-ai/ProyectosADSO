package co.sena.cimm.adso.saludboyaca.dao;

import co.sena.cimm.adso.saludboyaca.dto.Cita;
import co.sena.cimm.adso.saludboyaca.model.Conexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CitaDAO {

    // ✅ INSERTAR
    public void insertar(Cita c) {

        String sql = "INSERT INTO citas (\"idPaciente\", \"idUsuario\", \"idEspecialidad\", \"fechaCita\", \"horaCita\", motivo, estado, observaciones, \"fechaRegistro\", \"idRegistrador\") VALUES (?,?,?,?,?,?,?,?,?,?)";

        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, c.getIdPaciente());
            ps.setInt(2, c.getIdUsuario());
            ps.setInt(3, c.getIdEspecialidad());
            ps.setDate(4, new java.sql.Date(c.getFechaCita().getTime()));
            ps.setTime(5, Time.valueOf(c.getHoraCita()));
            ps.setString(6, c.getMotivo());
            ps.setString(7, c.getEstado());
            ps.setString(8, c.getObservaciones());
            ps.setTimestamp(9, Timestamp.valueOf(c.getFechaRegistro()));
            ps.setInt(10, c.getIdRegistrador());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ LISTAR TODAS
    public List<Cita> listarTodas() {

        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT * FROM citas ORDER BY \"fechaCita\" DESC, \"horaCita\" ASC";

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

    // ✅ CAMBIAR ESTADO
    public void cambiarEstado(int idCita, String estado) {

        String sql = "UPDATE citas SET estado=? WHERE \"idCita\"=?";

        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, estado);
            ps.setInt(2, idCita);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ ELIMINAR
    public void eliminar(int idCita) {

        String sql = "DELETE FROM citas WHERE \"idCita\"=?";

        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCita);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ BUSCAR POR ID
    public Cita buscarPorId(int idCita) {

        String sql = "SELECT * FROM citas WHERE \"idCita\"=?";

        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCita);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapear(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Cita> consultarPorDocumento(String documento) {

        List<Cita> lista = new ArrayList<>();

        String sql = "SELECT c.* FROM citas c " +
                "INNER JOIN pacientes p ON c.\"idPaciente\" = p.\"idPaciente\" " +
                "WHERE p.documento = ?";

        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, documento);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                lista.add(mapear(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    // ✅ LISTAR POR MÉDICO
    public List<Cita> listarPorMedico(int idUsuario) {

        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT * FROM citas WHERE \"idUsuario\"=?";

        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                lista.add(mapear(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    // ✅ LISTAR POR PACIENTE
    public List<Cita> listarPorPaciente(int idPaciente) {

        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT * FROM citas WHERE \"idPaciente\"=?";

        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idPaciente);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                lista.add(mapear(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    // ✅ LISTAR POR ESTADO
    public List<Cita> listarPorEstado(String estado) {

        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT * FROM citas WHERE estado=?";

        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, estado);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                lista.add(mapear(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    // ✅ CITAS PARA HOY
    public List<Cita> citasHoy() {

        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT * FROM citas WHERE \"fechaCita\" = CURRENT_DATE";

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

    // ✅ CITAS PENDIENTES
    public List<Cita> citasPendientes() {

        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT * FROM citas WHERE estado = 'PROGRAMADA'";

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

    // ✅ CITAS POR MES
    public List<Cita> citasPorMes(int mes, int anio) {

        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT * FROM citas WHERE EXTRACT(MONTH FROM \"fechaCita\")=? AND EXTRACT(YEAR FROM \"fechaCita\")=?";

        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, mes);
            ps.setInt(2, anio);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                lista.add(mapear(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    // ✅ ACTUALIZAR
    public void actualizar(Cita c) {

        String sql = "UPDATE citas SET \"idPaciente\"=?, \"idUsuario\"=?, \"idEspecialidad\"=?, \"fechaCita\"=?, \"horaCita\"=?, motivo=?, observaciones=? WHERE \"idCita\"=?";

        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, c.getIdPaciente());
            ps.setInt(2, c.getIdUsuario());
            ps.setInt(3, c.getIdEspecialidad());
            ps.setDate(4, new java.sql.Date(c.getFechaCita().getTime()));
            ps.setTime(5, Time.valueOf(c.getHoraCita()));
            ps.setString(6, c.getMotivo());
            ps.setString(7, c.getObservaciones());
            ps.setInt(8, c.getIdCita());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 📊 ESTADÍSTICAS: contar por estado
    public java.util.Map<String, Integer> contarPorEstado() {
        java.util.Map<String, Integer> mapa = new java.util.LinkedHashMap<>();
        String sql = "SELECT estado, COUNT(*) as total FROM citas GROUP BY estado";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                mapa.put(rs.getString("estado"), rs.getInt("total"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return mapa;
    }

    // 📊 ESTADÍSTICAS: citas por especialidad
    public java.util.Map<String, Integer> citasPorEspecialidad() {
        java.util.Map<String, Integer> mapa = new java.util.LinkedHashMap<>();
        String sql = "SELECT e.nombre, COUNT(c.\"idCita\") as total FROM citas c " +
                     "INNER JOIN especialidades e ON c.\"idEspecialidad\" = e.\"idEspecialidad\" " +
                     "GROUP BY e.nombre ORDER BY total DESC";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                mapa.put(rs.getString("nombre"), rs.getInt("total"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return mapa;
    }

    // 📊 ESTADÍSTICAS: total citas
    public int totalCitas() {
        String sql = "SELECT COUNT(*) FROM citas";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 🔧 MAPEAR
    private Cita mapear(ResultSet rs) throws SQLException {

        Cita c = new Cita();

        c.setIdCita(rs.getInt("idCita"));
        c.setIdPaciente(rs.getInt("idPaciente"));
        c.setIdUsuario(rs.getInt("idUsuario"));
        c.setIdEspecialidad(rs.getInt("idEspecialidad"));
        c.setFechaCita(rs.getDate("fechaCita"));
        c.setHoraCita(rs.getTime("horaCita").toLocalTime());
        c.setMotivo(rs.getString("motivo"));
        c.setEstado(rs.getString("estado"));
        c.setObservaciones(rs.getString("observaciones"));
        c.setFechaRegistro(rs.getTimestamp("fechaRegistro").toLocalDateTime());
        c.setIdRegistrador(rs.getInt("idRegistrador"));

        return c;
    }
}
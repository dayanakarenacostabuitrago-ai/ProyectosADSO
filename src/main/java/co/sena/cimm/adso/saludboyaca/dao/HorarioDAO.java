package co.sena.cimm.adso.saludboyaca.dao;

import co.sena.cimm.adso.saludboyaca.dto.Horario;
import co.sena.cimm.adso.saludboyaca.model.Conexion;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class HorarioDAO {

    // ✅ INSERTAR
    public void insertar(Horario h) {
        String sql = "INSERT INTO horarios (\"idUsuario\", \"diaSemana\", \"horaInicio\", \"horaFin\", \"maxCitas\") VALUES (?,?,?,?,?)";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, h.getIdUsuario());
            ps.setInt(2, h.getDiaSemana());
            ps.setTime(3, Time.valueOf(h.getHoraInicio()));
            ps.setTime(4, Time.valueOf(h.getHoraFin()));
            ps.setInt(5, h.getMaxCitas());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ ACTUALIZAR
    public void actualizar(Horario h) {
        String sql = "UPDATE horarios SET \"idUsuario\"=?, \"diaSemana\"=?, \"horaInicio\"=?, \"horaFin\"=?, \"maxCitas\"=? WHERE \"idHorario\"=?";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, h.getIdUsuario());
            ps.setInt(2, h.getDiaSemana());
            ps.setTime(3, Time.valueOf(h.getHoraInicio()));
            ps.setTime(4, Time.valueOf(h.getHoraFin()));
            ps.setInt(5, h.getMaxCitas());
            ps.setInt(6, h.getIdHorario());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ ELIMINAR
    public void eliminar(int id) {
        String sql = "DELETE FROM horarios WHERE \"idHorario\"=?";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ BUSCAR POR ID
    public Horario buscarPorId(int id) {
        String sql = "SELECT * FROM horarios WHERE \"idHorario\"=?";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapear(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ LISTAR POR MÉDICO
    public List<Horario> listarPorMedico(int idUsuario) {
        List<Horario> lista = new ArrayList<>();
        String sql = "SELECT * FROM horarios WHERE \"idUsuario\" = ? ORDER BY \"diaSemana\", \"horaInicio\"";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                lista.add(mapear(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ✅ LISTAR TODOS
    public List<Horario> listarTodos() {
        List<Horario> lista = new ArrayList<>();
        String sql = "SELECT * FROM horarios ORDER BY \"idUsuario\", \"diaSemana\", \"horaInicio\"";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                lista.add(mapear(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ✅ HORAS DISPONIBLES
    public List<LocalTime> horasDisponibles(int idUsuario, LocalDate fecha) {

        List<LocalTime> horas = new ArrayList<>();
        int diaSemana = fecha.getDayOfWeek().getValue();

        String sqlHorario = "SELECT \"horaInicio\", \"horaFin\", \"maxCitas\" "
                + "FROM horarios "
                + "WHERE \"idUsuario\" = ? AND \"diaSemana\" = ?";

        String sqlOcupadas = "SELECT \"horaCita\", COUNT(*) as total "
                + "FROM citas "
                + "WHERE \"idUsuario\" = ? AND \"fechaCita\" = ? "
                + "AND estado IN ('PROGRAMADA','CONFIRMADA') "
                + "GROUP BY \"horaCita\"";

        try (Connection con = Conexion.getConnection()) {

            LocalTime horaInicio = null;
            LocalTime horaFin = null;
            int maxCitas = 1;

            try (PreparedStatement ps = con.prepareStatement(sqlHorario)) {
                ps.setInt(1, idUsuario);
                ps.setInt(2, diaSemana);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    horaInicio = rs.getTime("horaInicio").toLocalTime();
                    horaFin = rs.getTime("horaFin").toLocalTime();
                    maxCitas = rs.getInt("maxCitas");
                }
            }

            if (horaInicio == null) return horas;

            Map<LocalTime, Integer> ocupadas = new HashMap<>();

            try (PreparedStatement ps = con.prepareStatement(sqlOcupadas)) {
                ps.setInt(1, idUsuario);
                ps.setDate(2, Date.valueOf(fecha));
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    LocalTime hora = rs.getTime("horaCita").toLocalTime();
                    int total = rs.getInt("total");
                    ocupadas.put(hora, total);
                }
            }

            LocalTime slot = horaInicio;
            while (!slot.isAfter(horaFin.minusMinutes(30))) {
                int usadas = ocupadas.getOrDefault(slot, 0);
                if (usadas == 0) {
                    horas.add(slot);
                }
                slot = slot.plusMinutes(30);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return horas;
    }

    // ✅ DÍAS CON HORARIO
    public List<Integer> diasConHorario(int idUsuario) {
        List<Integer> dias = new ArrayList<>();
        String sql = "SELECT DISTINCT \"diaSemana\" FROM horarios WHERE \"idUsuario\" = ?";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                dias.add(rs.getInt("diaSemana"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dias;
    }

    // ✅ VERIFICAR DISPONIBILIDAD
    public boolean estaDisponible(int idUsuario, LocalDate fecha, LocalTime hora) {
        String sql = "SELECT COUNT(*) FROM citas "
                + "WHERE \"idUsuario\" = ? AND \"fechaCita\" = ? AND \"horaCita\" = ? "
                + "AND estado IN ('PROGRAMADA','CONFIRMADA')";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setDate(2, Date.valueOf(fecha));
            ps.setTime(3, Time.valueOf(hora));
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1) == 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 🔧 MAPEAR
    private Horario mapear(ResultSet rs) throws SQLException {
        Horario h = new Horario();
        h.setIdHorario(rs.getInt("idHorario"));
        h.setIdUsuario(rs.getInt("idUsuario"));
        h.setDiaSemana(rs.getInt("diaSemana"));
        h.setHoraInicio(rs.getTime("horaInicio").toLocalTime());
        h.setHoraFin(rs.getTime("horaFin").toLocalTime());
        h.setMaxCitas(rs.getInt("maxCitas"));
        return h;
    }
}
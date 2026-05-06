package co.sena.cimm.adso.saludboyaca.dto;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Date;

public class Cita {

    // ── Campos originales de la tabla citas ──────────────────────────
    private int idCita;
    private int idPaciente;
    private int idUsuario;
    private int idEspecialidad;
    private Date fechaCita;
    private LocalTime horaCita;
    private String motivo;
    private String estado;
    private String observaciones;
    private LocalDateTime fechaRegistro;
    private int idRegistrador;

    // ── Campos extra para consulta pública (JOIN con pacientes, usuarios,
    // especialidades) ──
    private String pacienteNombre;
    private String pacienteApellido;
    private String documento;
    private String medicoNombre;
    private String medicoApellido;
    private String especialidad;

    public Cita() {
    }

    public Cita(int idCita, int idPaciente, int idUsuario, int idEspecialidad,
            Date fechaCita, LocalTime horaCita, String motivo, String estado,
            String observaciones, LocalDateTime fechaRegistro, int idRegistrador) {
        this.idCita = idCita;
        this.idPaciente = idPaciente;
        this.idUsuario = idUsuario;
        this.idEspecialidad = idEspecialidad;
        this.fechaCita = fechaCita;
        this.horaCita = horaCita;
        this.motivo = motivo;
        this.estado = estado;
        this.observaciones = observaciones;
        this.fechaRegistro = fechaRegistro;
        this.idRegistrador = idRegistrador;
    }

    // ── Getters / Setters originales ─────────────────────────────────
    public int getIdCita() {
        return idCita;
    }

    public void setIdCita(int idCita) {
        this.idCita = idCita;
    }

    public int getIdPaciente() {
        return idPaciente;
    }

    public void setIdPaciente(int idPaciente) {
        this.idPaciente = idPaciente;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdEspecialidad() {
        return idEspecialidad;
    }

    public void setIdEspecialidad(int v) {
        this.idEspecialidad = v;
    }

    public Date getFechaCita() {
        return fechaCita;
    }

    public void setFechaCita(Date fechaCita) {
        this.fechaCita = fechaCita;
    }

    public LocalTime getHoraCita() {
        return horaCita;
    }

    public void setHoraCita(LocalTime horaCita) {
        this.horaCita = horaCita;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String v) {
        this.observaciones = v;
    }

    public LocalDateTime getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(LocalDateTime v) {
        this.fechaRegistro = v;
    }

    public int getIdRegistrador() {
        return idRegistrador;
    }

    public void setIdRegistrador(int v) {
        this.idRegistrador = v;
    }

    // ── Getters / Setters campos extra para consulta pública ─────────
    public String getPacienteNombre() {
        return pacienteNombre;
    }

    public void setPacienteNombre(String v) {
        this.pacienteNombre = v;
    }

    public String getPacienteApellido() {
        return pacienteApellido;
    }

    public void setPacienteApellido(String v) {
        this.pacienteApellido = v;
    }

    public String getDocumento() {
        return documento;
    }

    public void setDocumento(String v) {
        this.documento = v;
    }

    public String getMedicoNombre() {
        return medicoNombre;
    }

    public void setMedicoNombre(String v) {
        this.medicoNombre = v;
    }

    public String getMedicoApellido() {
        return medicoApellido;
    }

    public void setMedicoApellido(String v) {
        this.medicoApellido = v;
    }

    public String getEspecialidad() {
        return especialidad;
    }

    public void setEspecialidad(String v) {
        this.especialidad = v;
    }
}
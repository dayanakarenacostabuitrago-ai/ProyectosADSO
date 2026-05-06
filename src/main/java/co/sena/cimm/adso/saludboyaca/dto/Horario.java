package co.sena.cimm.adso.saludboyaca.dto;

import java.time.LocalTime;

public class Horario {
    private int idHorario;
    private int idUsuario;
    private int diaSemana;
    private LocalTime horaInicio;
    private LocalTime horaFin;
    private int maxCitas;
    // Campo transitorio para mostrar en vistas
    private String nombreMedico;

    public Horario() {
    }

    public Horario(int idHorario, int idUsuario, int diaSemana, LocalTime horaInicio, LocalTime horaFin, int maxCitas) {
        this.idHorario = idHorario;
        this.idUsuario = idUsuario;
        this.diaSemana = diaSemana;
        this.horaInicio = horaInicio;
        this.horaFin = horaFin;
        this.maxCitas = maxCitas;
    }

    public int getIdHorario() {
        return idHorario;
    }

    public void setIdHorario(int idHorario) {
        this.idHorario = idHorario;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getDiaSemana() {
        return diaSemana;
    }

    public void setDiaSemana(int diaSemana) {
        this.diaSemana = diaSemana;
    }

    public LocalTime getHoraInicio() {
        return horaInicio;
    }

    public void setHoraInicio(LocalTime horaInicio) {
        this.horaInicio = horaInicio;
    }

    public LocalTime getHoraFin() {
        return horaFin;
    }

    public void setHoraFin(LocalTime horaFin) {
        this.horaFin = horaFin;
    }

    public int getMaxCitas() {
        return maxCitas;
    }

    public void setMaxCitas(int maxCitas) {
        this.maxCitas = maxCitas;
    }

    public String getNombreMedico() {
        return nombreMedico;
    }

    public void setNombreMedico(String nombreMedico) {
        this.nombreMedico = nombreMedico;
    }
}

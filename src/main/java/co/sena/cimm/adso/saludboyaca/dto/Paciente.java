package co.sena.cimm.adso.saludboyaca.dto;

import java.util.Date;

public class Paciente {
    private int idPaciente;
    private String nombres;
    private String apellidos;
    private String documento;
    private Date fechaNacimiento;
    private String telefono;
    private String email;
    private String eps;
    private String VeredaBarrio;

    public Paciente() {
    }

    public Paciente(int idPaciente, String nombres, String apellidos, String documento, Date fechaNacimiento,
            String telefono, String email, String eps, String veredaBarrio) {
        this.idPaciente = idPaciente;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.documento = documento;
        this.fechaNacimiento = fechaNacimiento;
        this.telefono = telefono;
        this.email = email;
        this.eps = eps;
        VeredaBarrio = veredaBarrio;
    }

    public int getIdPaciente() {
        return idPaciente;
    }

    public void setIdPaciente(int idPaciente) {
        this.idPaciente = idPaciente;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getDocumento() {
        return documento;
    }

    public void setDocumento(String documento) {
        this.documento = documento;
    }

    public Date getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(Date fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getEps() {
        return eps;
    }

    public void setEps(String eps) {
        this.eps = eps;
    }

    public String getVeredaBarrio() {
        return VeredaBarrio;
    }

    public void setVeredaBarrio(String veredaBarrio) {
        VeredaBarrio = veredaBarrio;
    }


}

package co.sena.cimm.adso.registraduria.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Ciudadano {

    // =========================
    // 🔹 CAMPOS BASE (TABLA)
    // =========================
    private Integer idCiudadanos;
    private String numeroDocumento;
    private String nombres;
    private String apellidos;
    private LocalDate fechaNacimiento;
    private String veredaBarrio;
    private String telefono;
    private String correo;
    private Integer idMesasVotacion;
    private LocalDateTime fechaRegistro;

    // =========================
    // 🔥 CAMPOS DE LOS JOIN (ya los tienes)
    // =========================
    private Integer numeroMesa;
    private String nombreZona;
    private String puestoVotacion;
    private String ciudadNombre;

    // =========================
    // 🆕 NUEVOS CAMPOS FALTANTES
    // =========================
    private String codigoDane; // de ciudades
    private String direccionZona; // de zonasVotacion
    private Integer capacidadMesa; // de mesasVotacion

    // =========================
    // 🔹 GETTERS Y SETTERS (BASE)
    // =========================

    public Integer getIdCiudadanos() {
        return idCiudadanos;
    }

    public void setIdCiudadanos(Integer idCiudadanos) {
        this.idCiudadanos = idCiudadanos;
    }

    public String getNumeroDocumento() {
        return numeroDocumento;
    }

    public void setNumeroDocumento(String numeroDocumento) {
        this.numeroDocumento = numeroDocumento;
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

    public LocalDate getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(LocalDate fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }

    public String getVeredaBarrio() {
        return veredaBarrio;
    }

    public void setVeredaBarrio(String veredaBarrio) {
        this.veredaBarrio = veredaBarrio;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public Integer getIdMesasVotacion() {
        return idMesasVotacion;
    }

    public void setIdMesasVotacion(Integer idMesasVotacion) {
        this.idMesasVotacion = idMesasVotacion;
    }

    public LocalDateTime getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(LocalDateTime fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    // =========================
    // 🔥 JOIN GETTERS/SETTERS (ya los tenías)
    // =========================

    public Integer getNumeroMesa() {
        return numeroMesa;
    }

    public void setNumeroMesa(Integer numeroMesa) {
        this.numeroMesa = numeroMesa;
    }

    public String getNombreZona() {
        return nombreZona;
    }

    public void setNombreZona(String nombreZona) {
        this.nombreZona = nombreZona;
    }

    public String getPuestoVotacion() {
        return puestoVotacion;
    }

    public void setPuestoVotacion(String puestoVotacion) {
        this.puestoVotacion = puestoVotacion;
    }

    public String getCiudadNombre() {
        return ciudadNombre;
    }

    public void setCiudadNombre(String ciudadNombre) {
        this.ciudadNombre = ciudadNombre;
    }

    // =========================
    // 🆕 NUEVOS GETTERS/SETTERS
    // =========================

    public String getCodigoDane() {
        return codigoDane;
    }

    public void setCodigoDane(String codigoDane) {
        this.codigoDane = codigoDane;
    }

    public String getDireccionZona() {
        return direccionZona;
    }

    public void setDireccionZona(String direccionZona) {
        this.direccionZona = direccionZona;
    }

    public Integer getCapacidadMesa() {
        return capacidadMesa;
    }

    public void setCapacidadMesa(Integer capacidadMesa) {
        this.capacidadMesa = capacidadMesa;
    }

    // =========================
    // 🔹 MÉTODO ÚTIL
    // =========================

    public String getNombreCompleto() {
        return nombres + " " + apellidos;
    }

    public String getIniciales() {
        String n = (nombres != null && !nombres.isEmpty()) ? nombres.substring(0, 1) : "?";
        String a = (apellidos != null && !apellidos.isEmpty()) ? apellidos.substring(0, 1) : "";
        return (n + a).toUpperCase();
    }
}

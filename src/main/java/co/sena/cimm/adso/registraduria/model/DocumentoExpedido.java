package co.sena.cimm.adso.registraduria.model;

import java.time.LocalDate;

public class DocumentoExpedido {

    private Integer idDocumentosExpedidos;
    private Integer idCiudadanos;
    private String tipoDocumento;
    private String numeroSerie;
    private LocalDate fechaExpedicion;
    private LocalDate fechaVencimiento;
    private String estado;
    private String observaciones;

    // Campos JOIN
    private String ciudadanoNombre;
    private String ciudadanoDocumento;

    // Constructores
    public DocumentoExpedido() {
    }

    // Getters y Setters
    public Integer getIdDocumentosExpedidos() {
        return idDocumentosExpedidos;
    }

    public void setIdDocumentosExpedidos(Integer idDocumentosExpedidos) {
        this.idDocumentosExpedidos = idDocumentosExpedidos;
    }

    public Integer getIdCiudadanos() {
        return idCiudadanos;
    }

    public void setIdCiudadanos(Integer idCiudadanos) {
        this.idCiudadanos = idCiudadanos;
    }

    public String getTipoDocumento() {
        return tipoDocumento;
    }

    public void setTipoDocumento(String tipoDocumento) {
        this.tipoDocumento = tipoDocumento;
    }

    public String getNumeroSerie() {
        return numeroSerie;
    }

    public void setNumeroSerie(String numeroSerie) {
        this.numeroSerie = numeroSerie;
    }

    public LocalDate getFechaExpedicion() {
        return fechaExpedicion;
    }

    public void setFechaExpedicion(LocalDate fechaExpedicion) {
        this.fechaExpedicion = fechaExpedicion;
    }

    public LocalDate getFechaVencimiento() {
        return fechaVencimiento;
    }

    public void setFechaVencimiento(LocalDate fechaVencimiento) {
        this.fechaVencimiento = fechaVencimiento;
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

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public String getCiudadanoNombre() {
        return ciudadanoNombre;
    }

    public void setCiudadanoNombre(String ciudadanoNombre) {
        this.ciudadanoNombre = ciudadanoNombre;
    }

    public String getCiudadanoDocumento() {
        return ciudadanoDocumento;
    }

    public void setCiudadanoDocumento(String ciudadanoDocumento) {
        this.ciudadanoDocumento = ciudadanoDocumento;
    }

    public String getNombreCompleto() {
        return ciudadanoNombre;
    }

    // Campo calculado para reporte de vencimientos
    private long diasRestantes;

    public long getDiasRestantes() {
        return diasRestantes;
    }

    public void setDiasRestantes(long diasRestantes) {
        this.diasRestantes = diasRestantes;
    }
}
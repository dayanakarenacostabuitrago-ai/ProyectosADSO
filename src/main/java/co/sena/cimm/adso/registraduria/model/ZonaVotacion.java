package co.sena.cimm.adso.registraduria.model;

public class ZonaVotacion {

    private Integer idZonaVotacion;
    private String nombreZona;
    private String puestoVotacion;
    private String direccion;
    private Integer idCiudades;

    // JOIN: nombre de la ciudad
    private String ciudadNombre;

    // Cantidad de mesas en esta zona (calculado)
    private Integer totalMesas;

    // ── Getters y Setters ──

    public Integer getIdZonaVotacion() {
        return idZonaVotacion;
    }

    public void setIdZonaVotacion(Integer idZonaVotacion) {
        this.idZonaVotacion = idZonaVotacion;
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

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public Integer getIdCiudades() {
        return idCiudades;
    }

    public void setIdCiudades(Integer idCiudades) {
        this.idCiudades = idCiudades;
    }

    public String getCiudadNombre() {
        return ciudadNombre;
    }

    public void setCiudadNombre(String ciudadNombre) {
        this.ciudadNombre = ciudadNombre;
    }

    public Integer getTotalMesas() {
        return totalMesas;
    }

    public void setTotalMesas(Integer totalMesas) {
        this.totalMesas = totalMesas;
    }
}

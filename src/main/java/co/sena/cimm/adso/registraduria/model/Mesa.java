package co.sena.cimm.adso.registraduria.model;

public class Mesa {
    private Integer idMesasVotacion;
    private Integer idZonaVotacion;
    private Integer numeroMesa;
    private Integer capacidad;
    // JOIN
    private String nombreZona;
    private String ciudadanosAsignados;
    private Integer totalCiudadanos;

    public Integer getIdMesasVotacion() {
        return idMesasVotacion;
    }

    public void setIdMesasVotacion(Integer v) {
        this.idMesasVotacion = v;
    }

    public Integer getIdZonaVotacion() {
        return idZonaVotacion;
    }

    public void setIdZonaVotacion(Integer v) {
        this.idZonaVotacion = v;
    }

    public Integer getNumeroMesa() {
        return numeroMesa;
    }

    public void setNumeroMesa(Integer v) {
        this.numeroMesa = v;
    }

    public Integer getCapacidad() {
        return capacidad;
    }

    public void setCapacidad(Integer v) {
        this.capacidad = v;
    }

    public String getNombreZona() {
        return nombreZona;
    }

    public void setNombreZona(String v) {
        this.nombreZona = v;
    }

    public Integer getTotalCiudadanos() {
        return totalCiudadanos;
    }

    public void setTotalCiudadanos(Integer v) {
        this.totalCiudadanos = v;
    }
}
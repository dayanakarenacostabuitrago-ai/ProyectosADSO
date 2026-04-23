package co.sena.cimm.adso.registraduria.dao;

import co.sena.cimm.adso.registraduria.model.ZonaVotacion;
import java.util.List;

public interface ZonaVotacionDAO {

    List<ZonaVotacion> listarTodas() throws Exception;

    List<ZonaVotacion> buscar(String termino) throws Exception;

    ZonaVotacion buscarPorId(int id) throws Exception;

    void crear(ZonaVotacion zona) throws Exception;

    void actualizar(ZonaVotacion zona) throws Exception;

    void eliminar(int id) throws Exception;

    boolean tieneMesas(int id) throws Exception;

    List<ZonaVotacion> buscarPorCiudad(int idCiudad) throws Exception;

    /** Retorna lista de [idCiudades, nombre] para el filtro */
    List<Object[]> listarCiudades() throws Exception;
}
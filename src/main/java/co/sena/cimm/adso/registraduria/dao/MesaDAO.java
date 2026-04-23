package co.sena.cimm.adso.registraduria.dao;

import co.sena.cimm.adso.registraduria.model.Mesa;
import java.util.List;

public interface MesaDAO {
    List<Mesa> listarTodas() throws Exception;

    List<Mesa> buscar(String termino) throws Exception;

    Mesa buscarPorId(int id) throws Exception;

    void crear(Mesa m) throws Exception;

    void actualizar(Mesa m) throws Exception;

    void eliminar(int id) throws Exception;

    boolean tieneCiudadanos(int id) throws Exception;

    List<Mesa> buscarPorZona(int idZona) throws Exception;
}
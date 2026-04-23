package co.sena.cimm.adso.registraduria.dao;

import co.sena.cimm.adso.registraduria.model.Ciudadano;
import java.util.List;

public interface CiudadanoDAO {
    
    List<Ciudadano> listarTodos() throws Exception;
    
    Ciudadano buscarPorId(int id) throws Exception;
    
    Ciudadano buscarPorDocumento(String numeroDocumento) throws Exception;
    
    List<Ciudadano> buscarPorNombre(String nombre) throws Exception;
    
    boolean insertar(Ciudadano ciudadano) throws Exception;
    
    boolean actualizar(Ciudadano ciudadano) throws Exception;
    
    boolean eliminar(int id) throws Exception;
    
    boolean existeDocumento(String numeroDocumento) throws Exception;
    
    List<Ciudadano> listarConMesaAsignada() throws Exception;

    boolean tieneDocumentos(int id) throws Exception;
}
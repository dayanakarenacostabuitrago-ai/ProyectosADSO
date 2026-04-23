package co.sena.cimm.adso.registraduria.dao;

import co.sena.cimm.adso.registraduria.model.DocumentoExpedido;
import java.util.List;

public interface DocumentoDAO {
    
    List<DocumentoExpedido> listarTodos() throws Exception;
    
    DocumentoExpedido buscarPorId(int id) throws Exception;
    
    List<DocumentoExpedido> buscarPorCiudadano(int idCiudadano) throws Exception;
    
    List<DocumentoExpedido> buscarPorTipo(String tipoDocumento) throws Exception;
    
    List<DocumentoExpedido> buscarPorEstado(String estado) throws Exception;
    
    boolean insertar(DocumentoExpedido documento) throws Exception;
    
    boolean actualizar(DocumentoExpedido documento) throws Exception;
    
    boolean eliminar(int id) throws Exception;
    
    boolean existeNumeroSerie(String numeroSerie) throws Exception;
    
    List<DocumentoExpedido> buscarPorCriterio(String criterio) throws Exception;

    /** Documentos ya vencidos (fechaVencimiento < hoy) */
    List<DocumentoExpedido> listarVencidos() throws Exception;

    /** Documentos que vencen entre hoy y hoy+30 dias */
    List<DocumentoExpedido> listarProximosAVencer() throws Exception;
}
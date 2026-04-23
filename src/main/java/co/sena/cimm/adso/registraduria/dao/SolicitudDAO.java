package co.sena.cimm.adso.registraduria.dao;

import co.sena.cimm.adso.registraduria.model.SolicitudCiudadano;
import java.util.List;

public interface SolicitudDAO {

    /** Guarda una nueva solicitud (retorna el ID generado) */
    int guardar(SolicitudCiudadano s) throws Exception;

    /** Lista todas las solicitudes ordenadas por fecha desc */
    List<SolicitudCiudadano> listarTodas() throws Exception;

    /** Cuenta cuántas solicitudes están en estado PENDIENTE */
    int contarPendientes() throws Exception;

    /** Actualiza estado + respuesta del admin */
    void responder(int id, String estado, String respuesta, String adminNombre) throws Exception;

    /** Busca una solicitud por ID */
    SolicitudCiudadano buscarPorId(int id) throws Exception;
}

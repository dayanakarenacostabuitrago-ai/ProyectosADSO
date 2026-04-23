package co.sena.cimm.adso.registraduria.dao;

import co.sena.cimm.adso.registraduria.model.Ciudadano;

public interface ConsultaMesaDAO {

    Ciudadano consultarPorDocumento(String documento) throws Exception;
}
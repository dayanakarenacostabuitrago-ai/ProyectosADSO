package co.sena.cimm.adso.registraduria.dao;

import co.sena.cimm.adso.registraduria.model.Usuario;
import java.util.List;

public interface UsuarioDAO {

    // Autenticación
    Usuario buscarPorUsername(String username) throws Exception;

    boolean validarCredenciales(String username, String password) throws Exception;

    // CRUD
    List<Usuario> listarTodos() throws Exception;

    Usuario buscarPorId(int id) throws Exception;

    boolean insertar(Usuario usuario) throws Exception;

    boolean actualizar(Usuario usuario) throws Exception;

    boolean eliminar(int id) throws Exception;

    boolean existeUsername(String username) throws Exception;
}
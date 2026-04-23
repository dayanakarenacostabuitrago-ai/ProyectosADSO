package co.sena.cimm.adso.registraduria.servlet;

import co.sena.cimm.adso.registraduria.dao.UsuarioDAO;
import co.sena.cimm.adso.registraduria.dao.UsuarioDAOImpl;
import co.sena.cimm.adso.registraduria.model.Usuario;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/usuarios")
public class UsuarioServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() {
        usuarioDAO = new UsuarioDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Verificar que sea SuperAdmin
        HttpSession session = req.getSession(false);
        Usuario usuarioActual = (Usuario) session.getAttribute("usuario");

        if (usuarioActual == null || !usuarioActual.getEsSuperAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("delete".equals(action)) {
                eliminarUsuario(req, resp);
            } else {
                listarUsuarios(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/usuarios?error=" + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Verificar que sea SuperAdmin
        HttpSession session = req.getSession(false);
        Usuario usuarioActual = (Usuario) session.getAttribute("usuario");

        if (usuarioActual == null || !usuarioActual.getEsSuperAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("create".equals(action)) {
                crearUsuario(req, resp);
            } else if ("update".equals(action)) {
                actualizarUsuario(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/usuarios");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/usuarios?error=" + e.getMessage());
        }
    }

    private void listarUsuarios(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        List<Usuario> usuarios = usuarioDAO.listarTodos();
        req.setAttribute("usuarios", usuarios);
        req.getRequestDispatcher("/WEB-INF/vistas/usuarios/listado.jsp").forward(req, resp);
    }

    private void crearUsuario(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String nombreCompleto = req.getParameter("nombreCompleto");
        String email = req.getParameter("email");
        String esSuperAdminStr = req.getParameter("esSuperAdmin");

        // Validaciones
        if (usuarioDAO.existeUsername(username)) {
            resp.sendRedirect(req.getContextPath() + "/usuarios?error=El+nombre+de+usuario+ya+existe");
            return;
        }

        // Encriptar contraseña
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        Usuario nuevo = new Usuario();
        nuevo.setUsername(username);
        nuevo.setPassword(hashedPassword);
        nuevo.setNombreCompleto(nombreCompleto);
        nuevo.setEmail(email);
        nuevo.setActivo(true);
        nuevo.setEsSuperAdmin("on".equals(esSuperAdminStr));

        if (usuarioDAO.insertar(nuevo)) {
            resp.sendRedirect(req.getContextPath() + "/usuarios?mensaje=Administrador+creado+exitosamente");
        } else {
            resp.sendRedirect(req.getContextPath() + "/usuarios?error=Error+al+crear+el+administrador");
        }
    }

    private void actualizarUsuario(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        int id = Integer.parseInt(req.getParameter("id"));
        String username = req.getParameter("username");
        String nombreCompleto = req.getParameter("nombreCompleto");
        String email = req.getParameter("email");
        String activoStr = req.getParameter("activo");
        String esSuperAdminStr = req.getParameter("esSuperAdmin");

        Usuario existente = usuarioDAO.buscarPorId(id);
        if (existente == null) {
            resp.sendRedirect(req.getContextPath() + "/usuarios?error=Administrador+no+encontrado");
            return;
        }

        existente.setUsername(username);
        existente.setNombreCompleto(nombreCompleto);
        existente.setEmail(email);
        existente.setActivo("on".equals(activoStr));
        existente.setEsSuperAdmin("on".equals(esSuperAdminStr));

        if (usuarioDAO.actualizar(existente)) {
            resp.sendRedirect(req.getContextPath() + "/usuarios?mensaje=Administrador+actualizado+exitosamente");
        } else {
            resp.sendRedirect(req.getContextPath() + "/usuarios?error=Error+al+actualizar+el+administrador");
        }
    }

    private void eliminarUsuario(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        int id = Integer.parseInt(req.getParameter("id"));

        // No permitir eliminar al propio usuario
        HttpSession session = req.getSession(false);
        Usuario usuarioActual = (Usuario) session.getAttribute("usuario");

        if (usuarioActual.getIdUsuario() == id) {
            resp.sendRedirect(req.getContextPath() + "/usuarios?error=No+puedes+eliminar+tu+propio+usuario");
            return;
        }

        if (usuarioDAO.eliminar(id)) {
            resp.sendRedirect(req.getContextPath() + "/usuarios?mensaje=Administrador+desactivado+exitosamente");
        } else {
            resp.sendRedirect(req.getContextPath() + "/usuarios?error=Error+al+desactivar+el+administrador");
        }
    }
}
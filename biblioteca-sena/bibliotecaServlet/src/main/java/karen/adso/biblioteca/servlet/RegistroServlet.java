package karen.adso.biblioteca.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import karen.adso.biblioteca.dao.UsuarioDAO;
import karen.adso.biblioteca.modelo.Usuario;

/**
 * Servlet para el auto-registro de estudiantes. GET /registro → muestra el
 * formulario (registro.jsp) POST /registro → crea el usuario y redirige al
 * login
 */
@WebServlet("/registro")
public class RegistroServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/vistas/registro.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String documento = trim(req.getParameter("documento"));
        String nombres = trim(req.getParameter("nombres"));
        String apellidos = trim(req.getParameter("apellidos"));
        String email = trim(req.getParameter("email"));
        String telefono = trim(req.getParameter("telefono"));

        // ── Validaciones básicas ──────────────────────────────────
        if (documento.isEmpty() || nombres.isEmpty() || apellidos.isEmpty()) {
            req.setAttribute("error", "Documento, nombres y apellidos son obligatorios.");
            req.getRequestDispatcher("/WEB-INF/vistas/registro.jsp").forward(req, resp);
            return;
        }
        if (documento.length() < 5 || documento.length() > 20) {
            req.setAttribute("error", "El documento debe tener entre 5 y 20 caracteres.");
            req.getRequestDispatcher("/WEB-INF/vistas/registro.jsp").forward(req, resp);
            return;
        }

        // ── Verificar que el documento no exista ya ───────────────
        if (usuarioDAO.buscarPorDocumento(documento) != null) {
            req.setAttribute("error", "Ya existe una cuenta con el documento " + documento + ".");
            req.getRequestDispatcher("/WEB-INF/vistas/registro.jsp").forward(req, resp);
            return;
        }

        // ── Crear el usuario con rol Estudiante / estado Activo ───
        Usuario u = new Usuario();
        u.setDocumento(documento);
        u.setNombres(nombres);
        u.setApellidos(apellidos);
        u.setEmail(email.isEmpty() ? null : email);
        u.setTelefono(telefono.isEmpty() ? null : telefono);
        u.setTipoUsuario("Estudiante");
        u.setEstado("Activo");

        boolean ok = usuarioDAO.insertar(u);

        if (ok) {
            // Redirigir al login con parámetro de éxito
            resp.sendRedirect(req.getContextPath() + "/loginServlet?registrado=1");
        } else {
            req.setAttribute("error", "Ocurrió un error al crear la cuenta. Intenta de nuevo.");
            req.getRequestDispatcher("/WEB-INF/vistas/registro.jsp").forward(req, resp);
        }
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }
}

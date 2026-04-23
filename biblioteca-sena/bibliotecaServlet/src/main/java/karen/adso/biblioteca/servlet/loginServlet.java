package karen.adso.biblioteca.servlet;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import karen.adso.biblioteca.dao.UsuarioDAO;
import karen.adso.biblioteca.modelo.Usuario;

@WebServlet("/loginServlet")
public class loginServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Manejo de cierre de sesión
        String accion = request.getParameter("accion");
        if ("logout".equals(accion)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/loginServlet");
            return;
        }

        // Si ya tiene sesión activa, redirigir según rol
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            redirigirSegunRol(session, request, response);
            return;
        }
        request.getRequestDispatcher("/WEB-INF/vistas/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String documento = request.getParameter("documento");
        String password  = request.getParameter("password");

        if (documento == null || documento.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Ingrese documento y contraseña.");
            request.getRequestDispatcher("/WEB-INF/vistas/login.jsp").forward(request, response);
            return;
        }

        Usuario usuario = usuarioDAO.buscarPorDocumento(documento.trim());

        if (usuario != null && password.equals(usuario.getDocumento())) {

            if (!"Activo".equalsIgnoreCase(usuario.getEstado())) {
                request.setAttribute("error", "Su cuenta está inactiva. Contacte al administrador.");
                request.getRequestDispatcher("/WEB-INF/vistas/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("usuario",          usuario);
            session.setAttribute("usuarioSesion",    usuario);
            session.setAttribute("usuarioId",        usuario.getIdUsuario());
            session.setAttribute("tipoUsuario",      usuario.getTipoUsuario());
            session.setAttribute("nombreUsuario",    usuario.getNombres());
            session.setAttribute("documentoUsuario", usuario.getDocumento());
            session.setMaxInactiveInterval(30 * 60);

            redirigirSegunRol(session, request, response);

        } else {
            request.setAttribute("error", "Documento o contraseña incorrectos.");
            request.getRequestDispatcher("/WEB-INF/vistas/login.jsp").forward(request, response);
        }
    }


    private void redirigirSegunRol(HttpSession session,
                                   HttpServletRequest request,
                                   HttpServletResponse response) throws IOException {

        String tipo = (String) session.getAttribute("tipoUsuario");

        if (tipo == null) {
            response.sendRedirect(request.getContextPath() + "/LibroServlet");
            return;
        }

        switch (tipo) {
            case "Administrativo":
                // Administrativo → va al catálogo de libros (panel principal con acceso total)
                response.sendRedirect(request.getContextPath() + "/LibroServlet");
                break;

            case "Bibliotecario":
                // Bibliotecario → catálogo de libros (puede editar/eliminar/registrar)
                response.sendRedirect(request.getContextPath() + "/LibroServlet");
                break;

            case "Estudiante":
                // Estudiante → catálogo de libros (solo lectura; sus préstamos/multas filtrados)
                response.sendRedirect(request.getContextPath() + "/LibroServlet");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/LibroServlet");
        }
    }
}

package karen.adso.biblioteca.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import karen.adso.biblioteca.dao.AutorDAO;
import karen.adso.biblioteca.modelo.Autor;

@WebServlet("/AutorServlet")
public class AutorServlet extends HttpServlet {

    private final AutorDAO autorDAO = new AutorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "nuevo":
                request.getRequestDispatcher("/WEB-INF/vistas/formularioAutor.jsp").forward(request, response);
                break;
            case "editar":
                int idE = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("autor", autorDAO.buscarPorId(idE));
                request.getRequestDispatcher("/WEB-INF/vistas/formularioAutor.jsp").forward(request, response);
                break;
            case "eliminar":
                boolean okE = autorDAO.eliminar(Integer.parseInt(request.getParameter("id")));
                request.getSession().setAttribute("mensaje", okE ? "Autor eliminado." : "Error al eliminar.");
                request.getSession().setAttribute("tipoMensaje", okE ? "success" : "danger");
                response.sendRedirect(request.getContextPath() + "/AutorServlet");
                break;
            default:
                List<Autor> autores = autorDAO.listarTodos();
                request.setAttribute("autores", autores);
                request.getRequestDispatcher("/WEB-INF/vistas/autor.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        Autor autor = construirAutor(request);

        boolean ok;
        if ("actualizar".equals(accion)) {
            autor.setId(Integer.parseInt(request.getParameter("id")));
            ok = autorDAO.actualizar(autor);
            request.getSession().setAttribute("mensaje", ok ? "Autor actualizado." : "Error al actualizar.");
        } else {
            ok = autorDAO.insertar(autor);
            request.getSession().setAttribute("mensaje", ok ? "Autor registrado." : "Error al registrar.");
        }
        request.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
        response.sendRedirect(request.getContextPath() + "/AutorServlet");
    }

    private Autor construirAutor(HttpServletRequest request) {
        Autor a = new Autor();

        a.setNombre(request.getParameter("nombre"));
        a.setApellido(request.getParameter("apellido"));
        a.setNacionalidad(request.getParameter("nacionalidad"));

        String nacimiento = request.getParameter("fechaNacimiento");

        if (nacimiento != null && !nacimiento.trim().isEmpty()) {
            try {
                a.setFechaNacimiento(java.sql.Date.valueOf(nacimiento));
            } catch (IllegalArgumentException e) {
                System.out.println("Formato de fecha inválido: " + nacimiento);
            }
        }

        return a;
    }
}

package karen.adso.biblioteca.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import karen.adso.biblioteca.dao.CategoriaDAO;
import karen.adso.biblioteca.modelo.Categoria;

@WebServlet("/CategoriaServlet")
public class CategoriaServlet extends HttpServlet {

    private final CategoriaDAO categoriaDAO = new CategoriaDAO();

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
                request.getRequestDispatcher("/WEB-INF/vistas/formularioCategoria.jsp")
                        .forward(request, response);
                break;
            case "editar":
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("categoria", categoriaDAO.buscarPorId(id));
                request.getRequestDispatcher("/WEB-INF/vistas/formularioCategoria.jsp")
                        .forward(request, response);
                break;
            case "eliminar":
                boolean ok = categoriaDAO.eliminar(Integer.parseInt(request.getParameter("id")));
                request.getSession().setAttribute("mensaje", ok ? "Categoria eliminada." : "Error al eliminar.");
                request.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
                response.sendRedirect(request.getContextPath() + "/CategoriaServlet");
                break;
            default:
                List<Categoria> categorias = categoriaDAO.listarTodos();
                request.setAttribute("categorias", categorias);
                request.getRequestDispatcher("/WEB-INF/vistas/categoria.jsp")
                        .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        Categoria c = new Categoria();
        c.setNombre(request.getParameter("nombre"));
        c.setDescripcion(request.getParameter("descripcion"));

        boolean ok;
        if ("actualizar".equals(accion)) {
            c.setId(Integer.parseInt(request.getParameter("id")));
            ok = categoriaDAO.actualizar(c);
            request.getSession().setAttribute("mensaje",
                    ok ? "Categoria actualizada." : "Error al actualizar.");
        } else {
            ok = categoriaDAO.insertar(c);
            request.getSession().setAttribute("mensaje",
                    ok ? "Categoria registrada." : "Error al registrar.");
        }
        request.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
        response.sendRedirect(request.getContextPath() + "/CategoriaServlet");
    }
}

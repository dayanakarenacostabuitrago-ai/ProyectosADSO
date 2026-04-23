/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package karen.adso.biblioteca.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import karen.adso.biblioteca.dao.EditorialDAO;
import karen.adso.biblioteca.modelo.Editorial;

@WebServlet("/EditorialServlet")
public class EditorialServlet extends HttpServlet {

    private final EditorialDAO editorialDAO = new EditorialDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        
        if (accion == null || accion.isEmpty()) {
            accion = "listar";
        }

        try {
            switch (accion) {
                case "nuevo":
                    request.getRequestDispatcher("/WEB-INF/vistas/formularioEditorial.jsp").forward(request, response);
                    break;
                    
                case "editar":
                    String idStr = request.getParameter("id");
                    if (idStr == null || idStr.isEmpty()) {
                        request.getSession().setAttribute("mensaje", "Error: ID de editorial no proporcionado");
                        request.getSession().setAttribute("tipoMensaje", "danger");
                        response.sendRedirect(request.getContextPath() + "/EditorialServlet");
                        return;
                    }
                    
                    int id = Integer.parseInt(idStr);
                    Editorial editorial = editorialDAO.buscarPorId(id);
                    
                    if (editorial == null) {
                        request.getSession().setAttribute("mensaje", "Error: Editorial no encontrada");
                        request.getSession().setAttribute("tipoMensaje", "danger");
                        response.sendRedirect(request.getContextPath() + "/EditorialServlet");
                        return;
                    }
                    
                    request.setAttribute("editorial", editorial);
                    request.getRequestDispatcher("/WEB-INF/vistas/formularioEditorial.jsp").forward(request, response);
                    break;
                    
                case "eliminar":
                    String idEliminar = request.getParameter("id");
                    if (idEliminar == null || idEliminar.isEmpty()) {
                        request.getSession().setAttribute("mensaje", "Error: ID no proporcionado");
                        request.getSession().setAttribute("tipoMensaje", "danger");
                    } else {
                        boolean ok = editorialDAO.eliminar(Integer.parseInt(idEliminar));
                        request.getSession().setAttribute("mensaje", ok ? "Editorial eliminada exitosamente" : "Error al eliminar editorial");
                        request.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
                    }
                    response.sendRedirect(request.getContextPath() + "/EditorialServlet");
                    break;
                    
                default:
                    List<Editorial> editoriales = editorialDAO.listarTodos();
                    request.setAttribute("editoriales", editoriales);
                    request.getRequestDispatcher("/WEB-INF/vistas/editorial.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/EditorialServlet");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        
        if (accion == null || accion.isEmpty()) {
            accion = "insertar";
        }

        try {
            Editorial e = new Editorial();
            e.setNombre(request.getParameter("nombre"));
            e.setPais(request.getParameter("pais"));
            e.setSitioWeb(request.getParameter("sitioWeb")); 
            boolean ok;
            
            if ("actualizar".equals(accion)) {
                // Actualizar editorial existente
                String idStr = request.getParameter("id");
                if (idStr == null || idStr.isEmpty()) {
                    request.getSession().setAttribute("mensaje", "Error: ID no proporcionado para actualización");
                    request.getSession().setAttribute("tipoMensaje", "danger");
                    response.sendRedirect(request.getContextPath() + "/EditorialServlet");
                    return;
                }
                
                e.setId(Integer.parseInt(idStr));
                ok = editorialDAO.actualizar(e);
                request.getSession().setAttribute("mensaje", ok ? "Editorial actualizada exitosamente" : "Error al actualizar editorial");
                request.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
                
            } else {
                // Insertar nueva editorial
                ok = editorialDAO.insertar(e);
                request.getSession().setAttribute("mensaje", ok ? "Editorial registrada exitosamente" : "Error al registrar editorial");
                request.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
            }
            
            response.sendRedirect(request.getContextPath() + "/EditorialServlet");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/EditorialServlet");
        }
    }
}
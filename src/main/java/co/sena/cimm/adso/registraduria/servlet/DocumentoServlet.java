package co.sena.cimm.adso.registraduria.servlet;

import co.sena.cimm.adso.registraduria.dao.CiudadanoDAO;
import co.sena.cimm.adso.registraduria.dao.CiudadanoDAOImpl;
import co.sena.cimm.adso.registraduria.dao.DocumentoDAO;
import co.sena.cimm.adso.registraduria.dao.DocumentoDAOImpl;
import co.sena.cimm.adso.registraduria.model.Ciudadano;
import co.sena.cimm.adso.registraduria.model.DocumentoExpedido;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/documentos")
public class DocumentoServlet extends HttpServlet {

    private DocumentoDAO documentoDAO;
    private CiudadanoDAO ciudadanoDAO;
    private DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Override
    public void init() {
        documentoDAO = new DocumentoDAOImpl();
        ciudadanoDAO = new CiudadanoDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if (action == null)
            action = "list";

        try {
            switch (action) {
                case "new":
                    mostrarFormulario(req, resp);
                    break;
                case "edit":
                    mostrarFormularioEditar(req, resp);
                    break;
                case "delete":
                    eliminarDocumento(req, resp);
                    break;
                case "search":
                    buscarDocumentos(req, resp);
                    break;
                case "filter":
                    filtrarDocumentos(req, resp);
                    break;
                case "vencidos":
                    reporteVencidos(req, resp);
                    break;
                default:
                    listarDocumentos(req, resp);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        try {
            if ("create".equals(action)) {
                crearDocumento(req, resp);
            } else if ("update".equals(action)) {
                actualizarDocumento(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/documentos");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void listarDocumentos(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        List<DocumentoExpedido> documentos = documentoDAO.listarTodos();
        req.setAttribute("documentos", documentos);
        req.getRequestDispatcher("/WEB-INF/vistas/documentos/listado.jsp").forward(req, resp);
    }

    private void mostrarFormulario(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        List<Ciudadano> ciudadanos = ciudadanoDAO.listarTodos();
        req.setAttribute("ciudadanos", ciudadanos);
        req.setAttribute("documento", new DocumentoExpedido());
        req.setAttribute("accion", "create");
        req.getRequestDispatcher("/WEB-INF/vistas/documentos/formulario.jsp").forward(req, resp);
    }

    private void mostrarFormularioEditar(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        DocumentoExpedido documento = documentoDAO.buscarPorId(id);

        if (documento != null) {
            List<Ciudadano> ciudadanos = ciudadanoDAO.listarTodos();
            req.setAttribute("ciudadanos", ciudadanos);
            req.setAttribute("documento", documento);
            req.setAttribute("accion", "update");
            req.getRequestDispatcher("/WEB-INF/vistas/documentos/formulario.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/documentos?error=Documento+no+encontrado");
        }
    }

    private void crearDocumento(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        String numeroSerie = req.getParameter("numeroSerie");

        if (documentoDAO.existeNumeroSerie(numeroSerie)) {
            req.setAttribute("error", "Ya existe un documento con ese número de serie");
            List<Ciudadano> ciudadanos = ciudadanoDAO.listarTodos();
            req.setAttribute("ciudadanos", ciudadanos);
            req.setAttribute("documento", construirDocumentoDesdeRequest(req));
            req.setAttribute("accion", "create");
            req.getRequestDispatcher("/WEB-INF/vistas/documentos/formulario.jsp").forward(req, resp);
            return;
        }

        DocumentoExpedido d;
        try {
            d = construirDocumentoDesdeRequest(req);
        } catch (IllegalArgumentException ex) {
            resp.sendRedirect(req.getContextPath() + "/documentos?error=" +
                    java.net.URLEncoder.encode(ex.getMessage(), "UTF-8"));
            return;
        }

        if (documentoDAO.insertar(d)) {
            resp.sendRedirect(req.getContextPath() + "/documentos?mensaje=Documento+registrado+exitosamente");
        } else {
            req.setAttribute("error", "Error al registrar el documento");
            List<Ciudadano> ciudadanos = ciudadanoDAO.listarTodos();
            req.setAttribute("ciudadanos", ciudadanos);
            req.setAttribute("documento", d);
            req.setAttribute("accion", "create");
            req.getRequestDispatcher("/WEB-INF/vistas/documentos/formulario.jsp").forward(req, resp);
        }
    }

    private void actualizarDocumento(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        int id = Integer.parseInt(req.getParameter("id"));
        DocumentoExpedido d = construirDocumentoDesdeRequest(req);
        d.setIdDocumentosExpedidos(id);

        if (documentoDAO.actualizar(d)) {
            resp.sendRedirect(req.getContextPath() + "/documentos?mensaje=Documento+actualizado+exitosamente");
        } else {
            req.setAttribute("error", "Error al actualizar el documento");
            List<Ciudadano> ciudadanos = ciudadanoDAO.listarTodos();
            req.setAttribute("ciudadanos", ciudadanos);
            req.setAttribute("documento", d);
            req.setAttribute("accion", "update");
            req.getRequestDispatcher("/WEB-INF/vistas/documentos/formulario.jsp").forward(req, resp);
        }
    }

    private void eliminarDocumento(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));

        if (documentoDAO.eliminar(id)) {
            resp.sendRedirect(req.getContextPath() + "/documentos?mensaje=Documento+eliminado+exitosamente");
        } else {
            resp.sendRedirect(req.getContextPath() + "/documentos?error=No+se+pudo+eliminar+el+documento");
        }
    }

    private void buscarDocumentos(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        String criterio = req.getParameter("criterio");

        if (criterio != null && !criterio.trim().isEmpty()) {
            List<DocumentoExpedido> documentos = documentoDAO.buscarPorCriterio(criterio);
            req.setAttribute("documentos", documentos);
            req.setAttribute("criterioBusqueda", criterio);
        } else {
            listarDocumentos(req, resp);
            return;
        }

        req.getRequestDispatcher("/WEB-INF/vistas/documentos/listado.jsp").forward(req, resp);
    }

    private void reporteVencidos(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        List<DocumentoExpedido> vencidos = documentoDAO.listarVencidos();
        List<DocumentoExpedido> proximos = documentoDAO.listarProximosAVencer();
        req.setAttribute("vencidos", vencidos);
        req.setAttribute("proximos", proximos);
        req.setAttribute("fechaActual", java.time.LocalDate.now().toString());
        req.setAttribute("currentPage", "vencidos");
        req.getRequestDispatcher("/WEB-INF/vistas/documentos/vencidos.jsp").forward(req, resp);
    }

    private void filtrarDocumentos(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        String filtro = req.getParameter("filtro");
        String valor = req.getParameter("valor");

        List<DocumentoExpedido> documentos;

        // Depuración: imprimir lo que llega
        System.out.println("=== FILTRO RECIBIDO ===");
        System.out.println("filtro: '" + filtro + "'");
        System.out.println("valor: '" + valor + "'");

        // Si no hay valor, mostrar todos
        if (valor == null || valor.isEmpty()) {
            System.out.println("No hay valor, mostrando todos");
            documentos = documentoDAO.listarTodos();
            req.setAttribute("documentos", documentos);
            req.getRequestDispatcher("/WEB-INF/vistas/documentos/listado.jsp").forward(req, resp);
            return;
        }

        // Si no hay filtro pero hay valor, asumimos tipo
        if (filtro == null || filtro.isEmpty()) {
            filtro = "tipo";
        }

        System.out.println("Filtrando por: " + filtro + " = " + valor);

        // Realizar el filtro según el tipo
        if ("tipo".equals(filtro)) {
            // Normalizar el valor para que coincida con la BD
            String tipoNormalizado = valor;

            // Mapeo de posibles valores al formato exacto de la BD
            if (valor.equals("Cédula de Ciudadanía") || valor.equals("Cedula de Ciudadania")) {
                tipoNormalizado = "Cedula de Ciudadania";
            } else if (valor.equals("Tarjeta de Identidad")) {
                tipoNormalizado = "Tarjeta de Identidad";
            } else if (valor.equals("Registro Civil")) {
                tipoNormalizado = "Registro Civil";
            } else if (valor.equals("Contraseña") || valor.equals("Contrasenha")) {
                tipoNormalizado = "Contrasenha";
            }

            System.out.println("Buscando por tipo: '" + tipoNormalizado + "'");
            documentos = documentoDAO.buscarPorTipo(tipoNormalizado);
            System.out.println("Documentos encontrados: " + (documentos != null ? documentos.size() : 0));

        } else if ("estado".equals(filtro)) {
            System.out.println("Buscando por estado: '" + valor + "'");
            documentos = documentoDAO.buscarPorEstado(valor);
        } else {
            documentos = documentoDAO.listarTodos();
        }

        req.setAttribute("documentos", documentos);
        req.setAttribute("filtroActivo", filtro);
        req.setAttribute("valorFiltro", valor);

        req.getRequestDispatcher("/WEB-INF/vistas/documentos/listado.jsp").forward(req, resp);
    }

    private DocumentoExpedido construirDocumentoDesdeRequest(HttpServletRequest req) throws Exception {
        DocumentoExpedido d = new DocumentoExpedido();

        // Soporta tanto idCiudadanos (int) como ciudadanoDocumento (cedula string)
        String idCiudParam = req.getParameter("idCiudadanos");
        String cedulaParam = req.getParameter("ciudadanoDocumento");
        if (idCiudParam != null && !idCiudParam.isBlank()) {
            d.setIdCiudadanos(Integer.parseInt(idCiudParam.trim()));
        } else if (cedulaParam != null && !cedulaParam.isBlank()) {
            Ciudadano c = ciudadanoDAO.buscarPorDocumento(cedulaParam.trim());
            if (c == null) {
                throw new IllegalArgumentException(
                        "No existe un ciudadano con documento: " + cedulaParam.trim());
            }
            d.setIdCiudadanos(c.getIdCiudadanos());
        }

        d.setTipoDocumento(req.getParameter("tipoDocumento"));
        d.setNumeroSerie(req.getParameter("numeroSerie"));

        String fechaExpStr = req.getParameter("fechaExpedicion");
        if (fechaExpStr != null && !fechaExpStr.isEmpty()) {
            d.setFechaExpedicion(LocalDate.parse(fechaExpStr, formatter));
        }

        String fechaVenStr = req.getParameter("fechaVencimiento");
        if (fechaVenStr != null && !fechaVenStr.isEmpty()) {
            d.setFechaVencimiento(LocalDate.parse(fechaVenStr, formatter));
        }

        d.setEstado(req.getParameter("estado"));
        d.setObservaciones(req.getParameter("observaciones"));

        return d;
    }
}
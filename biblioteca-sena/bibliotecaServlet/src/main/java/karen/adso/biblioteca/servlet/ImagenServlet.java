package karen.adso.biblioteca.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;


@WebServlet("/imagen")
public class ImagenServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String nombreArchivo = req.getParameter("f");

        if (nombreArchivo == null || nombreArchivo.contains("..") || nombreArchivo.contains("/")) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String rutaReal = getServletContext().getRealPath("/WEB-INF/imagenes");
        File archivo = new File(rutaReal + File.separator + nombreArchivo);

        if (!archivo.exists() || !archivo.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String ext = nombreArchivo.substring(nombreArchivo.lastIndexOf('.') + 1).toLowerCase();
        switch (ext) {
            case "jpg":
            case "jpeg":
                resp.setContentType("image/jpeg");
                break;
            case "png":
                resp.setContentType("image/png");
                break;
            case "webp":
                resp.setContentType("image/webp");
                break;
            default:
                resp.setContentType("application/octet-stream");
        }

        resp.setContentLengthLong(archivo.length());

        try (FileInputStream fis = new FileInputStream(archivo); OutputStream os = resp.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesLeidos;
            while ((bytesLeidos = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesLeidos);
            }
        }
    }
}

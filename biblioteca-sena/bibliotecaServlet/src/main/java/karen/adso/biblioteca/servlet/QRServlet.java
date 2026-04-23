package karen.adso.biblioteca.servlet;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;


@WebServlet("/QRServlet")
public class QRServlet extends HttpServlet {

    private static final int TAMANIO = 250;
    private static final int COLOR_NEGRO  = 0xFF000000;
    private static final int COLOR_BLANCO = 0xFFFFFFFF;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idPrestamoStr = req.getParameter("idPrestamo");
        String idReservaStr  = req.getParameter("idReserva");

        String idStr;
        String tipo;
        String servletDestino;

        if (idPrestamoStr != null && !idPrestamoStr.trim().isEmpty()) {
            idStr          = idPrestamoStr;
            tipo           = "prestamo";
            servletDestino = "PrestamoServlet";
        } else if (idReservaStr != null && !idReservaStr.trim().isEmpty()) {
            idStr          = idReservaStr;
            tipo           = "reserva";
            servletDestino = "ReservaServlet";
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parámetro idPrestamo o idReserva requerido.");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, tipo + " debe ser un número.");
            return;
        }

        String baseUrl     = req.getScheme() + "://" + req.getServerName()
                           + ":" + req.getServerPort()
                           + req.getContextPath();
        String urlDestino  = baseUrl + "/" + servletDestino + "?accion=ver&id=" + id;

        Map<EncodeHintType, Object> hints = new HashMap<>();
        hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);
        hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
        hints.put(EncodeHintType.MARGIN, 1);

        try {
            QRCodeWriter writer = new QRCodeWriter();
            BitMatrix matrix    = writer.encode(urlDestino, BarcodeFormat.QR_CODE, TAMANIO, TAMANIO, hints);

            int ancho = matrix.getWidth();
            int alto  = matrix.getHeight();
            BufferedImage imagen = new BufferedImage(ancho, alto, BufferedImage.TYPE_INT_RGB);

            for (int x = 0; x < ancho; x++) {
                for (int y = 0; y < alto; y++) {
                    imagen.setRGB(x, y, matrix.get(x, y) ? COLOR_NEGRO : COLOR_BLANCO);
                }
            }

            resp.setContentType("image/png");
            resp.setHeader("Cache-Control", "max-age=3600");

            OutputStream out = resp.getOutputStream();
            ImageIO.write(imagen, "PNG", out);
            out.flush();

        } catch (WriterException e) {
            System.err.println("QRServlet ERROR generando QR para " + tipo + " " + id + ": " + e.getMessage());
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al generar QR.");
        }
    }
}

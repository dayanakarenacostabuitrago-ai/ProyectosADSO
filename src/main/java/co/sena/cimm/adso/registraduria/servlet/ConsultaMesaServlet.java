package co.sena.cimm.adso.registraduria.servlet;

import co.sena.cimm.adso.registraduria.dao.ConsultaMesaDAO;
import co.sena.cimm.adso.registraduria.dao.ConsultaMesaDAOImpl;
import co.sena.cimm.adso.registraduria.model.Ciudadano;
import co.sena.cimm.adso.registraduria.service.PDFCorreoService;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.net.*;

import org.json.JSONObject;

@WebServlet("/consultaMesa")
public class ConsultaMesaServlet extends HttpServlet {

    private ConsultaMesaDAO dao;

    private static final String SECRET_KEY = "6LezKbssAAAAABxsDh4NNGRk_SlPpsshbd06nw-A";

    @Override
    public void init() {
        dao = new ConsultaMesaDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.removeAttribute("resultado");
        req.removeAttribute("error");
        req.removeAttribute("busquedaRealizada");

        req.getRequestDispatcher("/WEB-INF/vistas/consulta/consultaMesa.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String gRecaptchaResponse = req.getParameter("g-recaptcha-response");

        if (gRecaptchaResponse == null || gRecaptchaResponse.isEmpty()) {
            req.setAttribute("error", "Debes verificar que no eres un robot");
            req.getRequestDispatcher("/WEB-INF/vistas/consulta/consultaMesa.jsp")
                    .forward(req, resp);
            return;
        }

        boolean verificado = verificarCaptcha(gRecaptchaResponse);

        if (!verificado) {
            req.setAttribute("error", "Verificacion reCAPTCHA fallida");
            req.getRequestDispatcher("/WEB-INF/vistas/consulta/consultaMesa.jsp")
                    .forward(req, resp);
            return;
        }

        String documento = req.getParameter("numeroDocumento");

        try {
            Ciudadano c = dao.consultarPorDocumento(documento);

            req.setAttribute("busquedaRealizada", true);
            req.setAttribute("documentoBuscado", documento);

            if (c == null) {
                req.setAttribute("error", "No se encontro un ciudadano con el documento: " + documento);
            } else {
                req.setAttribute("resultado", c);

                
                if (c.getNumeroMesa() != null
                        && c.getCorreo() != null
                        && !c.getCorreo().isBlank()) {
                    try {
                        byte[] pdfBytes = PDFCorreoService.generarPDFBytes(c);
                        PDFCorreoService.enviarCorreoConPDF(c.getCorreo().trim(), c, pdfBytes);
                        req.setAttribute("mensajeCorreo",
                                "Comprobante enviado exitosamente a <strong>"
                                        + c.getCorreo().trim()
                                        + "</strong>. Recuerda que la clave del PDF es tu numero de documento.");
                    } catch (Exception mailEx) {
                        mailEx.printStackTrace();
                        req.setAttribute("errorCorreo",
                                "No se pudo enviar el correo a " + c.getCorreo().trim()
                                        + ". Puedes descargar el PDF manualmente.");
                    }
                } else if (c.getNumeroMesa() != null
                        && (c.getCorreo() == null || c.getCorreo().isBlank())) {
                    req.setAttribute("sinCorreoRegistrado", true);
                }
            }

            req.getRequestDispatcher("/WEB-INF/vistas/consulta/consultaMesa.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error en la consulta: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/vistas/consulta/consultaMesa.jsp")
                    .forward(req, resp);
        }
    }

    private boolean verificarCaptcha(String captchaResponse) {
        try {
            URL url = new URL("https://www.google.com/recaptcha/api/siteverify");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            String params = "secret=" + URLEncoder.encode(SECRET_KEY, "UTF-8")
                    + "&response=" + URLEncoder.encode(captchaResponse, "UTF-8");

            OutputStream os = conn.getOutputStream();
            os.write(params.getBytes("UTF-8"));
            os.flush();
            os.close();

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuilder respuesta = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                respuesta.append(inputLine);
            }
            in.close();

            JSONObject json = new JSONObject(respuesta.toString());
            System.out.println("Respuesta Google: " + respuesta.toString());
            return json.getBoolean("success");

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}

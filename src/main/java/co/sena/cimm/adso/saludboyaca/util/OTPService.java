package co.sena.cimm.adso.saludboyaca.util;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class OTPService {

    private static final String BREVO_API_KEY = System.getenv("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");
    private static final String EMAIL_REMIT = "dayanakarenacostabuitrago@gmail.com";

    public static void enviar(String destino, String otp) {
        try {
            URL url = new URL("https://api.brevo.com/v3/smtp/email");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("accept", "application/json");
            conn.setRequestProperty("api-key", BREVO_API_KEY);
            conn.setRequestProperty("content-type", "application/json");
            conn.setDoOutput(true);

            String json = "{"
                + "\"sender\":{\"name\":\"SaludBoyaca\",\"email\":\"" + EMAIL_REMIT + "\"},"
                + "\"to\":[{\"email\":\"" + destino + "\"}],"
                + "\"subject\":\"Código OTP\","
                + "\"textContent\":\"Tu código es: " + otp + "\""
                + "}";

            try (OutputStream os = conn.getOutputStream()) {
                os.write(json.getBytes("UTF-8"));
            }

            int responseCode = conn.getResponseCode();
            if (responseCode != 201) {
                System.err.println("Error Brevo API: " + responseCode);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
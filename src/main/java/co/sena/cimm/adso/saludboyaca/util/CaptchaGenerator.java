package co.sena.cimm.adso.saludboyaca.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class CaptchaGenerator {

    private static final String SECRET = "TU_SECRET_KEY";

    public static boolean validar(String token) {

        try {

            String url = "https://www.google.com/recaptcha/api/siteverify"
                    + "?secret=" + SECRET
                    + "&response=" + token;

            HttpURLConnection con = (HttpURLConnection) new URL(url).openConnection();
            con.setRequestMethod("POST");

            BufferedReader in = new BufferedReader(
                    new InputStreamReader(con.getInputStream())
            );

            StringBuilder response = new StringBuilder();
            String line;

            while ((line = in.readLine()) != null) {
                response.append(line);
            }

            in.close();

            return response.toString().contains("\"success\": true");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
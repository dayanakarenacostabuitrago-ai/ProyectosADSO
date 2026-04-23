package karen.adso.biblioteca.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

@WebServlet("/chatbot")
public class ChatbotServlet extends HttpServlet {

    private static final String GROQ_URL   = "https://api.groq.com/openai/v1/chat/completions";
    private static final String MODEL      = "llama-3.1-8b-instant";
    private static final int    MAX_TOKENS = 1024;

    // PON AQUI TU KEY DE GROQ
    private static final String API_KEY = "";

    private static final String SYSTEM_PROMPT
            = "Eres un asistente virtual de la Biblioteca SENA. "
            + "Ayudas con consultas sobre libros, prestamos, multas, autores, categorias y editoriales. "
            + "Responde siempre en espanol con acentos correctos. "
            + "Usa texto plano sin asteriscos ni simbolos markdown. "
            + "Para listas usa guion: - item. "
            + "Se breve y claro.";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/vistas/Chatbot.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json; charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");

        StringBuilder sb = new StringBuilder();
        String ln;
        BufferedReader reader = req.getReader();
        while ((ln = reader.readLine()) != null) sb.append(ln);
        String body = sb.toString();

        try {
            String groqRaw    = callGroqApi(body);
            String textReply  = extractText(groqRaw);
            // Devolver en formato que el frontend ya entiende
            String jsonOut = "{\"content\":[{\"type\":\"text\",\"text\":"
                           + jsonString(textReply) + "}]}";
            resp.getWriter().write(jsonOut);
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":{\"message\":\"" + escJson(e.getMessage()) + "\"}}");
        }
    }

    private String callGroqApi(String frontBody) throws IOException {
        String messagesArray = extractMessages(frontBody);
        String systemMsg = "{\"role\":\"system\",\"content\":" + jsonString(SYSTEM_PROMPT) + "}";

        String fullMessages;
        if (messagesArray.equals("[]")) {
            fullMessages = "[" + systemMsg + "]";
        } else {
            fullMessages = "[" + systemMsg + "," + messagesArray.substring(1);
        }

        String payload = "{\"model\":\"" + MODEL + "\","
                + "\"max_tokens\":" + MAX_TOKENS + ","
                + "\"messages\":" + fullMessages + "}";

        URL url = new URL(GROQ_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setConnectTimeout(15000);
        conn.setReadTimeout(30000);
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setRequestProperty("Authorization", "Bearer " + API_KEY);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(payload.getBytes(StandardCharsets.UTF_8));
        }

        int status = conn.getResponseCode();
        BufferedReader br = new BufferedReader(new InputStreamReader(
                status >= 200 && status < 300
                        ? conn.getInputStream() : conn.getErrorStream(),
                StandardCharsets.UTF_8));

        StringBuilder response = new StringBuilder();
        while ((ln = br.readLine()) != null) response.append(ln);
        br.close();
        return response.toString();
    }

    /**
     * Extrae el texto del campo choices[0].message.content
     * y decodifica secuencias \\uXXXX correctamente.
     */
    private String extractText(String groqJson) {
        // Buscar "content": dentro de message del assistant
        int choicesIdx = groqJson.indexOf("\"choices\"");
        if (choicesIdx == -1) {
            // Es un error — buscar message del error
            int msgIdx = groqJson.indexOf("\"message\":\"");
            if (msgIdx != -1) {
                return decodeJsonString(groqJson, msgIdx + 11);
            }
            return "No se pudo obtener respuesta.";
        }

        // Navegar hasta "content": dentro del primer choice
        int msgIdx = groqJson.indexOf("\"message\"", choicesIdx);
        if (msgIdx == -1) return "Sin contenido.";

        int contentIdx = groqJson.indexOf("\"content\":", msgIdx);
        if (contentIdx == -1) return "Sin contenido.";

        // El valor empieza después de "content":
        int valStart = contentIdx + 10;
        // Saltar espacios
        while (valStart < groqJson.length() && groqJson.charAt(valStart) == ' ') valStart++;
        // Debe ser una comilla
        if (valStart >= groqJson.length() || groqJson.charAt(valStart) != '"') return "Sin contenido.";

        return decodeJsonString(groqJson, valStart + 1);
    }

    /**
     * Lee un string JSON desde la posición dada (justo después de la comilla de apertura)
     * y decodifica escapes: \\n, \\t, \\uXXXX, etc.
     */
    private String decodeJsonString(String json, int start) {
        StringBuilder sb = new StringBuilder();
        int i = start;
        while (i < json.length()) {
            char c = json.charAt(i);
            if (c == '"') break; // fin del string
            if (c == '\\' && i + 1 < json.length()) {
                char next = json.charAt(i + 1);
                switch (next) {
                    case '"':  sb.append('"');  i += 2; break;
                    case '\\': sb.append('\\'); i += 2; break;
                    case '/':  sb.append('/');  i += 2; break;
                    case 'n':  sb.append('\n'); i += 2; break;
                    case 'r':  sb.append('\r'); i += 2; break;
                    case 't':  sb.append('\t'); i += 2; break;
                    case 'u':
                        
                        if (i + 5 < json.length()) {
                            String hex = json.substring(i + 2, i + 6);
                            try {
                                sb.append((char) Integer.parseInt(hex, 16));
                            } catch (NumberFormatException e) {
                                sb.append("\\u").append(hex);
                            }
                            i += 6;
                        } else { sb.append(c); i++; }
                        break;
                    default: sb.append(next); i += 2; break;
                }
            } else {
                sb.append(c);
                i++;
            }
        }
        return sb.toString();
    }

    /** Extrae el array "messages" del JSON del frontend */
    private String extractMessages(String json) {
        int start = json.indexOf("\"messages\"");
        if (start == -1) return "[]";
        int bracket = json.indexOf("[", start);
        if (bracket == -1) return "[]";
        int depth = 0, end = bracket;
        for (int i = bracket; i < json.length(); i++) {
            char c = json.charAt(i);
            if (c == '[') depth++;
            else if (c == ']' && --depth == 0) { end = i; break; }
        }
        return json.substring(bracket, end + 1);
    }

    /** Serializa un String Java como valor JSON con comillas */
    private static String jsonString(String s) {
        if (s == null) return "null";
        return "\"" + escJson(s) + "\"";
    }

    private static String escJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }

    private String ln; // variable auxiliar para while loops
}

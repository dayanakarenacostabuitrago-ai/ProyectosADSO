<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, karen.adso.biblioteca.modelo.Reserva"%>
<%
    List<Reserva> reservas = (List<Reserva>) request.getAttribute("reservas");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Mis Reservas</title>
        <style>
            body {
                font-family: Arial;
                background: #f4f6f9;
            }
            .container {
                width: 80%;
                margin: auto;
            }
            .card {
                background: white;
                padding: 15px;
                margin: 15px 0;
                border-radius: 10px;
                box-shadow: 0px 2px 6px rgba(0,0,0,0.2);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .info {
                line-height: 1.6;
            }
            img {
                border: 1px solid #ccc;
                padding: 5px;
                background: white;
            }
            h2 {
                text-align: center;
            }
        </style>
    </head>   

    <body>
        <div class="container">
            <h2>📚 Mis Reservas</h2>

            <% if (reservas != null && !reservas.isEmpty()) { %>
            <% for (Reserva r : reservas) {%>
            <div class="card">
                <div class="info">
                    <strong>ID:</strong> <%= r.getIdReserva()%><br>
                    <strong>Fecha:</strong> <%= r.getFechaReserva()%><br>
                    <strong>Estado:</strong> <%= r.getEstado()%>
                </div>

                <div>
                    <img src="<%= request.getContextPath()%>/QRServlet?idReserva=<%= r.getIdReserva()%>" width="120"/>
                </div>
            </div>
            <% } %>
            <% } else { %>
            <p>No tienes reservas registradas.</p>
            <% }%>

        </div>
    </body>
</html>
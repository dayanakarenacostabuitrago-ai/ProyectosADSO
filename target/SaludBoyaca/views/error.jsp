<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="es">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title><fmt:message key="error.access.denied"/> – SaludBoyacá</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                body {
                    background: #f4f6f9;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    min-height: 100vh;
                }

                .error-card {
                    max-width: 480px;
                    width: 100%;
                    background: #fff;
                    border-radius: 1rem;
                    box-shadow: 0 4px 24px rgba(0, 0, 0, .10);
                    padding: 2.5rem;
                    text-align: center;
                }

                .error-icon {
                    font-size: 3.5rem;
                    color: #e74c3c;
                    margin-bottom: 1rem;
                }
            </style>
        </head>

        <body>
            <div class="error-card">
                <div class="error-icon"><i class="fas fa-ban"></i></div>
                <h4 class="fw-bold mb-2"><fmt:message key="error.access.denied"/></h4>
                <p class="text-muted mb-4">
                    <c:choose>
                        <c:when test="${not empty errorMensaje}">${errorMensaje}</c:when>
                        <c:otherwise><fmt:message key="error.no.permission"/></c:otherwise>
                    </c:choose>
                </p>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
                    <i class="fas fa-home me-1"></i><fmt:message key="error.back.dashboard"/>
                </a>
            </div>
        </body>

        </html>
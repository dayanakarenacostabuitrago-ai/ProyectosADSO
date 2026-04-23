<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Crear cuenta — Biblioteca SENA</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Estilos.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/extras.css">
        <style>
            :root {
                --azul-oscuro: #0A1628;
                --azul-marino: #0D2855;
                --azul-primario: #1565C0;
                --azul-claro:  #42A5F5;
                --dorado:      #FFD54F;
            }
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                font-family: 'Lato', sans-serif;
                background: var(--azul-oscuro);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 2rem 1rem;
                position: relative;
                overflow: hidden;
            }
            body::before {
                content: '';
                position: fixed;
                inset: 0;
                background:
                    radial-gradient(ellipse 90% 70% at 15% 5%,  rgba(21,101,192,.3)  0%, transparent 55%),
                    radial-gradient(ellipse 70% 60% at 85% 90%, rgba(255,213,79,.07) 0%, transparent 55%),
                    radial-gradient(ellipse 50% 40% at 90% 10%, rgba(66,165,245,.12) 0%, transparent 50%);
                pointer-events: none;
            }
            .particle-bg {
                position: fixed;
                inset: 0;
                pointer-events: none;
                z-index: 0;
                overflow: hidden;
            }
            .particle-bg span {
                position: absolute;
                border-radius: 50%;
                background: rgba(66,165,245,.15);
                animation: floatUp linear infinite;
            }
            @keyframes floatUp {
                from {
                    transform: translateY(0) scale(1);
                    opacity: .6;
                }
                to   {
                    transform: translateY(-110vh) scale(.4);
                    opacity: 0;
                }
            }
            .wrap {
                position: relative;
                z-index: 10;
                width: 100%;
                max-width: 480px;
            }
            .brand {
                text-align: center;
                margin-bottom: 1.4rem;
            }
            .brand-icon {
                width: 54px;
                height: 54px;
                background: linear-gradient(135deg, var(--azul-primario), var(--azul-claro));
                border-radius: 14px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
                margin-bottom: .6rem;
                box-shadow: 0 8px 24px rgba(21,101,192,.4);
            }
            .brand h2 {
                font-family: 'Playfair Display', serif;
                font-size: 1.25rem;
                color: #fff;
                font-weight: 700;
            }
            .brand p {
                font-size: .8rem;
                color: rgba(255,255,255,.4);
                margin-top: .15rem;
            }
            /* Reutilizamos clases de extras.css: registro-card, etc. */
        </style>
    </head>
    <body>
        <div class="particle-bg" id="ptcBg"></div>

        <div class="wrap">
            <div class="brand">
                <div class="brand-icon">📚</div>
                <h2>Biblioteca SENA</h2>
                <p>Gestión Bibliotecaria</p>
            </div>

            <div class="registro-card">
                <div class="registro-title">Crear cuenta</div>
                <div class="registro-subtitle">Regístrate como estudiante para acceder al catálogo</div>

                <%-- Mensaje de error --%>
                <%
                    String error = (String) request.getAttribute("error");
                    if (error != null && !error.isEmpty()) {
                %>
                <div class="alerta-reg alerta-reg-error">
                    <i class="fas fa-exclamation-circle"></i> <%=error%>
                </div>
                <% }%>

                <form action="${pageContext.request.contextPath}/registro" method="post" autocomplete="off">

                    <div class="form-group-reg">
                        <label for="documento"><i class="fas fa-id-card me-1"></i>Número de documento *</label>
                        <input type="text" id="documento" name="documento"
                               placeholder="Ej: 1234567890"
                               maxlength="20" required
                               value="<%=request.getParameter("documento") != null ? request.getParameter("documento") : ""%>">
                    </div>

                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:.75rem">
                        <div class="form-group-reg">
                            <label for="nombres"><i class="fas fa-user me-1"></i>Nombres *</label>
                            <input type="text" id="nombres" name="nombres"
                                   placeholder="Ej: María"
                                   maxlength="80" required
                                   value="<%=request.getParameter("nombres") != null ? request.getParameter("nombres") : ""%>">
                        </div>
                        <div class="form-group-reg">
                            <label for="apellidos"><i class="fas fa-user me-1"></i>Apellidos *</label>
                            <input type="text" id="apellidos" name="apellidos"
                                   placeholder="Ej: García"
                                   maxlength="80" required
                                   value="<%=request.getParameter("apellidos") != null ? request.getParameter("apellidos") : ""%>">
                        </div>
                    </div>

                    <div class="form-group-reg">
                        <label for="email"><i class="fas fa-envelope me-1"></i>Correo electrónico</label>
                        <input type="email" id="email" name="email"
                               placeholder="Ej: maria@sena.edu.co"
                               maxlength="120"
                               value="<%=request.getParameter("email") != null ? request.getParameter("email") : ""%>">
                    </div>

                    <div class="form-group-reg">
                        <label for="telefono"><i class="fas fa-phone me-1"></i>Teléfono</label>
                        <input type="tel" id="telefono" name="telefono"
                               placeholder="Ej: 3001234567"
                               maxlength="20"
                               value="<%=request.getParameter("telefono") != null ? request.getParameter("telefono") : ""%>">
                    </div>

                    <div style="background:rgba(66,165,245,.07);border:1px solid rgba(66,165,245,.15);
                         border-radius:10px;padding:.65rem .9rem;margin:.5rem 0 .75rem;
                         font-size:.8rem;color:rgba(255,255,255,.5);display:flex;gap:.5rem;align-items:flex-start">
                        <i class="fas fa-info-circle" style="color:#42A5F5;margin-top:.1rem;flex-shrink:0"></i>
                        <span>Tu contraseña inicial será tu número de documento. Podrás cambiarla contactando al administrador.</span>
                    </div>

                    <button type="submit" class="btn-registro">
                        <i class="fas fa-user-plus me-2"></i>Crear cuenta
                    </button>
                </form>

                <div class="registro-footer">
                    ¿Ya tienes cuenta?
                    <a href="${pageContext.request.contextPath}/loginServlet">Iniciar sesión</a>
                    <span style="margin:0 .4rem;opacity:.4">·</span>
                    <a href="${pageContext.request.contextPath}/index.jsp">
                        <i class="fas fa-arrow-left" style="font-size:.75rem"></i> Volver al inicio
                    </a>
                </div>
            </div>
        </div>

        <script>
            // Partículas de fondo
            (function () {
                var bg = document.getElementById('ptcBg');
                for (var i = 0; i < 18; i++) {
                    var s = document.createElement('span');
                    var size = Math.random() * 3 + 1.5;
                    s.style.cssText = 'width:' + size + 'px;height:' + size + 'px;' +
                            'left:' + Math.random() * 100 + '%;' +
                            'bottom:-10px;' +
                            'animation-duration:' + (Math.random() * 12 + 8) + 's;' +
                            'animation-delay:-' + (Math.random() * 12) + 's;';
                    bg.appendChild(s);
                }
            })();
        </script>
    </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>500 — Error del Servidor | Biblioteca SENA</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <style>
            *,*::before,*::after{
                box-sizing:border-box;
                margin:0;
                padding:0;
            }
            :root{
                --azul-oscuro:#0A1628;
                --rojo:#f87171;
                --rojo-dark:#c0392b;
                --azul-claro:#42A5F5;
                --dorado:#FFD54F;
            }
            body{
                font-family:'Lato',sans-serif;
                background:var(--azul-oscuro);
                color:#F8FBFF;
                min-height:100vh;
                display:flex;
                flex-direction:column;
                align-items:center;
                justify-content:center;
                overflow:hidden;
                position:relative;
            }

            /* BACKGROUND */
            .bg-glow{
                position:absolute;
                inset:0;
                pointer-events:none;
            }
            .bg-glow::before{
                content:'';
                position:absolute;
                top:-10%;
                right:-10%;
                width:55%;
                height:65%;
                border-radius:50%;
                background:radial-gradient(circle,rgba(192,57,43,.14) 0%,transparent 70%);
            }
            .bg-glow::after{
                content:'';
                position:absolute;
                bottom:-15%;
                left:-5%;
                width:45%;
                height:55%;
                border-radius:50%;
                background:radial-gradient(circle,rgba(21,101,192,.12) 0%,transparent 70%);
            }
            .grid-lines{
                position:absolute;
                inset:0;
                background-image:linear-gradient(rgba(248,113,113,.03) 1px,transparent 1px),linear-gradient(90deg,rgba(248,113,113,.03) 1px,transparent 1px);
                background-size:60px 60px;
                pointer-events:none;
            }

            /* CONTENT */
            .content{
                position:relative;
                z-index:10;
                text-align:center;
                padding:2rem;
            }

            /* GEAR ICON */
            .gear-wrap{
                position:relative;
                display:inline-block;
                margin-bottom:1.5rem;
            }
            .gear-big{
                font-size:4rem;
                color:rgba(248,113,113,.8);
                animation:spin 6s linear infinite;
            }
            .gear-small{
                font-size:2rem;
                color:rgba(248,113,113,.5);
                position:absolute;
                bottom:-5px;
                right:-18px;
                animation:spin 4s linear infinite reverse;
            }
            @keyframes spin{
                to{
                    transform:rotate(360deg)
                }
            }

            /* ERROR CODE */
            .err-code{
                font-family:'Playfair Display',serif;
                font-size:clamp(6rem,16vw,13rem);
                font-weight:900;
                line-height:.9;
                background:linear-gradient(135deg,var(--rojo) 0%,#ff6b6b 40%,#c0392b 100%);
                background-size:200%;
                -webkit-background-clip:text;
                -webkit-text-fill-color:transparent;
                animation:shimmer 3s ease infinite;
                margin-bottom:1.5rem;
                letter-spacing:-4px;
            }
            @keyframes shimmer{
                0%,100%{
                    background-position:0%
                }
                50%{
                    background-position:100%
                }
            }

            /* TITLE & SUBTITLE */
            .err-title{
                font-family:'Playfair Display',serif;
                font-size:clamp(1.3rem,4vw,2rem);
                font-weight:700;
                margin-bottom:.8rem;
            }
            .err-sub{
                color:rgba(248,251,255,.45);
                font-size:1rem;
                max-width:500px;
                line-height:1.8;
                margin:0 auto 2.5rem;
            }

            /* DIVIDER */
            .divider{
                width:60px;
                height:3px;
                background:linear-gradient(90deg,var(--rojo),var(--dorado));
                border-radius:2px;
                margin:1.5rem auto;
            }

            /* ERROR DETAIL COLLAPSIBLE */
            .err-detail{
                background:rgba(248,113,113,.06);
                border:1px solid rgba(248,113,113,.18);
                border-radius:14px;
                padding:1.2rem 1.5rem;
                max-width:600px;
                margin:0 auto 2rem;
                text-align:left;
            }
            .err-detail summary{
                cursor:pointer;
                color:rgba(248,113,113,.7);
                font-size:.85rem;
                font-weight:700;
                letter-spacing:.3px;
                list-style:none;
                display:flex;
                align-items:center;
                gap:.5rem;
            }
            .err-detail summary::-webkit-details-marker{
                display:none;
            }
            .err-detail summary i{
                transition:transform .2s;
            }
            details[open] summary i{
                transform:rotate(90deg);
            }
            .err-detail code{
                display:block;
                margin-top:.8rem;
                font-size:.78rem;
                color:rgba(248,113,113,.6);
                line-height:1.6;
                word-break:break-all;
                background:rgba(0,0,0,.2);
                padding:.75rem 1rem;
                border-radius:8px;
                max-height:150px;
                overflow-y:auto;
            }

            /* BUTTONS */
            .btn-row{
                display:flex;
                gap:1rem;
                justify-content:center;
                flex-wrap:wrap;
            }
            .btn-primary{
                display:inline-flex;
                align-items:center;
                gap:.6rem;
                padding:.8rem 2rem;
                background:linear-gradient(135deg,#1565C0,#42A5F5);
                color:#fff;
                border-radius:50px;
                text-decoration:none;
                font-weight:700;
                font-size:.95rem;
                transition:all .25s;
                box-shadow:0 8px 24px rgba(21,101,192,.4);
            }
            .btn-primary:hover{
                transform:translateY(-3px);
                box-shadow:0 14px 34px rgba(21,101,192,.55);
                color:#fff;
            }
            .btn-retry{
                display:inline-flex;
                align-items:center;
                gap:.6rem;
                padding:.8rem 2rem;
                background:rgba(248,113,113,.12);
                color:var(--rojo);
                border:1.5px solid rgba(248,113,113,.25);
                border-radius:50px;
                text-decoration:none;
                font-weight:700;
                font-size:.95rem;
                transition:all .25s;
                cursor:pointer;
            }
            .btn-retry:hover{
                background:rgba(248,113,113,.22);
                transform:translateY(-2px);
                color:var(--rojo);
            }
            .btn-secondary{
                display:inline-flex;
                align-items:center;
                gap:.6rem;
                padding:.8rem 2rem;
                background:transparent;
                color:rgba(248,251,255,.5);
                border:1.5px solid rgba(255,255,255,.14);
                border-radius:50px;
                text-decoration:none;
                font-weight:600;
                font-size:.95rem;
                transition:all .25s;
            }
            .btn-secondary:hover{
                border-color:rgba(255,255,255,.3);
                color:rgba(248,251,255,.8);
            }

            /* STATUS CHIPS */
            .status-row{
                display:flex;
                gap:1rem;
                justify-content:center;
                flex-wrap:wrap;
                margin-top:2.5rem;
            }
            .status-chip{
                display:flex;
                align-items:center;
                gap:.5rem;
                padding:.45rem 1.1rem;
                background:rgba(255,255,255,.04);
                border:1px solid rgba(255,255,255,.07);
                border-radius:50px;
                font-size:.79rem;
                color:rgba(255,255,255,.38);
            }
            .status-chip i{
                font-size:.75rem;
            }
            .status-ok i{
                color:#4ade80;
            }
            .status-err i{
                color:var(--rojo);
            }
        </style>
    </head>
    <body>
        <div class="bg-glow"></div>
        <div class="grid-lines"></div>

        <div class="content">
            <!-- Gears -->
            <div class="gear-wrap">
                <i class="fas fa-cog gear-big"></i>
                <i class="fas fa-cog gear-small"></i>
            </div>

            <div class="err-code">500</div>
            <div class="divider"></div>
            <h1 class="err-title">Error Interno del Servidor</h1>
            <p class="err-sub">
                Algo salió mal en el servidor de la Biblioteca SENA.<br>
                El equipo técnico ha sido notificado. Por favor intenta de nuevo en unos momentos.
            </p>

            <!-- Error Detail (only in dev — remove in production) -->
            <%if(exception != null){%>
            <details class="err-detail">
                <summary><i class="fas fa-chevron-right"></i> Ver detalle técnico del error</summary>
                <code><%=exception.getClass().getName()%>: <%=exception.getMessage() != null ? exception.getMessage() : "Sin mensaje disponible"%></code>
            </details>
            <%}%>

            <div class="btn-row">
                <button onclick="location.reload()" class="btn-retry">
                    <i class="fas fa-redo"></i> Intentar de Nuevo
                </button>
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn-primary">
                    <i class="fas fa-home"></i> Ir al Inicio
                </a>
                <a href="javascript:history.back()" class="btn-secondary">
                    <i class="fas fa-arrow-left"></i> Volver
                </a>
            </div>

            <div class="status-row">
                <div class="status-chip status-ok"><i class="fas fa-circle"></i> Base de datos activa</div>
                <div class="status-chip status-err"><i class="fas fa-circle"></i> Error en la solicitud</div>
                <div class="status-chip status-ok"><i class="fas fa-circle"></i> Servidor en línea</div>
            </div>
        </div>
    </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, karen.adso.biblioteca.modelo.Reserva, karen.adso.biblioteca.modelo.Usuario"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    String tipoUsuario = (String) session.getAttribute("tipoUsuario");
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/loginServlet");
        return;
    }
    List<Reserva> reservas = (List<Reserva>) request.getAttribute("reservas");
    String mensaje = (String) session.getAttribute("mensaje");
    String tipoMensaje = (String) session.getAttribute("tipoMensaje");
    if (mensaje != null) {
        session.removeAttribute("mensaje");
        session.removeAttribute("tipoMensaje");
    }
    boolean esAdmin = "Administrativo".equals(tipoUsuario) || "Bibliotecario".equals(tipoUsuario);
    int totalRes = 0, pendientes = 0, confirmadas = 0, canceladas = 0;
    if (reservas != null) {
        totalRes = reservas.size();
        for (Reserva r : reservas) {
            String e = r.getEstado();
            if ("Pendiente".equalsIgnoreCase(e)) {
                pendientes++;
            } else if ("Lista".equalsIgnoreCase(e) || "Confirmada".equalsIgnoreCase(e)) {
                confirmadas++;
            } else if ("Cancelada".equalsIgnoreCase(e)) {
                canceladas++;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Mis Reservas — Biblioteca SENA</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Estilos.css">
        <style>
            :root{
                --az:#0A1628;
                --azm:#0D2855;
                --azp:#1565C0;
                --azc:#42A5F5;
                --dor:#FFD54F;
                --bco:#F8FBFF;
            }
            *{
                box-sizing:border-box;
                margin:0;
                padding:0;
            }
            body{
                display:flex;
                min-height:100vh;
                background:var(--az);
                font-family:'Lato',sans-serif;
                color:var(--bco);
                overflow-x:hidden;
            }

            /* ── SIDEBAR ── */
            .sidebar{
                width:252px;
                min-height:100vh;
                position:fixed;
                top:0;
                left:0;
                z-index:100;
                background:linear-gradient(180deg,#0D2855 0%,#081a3d 100%);
                border-right:1px solid rgba(66,165,245,.13);
                display:flex;
                flex-direction:column;
                overflow-y:auto;
            }
            .sb-brand{
                padding:1.4rem 1.4rem .9rem;
                border-bottom:1px solid rgba(255,255,255,.07);
                display:flex;
                align-items:center;
                gap:.55rem;
                text-decoration:none;
            }
            .sb-brand i{
                color:var(--dor);
                font-size:1.4rem;
            }
            .sb-brand h5{
                font-family:'Playfair Display',serif;
                font-size:1.08rem;
                color:var(--bco);
                margin:0;
            }
            .sb-user{
                padding:.7rem 1.4rem .95rem;
                border-bottom:1px solid rgba(255,255,255,.05);
                display:flex;
                align-items:center;
                gap:.7rem;
            }
            .sb-avatar{
                width:38px;
                height:38px;
                border-radius:50%;
                background:linear-gradient(135deg,var(--azp),var(--azc));
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:700;
                font-size:.88rem;
                color:#fff;
                text-transform:uppercase;
            }
            .sb-name{
                font-size:.82rem;
                font-weight:700;
                color:var(--bco);
                line-height:1.3;
            }
            .sb-role{
                font-size:.72rem;
                color:rgba(255,255,255,.45);
            }
            .sb-nav{
                flex:1;
                padding:.5rem 0;
            }
            .sb-section{
                padding:.55rem 1.4rem .25rem;
                font-size:.65rem;
                letter-spacing:.1em;
                text-transform:uppercase;
                color:rgba(255,255,255,.3);
                font-weight:700;
            }
            .sb-link{
                display:flex;
                align-items:center;
                gap:.7rem;
                padding:.6rem 1.4rem;
                text-decoration:none;
                color:rgba(255,255,255,.6);
                font-size:.85rem;
                transition:all .2s;
                border-left:3px solid transparent;
            }
            .sb-link:hover,.sb-link.active{
                background:rgba(66,165,245,.1);
                color:var(--azc);
                border-left-color:var(--azc);
            }
            .sb-link i{
                width:16px;
                text-align:center;
            }
            .sb-footer{
                padding:1rem 1.4rem;
                border-top:1px solid rgba(255,255,255,.07);
            }
            .btn-logout{
                display:flex;
                align-items:center;
                gap:.5rem;
                padding:.55rem 1rem;
                background:rgba(248,113,113,.1);
                color:#f87171;
                border:1px solid rgba(248,113,113,.2);
                border-radius:8px;
                text-decoration:none;
                font-size:.82rem;
                transition:all .2s;
            }
            .btn-logout:hover{
                background:rgba(248,113,113,.22);
                color:#fca5a5;
            }

            /* ── MAIN ── */
            .main{
                margin-left: 78px;
                flex:1;
                padding:2.2rem 2rem;
                min-height:100vh;
            }

            /* ── HEADER ── */
            .pg-header{
                display:flex;
                align-items:center;
                justify-content:space-between;
                margin-bottom:2rem;
                flex-wrap:wrap;
                gap:1rem;
            }
            .pg-title{
                font-family:'Playfair Display',serif;
                font-size:1.75rem;
                font-weight:900;
                background:linear-gradient(135deg,var(--bco),var(--azc));
                -webkit-background-clip:text;
                -webkit-text-fill-color:transparent;
            }
            .pg-sub{
                font-size:.82rem;
                color:rgba(255,255,255,.4);
                margin-top:.3rem;
            }
            .btn-catalogo{
                display:inline-flex;
                align-items:center;
                gap:.45rem;
                padding:.55rem 1.3rem;
                background:linear-gradient(135deg,var(--azp),var(--azc));
                color:#fff;
                border:none;
                border-radius:12px;
                font-size:.84rem;
                font-weight:700;
                text-decoration:none;
                box-shadow:0 4px 15px rgba(66,165,245,.3);
                transition:all .2s;
            }
            .btn-catalogo:hover{
                transform:translateY(-2px);
                box-shadow:0 6px 20px rgba(66,165,245,.45);
                color:#fff;
            }

            /* ── ALERT ── */
            .flash{
                border-radius:12px;
                padding:.85rem 1.2rem;
                margin-bottom:1.4rem;
                display:flex;
                align-items:center;
                gap:.7rem;
                font-size:.88rem;
            }
            .flash-success{
                background:rgba(74,222,128,.12);
                border:1px solid rgba(74,222,128,.3);
                color:#4ade80;
            }
            .flash-danger{
                background:rgba(248,113,113,.1);
                border:1px solid rgba(248,113,113,.25);
                color:#f87171;
            }

            /* ── KPI STRIP ── */
            .kpi-strip{
                display:grid;
                grid-template-columns:repeat(4,1fr);
                gap:1rem;
                margin-bottom:1.8rem;
            }
            @media(max-width:900px){
                .kpi-strip{
                    grid-template-columns:repeat(2,1fr);
                }
            }
            .kpi-tile{
                background:linear-gradient(145deg,rgba(13,40,85,.75),rgba(10,22,40,.95));
                border-radius:16px;
                padding:1.1rem 1.3rem;
                display:flex;
                align-items:center;
                gap:.9rem;
                transition:transform .25s,box-shadow .25s;
                border:1px solid rgba(255,255,255,.06);
            }
            .kpi-tile:hover{
                transform:translateY(-3px);
                box-shadow:0 10px 30px rgba(0,0,0,.4);
            }
            .kpi-ico{
                width:46px;
                height:46px;
                border-radius:12px;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:1.15rem;
                flex-shrink:0;
            }
            .kpi-n{
                font-size:1.7rem;
                font-weight:900;
                line-height:1;
            }
            .kpi-l{
                font-size:.71rem;
                color:rgba(255,255,255,.45);
                margin-top:.2rem;
                font-weight:600;
                text-transform:uppercase;
                letter-spacing:.04em;
            }

            /* ── PANEL ── */
            .panel{
                background:linear-gradient(145deg,rgba(13,40,85,.55),rgba(10,22,40,.9));
                border:1px solid rgba(66,165,245,.1);
                border-radius:20px;
                padding:1.6rem;
                overflow:hidden;
            }
            .panel-title{
                font-family:'Playfair Display',serif;
                font-size:1.1rem;
                color:var(--bco);
                margin-bottom:1.2rem;
                display:flex;
                align-items:center;
                gap:.5rem;
            }
            .panel-title i{
                color:var(--azc);
            }

            /* ── FILTER TABS ── */
            .ftabs{
                display:flex;
                gap:.5rem;
                flex-wrap:wrap;
                margin-bottom:1.3rem;
            }
            .ftab{
                padding:.35rem 1.1rem;
                border-radius:50px;
                font-size:.78rem;
                font-weight:700;
                cursor:pointer;
                border:1px solid rgba(66,165,245,.2);
                background:transparent;
                color:rgba(255,255,255,.45);
                transition:all .2s;
                letter-spacing:.02em;
            }
            .ftab.active,.ftab:hover{
                background:rgba(66,165,245,.15);
                color:var(--azc);
                border-color:var(--azc);
            }

            /* ── RESERVATION CARDS ── */
            .res-grid{
                display:flex;
                flex-direction:column;
                gap:.9rem;
            }
            .res-card{
                background:linear-gradient(135deg,rgba(21,50,100,.6),rgba(10,22,40,.9));
                border:1px solid rgba(66,165,245,.1);
                border-radius:18px;
                padding:1.3rem 1.5rem;
                display:flex;
                align-items:center;
                gap:1.4rem;
                transition:all .25s;
                position:relative;
                overflow:hidden;
            }
            .res-card::before{
                content:'';
                position:absolute;
                left:0;
                top:0;
                bottom:0;
                width:4px;
                border-radius:4px 0 0 4px;
                background:linear-gradient(180deg,var(--azc),var(--azp));
                transition:width .2s;
            }
            .res-card:hover{
                border-color:rgba(66,165,245,.35);
                transform:translateX(5px);
                box-shadow:0 8px 30px rgba(0,0,0,.4);
            }
            .res-card:hover::before{
                width:6px;
            }
            .res-card[data-estado="Pendiente"]::before{
                background:linear-gradient(180deg,#FFD54F,#F9A825);
            }
            .res-card[data-estado="Lista"]::before{
                background:linear-gradient(180deg,#4ade80,#16a34a);
            }
            .res-card[data-estado="Cancelada"]::before{
                background:linear-gradient(180deg,#f87171,#dc2626);
            }

            .res-qr-wrap{
                flex-shrink:0;
                position:relative;
            }
            .res-qr-wrap img{
                border-radius:12px;
                border:2px solid rgba(66,165,245,.25);
                background:#fff;
                padding:5px;
                box-shadow:0 4px 16px rgba(0,0,0,.4);
            }
            .res-qr-badge{
                position:absolute;
                bottom:-6px;
                right:-6px;
                width:22px;
                height:22px;
                border-radius:50%;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:.6rem;
                border:2px solid #0A1628;
                background:#1565C0;
                color:#fff;
            }

            .res-body{
                flex:1;
                min-width:0;
            }
            .res-id{
                font-family:'Playfair Display',serif;
                font-size:1.05rem;
                color:var(--dor);
                font-weight:700;
                margin-bottom:.35rem;
            }
            .res-badge{
                display:inline-flex;
                align-items:center;
                gap:.3rem;
                padding:.28rem .8rem;
                border-radius:50px;
                font-size:.73rem;
                font-weight:700;
                letter-spacing:.03em;
                margin-bottom:.55rem;
            }
            .badge-Pendiente{
                background:rgba(255,213,79,.15);
                color:#FFD54F;
                border:1px solid rgba(255,213,79,.3);
            }
            .badge-Lista,.badge-Confirmada{
                background:rgba(74,222,128,.15);
                color:#4ade80;
                border:1px solid rgba(74,222,128,.3);
            }
            .badge-Cancelada{
                background:rgba(248,113,113,.12);
                color:#f87171;
                border:1px solid rgba(248,113,113,.25);
            }
            .res-meta{
                display:flex;
                flex-wrap:wrap;
                gap:.4rem 1.2rem;
            }
            .res-meta-i{
                font-size:.8rem;
                color:rgba(255,255,255,.5);
                display:flex;
                align-items:center;
                gap:.3rem;
            }
            .res-meta-i i{
                color:var(--azc);
                font-size:.72rem;
            }
            .res-libro{
                font-size:.85rem;
                color:rgba(255,255,255,.75);
                font-weight:600;
                margin-bottom:.3rem;
                white-space:nowrap;
                overflow:hidden;
                text-overflow:ellipsis;
            }

            .res-right{
                flex-shrink:0;
                display:flex;
                flex-direction:column;
                gap:.5rem;
                align-items:flex-end;
            }
            .btn-print-res{
                display:inline-flex;
                align-items:center;
                gap:.35rem;
                padding:.4rem .9rem;
                background:rgba(255,213,79,.1);
                color:var(--dor);
                border:1px solid rgba(255,213,79,.25);
                border-radius:9px;
                font-size:.75rem;
                font-weight:700;
                cursor:pointer;
                text-decoration:none;
                transition:all .2s;
            }
            .btn-print-res:hover{
                background:rgba(255,213,79,.22);
                color:var(--dor);
            }

            /* ── EMPTY STATE ── */
            .empty{
                text-align:center;
                padding:4rem 2rem;
            }
            .empty svg{
                opacity:.2;
                margin-bottom:1.2rem;
            }
            .empty h4{
                color:rgba(248,251,255,.5);
                font-size:1.1rem;
                margin-bottom:.5rem;
            }
            .empty p{
                color:rgba(248,251,255,.3);
                font-size:.85rem;
            }

            /* ── MODAL COMPROBANTE ── */
            .modal-comp{
                display:none;
                position:fixed;
                inset:0;
                background:rgba(0,0,0,.85);
                z-index:9999;
                align-items:center;
                justify-content:center;
                padding:20px;
            }
            .modal-comp.show{
                display:flex;
            }

            /* Contenedor del ticket */
            .ticket-container{
                background:#fff;
                width:400px;
                max-width:100%;
                border-radius:12px;
                overflow:hidden;
                box-shadow:0 20px 60px rgba(0,0,0,.5);
            }

            /* Vista previa en pantalla */
            .ticket-screen{
                display:block;
            }

            /* Header azul */
            .ticket-header{
                background:linear-gradient(135deg,#0D2855,#1565C0);
                padding:20px;
                text-align:center;
                color:#fff;
            }
            .ticket-header .logo{
                font-family:'Playfair Display',serif;
                font-size:1.3rem;
                font-weight:700;
                margin-bottom:5px;
            }
            .ticket-header .logo i{
                color:#FFD54F;
                margin-right:8px;
            }
            .ticket-header .subtitle{
                font-size:.75rem;
                opacity:.8;
                text-transform:uppercase;
                letter-spacing:1px;
            }

            /* Cuerpo del ticket */
            .ticket-body{
                padding:25px;
                background:#fff;
            }

            /* Tabla de información */
            .ticket-table{
                width:100%;
                border-collapse:collapse;
                margin-bottom:20px;
            }
            .ticket-table td{
                padding:10px 0;
                border-bottom:1px dashed #ddd;
                vertical-align:top;
            }
            .ticket-table td:first-child{
                width:40%;
                color:#666;
                font-weight:600;
                font-size:.85rem;
            }
            .ticket-table td:last-child{
                color:#333;
                font-weight:700;
                font-size:.9rem;
                text-align:right;
            }
            .ticket-table tr:last-child td{
                border-bottom:none;
            }

            /* Número de reserva destacado */
            .reserva-numero{
                text-align:center;
                margin-bottom:20px;
                padding-bottom:20px;
                border-bottom:2px dashed #eee;
            }
            .reserva-numero .label{
                font-size:.75rem;
                color:#999;
                text-transform:uppercase;
                letter-spacing:1px;
                margin-bottom:5px;
            }
            .reserva-numero .numero{
                font-family:'Playfair Display',serif;
                font-size:2rem;
                color:#1565C0;
                font-weight:900;
            }

            /* QR */
            .ticket-qr{
                text-align:center;
                margin:20px 0;
            }
            .ticket-qr img{
                width:120px;
                height:120px;
                border:2px solid #eee;
                border-radius:8px;
                padding:5px;
            }

            /* Footer del ticket */
            .ticket-footer{
                background:#f8f9fa;
                padding:15px;
                text-align:center;
                font-size:.8rem;
                color:#666;
            }

            /* Botones */
            .ticket-actions{
                display:flex;
                gap:10px;
                justify-content:center;
                padding:15px;
                background:#fff;
                border-top:1px solid #eee;
            }
            .btn-ticket{
                padding:10px 20px;
                border-radius:8px;
                font-size:.85rem;
                font-weight:600;
                cursor:pointer;
                border:none;
                display:flex;
                align-items:center;
                gap:5px;
            }
            .btn-ticket.print{
                background:linear-gradient(135deg,#1565C0,#42A5F5);
                color:#fff;
            }
            .btn-ticket.close{
                background:#f1f3f4;
                color:#5f6368;
                border:1px solid #dadce0;
            }

            /* ── ESTILOS DE IMPRESIÓN ── */
            @media print{
                @page{
                    size:auto;
                    margin:0;
                }

                /* Ocultar TODO excepto el modal */
                body > *{
                    display:none !important;
                }

                /* Mostrar solo el modal */
                .modal-comp{
                    display:block !important;
                    position:static !important;
                    background:none !important;
                    padding:0 !important;
                    width:100% !important;
                    height:auto !important;
                }

                /* El contenedor del ticket */
                .ticket-container{
                    width:100% !important;
                    max-width:none !important;
                    box-shadow:none !important;
                    border-radius:0 !important;
                }

                /* Ocultar acciones */
                .ticket-actions{
                    display:none !important;
                }

                /* Forzar colores */
                .ticket-header{
                    background:#0D2855 !important;
                    -webkit-print-color-adjust:exact !important;
                    print-color-adjust:exact !important;
                    color:#fff !important;
                }

                .ticket-footer{
                    background:#f8f9fa !important;
                    -webkit-print-color-adjust:exact !important;
                    print-color-adjust:exact !important;
                }

                /* Asegurar que todo sea visible */
                *{
                    visibility:visible !important;
                }
            }

            /* ─── SIDEBAR DASHBOARD ─── */
            .sb{position:fixed;left:0;top:0;bottom:0;width:78px;
                background:#0C1424;border-right:1px solid rgba(66,165,245,.1);
                display:flex;flex-direction:column;align-items:center;
                padding:1.4rem 0 1.2rem;gap:.18rem;z-index:200}
            .sb-logo{width:42px;height:42px;border-radius:13px;
                background:linear-gradient(135deg,#1565C0,#42A5F5);
                display:flex;align-items:center;justify-content:center;
                color:#fff;font-size:1.1rem;margin-bottom:1.6rem;
                box-shadow:0 0 35px rgba(66,165,245,.14)}
            .ni{width:52px;height:52px;border-radius:13px;display:flex;
                flex-direction:column;align-items:center;justify-content:center;
                gap:3px;text-decoration:none;color:#5E7A96;font-size:.51rem;
                font-weight:700;text-transform:uppercase;letter-spacing:.04em;
                transition:all .28s cubic-bezier(.4,0,.2,1);
                border:1px solid transparent;position:relative;cursor:pointer}
            .ni i{font-size:.92rem;transition:transform .28s cubic-bezier(.4,0,.2,1)}
            .ni:hover{background:rgba(66,165,245,.08);color:#90CAF9;
                border-color:rgba(66,165,245,.1)}
            .ni:hover i{transform:scale(1.18) translateY(-1px)}
            .ni.act{background:linear-gradient(135deg,rgba(21,101,192,.45),rgba(66,165,245,.22));
                color:#42A5F5;border-color:rgba(66,165,245,.3);
                box-shadow:0 0 35px rgba(66,165,245,.14)}
            .ni.act::before{content:'';position:absolute;left:-1px;top:50%;
                transform:translateY(-50%);width:3px;height:62%;
                background:#42A5F5;border-radius:0 3px 3px 0}
            .sb-sep{width:30px;height:1px;background:rgba(66,165,245,.1);margin:.55rem 0}
            .sb-bot{margin-top:auto;display:flex;flex-direction:column;
                align-items:center;gap:.45rem}
            .sb-av{width:38px;height:38px;border-radius:50%;
                background:linear-gradient(135deg,#42A5F5,#7C3AED);
                display:flex;align-items:center;justify-content:center;
                color:#fff;font-weight:700;font-size:.88rem;
                border:2px solid rgba(66,165,245,.3);cursor:pointer;
                transition:all .28s cubic-bezier(.4,0,.2,1)}
            .sb-av:hover{transform:scale(1.08);box-shadow:0 0 35px rgba(66,165,245,.14)}
        </style>
    </head>
    <body>

        <!-- SIDEBAR -->
                <aside class="sb">
            <div class="sb-logo"><i class="fas fa-book-open"></i></div>
            <a href="${pageContext.request.contextPath}/DashboardServlet" class="ni" title="Inicio"><i class="fas fa-chart-pie"></i><span>Inicio</span></a>
            <a href="${pageContext.request.contextPath}/LibroServlet" class="ni" title="Libros"><i class="fas fa-book"></i><span>Libros</span></a>
            <a href="${pageContext.request.contextPath}/PrestamoServlet" class="ni" title="Préstamos"><i class="fas fa-hand-holding-heart"></i><span>Préstamos</span></a>
            <a href="${pageContext.request.contextPath}/ReservaServlet" class="ni act" title="Reservas"><i class="fas fa-calendar-check"></i><span>Reservas</span></a>
            <a href="${pageContext.request.contextPath}/MultaServlet" class="ni" title="Multas"><i class="fas fa-file-invoice-dollar"></i><span>Multas</span></a>
            <% if ("Administrativo".equals(tipoUsuario) || "Bibliotecario".equals(tipoUsuario)) { %><div class="sb-sep"></div>
            <a href="${pageContext.request.contextPath}/UsuarioServlet" class="ni" title="Usuarios"><i class="fas fa-users"></i><span>Usuarios</span></a>
            <% if ("Administrativo".equals(tipoUsuario)) { %>
            <a href="${pageContext.request.contextPath}/AutorServlet" class="ni" title="Autores"><i class="fas fa-feather-alt"></i><span>Autores</span></a>
            <a href="${pageContext.request.contextPath}/CategoriaServlet" class="ni" title="Categ."><i class="fas fa-tags"></i><span>Categ.</span></a>
            <a href="${pageContext.request.contextPath}/EditorialServlet" class="ni" title="Edit."><i class="fas fa-building"></i><span>Edit.</span></a>
            <% } %><% } %>
            <div class="sb-bot">
                <div class="ni" onclick="location.href='${pageContext.request.contextPath}/loginServlet?accion=logout'" title="Salir" style="color:rgba(248,113,113,.7)"><i class="fas fa-sign-out-alt"></i><span>Salir</span></div>
                <div class="sb-av" title="<%=usuarioSesion.getNombres()%> <%=usuarioSesion.getApellidos()%>"><%=usuarioSesion.getNombres().charAt(0)%></div>
            </div>
        </aside>

        <!-- MAIN -->
        <main class="main">

            <div class="pg-header">
                <div>
                    <div class="pg-title"><i class="fas fa-calendar-check me-2" style="color:var(--azc);-webkit-text-fill-color:var(--azc);"></i>Mis Reservas</div>
                    <div class="pg-sub">Consulta y gestiona tus reservas de libros activas</div>
                </div>
                <a href="${pageContext.request.contextPath}/LibroServlet" class="btn-catalogo">
                    <i class="fas fa-book"></i> Ver catálogo
                </a>
            </div>

            <% if (mensaje != null) {%>
            <div class="flash flash-<%=tipoMensaje%>">
                <i class="fas fa-<%="success".equals(tipoMensaje) ? "check-circle" : "exclamation-circle"%>"></i> <%=mensaje%>
            </div>
            <% }%>

            <!-- KPIs -->
            <div class="kpi-strip">
                <div class="kpi-tile" style="border-color:rgba(66,165,245,.25);">
                    <div class="kpi-ico" style="background:rgba(66,165,245,.15);color:var(--azc);"><i class="fas fa-list-ul"></i></div>
                    <div><div class="kpi-n" style="color:var(--azc);"><%=totalRes%></div><div class="kpi-l">Total</div></div>
                </div>
                <div class="kpi-tile" style="border-color:rgba(255,213,79,.25);">
                    <div class="kpi-ico" style="background:rgba(255,213,79,.15);color:var(--dor);"><i class="fas fa-clock"></i></div>
                    <div><div class="kpi-n" style="color:var(--dor);"><%=pendientes%></div><div class="kpi-l">Pendientes</div></div>
                </div>
                <div class="kpi-tile" style="border-color:rgba(74,222,128,.25);">
                    <div class="kpi-ico" style="background:rgba(74,222,128,.15);color:#4ade80;"><i class="fas fa-check-circle"></i></div>
                    <div><div class="kpi-n" style="color:#4ade80;"><%=confirmadas%></div><div class="kpi-l">Listas</div></div>
                </div>
                <div class="kpi-tile" style="border-color:rgba(248,113,113,.2);">
                    <div class="kpi-ico" style="background:rgba(248,113,113,.12);color:#f87171;"><i class="fas fa-times-circle"></i></div>
                    <div><div class="kpi-n" style="color:#f87171;"><%=canceladas%></div><div class="kpi-l">Canceladas</div></div>
                </div>
            </div>

            <!-- Panel + listado -->
            <div class="panel">
                <div class="panel-title"><i class="fas fa-layer-group"></i> Historial de reservas</div>

                <!-- Filtros -->
                <div class="ftabs">
                    <button class="ftab active" onclick="filtrar(this, 'todas')">
                        Todas <span style="opacity:.5;margin-left:.3rem;"><%=totalRes%></span>
                    </button>
                    <button class="ftab" onclick="filtrar(this, 'Pendiente')">
                        🟡 Pendientes <span style="opacity:.5;margin-left:.3rem;"><%=pendientes%></span>
                    </button>
                    <button class="ftab" onclick="filtrar(this, 'Lista')">
                        🟢 Listas <span style="opacity:.5;margin-left:.3rem;"><%=confirmadas%></span>
                    </button>
                    <button class="ftab" onclick="filtrar(this, 'Cancelada')">
                        🔴 Canceladas <span style="opacity:.5;margin-left:.3rem;"><%=canceladas%></span>
                    </button>
                </div>

                <div class="res-grid" id="resGrid">
                    <% if (reservas != null && !reservas.isEmpty()) {
                            for (Reserva r : reservas) {
                                String est = r.getEstado() != null ? r.getEstado() : "Pendiente";
                                String ico = "clock";
                                if ("Lista".equalsIgnoreCase(est) || "Confirmada".equalsIgnoreCase(est)) {
                                    ico = "check-circle";
                                } else if ("Cancelada".equalsIgnoreCase(est)) {
                                    ico = "times-circle";
                                }
                                String titulo = r.getTituloLibro() != null ? r.getTituloLibro() : "Libro #" + r.getIdLibro();
                                String usuario = r.getNombreUsuario() != null ? r.getNombreUsuario() + " " + r.getApellidoUsuario() : "";
                                String fecha = r.getFechaReserva() != null ? r.getFechaReserva().toString() : "—";
                    %>
                    <div class="res-card" data-estado="<%=est%>">
                        <div class="res-qr-wrap">
                            <img src="<%=request.getContextPath()%>/QRServlet?idReserva=<%=r.getIdReserva()%>" width="88" height="88" alt="QR #<%=r.getIdReserva()%>" loading="lazy"/>
                            <div class="res-qr-badge"><i class="fas fa-qrcode"></i></div>
                        </div>
                        <div class="res-body">
                            <div class="res-id">Reserva #<%=r.getIdReserva()%></div>
                            <div class="res-libro" title="<%=titulo%>"><i class="fas fa-book me-1" style="color:var(--azc);font-size:.8rem;"></i><%=titulo%></div>
                            <div class="res-badge badge-<%=est%>"><i class="fas fa-<%=ico%>"></i> <%=est%></div>
                            <div class="res-meta">
                                <div class="res-meta-i"><i class="fas fa-calendar-alt"></i> <%=fecha%></div>
                                <% if (r.getFechaReserva() != null) {%>
                                <div class="res-meta-i"><i class="fas fa-hourglass-end"></i> Exp: <%=r.getFechaReserva()%></div>
                                <% }%>
                            </div>
                        </div>
                        <div class="res-right">
                            <button class="btn-print-res" onclick="abrirComprobante(<%=r.getIdReserva()%>, '<%=titulo.replace("'", "\\'")%>', '<%=est%>', '<%=fecha%>', '<%=usuario.replace("'", "\\'")%>')">
                                <i class="fas fa-file-alt"></i> Comprobante
                            </button>
                        </div>
                    </div>
                    <% }
                    } else { %>
                    <div class="empty">
                        <svg width="80" height="80" viewBox="0 0 80 80" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <circle cx="40" cy="40" r="38" stroke="#42A5F5" stroke-width="2"/>
                        <path d="M25 52 Q40 22 55 52" stroke="#42A5F5" stroke-width="2.5" fill="none" stroke-linecap="round"/>
                        <circle cx="30" cy="38" r="3" fill="#42A5F5"/>
                        <circle cx="50" cy="38" r="3" fill="#42A5F5"/>
                        </svg>
                        <h4>Sin reservas registradas</h4>
                        <p>Explora el catálogo y reserva el libro que necesites.</p>
                        <a href="${pageContext.request.contextPath}/LibroServlet" class="btn-catalogo" style="margin-top:1rem;display:inline-flex;">
                            <i class="fas fa-book"></i> Explorar catálogo
                        </a>
                    </div>
                    <% }%>
                </div>
            </div>
        </main>

        <!-- COMPROBANTE MODAL -->
        <div class="modal-comp" id="modalComp">
            <div class="ticket-container">
                <div class="ticket-header">
                    <div class="logo"><i class="fas fa-book-open"></i>Biblioteca SENA</div>
                    <div class="subtitle">Comprobante de Reserva</div>
                </div>

                <div class="ticket-body">
                    <div class="reserva-numero">
                        <div class="label">N° de Reserva</div>
                        <div class="numero" id="cp-id">#000</div>
                    </div>

                    <table class="ticket-table">
                        <tr>
                            <td><i class="fas fa-book" style="margin-right:5px;color:#1565C0;"></i>Libro</td>
                            <td id="cp-libro">—</td>
                        </tr>
                        <tr>
                            <td><i class="fas fa-user" style="margin-right:5px;color:#1565C0;"></i>Solicitante</td>
                            <td id="cp-user">—</td>
                        </tr>
                        <tr>
                            <td><i class="fas fa-calendar" style="margin-right:5px;color:#1565C0;"></i>Fecha</td>
                            <td id="cp-fecha">—</td>
                        </tr>
                        <tr>
                            <td><i class="fas fa-tag" style="margin-right:5px;color:#1565C0;"></i>Estado</td>
                            <td id="cp-estado">—</td>
                        </tr>
                    </table>

                    <div class="ticket-qr">
                        <img id="cp-qr" src="" width="120" height="120" alt="Código QR">
                    </div>
                </div>

                <div class="ticket-footer">
                    Presenta este comprobante al recoger tu libro en la biblioteca
                </div>

                <div class="ticket-actions">
                    <button class="btn-ticket print" onclick="imprimirComp()">
                        <i class="fas fa-print"></i> Imprimir
                    </button>
                    <button class="btn-ticket close" onclick="cerrarComp()">
                        Cerrar
                    </button>
                </div>
            </div>
        </div>

        <script>
            function filtrar(btn, estado) {
                document.querySelectorAll('.ftab').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                document.querySelectorAll('.res-card').forEach(c => {
                    c.style.display = (estado === 'todas' || c.dataset.estado === estado) ? 'flex' : 'none';
                });
            }

            function abrirComprobante(id, titulo, estado, fecha, usuario) {
                document.getElementById('cp-id').textContent = '#' + id;
                document.getElementById('cp-libro').textContent = titulo;
                document.getElementById('cp-user').textContent = usuario || '—';
                document.getElementById('cp-fecha').textContent = fecha;

                const estadoEl = document.getElementById('cp-estado');
                let color = '#F9A825';
                if (estado === 'Lista' || estado === 'Confirmada')
                    color = '#2e7d32';
                else if (estado === 'Cancelada')
                    color = '#c62828';

                estadoEl.innerHTML = `<span style="color:${color};font-weight:700;">${estado}</span>`;

                document.getElementById('cp-qr').src = '${pageContext.request.contextPath}/QRServlet?idReserva=' + id;
                document.getElementById('modalComp').classList.add('show');
            }

            function cerrarComp() {
                document.getElementById('modalComp').classList.remove('show');
            }

            function imprimirComp() {
                window.print();
            }

            document.getElementById('modalComp').addEventListener('click', function (e) {
                if (e.target === this)
                    cerrarComp();
            });
        </script>
    </body>
</html>
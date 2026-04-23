<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, karen.adso.biblioteca.modelo.*, karen.adso.biblioteca.modelo.Usuario"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    String tipoUsuario = (String) session.getAttribute("tipoUsuario");
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/loginServlet");
        return;
    }
    Multa multa = (Multa) request.getAttribute("multa");
    boolean esPago = (multa != null && request.getAttribute("modoEditar") == null);
    boolean modoEditar = (multa != null && Boolean.TRUE.equals(request.getAttribute("modoEditar")));
    List<Prestamo> prestamos = (List<Prestamo>) request.getAttribute("prestamos");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%= modoEditar ? "Editar Multa" : esPago ? "Registrar Pago" : "Nueva Multa"%> — Biblioteca SENA</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Estilos.css">
        <style>
            :root{
                --azul-oscuro:#0A1628;
                --azul-marino:#0D2855;
                --azul-primario:#1565C0;
                --azul-claro:#42A5F5;
                --dorado:#FFD54F;
                --blanco:#F8FBFF;
                
                
                
                
                
            }
            .panel-body{
                display:flex;
                min-height:100vh;
                background:var(--azul-oscuro);
            }
            
            
            
            .sb-brand 
            
            
            
            
            
            
            
            
            
            .btn-logout:hover{
                background:rgba(248,81,73,0.1);
            }
            /* Ajuste main content */
            .main-c,.main-content{
                margin-left:76px;
            }
            .main-c{
                margin-left:76px;
                flex:1;
                padding:2.8rem 3.2rem;
            }
            .ph{
                display:flex;
                align-items:flex-start;
                justify-content:space-between;
                flex-wrap:wrap;
                gap:1rem;
                margin-bottom:2.4rem;
                padding-bottom:1.2rem;
                border-bottom:1px solid rgba(66,165,245,.1);
            }
            .ph-title{
                font-family:'Playfair Display',serif;
                font-size:2rem;
                font-weight:800;
                color:var(--blanco);
            }
            .ph-title span{
                color:#f87171;
            }
            .ph-title span.blue{
                color:var(--azul-claro);
            }
            .ph-sub{
                color:rgba(248,251,255,.42);
                font-size:.87rem;
                margin-top:.18rem;
            }
            .btn-back{
                display:inline-flex;
                align-items:center;
                gap:.5rem;
                padding:.55rem 1.35rem;
                background:rgba(21,101,192,.18);
                border:1px solid rgba(66,165,245,.22);
                border-radius:50px;
                color:var(--azul-claro);
                font-size:.87rem;
                font-weight:700;
                text-decoration:none;
                transition:all .2s;
            }
            .btn-back:hover{
                background:rgba(66,165,245,.18);
                color:var(--azul-claro);
                transform:translateX(-3px);
            }
            .f-card{
                background:linear-gradient(150deg,rgba(13,40,85,.72),rgba(10,22,40,.92));
                border:1px solid rgba(66,165,245,.14);
                border-radius:24px;
                padding:2.4rem 2.6rem;
                backdrop-filter:blur(16px);
                box-shadow:0 24px 64px rgba(0,0,0,.38);
                max-width:640px;
                animation:fup .5s ease both;
            }
            @keyframes fup{
                from{
                    opacity:0;
                    transform:translateY(26px)
                }
                to{
                    opacity:1;
                    transform:translateY(0)
                }
            }
            .multa-summary{
                background:rgba(248,113,113,.07);
                border:1px solid rgba(248,113,113,.2);
                border-radius:16px;
                padding:1.4rem 1.6rem;
                margin-bottom:2rem;
            }
            .ms-row{
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding:.5rem 0;
                border-bottom:1px solid rgba(248,113,113,.1);
            }
            .ms-row:last-child{
                border:none;
                padding-top:.75rem;
                margin-top:.25rem;
            }
            .ms-key{
                font-size:.82rem;
                color:rgba(255,255,255,.45);
            }
            .ms-val{
                font-size:.9rem;
                color:var(--blanco);
                font-weight:700;
            }
            .ms-monto{
                font-size:1.6rem;
                font-weight:800;
                color:#f87171;
                font-family:'Playfair Display',serif;
            }
            .monto-display{
                display:flex;
                align-items:center;
                gap:1rem;
                padding:1.2rem 1.5rem;
                background:rgba(248,113,113,.07);
                border:1px solid rgba(248,113,113,.18);
                border-radius:14px;
                margin-bottom:.5rem;
            }
            .monto-display .sign{
                font-size:1.3rem;
                font-weight:700;
                color:#f87171;
            }
            .monto-display .amount{
                font-family:'Playfair Display',serif;
                font-size:2.2rem;
                font-weight:900;
                color:#f87171;
                line-height:1;
            }
            .monto-display .currency{
                font-size:.85rem;
                color:rgba(248,113,113,.6);
                margin-top:.3rem;
            }
            .f-sec{
                display:flex;
                align-items:center;
                gap:.55rem;
                font-size:.79rem;
                text-transform:uppercase;
                letter-spacing:1px;
                font-weight:700;
                color:var(--azul-claro);
                margin-bottom:1.1rem;
                margin-top:1.6rem;
            }
            .f-sec:first-child{
                margin-top:0;
            }
            .f-sec::after{
                content:'';
                flex:1;
                height:1px;
                background:rgba(66,165,245,.14);
            }
            .f-sec.danger{
                color:#f87171;
            }
            .f-sec.danger::after{
                background:rgba(248,113,113,.18);
            }
            .f-group{
                margin-bottom:1.3rem;
            }
            .f-lbl{
                display:block;
                color:rgba(248,251,255,.72);
                font-size:.84rem;
                font-weight:700;
                margin-bottom:.42rem;
            }
            .f-lbl .req{
                color:#f87171;
            }
            .f-inp,.f-sel{
                width:100%;
                background:rgba(6,14,28,.65)!important;
                border:1.5px solid rgba(66,165,245,.17)!important;
                color:var(--blanco)!important;
                border-radius:12px!important;
                padding:.75rem 1.05rem!important;
                font-size:.9rem!important;
                font-family:'Lato',sans-serif;
                transition:border-color .25s,box-shadow .25s!important;
                outline:none;
            }
            .f-inp:focus,.f-sel:focus{
                border-color:var(--azul-claro)!important;
                box-shadow:0 0 0 3.5px rgba(66,165,245,.17)!important;
            }
            .f-inp::placeholder{
                color:rgba(255,255,255,.2)!important;
            }
            .f-sel option{
                background:var(--azul-marino);
            }
            .f-hint{
                font-size:.76rem;
                color:rgba(255,255,255,.28);
                margin-top:.3rem;
            }
            input[type="date"]::-webkit-calendar-picker-indicator{
                filter:invert(.6);
                cursor:pointer;
            }
            input[type="number"]::-webkit-inner-spin-button{
                filter:invert(.5);
            }
            .f-hr{
                border:none;
                border-top:1px solid rgba(66,165,245,.1);
                margin:1.8rem 0;
            }
            .btn-danger-go{
                display:inline-flex;
                align-items:center;
                gap:.6rem;
                padding:.72rem 2.1rem;
                border:none;
                border-radius:50px;
                background:linear-gradient(135deg,#c0392b,#f87171);
                color:#fff;
                font-weight:800;
                font-size:.95rem;
                cursor:pointer;
                transition:all .25s;
                box-shadow:0 6px 22px rgba(248,113,113,.28);
            }
            .btn-danger-go:hover{
                transform:translateY(-3px);
                box-shadow:0 12px 34px rgba(248,113,113,.42);
            }
            .btn-go{
                display:inline-flex;
                align-items:center;
                gap:.6rem;
                padding:.72rem 2.1rem;
                border:none;
                border-radius:50px;
                background:linear-gradient(135deg,#4ade80,#16a34a);
                color:#0A1628;
                font-weight:800;
                font-size:.95rem;
                cursor:pointer;
                transition:all .25s;
                box-shadow:0 6px 22px rgba(74,222,128,.28);
            }
            .btn-go:hover{
                transform:translateY(-3px);
                box-shadow:0 12px 34px rgba(74,222,128,.38);
            }
            .btn-blue-go{
                display:inline-flex;
                align-items:center;
                gap:.6rem;
                padding:.72rem 2.1rem;
                border:none;
                border-radius:50px;
                background:linear-gradient(135deg,var(--azul-primario),var(--azul-claro));
                color:#fff;
                font-weight:800;
                font-size:.95rem;
                cursor:pointer;
                transition:all .25s;
                box-shadow:0 6px 22px rgba(66,165,245,.28);
            }
            .btn-blue-go:hover{
                transform:translateY(-3px);
                box-shadow:0 12px 34px rgba(66,165,245,.38);
            }
            .btn-cx{
                display:inline-flex;
                align-items:center;
                gap:.5rem;
                padding:.72rem 1.6rem;
                border-radius:50px;
                border:1.5px solid rgba(255,255,255,.13);
                color:rgba(255,255,255,.5);
                font-size:.9rem;
                font-weight:600;
                text-decoration:none;
                transition:all .2s;
            }
            .btn-cx:hover{
                border-color:rgba(255,255,255,.28);
                color:rgba(255,255,255,.78);
            }
            .tip{
                font-size:.77rem;
                color:rgba(255,255,255,.27);
                margin-bottom:1.4rem;
            }
            .tip .req{
                color:#f87171;
            }
            .quick-amounts{
                display:flex;
                flex-wrap:wrap;
                gap:.4rem;
                margin-top:.6rem;
            }
            .qa{
                padding:.28rem .9rem;
                border-radius:50px;
                font-size:.79rem;
                cursor:pointer;
                background:rgba(248,113,113,.08);
                border:1px solid rgba(248,113,113,.2);
                color:#f87171;
                font-weight:700;
                transition:all .18s;
            }
            .qa:hover{
                background:rgba(248,113,113,.2);
                border-color:#f87171;
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
            .main-c{margin-left:78px!important}
        </style>
    </head>
    <body class="panel-body">

                <aside class="sb">
            <div class="sb-logo"><i class="fas fa-book-open"></i></div>
            <a href="${pageContext.request.contextPath}/DashboardServlet" class="ni" title="Inicio"><i class="fas fa-chart-pie"></i><span>Inicio</span></a>
            <a href="${pageContext.request.contextPath}/LibroServlet" class="ni" title="Libros"><i class="fas fa-book"></i><span>Libros</span></a>
            <a href="${pageContext.request.contextPath}/PrestamoServlet" class="ni" title="Préstamos"><i class="fas fa-hand-holding-heart"></i><span>Préstamos</span></a>
            <a href="${pageContext.request.contextPath}/ReservaServlet" class="ni" title="Reservas"><i class="fas fa-calendar-check"></i><span>Reservas</span></a>
            <a href="${pageContext.request.contextPath}/MultaServlet" class="ni act" title="Multas"><i class="fas fa-file-invoice-dollar"></i><span>Multas</span></a>
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

        <main class="main-c">
            <div class="ph">
                <div>
                    <div class="ph-title">
                        <%if (modoEditar) {%><span class="blue">Editar</span> Multa
                        <%} else if (esPago) {%><span>Registrar</span> Pago
                        <%} else {%><span>Nueva</span> Multa<%}%>
                    </div>
                    <div class="ph-sub">
                        <%if (modoEditar) {%>Modifica el monto y estado de la multa #<%=multa.getIdMulta()%>
                        <%} else if (esPago) {%>Confirma el pago de la multa #<%=multa.getIdMulta()%> del préstamo #<%=multa.getIdPrestamo()%>
                        <%} else {%>Genera una nueva multa por devolución tardía<%}%>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/MultaServlet" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Volver a Multas
                </a>
            </div>

            <div class="f-card">

                <%-- ═══ MODO PAGO ══════════════════════════════════ --%>
                <%if (esPago) {%>
                <div class="multa-summary">
                    <div class="ms-row"><span class="ms-key"><i class="fas fa-hashtag me-1"></i>ID Multa</span><span class="ms-val">#<%=multa.getIdMulta()%></span></div>
                    <div class="ms-row"><span class="ms-key"><i class="fas fa-hand-holding-heart me-1"></i>Préstamo</span><span class="ms-val">#<%=multa.getIdPrestamo()%></span></div>
                    <div class="ms-row"><span class="ms-key"><i class="fas fa-calendar me-1"></i>Fecha generación</span><span class="ms-val"><%=multa.getFechaGeneracion() != null ? multa.getFechaGeneracion().toString().substring(0, 10) : "—"%></span></div>
                    <div class="ms-row"><span class="ms-key">Monto a pagar</span><span class="ms-monto">$<%=String.format("%.2f", multa.getMonto())%></span></div>
                </div>
                <form action="${pageContext.request.contextPath}/MultaServlet" method="post">
                    <input type="hidden" name="accion" value="registrarPago">
                    <input type="hidden" name="id"     value="<%=multa.getIdMulta()%>">
                    <div class="f-sec"><i class="fas fa-calendar-check"></i> Fecha de Pago</div>
                    <div class="f-group">
                        <label class="f-lbl" for="fechaPago">Fecha en que se realiza el pago <span class="req">*</span></label>
                        <input type="date" id="fechaPago" name="fechaPago" class="f-inp" required>
                        <p class="f-hint"><i class="fas fa-info-circle me-1"></i>Dejar la fecha actual si el pago es hoy</p>
                    </div>
                    <hr class="f-hr">
                    <div class="d-flex gap-3 flex-wrap align-items-center">
                        <button type="submit" class="btn-go" onclick="return confirm('¿Confirmar el pago de $<%=String.format("%.2f", multa.getMonto())%>?')">
                            <i class="fas fa-money-bill-wave"></i> Confirmar Pago
                        </button>
                        <a href="${pageContext.request.contextPath}/MultaServlet" class="btn-cx"><i class="fas fa-times"></i> Cancelar</a>
                    </div>
                </form>

                <%-- ═══ MODO EDITAR ══════════════════════════════════ --%>
                <%} else if (modoEditar) {%>
                <div class="multa-summary">
                    <div class="ms-row"><span class="ms-key"><i class="fas fa-hashtag me-1"></i>ID Multa</span><span class="ms-val">#<%=multa.getIdMulta()%></span></div>
                    <div class="ms-row"><span class="ms-key"><i class="fas fa-hand-holding-heart me-1"></i>Préstamo</span><span class="ms-val">#<%=multa.getIdPrestamo()%></span></div>
                </div>
                <form action="${pageContext.request.contextPath}/MultaServlet" method="post">
                    <input type="hidden" name="accion" value="actualizar">
                    <input type="hidden" name="id"     value="<%=multa.getIdMulta()%>">
                    <div class="f-sec"><i class="fas fa-pen"></i> Editar Multa</div>
                    <div class="f-group">
                        <label class="f-lbl" for="montoEdit">Monto <span class="req">*</span></label>
                        <div class="monto-display" id="montoDisplay">
                            <span class="sign">$</span>
                            <div><div class="amount" id="montoVal"><%=String.format("%.2f", multa.getMonto())%></div><div class="currency">COP / Pesos</div></div>
                        </div>
                        <input type="number" id="montoEdit" name="monto" class="f-inp"
                               value="<%=multa.getMonto()%>" min="0" step="500" required
                               oninput="updateMonto(this.value)">
                        <div class="quick-amounts">
                            <span class="qa" onclick="setMonto(2000)">$2.000</span>
                            <span class="qa" onclick="setMonto(5000)">$5.000</span>
                            <span class="qa" onclick="setMonto(10000)">$10.000</span>
                            <span class="qa" onclick="setMonto(20000)">$20.000</span>
                            <span class="qa" onclick="setMonto(50000)">$50.000</span>
                        </div>
                    </div>
                    <div class="f-group">
                        <label class="f-lbl" for="estadoEdit">Estado <span class="req">*</span></label>
                        <select id="estadoEdit" name="estado" class="f-sel" required>
                            <option value="Pendiente" <%="Pendiente".equals(multa.getEstado()) ? "selected" : ""%>>Pendiente</option>
                            <option value="Pagado"    <%="Pagado".equals(multa.getEstado()) ? "selected" : ""%>>Pagado</option>
                        </select>
                    </div>
                    <hr class="f-hr">
                    <div class="d-flex gap-3 flex-wrap align-items-center">
                        <button type="submit" class="btn-blue-go">
                            <i class="fas fa-save"></i> Guardar Cambios
                        </button>
                        <a href="${pageContext.request.contextPath}/MultaServlet" class="btn-cx"><i class="fas fa-times"></i> Cancelar</a>
                    </div>
                </form>

                <%-- ═══ MODO NUEVA MULTA ══════════════════════════ --%>
                <%} else {%>
                <p class="tip"><span class="req">*</span> Campos obligatorios</p>
                <form action="${pageContext.request.contextPath}/MultaServlet" method="post">
                    <input type="hidden" name="accion" value="insertar">
                    <div class="f-sec danger"><i class="fas fa-exclamation-triangle"></i> Datos de la Multa</div>
                    <div class="f-group">
                        <label class="f-lbl" for="idPrestamo">Préstamo asociado <span class="req">*</span></label>
                        <select id="idPrestamo" name="idPrestamo" class="f-sel" required>
                            <option value="">— Selecciona el préstamo —</option>
                            <%if (prestamos != null) {
                                    for (Prestamo p : prestamos) {%>
                            <option value="<%=p.getIdPrestamo()%>">📋 Préstamo #<%=p.getIdPrestamo()%> — <%=p.getTituloLibro() != null ? p.getTituloLibro() : "Libro #" + p.getIdLibro()%> / <%=p.getNombreUsuario() != null ? p.getNombreUsuario() : "Usuario #" + p.getIdUsuario()%></option>
                            <%}
                                }%>
                        </select>
                        <p class="f-hint">Solo se muestran préstamos activos o en curso</p>
                    </div>
                    <div class="f-group">
                        <label class="f-lbl" for="monto">Monto de la multa <span class="req">*</span></label>
                        <div class="monto-display" id="montoDisplay">
                            <span class="sign">$</span>
                            <div><div class="amount" id="montoVal">0.00</div><div class="currency">COP / Pesos</div></div>
                        </div>
                        <input type="number" id="monto" name="monto" class="f-inp"
                               placeholder="Ej: 5000" min="0" step="500" required
                               oninput="updateMonto(this.value)">
                        <p class="f-hint">Montos rápidos:</p>
                        <div class="quick-amounts">
                            <span class="qa" onclick="setMonto(2000)">$2.000</span>
                            <span class="qa" onclick="setMonto(5000)">$5.000</span>
                            <span class="qa" onclick="setMonto(10000)">$10.000</span>
                            <span class="qa" onclick="setMonto(15000)">$15.000</span>
                            <span class="qa" onclick="setMonto(20000)">$20.000</span>
                            <span class="qa" onclick="setMonto(50000)">$50.000</span>
                        </div>
                    </div>
                    <div class="f-group">
                        <label class="f-lbl" for="fechaGeneracion">Fecha de generación <span class="req">*</span></label>
                        <input type="date" id="fechaGeneracion" name="fechaGeneracion" class="f-inp" required>
                    </div>
                    <hr class="f-hr">
                    <div class="d-flex gap-3 flex-wrap align-items-center">
                        <button type="submit" class="btn-danger-go">
                            <i class="fas fa-file-invoice-dollar"></i> Generar Multa
                        </button>
                        <a href="${pageContext.request.contextPath}/MultaServlet" class="btn-cx"><i class="fas fa-times"></i> Cancelar</a>
                    </div>
                </form>
                <%}%>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                const today = new Date().toISOString().split('T')[0];
                                const fpInput = document.getElementById('fechaPago');
                                const fgInput = document.getElementById('fechaGeneracion');
                                if (fpInput)
                                    fpInput.value = today;
                                if (fgInput)
                                    fgInput.value = today;

                                function updateMonto(v) {
                                    const el = document.getElementById('montoVal');
                                    if (el)
                                        el.textContent = parseFloat(v || 0).toLocaleString('es-CO', {minimumFractionDigits: 2});
                                }
                                function setMonto(v) {
                                    const inp = document.getElementById('monto') || document.getElementById('montoEdit');
                                    if (inp) {
                                        inp.value = v;
                                        updateMonto(v);
                                    }
                                }
        </script>
               <%@ include file="/WEB-INF/vistas/Chatbot.jsp" %>

    </body>
</html>
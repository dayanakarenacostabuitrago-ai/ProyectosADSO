<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="karen.adso.biblioteca.modelo.Categoria, karen.adso.biblioteca.modelo.Usuario"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    String tipoUsuario = (String) session.getAttribute("tipoUsuario");
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/loginServlet");
        return;
    }
    Categoria categoria = (Categoria) request.getAttribute("categoria");
    boolean esEdicion = (categoria != null);
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%= esEdicion ? "Editar Categoría" : "Nueva Categoría"%> — Biblioteca SENA</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Estilos.css">
        <style>
            :root{
                --azul-oscuro:#0A1628;
                --azul-marino:#0D2855;
                --azul-primario:#1565C0;
                --azul-medio:#1976D2;
                --azul-claro:#42A5F5;
                --dorado:#FFD54F;
                --blanco:#F8FBFF;
                
                
                
                
                
            }
            .panel-body{
                font-family:'Lato',sans-serif;
                background:var(--azul-oscuro);
                color:var(--blanco);
                min-height:100vh;
                display:flex
            }
            
            
            
            .sb-brand 
            
            
            
            
            
            
            
            
            
            .btn-logout:hover{
                background:rgba(248,81,73,0.1);
            }
            /* Ajuste main content */
            .main-c,.main-content{
                margin-left:76px;
            }
            /* Main */
            .main-content{
                margin-left:76px;
                flex:1;
                padding:2.5rem 3rem
            }
            .pg-header{
                display:flex;
                align-items:center;
                justify-content:space-between;
                flex-wrap:wrap;
                gap:1rem;
                margin-bottom:2.5rem;
                padding-bottom:1.25rem;
                border-bottom:1px solid rgba(66,165,245,.1)
            }
            .pg-title{
                font-family:'Playfair Display',serif;
                font-size:2rem;
                font-weight:800
            }
            .pg-title span{
                color:var(--dorado)
            }
            .pg-sub{
                color:rgba(255,255,255,.45);
                font-size:.88rem;
                margin-top:.2rem
            }
            .btn-back{
                display:inline-flex;
                align-items:center;
                gap:.5rem;
                padding:.55rem 1.4rem;
                border-radius:50px;
                background:rgba(66,165,245,.1);
                border:1px solid rgba(66,165,245,.25);
                color:var(--azul-claro);
                font-size:.875rem;
                font-weight:700;
                text-decoration:none;
                transition:all .2s
            }
            .btn-back:hover{
                background:rgba(66,165,245,.2);
                color:var(--azul-claro);
                transform:translateX(-3px)
            }
            /* Form card */
            .form-card{
                max-width:580px;
                background:linear-gradient(145deg,rgba(13,40,85,.85),rgba(10,22,40,.95));
                border:1px solid rgba(66,165,245,.13);
                border-radius:24px;
                padding:2.5rem;
                box-shadow:0 20px 60px rgba(0,0,0,.35);
                backdrop-filter:blur(12px);
                position:relative;
                overflow:hidden
            }
            .form-card::before{
                content:'';
                position:absolute;
                top:-80px;
                right:-80px;
                width:200px;
                height:200px;
                background:radial-gradient(circle,rgba(255,213,79,.07) 0%,transparent 70%);
                pointer-events:none
            }
            .card-icon{
                width:62px;
                height:62px;
                border-radius:18px;
                margin-bottom:1.4rem;
                background:linear-gradient(135deg,rgba(255,213,79,.15),rgba(21,101,192,.25));
                border:1px solid rgba(255,213,79,.2);
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:1.6rem
            }
            .card-title2{
                font-family:'Playfair Display',serif;
                font-size:1.35rem;
                font-weight:800;
                margin-bottom:.2rem
            }
            .card-sub2{
                color:rgba(255,255,255,.4);
                font-size:.85rem;
                margin-bottom:1.8rem
            }
            /* Fields */
            .flabel{
                display:block;
                color:rgba(255,255,255,.75);
                font-size:.83rem;
                font-weight:700;
                margin-bottom:.45rem;
                letter-spacing:.3px
            }
            .flabel .req{
                color:#f87171;
                margin-left:2px
            }
            .iwrap{
                position:relative
            }
            .iwrap .iico{
                position:absolute;
                left:1rem;
                top:50%;
                transform:translateY(-50%);
                color:var(--azul-claro);
                font-size:.9rem;
                pointer-events:none
            }
            .finput{
                width:100%;
                background:rgba(255,255,255,.05)!important;
                border:1.5px solid rgba(66,165,245,.18)!important;
                color:var(--blanco)!important;
                border-radius:12px!important;
                padding:.8rem 1rem .8rem 2.8rem!important;
                font-size:.95rem!important;
                transition:border-color .25s,box-shadow .25s!important
            }
            .finput:focus{
                outline:none!important;
                border-color:var(--dorado)!important;
                box-shadow:0 0 0 4px rgba(255,213,79,.1)!important;
                background:rgba(255,255,255,.08)!important
            }
            .finput::placeholder{
                color:rgba(255,255,255,.22)!important
            }
            .char-count{
                font-size:.75rem;
                color:rgba(255,255,255,.3);
                text-align:right;
                margin-top:.3rem
            }
            .char-count b{
                color:var(--azul-claro)
            }
            /* Icon picker */
            .picker-lbl{
                color:rgba(255,255,255,.42);
                font-size:.8rem;
                margin-bottom:.5rem;
                display:block
            }
            .icon-picker{
                display:flex;
                gap:.55rem;
                flex-wrap:wrap
            }
            .icon-opt{
                width:48px;
                height:48px;
                border-radius:12px;
                background:rgba(255,255,255,.05);
                border:2px solid rgba(255,255,255,.07);
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:1.1rem;
                cursor:pointer;
                transition:all .2s;
                color:rgba(255,255,255,.45)
            }
            .icon-opt:hover{
                background:rgba(255,213,79,.1);
                border-color:rgba(255,213,79,.4);
                color:var(--dorado);
                transform:scale(1.1)
            }
            .icon-opt.sel{
                background:rgba(255,213,79,.15);
                border-color:var(--dorado);
                color:var(--dorado);
                transform:scale(1.1)
            }
            /* Separator */
            .sep{
                border:none;
                border-top:1px solid rgba(66,165,245,.1);
                margin:1.75rem 0
            }
            /* Action buttons */
            .btn-gold{
                display:inline-flex;
                align-items:center;
                gap:.6rem;
                padding:.75rem 2rem;
                border-radius:50px;
                border:none;
                background:linear-gradient(135deg,#e6a800,var(--dorado));
                color:#0A1628;
                font-size:.95rem;
                font-weight:800;
                cursor:pointer;
                transition:all .25s;
                letter-spacing:.3px
            }
            .btn-gold:hover{
                transform:translateY(-3px);
                box-shadow:0 8px 28px rgba(255,213,79,.35)
            }
            .btn-cancel2{
                display:inline-flex;
                align-items:center;
                gap:.6rem;
                padding:.75rem 1.6rem;
                border-radius:50px;
                background:transparent;
                border:1.5px solid rgba(255,255,255,.12);
                color:rgba(255,255,255,.55);
                font-size:.9rem;
                font-weight:600;
                text-decoration:none;
                transition:all .2s
            }
            .btn-cancel2:hover{
                border-color:rgba(255,255,255,.3);
                color:rgba(255,255,255,.85)
            }
            /* Tip box */
            .tip-box{
                background:rgba(66,165,245,.07);
                border:1px solid rgba(66,165,245,.15);
                border-radius:12px;
                padding:1rem 1.2rem;
                margin-top:2rem;
                display:flex;
                gap:.75rem;
                align-items:flex-start
            }
            .tip-box i{
                color:var(--azul-claro);
                font-size:1rem;
                flex-shrink:0;
                margin-top:.1rem
            }
            .tip-box p{
                color:rgba(255,255,255,.48);
                font-size:.82rem;
                margin:0;
                line-height:1.55
            }
            @media(max-width:768px){
                
                .main-content{
                    margin-left:0;
                    padding:1.5rem 1rem
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
            .main-content{margin-left:78px!important}
        </style>
    </head>
    <%@ include file="/WEB-INF/vistas/Chatbot.jsp" %>
    <body class="panel-body">

        <!-- ══════════ SIDEBAR ══════════ -->
                <aside class="sb">
            <div class="sb-logo"><i class="fas fa-book-open"></i></div>
            <a href="${pageContext.request.contextPath}/DashboardServlet" class="ni" title="Inicio"><i class="fas fa-chart-pie"></i><span>Inicio</span></a>
            <a href="${pageContext.request.contextPath}/LibroServlet" class="ni" title="Libros"><i class="fas fa-book"></i><span>Libros</span></a>
            <a href="${pageContext.request.contextPath}/PrestamoServlet" class="ni" title="Préstamos"><i class="fas fa-hand-holding-heart"></i><span>Préstamos</span></a>
            <a href="${pageContext.request.contextPath}/ReservaServlet" class="ni" title="Reservas"><i class="fas fa-calendar-check"></i><span>Reservas</span></a>
            <a href="${pageContext.request.contextPath}/MultaServlet" class="ni" title="Multas"><i class="fas fa-file-invoice-dollar"></i><span>Multas</span></a>
            <% if ("Administrativo".equals(tipoUsuario) || "Bibliotecario".equals(tipoUsuario)) { %><div class="sb-sep"></div>
            <a href="${pageContext.request.contextPath}/UsuarioServlet" class="ni" title="Usuarios"><i class="fas fa-users"></i><span>Usuarios</span></a>
            <% if ("Administrativo".equals(tipoUsuario)) { %>
            <a href="${pageContext.request.contextPath}/AutorServlet" class="ni" title="Autores"><i class="fas fa-feather-alt"></i><span>Autores</span></a>
            <a href="${pageContext.request.contextPath}/CategoriaServlet" class="ni act" title="Categ."><i class="fas fa-tags"></i><span>Categ.</span></a>
            <a href="${pageContext.request.contextPath}/EditorialServlet" class="ni" title="Edit."><i class="fas fa-building"></i><span>Edit.</span></a>
            <% } %><% } %>
            <div class="sb-bot">
                <div class="ni" onclick="location.href='${pageContext.request.contextPath}/loginServlet?accion=logout'" title="Salir" style="color:rgba(248,113,113,.7)"><i class="fas fa-sign-out-alt"></i><span>Salir</span></div>
                <div class="sb-av" title="<%=usuarioSesion.getNombres()%> <%=usuarioSesion.getApellidos()%>"><%=usuarioSesion.getNombres().charAt(0)%></div>
            </div>
        </aside>

        <!-- ══════════ CONTENIDO ══════════ -->
        <main class="main-content">

            <!-- Encabezado de página -->
            <div class="pg-header">
                <div>
                    <div class="pg-title">
                        <i class="fas fa-tags me-2" style="color:var(--dorado);font-size:1.5rem;vertical-align:middle"></i>
                        <%= esEdicion ? "<span>Editar</span> Categoría" : "Nueva <span>Categoría</span>"%>
                    </div>
                    <div class="pg-sub">
                        <%= esEdicion
                                ? "Actualiza el nombre e ícono de esta categoría"
                                : "Crea una nueva clasificación temática para el catálogo"%>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/CategoriaServlet" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Volver a Categorías
                </a>
            </div>

            <!-- Tarjeta formulario -->
            <div class="form-card">

                <div class="card-icon"><i class="fas fa-tags" style="color:var(--dorado)"></i></div>
                <div class="card-title2"><%= esEdicion ? "Editar categoría" : "Registrar nueva categoría"%></div>
                <div class="card-sub2">Los campos marcados con <span style="color:#f87171">*</span> son obligatorios.</div>

                <form action="${pageContext.request.contextPath}/CategoriaServlet" method="post" id="frmCat" novalidate>
                    <input type="hidden" name="accion" value="<%= esEdicion ? "actualizar" : "insertar"%>">
                    <% if (esEdicion) {%>
                    <input type="hidden" name="id" value="<%=categoria.getId()%>">
                    <% }%>

                    <!-- Nombre -->
                    <div class="mb-4">
                        <label class="flabel" for="nombre">Nombre de la categoría <span class="req">*</span></label>
                        <div class="iwrap">
                            <i class="fas fa-tag iico"></i>
                            <input
                                type="text" id="nombre" name="nombre"
                                class="form-control finput"
                                placeholder="Ej: Literatura Colombiana, Inteligencia Artificial..."
                                value="<%= esEdicion ? categoria.getNombre() : ""%>"
                                maxlength="80" required autocomplete="off"
                                oninput="document.getElementById('cnt').textContent=this.value.length"
                                >
                        </div>
                        <div class="char-count"><b id="cnt"><%= esEdicion ? categoria.getNombre().length() : 0%></b> / 80 caracteres</div>
                    </div>

                    <!-- Descripcion -->
                    <div class="mb-4 mt-3">
                        <label class="flabel" for="descripcion">
                            <i class="fas fa-align-left me-1"></i>
                            Descripcion <span style="color:rgba(255,255,255,.4); font-size:.8rem">(opcional)</span>
                        </label>
                        <textarea
                            id="descripcion" name="descripcion"
                            class="form-control finput"
                            placeholder="Describe brevemente esta categoria..."
                            maxlength="300" rows="3"
                            style="resize:vertical;"
                            ><%= esEdicion && categoria.getDescripcion() != null ? categoria.getDescripcion() : ""%></textarea>
                        <div class="char-count">
                            <b id="cntDesc"><%= esEdicion && categoria.getDescripcion() != null ? categoria.getDescripcion().length() : 0%></b> / 300 caracteres
                        </div>
                    </div>

                    <hr class="sep">

                    <!-- Icono decorativo -->
                    <div class="mb-1">
                        <span class="picker-lbl"><i class="fas fa-palette me-1"></i> Elige un ícono representativo <span style="color:rgba(255,255,255,.3)">(opcional)</span></span>
                        <div class="icon-picker" id="iconPicker">
                            <div class="icon-opt sel"  data-icon="fa-bookmark"    title="Marcador"    onclick="pickIcon(this)"><i class="fas fa-bookmark"></i></div>
                            <div class="icon-opt"      data-icon="fa-star"        title="Destacado"   onclick="pickIcon(this)"><i class="fas fa-star"></i></div>
                            <div class="icon-opt"      data-icon="fa-flask"       title="Ciencias"    onclick="pickIcon(this)"><i class="fas fa-flask"></i></div>
                            <div class="icon-opt"      data-icon="fa-globe"       title="Geografía"   onclick="pickIcon(this)"><i class="fas fa-globe"></i></div>
                            <div class="icon-opt"      data-icon="fa-brain"       title="Psicología"  onclick="pickIcon(this)"><i class="fas fa-brain"></i></div>
                            <div class="icon-opt"      data-icon="fa-calculator"  title="Matemáticas" onclick="pickIcon(this)"><i class="fas fa-calculator"></i></div>
                            <div class="icon-opt"      data-icon="fa-music"       title="Arte"        onclick="pickIcon(this)"><i class="fas fa-music"></i></div>
                            <div class="icon-opt"      data-icon="fa-code"        title="Tecnología"  onclick="pickIcon(this)"><i class="fas fa-code"></i></div>
                            <div class="icon-opt"      data-icon="fa-leaf"        title="Naturaleza"  onclick="pickIcon(this)"><i class="fas fa-leaf"></i></div>
                            <div class="icon-opt"      data-icon="fa-gavel"       title="Derecho"     onclick="pickIcon(this)"><i class="fas fa-gavel"></i></div>
                            <div class="icon-opt"      data-icon="fa-heartbeat"   title="Salud"       onclick="pickIcon(this)"><i class="fas fa-heartbeat"></i></div>
                            <div class="icon-opt"      data-icon="fa-rocket"      title="Innovación"  onclick="pickIcon(this)"><i class="fas fa-rocket"></i></div>
                        </div>
                        <input type="hidden" name="icono" id="icoVal" value="fa-bookmark">
                    </div>

                    <hr class="sep">

                    <!-- Acciones -->
                    <div class="d-flex gap-3 align-items-center flex-wrap">
                        <button type="submit" class="btn-gold" id="btnSubmit">
                            <i class="fas fa-<%= esEdicion ? "save" : "plus-circle"%>"></i>
                            <%= esEdicion ? "Guardar Cambios" : "Crear Categoría"%>
                        </button>
                        <a href="${pageContext.request.contextPath}/CategoriaServlet" class="btn-cancel2">
                            <i class="fas fa-times"></i> Cancelar
                        </a>
                    </div>
                </form>

                <!-- Consejo -->
                <div class="tip-box">
                    <i class="fas fa-lightbulb"></i>
                    <p>
                        Una buena categoría es corta y descriptiva.
                        Evita nombres muy genéricos como <em>"Otros"</em>.
                        Ejemplos ideales:
                        <strong style="color:var(--azul-claro)">Novela Histórica</strong>,
                        <strong style="color:var(--azul-claro)">Programación Web</strong>,
                        <strong style="color:var(--azul-claro)">Biología Molecular</strong>.
                    </p>
                </div>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                function pickIcon(el) {
                                    document.querySelectorAll('.icon-opt').forEach(o => o.classList.remove('sel'));
                                    el.classList.add('sel');
                                    document.getElementById('icoVal').value = el.dataset.icon;
                                }
                                document.getElementById('frmCat').addEventListener('submit', function (e) {
                                    const inp = document.getElementById('nombre');
                                    if (!inp.value.trim()) {
                                        e.preventDefault();
                                        inp.style.borderColor = '#f87171';
                                        inp.style.boxShadow = '0 0 0 4px rgba(248,113,113,.15)';
                                        inp.focus();
                                    }
                                });
        </script>
        <%@ include file="/WEB-INF/vistas/Chatbot.jsp" %>

    </body>
</html>
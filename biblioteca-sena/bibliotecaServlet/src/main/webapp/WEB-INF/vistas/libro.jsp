<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, karen.adso.biblioteca.modelo.Libro, karen.adso.biblioteca.modelo.Usuario"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    String tipoUsuario = (String) session.getAttribute("tipoUsuario");
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/loginServlet");
        return;
    }
    List<Libro> libros = (List<Libro>) request.getAttribute("libros");
    String mensaje = (String) session.getAttribute("mensaje");
    String tipoMensaje = (String) session.getAttribute("tipoMensaje");
    session.removeAttribute("mensaje");
    session.removeAttribute("tipoMensaje");
    boolean esAdmin = "Administrativo".equals(tipoUsuario) || "Bibliotecario".equals(tipoUsuario);
    int totalDisp = 0, totalNDisp = 0;
    if (libros != null)
        for (Libro l : libros) {
            if (l.getDisponible() == 1) {
                totalDisp++;
            } else {
                totalNDisp++;
            }
        }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Catálogo — Biblioteca SENA</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Estilos.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/panel.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
        <style>
            /* ══════════════════════════════════════════════════
               VARIABLES Y ESTILOS BASE DEL DASHBOARD (Sidebar)
            ══════════════════════════════════════════════════ */
            :root{
                --bg:#080E1A;
                --bg2:#0C1424;
                --card:#101C30;
                --hover:#162034;
                --border:rgba(66,165,245,.1);
                --border2:rgba(66,165,245,.22);
                --b1:#0D47A1;
                --b2:#1565C0;
                --b3:#1976D2;
                --b4:#42A5F5;
                --b5:#90CAF9;
                --cyan:#00BCD4;
                --violet:#7C3AED;
                --indigo:#4F46E5;
                --green:#10B981;
                --amber:#F59E0B;
                --red:#EF4444;
                --txt:#EDF5FF;
                --txt2:#5E7A96;
                --txt3:#324558;
                --gB:0 0 35px rgba(66,165,245,.14);
                --gR:0 0 35px rgba(239,68,68,.18);
                --r:16px;
                --r2:10px;
                --r3:7px;
                --s1:0 2px 16px rgba(0,0,0,.4);
                --s2:0 6px 36px rgba(0,0,0,.5);
                --dur:.28s;
                --ease:cubic-bezier(.4,0,.2,1);
            }

            /* ─── SIDEBAR DEL DASHBOARD ─── */
            .sb{
                position:fixed;
                left:0;
                top:0;
                bottom:0;
                width:78px;
                background:var(--bg2);
                border-right:1px solid var(--border);
                display:flex;
                flex-direction:column;
                align-items:center;
                padding:1.4rem 0 1.2rem;
                gap:.18rem;
                z-index:200
            }
            .sb-logo{
                width:42px;
                height:42px;
                border-radius:13px;
                background:linear-gradient(135deg,var(--b2),var(--b4));
                display:flex;
                align-items:center;
                justify-content:center;
                color:#fff;
                font-size:1.1rem;
                margin-bottom:1.6rem;
                box-shadow:var(--gB);
                animation:pop .5s var(--ease) both
            }
            @keyframes pop{
                from{
                    opacity:0;
                    transform:scale(.6)
                }
                to{
                    opacity:1;
                    transform:scale(1)
                }
            }
            .ni{
                width:52px;
                height:52px;
                border-radius:13px;
                display:flex;
                flex-direction:column;
                align-items:center;
                justify-content:center;
                gap:3px;
                text-decoration:none;
                color:var(--txt2);
                font-size:.51rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:.04em;
                transition:all var(--dur) var(--ease);
                border:1px solid transparent;
                position:relative;
                cursor:pointer
            }
            .ni i{
                font-size:.92rem;
                transition:transform var(--dur) var(--ease)
            }
            .ni:hover{
                background:rgba(66,165,245,.08);
                color:var(--b5);
                border-color:var(--border)
            }
            .ni:hover i{
                transform:scale(1.18) translateY(-1px)
            }
            .ni.act{
                background:linear-gradient(135deg,rgba(21,101,192,.45),rgba(66,165,245,.22));
                color:var(--b4);
                border-color:rgba(66,165,245,.3);
                box-shadow:var(--gB)
            }
            .ni.act::before{
                content:'';
                position:absolute;
                left:-1px;
                top:50%;
                transform:translateY(-50%);
                width:3px;
                height:62%;
                background:var(--b4);
                border-radius:0 3px 3px 0
            }
            .sb-sep{
                width:30px;
                height:1px;
                background:var(--border);
                margin:.55rem 0
            }
            .sb-bot{
                margin-top:auto;
                display:flex;
                flex-direction:column;
                align-items:center;
                gap:.45rem
            }
            .sb-av{
                width:38px;
                height:38px;
                border-radius:50%;
                background:linear-gradient(135deg,var(--b4),var(--violet));
                display:flex;
                align-items:center;
                justify-content:center;
                color:#fff;
                font-weight:700;
                font-size:.88rem;
                border:2px solid rgba(66,165,245,.3);
                cursor:pointer;
                transition:all var(--dur) var(--ease)
            }
            .sb-av:hover{
                transform:scale(1.08);
                box-shadow:var(--gB)
            }

            /* ─── AJUSTE MAIN CONTENT PARA NUEVO SIDEBAR ─── */
            .main-content {
                margin-left: 78px !important;
                min-height: 100vh;
                background: var(--bg);
            }

            /* Scrollbar personalizado */
            ::-webkit-scrollbar{
                width:4px;
                height:4px
            }
            ::-webkit-scrollbar-track{
                background:transparent
            }
            ::-webkit-scrollbar-thumb{
                background:rgba(66,165,245,.2);
                border-radius:4px
            }
            ::-webkit-scrollbar-thumb:hover{
                background:var(--b4)
            }

            /* ══════════════════════════════════════════════════
               SELECT PERSONALIZADO (sin flechas nativas)
            ══════════════════════════════════════════════════ */
            .select-wrapper {
                position: relative;
                display: inline-block;
            }

            .select-wrapper::after {
                content: '\f107';
                font-family: 'Font Awesome 6 Free';
                font-weight: 900;
                position: absolute;
                right: 12px;
                top: 50%;
                transform: translateY(-50%);
                color: var(--b4);
                font-size: 0.8rem;
                pointer-events: none;
            }

            select.form-select {
                background-color: rgba(66,165,245,.07);
                border: 1px solid rgba(66,165,245,.25);
                color: var(--txt);
                appearance: none;
                -webkit-appearance: none;
                -moz-appearance: none;
                background-image: none !important;
                padding-right: 35px;
                font-size: 0.85rem;
            }

            select.form-select:focus {
                background-color: rgba(66,165,245,.12);
                border-color: var(--b4);
                box-shadow: 0 0 0 0.2rem rgba(66,165,245,.15);
                color: var(--txt);
            }

            select.form-select option {
                background-color: var(--bg2);
                color: var(--txt);
            }

            /* ══════════════════════════════════════════════════
               TOGGLE VISTA
            ══════════════════════════════════════════════════ */
            .vista-toggle {
                display:flex;
                gap:.4rem;
            }
            .btn-vista {
                width:36px;
                height:36px;
                border-radius:8px;
                border:1px solid rgba(66,165,245,.25);
                background:rgba(66,165,245,.07);
                color:rgba(255,255,255,.5);
                display:flex;
                align-items:center;
                justify-content:center;
                cursor:pointer;
                transition:all .2s;
                font-size:.85rem;
            }
            .btn-vista.active, .btn-vista:hover {
                background:rgba(66,165,245,.2);
                color:var(--b4);
                border-color:rgba(66,165,245,.5);
            }

            /* ══════════════════════════════════════════════════
               GRID CATÁLOGO
            ══════════════════════════════════════════════════ */
            .catalogo-grid {
                display:grid;
                grid-template-columns:repeat(auto-fill, minmax(200px,1fr));
                gap:2rem;
                margin-top:.5rem;
            }

            /* ══════════════════════════════════════════════════
               LIBRO-CARD — ESTILO LOMO DE LIBRO
            ══════════════════════════════════════════════════ */
            .libro-card {
                position:relative;
                cursor:pointer;
                border-radius:4px 14px 14px 4px;
                overflow:hidden;
                background:#0d1b38;
                border:1px solid rgba(255,255,255,.06);
                transition:transform .4s cubic-bezier(.23,1,.32,1),
                    box-shadow .4s cubic-bezier(.23,1,.32,1);
                box-shadow:-6px 0 0 #162f5c, 0 8px 32px rgba(0,0,0,.55);
            }
            /* Lomo colorido a la izquierda */
            .libro-card::before {
                content:'';
                position:absolute;
                left:0;
                top:0;
                bottom:0;
                width:6px;
                background:linear-gradient(180deg,#4f8ef7 0%,#a78bfa 50%,#f472b6 100%);
                border-radius:4px 0 0 4px;
                z-index:3;
                transition:width .3s ease;
            }
            .libro-card:hover {
                transform:translateY(-14px) rotate(-1.5deg);
                box-shadow:-10px 20px 0 #0e2348,
                    0 32px 70px rgba(0,0,0,.85);
            }
            .libro-card:hover::before {
                width:8px;
            }
            .libro-card.no-disp {
                opacity:.85;
            }

            /* ── PORTADA ── */
            .card-cover-wrap {
                position:relative;
                height:260px;
                overflow:hidden;
                background:#070f1e;
            }
            .card-portada {
                width:100%;
                height:100%;
                object-fit:cover;
                display:block;
                transition:transform .55s ease, filter .3s;
                filter:saturate(1.1) contrast(1.04);
            }
            .libro-card:hover .card-portada {
                transform:scale(1.07);
                filter:saturate(1.2) contrast(1.06) brightness(1.05);
            }

            /* Placeholder sin portada */
            .card-portada-placeholder {
                width:100%;
                height:100%;
                display:flex;
                flex-direction:column;
                align-items:center;
                justify-content:center;
                gap:12px;
                background:repeating-linear-gradient(
                    45deg,
                    #080f1e, #080f1e 10px,
                    #0c1830 10px, #0c1830 20px
                    );
            }
            .card-portada-placeholder .ph-icon {
                width:52px;
                height:64px;
                border:2px solid rgba(255,255,255,.1);
                border-radius:3px 8px 8px 3px;
                display:flex;
                align-items:center;
                justify-content:center;
                color:rgba(255,255,255,.18);
                font-size:1.5rem;
            }
            .card-portada-placeholder span {
                font-size:.68rem;
                color:rgba(255,255,255,.18);
                font-family:'Lato',sans-serif;
                text-align:center;
                padding:0 1rem;
                line-height:1.5;
            }

            /* Velo degradado sobre la portada */
            .card-veil {
                position:absolute;
                inset:0;
                background:linear-gradient(
                    to bottom,
                    transparent 25%,
                    rgba(6,9,15,.65) 62%,
                    rgba(6,9,15,.97) 100%
                    );
                pointer-events:none;
                z-index:1;
            }

            /* ── BADGE ESTADO (MEJORADO) ── */
            .card-badge {
                position:absolute;
                top:13px;
                left:16px;
                z-index:2;
                font-family:'Lato',sans-serif;
                font-size:.62rem;
                font-weight:800;
                letter-spacing:1.2px;
                text-transform:uppercase;
                padding:.35em .9em;
                border-radius:4px;
                display:flex;
                align-items:center;
                gap:6px;
            }
            .card-badge.disp {
                background: rgba(16, 185, 129, 0.35);
                color: #6ee7b7;
                border: 1px solid rgba(52, 211, 153, 0.6);
                box-shadow: 0 0 20px rgba(52, 211, 153, 0.35), inset 0 1px 0 rgba(255,255,255,0.1);
                text-shadow: 0 1px 2px rgba(0,0,0,0.4);
                backdrop-filter: blur(4px);
            }
            .card-badge.no-disp-badge {
                background: rgba(239, 68, 68, 0.35);
                color: #fca5a5;
                border: 1px solid rgba(248, 113, 113, 0.6);
                box-shadow: 0 0 20px rgba(239, 68, 68, 0.35), inset 0 1px 0 rgba(255,255,255,0.1);
                text-shadow: 0 1px 2px rgba(0,0,0,0.4);
                backdrop-filter: blur(4px);
            }
            .badge-dot {
                width: 7px;
                height: 7px;
                border-radius:50%;
                background:currentColor;
                animation:badgePulse 2.2s ease-in-out infinite;
                box-shadow: 0 0 10px currentColor;
            }
            @keyframes badgePulse {
                0%,100%{
                    opacity:1;
                    transform: scale(1);
                }
                50%{
                    opacity:.4;
                    transform: scale(0.8);
                }
            }

            /* Año en esquina superior derecha */
            .card-year-tag {
                position:absolute;
                top:13px;
                right:13px;
                z-index:2;
                font-family:'Lato',sans-serif;
                font-size:.6rem;
                color:rgba(255,255,255,.32);
                background:rgba(0,0,0,.42);
                padding:.22em .6em;
                border-radius:3px;
                border:1px solid rgba(255,255,255,.07);
            }

            /* ── CUERPO ── */
            .card-body-lib {
                padding:.95rem 1rem .85rem;
                position:relative;
            }
            .card-titulo {
                font-family:'Playfair Display',serif;
                font-size:.92rem;
                font-weight:700;
                color:#e8eeff;
                line-height:1.35;
                margin-bottom:.28rem;
                display:-webkit-box;
                -webkit-line-clamp:2;
                -webkit-box-orient:vertical;
                overflow:hidden;
            }
            .card-editorial {
                font-family:'Lato',sans-serif;
                font-size:.7rem;
                color:rgba(147,197,253,.62);
                font-weight:500;
                margin-bottom:.65rem;
                white-space:nowrap;
                overflow:hidden;
                text-overflow:ellipsis;
            }
            .card-meta {
                display:flex;
                align-items:center;
                justify-content:space-between;
                border-top:1px solid rgba(255,255,255,.05);
                padding-top:.5rem;
            }
            .card-pages {
                font-family:'Lato',sans-serif;
                font-size:.68rem;
                color:rgba(255,255,255,.22);
                display:flex;
                align-items:center;
                gap:4px;
            }
            .card-isbn {
                font-family:monospace;
                font-size:.62rem;
                color:rgba(99,149,210,.38);
                letter-spacing:.4px;
            }

            /* ── BOTONES DE ACCIÓN — barra inferior deslizable ── */
            .card-actions {
                display:flex;
                border-top:1px solid rgba(255,255,255,.05);
                background:#070f1e;
                max-height:0;
                overflow:hidden;
                transition:max-height .38s cubic-bezier(.23,1,.32,1);
            }
            .libro-card:hover .card-actions {
                max-height:52px;
            }

            .btn-card-action {
                flex:1;
                height:46px;
                display:flex;
                align-items:center;
                justify-content:center;
                gap:5px;
                text-decoration:none;
                border:none;
                cursor:pointer;
                font-family:'Lato',sans-serif;
                font-size:.68rem;
                font-weight:700;
                letter-spacing:.5px;
                text-transform:uppercase;
                transition:background .18s, color .18s;
                color:rgba(255,255,255,.38);
                background:transparent;
            }
            .btn-card-action + .btn-card-action {
                border-left:1px solid rgba(255,255,255,.05);
            }
            .btn-card-action i {
                font-size:.72rem;
            }
            .btn-card-view:hover  {
                background:rgba(99,179,237,.14);
                color:#90cdf4;
            }
            .btn-card-edit:hover  {
                background:rgba(167,139,250,.14);
                color:#c4b5fd;
            }
            .btn-card-del:hover   {
                background:rgba(248,113,113,.12);
                color:#f87171;
            }

            /* ══════════════════════════════════════════════════
               MODAL DETALLE
            ══════════════════════════════════════════════════ */
            .modal-libro .modal-content {
                background:linear-gradient(145deg,#0d2855,#0a1628);
                border:1px solid rgba(66,165,245,.2);
                border-radius:20px;
                color:#fff;
            }
            .modal-libro .modal-header {
                border-bottom:1px solid rgba(66,165,245,.12);
                padding:1.2rem 1.5rem;
            }
            .modal-libro .modal-body   {
                padding:1.5rem;
            }
            .modal-portada-lg {
                width:100%;
                max-height:320px;
                object-fit:cover;
                border-radius:12px;
            }
            .modal-titulo {
                font-family:'Playfair Display',serif;
                font-size:1.35rem;
                font-weight:800;
                color:#fff;
                margin-bottom:.25rem;
            }
            .modal-meta-row {
                display:flex;
                align-items:flex-start;
                gap:.5rem;
                margin-bottom:.55rem;
            }
            .modal-meta-icon {
                color:rgba(66,165,245,.8);
                width:16px;
                flex-shrink:0;
                margin-top:.18rem;
                font-size:.85rem;
            }
            .modal-meta-text {
                font-size:.85rem;
                color:rgba(255,255,255,.65);
            }
            .modal-meta-text strong {
                color:#fff;
            }
            .modal-close-btn {
                background:rgba(255,255,255,.08);
                border:1px solid rgba(255,255,255,.12);
                color:rgba(255,255,255,.6);
                border-radius:8px;
                padding:.3rem .7rem;
                font-size:.8rem;
            }

            /* Spinner portada */
            .portada-loading {
                animation:coverPulse 1.6s ease-in-out infinite;
            }
            @keyframes coverPulse {
                0%,100%{
                    opacity:.45
                }
                50%{
                    opacity:.9
                }
            }

            /* Vista tabla oculta por defecto */
            #vistaTabla {
                display:none;
            }
            #vistaCards {
                display:block;
            }

            /* Responsive */
            @media(max-width:576px) {
                .catalogo-grid {
                    grid-template-columns:repeat(2,1fr);
                    gap:1.2rem;
                }
                .card-cover-wrap {
                    height:195px;
                }
                .sb {
                    width:58px;
                }
                .main-content {
                    margin-left: 58px !important;
                }
                .ni {
                    width: 44px;
                    height: 44px;
                }
                .ni span {
                    display: none;
                }
            }

            /* Print */
            /* ── PRINT ── */
                        /* ── PRINT ── */
            @media print {

                * {
                    -webkit-print-color-adjust: exact !important;
                    print-color-adjust: exact !important;
                }

                body {
                    background: #ffffff !important;
                    color: #1e293b !important;
                    font-family: 'DM Sans', 'Lato', sans-serif !important;
                    font-size: 10pt !important;
                    line-height: 1.4 !important;
                }

                /* Ocultar elementos de UI */
                .sb, .sidebar, .no-print, 
                .btn-modo, .vista-toggle, .export-bar,
                .card-actions, .modal, .bienvenida-est,
                .flash-success, .flash-danger, .btn-panel-gold, 
                .btn-export, .search-box, .select-wrapper, 
                #filtroDisp, #searchInput, .btn-sm-action {
                    display: none !important;
                }

                /* Mostrar contenido principal */
                .main-content, #printArea {
                    margin-left: 0 !important;
                    padding: 15px 20px !important;
                    width: 100% !important;
                    max-width: 100% !important;
                    background: #ffffff !important;
                    display: block !important;
                }

                /* Header */
                .page-header {
                    display: flex !important;
                    flex-direction: row !important;
                    align-items: center !important;
                    justify-content: space-between !important;
                    margin-bottom: 20px !important;
                    padding: 18px 22px !important;
                    background: linear-gradient(135deg, #0d2855 0%, #1565C0 100%) !important;
                    border-radius: 14px !important;
                    border: 2px solid rgba(66, 165, 245, 0.4) !important;
                    page-break-inside: avoid !important;
                }

                .page-title {
                    font-family: 'Playfair Display', serif !important;
                    font-size: 22pt !important;
                    font-weight: 900 !important;
                    color: #ffffff !important;
                    margin: 0 0 6px 0 !important;
                }

                .page-title span {
                    color: #FFD54F !important;
                }

                .page-subtitle {
                    color: rgba(255, 255, 255, 0.85) !important;
                    font-size: 10pt !important;
                    margin: 0 !important;
                }

                /* Stats */
                .row.g-3 {
                    display: flex !important;
                    flex-wrap: wrap !important;
                    gap: 12px !important;
                    margin-bottom: 20px !important;
                }

                .col-sm-4 {
                    flex: 0 0 calc(33.333% - 8px) !important;
                    max-width: calc(33.333% - 8px) !important;
                }

                .stat-card {
                    background: #f8fafc !important;
                    border: 2px solid #e2e8f0 !important;
                    border-radius: 10px !important;
                    padding: 12px !important;
                    text-align: center !important;
                    page-break-inside: avoid !important;
                }

                .stat-icon {
                    width: 36px !important;
                    height: 36px !important;
                    border-radius: 8px !important;
                    margin: 0 auto 8px !important;
                    display: flex !important;
                    align-items: center !important;
                    justify-content: center !important;
                }

                .stat-value {
                    font-size: 18pt !important;
                    font-weight: 800 !important;
                    color: #1565C0 !important;
                    margin-bottom: 4px !important;
                }

                .stat-label {
                    font-size: 8pt !important;
                    color: #64748b !important;
                    text-transform: uppercase !important;
                    letter-spacing: 0.5px !important;
                }

                /* Panel */
                .panel-card {
                    background: #ffffff !important;
                    border: 2px solid #e2e8f0 !important;
                    border-radius: 14px !important;
                    padding: 18px !important;
                    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06) !important;
                }

                h6 {
                    font-family: 'Playfair Display', serif !important;
                    font-size: 13pt !important;
                    color: #1565C0 !important;
                    margin-bottom: 15px !important;
                    padding-bottom: 8px !important;
                    border-bottom: 2px solid #42A5F5 !important;
                }

                /* Forzar vista tarjetas */
                #vistaCards {
                    display: block !important;
                }

                #vistaTabla {
                    display: none !important;
                }

                /* Grid catálogo */
                .catalogo-grid {
                    display: grid !important;
                    grid-template-columns: repeat(3, 1fr) !important;
                    gap: 15px !important;
                    margin-top: 0 !important;
                }

                /* Tarjetas */
                .libro-card {
                    position: relative !important;
                    background: #ffffff !important;
                    border: 1px solid #e2e8f0 !important;
                    border-radius: 10px !important;
                    overflow: hidden !important;
                    page-break-inside: avoid !important;
                    break-inside: avoid !important;
                    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05) !important;
                    cursor: default !important;
                    transform: none !important;
                }

                .libro-card::before {
                    content: '' !important;
                    position: absolute !important;
                    left: 0 !important;
                    top: 0 !important;
                    bottom: 0 !important;
                    width: 4px !important;
                    background: linear-gradient(180deg, #4f8ef7 0%, #a78bfa 50%, #f472b6 100%) !important;
                    border-radius: 10px 0 0 10px !important;
                    z-index: 2 !important;
                }

                .libro-card.no-disp::before {
                    background: #94a3b8 !important;
                }

                .libro-card:hover {
                    transform: none !important;
                    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05) !important;
                }

                .libro-card:hover::before {
                    width: 4px !important;
                }

                /* Portada */
                .card-cover-wrap {
                    height: 140px !important;
                    background: #f1f5f9 !important;
                    position: relative !important;
                    overflow: hidden !important;
                }

                .card-portada {
                    width: 100% !important;
                    height: 100% !important;
                    object-fit: cover !important;
                    display: block !important;
                }

                .card-portada-placeholder {
                    width: 100% !important;
                    height: 100% !important;
                    display: flex !important;
                    flex-direction: column !important;
                    align-items: center !important;
                    justify-content: center !important;
                    background: repeating-linear-gradient(
                        45deg,
                        #f1f5f9, #f1f5f9 10px,
                        #e2e8f0 10px, #e2e8f0 20px
                    ) !important;
                }

                .card-portada-placeholder .ph-icon {
                    width: 36px !important;
                    height: 44px !important;
                    border: 2px solid #cbd5e1 !important;
                    border-radius: 3px 6px 6px 3px !important;
                    display: flex !important;
                    align-items: center !important;
                    justify-content: center !important;
                    color: #94a3b8 !important;
                    font-size: 1rem !important;
                    margin-bottom: 6px !important;
                }

                .card-portada-placeholder span {
                    font-size: 7pt !important;
                    color: #64748b !important;
                    text-align: center !important;
                    padding: 0 8px !important;
                    line-height: 1.3 !important;
                }

                .card-veil {
                    display: none !important;
                }

                /* Badges */
                .card-badge {
                    position: absolute !important;
                    top: 8px !important;
                    left: 10px !important;
                    z-index: 3 !important;
                    font-size: 6pt !important;
                    font-weight: 700 !important;
                    text-transform: uppercase !important;
                    letter-spacing: 0.3px !important;
                    padding: 3px 6px !important;
                    border-radius: 3px !important;
                }

                .card-badge.disp {
                    background: #dcfce7 !important;
                    color: #166534 !important;
                    border: 1px solid #86efac !important;
                }

                .card-badge.no-disp-badge {
                    background: #fee2e2 !important;
                    color: #991b1b !important;
                    border: 1px solid #fca5a5 !important;
                }

                .badge-dot {
                    display: inline-block !important;
                    width: 5px !important;
                    height: 5px !important;
                    border-radius: 50% !important;
                    background: currentColor !important;
                    margin-right: 3px !important;
                    animation: none !important;
                }

                .card-year-tag {
                    position: absolute !important;
                    top: 8px !important;
                    right: 8px !important;
                    z-index: 3 !important;
                    font-size: 6pt !important;
                    color: #64748b !important;
                    background: rgba(255, 255, 255, 0.95) !important;
                    padding: 2px 5px !important;
                    border-radius: 3px !important;
                    border: 1px solid #e2e8f0 !important;
                }

                /* Cuerpo */
                .card-body-lib {
                    padding: 10px !important;
                    background: #ffffff !important;
                }

                .card-titulo {
                    font-family: 'Playfair Display', serif !important;
                    font-size: 9pt !important;
                    font-weight: 700 !important;
                    color: #1e293b !important;
                    line-height: 1.25 !important;
                    margin-bottom: 4px !important;
                    display: -webkit-box !important;
                    -webkit-line-clamp: 2 !important;
                    -webkit-box-orient: vertical !important;
                    overflow: hidden !important;
                }

                .card-editorial {
                    font-size: 7pt !important;
                    color: #64748b !important;
                    margin-bottom: 6px !important;
                    white-space: nowrap !important;
                    overflow: hidden !important;
                    text-overflow: ellipsis !important;
                }

                .card-meta {
                    display: flex !important;
                    align-items: center !important;
                    justify-content: space-between !important;
                    padding-top: 6px !important;
                    border-top: 1px solid #f1f5f9 !important;
                }

                .card-pages {
                    font-size: 6pt !important;
                    color: #94a3b8 !important;
                }

                .card-isbn {
                    font-family: monospace !important;
                    font-size: 6pt !important;
                    color: #94a3b8 !important;
                }

                .card-actions {
                    display: none !important;
                    max-height: 0 !important;
                }

                /* Tabla */
                .table-panel {
                    width: 100% !important;
                    border-collapse: collapse !important;
                    font-size: 9pt !important;
                }

                .table-panel th {
                    background: #1565C0 !important;
                    color: #ffffff !important;
                    padding: 8px !important;
                    text-align: left !important;
                    font-size: 8pt !important;
                }

                .table-panel td {
                    padding: 8px !important;
                    border-bottom: 1px solid #e2e8f0 !important;
                }

                /* Quitar animaciones */
                * {
                    animation: none !important;
                    transition: none !important;
                }
            }
        </style>
    </head>
    <body class="panel-body" style="background: var(--bg);">

        <!-- ═══ SIDEBAR DEL DASHBOARD ═══════════════════════════════════ -->
        <aside class="sb">
            <div class="sb-logo"><i class="fas fa-book-open"></i></div>
            <a href="${pageContext.request.contextPath}/DashboardServlet" class="ni" title="Inicio"><i class="fas fa-chart-pie"></i><span>Inicio</span></a>
            <a href="${pageContext.request.contextPath}/LibroServlet" class="ni act" title="Libros"><i class="fas fa-book"></i><span>Libros</span></a>
            <a href="${pageContext.request.contextPath}/PrestamoServlet" class="ni" title="Préstamos"><i class="fas fa-hand-holding-heart"></i><span>Préstamos</span></a>
            <a href="${pageContext.request.contextPath}/ReservaServlet" class="ni" title="Reservas"><i class="fas fa-calendar-check"></i><span>Reservas</span></a>
            <a href="${pageContext.request.contextPath}/MultaServlet" class="ni" title="Multas"><i class="fas fa-file-invoice-dollar"></i><span>Multas</span></a>
            <% if (esAdmin) { %><div class="sb-sep"></div>
            <a href="${pageContext.request.contextPath}/UsuarioServlet" class="ni" title="Usuarios"><i class="fas fa-users"></i><span>Usuarios</span></a>
                    <% if ("Administrativo".equals(tipoUsuario)) { %>
            <a href="${pageContext.request.contextPath}/AutorServlet" class="ni" title="Autores"><i class="fas fa-feather-alt"></i><span>Autores</span></a>
            <a href="${pageContext.request.contextPath}/CategoriaServlet" class="ni" title="Categorías"><i class="fas fa-tags"></i><span>Categ.</span></a>
                    <% } %><% }%>
            <div class="sb-bot">
                <div class="ni" onclick="location.href = '${pageContext.request.contextPath}/loginServlet?accion=logout'" title="Salir" style="color:rgba(248,113,113,.7)">
                    <i class="fas fa-sign-out-alt"></i><span>Salir</span>
                </div>
                <div class="sb-av" title="<%=usuarioSesion.getNombres()%> <%=usuarioSesion.getApellidos()%>">
                    <%=usuarioSesion.getNombres().charAt(0)%>
                </div>
            </div>
        </aside>

        <!-- ═══ CONTENIDO PRINCIPAL ══════════════════════════════════════ -->
        <main class="main-content" id="printArea">

            <% if ("Estudiante".equals(tipoUsuario)) {%>
            <div class="bienvenida-est">
                <div class="wave">👋</div>
                <div class="txt">
                    ¡Hola, <strong><%=usuarioSesion.getNombres()%></strong>! Bienvenido(a) al catálogo.
                    Explora los libros disponibles y reserva los que te interesen.
                </div>
            </div>
            <% } %>

            <% if (mensaje != null) {%>
            <div class="<%= "success".equals(tipoMensaje) ? "flash-success" : "flash-danger"%>">
                <i class="fas fa-<%= "success".equals(tipoMensaje) ? "check-circle" : "exclamation-circle"%>"></i>
                <%=mensaje%>
            </div>
            <% } %>

            <!-- Cabecera -->
            <div class="page-header">
                <div>
                    <div class="page-title">Catálogo de <span>Libros</span></div>
                    <div class="page-subtitle">Inventario bibliográfico de la biblioteca SENA</div>
                </div>
                <div class="d-flex gap-2 align-items-center flex-wrap">
                    <div class="export-bar no-print">
                        <button class="btn-export btn-export-pdf"   onclick="exportarPDF()"><i class="fas fa-file-pdf"></i> PDF</button>
                        <button class="btn-export btn-export-excel" onclick="exportarExcel()"><i class="fas fa-file-excel"></i> Excel</button>
                        <button class="btn-export btn-export-print" onclick="window.print()"><i class="fas fa-print"></i> Imprimir</button>
                    </div>
                    <% if (esAdmin) { %>
                    <a href="${pageContext.request.contextPath}/LibroServlet?accion=nuevo" class="btn-panel-gold no-print">
                        <i class="fas fa-plus"></i> Nuevo Libro
                    </a>
                    <% }%>
                </div>
            </div>

            <!-- Stats -->
            <div class="row g-3 mb-4">
                <div class="col-sm-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(66,165,245,0.15)"><i class="fas fa-book" style="color:var(--b4)"></i></div>
                        <div class="stat-value"><%=libros != null ? libros.size() : 0%></div>
                        <div class="stat-label">Total de Libros</div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(74,222,128,0.12)"><i class="fas fa-check-circle" style="color:#4ade80"></i></div>
                        <div class="stat-value" style="color:#4ade80"><%=totalDisp%></div>
                        <div class="stat-label">Disponibles</div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(248,113,113,0.12)"><i class="fas fa-times-circle" style="color:#f87171"></i></div>
                        <div class="stat-value" style="color:#f87171"><%=totalNDisp%></div>
                        <div class="stat-label">En Préstamo</div>
                    </div>
                </div>
            </div>

            <!-- Panel principal -->
            <div class="panel-card">

                <!-- Barra filtros + toggle -->
                <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2 no-print">
                    <h6 class="mb-0" style="font-weight:700">
                        <i class="fas fa-book-open me-2"></i>Catálogo
                    </h6>
                    <div class="d-flex gap-2 align-items-center flex-wrap">
                        <div class="select-wrapper" style="width:160px">
                            <select id="filtroDisp" class="form-select" onchange="filtrar()">
                                <option value="">Todos</option>
                                <option value="disponible">Disponibles</option>
                                <option value="no disponible">En Préstamo</option>
                            </select>
                        </div>
                        <div class="search-box" style="width:220px">
                            <i class="fas fa-search"></i>
                            <input type="text" id="searchInput" placeholder="Buscar libro..." oninput="filtrar()">
                        </div>
                        <div class="vista-toggle no-print">
                            <button class="btn-vista active" id="btnCards" onclick="setVista('cards')" title="Vista tarjetas">
                                <i class="fas fa-th-large"></i>
                            </button>
                            <button class="btn-vista" id="btnTabla" onclick="setVista('tabla')" title="Vista tabla">
                                <i class="fas fa-list"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- ══════════════════════════════════════════════════════
                     VISTA TARJETAS
                ══════════════════════════════════════════════════════ -->
                <div id="vistaCards">
                    <div class="catalogo-grid" id="catalogoGrid">
                        <%
                            if (libros != null && !libros.isEmpty()) {
                                for (Libro l : libros) {
                                    boolean disp = l.getDisponible() == 1;
                                    String isbn = l.getIsbn() != null ? l.getIsbn().replaceAll("[^0-9X]", "") : "";
                                    String editorial = l.getEditorialNombre() != null ? l.getEditorialNombre() : "";
                                    String categoria = l.getCategoriaNombre() != null ? l.getCategoriaNombre() : "";
                                    String imgSrc = null;
                                    if (l.getImagen() != null && !l.getImagen().isEmpty()) {
                                        imgSrc = request.getContextPath() + "/imagen?f=" + l.getImagen();
                                    } else if (!isbn.isEmpty()) {
                                        imgSrc = "https://covers.openlibrary.org/b/isbn/" + isbn + "-M.jpg";
                                    }
                        %>
                        <div class="libro-card <%=disp ? "" : "no-disp"%>"
                             data-titulo="<%=l.getTitulo().toLowerCase().replace("\"", "")%>"
                             data-estado="<%=disp ? "disponible" : "no disponible"%>"
                             onclick="verDetalle(<%=l.getId()%>, '<%=l.getTitulo().replace("'", "\\'")%>', '<%=isbn%>', '<%=editorial.replace("'", "\\'")%>', '<%=categoria.replace("'", "\\'")%>',<%=l.getAñoPublicacion()%>, '<%=l.getNumPaginas() != null ? l.getNumPaginas() : ""%>',<%=disp ? "true" : "false"%>)">

                            <!-- PORTADA -->
                            <div class="card-cover-wrap">
                                <% if (imgSrc != null) {%>
                                <img class="card-portada portada-loading"
                                     src="<%=imgSrc%>"
                                     alt="Portada <%=l.getTitulo()%>"
                                     onload="this.classList.remove('portada-loading')"
                                     onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                                <div class="card-portada-placeholder" style="display:none">
                                    <div class="ph-icon"><i class="fas fa-book-open"></i></div>
                                    <span><%=l.getTitulo()%></span>
                                </div>
                                <% } else {%>
                                <div class="card-portada-placeholder">
                                    <div class="ph-icon"><i class="fas fa-book-open"></i></div>
                                    <span><%=l.getTitulo()%></span>
                                </div>
                                <% }%>
                                <div class="card-veil"></div>
                                <span class="card-badge <%=disp ? "disp" : "no-disp-badge"%>">
                                    <span class="badge-dot"></span>
                                    <%=disp ? "Disponible" : "En préstamo"%>
                                </span>
                                <% if (l.getAñoPublicacion() > 0) {%>
                                <span class="card-year-tag"><%=l.getAñoPublicacion()%></span>
                                <% }%>
                            </div>

                            <!-- CUERPO -->
                            <div class="card-body-lib">
                                <div class="card-titulo"><%=l.getTitulo()%></div>
                                <div class="card-editorial">
                                    <i class="fas fa-building" style="font-size:.62rem;opacity:.5"></i>
                                    <%=editorial.isEmpty() ? "Editorial desconocida" : editorial%><%=!categoria.isEmpty() ? " · " + categoria : ""%>
                                </div>
                                <div class="card-meta">
                                    <span class="card-pages">
                                        <i class="fas fa-file-alt" style="font-size:.62rem"></i>
                                        <%=l.getNumPaginas() != null ? l.getNumPaginas() + " pág." : "—"%>
                                    </span>
                                    <span class="card-isbn"><%=!isbn.isEmpty() ? isbn.substring(0, Math.min(isbn.length(), 9)) : "Sin ISBN"%></span>
                                </div>
                            </div>

                            <!-- ACCIONES — barra inferior deslizable -->
                            <div class="card-actions" onclick="event.stopPropagation()">
                                <button class="btn-card-action btn-card-view"
                                        onclick="verDetalle(<%=l.getId()%>, '<%=l.getTitulo().replace("'", "\\'")%>', '<%=isbn%>', '<%=editorial.replace("'", "\\'")%>', '<%=categoria.replace("'", "\\'")%>',<%=l.getAñoPublicacion()%>, '<%=l.getNumPaginas() != null ? l.getNumPaginas() : ""%>',<%=disp ? "true" : "false"%>)">
                                    <i class="fas fa-eye"></i> Ver
                                </button>
                                <% if (esAdmin) {%>
                                <a href="${pageContext.request.contextPath}/LibroServlet?accion=editar&id=<%=l.getId()%>"
                                   class="btn-card-action btn-card-edit">
                                    <i class="fas fa-pen"></i> Editar
                                </a>
                                <a href="${pageContext.request.contextPath}/LibroServlet?accion=eliminar&id=<%=l.getId()%>"
                                   class="btn-card-action btn-card-del"
                                   onclick="return confirm('¿Eliminar <%=l.getTitulo().replace("'", "\\'")%>?')">
                                    <i class="fas fa-trash"></i> Borrar
                                </a>
                                <% } %>
                            </div>

                        </div>
                        <%
                            }
                        } else {
                        %>
                        <div style="grid-column:1/-1;padding:3rem;text-align:center;color:rgba(255,255,255,.28)">
                            <i class="fas fa-book" style="font-size:3rem;margin-bottom:1rem;display:block"></i>
                            No hay libros registrados.
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- ══════════════════════════════════════════════════════
                     VISTA TABLA
                ══════════════════════════════════════════════════════ -->
                <div id="vistaTabla">
                    <div class="table-responsive">
                        <table class="table-panel" id="tablaLibros">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Título</th>
                                    <th>ISBN</th>
                                    <th>Año</th>
                                    <th>Páginas</th>
                                    <th>Editorial</th>
                                    <th>Estado</th>
                                    <% if (esAdmin) { %><th style="text-align:center" class="no-print">Acciones</th><% } %>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (libros != null && !libros.isEmpty()) {
                                        for (Libro l : libros) {
                                            String dispLabel = l.getDisponible() == 1 ? "Disponible" : "No disponible";
                                %>
                                <tr class="fila-libro"
                                    data-titulo="<%=l.getTitulo().toLowerCase()%>"
                                    data-estado="<%=l.getDisponible() == 1 ? "disponible" : "no disponible"%>">
                                    <td><span style="color:rgba(255,255,255,.35);font-size:.8rem"><%=l.getId()%></span></td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <div style="width:34px;height:44px;border-radius:4px;background:linear-gradient(135deg,var(--b2),var(--b4));display:flex;align-items:center;justify-content:center;flex-shrink:0">
                                                <i class="fas fa-book" style="color:white;font-size:.8rem"></i>
                                            </div>
                                            <span style="font-weight:600"><%=l.getTitulo()%></span>
                                        </div>
                                    </td>
                                    <td><code style="color:var(--b4);font-size:.8rem"><%=l.getIsbn() != null ? l.getIsbn() : "—"%></code></td>
                                    <td style="color:rgba(255,255,255,.6)"><%=l.getAñoPublicacion() > 0 ? l.getAñoPublicacion() : "—"%></td>
                                    <td style="color:rgba(255,255,255,.6)"><%=l.getNumPaginas() != null ? l.getNumPaginas() + " pág." : "—"%></td>
                                    <td style="color:rgba(255,255,255,.6);font-size:.83rem"><%=l.getEditorialNombre() != null ? l.getEditorialNombre() : "—"%></td>
                                    <td><span class="<%=l.getDisponible() == 1 ? "badge-disponible" : "badge-no-disponible"%>"><%=dispLabel%></span></td>
                                        <% if (esAdmin) {%>
                                    <td style="text-align:center" class="no-print">
                                        <div class="d-flex gap-2 justify-content-center">
                                            <a href="${pageContext.request.contextPath}/LibroServlet?accion=editar&id=<%=l.getId()%>"
                                               class="btn-sm-action btn-edit" title="Editar"><i class="fas fa-pen"></i></a>
                                            <a href="${pageContext.request.contextPath}/LibroServlet?accion=eliminar&id=<%=l.getId()%>"
                                               class="btn-sm-action btn-delete" title="Eliminar"
                                               onclick="return confirm('¿Eliminar <%=l.getTitulo()%>?')">
                                                <i class="fas fa-trash"></i></a>
                                        </div>
                                    </td>
                                    <% } %>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr><td colspan="8">
                                        <div class="empty-state">
                                            <i class="fas fa-book"></i>
                                            <p>No hay libros registrados.</p>
                                        </div>
                                    </td></tr>
                                    <% }%>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div><!-- fin panel-card -->
        </main>

        <!-- ═══ MODAL DETALLE LIBRO ══════════════════════════════════════ -->
        <div class="modal fade modal-libro" id="modalLibro" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" style="font-family:'Playfair Display',serif;color:#fff">
                            <i class="fas fa-book-open me-2" style="color:#FFD54F"></i>Detalle del Libro
                        </h5>
                        <button type="button" class="modal-close-btn" data-bs-dismiss="modal">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="row g-4">
                            <div class="col-md-4">
                                <img id="modalPortada" src="" alt="Portada"
                                     class="modal-portada-lg"
                                     onerror="this.src='';this.style.display='none';document.getElementById('modalPortadaFallback').style.display='flex'">
                                <div id="modalPortadaFallback"
                                     style="display:none;width:100%;height:220px;background:linear-gradient(135deg,#0d2855,#1565c0);border-radius:12px;align-items:center;justify-content:center;font-size:3rem;color:rgba(255,255,255,.2)">
                                    <i class="fas fa-book-open"></i>
                                </div>
                            </div>
                            <div class="col-md-8">
                                <div class="modal-titulo" id="modalTitulo"></div>
                                <div id="modalBadge" class="mb-3"></div>
                                <div class="modal-meta-row">
                                    <i class="fas fa-building modal-meta-icon"></i>
                                    <div class="modal-meta-text">Editorial: <strong id="modalEditorial"></strong></div>
                                </div>
                                <div class="modal-meta-row">
                                    <i class="fas fa-tag modal-meta-icon"></i>
                                    <div class="modal-meta-text">Categoría: <strong id="modalCategoria"></strong></div>
                                </div>
                                <div class="modal-meta-row">
                                    <i class="fas fa-calendar modal-meta-icon"></i>
                                    <div class="modal-meta-text">Año: <strong id="modalAnio"></strong></div>
                                </div>
                                <div class="modal-meta-row">
                                    <i class="fas fa-file-alt modal-meta-icon"></i>
                                    <div class="modal-meta-text">Páginas: <strong id="modalPaginas"></strong></div>
                                </div>
                                <div class="modal-meta-row">
                                    <i class="fas fa-barcode modal-meta-icon"></i>
                                    <div class="modal-meta-text">ISBN: <strong id="modalIsbn" style="font-family:monospace;color:#42A5F5"></strong></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.8.2/jspdf.plugin.autotable.min.js"></script>
        <script>
                                                   /* ── Toggle vista tarjetas / tabla ── */
                                                   function setVista(v) {
                                                       if (v === 'cards') {
                                                           document.getElementById('vistaCards').style.display = 'block';
                                                           document.getElementById('vistaTabla').style.display = 'none';
                                                           document.getElementById('btnCards').classList.add('active');
                                                           document.getElementById('btnTabla').classList.remove('active');
                                                       } else {
                                                           document.getElementById('vistaCards').style.display = 'none';
                                                           document.getElementById('vistaTabla').style.display = 'block';
                                                           document.getElementById('btnTabla').classList.add('active');
                                                           document.getElementById('btnCards').classList.remove('active');
                                                       }
                                                       localStorage.setItem('libros_vista', v);
                                                   }
                                                   (function () {
                                                       const pref = localStorage.getItem('libros_vista');
                                                       if (pref === 'tabla')
                                                           setVista('tabla');
                                                   })();

                                                   /* ── Filtrar ── */
                                                   function filtrar() {
                                                       const txt = document.getElementById('searchInput').value.toLowerCase().trim();
                                                       const est = document.getElementById('filtroDisp').value.toLowerCase();
                                                       document.querySelectorAll('.libro-card').forEach(c => {
                                                           const match = (c.dataset.titulo || '').includes(txt) && (est === '' || c.dataset.estado === est);
                                                           c.style.display = match ? '' : 'none';
                                                       });
                                                       document.querySelectorAll('.fila-libro').forEach(r => {
                                                           const match = (r.dataset.titulo || '').includes(txt) && (est === '' || r.dataset.estado === est);
                                                           r.style.display = match ? '' : 'none';
                                                       });
                                                   }

                                                   /* ── Modal detalle ── */
                                                   const modalBS = new bootstrap.Modal(document.getElementById('modalLibro'));
                                                   function verDetalle(id, titulo, isbn, editorial, categoria, anio, paginas, disponible) {
                                                       document.getElementById('modalTitulo').textContent = titulo;
                                                       document.getElementById('modalEditorial').textContent = editorial || '—';
                                                       document.getElementById('modalCategoria').textContent = categoria || '—';
                                                       document.getElementById('modalAnio').textContent = anio > 0 ? anio : '—';
                                                       document.getElementById('modalPaginas').textContent = paginas ? paginas + ' páginas' : '—';
                                                       document.getElementById('modalIsbn').textContent = isbn || '—';
                                                       const badge = document.getElementById('modalBadge');
                                                       badge.innerHTML = disponible
                                                               ? '<span style="background:rgba(74,222,128,.15);color:#4ade80;border:1px solid rgba(74,222,128,.3);border-radius:50px;padding:.25em .9em;font-size:.8rem;font-weight:700"><i class="fas fa-check me-1"></i>Disponible</span>'
                                                               : '<span style="background:rgba(248,113,113,.15);color:#f87171;border:1px solid rgba(248,113,113,.3);border-radius:50px;padding:.25em .9em;font-size:.8rem;font-weight:700"><i class="fas fa-clock me-1"></i>En Préstamo</span>';
                                                       const portada = document.getElementById('modalPortada');
                                                       const fallback = document.getElementById('modalPortadaFallback');
                                                       portada.style.display = 'block';
                                                       fallback.style.display = 'none';
                                                       if (isbn) {
                                                           portada.src = 'https://covers.openlibrary.org/b/isbn/' + isbn + '-L.jpg';
                                                       } else {
                                                           portada.style.display = 'none';
                                                           fallback.style.display = 'flex';
                                                       }
                                                       modalBS.show();
                                                   }

                                                   /* ── Exportar PDF ── */
                                                   function exportarPDF() {
                                                       const {jsPDF} = window.jspdf;
                                                       const doc = new jsPDF({orientation: 'landscape'});
                                                       doc.setFontSize(16);
                                                       doc.setTextColor(13, 40, 85);
                                                       doc.text('Catálogo de Libros — Biblioteca SENA', 14, 18);
                                                       doc.setFontSize(9);
                                                       doc.setTextColor(120, 120, 120);
                                                       doc.text('Generado: ' + new Date().toLocaleString('es-CO'), 14, 24);
                                                       const filas = [];
                                                       document.querySelectorAll('#tablaLibros tbody tr.fila-libro').forEach(r => {
                                                           if (r.style.display === 'none')
                                                               return;
                                                           const c = r.querySelectorAll('td');
                                                           if (c.length < 6)
                                                               return;
                                                           filas.push([c[0].textContent.trim(), c[1].textContent.trim(),
                                                               c[2].textContent.trim(), c[3].textContent.trim(),
                                                               c[4].textContent.trim(), c[6].textContent.trim()]);
                                                       });
                                                       doc.autoTable({
                                                           startY: 28,
                                                           head: [['#', 'Título', 'ISBN', 'Año', 'Páginas', 'Estado']],
                                                           body: filas,
                                                           styles: {fontSize: 8, cellPadding: 3},
                                                           headStyles: {fillColor: [21, 101, 192], textColor: 255, fontStyle: 'bold'},
                                                           alternateRowStyles: {fillColor: [245, 248, 255]}
                                                       });
                                                       doc.save('libros_biblioteca.pdf');
                                                   }

                                                   /* ── Exportar Excel ── */
                                                   function exportarExcel() {
                                                       const filas = [['ID', 'Título', 'ISBN', 'Año', 'Páginas', 'Editorial', 'Estado']];
                                                       document.querySelectorAll('#tablaLibros tbody tr.fila-libro').forEach(r => {
                                                           if (r.style.display === 'none')
                                                               return;
                                                           const c = r.querySelectorAll('td');
                                                           if (c.length < 6)
                                                               return;
                                                           filas.push([c[0].textContent.trim(), c[1].textContent.trim(),
                                                               c[2].textContent.trim(), c[3].textContent.trim(),
                                                               c[4].textContent.trim(), c[5].textContent.trim(), c[6].textContent.trim()]);
                                                       });
                                                       const wb = XLSX.utils.book_new();
                                                       const ws = XLSX.utils.aoa_to_sheet(filas);
                                                       ws['!cols'] = [{wch: 6}, {wch: 40}, {wch: 18}, {wch: 8}, {wch: 10}, {wch: 20}, {wch: 14}];
                                                       XLSX.utils.book_append_sheet(wb, ws, 'Libros');
                                                       XLSX.writeFile(wb, 'libros_biblioteca.xlsx');
                                                   }

                                                   /* ── Imprimir: manejar vista antes/después de imprimir ── */
                                                   window.addEventListener('beforeprint', function () {
                                                       /* Fondo del body */
                                                       document.body.style.setProperty('background', '#ffffff', 'important');
                                                       document.body.style.setProperty('color', '#1e293b', 'important');
                                                       /* Vista tarjetas */
                                                       var cards = document.getElementById('vistaCards');
                                                       var tabla = document.getElementById('vistaTabla');
                                                       if (tabla && tabla.style.display === 'block') {
                                                           cards.setAttribute('data-restore-print', '1');
                                                           cards.style.setProperty('display', 'block', 'important');
                                                           tabla.style.setProperty('display', 'none', 'important');
                                                       }
                                                   });
                                                   window.addEventListener('afterprint', function () {
                                                       /* Restaurar fondo */
                                                       document.body.style.removeProperty('background');
                                                       document.body.style.removeProperty('color');
                                                       /* Restaurar vista */
                                                       var cards = document.getElementById('vistaCards');
                                                       var tabla = document.getElementById('vistaTabla');
                                                       if (cards && cards.getAttribute('data-restore-print') === '1') {
                                                           cards.removeAttribute('data-restore-print');
                                                           cards.style.removeProperty('display');
                                                           tabla.style.removeProperty('display');
                                                           setVista('tabla');
                                                       }
                                                   });
        </script>

        <%@ include file="/WEB-INF/vistas/Chatbot.jsp" %>

        <!-- Botón modo claro/oscuro -->
        <button class="btn-modo" id="btnModo" title="Cambiar tema" onclick="toggleModo()">
            <i class="fas fa-sun" id="icoModo"></i>
        </button>
        <script>
            (function () {
                if (localStorage.getItem('modoClaro') === '1') {
                    document.body.classList.add('light-mode');
                    document.getElementById('icoModo').className = 'fas fa-moon';
                }
            })();
            function toggleModo() {
                var isLight = document.body.classList.toggle('light-mode');
                document.getElementById('icoModo').className = isLight ? 'fas fa-moon' : 'fas fa-sun';
                localStorage.setItem('modoClaro', isLight ? '1' : '0');
            }
        </script>

    </body>
</html>
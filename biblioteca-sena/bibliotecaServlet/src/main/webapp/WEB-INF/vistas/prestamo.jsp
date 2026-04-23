<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, karen.adso.biblioteca.modelo.Prestamo, karen.adso.biblioteca.modelo.Usuario"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    String tipoUsuario = (String) session.getAttribute("tipoUsuario");
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/loginServlet");
        return;
    }
    List<Prestamo> prestamos = (List<Prestamo>) request.getAttribute("prestamos");
    String mensaje = (String) session.getAttribute("mensaje");
    String tipoMensaje = (String) session.getAttribute("tipoMensaje");
    session.removeAttribute("mensaje");
    session.removeAttribute("tipoMensaje");
    boolean esAdmin = "Administrativo".equals(tipoUsuario) || "Bibliotecario".equals(tipoUsuario);
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    int totalActivos = 0, totalDevueltos = 0;
    if (prestamos != null)
        for (Prestamo p : prestamos) {
            if ("Activo".equals(p.getEstado()) || "En curso".equals(p.getEstado())) {
                totalActivos++;
            } else {
                totalDevueltos++;
            }
        }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Préstamos — Biblioteca SENA</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Estilos.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

        <style>
            :root {
                --ink:  #080f1e;
                --azp:  #1565C0;
                --azc:  #42A5F5;
                --dor:  #FFD54F;
                --grn:  #4ade80;
                --red:  #f87171;
                --pur:  #CE93D8;
                --wht:  #e8f0fe;
            }

            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'DM Sans', sans-serif;
                background: var(--ink);
                min-height: 100vh;
                color: var(--wht);
            }

            /* ── FULL WIDTH MAIN ── */
            .pw {
                margin-left: 78px;
                padding: 2.4rem 2.5rem;
                min-height: 100vh;
                width: calc(100% - 78px);
            }

            /* ── FLASH ── */
            .flash {
                display: flex;
                align-items: center;
                gap: .6rem;
                border-radius: 14px;
                padding: .8rem 1.2rem;
                margin-bottom: 1.4rem;
                font-size: .88rem;
                font-weight: 500;
            }
            .flash-success {
                background:rgba(74,222,128,.1);
                border:1px solid rgba(74,222,128,.25);
                color:#4ade80;
            }
            .flash-danger  {
                background:rgba(248,113,113,.1);
                border:1px solid rgba(248,113,113,.25);
                color:#f87171;
            }

            /* ── PAGE HEADER ── */
            .ph {
                display: flex;
                align-items: flex-end;
                justify-content: space-between;
                margin-bottom: 2rem;
                flex-wrap: wrap;
                gap: 1rem;
            }
            .ph h1 {
                font-family: 'Playfair Display', serif;
                font-size: 1.85rem;
                font-weight: 900;
                color: #fff;
                line-height: 1.1;
            }
            .ph h1 span {
                color: var(--azc);
            }
            .ph p {
                font-size: .83rem;
                color: rgba(255,255,255,.38);
                margin-top: .25rem;
            }

            .btn-new {
                display: inline-flex;
                align-items: center;
                gap: .5rem;
                padding: .68rem 1.4rem;
                border-radius: 12px;
                background: linear-gradient(135deg, var(--dor), #f9a825);
                color: #0a1628;
                font-weight: 700;
                font-size: .88rem;
                text-decoration: none;
                box-shadow: 0 6px 20px rgba(255,213,79,.28);
                transition: transform .2s, box-shadow .2s;
            }
            .btn-new:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 28px rgba(255,213,79,.4);
                color: #0a1628;
            }

            /* ── KPI STRIP ── */
            .kpi-strip {
                display: grid;
                grid-template-columns: repeat(3,1fr);
                gap: 1.2rem;
                margin-bottom: 2rem;
            }
            .kpi {
                border-radius: 18px;
                padding: 1.4rem 1.6rem;
                position: relative;
                overflow: hidden;
                border: 1px solid rgba(255,255,255,.06);
                transition: transform .25s;
                cursor: default;
                animation: up .5s cubic-bezier(.22,1,.36,1) both;
            }
            .kpi:hover {
                transform: translateY(-3px);
            }
            .kpi:nth-child(1){
                background:linear-gradient(135deg,rgba(21,101,192,.38),rgba(66,165,245,.18));
                border-color:rgba(66,165,245,.18);
                animation-delay:.04s;
            }
            .kpi:nth-child(2){
                background:linear-gradient(135deg,rgba(255,193,7,.3),rgba(255,213,79,.14));
                border-color:rgba(255,213,79,.18);
                animation-delay:.08s;
            }
            .kpi:nth-child(3){
                background:linear-gradient(135deg,rgba(74,222,128,.24),rgba(66,165,245,.12));
                border-color:rgba(74,222,128,.18);
                animation-delay:.12s;
            }
            @keyframes up {
                from{
                    opacity:0;
                    transform:translateY(16px)
                }
                to{
                    opacity:1;
                    transform:translateY(0)
                }
            }

            .kpi-ico {
                position:absolute;
                right:1.4rem;
                bottom:.8rem;
                font-size:2.8rem;
                opacity:.1;
            }
            .kpi:nth-child(1) .kpi-ico {
                color:var(--azc);
            }
            .kpi:nth-child(2) .kpi-ico {
                color:var(--dor);
            }
            .kpi:nth-child(3) .kpi-ico {
                color:var(--grn);
            }
            .kpi-lbl {
                font-size:.68rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:.1em;
                color:rgba(255,255,255,.45);
                margin-bottom:.5rem;
            }
            .kpi-val {
                font-size:2.5rem;
                font-weight:800;
                line-height:1;
                color:#fff;
            }

            /* ── TABLE PANEL ── */
            .tp {
                background: rgba(255,255,255,.025);
                border: 1px solid rgba(255,255,255,.07);
                border-radius: 22px;
                width: 100%;            /* ← full width of .pw */
                animation: up .5s .18s cubic-bezier(.22,1,.36,1) both;
            }

            /* toolbar */
            .tp-bar {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 1.3rem 1.8rem;
                border-bottom: 1px solid rgba(255,255,255,.06);
                flex-wrap: wrap;
                gap: .9rem;
            }
            .tp-title {
                display: flex;
                align-items: center;
                gap: .6rem;
                font-size: 1rem;
                font-weight: 700;
                color: #fff;
            }
            .tp-title i {
                color: var(--azc);
            }
            .tp-ctrl {
                display: flex;
                align-items: center;
                gap: .55rem;
                flex-wrap: wrap;
            }

            .srch {
                position: relative;
            }
            .srch i {
                position:absolute;
                left:.85rem;
                top:50%;
                transform:translateY(-50%);
                color:rgba(255,255,255,.28);
                font-size:.8rem;
                pointer-events:none;
            }
            .srch input {
                background:rgba(255,255,255,.05);
                border:1px solid rgba(255,255,255,.09);
                border-radius:11px;
                padding:.58rem .9rem .58rem 2.2rem;
                color:#fff;
                font-size:.83rem;
                font-family:'DM Sans',sans-serif;
                width:230px;
                outline:none;
                transition:border-color .2s, background .2s;
            }
            .srch input:focus {
                border-color:rgba(66,165,245,.4);
                background:rgba(66,165,245,.05);
            }
            .srch input::placeholder {
                color:rgba(255,255,255,.2);
            }

            .sel-f {
                background:rgba(255,255,255,.05);
                border:1px solid rgba(255,255,255,.09);
                border-radius:11px;
                padding:.58rem .9rem;
                color:#fff;
                font-size:.83rem;
                font-family:'DM Sans',sans-serif;
                outline:none;
                cursor:pointer;
            }
            .sel-f option {
                background:#0d2855;
            }

            .ico-btn {
                width:35px;
                height:35px;
                border-radius:9px;
                background:rgba(255,255,255,.05);
                border:1px solid rgba(255,255,255,.09);
                color:rgba(255,255,255,.45);
                display:flex;
                align-items:center;
                justify-content:center;
                cursor:pointer;
                font-size:.8rem;
                transition:all .2s;
            }
            .ico-btn:hover {
                background:rgba(66,165,245,.15);
                color:var(--azc);
                border-color:rgba(66,165,245,.3);
            }

            /* ── COLUMN HEADERS ── */
            .loan-header {
                display: grid;
                grid-template-columns: 1fr 118px 118px 108px 72px 46px;
                gap: .8rem;
                padding: .65rem 1.5rem .55rem 2.2rem;
                border-bottom: 1px solid rgba(255,255,255,.055);
            }
            .lh {
                font-size:.64rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:.09em;
                color:rgba(255,255,255,.28);
            }
            .lh.c {
                text-align:center;
            }
            .lh.r {
                text-align:right;
            }

            /* ── ROWS CONTAINER — NO overflow:hidden so dropdown can escape ── */
            .loan-list {
                padding: .6rem 1rem 1rem;
            }

            /* ── LOAN ROW ── */
            .loan-row {
                display: grid;
                grid-template-columns: 1fr 118px 118px 108px 72px 46px;
                align-items: center;
                gap: .8rem;
                padding: .95rem 1rem .95rem 1.4rem;
                border-radius: 14px;
                margin-bottom: .55rem;
                position: relative;
                border: 1px solid rgba(255,255,255,.04);
                background: rgba(255,255,255,.03);
                transition: background .22s, border-color .22s, box-shadow .22s, transform .2s;
                animation: rowIn .4s cubic-bezier(.22,1,.36,1) both;
            }
            /* stagger */
            .loan-row:nth-child(1){
                animation-delay:.07s;
            }
            .loan-row:nth-child(2){
                animation-delay:.11s;
            }
            .loan-row:nth-child(3){
                animation-delay:.15s;
            }
            .loan-row:nth-child(4){
                animation-delay:.19s;
            }
            .loan-row:nth-child(5){
                animation-delay:.23s;
            }
            .loan-row:nth-child(6){
                animation-delay:.27s;
            }
            .loan-row:nth-child(7){
                animation-delay:.31s;
            }
            .loan-row:nth-child(8){
                animation-delay:.35s;
            }
            .loan-row:nth-child(9){
                animation-delay:.39s;
            }
            .loan-row:nth-child(10){
                animation-delay:.43s;
            }
            @keyframes rowIn {
                from{
                    opacity:0;
                    transform:translateX(-10px)
                }
                to{
                    opacity:1;
                    transform:translateX(0)
                }
            }

            /* left accent bar */
            .loan-row::before {
                content:'';
                position:absolute;
                left:0;
                top:18%;
                bottom:18%;
                width:3px;
                border-radius:0 3px 3px 0;
                transition: top .2s, bottom .2s;
            }
            .loan-row.st-active::before   {
                background:var(--dor);
                box-shadow:0 0 8px rgba(255,213,79,.55);
            }
            .loan-row.st-returned::before {
                background:var(--grn);
                box-shadow:0 0 8px rgba(74,222,128,.5);
            }
            .loan-row.st-expired::before  {
                background:var(--red);
                box-shadow:0 0 8px rgba(248,113,113,.55);
            }

            .loan-row:hover {
                background:rgba(66,165,245,.07);
                border-color:rgba(66,165,245,.18);
                transform:translateX(4px);
                box-shadow:0 6px 28px rgba(0,0,0,.28);
            }
            .loan-row:hover::before {
                top:8%;
                bottom:8%;
            }

            /* ── BOOK CELL ── */
            .bc {
                display:flex;
                align-items:center;
                gap:.85rem;
                min-width:0;
            }
            .bc-thumb {
                width:44px;
                height:44px;
                border-radius:10px;
                flex-shrink:0;
                background:linear-gradient(135deg,var(--azp),var(--azc));
                display:flex;
                align-items:center;
                justify-content:center;
                overflow:hidden;
                font-size:1.05rem;
                color:#fff;
                box-shadow:0 4px 12px rgba(21,101,192,.35);
                transition:transform .22s;
            }
            .loan-row:hover .bc-thumb {
                transform:scale(1.06);
            }
            .bc-thumb img {
                width:100%;
                height:100%;
                object-fit:cover;
                cursor:pointer;
            }
            .bc-title {
                font-size:.88rem;
                font-weight:700;
                color:#fff;
                white-space:nowrap;
                overflow:hidden;
                text-overflow:ellipsis;
                max-width: clamp(140px, 20vw, 300px);
                transition:color .2s;
            }
            .loan-row:hover .bc-title {
                color:var(--azc);
            }
            .bc-user {
                font-size:.74rem;
                color:rgba(255,255,255,.4);
                display:flex;
                align-items:center;
                gap:.28rem;
                margin-top:.15rem;
            }
            .bc-user i {
                color:var(--azc);
                font-size:.65rem;
            }

            /* ── DATE CELL ── */
            .dc .dc-val {
                font-size:.81rem;
                color:rgba(255,255,255,.72);
                font-weight:500;
            }
            .dc .dc-lbl {
                font-size:.63rem;
                color:rgba(255,255,255,.26);
                text-transform:uppercase;
                letter-spacing:.06em;
                margin-top:.06rem;
            }

            /* ── DAYS BADGE ── */
            .db {
                display:inline-flex;
                align-items:center;
                gap:.32rem;
                padding:.32rem .75rem;
                border-radius:50px;
                font-size:.77rem;
                font-weight:700;
                white-space:nowrap;
            }
            .db.ok     {
                background:rgba(74,222,128,.14);
                color:#4ade80;
                border:1px solid rgba(74,222,128,.28);
            }
            .db.warn   {
                background:rgba(255,213,79,.14);
                color:#FFD54F;
                border:1px solid rgba(255,213,79,.28);
            }
            .db.danger {
                background:rgba(248,113,113,.14);
                color:#f87171;
                border:1px solid rgba(248,113,113,.28);
            }
            .db.done   {
                background:rgba(255,255,255,.06);
                color:rgba(255,255,255,.32);
                border:1px solid rgba(255,255,255,.1);
            }

            /* ── STATUS ICON ── */
            .si {
                width:34px;
                height:34px;
                border-radius:9px;
                margin:0 auto;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:.82rem;
            }
            .si.active   {
                background:rgba(255,213,79,.16);
                color:#FFD54F;
                border:1px solid rgba(255,213,79,.3);
            }
            .si.returned {
                background:rgba(74,222,128,.14);
                color:#4ade80;
                border:1px solid rgba(74,222,128,.3);
            }
            .si.expired  {
                background:rgba(248,113,113,.14);
                color:#f87171;
                border:1px solid rgba(248,113,113,.3);
            }

            /* ── TRIGGER BUTTON ── */
            .act-trigger {
                width:32px;
                height:32px;
                border-radius:9px;
                margin-left:auto;
                background:rgba(255,255,255,.07);
                border:1px solid rgba(255,255,255,.12);
                color:rgba(255,255,255,.45);
                cursor:pointer;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:.78rem;
                transition:all .2s;
            }
            .act-trigger:hover, .act-trigger.open {
                background:rgba(66,165,245,.18);
                color:var(--azc);
                border-color:rgba(66,165,245,.45);
            }

            /* ── FIXED ACTION PANEL ── */
            /* Rendered into body via JS so it can't be clipped */
            #globalActPanel {
                display: none;
                position: fixed;       /* ← fixed: never clipped by any parent */
                z-index: 9999;
                background: linear-gradient(160deg, #102253 0%, #0a1a3d 100%);
                border: 1px solid rgba(66,165,245,.35);
                border-radius: 18px;
                padding: .75rem;
                min-width: 220px;
                box-shadow:
                    0 24px 60px rgba(0,0,0,.7),
                    0 0 0 1px rgba(255,255,255,.06) inset,
                    0 0 40px rgba(21,101,192,.18);
                animation: pIn .2s cubic-bezier(.22,1,.36,1) both;
            }
            @keyframes pIn {
                from{
                    opacity:0;
                    transform:translateY(-8px) scale(.95)
                }
                to{
                    opacity:1;
                    transform:translateY(0) scale(1)
                }
            }

            .ap-head {
                padding: .35rem .55rem .55rem;
                font-size: .64rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: .1em;
                color: rgba(255,255,255,.35);
                border-bottom: 1px solid rgba(255,255,255,.08);
                margin-bottom: .5rem;
            }
            .ap-item {
                display: flex;
                align-items: center;
                gap: .65rem;
                padding: .6rem .7rem;
                border-radius: 11px;
                color: var(--wht);
                font-size: .84rem;
                font-weight: 500;
                text-decoration: none;
                border: none;
                background: none;
                width: 100%;
                text-align: left;
                cursor: pointer;
                transition: background .16s;
                margin-bottom: .15rem;
            }
            .ap-item:last-child {
                margin-bottom: 0;
            }
            .ap-item:hover {
                background: rgba(255,255,255,.07);
            }
            .ap-ico {
                width: 29px;
                height: 29px;
                border-radius: 8px;
                flex-shrink: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: .8rem;
            }
            /* vivid icon colors */
            .ap-item.qr    .ap-ico {
                background: rgba(206,147,216,.2);
                color: #CE93D8;
                border:1px solid rgba(206,147,216,.3);
            }
            .ap-item.ret   .ap-ico {
                background: rgba(255,213,79,.18);
                color: #FFD54F;
                border:1px solid rgba(255,213,79,.3);
            }
            .ap-item.s-cur .ap-ico {
                background: rgba(255,213,79,.18);
                color: #FFD54F;
                border:1px solid rgba(255,213,79,.3);
            }
            .ap-item.s-dev .ap-ico {
                background: rgba(74,222,128,.18);
                color: #4ade80;
                border:1px solid rgba(74,222,128,.3);
            }
            .ap-item.s-vec .ap-ico {
                background: rgba(248,113,113,.18);
                color: #f87171;
                border:1px solid rgba(248,113,113,.3);
            }
            .ap-item.del   .ap-ico {
                background: rgba(248,113,113,.18);
                color: #f87171;
                border:1px solid rgba(248,113,113,.3);
            }
            .ap-div {
                height:1px;
                background:rgba(255,255,255,.08);
                margin:.45rem 0;
            }

            /* ── EMPTY ── */
            .empty-st {
                text-align:center;
                padding:3.5rem;
                color:rgba(255,255,255,.3);
            }
            .empty-st i {
                font-size:2.6rem;
                opacity:.25;
                margin-bottom:.9rem;
                display:block;
            }

            /* ── MODALS ── */
            .mwrap {
                display:none;
                position:fixed;
                inset:0;
                z-index:10000;
                background:rgba(0,0,0,.78);
                align-items:center;
                justify-content:center;
            }
            .mwrap.show {
                display:flex;
            }
            .mbox {
                background:linear-gradient(145deg,#0d2855,#081a3d);
                border:1px solid rgba(66,165,245,.28);
                border-radius:20px;
                padding:2rem;
                text-align:center;
                max-width:300px;
                width:90%;
                box-shadow:0 24px 64px rgba(0,0,0,.6);
            }
            .mbox p  {
                color:rgba(255,255,255,.5);
                font-size:.8rem;
                margin-bottom:.9rem;
            }
            .mbox img {
                border-radius:10px;
                background:#fff;
                padding:8px;
            }
            .mclose {
                margin-top:1rem;
                padding:.45rem 1.4rem;
                border-radius:50px;
                border:1px solid rgba(255,255,255,.15);
                background:rgba(255,255,255,.08);
                color:#fff;
                cursor:pointer;
                font-size:.82rem;
                font-family:'DM Sans',sans-serif;
                transition:background .2s;
            }
            .mclose:hover {
                background:rgba(255,255,255,.18);
            }
            .mimg-box {
                max-width:90vw;
            }
            .mimg-box img {
                max-height:80vh;
                border-radius:12px;
                box-shadow:0 24px 64px rgba(0,0,0,.6);
            }
            .mimg-box p {
                color:#fff;
                margin-top:.8rem;
                font-weight:700;
            }

            /* ── PRINT ── */
            /* ── PRINT ── */
            @media print {

                * {
                    -webkit-print-color-adjust: exact !important;
                    print-color-adjust: exact !important;
                }

                body {
                    background: #0a1628 !important;
                    color: #f8fafc !important;
                    font-family: 'DM Sans', sans-serif !important;
                    font-size: 11px !important;
                    line-height: 1.4 !important;
                }

                /* Ocultar elementos de UI */
                .sidebar, .sb, .no-print, .tp-bar, .kpi-strip,
                .act-trigger, .flash, .btn-new, .sb-bot, .sb-sep {
                    display: none !important;
                }

                /* Layout principal */
                .pw {
                    margin-left: 0 !important;
                    padding: 20px 25px !important;
                    width: 100% !important;
                    max-width: 100% !important;
                }

                /* Header de página mejorado */
                .ph {
                    display: flex !important;
                    flex-direction: row !important;
                    align-items: center !important;
                    justify-content: space-between !important;
                    margin-bottom: 25px !important;
                    padding: 20px 25px !important;
                    background: linear-gradient(135deg, #0d2855 0%, #081a3d 100%) !important;
                    border: 2px solid rgba(66, 165, 245, 0.3) !important;
                    border-radius: 16px !important;
                    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4) !important;
                }

                .ph > div:first-child {
                    flex: 1 !important;
                }

                .ph h1 {
                    font-family: 'Playfair Display', serif !important;
                    font-size: 28px !important;
                    font-weight: 900 !important;
                    color: #ffffff !important;
                    margin: 0 0 8px 0 !important;
                    letter-spacing: -0.5px !important;
                }

                .ph h1 span {
                    color: #42A5F5 !important;
                    text-shadow: 0 0 20px rgba(66, 165, 245, 0.3) !important;
                }

                .ph p {
                    color: #94a3b8 !important;
                    font-size: 13px !important;
                    margin: 0 !important;
                    font-weight: 400 !important;
                }

                /* Info de impresión (fecha/hora) */
                .ph::after {
                    content: "Biblioteca SENA - Reporte de Préstamos" !important;
                    display: block !important;
                    font-size: 10px !important;
                    color: #64748b !important;
                    text-transform: uppercase !important;
                    letter-spacing: 1px !important;
                    font-weight: 600 !important;
                    margin-left: 20px !important;
                    padding-left: 20px !important;
                    border-left: 2px solid rgba(66, 165, 245, 0.3) !important;
                }

                /* Panel de tabla */
                .tp {
                    background: transparent !important;
                    border: none !important;
                    border-radius: 0 !important;
                    box-shadow: none !important;
                }

                /* Encabezados de columna */
                .loan-header {
                    display: grid !important;
                    grid-template-columns: 2fr 100px 100px 90px 80px !important;
                    gap: 10px !important;
                    padding: 14px 20px !important;
                    background: linear-gradient(135deg, #1565C0 0%, #42A5F5 100%) !important;
                    border-radius: 12px 12px 0 0 !important;
                    border: none !important;
                    margin-bottom: 0 !important;
                }

                .lh {
                    color: #ffffff !important;
                    font-size: 10px !important;
                    font-weight: 700 !important;
                    text-transform: uppercase !important;
                    letter-spacing: 0.8px !important;
                    text-align: left !important;
                }

                .lh.c {
                    text-align: center !important;
                }

                /* Lista de préstamos */
                .loan-list {
                    padding: 0 !important;
                    background: #0f172a !important;
                    border: 2px solid #1e293b !important;
                    border-top: none !important;
                    border-radius: 0 0 12px 12px !important;
                }

                /* Filas de préstamo */
                .loan-row {
                    display: grid !important;
                    grid-template-columns: 2fr 100px 100px 90px 80px !important;
                    gap: 10px !important;
                    padding: 14px 20px !important;
                    margin-bottom: 0 !important;
                    border-radius: 0 !important;
                    border: none !important;
                    border-bottom: 1px solid #1e293b !important;
                    background: #0f172a !important;
                    page-break-inside: avoid !important;
                    break-inside: avoid !important;
                    align-items: center !important;
                }

                .loan-row:last-child {
                    border-bottom: none !important;
                    border-radius: 0 0 12px 12px !important;
                }

                /* Colores de acento según estado */
                .loan-row.st-active {
                    background: linear-gradient(90deg, rgba(255, 213, 79, 0.08) 0%, transparent 12%) !important;
                    border-left: 4px solid #FFD54F !important;
                }

                .loan-row.st-returned {
                    background: linear-gradient(90deg, rgba(74, 222, 128, 0.08) 0%, transparent 12%) !important;
                    border-left: 4px solid #4ade80 !important;
                }

                .loan-row.st-expired {
                    background: linear-gradient(90deg, rgba(248, 113, 113, 0.08) 0%, transparent 12%) !important;
                    border-left: 4px solid #f87171 !important;
                }

                /* Celda de libro */
                .bc {
                    gap: 12px !important;
                }

                .bc-thumb {
                    width: 42px !important;
                    height: 42px !important;
                    border-radius: 10px !important;
                    background: linear-gradient(135deg, #1565C0, #42A5F5) !important;
                    box-shadow: 0 4px 12px rgba(21, 101, 192, 0.35) !important;
                }

                .bc-thumb img {
                    border-radius: 10px !important;
                }

                .bc-title {
                    color: #ffffff !important;
                    font-size: 12px !important;
                    font-weight: 700 !important;
                    max-width: none !important;
                    white-space: normal !important;
                    overflow: visible !important;
                    line-height: 1.3 !important;
                }

                .bc-user {
                    color: #94a3b8 !important;
                    font-size: 10px !important;
                    margin-top: 4px !important;
                }

                .bc-user i {
                    color: #42A5F5 !important;
                    font-size: 9px !important;
                }

                /* Fechas */
                .dc .dc-val {
                    color: #e2e8f0 !important;
                    font-size: 11px !important;
                    font-weight: 600 !important;
                }

                .dc .dc-lbl {
                    color: #64748b !important;
                    font-size: 9px !important;
                    text-transform: uppercase !important;
                    letter-spacing: 0.5px !important;
                    margin-top: 2px !important;
                }

                /* Badges de días */
                .db {
                    padding: 6px 12px !important;
                    border-radius: 20px !important;
                    font-size: 10px !important;
                    font-weight: 700 !important;
                    border-width: 2px !important;
                }

                .db.ok {
                    background: rgba(74, 222, 128, 0.15) !important;
                    color: #4ade80 !important;
                    border: 2px solid #4ade80 !important;
                }

                .db.warn {
                    background: rgba(255, 213, 79, 0.15) !important;
                    color: #FFD54F !important;
                    border: 2px solid #FFD54F !important;
                }

                .db.danger {
                    background: rgba(248, 113, 113, 0.15) !important;
                    color: #f87171 !important;
                    border: 2px solid #f87171 !important;
                }

                .db.done {
                    background: rgba(255, 255, 255, 0.08) !important;
                    color: #94a3b8 !important;
                    border: 2px solid #475569 !important;
                }

                /* Estado */
                .si {
                    width: 34px !important;
                    height: 34px !important;
                    border-radius: 10px !important;
                    margin: 0 auto !important;
                    display: flex !important;
                    align-items: center !important;
                    justify-content: center !important;
                    font-size: 14px !important;
                    border-width: 2px !important;
                }

                .si.active {
                    background: rgba(255, 213, 79, 0.15) !important;
                    color: #FFD54F !important;
                    border: 2px solid #FFD54F !important;
                }

                .si.returned {
                    background: rgba(74, 222, 128, 0.15) !important;
                    color: #4ade80 !important;
                    border: 2px solid #4ade80 !important;
                }

                .si.expired {
                    background: rgba(248, 113, 113, 0.15) !important;
                    color: #f87171 !important;
                    border: 2px solid #f87171 !important;
                }

                /* Estado vacío */
                .empty-st {
                    padding: 50px !important;
                    color: #64748b !important;
                }

                .empty-st i {
                    color: #42A5F5 !important;
                    opacity: 0.4 !important;
                    font-size: 3rem !important;
                    margin-bottom: 15px !important;
                }

                /* Forzar mostrar columnas ocultas en responsive */
                .hide-sm {
                    display: block !important;
                }

                /* Quitar animaciones */
                .loan-row, .kpi, .tp {
                    animation: none !important;
                    transform: none !important;
                    transition: none !important;
                }

                /* Quitar hover effects */
                .loan-row:hover, .loan-row:hover::before {
                    transform: none !important;
                    background: inherit !important;
                    border-color: inherit !important;
                }

                /* Quitar sombras y efectos de profundidad innecesarios */
                .loan-row {
                    box-shadow: none !important;
                }

                /* Asegurar que todo el contenido sea visible */
                .loan-row::before {
                    display: none !important;
                }
            }
            /* ── RESPONSIVE ── */
            @media (max-width:1100px) {
                .loan-header,.loan-row {
                    grid-template-columns:1fr 100px 100px 98px 65px 40px;
                }
                .bc-title {
                    max-width:160px;
                }
            }
            @media (max-width:820px) {
                .pw {
                    margin-left:0;
                    padding:1.4rem;
                    width:100%;
                }
                .kpi-strip {
                    grid-template-columns:1fr 1fr;
                }
                .loan-header,.loan-row {
                    grid-template-columns:1fr 88px 88px 46px;
                }
                .hide-sm {
                    display:none !important;
                }
            }

            /* ─── SIDEBAR DASHBOARD ─── */
            .sb{
                position:fixed;
                left:0;
                top:0;
                bottom:0;
                width:78px;
                background:#0C1424;
                border-right:1px solid rgba(66,165,245,.1);
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
                background:linear-gradient(135deg,#1565C0,#42A5F5);
                display:flex;
                align-items:center;
                justify-content:center;
                color:#fff;
                font-size:1.1rem;
                margin-bottom:1.6rem;
                box-shadow:0 0 35px rgba(66,165,245,.14)
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
                color:#5E7A96;
                font-size:.51rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:.04em;
                transition:all .28s cubic-bezier(.4,0,.2,1);
                border:1px solid transparent;
                position:relative;
                cursor:pointer
            }
            .ni i{
                font-size:.92rem;
                transition:transform .28s cubic-bezier(.4,0,.2,1)
            }
            .ni:hover{
                background:rgba(66,165,245,.08);
                color:#90CAF9;
                border-color:rgba(66,165,245,.1)
            }
            .ni:hover i{
                transform:scale(1.18) translateY(-1px)
            }
            .ni.act{
                background:linear-gradient(135deg,rgba(21,101,192,.45),rgba(66,165,245,.22));
                color:#42A5F5;
                border-color:rgba(66,165,245,.3);
                box-shadow:0 0 35px rgba(66,165,245,.14)
            }
            .ni.act::before{
                content:'';
                position:absolute;
                left:-1px;
                top:50%;
                transform:translateY(-50%);
                width:3px;
                height:62%;
                background:#42A5F5;
                border-radius:0 3px 3px 0
            }
            .sb-sep{
                width:30px;
                height:1px;
                background:rgba(66,165,245,.1);
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
                background:linear-gradient(135deg,#42A5F5,#7C3AED);
                display:flex;
                align-items:center;
                justify-content:center;
                color:#fff;
                font-weight:700;
                font-size:.88rem;
                border:2px solid rgba(66,165,245,.3);
                cursor:pointer;
                transition:all .28s cubic-bezier(.4,0,.2,1)
            }
            .sb-av:hover{
                transform:scale(1.08);
                box-shadow:0 0 35px rgba(66,165,245,.14)
            }
        </style>
    </head>
    <body class="panel-body">

        <!-- SIDEBAR -->
        <aside class="sb">
            <div class="sb-logo"><i class="fas fa-book-open"></i></div>
            <a href="${pageContext.request.contextPath}/DashboardServlet" class="ni" title="Inicio"><i class="fas fa-chart-pie"></i><span>Inicio</span></a>
            <a href="${pageContext.request.contextPath}/LibroServlet" class="ni" title="Libros"><i class="fas fa-book"></i><span>Libros</span></a>
            <a href="${pageContext.request.contextPath}/PrestamoServlet" class="ni act" title="Préstamos"><i class="fas fa-hand-holding-heart"></i><span>Préstamos</span></a>
            <a href="${pageContext.request.contextPath}/ReservaServlet" class="ni" title="Reservas"><i class="fas fa-calendar-check"></i><span>Reservas</span></a>
            <a href="${pageContext.request.contextPath}/MultaServlet" class="ni" title="Multas"><i class="fas fa-file-invoice-dollar"></i><span>Multas</span></a>
            <% if ("Administrativo".equals(tipoUsuario) || "Bibliotecario".equals(tipoUsuario)) { %><div class="sb-sep"></div>
            <a href="${pageContext.request.contextPath}/UsuarioServlet" class="ni" title="Usuarios"><i class="fas fa-users"></i><span>Usuarios</span></a>
                    <% if ("Administrativo".equals(tipoUsuario)) { %>
            <a href="${pageContext.request.contextPath}/AutorServlet" class="ni" title="Autores"><i class="fas fa-feather-alt"></i><span>Autores</span></a>
            <a href="${pageContext.request.contextPath}/CategoriaServlet" class="ni" title="Categ."><i class="fas fa-tags"></i><span>Categ.</span></a>
            <a href="${pageContext.request.contextPath}/EditorialServlet" class="ni" title="Edit."><i class="fas fa-building"></i><span>Edit.</span></a>
                    <% } %><% }%>
            <div class="sb-bot">
                <div class="ni" onclick="location.href = '${pageContext.request.contextPath}/loginServlet?accion=logout'" title="Salir" style="color:rgba(248,113,113,.7)"><i class="fas fa-sign-out-alt"></i><span>Salir</span></div>
                <div class="sb-av" title="<%=usuarioSesion.getNombres()%> <%=usuarioSesion.getApellidos()%>"><%=usuarioSesion.getNombres().charAt(0)%></div>
            </div>
        </aside>

        <!-- MAIN -->
        <main class="pw" id="printArea">

            <% if (mensaje != null) {%>
            <div class="flash flash-<%=tipoMensaje%>">
                <i class="fas fa-<%="success".equals(tipoMensaje) ? "check-circle" : "exclamation-circle"%>"></i> <%=mensaje%>
            </div>
            <% } %>

            <!-- Header -->
            <div class="ph">
                <div>
                    <h1>Gestión de <span>Préstamos</span></h1>
                    <p>Control de préstamos activos y devoluciones del sistema</p>
                </div>
                <% if (esAdmin) { %>
                <a href="${pageContext.request.contextPath}/PrestamoServlet?accion=nuevo" class="btn-new no-print">
                    <i class="fas fa-plus"></i> Nuevo Préstamo
                </a>
                <% }%>
            </div>

            <!-- KPIs -->
            <div class="kpi-strip">
                <div class="kpi">
                    <div class="kpi-lbl">Total préstamos</div>
                    <div class="kpi-val"><%=prestamos != null ? prestamos.size() : 0%></div>
                    <i class="fas fa-hand-holding-heart kpi-ico"></i>
                </div>
                <div class="kpi">
                    <div class="kpi-lbl">En curso</div>
                    <div class="kpi-val"><%=totalActivos%></div>
                    <i class="fas fa-clock kpi-ico"></i>
                </div>
                <div class="kpi">
                    <div class="kpi-lbl">Devueltos</div>
                    <div class="kpi-val"><%=totalDevueltos%></div>
                    <i class="fas fa-check-circle kpi-ico"></i>
                </div>
            </div>

            <!-- Table panel -->
            <div class="tp">

                <!-- Toolbar -->
                <div class="tp-bar no-print">
                    <div class="tp-title"><i class="fas fa-list-ul"></i> Listado de préstamos</div>
                    <div class="tp-ctrl">
                        <div class="srch">
                            <i class="fas fa-search"></i>
                            <input type="text" id="searchInput" placeholder="Buscar libro o usuario…">
                        </div>
                        <select id="filtroEstado" class="sel-f">
                            <option value="">Todos los estados</option>
                            <option value="en curso">En curso</option>
                            <option value="devuelto">Devueltos</option>
                            <option value="vencido">Vencidos</option>
                        </select>
                        <button class="ico-btn" onclick="exportarPDF()"  title="PDF"><i class="fas fa-file-pdf"></i></button>
                        <button class="ico-btn" onclick="exportarExcel()" title="Excel"><i class="fas fa-file-excel"></i></button>
                        <button class="ico-btn" onclick="window.print()"  title="Imprimir"><i class="fas fa-print"></i></button>
                    </div>
                </div>

                <!-- Column headers -->
                <div class="loan-header">
                    <div class="lh">Libro / Usuario</div>
                    <div class="lh hide-sm">F. Préstamo</div>
                    <div class="lh hide-sm">F. Devolución</div>
                    <div class="lh">Días</div>
                    <div class="lh c">Estado</div>
                    <div class="lh r no-print">&#8942;</div>
                </div>

                <!-- Rows -->
                <div class="loan-list" id="loanList">
                    <%
                        if (prestamos != null && !prestamos.isEmpty()) {
                            for (Prestamo p : prestamos) {
                                boolean activo = "Activo".equals(p.getEstado()) || "En curso".equals(p.getEstado());
                                boolean devuelto = "Devuelto".equals(p.getEstado());
                                String rowCls = activo ? "st-active" : devuelto ? "st-returned" : "st-expired";
                                String siCls = activo ? "active" : devuelto ? "returned" : "expired";
                                String siIco = activo ? "fa-clock" : devuelto ? "fa-check" : "fa-times";

                                long dias = -999;
                                if (activo && p.getFechaDevolucion() != null) {
                                    dias = (p.getFechaDevolucion().getTime() - System.currentTimeMillis()) / (1000L * 60 * 60 * 24);
                                }
                                String dbCls = dias > 2 ? "ok" : dias >= 0 ? "warn" : dias == -999 ? "done" : "danger";
                                String dbTxt = dias > 0 ? dias + " días" : dias == 0 ? "Hoy vence" : dias == -999 ? "Finalizado" : "Vencido";
                                String dbIco = dias > 2 ? "fa-clock" : dias >= 0 ? "fa-exclamation-triangle" : dias == -999 ? "fa-check" : "fa-times-circle";

                                String titulo = p.getTituloLibro() != null ? p.getTituloLibro() : "Libro #" + p.getIdLibro();
                                String usuario = p.getNombreUsuario() != null ? p.getNombreUsuario() + " " + (p.getApellidoUsuario() != null ? p.getApellidoUsuario() : "") : "Usuario #" + p.getIdUsuario();
                                String imagen = p.getImagen() != null && !p.getImagen().isEmpty() ? p.getImagen() : null;

                                // Build action panel HTML for this row
                                StringBuilder ap = new StringBuilder();
                                ap.append("<div class='ap-head'>Préstamo #").append(p.getIdPrestamo()).append("</div>");
                                if (activo) {
                                    ap.append("<button class='ap-item qr' onclick=\"verQR(").append(p.getIdPrestamo()).append(")\"><div class='ap-ico'><i class='fas fa-qrcode'></i></div><span>Ver QR devolución</span></button>");
                                }
                                if (activo && esAdmin) {
                                    ap.append("<a class='ap-item ret' href='").append(request.getContextPath()).append("/PrestamoServlet?accion=devolucion&id=").append(p.getIdPrestamo()).append("'><div class='ap-ico'><i class='fas fa-undo-alt'></i></div><span>Registrar devolución</span></a>");
                                }
                                if ("Administrativo".equals(tipoUsuario)) {
                                    ap.append("<div class='ap-div'></div>");
                                    ap.append("<form action='").append(request.getContextPath()).append("/PrestamoServlet' method='post' style='margin:0'><input type='hidden' name='accion' value='editarEstado'><input type='hidden' name='id' value='").append(p.getIdPrestamo()).append("'><input type='hidden' name='estado' value='En curso'><button class='ap-item s-cur' type='submit' onclick=\"return confirm('¿Marcar En curso?')\"><div class='ap-ico'><i class='fas fa-clock'></i></div><span>Marcar En curso</span></button></form>");
                                    ap.append("<form action='").append(request.getContextPath()).append("/PrestamoServlet' method='post' style='margin:0'><input type='hidden' name='accion' value='editarEstado'><input type='hidden' name='id' value='").append(p.getIdPrestamo()).append("'><input type='hidden' name='estado' value='Devuelto'><button class='ap-item s-dev' type='submit' onclick=\"return confirm('¿Marcar Devuelto?')\"><div class='ap-ico'><i class='fas fa-check'></i></div><span>Marcar Devuelto</span></button></form>");
                                    ap.append("<form action='").append(request.getContextPath()).append("/PrestamoServlet' method='post' style='margin:0'><input type='hidden' name='accion' value='editarEstado'><input type='hidden' name='id' value='").append(p.getIdPrestamo()).append("'><input type='hidden' name='estado' value='Vencido'><button class='ap-item s-vec' type='submit' onclick=\"return confirm('¿Marcar Vencido?')\"><div class='ap-ico'><i class='fas fa-times'></i></div><span>Marcar Vencido</span></button></form>");
                                    ap.append("<div class='ap-div'></div>");
                                    ap.append("<a class='ap-item del' href='").append(request.getContextPath()).append("/PrestamoServlet?accion=eliminar&id=").append(p.getIdPrestamo()).append("' onclick=\"return confirm('¿Eliminar este préstamo?')\"><div class='ap-ico'><i class='fas fa-trash'></i></div><span>Eliminar préstamo</span></a>");
                                }
                                String apHtml = ap.toString().replace("\"", "&quot;").replace("'", "&#39;");
                    %>
                    <div class="loan-row <%=rowCls%>"
                         data-search="<%=titulo.toLowerCase()%> <%=usuario.toLowerCase()%>"
                         data-estado="<%=p.getEstado().toLowerCase()%>">

                        <!-- Book info -->
                        <div class="bc">
                            <div class="bc-thumb">
                                <% if (imagen != null) {%>
                                <img src="<%=request.getContextPath()%>/imagen?f=<%=imagen%>" alt="Portada"
                                     onclick="verImg('<%=request.getContextPath()%>/imagen?f=<%=imagen%>', '<%=titulo.replace("'", "\\'")%>')">
                                <% } else { %>
                                <i class="fas fa-book"></i>
                                <% }%>
                            </div>
                            <div>
                                <div class="bc-title" title="<%=titulo%>"><%=titulo%></div>
                                <div class="bc-user"><i class="fas fa-user"></i><%=usuario%></div>
                            </div>
                        </div>

                        <!-- F. Préstamo -->
                        <div class="dc hide-sm">
                            <div class="dc-val"><%=p.getFechaPrestamo() != null ? sdf.format(p.getFechaPrestamo()) : "—"%></div>
                            <div class="dc-lbl">Prestado</div>
                        </div>

                        <!-- F. Devolución -->
                        <div class="dc hide-sm">
                            <div class="dc-val"><%=p.getFechaDevolucion() != null ? sdf.format(p.getFechaDevolucion()) : "—"%></div>
                            <div class="dc-lbl">Devolución</div>
                        </div>

                        <!-- Días -->
                        <div>
                            <span class="db <%=dbCls%>">
                                <i class="fas <%=dbIco%>"></i><%=dbTxt%>
                            </span>
                        </div>

                        <!-- Estado -->
                        <div style="display:flex;justify-content:center;">
                            <div class="si <%=siCls%>" title="<%=p.getEstado()%>">
                                <i class="fas <%=siIco%>"></i>
                            </div>
                        </div>

                        <!-- Actions trigger -->
                        <div style="display:flex;justify-content:flex-end;" class="no-print">
                            <button class="act-trigger"
                                    data-ap="<%=apHtml%>"
                                    onclick="openPanel(this)"
                                    title="Acciones">
                                <i class="fas fa-ellipsis-v"></i>
                            </button>
                        </div>

                    </div>
                    <%  }
                    } else { %>
                    <div class="empty-st">
                        <i class="fas fa-hand-holding-heart"></i>
                        <p>No hay préstamos registrados.</p>
                    </div>
                    <% }%>
                </div><!-- /loan-list -->
            </div><!-- /tp -->
        </main>

        <!-- GLOBAL FLOATING ACTION PANEL (in body root — never clipped) -->
        <div id="globalActPanel"></div>

        <!-- QR Modal -->
        <div class="mwrap" id="modalQR" onclick="this.classList.remove('show')">
            <div class="mbox" onclick="event.stopPropagation()">
                <p><i class="fas fa-qrcode me-1" style="color:var(--pur)"></i> Escanea para registrar la devolución</p>
                <img id="qrImg" src="" width="180" height="180" alt="QR">
                <p id="qrLbl" style="margin-top:.6rem;font-size:.74rem;color:rgba(255,255,255,.28);"></p>
                <button class="mclose" onclick="document.getElementById('modalQR').classList.remove('show')">
                    <i class="fas fa-times me-1"></i>Cerrar
                </button>
            </div>
        </div>

        <!-- Img Modal -->
        <div class="mwrap" id="modalImg" onclick="this.classList.remove('show')">
            <div class="mimg-box" onclick="event.stopPropagation()">
                <img id="imgSrc" src="" alt="Portada">
                <p id="imgTitle"></p>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.8.2/jspdf.plugin.autotable.min.js"></script>

        <script>
                const panel = document.getElementById('globalActPanel');
                let activeBtn = null;

                function openPanel(btn) {
                    // same button → toggle off
                    if (activeBtn === btn && panel.style.display === 'block') {
                        hidePanel();
                        return;
                    }
                    // populate content (unescape the stored HTML)
                    const raw = btn.getAttribute('data-ap')
                            .replace(/&quot;/g, '\"')
                            .replace(/&#39;/g, "'");
                    panel.innerHTML = raw;
                    panel.style.display = 'block';

                    // position: below the button, right-aligned
                    const rect = btn.getBoundingClientRect();
                    const pw = panel.offsetWidth || 230;
                    let left = rect.right - pw;
                    let top = rect.bottom + 8;
                    // clamp so it doesn't go off-screen
                    if (left < 8)
                        left = 8;
                    if (top + 300 > window.innerHeight)
                        top = rect.top - 300 - 8;
                    panel.style.left = left + 'px';
                    panel.style.top = top + 'px';

                    activeBtn = btn;
                    btn.classList.add('open');

                    // re-trigger animation
                    panel.style.animation = 'none';
                    requestAnimationFrame(() => {
                        panel.style.animation = '';
                    });
                }

                function hidePanel() {
                    panel.style.display = 'none';
                    if (activeBtn) {
                        activeBtn.classList.remove('open');
                        activeBtn = null;
                    }
                }

                document.addEventListener('click', e => {
                    if (!e.target.closest('.act-trigger') && !e.target.closest('#globalActPanel')) {
                        hidePanel();
                    }
                });

                /* Filter */
                function filtrar() {
                    const txt = document.getElementById('searchInput').value.toLowerCase();
                    const est = document.getElementById('filtroEstado').value.toLowerCase();
                    document.querySelectorAll('.loan-row').forEach(r => {
                        const s = r.dataset.search || '';
                        const e = r.dataset.estado || '';
                        r.style.display = (s.includes(txt) && (est === '' || e.includes(est))) ? '' : 'none';
                    });
                }
                document.getElementById('searchInput').addEventListener('input', filtrar);
                document.getElementById('filtroEstado').addEventListener('change', filtrar);

                /* QR */
                function verQR(id) {
                    document.getElementById('qrImg').src = '${pageContext.request.contextPath}/QRServlet?idPrestamo=' + id;
                    document.getElementById('qrLbl').textContent = 'Préstamo #' + id;
                    document.getElementById('modalQR').classList.add('show');
                    hidePanel();
                }

                /* Img */
                function verImg(src, title) {
                    document.getElementById('imgSrc').src = src;
                    document.getElementById('imgTitle').textContent = title;
                    document.getElementById('modalImg').classList.add('show');
                }

                /* PDF */
                function exportarPDF() {
                    const {jsPDF} = window.jspdf;
                    const doc = new jsPDF({orientation: 'landscape'});
                    doc.setFontSize(16);
                    doc.text('Préstamos — Biblioteca SENA', 14, 20);
                    const filas = [];
                    document.querySelectorAll('.loan-row').forEach(row => {
                        if (row.style.display === 'none')
                            return;
                        filas.push([
                            row.querySelector('.bc-title')?.textContent?.trim() || '',
                            row.querySelector('.bc-user')?.textContent?.trim() || '',
                            row.querySelectorAll('.dc .dc-val')[0]?.textContent?.trim() || '',
                            row.querySelectorAll('.dc .dc-val')[1]?.textContent?.trim() || '',
                            row.querySelector('.db')?.textContent?.trim() || '',
                            row.querySelector('.si')?.title || ''
                        ]);
                    });
                    doc.autoTable({startY: 28, head: [['Libro', 'Usuario', 'F.Préstamo', 'F.Devolución', 'Días', 'Estado']], body: filas, styles: {fontSize: 8}, headStyles: {fillColor: [21, 101, 192]}});
                    doc.save('prestamos.pdf');
                }

                /* Excel */
                function exportarExcel() {
                    const filas = [['Libro', 'Usuario', 'F.Préstamo', 'F.Devolución', 'Días', 'Estado']];
                    document.querySelectorAll('.loan-row').forEach(row => {
                        if (row.style.display === 'none')
                            return;
                        filas.push([
                            row.querySelector('.bc-title')?.textContent?.trim() || '',
                            row.querySelector('.bc-user')?.textContent?.trim() || '',
                            row.querySelectorAll('.dc .dc-val')[0]?.textContent?.trim() || '',
                            row.querySelectorAll('.dc .dc-val')[1]?.textContent?.trim() || '',
                            row.querySelector('.db')?.textContent?.trim() || '',
                            row.querySelector('.si')?.title || ''
                        ]);
                    });
                    const wb = XLSX.utils.book_new();
                    const ws = XLSX.utils.aoa_to_sheet(filas);
                    XLSX.utils.book_append_sheet(wb, ws, 'Prestamos');
                    XLSX.writeFile(wb, 'prestamos.xlsx');
                }
        </script>

        <%@ include file="/WEB-INF/vistas/Chatbot.jsp" %>

    </body>
</html>

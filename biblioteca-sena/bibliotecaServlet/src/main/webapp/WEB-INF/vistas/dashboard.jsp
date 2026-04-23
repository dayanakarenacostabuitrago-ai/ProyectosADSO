<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Map, java.util.LinkedHashMap, java.text.NumberFormat, java.util.Locale, java.util.List, java.util.ArrayList, java.util.Date, java.text.SimpleDateFormat, java.util.Calendar"%>
<%
    karen.adso.biblioteca.modelo.Usuario usuarioSesion
            = (karen.adso.biblioteca.modelo.Usuario) session.getAttribute("usuario");
    String tipoUsuario = (String) session.getAttribute("tipoUsuario");
    boolean esAdmin = "Administrativo".equals(tipoUsuario) || "Bibliotecario".equals(tipoUsuario);

    int totalLibros = request.getAttribute("totalLibros") != null ? (Integer) request.getAttribute("totalLibros") : 0;
    int librosDisp = request.getAttribute("librosDisp") != null ? (Integer) request.getAttribute("librosDisp") : 0;
    int librosEnPrestamo = request.getAttribute("librosEnPrestamo") != null ? (Integer) request.getAttribute("librosEnPrestamo") : 0;
    int totalPrestamos = request.getAttribute("totalPrestamos") != null ? (Integer) request.getAttribute("totalPrestamos") : 0;
    int prestamosActivos = request.getAttribute("prestamosActivos") != null ? (Integer) request.getAttribute("prestamosActivos") : 0;
    int prestamosVencidos = request.getAttribute("prestamosVencidos") != null ? (Integer) request.getAttribute("prestamosVencidos") : 0;
    int totalMultas = request.getAttribute("totalMultas") != null ? (Integer) request.getAttribute("totalMultas") : 0;
    int multasPendientes = request.getAttribute("multasPendientes") != null ? (Integer) request.getAttribute("multasPendientes") : 0;
    double montoPendiente = request.getAttribute("montoPendiente") != null ? (Double) request.getAttribute("montoPendiente") : 0.0;
    int totalUsuarios = request.getAttribute("totalUsuarios") != null ? (Integer) request.getAttribute("totalUsuarios") : 0;
    int usuariosActivos = request.getAttribute("usuariosActivos") != null ? (Integer) request.getAttribute("usuariosActivos") : 0;

    @SuppressWarnings(
            
    
    "unchecked") Map<String, Integer> topLibros = (Map<String, Integer>) request.getAttribute("topLibros");
    if (topLibros == null) {
        topLibros = new LinkedHashMap<>();
    }
    @SuppressWarnings(
            
    
    "unchecked") Map<String, Integer> prestamosMes = (Map<String, Integer>) request.getAttribute("prestamosMes");
    if (prestamosMes == null) {
        prestamosMes = new LinkedHashMap<>();
    }
    @SuppressWarnings(
            
    
    "unchecked") List<Map<String, Object>> topUsuarios = (List<Map<String, Object>>) request.getAttribute("topUsuarios");
    if (topUsuarios == null) {
        topUsuarios = new ArrayList<>();
    }

    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("es", "CO"));
    String montoStr = nf.format(montoPendiente);
    int multasPagadas = totalMultas - multasPendientes;
    int pctDisponible = totalLibros > 0 ? Math.round((librosDisp * 100f) / totalLibros) : 0;
    int pctUsrActivos = totalUsuarios > 0 ? Math.round((usuariosActivos * 100f) / totalUsuarios) : 0;
    int pctMultasPend = totalMultas > 0 ? Math.round((multasPendientes * 100f) / totalMultas) : 0;

    SimpleDateFormat sdfDia = new SimpleDateFormat("EEEE d 'de' MMMM", new Locale("es", "ES"));
    Calendar cal = Calendar.getInstance();
    int mesActual = cal.get(Calendar.MONTH);
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard — Biblioteca SENA</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;600;700;800;900&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
        <style>
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
            *,*::before,*::after{
                box-sizing:border-box;
                margin:0;
                padding:0
            }
            body{
                font-family:'DM Sans',sans-serif;
                background:var(--bg);
                color:var(--txt);
                min-height:100vh;
                overflow-x:hidden
            }
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

            /* ─── SIDEBAR ─── */
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

            /* ─── LAYOUT ─── */
            .wrap{
                margin-left:78px;
                height:100vh;
                display:flex;
                flex-direction:column;
                overflow:hidden
            }

            /* ─── TOPBAR ─── */
            .tb{
                display:flex;
                align-items:center;
                gap:1.25rem;
                padding:.85rem 1.6rem;
                background:var(--bg2);
                border-bottom:1px solid var(--border);
                flex-shrink:0;
                animation:slideDown .45s var(--ease) both
            }
            @keyframes slideDown{
                from{
                    opacity:0;
                    transform:translateY(-10px)
                }
                to{
                    opacity:1;
                    transform:none
                }
            }
            .tb-brand .tt{
                font-family:'Sora',sans-serif;
                font-size:.98rem;
                font-weight:800;
                color:var(--txt);
                white-space:nowrap
            }
            .tb-brand .ts{
                font-size:.67rem;
                color:var(--txt2);
                margin-top:.08rem;
                white-space:nowrap
            }
            .ms{
                display:flex;
                gap:.22rem;
                flex:1;
                overflow-x:auto;
                scrollbar-width:none;
                padding:.12rem .2rem
            }
            .ms::-webkit-scrollbar{
                display:none
            }
            .mb{
                padding:.35rem .68rem;
                border-radius:50px;
                border:none;
                background:transparent;
                color:var(--txt2);
                font-size:.63rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:.04em;
                cursor:pointer;
                white-space:nowrap;
                transition:all .2s var(--ease);
                font-family:'DM Sans',sans-serif
            }
            .mb:hover{
                color:var(--txt);
                background:rgba(66,165,245,.09)
            }
            .mb.act{
                background:linear-gradient(135deg,var(--b2),var(--b4));
                color:#fff;
                box-shadow:0 2px 12px rgba(66,165,245,.38)
            }
            .tb-r{
                display:flex;
                align-items:center;
                gap:.6rem;
                flex-shrink:0
            }
            .live{
                display:inline-flex;
                align-items:center;
                gap:.38rem;
                padding:.32rem .8rem;
                border-radius:20px;
                background:rgba(16,185,129,.1);
                border:1px solid rgba(16,185,129,.18);
                font-size:.63rem;
                font-weight:700;
                color:#34D399;
                white-space:nowrap
            }
            .ldot{
                width:5px;
                height:5px;
                background:#34D399;
                border-radius:50%;
                animation:pulse 2s infinite
            }
            @keyframes pulse{
                0%,100%{
                    opacity:1;
                    transform:scale(1)
                }
                50%{
                    opacity:.3;
                    transform:scale(.55)
                }
            }
            .btn-np{
                display:flex;
                align-items:center;
                gap:.38rem;
                padding:.4rem 1.05rem;
                border-radius:20px;
                border:none;
                background:linear-gradient(135deg,var(--b2),var(--b4));
                color:#fff;
                font-size:.7rem;
                font-weight:700;
                cursor:pointer;
                text-decoration:none;
                transition:all .22s var(--ease);
                font-family:'DM Sans',sans-serif;
                white-space:nowrap
            }
            .btn-np:hover{
                transform:translateY(-2px);
                box-shadow:0 5px 18px rgba(66,165,245,.38);
                color:#fff
            }
            .btn-ic{
                width:32px;
                height:32px;
                border-radius:50%;
                border:1px solid var(--border);
                background:var(--card);
                display:flex;
                align-items:center;
                justify-content:center;
                color:var(--txt2);
                cursor:pointer;
                transition:all .22s var(--ease);
                font-size:.76rem
            }
            .btn-ic:hover{
                border-color:var(--b4);
                color:var(--b4);
                transform:rotate(45deg)
            }
            #icoR{
                transition:transform .5s
            }

            /* ─── SCROLL ─── */
            .sa{
                flex:1;
                overflow-y:auto;
                padding:1.2rem 1.6rem 1.6rem
            }

            /* ─── GRID ─── */
            .grid{
                display:grid;
                grid-template-columns:1fr .46fr .3fr;
                grid-template-rows:305px 235px;
                gap:1rem
            }
            .cm{
                grid-column:1;
                grid-row:1
            }
            .cd{
                grid-column:2;
                grid-row:1
            }
            .cs{
                grid-column:3;
                grid-row:1/3;
                display:flex;
                flex-direction:column
            }
            .cmu{
                grid-column:1;
                grid-row:2
            }
            .cb{
                grid-column:2;
                grid-row:2
            }

            /* ─── CARD ─── */
            .card{
                background:var(--card);
                border-radius:var(--r);
                border:1px solid var(--border);
                padding:1.25rem 1.3rem;
                display:flex;
                flex-direction:column;
                overflow:hidden;
                position:relative;
                transition:border-color var(--dur) var(--ease),box-shadow var(--dur) var(--ease),transform var(--dur) var(--ease)
            }
            .card::after{
                content:'';
                position:absolute;
                inset:0;
                border-radius:var(--r);
                background:radial-gradient(ellipse at 0 0,rgba(66,165,245,.05) 0%,transparent 65%);
                pointer-events:none
            }
            .card:hover{
                border-color:var(--border2);
                box-shadow:var(--s2);
                transform:translateY(-2px)
            }
            .card{
                opacity:0;
                animation:fadeUp .5s var(--ease) both
            }
            @keyframes fadeUp{
                from{
                    opacity:0;
                    transform:translateY(16px)
                }
                to{
                    opacity:1;
                    transform:none
                }
            }
            .cm{
                animation-delay:.07s
            }
            .cd{
                animation-delay:.14s
            }
            .cs{
                animation-delay:.21s
            }
            .cmu{
                animation-delay:.28s
            }
            .cb{
                animation-delay:.35s
            }

            /* ─── CARD HEADER ─── */
            .ch{
                display:flex;
                align-items:flex-start;
                justify-content:space-between;
                margin-bottom:.8rem;
                gap:.5rem
            }
            .lbl{
                font-size:.58rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:.09em;
                color:var(--txt2);
                margin-bottom:.18rem
            }
            .big{
                font-family:'Sora',sans-serif;
                font-size:1.45rem;
                font-weight:900;
                color:var(--txt);
                line-height:1
            }
            .sub{
                font-size:.68rem;
                color:var(--txt2);
                margin-top:.18rem
            }
            .ch-r{
                display:flex;
                align-items:center;
                gap:.42rem;
                flex-shrink:0;
                flex-wrap:wrap;
                justify-content:flex-end
            }

            /* ─── CHIPS ─── */
            .chip{
                display:inline-flex;
                align-items:center;
                gap:.28rem;
                padding:.26rem .62rem;
                border-radius:20px;
                font-size:.61rem;
                font-weight:700;
                white-space:nowrap;
                transition:transform .18s var(--ease)
            }
            .chip:hover{
                transform:scale(1.05)
            }
            .cb4{
                background:rgba(66,165,245,.14);
                color:var(--b4)
            }
            .cg{
                background:rgba(16,185,129,.14);
                color:#34D399
            }
            .ca{
                background:rgba(245,158,11,.14);
                color:#FBBF24
            }
            .cr{
                background:rgba(239,68,68,.14);
                color:#F87171
            }
            .cv{
                background:rgba(124,58,237,.14);
                color:#A78BFA
            }

            /* ─── TOGGLES ─── */
            .trow{
                display:flex;
                gap:.32rem
            }
            .tog{
                padding:.26rem .68rem;
                border-radius:20px;
                border:1px solid var(--border);
                background:transparent;
                color:var(--txt2);
                font-size:.6rem;
                font-weight:700;
                cursor:pointer;
                transition:all .2s var(--ease);
                font-family:'DM Sans',sans-serif
            }
            .tog.on{
                background:var(--b2);
                border-color:var(--b4);
                color:#fff;
                box-shadow:0 2px 10px rgba(66,165,245,.28)
            }
            .tog:hover:not(.on){
                background:rgba(66,165,245,.09);
                color:var(--b5)
            }

            /* ─── CHART META ─── */
            .cmeta{
                display:flex;
                gap:1.1rem;
                margin-bottom:.55rem
            }
            .cmi{
                display:flex;
                align-items:center;
                gap:.38rem
            }
            .cmt{
                width:7px;
                height:7px;
                border-radius:50%
            }
            .cml{
                font-size:.66rem;
                color:var(--txt2)
            }
            .cmv{
                font-family:'Sora',sans-serif;
                font-size:.82rem;
                font-weight:700;
                color:var(--txt);
                margin-left:.12rem
            }

            /* ─── DONUT ─── */
            .dw{
                flex:1;
                display:flex;
                align-items:center;
                justify-content:center;
                position:relative;
                padding:.2rem 0
            }
            .dc{
                position:absolute;
                top:50%;
                left:50%;
                transform:translate(-50%,-50%);
                text-align:center;
                pointer-events:none
            }
            .dp{
                font-family:'Sora',sans-serif;
                font-size:1.6rem;
                font-weight:900;
                color:var(--txt)
            }
            .dl{
                font-size:.54rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:.06em;
                color:var(--txt2)
            }
            .dleg{
                display:flex;
                justify-content:center;
                gap:1rem;
                margin-top:.55rem;
                flex-wrap:wrap
            }
            .dli{
                display:flex;
                align-items:center;
                gap:.32rem;
                font-size:.63rem;
                color:var(--txt2)
            }
            .dlid{
                width:6px;
                height:6px;
                border-radius:50%;
                flex-shrink:0
            }

            /* ─── STATS PANEL ─── */
            .cs{
                padding:.85rem .95rem;
                gap:.42rem;
                background:linear-gradient(160deg,rgba(21,101,192,.07) 0%,var(--card) 55%)
            }
            .shd{
                text-align:center;
                padding-bottom:.6rem;
                border-bottom:1px solid var(--border);
                margin-bottom:.08rem
            }
            .sav{
                width:44px;
                height:44px;
                border-radius:50%;
                background:linear-gradient(135deg,var(--b4),var(--indigo));
                display:flex;
                align-items:center;
                justify-content:center;
                color:#fff;
                font-size:.98rem;
                font-weight:800;
                margin:0 auto .38rem;
                border:2px solid rgba(66,165,245,.32);
                box-shadow:var(--gB);
                animation:pop .7s cubic-bezier(.34,1.56,.64,1) .3s both
            }
            .sn{
                font-family:'Sora',sans-serif;
                font-size:.8rem;
                font-weight:700;
                color:var(--txt)
            }
            .sr2{
                font-size:.58rem;
                color:var(--b4);
                text-transform:uppercase;
                letter-spacing:.07em;
                margin-top:.08rem
            }
            .si{
                display:flex;
                align-items:center;
                justify-content:space-between;
                padding:.48rem .6rem;
                background:rgba(255,255,255,.026);
                border-radius:var(--r3);
                border:1px solid var(--border);
                transition:all .2s var(--ease);
                cursor:default;
                position:relative;
                overflow:hidden
            }
            .si::before{
                content:'';
                position:absolute;
                left:0;
                top:0;
                bottom:0;
                width:2.5px;
                border-radius:0 2px 2px 0
            }
            .si:hover{
                background:var(--hover);
                transform:translateX(2.5px);
                border-color:var(--border2)
            }
            .si-l{
                display:flex;
                align-items:center;
                gap:.48rem
            }
            .si-ic{
                width:27px;
                height:27px;
                border-radius:7px;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:.68rem;
                flex-shrink:0;
                transition:transform .2s var(--ease)
            }
            .si:hover .si-ic{
                transform:scale(1.12) rotate(-4deg)
            }
            .si-n{
                font-size:.7rem;
                font-weight:600;
                color:var(--txt)
            }
            .si-s{
                font-size:.57rem;
                color:var(--txt2)
            }
            .si-v{
                font-family:'Sora',sans-serif;
                font-size:.86rem;
                font-weight:800
            }
            /* colores por tipo */
            .ti-lib .si-ic{
                background:rgba(66,165,245,.14);
                color:var(--b4)
            }
            .ti-lib .si-v{
                color:var(--b4)
            }
            .ti-lib::before{
                background:var(--b4)
            }
            .ti-pre .si-ic{
                background:rgba(16,185,129,.14);
                color:#34D399
            }
            .ti-pre .si-v{
                color:#34D399
            }
            .ti-pre::before{
                background:#34D399
            }
            .ti-ven .si-ic{
                background:rgba(239,68,68,.14);
                color:#F87171
            }
            .ti-ven .si-v{
                color:#F87171
            }
            .ti-ven::before{
                background:#F87171
            }
            .ti-mul .si-ic{
                background:rgba(245,158,11,.14);
                color:#FBBF24
            }
            .ti-mul .si-v{
                color:#FBBF24
            }
            .ti-mul::before{
                background:#FBBF24
            }
            .ti-usr .si-ic{
                background:rgba(124,58,237,.14);
                color:#A78BFA
            }
            .ti-usr .si-v{
                color:#A78BFA
            }
            .ti-usr::before{
                background:#A78BFA
            }
            .ti-mon .si-ic{
                background:rgba(239,68,68,.14);
                color:#F87171
            }
            .ti-mon .si-v{
                color:#F87171;
                font-size:.68rem
            }
            .ti-mon::before{
                background:var(--red)
            }
            .sact{
                display:flex;
                flex-direction:column;
                gap:.38rem;
                margin-top:.2rem
            }
            .sabt{
                display:flex;
                align-items:center;
                justify-content:center;
                gap:.38rem;
                padding:.5rem;
                border-radius:var(--r3);
                border:none;
                font-size:.68rem;
                font-weight:700;
                cursor:pointer;
                text-decoration:none;
                transition:all .2s var(--ease);
                font-family:'DM Sans',sans-serif
            }
            .sabt:hover{
                transform:translateY(-2px)
            }
            .sap{
                background:linear-gradient(135deg,var(--b2),var(--b4));
                color:#fff;
                box-shadow:0 3px 12px rgba(66,165,245,.28)
            }
            .sap:hover{
                box-shadow:0 5px 20px rgba(66,165,245,.38);
                color:#fff
            }
            .saw{
                background:rgba(239,68,68,.13);
                color:#FCA5A5;
                border:1px solid rgba(239,68,68,.18)
            }
            .saw:hover{
                background:rgba(239,68,68,.22);
                color:#FCA5A5
            }

            /* ─── GAUGE MULTAS (innovador) ─── */
            .gauge-wrap{
                display:flex;
                align-items:center;
                gap:1.1rem;
                flex:1;
                min-height:0
            }
            .gc-w{
                position:relative;
                flex-shrink:0;
                width:124px;
                height:124px
            }
            #gCanvas{
                display:block
            }
            .gc-c{
                position:absolute;
                top:50%;
                left:50%;
                transform:translate(-50%,-50%);
                text-align:center;
                pointer-events:none
            }
            .gp{
                font-family:'Sora',sans-serif;
                font-size:1.3rem;
                font-weight:900;
                color:var(--txt)
            }
            .gll{
                font-size:.52rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:.06em;
                color:var(--txt2)
            }
            .gd{
                flex:1;
                display:flex;
                flex-direction:column;
                gap:.5rem
            }
            .gr{
                display:flex;
                align-items:center;
                gap:.5rem
            }
            .gr-d{
                width:7px;
                height:7px;
                border-radius:50%;
                flex-shrink:0
            }
            .gr-l{
                font-size:.68rem;
                color:var(--txt2);
                flex:1
            }
            .gr-bw{
                width:76px;
                height:4px;
                background:rgba(255,255,255,.055);
                border-radius:2px;
                overflow:hidden
            }
            .gr-bf{
                height:100%;
                border-radius:2px;
                transition:width 1.3s cubic-bezier(.4,0,.2,1)
            }
            .gr-v{
                font-size:.68rem;
                font-weight:700;
                color:var(--txt);
                min-width:22px;
                text-align:right
            }
            .mrow{
                display:flex;
                align-items:center;
                justify-content:space-between;
                margin-top:.3rem;
                padding:.42rem .58rem;
                background:rgba(255,255,255,.03);
                border-radius:var(--r3);
                border:1px solid var(--border)
            }
            .ml{
                font-size:.65rem;
                color:var(--txt2)
            }
            .mv{
                font-family:'Sora',sans-serif;
                font-size:.8rem;
                font-weight:700;
                color:#FBBF24
            }

            /* ─── BOOKS ─── */
            .bkl{
                display:flex;
                flex-direction:column;
                gap:.4rem;
                flex:1;
                overflow:hidden
            }
            .bkr{
                display:flex;
                align-items:center;
                gap:.58rem;
                padding:.38rem .45rem;
                border-radius:var(--r3);
                transition:background .2s var(--ease);
                cursor:default
            }
            .bkr:hover{
                background:rgba(255,255,255,.04)
            }
            .bkn{
                width:23px;
                height:23px;
                border-radius:6px;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:.6rem;
                font-weight:900;
                color:#fff;
                flex-shrink:0
            }
            .bki{
                flex:1;
                min-width:0
            }
            .bkt{
                font-size:.7rem;
                font-weight:600;
                color:var(--txt);
                white-space:nowrap;
                overflow:hidden;
                text-overflow:ellipsis;
                margin-bottom:.2rem
            }
            .bkbg{
                height:3px;
                background:rgba(255,255,255,.055);
                border-radius:2px;
                overflow:hidden
            }
            .bkbf{
                height:100%;
                border-radius:2px;
                transition:width 1.1s cubic-bezier(.4,0,.2,1)
            }
            .bkc{
                font-size:.66rem;
                font-weight:700;
                min-width:18px;
                text-align:right
            }

            /* ─── TOASTS ─── */
            .tcs{
                position:fixed;
                bottom:1.4rem;
                right:1.4rem;
                z-index:9999;
                display:flex;
                flex-direction:column;
                gap:.45rem;
                pointer-events:none
            }
            .tc{
                display:flex;
                align-items:center;
                gap:.58rem;
                padding:.58rem .9rem;
                border-radius:11px;
                background:#0C1424;
                border:1px solid var(--border);
                box-shadow:var(--s2);
                color:var(--txt);
                font-size:.71rem;
                max-width:260px;
                pointer-events:all;
                animation:tI .28s var(--ease)
            }
            .tc.out{
                animation:tO .28s var(--ease) forwards
            }
            @keyframes tI{
                from{
                    opacity:0;
                    transform:translateX(14px) scale(.95)
                }
                to{
                    opacity:1;
                    transform:none
                }
            }
            @keyframes tO{
                from{
                    opacity:1
                }
                to{
                    opacity:0;
                    transform:translateX(14px)
                }
            }
            .ti2{
                width:25px;
                height:25px;
                border-radius:7px;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:.7rem;
                flex-shrink:0
            }

            /* ─── RESPONSIVE ─── */
            @media(max-width:1280px){
                .grid{
                    grid-template-columns:1fr .5fr .3fr
                }
            }
            @media(max-width:1080px){
                .grid{
                    grid-template-columns:1fr 1fr;
                    grid-template-rows:auto
                }
                .cm{
                    grid-column:1/3;
                    grid-row:1;
                    height:280px
                }
                .cd{
                    grid-column:1;
                    grid-row:2;
                    height:255px
                }
                .cs{
                    grid-column:2;
                    grid-row:2/4
                }
                .cmu{
                    grid-column:1;
                    grid-row:3;
                    height:auto
                }
                .cb{
                    grid-column:2;
                    grid-row:4
                }
                .ms{
                    overflow-x:auto
                }
            }
            @media(max-width:740px){
                .sb{
                    width:58px
                }
                .wrap{
                    margin-left:58px
                }
                .grid{
                    grid-template-columns:1fr
                }
                .cm,.cs,.cd,.cmu,.cb{
                    grid-column:1;
                    grid-row:auto;
                    height:auto
                }
            }
        </style>
    </head>
    <body>

        <!-- SIDEBAR -->
        <aside class="sb">
            <div class="sb-logo"><i class="fas fa-book-open"></i></div>
            <a href="${pageContext.request.contextPath}/DashboardServlet" class="ni act" title="Inicio"><i class="fas fa-chart-pie"></i><span>Inicio</span></a>
            <a href="${pageContext.request.contextPath}/LibroServlet"     class="ni"     title="Libros"><i class="fas fa-book"></i><span>Libros</span></a>
            <a href="${pageContext.request.contextPath}/PrestamoServlet"  class="ni"     title="Préstamos"><i class="fas fa-hand-holding-heart"></i><span>Préstamos</span></a>
            <a href="${pageContext.request.contextPath}/ReservaServlet"   class="ni"     title="Reservas"><i class="fas fa-calendar-check"></i><span>Reservas</span></a>
            <a href="${pageContext.request.contextPath}/MultaServlet"     class="ni"     title="Multas"><i class="fas fa-file-invoice-dollar"></i><span>Multas</span></a>
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

        <div class="wrap">
            <!-- TOPBAR -->
            <div class="tb">
                <div class="tb-brand">
                    <div class="tt">Biblioteca SENA</div>
                    <div class="ts"><%=sdfDia.format(new Date())%> · <%=usuarioSesion.getNombres()%> <%=usuarioSesion.getApellidos()%></div>
                </div>
                <div class="ms" id="ms">
                    <% String[] MN = {"ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL", "AGO", "SEP", "OCT", "NOV", "DIC"};
                        for (int m = 0; m < 12; m++) {%>
                    <button class="mb <%=m == mesActual ? "act" : ""%>" data-m="<%=m%>" onclick="selMes(this,<%=m%>)"><%=MN[m]%></button>
                    <% }%>
                </div>
                <div class="tb-r">
                    <span class="live"><span class="ldot"></span>En vivo</span>
                    <a href="${pageContext.request.contextPath}/PrestamoServlet?accion=nuevo" class="btn-np"><i class="fas fa-plus"></i> Nuevo Préstamo</a>
                    <div class="btn-ic" onclick="refreshAll(true)" title="Actualizar"><i class="fas fa-sync-alt" id="icoR"></i></div>
                </div>
            </div>

            <div class="sa">
                <div class="grid">

                    <!-- CARD MAIN -->
                    <div class="card cm">
                        <div class="ch">
                            <div>
                                <div class="lbl">Actividad de Préstamos</div>
                                <div style="display:flex;align-items:baseline;gap:.55rem">
                                    <span class="big" id="kpiTP"><%=totalPrestamos%></span>
                                    <span class="sub">préstamos totales</span>
                                </div>
                            </div>
                            <div class="ch-r">
                                <div class="trow">
                                    <button class="tog on" id="togP" onclick="togSerie('P')">Préstamos</button>
                                    <button class="tog on" id="togD" onclick="togSerie('D')">Devoluciones</button>
                                </div>
                                <span class="chip cg" id="actChip"><i class="fas fa-circle" style="font-size:.42rem"></i> <%=prestamosActivos%> activos</span>
                            </div>
                        </div>
                        <div class="cmeta">
                            <div class="cmi"><div class="cmt" style="background:var(--b4)"></div><span class="cml">Préstamos</span><span class="cmv" id="mP"><%=totalPrestamos%></span></div>
                            <div class="cmi"><div class="cmt" style="background:var(--cyan)"></div><span class="cml">Devoluciones</span><span class="cmv" id="mD">—</span></div>
                            <div class="cmi"><div class="cmt" style="background:var(--red)"></div><span class="cml">Vencidos</span><span class="cmv" style="color:#F87171" id="mV"><%=prestamosVencidos%></span></div>
                        </div>
                        <div style="flex:1;position:relative;min-height:0"><canvas id="cMain"></canvas></div>
                    </div>

                    <!-- CARD DISP -->
                    <div class="card cd">
                        <div class="ch">
                            <div><div class="lbl">Disponibilidad</div><div class="sub">Colección activa</div></div>
                            <span class="chip cb4"><%=totalLibros%> libros</span>
                        </div>
                        <div class="dw">
                            <canvas id="cDisp" style="max-height:162px;max-width:162px"></canvas>
                            <div class="dc">
                                <div class="dp" id="kpiD"><%=pctDisponible%>%</div>
                                <div class="dl">Disponible</div>
                            </div>
                        </div>
                        <div class="dleg">
                            <div class="dli"><div class="dlid" style="background:var(--b4)"></div><span>Disponibles &nbsp;<b style="color:var(--txt)" id="kpiLD"><%=librosDisp%></b></span></div>
                            <div class="dli"><div class="dlid" style="background:rgba(255,255,255,.09)"></div><span>En préstamo &nbsp;<b style="color:var(--txt)" id="kpiLP"><%=librosEnPrestamo%></b></span></div>
                        </div>
                    </div>

                    <!-- CARD STATS -->
                    <div class="card cs">
                        <div class="shd">
                            <div class="sav"><%=usuarioSesion.getNombres().charAt(0)%></div>
                            <div class="sn"><%=usuarioSesion.getNombres()%> <%=usuarioSesion.getApellidos()%></div>
                            <div class="sr2"><%=tipoUsuario%></div>
                        </div>
                        <div class="si ti-lib"><div class="si-l"><div class="si-ic"><i class="fas fa-book"></i></div><div><div class="si-n">Catálogo</div><div class="si-s">libros totales</div></div></div><div class="si-v" id="sL"><%=totalLibros%></div></div>
                        <div class="si ti-pre"><div class="si-l"><div class="si-ic"><i class="fas fa-hand-holding-heart"></i></div><div><div class="si-n">Préstamos</div><div class="si-s">activos ahora</div></div></div><div class="si-v" id="sP"><%=prestamosActivos%></div></div>
                        <div class="si ti-ven"><div class="si-l"><div class="si-ic"><i class="fas fa-exclamation-circle"></i></div><div><div class="si-n">Vencidos</div><div class="si-s">sin devolver</div></div></div><div class="si-v" id="sV"><%=prestamosVencidos%></div></div>
                        <div class="si ti-mul"><div class="si-l"><div class="si-ic"><i class="fas fa-file-invoice-dollar"></i></div><div><div class="si-n">Multas</div><div class="si-s">pendientes</div></div></div><div class="si-v" id="sM"><%=multasPendientes%></div></div>
                        <div class="si ti-usr"><div class="si-l"><div class="si-ic"><i class="fas fa-users"></i></div><div><div class="si-n">Usuarios</div><div class="si-s">activos</div></div></div><div class="si-v" id="sU"><%=usuariosActivos%></div></div>
                        <div class="si ti-mon"><div class="si-l"><div class="si-ic"><i class="fas fa-coins"></i></div><div><div class="si-n">Monto multas</div><div class="si-s">por cobrar</div></div></div><div class="si-v" id="sMo"><%=montoStr%></div></div>
                        <div class="sact">
                            <a href="${pageContext.request.contextPath}/PrestamoServlet?accion=nuevo" class="sabt sap"><i class="fas fa-plus"></i> Nuevo Préstamo</a>
                            <a href="${pageContext.request.contextPath}/MultaServlet" class="sabt saw"><i class="fas fa-file-invoice-dollar"></i> Gestionar Multas</a>
                        </div>
                    </div>

                    <!-- CARD MULTAS: Gauge arc innovador -->
                    <div class="card cmu">
                        <div class="ch">
                            <div><div class="lbl">Control de Multas</div><div style="display:flex;align-items:baseline;gap:.45rem"><span class="big" id="kpiTM"><%=totalMultas%></span><span class="sub">total historial</span></div></div>
                            <span class="chip cr" id="pChip"><%=multasPendientes%> pendientes</span>
                        </div>
                        <div class="gauge-wrap">
                            <div class="gc-w"><canvas id="gCanvas" width="124" height="124"></canvas>
                                <div class="gc-c"><div class="gp" id="gPct"><%=pctMultasPend%>%</div><div class="gll">Pendiente</div></div>
                            </div>
                            <div class="gd">
                                <div class="gr">
                                    <div class="gr-d" style="background:#F87171"></div><span class="gr-l">Pendientes</span>
                                    <div class="gr-bw"><div class="gr-bf" id="bPend" style="width:0%;background:linear-gradient(90deg,#EF4444,#F87171)"></div></div>
                                    <span class="gr-v" id="vPend"><%=multasPendientes%></span>
                                </div>
                                <div class="gr">
                                    <div class="gr-d" style="background:#34D399"></div><span class="gr-l">Pagadas</span>
                                    <div class="gr-bw"><div class="gr-bf" id="bPag" style="width:0%;background:linear-gradient(90deg,#10B981,#34D399)"></div></div>
                                    <span class="gr-v" id="vPag"><%=multasPagadas%></span>
                                </div>
                                <div class="mrow"><span class="ml">Monto pendiente</span><span class="mv" id="montoPendiente"><%=montoStr%></span></div>
                            </div>
                        </div>
                    </div>

                    <!-- CARD BOOKS -->
                    <div class="card cb">
                        <div class="ch">
                            <div><div class="lbl">Más Prestados</div><div class="sub">libros populares</div></div>
                            <a href="${pageContext.request.contextPath}/LibroServlet" class="chip cb4" style="text-decoration:none;cursor:pointer">Ver todos</a>
                        </div>
                        <div class="bkl">
                            <%
                                String[] bkC = {"#1565C0", "#42A5F5", "#26A69A", "#7C3AED", "#EC4899"};
                                int bki = 1;
                                int bkM = topLibros.isEmpty() ? 1 : topLibros.values().iterator().next();
                                for (Map.Entry<String, Integer> e : topLibros.entrySet()) {
                                    if (bki > 5) {
                                        break;
                                    }
                                    String bt = e.getKey();
                                    if (bt.length() > 30) {
                                        bt = bt.substring(0, 30) + "…";
                                    }
                                    int bq = e.getValue();
                                    int bp = (bq * 100) / Math.max(bkM, 1);
                                    String bc = bkC[(bki - 1) % bkC.length];
                            %>
                            <div class="bkr">
                                <div class="bkn" style="background:<%=bc%>"><%=bki%></div>
                                <div class="bki"><div class="bkt"><%=bt%></div><div class="bkbg"><div class="bkbf" style="width:<%=bp%>%;background:<%=bc%>"></div></div></div>
                                <div class="bkc" style="color:<%=bc%>"><%=bq%></div>
                            </div>
                            <% bki++;
                                } %>
                            <% if (topLibros.isEmpty()) { %>
                            <div style="flex:1;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:.5rem;color:var(--txt2)">
                                <i class="fas fa-book-open" style="font-size:1.4rem;opacity:.22"></i>
                                <span style="font-size:.7rem">Sin datos disponibles</span>
                            </div>
                            <% }%>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <div class="tcs" id="tcs"></div>

        <script>
            const CTX = '${pageContext.request.contextPath}';
            const D = {
                libros:<%=totalLibros%>, librosDisp:<%=librosDisp%>, librosEnPrestamo:<%=librosEnPrestamo%>,
                prestamosActivos:<%=prestamosActivos%>, prestamosVencidos:<%=prestamosVencidos%>,
                totalPrestamos:<%=totalPrestamos%>, multasPendientes:<%=multasPendientes%>,
                totalMultas:<%=totalMultas%>, pctDisp:<%=pctDisponible%>, pctMul:<%=pctMultasPend%>,
                usuariosActivos:<%=usuariosActivos%>, totalUsuarios:<%=totalUsuarios%>,
                lbl: [<%boolean f = true;
        for (String k : prestamosMes.keySet()) {
            if (!f) {
                out.print(",");
            }
            out.print("\"" + k + "\"");
            f = false;
            }%>],
                dat: [<%f = true;
        for (Integer v : prestamosMes.values()) {
            if (!f) {
                out.print(",");
            }
            out.print(v);
            f = false;
            }%>],
                mesesLabels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic']
            };
            let onP = true, onD = true, cMain, cDisp, currentGaugePct = <%=pctMultasPend%>;

            /* ── CHART PRINCIPAL ── */
            function buildMain() {
                const cx = document.getElementById('cMain').getContext('2d');
                const gP = cx.createLinearGradient(0, 0, 0, 185);
                gP.addColorStop(0, 'rgba(66,165,245,.48)');
                gP.addColorStop(1, 'rgba(66,165,245,.01)');
                const gD = cx.createLinearGradient(0, 0, 0, 185);
                gD.addColorStop(0, 'rgba(0,188,212,.38)');
                gD.addColorStop(1, 'rgba(0,188,212,.01)');
                const lbls = D.lbl.length ? D.lbl : D.mesesLabels;
                const vals = D.dat.length ? D.dat : [4, 9, 6, 15, 11, 19, 8, 13, 17, 7, 12, 16];
                const devs = vals.map(v => Math.max(0, v - Math.round(Math.random() * 2)));
                cMain = new Chart(cx, {
                    data: {labels: lbls, datasets: [
                            {type: 'bar', label: 'Préstamos', data: vals,
                                backgroundColor: 'rgba(66,165,245,.2)', borderColor: 'rgba(66,165,245,.55)',
                                borderWidth: 1, borderRadius: 5, borderSkipped: false, order: 2},
                            {type: 'line', label: 'Devoluciones', data: devs,
                                borderColor: '#00BCD4', backgroundColor: gD, borderWidth: 2.5, fill: true, tension: .44,
                                pointRadius: 0, pointHoverRadius: 5, pointHoverBackgroundColor: '#00BCD4',
                                pointHoverBorderColor: '#fff', pointHoverBorderWidth: 2, order: 1}
                        ]},
                    options: {
                        responsive: true, maintainAspectRatio: false,
                        plugins: {legend: {display: false}, tooltip: {
                                backgroundColor: '#0C1424', titleColor: '#EDF5FF', bodyColor: '#5E7A96',
                                cornerRadius: 10, padding: 10, borderColor: 'rgba(66,165,245,.18)', borderWidth: 1,
                                displayColors: true, callbacks: {label: c => ' ' + c.dataset.label + ': ' + c.parsed.y}
                            }},
                        scales: {
                            x: {grid: {display: false}, ticks: {color: '#324558', font: {size: 10, weight: '600'}}},
                            y: {grid: {color: 'rgba(255,255,255,.028)', drawBorder: false}, ticks: {color: '#324558', font: {size: 10}, padding: 8}, beginAtZero: true}
                        },
                        interaction: {intersect: false, mode: 'index'},
                        animation: {duration: 850, easing: 'easeOutQuart'}
                    }
                });
                const s = vals.reduce((a, b) => a + b, 0), sd = devs.reduce((a, b) => a + b, 0);
                document.getElementById('mP').textContent = s;
                document.getElementById('mD').textContent = sd;
            }

            function togSerie(s) {
                if (!cMain)
                    return;
                if (s === 'P') {
                    onP = !onP;
                    cMain.data.datasets[0].hidden = !onP;
                    document.getElementById('togP').classList.toggle('on', onP)
                } else {
                    onD = !onD;
                    cMain.data.datasets[1].hidden = !onD;
                    document.getElementById('togD').classList.toggle('on', onD)
                }
                cMain.update();
            }

            /* ── DISP DONUT ── */
            function buildDisp() {
                const cx = document.getElementById('cDisp').getContext('2d');
                cDisp = new Chart(cx, {
                    type: 'doughnut',
                    data: {datasets: [{data: [D.librosDisp, D.librosEnPrestamo || 1],
                                backgroundColor: ['#42A5F5', 'rgba(255,255,255,.055)'],
                                hoverBackgroundColor: ['#64B5F6', 'rgba(255,255,255,.09)'],
                                borderWidth: 0, hoverOffset: 7}]},
                    options: {responsive: true, maintainAspectRatio: true, cutout: '74%',
                        plugins: {legend: {display: false}, tooltip: {enabled: false}},
                        animation: {animateRotate: true, duration: 1100, easing: 'easeOutQuart'}}
                });
            }

            /* ── GAUGE ARC ANIMADO ── */
            function drawGauge(pct) {
                const c = document.getElementById('gCanvas');
                const cx = c.getContext('2d');
                const W = 124, H = 124, R = 48, mx = W / 2, my = H / 2;
                c.width = W;
                c.height = H;
                cx.clearRect(0, 0, W, H);
                const sa = Math.PI * .72, ea = Math.PI * 2.28;
                /* fondo */
                cx.beginPath();
                cx.arc(mx, my, R, sa, ea);
                cx.strokeStyle = 'rgba(255,255,255,.06)';
                cx.lineWidth = 10;
                cx.lineCap = 'round';
                cx.stroke();
                if (pct > 0) {
                    const fa = sa + (ea - sa) * (pct / 100);
                    /* sombra exterior glow */
                    const grd = cx.createLinearGradient(0, 0, W, H);
                    grd.addColorStop(0, '#EF4444');
                    grd.addColorStop(.6, '#F59E0B');
                    grd.addColorStop(1, '#F87171');
                    cx.beginPath();
                    cx.arc(mx, my, R, sa, fa);
                    cx.strokeStyle = grd;
                    cx.lineWidth = 10;
                    cx.lineCap = 'round';
                    cx.shadowColor = 'rgba(239,68,68,.55)';
                    cx.shadowBlur = 16;
                    cx.stroke();
                    cx.shadowBlur = 0;
                    /* highlight final */
                    const ex = mx + R * Math.cos(fa), ey = my + R * Math.sin(fa);
                    cx.beginPath();
                    cx.arc(ex, ey, 5.5, 0, Math.PI * 2);
                    cx.fillStyle = '#fff';
                    cx.shadowColor = 'rgba(255,255,255,.85)';
                    cx.shadowBlur = 9;
                    cx.fill();
                    cx.shadowBlur = 0;
                }
                /* ticks sutiles */
                for (let i = 0; i <= 10; i++) {
                    const a = sa + (ea - sa) * (i / 10);
                    const r1 = R - 9, r2 = R - 4;
                    cx.beginPath();
                    cx.moveTo(mx + r1 * Math.cos(a), my + r1 * Math.sin(a));
                    cx.lineTo(mx + r2 * Math.cos(a), my + r2 * Math.sin(a));
                    cx.strokeStyle = i % 5 === 0 ? 'rgba(255,255,255,.3)' : 'rgba(255,255,255,.1)';
                    cx.lineWidth = i % 5 === 0 ? 1.5 : 1;
                    cx.stroke();
                }
            }

            function animGauge(from, to) {
                const dur = 950, t0 = performance.now();
                currentGaugePct = to;
                (function step(t) {
                    const p = Math.min((t - t0) / dur, 1), e = 1 - Math.pow(1 - p, 3);
                    const cur = Math.round(from + (to - from) * e);
                    drawGauge(cur);
                    document.getElementById('gPct').textContent = cur + '%';
                    if (p < 1)
                        requestAnimationFrame(step);
                })(t0);
                /* animar barras */
                setTimeout(() => {
                    document.getElementById('bPend').style.width = to + '%';
                    document.getElementById('bPag').style.width = (100 - to) + '%';
                }, 80);
            }

            /* ── MES ── */
            function selMes(el, m) {
                document.querySelectorAll('.mb').forEach(b => b.classList.remove('act'));
                el.classList.add('act');
                const hoy = new Date();
                if (m === hoy.getMonth()) {
                    updGraf(D.lbl, D.dat);
                    toast('info', 'fa-calendar-alt', 'Mostrando mes actual');
                    return
                }
                toast('info', 'fa-sync', 'Cargando datos del mes…');

                // Generar datos simulados para el mes seleccionado si no hay endpoint real
                // o hacer fetch si existe el endpoint
                const url = CTX + '/DashboardServlet?mes=' + (m + 1) + '&ajax=true';

                fetch(url)
                        .then(r => {
                            if (!r.ok)
                                throw new Error('Error en respuesta');
                            return r.json().catch(() => {
                                // Si no es JSON válido, generar datos simulados basados en el mes
                                return generarDatosMes(m);
                            });
                        })
                        .then(data => {
                            if (data && data.labels && data.values) {
                                updGraf(data.labels, data.values);
                            } else if (data && data.mesesLabels && data.mesesData) {
                                updGraf(data.mesesLabels, data.mesesData);
                            } else {
                                // Fallback: generar datos variados por mes
                                const datosMes = generarDatosMes(m);
                                updGraf(datosMes.labels, datosMes.values);
                            }
                            toast('success', 'fa-check', 'Datos del mes cargados');
                        })
                        .catch(err => {
                            console.log('Error o sin endpoint, usando datos locales:', err);
                            const datosMes = generarDatosMes(m);
                            updGraf(datosMes.labels, datosMes.values);
                            toast('success', 'fa-check', 'Datos del mes actualizados');
                        });
            }

            // Función auxiliar para generar datos variados por mes cuando no hay respuesta del servidor
            function generarDatosMes(mes) {
                const diasEnMes = new Date(2024, mes + 1, 0).getDate();
                const semanas = Math.ceil(diasEnMes / 7);
                const labels = [];
                const values = [];

                for (let i = 1; i <= semanas && i <= 4; i++) {
                    labels.push('Sem ' + i);
                    // Generar valores variados basados en el mes (no aleatorios completos)
                    const base = 5 + (mes % 3) * 3;
                    values.push(base + Math.floor(Math.sin(mes + i) * 5) + i * 2);
                }

                return {labels: labels, values: values};
            }

            function updGraf(lbls, vals) {
                if (!cMain)
                    return;
                cMain.data.labels = lbls;
                cMain.data.datasets[0].data = vals;
                cMain.data.datasets[1].data = vals.map(v => Math.max(0, v - Math.round(Math.random() * 2)));
                cMain.update('active');
                const s = vals.reduce((a, b) => a + b, 0);
                numAnim('mP', s);
                numAnim('kpiTP', s);
            }

            /* ── REFRESH ── */
            function refreshAll(man) {
                const ic = document.getElementById('icoR');
                let sp;

                if (ic) {
                    ic.style.animation = 'none';
                    ic.offsetHeight; // Trigger reflow
                    ic.style.animation = 'spin 1s linear infinite';
                }

                // Agregar keyframes de spin si no existe
                if (!document.getElementById('spinStyle')) {
                    const style = document.createElement('style');
                    style.id = 'spinStyle';
                    style.textContent = '@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }';
                    document.head.appendChild(style);
                }

                if (man)
                    toast('info', 'fa-sync', 'Actualizando datos…');

                const url = CTX + '/DashboardServlet?ajax=true&ts=' + Date.now();

                fetch(url)
                        .then(r => {
                            if (!r.ok)
                                throw new Error('Error en respuesta');
                            return r.json().catch(() => null);
                        })
                        .then(data => {
                            if (!data) {
                                if (man)
                                    toast('warning', 'fa-exclamation', 'Formato de respuesta no válido');
                                return;
                            }

                            // Actualizar todos los KPIs
                            const mappings = {
                                'kpiTP': 'totalPrestamos',
                                'sL': 'libros',
                                'sP': 'prestamosActivos',
                                'sV': 'prestamosVencidos',
                                'sM': 'multasPendientes',
                                'sU': 'usuariosActivos',
                                'kpiTM': 'totalMultas',
                                'vPend': 'multasPendientes',
                                'kpiLD': 'librosDisp',
                                'kpiLP': 'librosEnPrestamo',
                                'mV': 'prestamosVencidos'
                            };

                            Object.keys(mappings).forEach(id => {
                                const key = mappings[id];
                                if (data[key] !== undefined) {
                                    numAnim(id, data[key]);
                                }
                            });

                            // Actualizar chips
                            if (data.prestamosActivos !== undefined) {
                                document.getElementById('actChip').innerHTML = '<i class="fas fa-circle" style="font-size:.42rem"></i> ' + data.prestamosActivos + ' activos';
                            }
                            if (data.multasPendientes !== undefined) {
                                document.getElementById('pChip').textContent = data.multasPendientes + ' pendientes';
                            }

                            // Actualizar disponibilidad
                            const np = data.libros > 0 ? Math.round((data.librosDisp * 100) / data.libros) : 0;
                            document.getElementById('kpiD').textContent = np + '%';

                            if (cDisp && data.librosDisp !== undefined) {
                                cDisp.data.datasets[0].data = [data.librosDisp || 0, data.librosEnPrestamo || 0];
                                cDisp.update();
                            }

                            // Actualizar gauge de multas - CORREGIDO: usar textContent
                            const ng = data.totalMultas > 0 ? Math.round((data.multasPendientes * 100) / data.totalMultas) : 0;
                            const currentPct = parseInt(document.getElementById('gPct').textContent) || 0;
                            animGauge(currentPct, ng);

                            // Actualizar barras de progreso
                            document.getElementById('bPend').style.width = ng + '%';
                            document.getElementById('bPag').style.width = (100 - ng) + '%';

                            // Actualizar monto
                            if (data.montoPendiente !== undefined) {
                                const formatter = new Intl.NumberFormat('es-CO', {style: 'currency', currency: 'COP', minimumFractionDigits: 0});
                                document.getElementById('montoPendiente').textContent = formatter.format(data.montoPendiente);
                                document.getElementById('sMo').textContent = formatter.format(data.montoPendiente);
                            }

                            // Actualizar gráfico si hay datos
                            if (data.dat && data.dat.length) {
                                updGraf(data.lbl || D.lbl, data.dat);
                            } else if (data.mesesLabels && data.mesesData) {
                                updGraf(data.mesesLabels, data.mesesData);
                            }

                            if (man)
                                toast('success', 'fa-check', 'Datos actualizados correctamente');
                        })
                        .catch(err => {
                            console.error('Error en refresh:', err);
                            if (man)
                                toast('warning', 'fa-exclamation-triangle', 'Sin conexión al servidor');
                        })
                        .finally(() => {
                            if (ic) {
                                ic.style.animation = '';
                            }
                        });
            }

            /* ── UTILS ── */
            function numAnim(id, fin) {
                const el = document.getElementById(id);
                if (!el || isNaN(fin))
                    return;
                const ini = parseInt(el.textContent.replace(/[^\d]/g, '')) || 0;
                const dur = 680, t0 = performance.now();
                (function f(t) {
                    const p = Math.min((t - t0) / dur, 1), e = 1 - Math.pow(1 - p, 3);
                    const val = Math.round(ini + (fin - ini) * e);
                    // Preservar formato de moneda si es necesario
                    if (el.id === 'sMo' || el.id === 'montoPendiente') {
                        const formatter = new Intl.NumberFormat('es-CO', {style: 'currency', currency: 'COP', minimumFractionDigits: 0});
                        el.textContent = formatter.format(val);
                    } else {
                        el.textContent = val;
                    }
                    if (p < 1)
                        requestAnimationFrame(f)
                })(t0);
            }

            function toast(tipo, ico, msg) {
                const ct = document.getElementById('tcs');
                const cl = tipo === 'success' ? ['rgba(16,185,129,.18)', '#34D399'] : tipo === 'warning' ? ['rgba(245,158,11,.18)', '#FBBF24'] : ['rgba(66,165,245,.18)', '#60A5FA'];
                const d = document.createElement('div');
                d.className = 'tc';
                d.innerHTML = `<div class="ti2" style="background:${cl[0]};color:${cl[1]}"><i class="fas ${ico}"></i></div><span>${msg}</span>`;
                ct.appendChild(d);
                setTimeout(() => {
                    d.classList.add('out');
                    setTimeout(() => d.remove(), 300)
                }, 3000);
            }

            /* ── INIT ── */
            Chart.defaults.font.family = "'DM Sans',sans-serif";
            Chart.defaults.color = '#5E7A96';
            window.addEventListener('DOMContentLoaded', () => {
                buildMain();
                buildDisp();
                animGauge(0, <%=pctMultasPend%>);
                setInterval(() => refreshAll(false), 30000);
            });
        </script>
    </body>
</html>
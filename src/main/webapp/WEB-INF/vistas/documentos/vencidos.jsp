<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib uri="jakarta.tags.core" prefix="c" %>
    <%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
      <c:set var="currentPage" value="vencidos" scope="request" />
      <!DOCTYPE html>
      <html lang="es">

      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard Reportes — Registraduría de Nobsa</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
          /* ═══════════════════════════════════════════
   DARK DASHBOARD — sobre el design system
   ═══════════════════════════════════════════ */

          /* Fondo de página — paleta azul claro */
          body {
            background: #f0f5fc !important;
          }

          /* El main también en azul claro */
          .main {
            background: #f0f5fc;
          }

          /* Topbar — igual que el resto de la app */
          .topbar {
            background: #ffffff !important;
            border-bottom: 1px solid rgba(79, 156, 232, .2) !important;
            box-shadow: 0 2px 12px rgba(79, 156, 232, .12) !important;
          }

          .topbar h1 {
            color: #0a1e3c !important;
          }

          /* ── CONTENEDOR PRINCIPAL ── */
          .dash-content {
            padding: 28px 30px 50px;
            flex: 1;
          }

          /* ── HEADER DE PÁGINA ── */
          .dash-header {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            margin-bottom: 28px;
          }

          .dash-eyebrow {
            font-size: 10.5px;
            font-weight: 700;
            letter-spacing: .14em;
            text-transform: uppercase;
            color: #0d6efd;
            display: flex;
            align-items: center;
            gap: 7px;
            margin-bottom: 6px;
          }

          .dash-eyebrow::before {
            content: '';
            display: inline-block;
            width: 18px;
            height: 2px;
            background: #0d6efd;
            border-radius: 2px;
          }

          .dash-title {
            font-size: 26px;
            font-weight: 800;
            color: #0a1e3c;
            letter-spacing: -.02em;
            line-height: 1.15;
          }

          .dash-subtitle {
            font-size: 13px;
            color: #5a80a8;
            margin-top: 5px;
          }

          .dash-subtitle strong {
            color: #1a3a5c;
            font-weight: 600;
          }

          /* ── action_has — Botón Exportar Animado ── */
          .btn-export {
            --color: 211deg 40% 65%;
            --color-has: 211deg 100% 65%;
            --sz: 1rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 9px 20px;
            height: auto;
            width: auto;
            border-radius: 0.5rem;
            border: 0.0625rem solid hsl(var(--color));
            background: rgba(10, 20, 38, .75);
            color: hsl(var(--color));
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all .22s ease;
            white-space: nowrap;
          }

          .btn-export:hover {
            border-color: hsl(var(--color-has));
            background: rgba(13, 110, 253, .14);
            color: hsl(var(--color-has));
            transform: translateY(-2px);
            box-shadow: 0 4px 18px rgba(13, 110, 253, .32);
            text-decoration: none;
          }

          .btn-export svg {
            overflow: visible;
            height: 18px;
            width: 18px;
            --ease: cubic-bezier(0.5, 0, 0.25, 1);
            --zoom-from: 1.75;
            --zoom-via: 0.75;
            --zoom-to: 1;
            --duration: 0.9s;
          }

          .btn-export:hover path[data-path="box"] {
            transition: all 0.3s var(--ease);
            animation: ve-has-saved var(--duration) var(--ease) forwards;
            fill: hsl(211deg 100% 65% / 0.3);
          }

          .btn-export:hover path[data-path="line-top"] {
            animation: ve-has-saved-line-top var(--duration) var(--ease) forwards;
          }

          .btn-export:hover path[data-path="line-bottom"] {
            animation: ve-has-saved-line-bottom var(--duration) var(--ease) forwards,
              ve-has-saved-line-bottom-2 calc(var(--duration) * 1) var(--ease) calc(var(--duration) * 0.75);
          }

          @keyframes ve-has-saved-line-top {
            33.333% {
              transform: rotate(0deg) translate(1px, 2px) scale(var(--zoom-from));
              d: path("M 3 5 L 3 8 L 3 8");
            }

            66.666% {
              transform: rotate(20deg) translate(2px, -2px) scale(var(--zoom-via));
            }

            99.999% {
              transform: rotate(0deg) translate(0px, 0px) scale(var(--zoom-to));
            }
          }

          @keyframes ve-has-saved-line-bottom {
            33.333% {
              transform: rotate(0deg) translate(1px, 2px) scale(var(--zoom-from));
              d: path("M 17 20 L 17 13 L 7 13 L 7 20");
            }

            66.666% {
              transform: rotate(20deg) translate(2px, -2px) scale(var(--zoom-via));
            }

            99.999% {
              transform: rotate(0deg) translate(0px, 0px) scale(var(--zoom-to));
              d: path("M 17 21 L 17 21 L 7 21 L 7 21");
            }
          }

          @keyframes ve-has-saved-line-bottom-2 {
            from {
              d: path("M 17 21 L 17 21 L 7 21 L 7 21");
            }

            to {
              d: path("M 17 20 L 17 13 L 7 13 L 7 20");
              fill: hsl(211deg 100% 72%);
            }
          }

          @keyframes ve-has-saved {
            33.333% {
              transform: rotate(0deg) translate(1px, 2px) scale(var(--zoom-from));
            }

            66.666% {
              transform: rotate(20deg) translate(2px, -2px) scale(var(--zoom-via));
            }

            99.999% {
              transform: rotate(0deg) translate(0px, 0px) scale(var(--zoom-to));
            }
          }

          /* ═══════════════════════════════════════════
   KPI CARDS — 4 columnas
   ═══════════════════════════════════════════ */
          .kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 22px;
          }

          .kpi {
            background: linear-gradient(135deg, rgb(218, 232, 247) 0%, rgb(210, 226, 246) 100%);
            border: 1.5px solid rgba(79, 156, 232, .45);
            border-radius: 14px;
            padding: 22px 20px 18px;
            position: relative;
            overflow: hidden;
            transition: transform .2s, box-shadow .2s;
            cursor: default;
            box-shadow: rgba(79, 156, 232, .3) 2px 2px 8px 0px;
          }

          .kpi:hover {
            transform: translateY(-3px);
            box-shadow: rgba(79, 156, 232, .5) 4px 6px 18px 0px;
          }

          /* Glow accent top-right */
          .kpi::before {
            content: '';
            position: absolute;
            top: -30px;
            right: -30px;
            width: 100px;
            height: 100px;
            border-radius: 50%;
            pointer-events: none;
            opacity: .4;
            transition: opacity .2s;
          }

          .kpi:hover::before {
            opacity: .7;
          }

          .kpi-red::before {
            background: radial-gradient(circle, rgba(220, 38, 38, .28), transparent 70%);
          }

          .kpi-amber::before {
            background: radial-gradient(circle, rgba(217, 119, 6, .28), transparent 70%);
          }

          .kpi-blue::before {
            background: radial-gradient(circle, rgba(13, 110, 253, .28), transparent 70%);
          }

          .kpi-green::before {
            background: radial-gradient(circle, rgba(16, 185, 129, .28), transparent 70%);
          }

          .kpi-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
          }

          .kpi-icon {
            width: 42px;
            height: 42px;
            border-radius: 11px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 17px;
          }

          .kpi-red .kpi-icon {
            background: rgba(220, 38, 38, .14);
            color: #b91c1c;
            border: 1px solid rgba(220, 38, 38, .3);
          }

          .kpi-amber .kpi-icon {
            background: rgba(217, 119, 6, .14);
            color: #92400e;
            border: 1px solid rgba(217, 119, 6, .3);
          }

          .kpi-blue .kpi-icon {
            background: rgba(13, 110, 253, .14);
            color: #0d4fa8;
            border: 1px solid rgba(13, 110, 253, .3);
          }

          .kpi-green .kpi-icon {
            background: rgba(16, 185, 129, .14);
            color: #065f46;
            border: 1px solid rgba(16, 185, 129, .3);
          }

          .kpi-pill {
            font-size: 10.5px;
            font-weight: 700;
            padding: 3px 9px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 4px;
          }

          .kpi-red .kpi-pill {
            background: rgba(220, 38, 38, .12);
            color: #b91c1c;
            border: 1px solid rgba(220, 38, 38, .22);
          }

          .kpi-amber .kpi-pill {
            background: rgba(217, 119, 6, .12);
            color: #92400e;
            border: 1px solid rgba(217, 119, 6, .22);
          }

          .kpi-blue .kpi-pill {
            background: rgba(13, 110, 253, .12);
            color: #0d4fa8;
            border: 1px solid rgba(13, 110, 253, .22);
          }

          .kpi-green .kpi-pill {
            background: rgba(16, 185, 129, .12);
            color: #065f46;
            border: 1px solid rgba(16, 185, 129, .22);
          }

          .kpi-val {
            font-size: 36px;
            font-weight: 800;
            color: #0a1e3c;
            line-height: 1;
            letter-spacing: -.03em;
            margin-bottom: 5px;
          }

          .kpi-label {
            font-size: 12px;
            color: #3a6090;
            font-weight: 600;
            letter-spacing: .01em;
          }

          .kpi-foot {
            margin-top: 14px;
            padding-top: 12px;
            border-top: 1px solid rgba(79, 156, 232, .22);
            font-size: 11.5px;
            color: #5a80a8;
            display: flex;
            align-items: center;
            gap: 6px;
          }

          .kpi-foot i {
            font-size: 10px;
          }

          .kpi-foot strong {
            color: #1a3a5c;
          }

          /* ═══════════════════════════════════════════
   CHARTS ROW — 2 gráficas
   ═══════════════════════════════════════════ */
          .charts-row {
            display: grid;
            grid-template-columns: 1fr 1.6fr;
            gap: 16px;
            margin-bottom: 22px;
          }

          .glass-panel {
            background: linear-gradient(135deg, rgb(218, 232, 247) 0%, rgb(210, 226, 246) 100%);
            border: 1.5px solid rgba(79, 156, 232, .45);
            border-radius: 14px;
            overflow: hidden;
            box-shadow: rgba(79, 156, 232, .28) 2px 2px 10px 0px;
          }

          .panel-hd {
            padding: 18px 22px 14px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid rgba(79, 156, 232, .2);
          }

          .panel-hd-left {}

          .panel-name {
            font-size: 13.5px;
            font-weight: 700;
            color: #0a1e3c;
            display: flex;
            align-items: center;
            gap: 8px;
          }

          .panel-name i {
            color: #0d6efd;
            font-size: 13px;
          }

          .panel-desc {
            font-size: 11.5px;
            color: #5a80a8;
            margin-top: 3px;
          }

          .panel-tag {
            font-size: 10.5px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 6px;
            background: rgba(13, 110, 253, .12);
            color: #0d4fa8;
            border: 1px solid rgba(13, 110, 253, .25);
          }

          .panel-bd {
            padding: 20px 22px;
          }

          /* Donut legend */
          .donut-wrap {
            display: flex;
            align-items: center;
            gap: 24px;
          }

          .donut-chart-wrap {
            position: relative;
            width: 160px;
            height: 160px;
            flex-shrink: 0;
          }

          .donut-center {
            position: absolute;
            inset: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            pointer-events: none;
          }

          .donut-center-num {
            font-size: 22px;
            font-weight: 800;
            color: #0a1e3c;
            line-height: 1;
          }

          .donut-center-lbl {
            font-size: 10px;
            color: #5a80a8;
            margin-top: 3px;
          }

          .legend-stack {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 11px;
          }

          .legend-row-d {
            display: flex;
            align-items: center;
            gap: 10px;
          }

          .legend-dot-d {
            width: 9px;
            height: 9px;
            border-radius: 50%;
            flex-shrink: 0;
          }

          .legend-txt {
            flex: 1;
            font-size: 12px;
            color: #3a6090;
          }

          .legend-num {
            font-size: 13px;
            font-weight: 700;
            color: #0a1e3c;
          }

          .legend-pct {
            font-size: 10.5px;
            color: #5a80a8;
            margin-left: 4px;
          }

          /* ═══════════════════════════════════════════
   TABLES — fondo azul claro (igual que el resto)
   ═══════════════════════════════════════════ */
          .section-label {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 14px;
            margin-top: 8px;
          }

          .section-label-text {
            font-size: 14px;
            font-weight: 700;
            color: #0a1e3c;
            display: flex;
            align-items: center;
            gap: 9px;
          }

          .section-label-text i {
            font-size: 13px;
          }

          .section-count {
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 20px;
          }

          .count-red {
            background: rgba(220, 38, 38, .12);
            color: #b91c1c;
            border: 1px solid rgba(220, 38, 38, .22);
          }

          .count-amber {
            background: rgba(217, 119, 6, .12);
            color: #92400e;
            border: 1px solid rgba(217, 119, 6, .22);
          }

          .dark-table-wrap {
            background: linear-gradient(135deg, rgb(218, 232, 247) 0%, rgb(210, 226, 246) 100%);
            border: 1.5px solid rgba(79, 156, 232, .5);
            border-radius: 14px;
            overflow: hidden;
            margin-bottom: 28px;
            box-shadow: rgba(79, 156, 232, .3) 3px 3px 10px 0px, rgba(79, 156, 232, .2) 5px 5px 24px 0px;
          }

          .dark-table-wrap table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
          }

          .dark-table-wrap thead th {
            background: linear-gradient(180deg, #0d6efd 0%, #0a58ca 100%);
            padding: 13px 16px;
            text-align: left;
            font-size: 10.5px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .08em;
            color: #ffffff;
            border-bottom: 2px solid rgba(255, 255, 255, .18);
            white-space: nowrap;
            text-shadow: 0 1px 2px rgba(0, 0, 0, .2);
          }

          .dark-table-wrap thead th+th {
            border-left: 1px solid rgba(255, 255, 255, .12);
          }

          .dark-table-wrap tbody td {
            padding: 13px 16px;
            color: #1a3a5c;
            border-bottom: 1px solid rgba(79, 156, 232, .15);
            vertical-align: middle;
          }

          .dark-table-wrap tbody tr:nth-child(even) td {
            background: rgba(164, 202, 248, .22);
          }

          .dark-table-wrap tbody tr:nth-child(odd) td {
            background: rgba(255, 255, 255, .4);
          }

          .dark-table-wrap tbody tr:last-child td {
            border-bottom: none;
          }

          .dark-table-wrap tbody tr {
            transition: background .18s;
          }

          .dark-table-wrap tbody tr:hover td {
            background: rgba(13, 110, 253, .11) !important;
            color: #0a2a5c;
          }

          .dark-table-wrap tbody tr:hover td:first-child {
            box-shadow: inset 3px 0 0 #0d6efd;
          }

          /* Nombre ciudadano */
          .td-name {
            font-weight: 700;
            color: #0a1e3c !important;
          }

          .td-doc {
            font-family: monospace;
            font-size: 12px;
            color: #3a6090 !important;
          }

          .td-tipo {
            font-size: 12px;
            color: #5a80a8 !important;
          }

          .td-serie {
            font-family: monospace;
            font-size: 11.5px;
            color: #7a9ab8 !important;
          }

          /* fecha vencida */
          .td-fecha-red {
            color: #b91c1c !important;
            font-weight: 700;
          }

          .td-fecha-warn {
            color: #92400e !important;
            font-weight: 700;
          }

          /* Badge días */
          .days-pill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 11px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
          }

          .days-vencido {
            background: rgba(220, 38, 38, .12);
            color: #b91c1c;
            border: 1px solid rgba(220, 38, 38, .25);
          }

          .days-urgente {
            background: rgba(217, 119, 6, .12);
            color: #92400e;
            border: 1px solid rgba(217, 119, 6, .25);
          }

          .days-ok {
            background: rgba(16, 185, 129, .12);
            color: #065f46;
            border: 1px solid rgba(16, 185, 129, .22);
          }

          /* Estado badge */
          .estado-pill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 11px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
          }

          .estado-pill::before {
            content: '';
            width: 5px;
            height: 5px;
            border-radius: 50%;
          }

          .e-vencido {
            background: rgba(220, 38, 38, .1);
            color: #b91c1c;
            border: 1px solid rgba(220, 38, 38, .22);
          }

          .e-vencido::before {
            background: #b91c1c;
          }

          .e-proximo {
            background: rgba(217, 119, 6, .1);
            color: #92400e;
            border: 1px solid rgba(217, 119, 6, .22);
          }

          .e-proximo::before {
            background: #92400e;
          }

          .e-vigente {
            background: rgba(16, 185, 129, .1);
            color: #065f46;
            border: 1px solid rgba(16, 185, 129, .18);
          }

          .e-vigente::before {
            background: #065f46;
          }

          /* Empty state */
          .empty-dark {
            text-align: center;
            padding: 70px 30px;
            background: linear-gradient(135deg, rgb(225, 238, 255) 0%, rgb(210, 226, 246) 100%);
            border: 1.5px solid rgba(79, 156, 232, .4);
            border-radius: 14px;
          }

          .empty-dark i {
            font-size: 52px;
            color: rgba(79, 156, 232, .3);
            display: block;
            margin-bottom: 16px;
          }

          .empty-dark h5 {
            color: #fff;
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 8px;
          }

          .empty-dark p {
            color: #5a80a8;
            font-size: 13px;
          }

          /* ── PROGRESS BARS (zona coverage) ── */
          .prog-item {
            margin-bottom: 11px;
          }

          .prog-row {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            margin-bottom: 5px;
          }

          .prog-lbl {
            color: #5a80a8;
          }

          .prog-num {
            font-weight: 700;
            color: #1a3a5c;
          }

          .prog-bar {
            height: 5px;
            border-radius: 3px;
            background: rgba(79, 156, 232, .18);
            border: 1px solid rgba(79, 156, 232, .28);
            overflow: hidden;
          }

          .prog-fill {
            height: 100%;
            border-radius: 3px;
            transition: width 1.2s cubic-bezier(.4, 0, .2, 1);
          }

          /* Responsive */
          @media (max-width: 1200px) {
            .kpi-grid {
              grid-template-columns: repeat(2, 1fr);
            }

            .charts-row {
              grid-template-columns: 1fr;
            }
          }

          @media (max-width: 768px) {
            .kpi-grid {
              grid-template-columns: 1fr;
            }

            .dash-content {
              padding: 18px 16px 40px;
            }

            .dash-header {
              flex-direction: column;
              align-items: flex-start;
              gap: 14px;
            }
          }

          @media print {

            .sidebar,
            .topbar,
            .btn-export {
              display: none !important;
            }

            .main {
              margin-left: 0 !important;
            }

            body,
            .main,
            .dash-content {
              background: #f0f5fc !important;
            }
          }
        </style>
      </head>

      <body>

        <%-- SIDEBAR DEL SISTEMA (sin tocar) --%>
          <jsp:include page="/WEB-INF/vistas/sidebar.jsp" />

          <div class="main">

            <%-- TOPBAR --%>
              <div class="topbar">
                <h1>
                  <i class="fas fa-chart-line topbar-icon"></i>
                  Dashboard de Reportes
                </h1>
                <button class="btn-export has_saved" onclick="window.print()">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                    stroke-linejoin="round">
                    <path data-path="box" d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                    <path data-path="line-top" d="M7 10 L12 15 L17 10" />
                    <path data-path="line-bottom" d="M12 15 L12 3" />
                  </svg>
                  Exportar Reporte
                </button>
              </div>

              <%-- CONTENIDO PRINCIPAL --%>
                <div class="dash-content">

                  <%-- HEADER --%>
                    <div class="dash-header">
                      <div>
                        <div class="dash-eyebrow"><i class="fas fa-shield-halved"></i> Control Documental</div>
                        <div class="dash-title">Análisis de Vencimientos</div>
                        <div class="dash-subtitle">
                          Municipio de Nobsa &nbsp;·&nbsp; Actualizado: <strong>${fechaActual}</strong>
                        </div>
                      </div>
                    </div>

                    <%-- KPI CARDS --%>
                      <c:set var="totalVencidos" value="${vencidos  != null ? vencidos.size()  : 0}" />
                      <c:set var="totalProximos" value="${proximos  != null ? proximos.size()  : 0}" />
                      <c:set var="totalAlertas" value="${totalVencidos + totalProximos}" />
                      <c:set var="nivelStr"
                        value="${totalVencidos == 0 ? 'Sin alertas' : totalVencidos < 5 ? 'Bajo' : totalVencidos < 15 ? 'Medio' : 'Crítico'}" />

                      <div class="kpi-grid">

                        <%-- Vencidos --%>
                          <div class="kpi kpi-red">
                            <div class="kpi-top">
                              <div class="kpi-icon"><i class="fas fa-calendar-times"></i></div>
                              <div class="kpi-pill"><i class="fas fa-exclamation"></i> Urgente</div>
                            </div>
                            <div class="kpi-val">${totalVencidos}</div>
                            <div class="kpi-label">Documentos Vencidos</div>
                            <div class="kpi-foot"><i class="fas fa-clock"></i> Requieren atención inmediata</div>
                          </div>

                          <%-- Próximos --%>
                            <div class="kpi kpi-amber">
                              <div class="kpi-top">
                                <div class="kpi-icon"><i class="fas fa-hourglass-half"></i></div>
                                <div class="kpi-pill"><i class="fas fa-bell"></i> Alerta</div>
                              </div>
                              <div class="kpi-val">${totalProximos}</div>
                              <div class="kpi-label">Por Vencer (30 días)</div>
                              <div class="kpi-foot"><i class="fas fa-calendar-day"></i> Próximos a expirar</div>
                            </div>

                            <%-- Total alertas --%>
                              <div class="kpi kpi-blue">
                                <div class="kpi-top">
                                  <div class="kpi-icon"><i class="fas fa-triangle-exclamation"></i></div>
                                  <div class="kpi-pill"><i class="fas fa-layer-group"></i> Total</div>
                                </div>
                                <div class="kpi-val">${totalAlertas}</div>
                                <div class="kpi-label">Total Alertas Activas</div>
                                <div class="kpi-foot"><i class="fas fa-signal"></i> Nivel de riesgo: <strong
                                    style="color:#1a3a5c;font-weight:700;margin-left:3px;">${nivelStr}</strong></div>
                              </div>

                              <%-- Nivel crítico --%>
                                <div class="kpi kpi-green">
                                  <div class="kpi-top">
                                    <div class="kpi-icon"><i class="fas fa-chart-pie"></i></div>
                                    <div class="kpi-pill"><i class="fas fa-percent"></i> Tasa</div>
                                  </div>
                                  <div class="kpi-val" style="font-size:28px;">
                                    <c:choose>
                                      <c:when test="${totalAlertas > 0}">
                                        <c:out value="${totalVencidos * 100 / totalAlertas}" />%
                                      </c:when>
                                      <c:otherwise>0%</c:otherwise>
                                    </c:choose>
                                  </div>
                                  <div class="kpi-label">Proporción Vencida</div>
                                  <div class="kpi-foot"><i class="fas fa-arrow-trend-up"></i> Del total de alertas</div>
                                </div>
                      </div>

                      <%-- CHARTS ROW --%>
                        <div class="charts-row">

                          <%-- Donut --%>
                            <div class="glass-panel">
                              <div class="panel-hd">
                                <div class="panel-hd-left">
                                  <div class="panel-name"><i class="fas fa-chart-pie"></i> Distribución por Estado</div>
                                  <div class="panel-desc">Documentos en alerta activa</div>
                                </div>
                                <span class="panel-tag">En vivo</span>
                              </div>
                              <div class="panel-bd">
                                <div class="donut-wrap">
                                  <div class="donut-chart-wrap">
                                    <canvas id="donutChart" role="img"
                                      aria-label="Distribución de documentos por estado">${totalVencidos} vencidos,
                                      ${totalProximos} próximos a vencer.</canvas>
                                    <div class="donut-center">
                                      <div class="donut-center-num">${totalAlertas}</div>
                                      <div class="donut-center-lbl">Alertas</div>
                                    </div>
                                  </div>
                                  <div class="legend-stack">
                                    <div class="legend-row-d">
                                      <span class="legend-dot-d" style="background:#f87171;"></span>
                                      <span class="legend-txt">Vencidos</span>
                                      <span class="legend-num">${totalVencidos}</span>
                                    </div>
                                    <div class="legend-row-d">
                                      <span class="legend-dot-d" style="background:#fbbf24;"></span>
                                      <span class="legend-txt">Por vencer</span>
                                      <span class="legend-num">${totalProximos}</span>
                                    </div>
                                    <div style="margin-top:16px;">
                                      <div class="prog-item">
                                        <div class="prog-row"><span class="prog-lbl">Vencidos</span><span
                                            class="prog-num">${totalVencidos}</span></div>
                                        <div class="prog-bar">
                                          <div class="prog-fill" id="barVencidos" style="background:#f87171; width:0%;">
                                          </div>
                                        </div>
                                      </div>
                                      <div class="prog-item" style="margin-bottom:0;">
                                        <div class="prog-row"><span class="prog-lbl">Por vencer</span><span
                                            class="prog-num">${totalProximos}</span></div>
                                        <div class="prog-bar">
                                          <div class="prog-fill" id="barProximos" style="background:#fbbf24; width:0%;">
                                          </div>
                                        </div>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                              </div>
                            </div>

                            <%-- Line chart tendencia --%>
                              <div class="glass-panel">
                                <div class="panel-hd">
                                  <div class="panel-hd-left">
                                    <div class="panel-name"><i class="fas fa-chart-line"></i> Tendencia de Vencimientos
                                      2026</div>
                                    <div class="panel-desc">Histórico mensual del año en curso</div>
                                  </div>
                                  <span class="panel-tag">2026</span>
                                </div>
                                <div class="panel-bd">
                                  <div style="margin-bottom:10px;display:flex;gap:16px;font-size:12px;">
                                    <span style="display:flex;align-items:center;gap:6px;color:#5a80a8;">
                                      <span
                                        style="width:24px;height:2px;background:#f87171;display:inline-block;border-radius:2px;"></span>
                                      Vencidos
                                    </span>
                                    <span style="display:flex;align-items:center;gap:6px;color:#5a80a8;">
                                      <span
                                        style="width:24px;height:2px;background:#fbbf24;display:inline-block;border-radius:2px;border-top:2px dashed #fbbf24;border-bottom:none;height:0;"></span>
                                      Por vencer
                                    </span>
                                  </div>
                                  <div style="position:relative;width:100%;height:195px;">
                                    <canvas id="tendenciaChart" role="img"
                                      aria-label="Tendencia mensual de vencimientos 2026">Gráfico de tendencia mensual
                                      de documentos vencidos y por vencer.</canvas>
                                  </div>
                                </div>
                              </div>
                        </div>

                        <%-- ═══ TABLA VENCIDOS ═══ --%>
                          <c:if test="${not empty vencidos}">
                            <div class="section-label">
                              <div class="section-label-text">
                                <i class="fas fa-circle-exclamation" style="color:#f87171;"></i>
                                Documentos Vencidos
                              </div>
                              <span class="section-count count-red">${vencidos.size()} registros</span>
                            </div>
                            <div class="dark-table-wrap">
                              <table>
                                <thead>
                                  <tr>
                                    <th>Ciudadano</th>
                                    <th>Cédula</th>
                                    <th>Tipo Doc.</th>
                                    <th>N° Serie</th>
                                    <th>Vencimiento</th>
                                    <th>Días</th>
                                    <th>Estado</th>
                                  </tr>
                                </thead>
                                <tbody>
                                  <c:forEach var="d" items="${vencidos}">
                                    <tr>
                                      <td class="td-name">${d.ciudadanoNombre}</td>
                                      <td class="td-doc">${d.ciudadanoDocumento}</td>
                                      <td class="td-tipo">${d.tipoDocumento}</td>
                                      <td class="td-serie">${d.numeroSerie}</td>
                                      <td class="td-fecha-red">${d.fechaVencimiento}</td>
                                      <td>
                                        <span class="days-pill days-vencido">
                                          <i class="fas fa-clock"></i> ${d.diasRestantes} días
                                        </span>
                                      </td>
                                      <td><span class="estado-pill e-vencido">Vencido</span></td>
                                    </tr>
                                  </c:forEach>
                                </tbody>
                              </table>
                            </div>
                          </c:if>

                          <%-- ═══ TABLA PRÓXIMOS ═══ --%>
                            <c:if test="${not empty proximos}">
                              <div class="section-label">
                                <div class="section-label-text">
                                  <i class="fas fa-hourglass-start" style="color:#fbbf24;"></i>
                                  Próximos a Vencer — 30 días
                                </div>
                                <span class="section-count count-amber">${proximos.size()} registros</span>
                              </div>
                              <div class="dark-table-wrap">
                                <table>
                                  <thead>
                                    <tr>
                                      <th>Ciudadano</th>
                                      <th>Cédula</th>
                                      <th>Tipo Doc.</th>
                                      <th>N° Serie</th>
                                      <th>Vencimiento</th>
                                      <th>Días restantes</th>
                                      <th>Estado</th>
                                    </tr>
                                  </thead>
                                  <tbody>
                                    <c:forEach var="d" items="${proximos}">
                                      <tr>
                                        <td class="td-name">${d.ciudadanoNombre}</td>
                                        <td class="td-doc">${d.ciudadanoDocumento}</td>
                                        <td class="td-tipo">${d.tipoDocumento}</td>
                                        <td class="td-serie">${d.numeroSerie}</td>
                                        <td class="td-fecha-warn">${d.fechaVencimiento}</td>
                                        <td>
                                          <span class="days-pill ${d.diasRestantes <= 7 ? 'days-urgente' : 'days-ok'}">
                                            <i class="fas fa-calendar-day"></i> ${d.diasRestantes} días
                                          </span>
                                        </td>
                                        <td>
                                          <span class="estado-pill ${d.diasRestantes <= 7 ? 'e-proximo' : 'e-vigente'}">
                                            ${d.diasRestantes <= 7 ? 'Próximo' : 'Vigente' } </span>
                                        </td>
                                      </tr>
                                    </c:forEach>
                                  </tbody>
                                </table>
                              </div>
                            </c:if>

                            <%-- Empty state --%>
                              <c:if test="${empty vencidos and empty proximos}">
                                <div class="empty-dark">
                                  <i class="fas fa-circle-check" style="color:#34d399;opacity:1;font-size:56px;"></i>
                                  <h5>¡Todo en orden!</h5>
                                  <p>No hay documentos vencidos ni próximos a vencer en los próximos 30 días.</p>
                                </div>
                              </c:if>

                </div><%-- /dash-content --%>
          </div><%-- /main --%>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
              const vencidosCount = ${ vencidos  != null ? vencidos.size() : 0};
              const proximosCount = ${ proximos  != null ? proximos.size() : 0};
              const totalAlertas = vencidosCount + proximosCount;

              /* ── Progress bars animadas ── */
              window.addEventListener('DOMContentLoaded', () => {
                if (totalAlertas > 0) {
                  setTimeout(() => {
                    document.getElementById('barVencidos').style.width = Math.round(vencidosCount * 100 / totalAlertas) + '%';
                    document.getElementById('barProximos').style.width = Math.round(proximosCount * 100 / totalAlertas) + '%';
                  }, 300);
                }
              });

              /* ── Donut Chart ── */
              new Chart(document.getElementById('donutChart'), {
                type: 'doughnut',
                data: {
                  labels: ['Vencidos', 'Por vencer'],
                  datasets: [{
                    data: [vencidosCount, proximosCount],
                    backgroundColor: ['#f87171', '#fbbf24'],
                    borderWidth: 0,
                    hoverOffset: 8
                  }]
                },
                options: {
                  responsive: true,
                  maintainAspectRatio: false,
                  cutout: '72%',
                  plugins: {
                    legend: { display: false },
                    tooltip: {
                      backgroundColor: '#e8f0fc',
                      titleColor: '#2979e8',
                      bodyColor: '#fff',
                      padding: 10,
                      cornerRadius: 8,
                      borderColor: 'rgba(79,156,232,.35)',
                      borderWidth: 1
                    }
                  }
                }
              });

              /* ── Line Chart tendencia ── */
              new Chart(document.getElementById('tendenciaChart'), {
                type: 'line',
                data: {
                  labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
                  datasets: [
                    {
                      label: 'Documentos Vencidos',
                      data: [2, 3, 1, 4, 2, 5, 3, 2, 4, 1, 3, vencidosCount],
                      borderColor: '#f87171',
                      backgroundColor: 'rgba(248,113,113,0.08)',
                      fill: true,
                      tension: 0.45,
                      pointRadius: 4,
                      pointHoverRadius: 6,
                      pointBackgroundColor: '#f87171',
                      pointBorderColor: '#e8f0fc',
                      pointBorderWidth: 2,
                      borderWidth: 2
                    },
                    {
                      label: 'Por Vencer',
                      data: [1, 2, 3, 2, 4, 3, 5, 4, 6, 3, 4, proximosCount],
                      borderColor: '#fbbf24',
                      backgroundColor: 'rgba(251,191,36,0.06)',
                      fill: true,
                      tension: 0.45,
                      pointRadius: 4,
                      pointHoverRadius: 6,
                      pointBackgroundColor: '#fbbf24',
                      pointBorderColor: '#e8f0fc',
                      pointBorderWidth: 2,
                      borderDash: [5, 3],
                      borderWidth: 2
                    }
                  ]
                },
                options: {
                  responsive: true,
                  maintainAspectRatio: false,
                  plugins: {
                    legend: { display: false },
                    tooltip: {
                      backgroundColor: '#e8f0fc',
                      titleColor: '#2979e8',
                      bodyColor: '#fff',
                      padding: 10,
                      cornerRadius: 8,
                      borderColor: 'rgba(79,156,232,.35)',
                      borderWidth: 1,
                      mode: 'index',
                      intersect: false
                    }
                  },
                  scales: {
                    x: {
                      grid: { color: 'rgba(79,156,232,0.1)', drawBorder: false },
                      ticks: { color: '#5a80a8', font: { size: 11 } },
                      border: { display: false }
                    },
                    y: {
                      beginAtZero: true,
                      grid: { color: 'rgba(79,156,232,0.1)', drawBorder: false },
                      ticks: { color: '#5a80a8', font: { size: 11 }, stepSize: 1 },
                      border: { display: false }
                    }
                  },
                  interaction: { mode: 'index', intersect: false }
                }
              });
            </script>
      </body>

      </html>
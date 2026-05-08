<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<fmt:setLocale value="${not empty sessionScope.lang ? sessionScope.lang : 'es'}"/>
<fmt:setBundle basename="messages"/>
<!DOCTYPE html>
<html lang="${not empty sessionScope.lang ? sessionScope.lang : 'es'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${msg["dashboard.title"]} — SaludBoyacá</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

  <style>
    /* ── Variables (paleta verde SaludBoyacá) ── */
    :root {
      --g:        #4d7a68;
      --g-dark:   #3a5e50;
      --g-light:  #6a9e8a;
      --g-pale:   #e8f2ee;
      --g-bg:     #f0f7f4;
      --text:     #1a2e26;
      --text-mid: #4a6258;
      --text-lt:  #7a9a8e;
      --border:   #dce9e4;
      --white:    #ffffff;
      --shadow:   0 2px 12px rgba(74,120,100,.10);
      --radius:   14px;
      --radius-sm:10px;
    }
    *, *::before, *::after { box-sizing: border-box; }
    body {
      font-family: 'Plus Jakarta Sans','Segoe UI',sans-serif;
      background: var(--g-bg); color: var(--text); min-height: 100vh;
    }

    /* ── Grid 2 columnas ── */
    .dash-grid {
      display: grid;
      grid-template-columns: 1fr 290px;
      gap: 1.1rem;
      padding: 0;
      align-items: start;
    }
    @media (max-width:992px){ .dash-grid { grid-template-columns:1fr; } }

    /* ── Card base ── */
    .db-card {
      background: var(--white);
      border-radius: var(--radius);
      border: 1px solid var(--border);
      box-shadow: var(--shadow);
      overflow: hidden;
    }
    .section-hdr {
      display: flex; align-items: center; justify-content: space-between;
      padding: .85rem 1.2rem .65rem;
      border-bottom: 1px solid var(--border);
    }
    .section-hdr h6 { font-size:.92rem; font-weight:800; color:var(--text); margin:0; }
    .pill-tag {
      display:flex; align-items:center; gap:.35rem;
      font-size:.74rem; font-weight:600; color:var(--text-mid);
      background:var(--g-pale); border-radius:6px;
      padding:.25rem .7rem; border:1px solid var(--border);
      text-decoration:none;
    }
    .pill-tag:hover { color:var(--g); }

    /* ── Banner bienvenida ── */
    .banner {
      background: linear-gradient(135deg, #e8f2ee 0%, #d4ece2 100%);
      border-radius: var(--radius);
      border: 1px solid #c2ddd4;
      padding: 1.2rem 1.5rem;
      display: flex; align-items: center; justify-content: space-between; gap: 1rem;
      margin-bottom: 1.1rem;
    }
    .banner h5 { font-size:1.08rem; font-weight:800; color:var(--g-dark); margin:0 0 .25rem; }
    .banner p  { font-size:.8rem; color:var(--text-mid); margin:0 0 .7rem; }
    .banner-btn {
      display:inline-block; background:var(--g); color:#fff;
      font-size:.8rem; font-weight:700; padding:.42rem 1rem;
      border-radius:8px; text-decoration:none; transition:background .2s;
    }
    .banner-btn:hover { background:var(--g-dark); color:#fff; }
    .banner-icon {
      width:68px; height:68px; border-radius:12px; flex-shrink:0;
      background:rgba(255,255,255,.55); border:2px solid rgba(255,255,255,.8);
      display:flex; align-items:center; justify-content:center;
      font-size:2.1rem; color:var(--g);
    }

    /* ── Mini stat cards ── */
    .mini-stats { display:grid; grid-template-columns:repeat(auto-fit,minmax(120px,1fr)); gap:.85rem; margin-bottom:1.1rem; }
    .msc {
      background:var(--white); border-radius:var(--radius-sm);
      border:1px solid var(--border); padding:.85rem 1rem;
      display:flex; align-items:center; gap:.7rem; box-shadow:var(--shadow);
    }
    .msc-icon {
      width:38px; height:38px; border-radius:9px;
      display:flex; align-items:center; justify-content:center;
      font-size:.95rem; flex-shrink:0;
    }
    .msc-num { font-size:1.55rem; font-weight:800; line-height:1; color:var(--text); }
    .msc-lbl { font-size:.67rem; color:var(--text-lt); font-weight:600; text-transform:uppercase; letter-spacing:.05em; }

    /* ── Chart ── */
    .chart-wrap { padding:.7rem 1.2rem 1rem; }
    .cs-side { display:flex; flex-direction:column; gap:.5rem; }
    .cs-item {
      display:flex; align-items:center; gap:.55rem;
      background:var(--g-pale); border-radius:8px; padding:.5rem .7rem;
    }
    .cs-ico {
      width:30px; height:30px; border-radius:7px;
      background:var(--white); display:flex; align-items:center;
      justify-content:center; color:var(--g); font-size:.8rem; flex-shrink:0;
    }
    .cs-n  { font-size:1.2rem; font-weight:800; line-height:1; color:var(--text); }
    .cs-l  { font-size:.65rem; color:var(--text-lt); font-weight:600; }

    /* ── Tabla citas ── */
    .pr-tbl { width:100%; border-collapse:collapse; }
    .pr-tbl th {
      font-size:.68rem; font-weight:700; color:var(--text-mid);
      text-transform:uppercase; letter-spacing:.05em;
      padding:.6rem 1rem; background:var(--g-pale);
      border-bottom:1px solid var(--border); white-space:nowrap;
    }
    .pr-tbl td {
      padding:.65rem 1rem; font-size:.82rem; color:var(--text);
      border-bottom:1px solid #f0f7f4; vertical-align:middle;
    }
    .pr-tbl tr:last-child td { border-bottom:none; }
    .pr-tbl tbody tr:hover td { background:var(--g-pale); }

    .av-pill {
      width:28px; height:28px; border-radius:50%;
      background:var(--g-pale); color:var(--g-dark);
      font-size:.67rem; font-weight:800;
      display:inline-flex; align-items:center; justify-content:center; flex-shrink:0;
    }
    .badge-estado { font-size:.69rem; padding:.22em .6em; border-radius:20px; font-weight:700; }
    .estado-COMPLETADA,.estado-ATENDIDA { background:#e8f2ee; color:#2d7a4a; }
    .estado-CONFIRMADA                  { background:#e0f5eb; color:#1a6640; }
    .estado-PENDIENTE                   { background:#fff8e1; color:#9a7200; }
    .estado-CANCELADA                   { background:#fef0f0; color:#9a2020; }
    .estado-PROGRAMADA                  { background:#eef8f0; color:#2d7a4a; }

    /* ── Right panel ── */
    .right-panel { display:flex; flex-direction:column; gap:1rem; }

    /* Doc card */
    .doc-card { text-align:center; padding:1.2rem 1rem 1rem; }
    .doc-avatar {
      width:70px; height:70px; border-radius:12px;
      background:var(--g-pale); color:var(--g); font-size:2rem;
      display:flex; align-items:center; justify-content:center; margin:0 auto;
    }
    .doc-name { font-size:.92rem; font-weight:800; color:var(--text); margin:.45rem 0 .1rem; }
    .doc-role { font-size:.73rem; color:var(--text-lt); }
    .doc-stats { display:grid; grid-template-columns:1fr 1fr; border-top:1px solid var(--border); margin-top:.85rem; }
    .doc-stat { padding:.65rem .5rem; text-align:center; }
    .doc-stat:first-child { border-right:1px solid var(--border); }
    .doc-stat-n { font-size:1.25rem; font-weight:800; color:var(--text); }
    .doc-stat-l { font-size:.62rem; color:var(--text-lt); text-transform:uppercase; letter-spacing:.05em; font-weight:700; }

    /* Calendario */
    .cal-body { padding:.85rem 1rem .95rem; }
    .cal-hdr { display:flex; align-items:center; justify-content:space-between; margin-bottom:.7rem; }
    .cal-title { font-size:.88rem; font-weight:800; color:var(--text); }
    .cal-nav {
      background:none; border:1px solid var(--border); border-radius:6px;
      width:24px; height:24px; cursor:pointer; color:var(--text-mid);
      display:flex; align-items:center; justify-content:center; font-size:.7rem; transition:background .15s;
    }
    .cal-nav:hover { background:var(--g-pale); }
    .cal-grid { display:grid; grid-template-columns:repeat(7,1fr); gap:1px; text-align:center; }
    .cal-dn { font-size:.6rem; font-weight:700; color:var(--text-lt); padding:.22rem 0; }
    .cal-d  { font-size:.73rem; padding:.28rem .1rem; border-radius:5px; color:var(--text-mid); }
    .cal-d.other { color:#ccc; }
    .cal-d.today {
      background:var(--g); color:#fff; font-weight:800; border-radius:50%;
      width:24px; height:24px; display:flex; align-items:center; justify-content:center; margin:auto;
    }

    /* Bottom donut */
    .bstats-body { padding:.95rem 1.1rem; }
    .bstats-row { display:flex; justify-content:space-between; margin-bottom:.55rem; }
    .bstat-dot { width:7px; height:7px; border-radius:50%; display:inline-block; margin-right:.3rem; }
    .bstat-lbl { font-size:.7rem; color:var(--text-lt); font-weight:600; }
    .bstat-n   { font-size:1.1rem; font-weight:800; color:var(--text); }
    .donut-wrap { display:flex; align-items:center; justify-content:center; padding:.5rem 0 .65rem; position:relative; }
    .donut-lbl  { position:absolute; text-align:center; font-size:1.2rem; font-weight:800; color:var(--text); line-height:1; }
    .donut-sub  { font-size:.62rem; color:var(--text-lt); font-weight:600; }

    /* Acciones rápidas mini */
    .quick-link {
      display:flex; align-items:center; gap:.7rem; text-decoration:none;
      background:var(--g-pale); border-radius:9px; padding:.6rem .85rem;
      color:var(--g-dark); font-size:.82rem; font-weight:600; transition:background .15s;
    }
    .quick-link:hover { background:#d4ece2; color:var(--g-dark); }

    /* ── Toast notifications ── */
    .toast-container-custom {
      position:fixed; top:70px; right:20px; z-index:9999;
      display:flex; flex-direction:column; gap:8px; max-width:320px;
    }
    .sb-toast {
      background:#fff; border-radius:12px; border-left:4px solid var(--g);
      box-shadow:0 8px 24px rgba(0,0,0,.12); padding:.7rem .95rem;
      display:flex; align-items:flex-start; gap:.55rem;
      animation: toastIn .3s ease;
    }
    .sb-toast.toast-error   { border-color:#e74c3c; }
    .sb-toast.toast-warning { border-color:#f39c12; }
    .sb-toast.toast-info    { border-color:#3498db; }
    .sb-toast-icon { font-size:1rem; color:var(--g); flex-shrink:0; margin-top:.05rem; }
    .sb-toast.toast-error   .sb-toast-icon { color:#e74c3c; }
    .sb-toast.toast-warning .sb-toast-icon { color:#f39c12; }
    .sb-toast.toast-info    .sb-toast-icon { color:#3498db; }
    .sb-toast-text { font-size:.8rem; color:var(--text); font-weight:500; flex:1; }
    .sb-toast-close { background:none; border:none; color:var(--text-lt); cursor:pointer; font-size:.9rem; padding:0; }
    @keyframes toastIn { from{opacity:0;transform:translateX(30px)} to{opacity:1;transform:none} }
  </style>
</head>
<body>

<%@ include file="/views/templates/header.jsp" %>
<c:set var="activePage" value="dashboard" scope="request"/>
<%@ include file="/views/templates/sidebar.jsp" %>

<div class="sb-main">

  <%-- Calcular contadores antes de renderizar --%>
  <c:set var="programadasCount" value="0"/>
  <c:set var="confirmadasCount" value="0"/>
  <c:set var="canceladasCount"  value="0"/>
  <c:forEach var="c" items="${citasHoy}">
    <c:if test="${c.estado == 'PROGRAMADA'}"> <c:set var="programadasCount" value="${programadasCount + 1}"/></c:if>
    <c:if test="${c.estado == 'CONFIRMADA'}"> <c:set var="confirmadasCount" value="${confirmadasCount + 1}"/></c:if>
    <c:if test="${c.estado == 'CANCELADA'}">  <c:set var="canceladasCount"  value="${canceladasCount  + 1}"/></c:if>
  </c:forEach>
  <c:set var="totalHoy" value="${empty citasHoy ? 0 : citasHoy.size()}"/>

  <div class="dash-grid">

    <%-- ══ COLUMNA IZQUIERDA ══ --%>
    <div>

      <%-- Banner --%>
      <div class="banner">
        <div>
          <h5><fmt:message key="dashboard.welcome"/></h5>
          <p><fmt:message key="dashboard.subtitle"/></p>
          <a href="${pageContext.request.contextPath}/citas" class="banner-btn"><fmt:message key="dashboard.learn.more"/></a>
        </div>
        <div class="banner-icon"><i class="fas fa-laptop-medical"></i></div>
      </div>

      <%-- Mini stat cards por rol --%>
      <c:choose>
        <c:when test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}">
          <div class="mini-stats">
            <div class="msc">
              <div class="msc-icon" style="background:#e8f2ee;color:var(--g-light);"><i class="fas fa-users"></i></div>
              <div><div class="msc-num">${totalPacientes != null ? totalPacientes : 0}</div><div class="msc-lbl"><fmt:message key="stat.patients"/></div></div>
            </div>
            <div class="msc">
              <div class="msc-icon" style="background:#e0f5eb;color:#1a6640;"><i class="fas fa-calendar-day"></i></div>
              <div><div class="msc-num">${totalHoy}</div><div class="msc-lbl"><fmt:message key="stat.appointments.today"/></div></div>
            </div>
            <div class="msc">
              <div class="msc-icon" style="background:#fff8e1;color:#9a7200;"><i class="fas fa-hourglass-half"></i></div>
              <div><div class="msc-num">${citasPendientes != null ? citasPendientes : programadasCount}</div><div class="msc-lbl"><fmt:message key="stat.scheduled"/></div></div>
            </div>
          </div>
        </c:when>
        <c:when test="${sessionScope.usuarioRol == 'MEDICO'}">
          <div class="mini-stats">
            <div class="msc">
              <div class="msc-icon" style="background:#e8f2ee;color:var(--g-light);"><i class="fas fa-calendar-day"></i></div>
              <div><div class="msc-num">${totalHoy}</div><div class="msc-lbl"><fmt:message key="stat.appointments.today"/></div></div>
            </div>
            <div class="msc">
              <div class="msc-icon" style="background:#e0f5eb;color:#1a6640;"><i class="fas fa-check-circle"></i></div>
              <div><div class="msc-num">${confirmadasCount}</div><div class="msc-lbl"><fmt:message key="stat.confirmed"/></div></div>
            </div>
            <div class="msc">
              <div class="msc-icon" style="background:#fff8e1;color:#9a7200;"><i class="fas fa-hourglass-half"></i></div>
              <div><div class="msc-num">${programadasCount}</div><div class="msc-lbl"><fmt:message key="stat.scheduled"/></div></div>
            </div>
            <div class="msc">
              <div class="msc-icon" style="background:#fef0f0;color:#9a2020;"><i class="fas fa-times-circle"></i></div>
              <div><div class="msc-num">${canceladasCount}</div><div class="msc-lbl"><fmt:message key="stat.cancelled"/></div></div>
            </div>
          </div>
        </c:when>
        <c:when test="${sessionScope.usuarioRol == 'ENFERMERO'}">
          <div class="mini-stats">
            <div class="msc">
              <div class="msc-icon" style="background:#f3eefa;color:#6c3483;"><i class="fas fa-calendar-day"></i></div>
              <div><div class="msc-num">${totalHoy}</div><div class="msc-lbl"><fmt:message key="stat.appointments.today"/></div></div>
            </div>
            <div class="msc">
              <div class="msc-icon" style="background:#e0f5eb;color:#1a6640;"><i class="fas fa-check-circle"></i></div>
              <div><div class="msc-num">${confirmadasCount}</div><div class="msc-lbl"><fmt:message key="stat.confirmed"/></div></div>
            </div>
            <div class="msc">
              <div class="msc-icon" style="background:#fff8e1;color:#9a7200;"><i class="fas fa-hourglass-half"></i></div>
              <div><div class="msc-num">${programadasCount}</div><div class="msc-lbl"><fmt:message key="stat.scheduled"/></div></div>
            </div>
          </div>
        </c:when>
      </c:choose>

      <%-- Gráfico actividad de citas --%>
      <div class="db-card mb-3">
        <div class="section-hdr">
          <h6><i class="fas fa-chart-line me-2" style="color:var(--g);"></i><fmt:message key="dashboard.activity"/></h6>
          <div class="pill-tag"><i class="fas fa-calendar-alt"></i><span id="mesLabel">Cargando...</span></div>
        </div>
        <div class="chart-wrap">
          <div class="d-flex gap-3 align-items-start">
            <div style="flex:1; min-height:155px;">
              <canvas id="actividadChart" height="145"></canvas>
            </div>
            <div class="cs-side">
              <div class="cs-item">
                <div class="cs-ico"><i class="fas fa-user-plus"></i></div>
                <div><div class="cs-n">${totalHoy}</div><div class="cs-l"><fmt:message key="stat.new"/></div></div>
              </div>
              <div class="cs-item">
                <div class="cs-ico"><i class="fas fa-bell"></i></div>
                <div><div class="cs-n">${programadasCount}</div><div class="cs-l"><fmt:message key="stat.scheduled"/></div></div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <%-- Tabla citas del día --%>
      <div class="db-card">
        <div class="section-hdr">
          <h6>
            <c:choose>
              <c:when test="${sessionScope.usuarioRol == 'MEDICO'}"><i class="fas fa-calendar-check me-2" style="color:var(--g);"></i><fmt:message key="dashboard.my.appointments"/></c:when>
              <c:otherwise><i class="fas fa-users me-2" style="color:var(--g);"></i><fmt:message key="dashboard.recent.patients"/></c:otherwise>
            </c:choose>
          </h6>
          <a href="${pageContext.request.contextPath}/citas" class="pill-tag"><fmt:message key="dashboard.view.all"/> <i class="fas fa-arrow-right ms-1"></i></a>
        </div>

        <c:choose>
          <c:when test="${empty citasHoy}">
            <div style="text-align:center;padding:2.5rem;color:#aaa;">
              <i class="fas fa-calendar-times" style="font-size:2.2rem;opacity:.3;display:block;margin-bottom:.75rem;"></i>
              <p style="margin:0;font-size:.84rem;"><fmt:message key="dashboard.no.appointments"/></p>
              <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}">
                <a href="${pageContext.request.contextPath}/citas?accion=nuevo" class="banner-btn mt-3" style="display:inline-block;">
                  <i class="fas fa-plus me-1"></i> <fmt:message key="dashboard.schedule.appointment"/>
                </a>
              </c:if>
            </div>
          </c:when>
          <c:otherwise>
            <div style="overflow-x:auto;">
              <table class="pr-tbl">
                <thead>
                  <tr>
                    <th><fmt:message key="paciente.nombre"/></th>
                    <c:if test="${sessionScope.usuarioRol != 'MEDICO'}"><th><fmt:message key="cita.medico"/></th></c:if>
                    <th><fmt:message key="cita.hora"/></th>
                    <th><fmt:message key="cita.specialty"/></th>
                    <th><fmt:message key="cita.estado"/></th>
                    <c:if test="${sessionScope.usuarioRol != 'ENFERMERO'}"><th></th></c:if>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="cita" items="${citasHoy}">
                    <tr>
                      <td>
                        <div class="d-flex align-items-center gap-2">
                          <div class="av-pill">
                            <c:choose>
                              <c:when test="${not empty cita.pacienteNombre}">${fn:substring(cita.pacienteNombre,0,1)}${fn:substring(cita.pacienteApellido,0,1)}</c:when>
                              <c:otherwise><i class="fas fa-user" style="font-size:.6rem;"></i></c:otherwise>
                            </c:choose>
                          </div>
                          <span>${cita.pacienteNombre} ${cita.pacienteApellido}</span>
                        </div>
                      </td>
                      <c:if test="${sessionScope.usuarioRol != 'MEDICO'}">
                        <td style="color:var(--text-mid);">${cita.medicoNombre} ${cita.medicoApellido}</td>
                      </c:if>
                      <td style="font-weight:700;color:var(--g-dark);">${cita.horaCita}</td>
                      <td style="color:var(--text-mid);max-width:130px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                        ${not empty cita.especialidad ? cita.especialidad : cita.motivo}
                      </td>
                      <td><span class="badge-estado estado-${cita.estado}">${cita.estado}</span></td>
                      <c:if test="${sessionScope.usuarioRol != 'ENFERMERO'}">
                        <td>
                          <c:choose>
                            <c:when test="${sessionScope.usuarioRol == 'MEDICO'}">
                              <a href="${pageContext.request.contextPath}/citas?accion=detalle&id=${cita.idCita}"
                                 style="background:var(--g-pale);color:var(--g-dark);font-size:.7rem;padding:.22rem .6rem;border-radius:20px;text-decoration:none;font-weight:600;">
                                <i class="fas fa-eye"></i>
                              </a>
                            </c:when>
                            <c:otherwise>
                              <a href="${pageContext.request.contextPath}/citas?accion=editar&id=${cita.idCita}"
                                 style="background:var(--g-pale);color:var(--g-dark);font-size:.7rem;padding:.22rem .6rem;border-radius:20px;text-decoration:none;font-weight:600;">
                                <i class="fas fa-edit"></i>
                              </a>
                            </c:otherwise>
                          </c:choose>
                        </td>
                      </c:if>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <c:if test="${sessionScope.usuarioRol == 'ENFERMERO'}">
        <div style="margin-top:.9rem;background:#f3eefa;border-left:4px solid #9b72c8;border-radius:10px;padding:.8rem 1rem;font-size:.82rem;color:#6C3483;">
          <i class="fas fa-lock me-2"></i><fmt:message key="dashboard.readonly.notice"/>
        </div>
      </c:if>

    </div><%-- /col izquierda --%>

    <%-- ══ COLUMNA DERECHA ══ --%>
    <div class="right-panel">

      <%-- Tarjeta usuario --%>
      <div class="db-card doc-card">
        <div class="doc-avatar">
          <c:choose>
            <c:when test="${sessionScope.usuarioRol == 'MEDICO'}"><i class="fas fa-user-md"></i></c:when>
            <c:when test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}"><i class="fas fa-concierge-bell"></i></c:when>
            <c:otherwise><i class="fas fa-user-nurse"></i></c:otherwise>
          </c:choose>
        </div>
        <div class="doc-name">${sessionScope.usuarioNombre}</div>
        <div class="doc-role">
          <c:choose>
            <c:when test="${sessionScope.usuarioRol == 'MEDICO'}"><fmt:message key="role.medico"/></c:when>
            <c:when test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}"><fmt:message key="role.recepcionista"/></c:when>
            <c:otherwise><fmt:message key="role.enfermero"/></c:otherwise>
          </c:choose>
        </div>
        <div class="doc-stats">
          <div class="doc-stat">
            <div class="doc-stat-n">${totalHoy}</div>
            <div class="doc-stat-l"><fmt:message key="stat.appointments"/></div>
          </div>
          <div class="doc-stat">
            <div class="doc-stat-n">${totalPacientes != null ? totalPacientes : (confirmadasCount + programadasCount)}</div>
            <div class="doc-stat-l"><fmt:message key="stat.patients"/></div>
          </div>
        </div>
      </div>

      <%-- Calendario --%>
      <div class="db-card">
        <div class="cal-body">
          <div class="cal-hdr">
            <div class="cal-title" id="calTitle"></div>
            <div class="d-flex gap-1">
              <button class="cal-nav" id="calPrev"><i class="fas fa-chevron-left"></i></button>
              <button class="cal-nav" id="calNext"><i class="fas fa-chevron-right"></i></button>
            </div>
          </div>
          <div class="cal-grid" id="calGrid"></div>
        </div>
      </div>

      <%-- Estadísticas donut --%>
      <div class="db-card">
        <div class="bstats-body">
          <div class="bstats-row">
            <div>
              <div class="bstat-lbl"><span class="bstat-dot" style="background:var(--g);"></span><fmt:message key="stat.consultations"/></div>
              <div class="bstat-n">${totalHoy}</div>
            </div>
            <div style="text-align:right;">
              <div class="bstat-lbl"><span class="bstat-dot" style="background:#a8d5be;"></span><fmt:message key="stat.returns"/></div>
              <div class="bstat-n">${confirmadasCount}</div>
            </div>
          </div>
          <div class="donut-wrap">
            <canvas id="donutChart" width="120" height="120"></canvas>
            <div class="donut-lbl">${totalPacientes != null ? totalPacientes : (totalHoy + confirmadasCount)}<br><span class="donut-sub"><fmt:message key="stat.patients"/></span></div>
          </div>
        </div>
      </div>

      <%-- Acciones rápidas --%>
      <div class="db-card">
        <div class="section-hdr"><h6><i class="fas fa-bolt me-2" style="color:var(--g);"></i><fmt:message key="dashboard.quick.actions"/></h6></div>
        <div style="padding:.7rem; display:flex; flex-direction:column; gap:.5rem;">
          <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}">
            <a href="${pageContext.request.contextPath}/citas?accion=nuevo" class="quick-link"><i class="fas fa-calendar-plus"></i> <fmt:message key="cita.new"/></a>
            <a href="${pageContext.request.contextPath}/pacientes?accion=nuevo" class="quick-link"><i class="fas fa-user-plus"></i> <fmt:message key="paciente.new"/></a>
          </c:if>
          <a href="${pageContext.request.contextPath}/citas" class="quick-link"><i class="fas fa-list-alt"></i> <fmt:message key="nav.view.appointments"/></a>
          <c:if test="${sessionScope.usuarioRol != 'ENFERMERO'}">
            <a href="${pageContext.request.contextPath}/horarios" class="quick-link"><i class="fas fa-clock"></i> <fmt:message key="nav.schedules"/></a>
          </c:if>
          <c:if test="${sessionScope.usuarioRol == 'MEDICO' || sessionScope.usuarioRol == 'RECEPCIONISTA'}">
            <a href="${pageContext.request.contextPath}/citas?accion=exportarPDF" target="_blank" class="quick-link"><i class="fas fa-file-pdf"></i> <fmt:message key="nav.export.pdf"/></a>
          </c:if>
        </div>
      </div>

    </div><%-- /right panel --%>

  </div><%-- /dash-grid --%>
</div><%-- /sb-main --%>
</div><%-- /sb-layout --%>

<%-- Toast container --%>
<div class="toast-container-custom" id="toastContainer"></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
/* ══ TOAST ══ */
function showToast(msg, type) {
  type = type || 'success';
  var icons = {success:'fa-check-circle', error:'fa-times-circle', warning:'fa-exclamation-triangle', info:'fa-info-circle'};
  var box = document.getElementById('toastContainer');
  var t = document.createElement('div');
  t.className = 'sb-toast' + (type !== 'success' ? ' toast-' + type : '');
  t.innerHTML = '<i class="fas '+icons[type]+' sb-toast-icon"></i><span class="sb-toast-text">'+msg+'</span><button class="sb-toast-close" onclick="this.parentElement.remove()">&#xd7;</button>';
  box.appendChild(t);
  setTimeout(function(){if(t.parentElement){t.style.cssText+='opacity:0;transform:translateX(30px);transition:.3s;';setTimeout(function(){t.remove();},300);}},4500);
}

/* Flash message server-side */
<c:if test="${not empty sessionScope.flashMessage}">
  showToast('${sessionScope.flashMessage}', '${not empty sessionScope.flashType ? sessionScope.flashType : "success"}');
</c:if>

/* Dashboard loaded notification */
document.addEventListener('DOMContentLoaded', function() {
  var hora = new Date().toLocaleTimeString('es-CO',{hour:'2-digit',minute:'2-digit'});
  showToast('<fmt:message key="dashboard.loaded"/> — ' + hora, 'info');
});

/* ══ CALENDAR ══ */
(function(){
  var meses = ['<fmt:message key="cal.jan"/>','<fmt:message key="cal.feb"/>','<fmt:message key="cal.mar"/>','<fmt:message key="cal.apr"/>','<fmt:message key="cal.may"/>','<fmt:message key="cal.jun"/>','<fmt:message key="cal.jul"/>','<fmt:message key="cal.aug"/>','<fmt:message key="cal.sep"/>','<fmt:message key="cal.oct"/>','<fmt:message key="cal.nov"/>','<fmt:message key="cal.dec"/>'];
  var dias  = ['<fmt:message key="cal.sun"/>','<fmt:message key="cal.mon"/>','<fmt:message key="cal.tue"/>','<fmt:message key="cal.wed"/>','<fmt:message key="cal.thu"/>','<fmt:message key="cal.fri"/>','<fmt:message key="cal.sat"/>'];
  var hoy   = new Date();
  var cur   = new Date(hoy.getFullYear(), hoy.getMonth(), 1);
  document.getElementById('mesLabel').textContent = meses[hoy.getMonth()];

  function render(){
    var y=cur.getFullYear(), m=cur.getMonth();
    document.getElementById('calTitle').textContent = meses[m]+' '+y;
    var g = document.getElementById('calGrid'); g.innerHTML='';
    dias.forEach(function(d){var el=document.createElement('div');el.className='cal-dn';el.textContent=d;g.appendChild(el);});
    var first=new Date(y,m,1).getDay(), last=new Date(y,m+1,0).getDate(), prevLast=new Date(y,m,0).getDate();
    for(var i=first-1;i>=0;i--){var el=document.createElement('div');el.className='cal-d other';el.textContent=prevLast-i;g.appendChild(el);}
    for(var d2=1;d2<=last;d2++){var el=document.createElement('div');var isT=(y===hoy.getFullYear()&&m===hoy.getMonth()&&d2===hoy.getDate());el.className='cal-d'+(isT?' today':'');el.textContent=d2;g.appendChild(el);}
    var total=first+last,rem=total%7===0?0:7-(total%7);
    for(var n=1;n<=rem;n++){var el=document.createElement('div');el.className='cal-d other';el.textContent=n;g.appendChild(el);}
  }
  render();
  document.getElementById('calPrev').addEventListener('click',function(){cur.setMonth(cur.getMonth()-1);render();});
  document.getElementById('calNext').addEventListener('click',function(){cur.setMonth(cur.getMonth()+1);render();});
})();

/* ══ CHART ACTIVIDAD ══ */
(function(){
  var actividadRaw = '${not empty actividadJson ? actividadJson : "{}"}';
  var dbData = {};
  try { dbData = JSON.parse(actividadRaw.replace(/&quot;/g,'"')); } catch(e) {}
  var labels=[], data=[], hoy2=new Date();
  for(var i=13;i>=0;i--){
    var d=new Date(hoy2); d.setDate(hoy2.getDate()-i);
    var iso=d.getFullYear()+'-'+String(d.getMonth()+1).padStart(2,'0')+'-'+String(d.getDate()).padStart(2,'0');
    labels.push(String(d.getDate()).padStart(2,'0'));
    data.push(dbData[iso] !== undefined ? dbData[iso] : 0);
  }
  var maxVal=Math.max.apply(null,data.concat([1]));
  new Chart(document.getElementById('actividadChart'),{
    type:'bar',
    data:{labels:labels,datasets:[{
      data:data,
      backgroundColor:function(context){
        var chart=context.chart,c=chart.ctx,a=chart.chartArea;
        if(!a) return 'rgba(77,122,104,.6)';
        var g=c.createLinearGradient(0,a.top,0,a.bottom);
        g.addColorStop(0,'rgba(45,90,71,.9)');g.addColorStop(1,'rgba(106,158,138,.3)');return g;
      },
      borderRadius:7, borderSkipped:false, hoverBackgroundColor:'#2d5a47'
    }]},
    options:{responsive:true,maintainAspectRatio:false,animation:{duration:800,easing:'easeOutQuart'},
      plugins:{legend:{display:false},tooltip:{backgroundColor:'#1a2e26',titleFont:{size:10},bodyFont:{size:12},
        callbacks:{label:function(ctx){return ' Citas: '+ctx.raw;}}}},
      scales:{x:{grid:{display:false},ticks:{font:{size:9},color:'#7a9a8e'}},
              y:{display:false,beginAtZero:true,suggestedMax:maxVal+1}}}
  });
})();

/* ══ DONUT CHART ══ */
(function(){
  var total=parseInt('${totalHoy}')||0;
  var pend=parseInt('${programadasCount}')||0;
  var rest=Math.max(total-pend,0);
  new Chart(document.getElementById('donutChart'),{
    type:'doughnut',
    data:{datasets:[{data:[rest>0?rest:1,pend>0?pend:(total===0?1:0)],backgroundColor:['#4d7a68','#a8d5be'],borderWidth:0,cutout:'72%'}]},
    options:{responsive:false,plugins:{legend:{display:false},tooltip:{enabled:total>0}}}
  });
})();
</script>
</body>
</html>

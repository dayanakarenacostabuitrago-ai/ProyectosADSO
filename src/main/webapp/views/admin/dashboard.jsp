<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="co.sena.cimm.adso.saludboyaca.dto.Usuario" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="${not empty sessionScope.lang ? sessionScope.lang : 'es'}"/>
<fmt:setBundle basename="messages"/>

<%
  Usuario usuarioSesion = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
  String nombreAdmin    = (usuarioSesion != null) ? usuarioSesion.getNombres()   : "Admin";
  String apellidoAdmin  = (usuarioSesion != null) ? usuarioSesion.getApellidos() : "";

  int totalUsuarios    = request.getAttribute("totalUsuarios")    != null ? (int) request.getAttribute("totalUsuarios")    : 0;
  int totalPacientes   = request.getAttribute("totalPacientes")   != null ? (int) request.getAttribute("totalPacientes")   : 0;
  int citasHoyCount    = request.getAttribute("citasHoyCount")    != null ? (int) request.getAttribute("citasHoyCount")    : 0;
  int totalCitas       = request.getAttribute("totalCitas")       != null ? (int) request.getAttribute("totalCitas")       : 0;
  int citasPendientes  = request.getAttribute("citasPendientes")  != null ? (int) request.getAttribute("citasPendientes")  : 0;
  int totalMedicos     = request.getAttribute("totalMedicos")     != null ? (int) request.getAttribute("totalMedicos")     : 0;

  String estadoCitasJson  = request.getAttribute("estadoCitasJson")  != null ? (String) request.getAttribute("estadoCitasJson")  : "{}";
  String citasPorEspJson  = request.getAttribute("citasPorEspJson")  != null ? (String) request.getAttribute("citasPorEspJson")  : "{}";
  String usuariosPorRolJson = request.getAttribute("usuariosPorRolJson") != null ? (String) request.getAttribute("usuariosPorRolJson") : "{}";
  String mesesJson        = request.getAttribute("mesesJson")        != null ? (String) request.getAttribute("mesesJson")        : "[]";
  String cantidadesJson   = request.getAttribute("cantidadesJson")   != null ? (String) request.getAttribute("cantidadesJson")   : "[]";
  String horariosJson     = request.getAttribute("horariosJson")     != null ? (String) request.getAttribute("horariosJson")     : "[]";
%>
<!DOCTYPE html>
<html lang="${not empty sessionScope.lang ? sessionScope.lang : 'es'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><fmt:message key="dashboard.title"/> — SaludBoyacá</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
  <style>
    /* ── Estilos exclusivos del dashboard admin (no sobreescriben header/sidebar) ── */
    .dashboard-content { padding: 0; }

    .kpi-group {
      display: flex; gap: 1rem; flex-wrap: wrap; margin-bottom: 1.5rem;
    }
    .kpi-card {
      background: #fff; border-radius: 14px; padding: 1.1rem 1.3rem;
      box-shadow: 0 1px 6px rgba(45,90,71,.08); border: 1px solid #dce9e4;
      flex: 1; min-width: 150px; display: flex; align-items: center; gap: .9rem;
      transition: box-shadow .2s, transform .2s;
    }
    .kpi-card:hover { box-shadow: 0 4px 16px rgba(45,90,71,.13); transform: translateY(-2px); }
    .kpi-icon {
      width: 48px; height: 48px; border-radius: 12px; background: #e8f2ee;
      display: flex; align-items: center; justify-content: center; flex-shrink: 0;
    }
    .kpi-icon i { font-size: 1.3rem; color: #2d5a47; }
    .kpi-num   { font-size: 26px; font-weight: 800; color: #1e293b; line-height: 1.2; }
    .kpi-label { font-size: 11px; color: #64748b; font-weight: 500; margin-top: 3px; }

    /* Dashboard cards */
    .db-card {
      background: #fff; border-radius: 14px; padding: 1.2rem;
      box-shadow: 0 1px 6px rgba(45,90,71,.08); border: 1px solid #dce9e4;
      height: 100%;
    }
    .db-card-title {
      font-size: .75rem; font-weight: 800; text-transform: uppercase;
      letter-spacing: .06em; color: #4a6258; margin-bottom: 1rem;
    }

    /* Grid helpers */
    .db-row       { display: flex; gap: 1rem; margin-bottom: 1rem; flex-wrap: wrap; }
    .db-col-half  { flex: 1; min-width: 260px; }
    .db-col-third { flex: 1; min-width: 200px; }
    .db-col-full  { flex: 0 0 100%; }

    /* Stat bars */
    .stat-row  { display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; }
    .stat-lbl  { font-size: 11px; color: #64748b; display: flex; align-items: center; gap: 5px; }
    .dot       { width: 8px; height: 8px; border-radius: 50%; display: inline-block; }
    .bar-wrap  { flex: 1; margin: 0 10px; height: 6px; background: #e2e8f0; border-radius: 10px; overflow: hidden; }
    .bar-fill  { height: 100%; border-radius: 10px; background: #2d5a47; }
    .bar-fill.alt { background: #6a9e8a; }
    .stat-val  { font-size: 11px; font-weight: 700; color: #1e293b; min-width: 28px; text-align: right; }

    .big-stat     { text-align: center; padding: 0 .8rem; }
    .big-stat .num { font-size: 36px; font-weight: 800; color: #2d5a47; line-height: 1; }
    .big-stat .sub { font-size: 10px; color: #64748b; margin-top: 4px; }

    /* Table */
    .dash-table          { width: 100%; border-collapse: collapse; font-size: 11px; }
    .dash-table th        { background: #f8fafc; color: #4a6258; font-weight: 700; padding: 8px 10px; text-align: left; font-size: 10px; letter-spacing: .04em; border-bottom: 1px solid #e2e8f0; }
    .dash-table td        { padding: 8px 10px; border-bottom: 1px solid #f1f5f9; color: #334155; }
    .dash-table tr:hover td { background: #f8fafc; }
    .badge-db  { display: inline-block; padding: 2px 8px; border-radius: 20px; font-size: 10px; font-weight: 600; }
    .badge-prog { background: #fef3c7; color: #92400e; }
    .badge-comp { background: #d1fae5; color: #065f46; }
    .badge-canc { background: #fee2e2; color: #991b1b; }

    /* H-bars */
    .hbar-item  { margin-bottom: 12px; }
    .hbar-hdr   { display: flex; justify-content: space-between; font-size: 11px; margin-bottom: 3px; }
    .hbar-lbl   { color: #64748b; }
    .hbar-pct   { color: #1e293b; font-weight: 700; }
    .hbar-track { height: 6px; background: #e2e8f0; border-radius: 10px; overflow: hidden; }
    .hbar-fill  { height: 100%; background: #2d5a47; border-radius: 10px; }

    /* Legend */
    .legend-list  { margin-top: 10px; }
    .legend-item  { display: flex; align-items: center; justify-content: space-between; font-size: 11px; color: #64748b; margin-bottom: 5px; }
    .legend-lbl   { display: flex; align-items: center; gap: 5px; }
    .legend-pct   { font-weight: 700; color: #1e293b; }

    /* Highlight */
    .highlight-pct { font-size: 44px; font-weight: 800; color: #2d5a47; line-height: 1; }
    .highlight-sub { font-size: 11px; color: #64748b; margin-top: 6px; max-width: 160px; }

    canvas { width: 100% !important; }
    .donut-wrap canvas { max-height: 160px; }
  </style>
</head>
<body>

<%-- ── Header global del sistema ── --%>
<c:set var="activePage" value="dashboard" scope="request"/>
<jsp:include page="/views/templates/header.jsp"/>

<%-- ── Sidebar + contenido ── --%>
<jsp:include page="/views/templates/sidebar.jsp"/>

  <main class="sb-main">
    <div class="dashboard-content">

      <%-- Breadcrumb --%>
      <div style="font-size:.72rem;color:#7a9a8e;margin-bottom:1rem;">
        <a href="${pageContext.request.contextPath}/dashboard" style="color:#4d7a68;font-weight:700;text-decoration:none;">
          <fmt:message key="nav.dashboard"/>
        </a>
        <span style="margin:0 .4rem;">›</span>
        <fmt:message key="dashboard.title"/>
      </div>

      <%-- FILA KPIs --%>
      <div class="kpi-group">
        <div class="kpi-card">
          <div class="kpi-icon"><i class="fas fa-users-cog"></i></div>
          <div><div class="kpi-num"><%= totalUsuarios %></div><div class="kpi-label">Total Usuarios</div></div>
        </div>
        <div class="kpi-card">
          <div class="kpi-icon"><i class="fas fa-user-injured"></i></div>
          <div><div class="kpi-num"><%= totalPacientes %></div><div class="kpi-label"><fmt:message key="stat.patients"/></div></div>
        </div>
        <div class="kpi-card">
          <div class="kpi-icon"><i class="fas fa-calendar-day"></i></div>
          <div><div class="kpi-num"><%= citasHoyCount %></div><div class="kpi-label"><fmt:message key="stat.appointments.today"/></div></div>
        </div>
        <div class="kpi-card">
          <div class="kpi-icon"><i class="fas fa-stethoscope"></i></div>
          <div><div class="kpi-num"><%= totalMedicos %></div><div class="kpi-label"><fmt:message key="role.medico"/>s activos</div></div>
        </div>
        <div class="kpi-card">
          <div class="kpi-icon"><i class="fas fa-calendar-check"></i></div>
          <div><div class="kpi-num"><%= totalCitas %></div><div class="kpi-label"><fmt:message key="stat.appointments"/> totales</div></div>
        </div>
      </div>

      <%-- FILA 2: Estado citas + Tendencia mensual --%>
      <div class="db-row">
        <div class="db-col-half">
          <div class="db-card">
            <div class="db-card-title">📊 <fmt:message key="stat.appointments"/> — estado</div>
            <div style="display:flex;align-items:center;gap:1rem;">
              <div style="flex:1;">
                <div class="stat-row">
                  <span class="stat-lbl"><span class="dot" style="background:#2d5a47"></span><fmt:message key="stat.scheduled"/></span>
                  <div class="bar-wrap"><div class="bar-fill" id="bar-prog" style="width:0%"></div></div>
                  <span class="stat-val" id="val-prog">0</span>
                </div>
                <div class="stat-row">
                  <span class="stat-lbl"><span class="dot" style="background:#6a9e8a"></span>Completadas</span>
                  <div class="bar-wrap"><div class="bar-fill alt" id="bar-comp" style="width:0%"></div></div>
                  <span class="stat-val" id="val-comp">0</span>
                </div>
                <div class="stat-row">
                  <span class="stat-lbl"><span class="dot" style="background:#fca5a5"></span><fmt:message key="stat.cancelled"/></span>
                  <div class="bar-wrap"><div class="bar-fill" id="bar-canc" style="width:0%;background:#fca5a5;"></div></div>
                  <span class="stat-val" id="val-canc">0</span>
                </div>
              </div>
              <div class="big-stat">
                <div class="num"><%= citasHoyCount %></div>
                <div class="sub"><fmt:message key="stat.appointments.today"/></div>
              </div>
            </div>
          </div>
        </div>
        <div class="db-col-half">
          <div class="db-card">
            <div class="db-card-title">📈 Tendencia mensual de citas</div>
            <canvas id="trendChart" height="100"></canvas>
          </div>
        </div>
      </div>

      <%-- FILA 3: Donut roles + Tabla especialidades --%>
      <div class="db-row">
        <div class="db-col-third" style="max-width:280px;">
          <div class="db-card">
            <div class="db-card-title">👥 Usuarios por rol</div>
            <div class="donut-wrap" style="display:flex;justify-content:center;">
              <canvas id="donutChart" width="160" height="160" style="max-width:160px;"></canvas>
            </div>
            <div class="legend-list" id="donut-legend"></div>
          </div>
        </div>
        <div style="flex:2;min-width:280px;">
          <div class="db-card">
            <div class="db-card-title">🏥 <fmt:message key="cita.specialty"/> — análisis</div>
            <div style="overflow-x:auto;">
              <table class="dash-table">
                <thead><tr>
                  <th><fmt:message key="cita.specialty"/></th>
                  <th><fmt:message key="stat.scheduled"/></th>
                  <th>Completadas</th>
                  <th><fmt:message key="stat.cancelled"/></th>
                  <th>Total</th>
                </tr></thead>
                <tbody id="esp-table-body">
                  <tr><td colspan="5" style="text-align:center;padding:16px;color:#64748b;">Cargando...</td></tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>

      <%-- FILA 4: Top especialidades + Pie estados + Indicadores --%>
      <div class="db-row">
        <div class="db-col-third">
          <div class="db-card">
            <div class="db-card-title">🏆 Top especialidades</div>
            <div id="hbar-esp"></div>
          </div>
        </div>
        <div class="db-col-third">
          <div class="db-card">
            <div class="db-card-title">${msg["admin.chart.cita.dist"]}</div>
            <canvas id="pieChart2" height="150"></canvas>
          </div>
        </div>
        <div class="db-col-third">
          <div class="db-card">
            <div class="db-card-title">${msg["admin.chart.quick.kpis"]}</div>
            <div class="hbar-item">
              <div class="hbar-hdr"><span class="hbar-lbl">Citas pendientes</span><span class="hbar-pct" id="pct-pend">0%</span></div>
              <div class="hbar-track"><div class="hbar-fill" id="pend-bar" style="width:0%"></div></div>
            </div>
            <div class="hbar-item">
              <div class="hbar-hdr"><span class="hbar-lbl">Total citas</span><span class="hbar-pct"><%= totalCitas %></span></div>
              <div class="hbar-track"><div class="hbar-fill" style="width:100%"></div></div>
            </div>
            <div class="hbar-item">
              <div class="hbar-hdr"><span class="hbar-lbl">${msg["stat.medicos.activos"]}</span><span class="hbar-pct"><%= totalMedicos %></span></div>
              <div class="hbar-track"><div class="hbar-fill" style="width:<%= Math.min(totalMedicos * 5, 100) %>%"></div></div>
            </div>
            <div style="margin-top:1.2rem;text-align:center;">
              <div class="highlight-pct" id="pct-pend-big">0%</div>
              <div class="highlight-sub">citas programadas sobre el total</div>
            </div>
          </div>
        </div>
      </div>

      <%-- FILA 5: Barras especialidades + Distribución edades --%>
      <div class="db-row">
        <div class="db-col-half">
          <div class="db-card">
            <div class="db-card-title">📊 Citas por especialidad</div>
            <canvas id="barEspChart" height="120"></canvas>
          </div>
        </div>
        <div class="db-col-half">
          <div class="db-card">
            <div class="db-card-title">${msg["admin.chart.age.dist"]}</div>
            <div class="hbar-item"><div class="hbar-hdr"><span class="hbar-lbl">18 – 25</span><span class="hbar-pct">18.6%</span></div><div class="hbar-track"><div class="hbar-fill" style="width:18.6%"></div></div></div>
            <div class="hbar-item"><div class="hbar-hdr"><span class="hbar-lbl">26 – 35</span><span class="hbar-pct">40.9%</span></div><div class="hbar-track"><div class="hbar-fill" style="width:40.9%"></div></div></div>
            <div class="hbar-item"><div class="hbar-hdr"><span class="hbar-lbl">36 – 45</span><span class="hbar-pct">18.1%</span></div><div class="hbar-track"><div class="hbar-fill" style="width:18.1%;background:#6a9e8a"></div></div></div>
            <div class="hbar-item"><div class="hbar-hdr"><span class="hbar-lbl">46 – 55</span><span class="hbar-pct">11.0%</span></div><div class="hbar-track"><div class="hbar-fill" style="width:11%;background:#6a9e8a"></div></div></div>
            <div class="hbar-item"><div class="hbar-hdr"><span class="hbar-lbl">56+</span><span class="hbar-pct">11.4%</span></div><div class="hbar-track"><div class="hbar-fill" style="width:11.4%;background:#fca5a5"></div></div></div>
          </div>
        </div>
      </div>


      <%-- FILA 6: Horarios por médico --%>
      <div class="db-row">
        <div class="db-col-full">
          <div class="db-card">
            <div class="db-card-title">${msg["admin.chart.schedule.by.doc"]}</div>
            <div style="display:flex;gap:.6rem;flex-wrap:wrap;margin-bottom:1rem;" id="medico-tabs"></div>
            <div id="horario-panel">
              <p style="color:#64748b;font-size:.8rem;text-align:center;padding:1rem;">${msg["admin.schedule.select.doctor"]}</p>
            </div>
          </div>
        </div>
      </div>

    </div><%-- /dashboard-content --%>
  </main>

</div><%-- cierre sb-layout que abre sidebar.jsp --%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
const estadoCitasRaw    = <%=estadoCitasJson%>;
const citasPorEspRaw    = <%=citasPorEspJson%>;
const usuariosPorRol    = <%=usuariosPorRolJson%>;
const mesesLabels       = <%=mesesJson%>;
const mesesCantidades   = <%=cantidadesJson%>;
const totalCitasGlobal  = <%= totalCitas %>;
const pendientesGlobal  = <%= citasPendientes %>;

const G  = '#2d5a47'; const GL = '#6a9e8a'; const GR = '#fca5a5';
const COLORES = [G, GL, GR, '#4a7c68', '#8fbdaa', '#c4234f'];

// ── Estado citas barras ─────────────────────────────────────
(function(){
  const prog = estadoCitasRaw['PROGRAMADA']||0, comp = estadoCitasRaw['COMPLETADA']||0, canc = estadoCitasRaw['CANCELADA']||0;
  const max  = Math.max(prog,comp,canc,1);
  ['prog','comp','canc'].forEach((k,i)=>{
    const vals = [prog,comp,canc];
    document.getElementById('val-'+k).textContent = vals[i];
    document.getElementById('bar-'+k).style.width = (vals[i]/max*100)+'%';
  });
  const pct = totalCitasGlobal>0 ? Math.round(pendientesGlobal/totalCitasGlobal*100) : 0;
  document.getElementById('pct-pend').textContent = pct+'%';
  document.getElementById('pend-bar').style.width = pct+'%';
  document.getElementById('pct-pend-big').textContent = pct+'%';
})();

// ── Trend chart ─────────────────────────────────────────────
new Chart(document.getElementById('trendChart'),{
  type:'bar',
  data:{ labels: mesesLabels.length?mesesLabels:['Ene','Feb','Mar','Abr','May','Jun'],
         datasets:[{data:mesesCantidades.length?mesesCantidades:[0,0,0,0,0,0], backgroundColor:G, borderRadius:5}]},
  options:{ plugins:{legend:{display:false}}, scales:{x:{grid:{display:false}},y:{grid:{color:'#f1f5f9'}}}, maintainAspectRatio:true }
});

// ── Donut roles ─────────────────────────────────────────────
(function(){
  const labels=Object.keys(usuariosPorRol), values=Object.values(usuariosPorRol);
  const total=values.reduce((a,b)=>a+b,1);
  new Chart(document.getElementById('donutChart'),{
    type:'doughnut',
    data:{labels, datasets:[{data:values, backgroundColor:COLORES.slice(0,labels.length), borderWidth:3, borderColor:'#fff'}]},
    options:{cutout:'65%', plugins:{legend:{display:false}}, maintainAspectRatio:false}
  });
  const lg=document.getElementById('donut-legend');
  labels.forEach((l,i)=>{
    const pct=Math.round(values[i]/total*100);
    lg.innerHTML+='<div class="legend-item"><span class="legend-lbl"><span class="dot" style="background:'+COLORES[i]+'" ></span>'+l+'</span><span class="legend-pct">'+pct+'%</span></div>';
  });
})();

// ── Tabla especialidades ─────────────────────────────────────
(function(){
  const espK=Object.keys(citasPorEspRaw), espV=Object.values(citasPorEspRaw);
  const prog=estadoCitasRaw['PROGRAMADA']||0, comp=estadoCitasRaw['COMPLETADA']||0, canc=estadoCitasRaw['CANCELADA']||0;
  const espTot=espV.reduce((a,b)=>a+b,1);
  const tb=document.getElementById('esp-table-body');
  if(!espK.length){ tb.innerHTML='<tr><td colspan="5" style="text-align:center;color:#64748b">Sin datos de especialidades</td></tr>'; return; }
  tb.innerHTML=espK.map(function(k,i){
    var tot=espV[i], r=tot/espTot;
    return '<tr><td><strong>'+k+'</strong></td><td><span class="badge-db badge-prog">'+Math.round(prog*r)+'</span></td><td><span class="badge-db badge-comp">'+Math.round(comp*r)+'</span></td><td><span class="badge-db badge-canc">'+Math.round(canc*r)+'</span></td><td><strong>'+tot+'</strong></td></tr>';
  }).join('');
})();

// ── H-bars especialidades ────────────────────────────────────
(function(){
  const espK=Object.keys(citasPorEspRaw), espV=Object.values(citasPorEspRaw);
  const maxE=Math.max(...espV,1);
  const hb=document.getElementById('hbar-esp');
  if(!espK.length){ hb.innerHTML='<p style="color:#64748b;text-align:center;font-size:12px">Sin datos</p>'; return; }
  hb.innerHTML=espK.slice(0,6).map(function(k,i){
    var pct=Math.round(espV[i]/maxE*100);
    var bg=i%2===0?G:GL;
    return '<div class="hbar-item"><div class="hbar-hdr"><span class="hbar-lbl">'+k+'</span><span class="hbar-pct">'+pct+'%</span></div><div class="hbar-track"><div class="hbar-fill" style="width:'+pct+'%;background:'+bg+'"></div></div></div>';
  }).join('');
})();

// ── Pie chart estados ────────────────────────────────────────
new Chart(document.getElementById('pieChart2'),{
  type:'pie',
  data:{labels:['Programadas','Completadas','Canceladas'],
        datasets:[{data:[estadoCitasRaw['PROGRAMADA']||0,estadoCitasRaw['COMPLETADA']||0,estadoCitasRaw['CANCELADA']||0],
                   backgroundColor:[G,GL,GR], borderWidth:3, borderColor:'#fff'}]},
  options:{plugins:{legend:{position:'bottom',labels:{font:{size:10},color:'#64748b',boxWidth:10,padding:6}}}, maintainAspectRatio:true}
});

// ── Bar chart especialidades ─────────────────────────────────
(function(){
  const espK=Object.keys(citasPorEspRaw).slice(0,8), espV=espK.map(k=>citasPorEspRaw[k]);
  new Chart(document.getElementById('barEspChart'),{
    type:'bar',
    data:{labels:espK.length?espK:['Sin datos'], datasets:[{data:espV.length?espV:[0], backgroundColor:G, borderRadius:5}]},
    options:{plugins:{legend:{display:false}}, scales:{x:{grid:{display:false},ticks:{font:{size:9},maxRotation:30}},y:{grid:{color:'#f1f5f9'}}}, maintainAspectRatio:true}
  });
})();

// ── Horarios por médico ──────────────────────────────────────
(function(){
  const data = <%=horariosJson%>;
  const tabs = document.getElementById('medico-tabs');
  const panel = document.getElementById('horario-panel');
  const dias = MSG_DAYS;
  const G = '#2d5a47';

  if(!data.length){
    tabs.innerHTML = '<p style="color:#64748b;font-size:.8rem;">' + MSG_NO_DOCS + '</p>';
    return;
  }

  function renderHorario(med){
    if(!med.horarios.length){
      panel.innerHTML = '<p style="color:#64748b;font-size:.8rem;text-align:center;padding:1rem;">'+med.nombre+' no tiene horarios registrados.</p>';
      return;
    }
    let html = '<div style="overflow-x:auto;"><table class="dash-table"><thead><tr><th>'+MSG_TH_DAY+'</th><th>'+MSG_TH_START+'</th><th>'+MSG_TH_END+'</th><th>'+MSG_TH_MAX+'</th></tr></thead><tbody>';
    med.horarios.forEach(function(h){
      html += '<tr><td><strong>'+h.dia+'</strong></td><td>'+h.inicio+'</td><td>'+h.fin+'</td><td><span class="badge-db badge-comp">'+h.max+'</span></td></tr>';
    });
    html += '</tbody></table></div>';

    // Resumen visual semana
    html += '<div style="display:flex;gap:.5rem;margin-top:.8rem;flex-wrap:wrap;">';
    dias.forEach(function(d){
      var tiene = med.horarios.some(function(h){ return h.dia === d; });
      html += '<div style="text-align:center;padding:.4rem .7rem;border-radius:8px;font-size:.7rem;font-weight:700;background:'+(tiene?'#d1fae5':'#f1f5f9')+';color:'+(tiene?'#065f46':'#94a3b8')+';border:2px solid '+(tiene?'#6ee7b7':'#e2e8f0')+';">';
      html += d.substring(0,3)+'<br><i class="fas '+(tiene?'fa-check-circle text-success':'fa-times-circle')+'" style="font-size:.9rem;"></i></div>';
    });
    html += '</div>';
    panel.innerHTML = html;
  }

  data.forEach(function(med, i){
    var btn = document.createElement('button');
    btn.textContent = med.nombre;
    btn.className = 'btn btn-sm rounded-pill';
    btn.style.cssText = 'font-size:.75rem;font-weight:600;';
    btn.setAttribute('data-idx', i);
    btn.addEventListener('click', function(){
      document.querySelectorAll('#medico-tabs button').forEach(function(b){ b.style.background='#f1f5f9'; b.style.color='#64748b'; });
      btn.style.background = G; btn.style.color = '#fff';
      renderHorario(data[i]);
    });
    tabs.appendChild(btn);
    if(i===0){ btn.style.background=G; btn.style.color='#fff'; renderHorario(med); }
  });
})();

</script>
</body>
</html>

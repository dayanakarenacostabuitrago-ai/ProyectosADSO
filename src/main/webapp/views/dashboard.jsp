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
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

  <style>
    :root {
      /* Paleta suave inspirada en MindMate - combina con verde sidebar */
      --primary:      #5a8f7b;
      --primary-light:#7db5a0;
      --primary-pale: #e8f5f0;
      --lavender:     #c4b5e0;
      --lavender-light:#ede7f6;
      --peach:        #f5d0c5;
      --peach-light:  #fdf2ef;
      --sky:          #a8d4e6;
      --sky-light:    #e8f4f8;
      --cream:        #faf9f6;
      --cream-warm:   #f5f0e8;
      --text:         #2d3436;
      --text-mid:     #636e72;
      --text-light:   #b2bec3;
      --white:        #ffffff;
      --shadow-soft:  0 4px 20px rgba(45,52,54,0.06);
      --shadow-hover: 0 8px 30px rgba(45,52,54,0.10);
      --radius:       20px;
      --radius-lg:    24px;
      --radius-sm:    14px;
      --radius-xs:    10px;
    }

    * { box-sizing: border-box; }
    body {
      font-family: 'Plus Jakarta Sans', 'Segoe UI', sans-serif;
      background: linear-gradient(135deg, var(--cream) 0%, var(--cream-warm) 100%);
      color: var(--text);
      min-height: 100vh;
    }

    /* Layout grid */
    .dash-container {
      display: grid;
      grid-template-columns: 1fr 320px;
      gap: 1.5rem;
      padding: 0;
      max-width: 1400px;
      margin: 0 auto;
    }
    @media (max-width: 1100px) {
      .dash-container { grid-template-columns: 1fr; }
    }

    /* Cards base */
    .glass-card {
      background: var(--white);
      border-radius: var(--radius);
      border: 1px solid rgba(0,0,0,0.04);
      box-shadow: var(--shadow-soft);
      overflow: hidden;
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .glass-card:hover {
      transform: translateY(-2px);
      box-shadow: var(--shadow-hover);
    }

    /* Welcome banner */
    .welcome-banner {
      background: linear-gradient(135deg, var(--primary-pale) 0%, var(--lavender-light) 50%, var(--peach-light) 100%);
      border-radius: var(--radius-lg);
      padding: 1.8rem 2rem;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 1.5rem;
      margin-bottom: 1.5rem;
      position: relative;
      overflow: hidden;
    }
    .welcome-banner::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -10%;
      width: 300px;
      height: 300px;
      background: radial-gradient(circle, rgba(90,143,123,0.08) 0%, transparent 70%);
      border-radius: 50%;
    }
    .welcome-text h2 {
      font-size: 1.4rem;
      font-weight: 800;
      color: var(--text);
      margin: 0 0 0.3rem;
    }
    .welcome-text p {
      font-size: 0.85rem;
      color: var(--text-mid);
      margin: 0;
    }
    .welcome-avatar {
      width: 70px;
      height: 70px;
      border-radius: var(--radius-sm);
      background: linear-gradient(135deg, var(--primary) 0%, var(--lavender) 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.8rem;
      color: white;
      flex-shrink: 0;
      box-shadow: 0 4px 15px rgba(90,143,123,0.3);
    }

    /* Stat pills */
    .stats-row {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
      gap: 1rem;
      margin-bottom: 1.5rem;
    }
    .stat-pill {
      background: var(--white);
      border-radius: var(--radius-sm);
      padding: 1.1rem 1.2rem;
      display: flex;
      align-items: center;
      gap: 0.9rem;
      box-shadow: var(--shadow-soft);
      border: 1px solid rgba(0,0,0,0.03);
      transition: all 0.3s ease;
    }
    .stat-pill:hover {
      transform: translateY(-3px);
      box-shadow: var(--shadow-hover);
    }
    .stat-icon {
      width: 44px;
      height: 44px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.1rem;
      flex-shrink: 0;
    }
    .stat-icon.green { background: var(--primary-pale); color: var(--primary); }
    .stat-icon.lavender { background: var(--lavender-light); color: #8e7cc3; }
    .stat-icon.peach { background: var(--peach-light); color: #d4896e; }
    .stat-icon.sky { background: var(--sky-light); color: #5dade2; }
    .stat-num {
      font-size: 1.6rem;
      font-weight: 800;
      color: var(--text);
      line-height: 1;
    }
    .stat-label {
      font-size: 0.7rem;
      color: var(--text-light);
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.06em;
      margin-top: 0.15rem;
    }

    /* Section headers */
    .section-title {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 1.1rem 1.4rem 0.9rem;
      border-bottom: 1px solid rgba(0,0,0,0.04);
    }
    .section-title h6 {
      font-size: 0.95rem;
      font-weight: 700;
      color: var(--text);
      margin: 0;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }
    .section-badge {
      font-size: 0.72rem;
      font-weight: 600;
      padding: 0.35rem 0.8rem;
      border-radius: 20px;
      background: var(--primary-pale);
      color: var(--primary);
    }

    /* Chart area */
    .chart-container {
      padding: 1rem 1.4rem 1.2rem;
    }
    .chart-flex {
      display: flex;
      gap: 1.2rem;
      align-items: flex-start;
    }
    .chart-main { flex: 1; min-height: 180px; }
    .chart-side {
      display: flex;
      flex-direction: column;
      gap: 0.6rem;
      min-width: 130px;
    }
    .side-metric {
      background: linear-gradient(135deg, var(--primary-pale) 0%, var(--lavender-light) 100%);
      border-radius: var(--radius-xs);
      padding: 0.7rem 0.9rem;
      text-align: center;
    }
    .side-metric.val2 { background: linear-gradient(135deg, var(--peach-light) 0%, var(--sky-light) 100%); }
    .side-metric-num {
      font-size: 1.3rem;
      font-weight: 800;
      color: var(--text);
    }
    .side-metric-label {
      font-size: 0.62rem;
      color: var(--text-mid);
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }

    /* Table styling */
    .modern-table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0;
    }
    .modern-table th {
      font-size: 0.68rem;
      font-weight: 700;
      color: var(--text-light);
      text-transform: uppercase;
      letter-spacing: 0.06em;
      padding: 0.8rem 1.2rem;
      background: transparent;
      border-bottom: 2px solid var(--primary-pale);
      white-space: nowrap;
    }
    .modern-table td {
      padding: 0.85rem 1.2rem;
      font-size: 0.84rem;
      color: var(--text);
      border-bottom: 1px solid rgba(0,0,0,0.03);
      vertical-align: middle;
    }
    .modern-table tbody tr {
      transition: background 0.2s ease;
    }
    .modern-table tbody tr:hover {
      background: var(--cream);
    }
    .modern-table tbody tr:last-child td { border-bottom: none; }

    .patient-avatar {
      width: 36px;
      height: 36px;
      border-radius: 50%;
      background: linear-gradient(135deg, var(--primary) 0%, var(--lavender) 100%);
      color: white;
      font-size: 0.72rem;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
    }
    .patient-name { font-weight: 600; }
    .patient-info { font-size: 0.75rem; color: var(--text-light); }

    .status-badge {
      font-size: 0.7rem;
      font-weight: 700;
      padding: 0.35em 0.9em;
      border-radius: 20px;
      display: inline-block;
    }
    .status-PROGRAMADA { background: var(--primary-pale); color: var(--primary); }
    .status-CONFIRMADA { background: var(--lavender-light); color: #7d6aaa; }
    .status-ATENDIDA   { background: var(--sky-light); color: #4a90a4; }
    .status-CANCELADA  { background: var(--peach-light); color: #c07860; }

    .action-btn {
      width: 32px;
      height: 32px;
      border-radius: 10px;
      border: none;
      background: var(--cream);
      color: var(--text-mid);
      display: inline-flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      transition: all 0.2s ease;
      text-decoration: none;
    }
    .action-btn:hover {
      background: var(--primary);
      color: white;
      transform: scale(1.1);
    }

    /* Empty state */
    .empty-state {
      text-align: center;
      padding: 3rem 2rem;
      color: var(--text-light);
    }
    .empty-state i {
      font-size: 3rem;
      opacity: 0.3;
      margin-bottom: 1rem;
      display: block;
    }
    .empty-state p { margin: 0; font-size: 0.9rem; }

    /* Right panel */
    .right-column { display: flex; flex-direction: column; gap: 1.2rem; }

    /* Profile card */
    .profile-card {
      text-align: center;
      padding: 1.8rem 1.2rem 1.2rem;
      background: linear-gradient(180deg, var(--white) 0%, var(--cream) 100%);
    }
    .profile-avatar-large {
      width: 80px;
      height: 80px;
      border-radius: var(--radius-sm);
      background: linear-gradient(135deg, var(--primary) 0%, var(--lavender) 50%, var(--peach) 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 2.2rem;
      color: white;
      margin: 0 auto 0.8rem;
      box-shadow: 0 6px 20px rgba(90,143,123,0.25);
    }
    .profile-name {
      font-size: 1.05rem;
      font-weight: 800;
      color: var(--text);
      margin: 0 0 0.2rem;
    }
    .profile-role {
      font-size: 0.78rem;
      color: var(--text-light);
      font-weight: 500;
      margin-bottom: 1rem;
    }
    .profile-stats {
      display: grid;
      grid-template-columns: 1fr 1fr;
      border-top: 1px solid rgba(0,0,0,0.05);
      padding-top: 1rem;
    }
    .profile-stat { text-align: center; }
    .profile-stat:first-child { border-right: 1px solid rgba(0,0,0,0.05); }
    .profile-stat-num {
      font-size: 1.4rem;
      font-weight: 800;
      color: var(--text);
    }
    .profile-stat-label {
      font-size: 0.62rem;
      color: var(--text-light);
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.06em;
    }

    /* Calendar */
    .calendar-wrap { padding: 1rem 1.1rem 1.1rem; }
    .calendar-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 0.8rem;
    }
    .calendar-title {
      font-size: 0.95rem;
      font-weight: 700;
      color: var(--text);
    }
    .calendar-nav {
      width: 28px;
      height: 28px;
      border-radius: 8px;
      border: 1px solid rgba(0,0,0,0.08);
      background: var(--white);
      color: var(--text-mid);
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      font-size: 0.7rem;
      transition: all 0.2s;
    }
    .calendar-nav:hover {
      background: var(--primary);
      color: white;
      border-color: var(--primary);
    }
    .calendar-grid {
      display: grid;
      grid-template-columns: repeat(7, 1fr);
      gap: 2px;
      text-align: center;
    }
    .cal-day-name {
      font-size: 0.6rem;
      font-weight: 700;
      color: var(--text-light);
      padding: 0.3rem 0;
      text-transform: uppercase;
    }
    .cal-day {
      font-size: 0.78rem;
      padding: 0.35rem 0.1rem;
      border-radius: 8px;
      color: var(--text-mid);
      cursor: pointer;
      transition: all 0.2s;
    }
    .cal-day:hover:not(.other):not(.today) {
      background: var(--primary-pale);
      color: var(--primary);
    }
    .cal-day.other { color: #ddd; }
    .cal-day.today {
      background: linear-gradient(135deg, var(--primary) 0%, var(--lavender) 100%);
      color: white;
      font-weight: 700;
      box-shadow: 0 2px 8px rgba(90,143,123,0.3);
    }
    .cal-day.has-event {
      position: relative;
    }
    .cal-day.has-event::after {
      content: '';
      position: absolute;
      bottom: 2px;
      left: 50%;
      transform: translateX(-50%);
      width: 4px;
      height: 4px;
      border-radius: 50%;
      background: var(--peach);
    }

    /* Donut chart */
    .donut-container {
      padding: 1.2rem 1.1rem;
      text-align: center;
    }
    .donut-wrapper {
      position: relative;
      display: inline-block;
      margin: 0.5rem 0;
    }
    .donut-center {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      text-align: center;
    }
    .donut-center-num {
      font-size: 1.5rem;
      font-weight: 800;
      color: var(--text);
      line-height: 1;
    }
    .donut-center-label {
      font-size: 0.65rem;
      color: var(--text-light);
      font-weight: 600;
      text-transform: uppercase;
    }
    .donut-legend {
      display: flex;
      justify-content: center;
      gap: 1rem;
      margin-top: 0.8rem;
    }
    .legend-item {
      display: flex;
      align-items: center;
      gap: 0.35rem;
      font-size: 0.72rem;
      color: var(--text-mid);
      font-weight: 600;
    }
    .legend-dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
    }

    /* Quick actions */
    .quick-actions { padding: 0.6rem; }
    .quick-action-btn {
      display: flex;
      align-items: center;
      gap: 0.8rem;
      padding: 0.75rem 1rem;
      border-radius: var(--radius-xs);
      text-decoration: none;
      color: var(--text);
      font-size: 0.82rem;
      font-weight: 600;
      transition: all 0.25s ease;
      margin-bottom: 0.4rem;
      border: 1px solid transparent;
    }
    .quick-action-btn:last-child { margin-bottom: 0; }
    .quick-action-btn:hover {
      background: var(--primary-pale);
      border-color: var(--primary-light);
      color: var(--primary);
      transform: translateX(4px);
    }
    .quick-action-btn i {
      width: 32px;
      height: 32px;
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 0.9rem;
      flex-shrink: 0;
    }
    .qa-green i { background: var(--primary-pale); color: var(--primary); }
    .qa-lavender i { background: var(--lavender-light); color: #8e7cc3; }
    .qa-peach i { background: var(--peach-light); color: #d4896e; }
    .qa-sky i { background: var(--sky-light); color: #5dade2; }

    /* Readonly notice */
    .readonly-notice {
      margin-top: 1rem;
      background: linear-gradient(135deg, var(--lavender-light) 0%, var(--peach-light) 100%);
      border-left: 4px solid var(--lavender);
      border-radius: var(--radius-xs);
      padding: 1rem 1.2rem;
      font-size: 0.82rem;
      color: #6c5b7b;
      display: flex;
      align-items: center;
      gap: 0.6rem;
    }

    /* Animations */
    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .animate-in {
      animation: fadeInUp 0.6s ease forwards;
    }
    .delay-1 { animation-delay: 0.1s; opacity: 0; }
    .delay-2 { animation-delay: 0.2s; opacity: 0; }
    .delay-3 { animation-delay: 0.3s; opacity: 0; }

    /* Toast */
    .toast-container-custom {
      position: fixed;
      top: 80px;
      right: 24px;
      z-index: 9999;
      display: flex;
      flex-direction: column;
      gap: 10px;
      max-width: 340px;
    }
    .sb-toast {
      background: var(--white);
      border-radius: var(--radius-sm);
      border-left: 4px solid var(--primary);
      box-shadow: var(--shadow-hover);
      padding: 0.9rem 1.1rem;
      display: flex;
      align-items: flex-start;
      gap: 0.7rem;
      animation: toastIn 0.35s cubic-bezier(0.68, -0.55, 0.265, 1.55);
    }
    .sb-toast.toast-error   { border-color: #e07a5f; }
    .sb-toast.toast-warning { border-color: #f2cc8f; }
    .sb-toast.toast-info    { border-color: #81b29a; }
    .sb-toast-icon { font-size: 1.1rem; flex-shrink: 0; margin-top: 0.05rem; }
    .sb-toast.toast-error   .sb-toast-icon { color: #e07a5f; }
    .sb-toast.toast-warning .sb-toast-icon { color: #f2cc8f; }
    .sb-toast.toast-info    .sb-toast-icon { color: #81b29a; }
    .sb-toast-text { font-size: 0.82rem; color: var(--text); font-weight: 500; flex: 1; }
    .sb-toast-close { background: none; border: none; color: var(--text-light); cursor: pointer; font-size: 1rem; padding: 0; transition: color 0.2s; }
    .sb-toast-close:hover { color: var(--text); }
    @keyframes toastIn {
      from { opacity: 0; transform: translateX(40px) scale(0.9); }
      to { opacity: 1; transform: translateX(0) scale(1); }
    }

    /* Scrollbar */
    ::-webkit-scrollbar { width: 6px; }
    ::-webkit-scrollbar-track { background: transparent; }
    ::-webkit-scrollbar-thumb { background: var(--primary-light); border-radius: 10px; }
    ::-webkit-scrollbar-thumb:hover { background: var(--primary); }
  </style>
</head>
<body>

<%@ include file="/views/templates/header.jsp" %>
<c:set var="activePage" value="dashboard" scope="request"/>
<%@ include file="/views/templates/sidebar.jsp" %>

<div class="sb-main">

  <%-- Calcular contadores --%>
  <c:set var="programadasCount" value="0"/>
  <c:set var="confirmadasCount" value="0"/>
  <c:set var="canceladasCount"  value="0"/>
  <c:set var="atendidasCount"   value="0"/>
  <c:forEach var="c" items="${citasHoy}">
    <c:if test="${c.estado == 'PROGRAMADA'}"> <c:set var="programadasCount" value="${programadasCount + 1}"/></c:if>
    <c:if test="${c.estado == 'CONFIRMADA'}"> <c:set var="confirmadasCount" value="${confirmadasCount + 1}"/></c:if>
    <c:if test="${c.estado == 'CANCELADA'}">  <c:set var="canceladasCount"  value="${canceladasCount  + 1}"/></c:if>
    <c:if test="${c.estado == 'ATENDIDA'}">   <c:set var="atendidasCount"   value="${atendidasCount   + 1}"/></c:if>
  </c:forEach>
  <c:set var="totalHoy" value="${empty citasHoy ? 0 : citasHoy.size()}"/>

  <div class="dash-container">

    <%-- ══ COLUMNA IZQUIERDA ══ --%>
    <div>

      <%-- Welcome Banner --%>
      <div class="welcome-banner animate-in">
        <div class="welcome-text">
          <h2><fmt:message key="dashboard.welcome"/></h2>
          <p><fmt:message key="dashboard.subtitle"/></p>
        </div>
        <div class="welcome-avatar">
          <c:choose>
            <c:when test="${sessionScope.usuarioRol == 'MEDICO'}"><i class="fas fa-user-md"></i></c:when>
            <c:when test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}"><i class="fas fa-concierge-bell"></i></c:when>
            <c:when test="${sessionScope.usuarioRol == 'ADMINISTRADOR'}"><i class="fas fa-shield-alt"></i></c:when>
            <c:otherwise><i class="fas fa-user-nurse"></i></c:otherwise>
          </c:choose>
        </div>
      </div>

      <%-- Stats Pills por Rol --%>
      <c:choose>
        <c:when test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}">
          <div class="stats-row animate-in delay-1">
            <div class="stat-pill">
              <div class="stat-icon green"><i class="fas fa-users"></i></div>
              <div>
                <div class="stat-num">${totalPacientes != null ? totalPacientes : 0}</div>
                <div class="stat-label"><fmt:message key="stat.patients"/></div>
              </div>
            </div>
            <div class="stat-pill">
              <div class="stat-icon lavender"><i class="fas fa-calendar-day"></i></div>
              <div>
                <div class="stat-num">${totalHoy}</div>
                <div class="stat-label"><fmt:message key="stat.appointments.today"/></div>
              </div>
            </div>
            <div class="stat-pill">
              <div class="stat-icon peach"><i class="fas fa-hourglass-half"></i></div>
              <div>
                <div class="stat-num">${citasPendientes != null ? citasPendientes : programadasCount}</div>
                <div class="stat-label"><fmt:message key="stat.scheduled"/></div>
              </div>
            </div>
          </div>
        </c:when>
        <c:when test="${sessionScope.usuarioRol == 'MEDICO'}">
          <div class="stats-row animate-in delay-1">
            <div class="stat-pill">
              <div class="stat-icon green"><i class="fas fa-calendar-day"></i></div>
              <div>
                <div class="stat-num">${totalHoy}</div>
                <div class="stat-label"><fmt:message key="stat.appointments.today"/></div>
              </div>
            </div>
            <div class="stat-pill">
              <div class="stat-icon lavender"><i class="fas fa-check-circle"></i></div>
              <div>
                <div class="stat-num">${confirmadasCount}</div>
                <div class="stat-label"><fmt:message key="stat.confirmed"/></div>
              </div>
            </div>
            <div class="stat-pill">
              <div class="stat-icon peach"><i class="fas fa-hourglass-half"></i></div>
              <div>
                <div class="stat-num">${programadasCount}</div>
                <div class="stat-label"><fmt:message key="stat.scheduled"/></div>
              </div>
            </div>
            <div class="stat-pill">
              <div class="stat-icon sky"><i class="fas fa-times-circle"></i></div>
              <div>
                <div class="stat-num">${canceladasCount}</div>
                <div class="stat-label"><fmt:message key="stat.cancelled"/></div>
              </div>
            </div>
          </div>
        </c:when>
        <c:when test="${sessionScope.usuarioRol == 'ENFERMERO'}">
          <div class="stats-row animate-in delay-1">
            <div class="stat-pill">
              <div class="stat-icon green"><i class="fas fa-calendar-day"></i></div>
              <div>
                <div class="stat-num">${totalHoy}</div>
                <div class="stat-label"><fmt:message key="stat.appointments.today"/></div>
              </div>
            </div>
            <div class="stat-pill">
              <div class="stat-icon lavender"><i class="fas fa-check-circle"></i></div>
              <div>
                <div class="stat-num">${confirmadasCount}</div>
                <div class="stat-label"><fmt:message key="stat.confirmed"/></div>
              </div>
            </div>
            <div class="stat-pill">
              <div class="stat-icon peach"><i class="fas fa-hourglass-half"></i></div>
              <div>
                <div class="stat-num">${programadasCount}</div>
                <div class="stat-label"><fmt:message key="stat.scheduled"/></div>
              </div>
            </div>
          </div>
        </c:when>
      </c:choose>

      <%-- Gráfico de Actividad --%>
      <div class="glass-card mb-4 animate-in delay-2">
        <div class="section-title">
          <h6><i class="fas fa-chart-line" style="color: var(--primary);"></i> <fmt:message key="dashboard.activity"/></h6>
          <span class="section-badge" id="mesLabel">Cargando...</span>
        </div>
        <div class="chart-container">
          <div class="chart-flex">
            <div class="chart-main">
              <canvas id="actividadChart" height="180"></canvas>
            </div>
            <div class="chart-side">
              <div class="side-metric">
                <div class="side-metric-num">${totalHoy}</div>
                <div class="side-metric-label"><fmt:message key="stat.new"/></div>
              </div>
              <div class="side-metric val2">
                <div class="side-metric-num">${programadasCount}</div>
                <div class="side-metric-label"><fmt:message key="stat.scheduled"/></div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <%-- Tabla de Citas --%>
      <div class="glass-card animate-in delay-3">
        <div class="section-title">
          <h6>
            <c:choose>
              <c:when test="${sessionScope.usuarioRol == 'MEDICO'}"><i class="fas fa-calendar-check" style="color: var(--primary);"></i> <fmt:message key="dashboard.my.appointments"/></c:when>
              <c:otherwise><i class="fas fa-users" style="color: var(--primary);"></i> <fmt:message key="dashboard.recent.patients"/></c:otherwise>
            </c:choose>
          </h6>
          <a href="${pageContext.request.contextPath}/citas" class="section-badge" style="text-decoration: none;">
            <fmt:message key="dashboard.view.all"/> <i class="fas fa-arrow-right ms-1" style="font-size: 0.6rem;"></i>
          </a>
        </div>

        <c:choose>
          <c:when test="${empty citasHoy}">
            <div class="empty-state">
              <i class="fas fa-calendar-times"></i>
              <p><fmt:message key="dashboard.no.appointments"/></p>
              <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}">
                <a href="${pageContext.request.contextPath}/citas?accion=nuevo" class="quick-action-btn qa-green mt-3" style="display: inline-flex; width: auto;">
                  <i class="fas fa-plus"></i> <fmt:message key="dashboard.schedule.appointment"/>
                </a>
              </c:if>
            </div>
          </c:when>
          <c:otherwise>
            <div style="overflow-x: auto;">
              <table class="modern-table">
                <thead>
                  <tr>
                    <th><fmt:message key="paciente.nombre"/></th>
                    <c:if test="${sessionScope.usuarioRol != 'MEDICO'}"><th><fmt:message key="cita.medico"/></th></c:if>
                    <th><fmt:message key="cita.hora"/></th>
                    <th><fmt:message key="cita.specialty"/></th>
                    <th><fmt:message key="cita.estado"/></th>
                    <c:if test="${sessionScope.usuarioRol != 'ENFERMERO'}"><th style="width: 50px;"></th></c:if>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="cita" items="${citasHoy}">
                    <tr>
                      <td>
                        <div class="d-flex align-items-center gap-2">
                          <div class="patient-avatar">
                            <c:choose>
                              <c:when test="${not empty cita.pacienteNombre}">${fn:substring(cita.pacienteNombre,0,1)}${fn:substring(cita.pacienteApellido,0,1)}</c:when>
                              <c:otherwise><i class="fas fa-user" style="font-size: 0.6rem;"></i></c:otherwise>
                            </c:choose>
                          </div>
                          <div>
                            <div class="patient-name">${cita.pacienteNombre} ${cita.pacienteApellido}</div>
                            <div class="patient-info">${cita.motivo}</div>
                          </div>
                        </div>
                      </td>
                      <c:if test="${sessionScope.usuarioRol != 'MEDICO'}">
                        <td style="color: var(--text-mid);">${cita.medicoNombre} ${cita.medicoApellido}</td>
                      </c:if>
                      <td style="font-weight: 700; color: var(--primary);">${cita.horaCita}</td>
                      <td style="color: var(--text-mid); max-width: 140px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                        ${not empty cita.especialidad ? cita.especialidad : cita.motivo}
                      </td>
                      <td><span class="status-badge status-${cita.estado}">${cita.estado}</span></td>
                      <c:if test="${sessionScope.usuarioRol != 'ENFERMERO'}">
                        <td>
                          <c:choose>
                            <c:when test="${sessionScope.usuarioRol == 'MEDICO'}">
                              <a href="${pageContext.request.contextPath}/citas?accion=detalle&id=${cita.idCita}" class="action-btn" title="Ver detalle">
                                <i class="fas fa-eye"></i>
                              </a>
                            </c:when>
                            <c:otherwise>
                              <a href="${pageContext.request.contextPath}/citas?accion=editar&id=${cita.idCita}" class="action-btn" title="Editar cita">
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
        <div class="readonly-notice animate-in delay-3">
          <i class="fas fa-lock"></i>
          <fmt:message key="dashboard.readonly.notice"/>
        </div>
      </c:if>

    </div><%-- /col izquierda --%>

    <%-- ══ COLUMNA DERECHA ══ --%>
    <div class="right-column">

      <%-- Profile Card --%>
      <div class="glass-card profile-card animate-in">
        <div class="profile-avatar-large">
          <c:choose>
            <c:when test="${sessionScope.usuarioRol == 'MEDICO'}"><i class="fas fa-user-md"></i></c:when>
            <c:when test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}"><i class="fas fa-concierge-bell"></i></c:when>
            <c:when test="${sessionScope.usuarioRol == 'ADMINISTRADOR'}"><i class="fas fa-shield-alt"></i></c:when>
            <c:otherwise><i class="fas fa-user-nurse"></i></c:otherwise>
          </c:choose>
        </div>
        <div class="profile-name">${sessionScope.usuarioNombre}</div>
        <div class="profile-role">
          <c:choose>
            <c:when test="${sessionScope.usuarioRol == 'MEDICO'}"><fmt:message key="role.medico"/></c:when>
            <c:when test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}"><fmt:message key="role.recepcionista"/></c:when>
            <c:when test="${sessionScope.usuarioRol == 'ADMINISTRADOR'}"><fmt:message key="role.admin"/></c:when>
            <c:otherwise><fmt:message key="role.enfermero"/></c:otherwise>
          </c:choose>
        </div>
        <div class="profile-stats">
          <div class="profile-stat">
            <div class="profile-stat-num">${totalHoy}</div>
            <div class="profile-stat-label"><fmt:message key="stat.appointments"/></div>
          </div>
          <div class="profile-stat">
            <div class="profile-stat-num">${totalPacientes != null ? totalPacientes : (confirmadasCount + programadasCount)}</div>
            <div class="profile-stat-label"><fmt:message key="stat.patients"/></div>
          </div>
        </div>
      </div>

      <%-- Calendar --%>
      <div class="glass-card animate-in delay-1">
        <div class="calendar-wrap">
          <div class="calendar-header">
            <div class="calendar-title" id="calTitle"></div>
            <div class="d-flex gap-1">
              <button class="calendar-nav" id="calPrev"><i class="fas fa-chevron-left"></i></button>
              <button class="calendar-nav" id="calNext"><i class="fas fa-chevron-right"></i></button>
            </div>
          </div>
          <div class="calendar-grid" id="calGrid"></div>
        </div>
      </div>

      <%-- Donut Chart --%>
      <div class="glass-card animate-in delay-2">
        <div class="donut-container">
          <div class="section-title" style="padding: 0 0 0.5rem; border: none;">
            <h6 style="font-size: 0.85rem;"><fmt:message key="stat.distribution"/></h6>
          </div>
          <div class="donut-wrapper">
            <canvas id="donutChart" width="130" height="130"></canvas>
            <div class="donut-center">
              <div class="donut-center-num">${totalPacientes != null ? totalPacientes : (totalHoy + confirmadasCount)}</div>
              <div class="donut-center-label"><fmt:message key="stat.patients"/></div>
            </div>
          </div>
          <div class="donut-legend">
            <div class="legend-item">
              <span class="legend-dot" style="background: var(--primary);"></span>
              <fmt:message key="stat.consultations"/>
            </div>
            <div class="legend-item">
              <span class="legend-dot" style="background: var(--lavender);"></span>
              <fmt:message key="stat.returns"/>
            </div>
          </div>
        </div>
      </div>

      <%-- Quick Actions --%>
      <div class="glass-card animate-in delay-3">
        <div class="section-title">
          <h6><i class="fas fa-bolt" style="color: var(--primary);"></i> <fmt:message key="dashboard.quick.actions"/></h6>
        </div>
        <div class="quick-actions">
          <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}">
            <a href="${pageContext.request.contextPath}/citas?accion=nuevo" class="quick-action-btn qa-green">
              <i class="fas fa-calendar-plus"></i> <fmt:message key="cita.new"/>
            </a>
            <a href="${pageContext.request.contextPath}/pacientes?accion=nuevo" class="quick-action-btn qa-lavender">
              <i class="fas fa-user-plus"></i> <fmt:message key="paciente.new"/>
            </a>
          </c:if>
          <a href="${pageContext.request.contextPath}/citas" class="quick-action-btn qa-peach">
            <i class="fas fa-list-alt"></i> <fmt:message key="nav.view.appointments"/>
          </a>
          <c:if test="${sessionScope.usuarioRol != 'ENFERMERO'}">
            <a href="${pageContext.request.contextPath}/horarios" class="quick-action-btn qa-sky">
              <i class="fas fa-clock"></i> <fmt:message key="nav.schedules"/>
            </a>
          </c:if>
          <c:if test="${sessionScope.usuarioRol == 'MEDICO' || sessionScope.usuarioRol == 'RECEPCIONISTA'}">
            <a href="${pageContext.request.contextPath}/citas?accion=exportarPDF" target="_blank" class="quick-action-btn qa-green">
              <i class="fas fa-file-pdf"></i> <fmt:message key="nav.export.pdf"/>
            </a>
          </c:if>
        </div>
      </div>

    </div><%-- /right column --%>

  </div><%-- /dash-container --%>
</div><%-- /sb-main --%>
</div><%-- /sb-layout --%>

<%-- Toast container --%>
<div class="toast-container-custom" id="toastContainer"></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
/* ══ TOAST ══ */
function showToast(msg, type) {
  type = type || 'success';
  var icons = {
    success: 'fa-check-circle',
    error: 'fa-times-circle',
    warning: 'fa-exclamation-triangle',
    info: 'fa-info-circle'
  };
  var colors = {
    success: '#5a8f7b',
    error: '#e07a5f',
    warning: '#f2cc8f',
    info: '#81b29a'
  };
  var box = document.getElementById('toastContainer');
  var t = document.createElement('div');
  t.className = 'sb-toast' + (type !== 'success' ? ' toast-' + type : '');
  t.innerHTML = '<i class="fas ' + icons[type] + ' sb-toast-icon" style="color:' + colors[type] + '"></i>' +
    '<span class="sb-toast-text">' + msg + '</span>' +
    '<button class="sb-toast-close" onclick="this.parentElement.remove()">&times;</button>';
  box.appendChild(t);
  setTimeout(function() {
    if (t.parentElement) {
      t.style.cssText += 'opacity:0;transform:translateX(40px) scale(0.9);transition:all .3s ease;';
      setTimeout(function() { t.remove(); }, 300);
    }
  }, 5000);
}

/* Flash message server-side */
<c:if test="${not empty sessionScope.flashMessage}">
  showToast('${sessionScope.flashMessage}', '${not empty sessionScope.flashType ? sessionScope.flashType : "success"}');
</c:if>

/* Dashboard loaded notification */
document.addEventListener('DOMContentLoaded', function() {
  var hora = new Date().toLocaleTimeString('es-CO', {hour: '2-digit', minute: '2-digit'});
  showToast('<fmt:message key="dashboard.loaded"/> — ' + hora, 'info');
});

/* ══ CALENDAR ══ */
(function() {
  var meses = ['<fmt:message key="cal.jan"/>','<fmt:message key="cal.feb"/>','<fmt:message key="cal.mar"/>','<fmt:message key="cal.apr"/>','<fmt:message key="cal.may"/>','<fmt:message key="cal.jun"/>','<fmt:message key="cal.jul"/>','<fmt:message key="cal.aug"/>','<fmt:message key="cal.sep"/>','<fmt:message key="cal.oct"/>','<fmt:message key="cal.nov"/>','<fmt:message key="cal.dec"/>'];
  var dias  = ['<fmt:message key="cal.sun"/>','<fmt:message key="cal.mon"/>','<fmt:message key="cal.tue"/>','<fmt:message key="cal.wed"/>','<fmt:message key="cal.thu"/>','<fmt:message key="cal.fri"/>','<fmt:message key="cal.sat"/>'];
  var hoy   = new Date();
  var cur   = new Date(hoy.getFullYear(), hoy.getMonth(), 1);
  document.getElementById('mesLabel').textContent = meses[hoy.getMonth()];

  function render() {
    var y = cur.getFullYear(), m = cur.getMonth();
    document.getElementById('calTitle').textContent = meses[m] + ' ' + y;
    var g = document.getElementById('calGrid');
    g.innerHTML = '';
    dias.forEach(function(d) {
      var el = document.createElement('div');
      el.className = 'cal-day-name';
      el.textContent = d;
      g.appendChild(el);
    });
    var first = new Date(y, m, 1).getDay();
    var last = new Date(y, m + 1, 0).getDate();
    var prevLast = new Date(y, m, 0).getDate();
    for (var i = first - 1; i >= 0; i--) {
      var el = document.createElement('div');
      el.className = 'cal-day other';
      el.textContent = prevLast - i;
      g.appendChild(el);
    }
    for (var d2 = 1; d2 <= last; d2++) {
      var el = document.createElement('div');
      var isT = (y === hoy.getFullYear() && m === hoy.getMonth() && d2 === hoy.getDate());
      el.className = 'cal-day' + (isT ? ' today' : '');
      el.textContent = d2;
      g.appendChild(el);
    }
    var total = first + last;
    var rem = total % 7 === 0 ? 0 : 7 - (total % 7);
    for (var n = 1; n <= rem; n++) {
      var el = document.createElement('div');
      el.className = 'cal-day other';
      el.textContent = n;
      g.appendChild(el);
    }
  }
  render();
  document.getElementById('calPrev').addEventListener('click', function() {
    cur.setMonth(cur.getMonth() - 1);
    render();
  });
  document.getElementById('calNext').addEventListener('click', function() {
    cur.setMonth(cur.getMonth() + 1);
    render();
  });
})();

/* ══ CHART ACTIVIDAD ══ */
(function() {
  var labels = [], data = [], hoy2 = new Date();
  for (var i = 13; i >= 0; i--) {
    var d = new Date(hoy2);
    d.setDate(hoy2.getDate() - i);
    labels.push(d.getDate().toString().padStart(2, '0'));
    data.push(Math.floor(Math.random() * 7) + 1);
  }
  data[data.length - 1] = parseInt('${totalHoy}') || data[data.length - 1];
  new Chart(document.getElementById('actividadChart'), {
    type: 'line',
    data: {
      labels: labels,
      datasets: [{
        data: data,
        fill: true,
        borderColor: '#5a8f7b',
        borderWidth: 2.5,
        tension: 0.45,
        pointRadius: 4,
        pointBackgroundColor: '#5a8f7b',
        pointBorderColor: '#fff',
        pointBorderWidth: 2,
        pointHoverRadius: 6,
        backgroundColor: function(ctx) {
          var g = ctx.chart.ctx.createLinearGradient(0, 0, 0, 180);
          g.addColorStop(0, 'rgba(90,143,123,0.18)');
          g.addColorStop(1, 'rgba(90,143,123,0)');
          return g;
        }
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      animation: { duration: 1000, easing: 'easeOutQuart' },
      plugins: {
        legend: { display: false },
        tooltip: {
          backgroundColor: 'rgba(45,52,54,0.9)',
          padding: 12,
          cornerRadius: 10,
          titleFont: { size: 12, family: 'Plus Jakarta Sans' },
          bodyFont: { size: 13, family: 'Plus Jakarta Sans', weight: '600' },
          callbacks: { label: function(ctx) { return 'Citas: ' + ctx.raw; } }
        }
      },
      scales: {
        x: {
          grid: { display: false },
          ticks: { font: { size: 10, family: 'Plus Jakarta Sans' }, color: '#b2bec3' }
        },
        y: { display: false, beginAtZero: true }
      }
    }
  });
})();

/* ══ DONUT CHART ══ */
(function() {
  var total = parseInt('${totalHoy}') || 0;
  var pend = parseInt('${programadasCount}') || 0;
  var rest = Math.max(total - pend, 0);
  new Chart(document.getElementById('donutChart'), {
    type: 'doughnut',
    data: {
      datasets: [{
        data: [rest > 0 ? rest : 1, pend > 0 ? pend : (total === 0 ? 1 : 0)],
        backgroundColor: ['#5a8f7b', '#c4b5e0'],
        borderWidth: 0,
        cutout: '75%',
        hoverOffset: 4
      }]
    },
    options: {
      responsive: false,
      animation: { animateRotate: true, duration: 1200 },
      plugins: {
        legend: { display: false },
        tooltip: {
          enabled: total > 0,
          backgroundColor: 'rgba(45,52,54,0.9)',
          cornerRadius: 8,
          callbacks: {
            label: function(ctx) {
              var labels = ['Consultas', 'Programadas'];
              return labels[ctx.dataIndex] + ': ' + ctx.raw;
            }
          }
        }
      }
    }
  });
})();
</script>
</body>
</html>
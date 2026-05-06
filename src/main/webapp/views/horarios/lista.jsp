<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="${not empty sessionScope.lang ? sessionScope.lang : 'es'}" />
<fmt:setBundle basename="messages" />
<!DOCTYPE html>
<html lang="${not empty sessionScope.lang ? sessionScope.lang : 'es'}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Horarios — SaludBoyacá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f0f7f4; font-family: 'Plus Jakarta Sans','Segoe UI',sans-serif; }
        .page-card { background:#fff; border-radius:14px; box-shadow:0 2px 12px rgba(74,120,100,.10); border:1px solid #dce9e4; }
        .page-header { background:linear-gradient(135deg,#4d7a68,#6a9e8a) !important; border-radius:14px 14px 0 0; }
        .table th { font-size:.71rem; text-transform:uppercase; letter-spacing:.06em; color:#4a6258; background:#e8f2ee; font-weight:700; }
        .table td { color:#1a2e26; font-size:.85rem; vertical-align:middle; }
        .table-hover tbody tr:hover td { background:rgba(232,242,238,.5); }
        .dia-badge { font-size:.73rem; padding:.25em .65em; border-radius:20px; font-weight:700; background:#e8f2ee; color:#4d7a68; }
        .time-range { font-size:.88rem; font-weight:600; color:#4d7a68; }
        .empty-state { text-align:center; padding:3rem; color:#aaa; }
        .empty-state i { font-size:2.8rem; opacity:.3; }
        .btn-accion { border-radius:8px; font-size:.8rem; padding:.3em .7em; }
        .medico-name { font-weight:600; color:#1a2e26; font-size:.88rem; }
        .filter-bar { background:#e8f2ee; border-radius:12px; padding:1rem; border:1px solid #dce9e4; }
        .week-chip { min-width:60px; text-align:center; border-radius:10px; padding:.4em .6em; font-size:.7rem; font-weight:700; }
    </style>
</head>
<body>
<%@ include file="/views/templates/header.jsp" %>
<c:set var="activePage" value="horarios" scope="request" />
<%@ include file="/views/templates/sidebar.jsp" %>
<div class="sb-main">

    <div class="page-card p-0 overflow-hidden">

        <!-- Encabezado -->
        <div class="page-header p-3 text-white d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-0 fw-bold">
                    <i class="fas fa-clock me-2"></i>
                    <c:choose>
                        <c:when test="${sessionScope.usuarioRol == 'MEDICO'}"><fmt:message key="horario.my.title"/></c:when>
                        <c:otherwise><fmt:message key="horario.manage"/></c:otherwise>
                    </c:choose>
                </h5>
                <small class="opacity-75">
                    <c:choose>
                        <c:when test="${sessionScope.usuarioRol == 'MEDICO'}"><fmt:message key="horario.my.subtitle"/></c:when>
                        <c:otherwise><fmt:message key="horario.manage.subtitle"/></c:otherwise>
                    </c:choose>
                </small>
            </div>
            <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA' || sessionScope.usuarioRol == 'ADMINISTRADOR'}">
                <a href="${pageContext.request.contextPath}/horarios?accion=nuevo"
                   class="btn btn-light btn-sm rounded-pill fw-semibold px-3">
                    <i class="fas fa-plus me-1"></i> Nuevo Horario
                </a>
            </c:if>
        </div>

        <div class="p-3">

            <!-- Filtro por médico (solo RECEPCIONISTA) -->
            <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA' || sessionScope.usuarioRol == 'ADMINISTRADOR'}">
                <div class="filter-bar mb-3">
                    <form method="get" action="${pageContext.request.contextPath}/horarios"
                          class="d-flex gap-2 align-items-end flex-wrap">
                        <input type="hidden" name="accion" value="listar">
                        <div class="flex-grow-1">
                            <label class="form-label mb-1" style="font-size:.8rem;font-weight:600;color:#4a5568;">
                                <i class="fas fa-user-md me-1 text-muted"></i><fmt:message key="horario.filter.doctor"/>
                            </label>
                            <select name="idUsuario" class="form-select form-select-sm">
                                <option value=""><fmt:message key="horario.all.doctors"/></option>
                                <c:forEach var="med" items="${medicos}">
                                    <option value="${med.idUsuario}"
                                        ${medicoFiltrado == med.idUsuario ? 'selected' : ''}>
                                        ${med.nombres} ${med.apellidos}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-success btn-sm rounded-pill px-3">
                            <i class="fas fa-filter me-1"></i><fmt:message key="horario.filter"/>
                        </button>
                        <a href="${pageContext.request.contextPath}/horarios?accion=listar"
                           class="btn btn-outline-secondary btn-sm rounded-pill">
                            <i class="fas fa-times me-1"></i>Limpiar
                        </a>
                    </form>
                </div>
            </c:if>

            <!-- Tabla -->
            <c:choose>
                <c:when test="${empty horarios}">
                    <div class="empty-state">
                        <i class="fas fa-calendar-times d-block mb-2"></i>
                        <p class="mb-0">
                            <c:choose>
                                <c:when test="${sessionScope.usuarioRol == 'MEDICO'}"><fmt:message key="horario.empty.medico"/></c:when>
                                <c:otherwise><fmt:message key="horario.empty"/></c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-3"><fmt:message key="horario.dia"/></th>
                                    <th><fmt:message key="horario.inicio"/></th>
                                    <th><fmt:message key="horario.fin"/></th>
                                    <th><fmt:message key="horario.max"/></th>
                                    <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA' || sessionScope.usuarioRol == 'ADMINISTRADOR'}">
                                        <th><fmt:message key="horario.medico"/></th>
                                        <th class="th-actions">Acciones</th>
                                    </c:if>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="h" items="${horarios}">
                                    <tr>
                                        <td class="ps-3">
                                            <span class="dia-badge">
                                                <c:choose>
                                                    <c:when test="${h.diaSemana == 1}"><fmt:message key="horario.lunes"/></c:when>
                                                    <c:when test="${h.diaSemana == 2}"><fmt:message key="horario.martes"/></c:when>
                                                    <c:when test="${h.diaSemana == 3}"><fmt:message key="horario.miercoles"/></c:when>
                                                    <c:when test="${h.diaSemana == 4}"><fmt:message key="horario.jueves"/></c:when>
                                                    <c:when test="${h.diaSemana == 5}"><fmt:message key="horario.viernes"/></c:when>
                                                    <c:when test="${h.diaSemana == 6}"><fmt:message key="horario.sabado"/></c:when>
                                                    <c:otherwise><fmt:message key="horario.domingo"/></c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td class="time-range"><i class="fas fa-play me-1" style="font-size:.65rem;"></i>${h.horaInicio}</td>
                                        <td class="time-range"><i class="fas fa-stop me-1" style="font-size:.65rem;"></i>${h.horaFin}</td>
                                        <td>
                                            <span class="badge bg-light text-dark border">
                                                <i class="fas fa-users me-1" style="font-size:.7rem;"></i>${h.maxCitas}
                                            </span>
                                        </td>
                                        <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA' || sessionScope.usuarioRol == 'ADMINISTRADOR'}">
                                            <td>
                                                <span class="medico-name">
                                                    <i class="fas fa-user-md me-1 text-muted" style="font-size:.8rem;"></i>
                                                    ${h.nombreMedico}
                                                </span>
                                            </td>
                                            <td class="td-actions">
                                                <div class="btn-fan">
                                                    <a href="${pageContext.request.contextPath}/horarios?accion=editar&id=${h.idHorario}"
                                                       class="fan-btn fan-edit" title="Editar">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/horarios?accion=eliminar&id=${h.idHorario}"
                                                       class="fan-btn fan-delete" title="Eliminar"
                                                       onclick="return confirm('¿Eliminar este horario?')">
                                                        <i class="fas fa-trash"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/horarios?accion=editar&id=${h.idHorario}"
                                                       class="fan-btn fan-view" title="Ver detalle">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </c:if>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Resumen visual semanal -->
                    <div class="mt-4 pt-3 border-top">
                        <p style="font-size:.72rem;font-weight:800;color:#7F8C8D;text-transform:uppercase;letter-spacing:.08em;">
                            Resumen semanal
                        </p>
                        <div class="d-flex flex-wrap gap-2">
                            <c:forEach var="dia" begin="1" end="5">
                                <c:set var="tieneHorario" value="false" />
                                <c:forEach var="h" items="${horarios}">
                                    <c:if test="${h.diaSemana == dia}"><c:set var="tieneHorario" value="true" /></c:if>
                                </c:forEach>
                                <div class="week-chip"
                                     style="background:${tieneHorario ? '#D5F5E3' : '#f8f9fa'};
                                            border:2px solid ${tieneHorario ? '#1E8449' : '#e9ecef'};
                                            color:${tieneHorario ? '#1E8449' : '#adb5bd'};">
                                    <div>
                                        <c:choose>
                                            <c:when test="${dia==1}"><fmt:message key="dia.lun"/></c:when>
                                            <c:when test="${dia==2}"><fmt:message key="dia.mar"/></c:when>
                                            <c:when test="${dia==3}"><fmt:message key="dia.mie"/></c:when>
                                            <c:when test="${dia==4}"><fmt:message key="dia.jue"/></c:when>
                                            <c:otherwise><fmt:message key="dia.vie"/></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <i class="fas ${tieneHorario ? 'fa-check-circle text-success' : 'fa-times-circle'}"
                                       style="font-size:1rem;"></i>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                </c:otherwise>
            </c:choose>
        </div>
    </div>

</div><%-- /sb-main --%>
</div><%-- /sb-layout --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<div id="toastContainer" style="position:fixed;top:70px;right:20px;z-index:9999;display:flex;flex-direction:column;gap:8px;max-width:320px;"></div>
<style>
.sb-toast{background:#fff;border-radius:12px;border-left:4px solid #4d7a68;box-shadow:0 8px 24px rgba(0,0,0,.12);padding:.7rem .95rem;display:flex;align-items:flex-start;gap:.55rem;animation:toastIn .3s ease;}
.sb-toast.toast-error{border-color:#e74c3c;}.sb-toast.toast-warning{border-color:#f39c12;}.sb-toast.toast-info{border-color:#3498db;}
.sb-toast-icon{font-size:1rem;color:#4d7a68;flex-shrink:0;}.sb-toast.toast-error .sb-toast-icon{color:#e74c3c;}.sb-toast.toast-warning .sb-toast-icon{color:#f39c12;}.sb-toast.toast-info .sb-toast-icon{color:#3498db;}
.sb-toast-text{font-size:.8rem;color:#1a2e26;font-weight:500;flex:1;}.sb-toast-close{background:none;border:none;color:#7a9a8e;cursor:pointer;}
@keyframes toastIn{from{opacity:0;transform:translateX(30px)}to{opacity:1;transform:none}}
</style>
<script>
function showToast(msg,type){
  type=type||'success';
  var icons={success:'fa-check-circle',error:'fa-times-circle',warning:'fa-exclamation-triangle',info:'fa-info-circle'};
  var box=document.getElementById('toastContainer');
  var t=document.createElement('div');
  t.className='sb-toast'+(type!=='success'?' toast-'+type:'');
  t.innerHTML='<i class="fas '+icons[type]+' sb-toast-icon"></i><span class="sb-toast-text">'+msg+'</span><button class="sb-toast-close" onclick="this.parentElement.remove()">&#xd7;</button>';
  box.appendChild(t);
  setTimeout(function(){if(t.parentElement){t.style.cssText+='opacity:0;transform:translateX(30px);transition:.3s;';setTimeout(function(){t.remove();},300);}},4500);
}
document.addEventListener('DOMContentLoaded',function(){
  var fd=document.getElementById('flashData');
  if(fd){ showToast(fd.getAttribute('data-msg'),fd.getAttribute('data-type')); }
});
</script>

</body>
</html>

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
    <title>${msg["horario.title"]} — SaludBoyacá</title>
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

                    <%-- CARDS DE HORARIOS --%>
                    <style>
                        .horario-cards { display: grid; grid-template-columns: repeat(auto-fill,minmax(260px,1fr)); gap: 1rem; }
                        .h-card {
                            border-radius: 16px; overflow: hidden;
                            box-shadow: 0 4px 18px rgba(0,0,0,.08);
                            transition: transform .22s, box-shadow .22s;
                            border: none;
                        }
                        .h-card:hover { transform: translateY(-4px); box-shadow: 0 10px 30px rgba(0,0,0,.13); }
                        .h-card-header {
                            padding: 1rem 1.1rem .75rem;
                            display: flex; justify-content: space-between; align-items: center;
                        }
                        .h-card-dia {
                            font-size: .78rem; font-weight: 800; letter-spacing: .06em;
                            text-transform: uppercase; color: #fff; opacity: .85;
                        }
                        .h-card-icon { font-size: 1.6rem; opacity: .25; }
                        .h-card-body { background: #fff; padding: .9rem 1.1rem 1rem; }
                        .h-time-row { display: flex; align-items: center; gap: .5rem; margin-bottom: .5rem; }
                        .h-time-badge {
                            background: #f0f7f4; border: 1px solid #dce9e4;
                            border-radius: 8px; padding: .3rem .7rem;
                            font-size: .88rem; font-weight: 700; color: #2d5a47;
                            display: flex; align-items: center; gap: .35rem;
                        }
                        .h-time-sep { color: #aab8b3; font-size: .8rem; font-weight: 600; }
                        .h-max-badge {
                            display: inline-flex; align-items: center; gap: .3rem;
                            background: #e8f2ee; border-radius: 20px;
                            padding: .22rem .7rem; font-size: .78rem; font-weight: 700; color: #4d7a68;
                            margin-top: .3rem;
                        }
                        .h-medico {
                            display: flex; align-items: center; gap: .4rem;
                            font-size: .82rem; font-weight: 600; color: #4a6258;
                            margin-top: .6rem; padding-top: .6rem; border-top: 1px solid #e8f2ee;
                        }
                        .h-actions { display: flex; gap: .4rem; margin-top: .75rem; }
                        .h-btn {
                            flex: 1; border: none; border-radius: 9px; padding: .38rem .5rem;
                            font-size: .78rem; font-weight: 600; cursor: pointer;
                            transition: all .18s; text-decoration: none; text-align: center;
                            display: inline-flex; align-items: center; justify-content: center; gap: .3rem;
                        }
                        .h-btn-edit { background: #e8f2ee; color: #2d5a47; }
                        .h-btn-edit:hover { background: #4d7a68; color: #fff; }
                        .h-btn-del { background: #fef0f0; color: #9a2020; }
                        .h-btn-del:hover { background: #e74c3c; color: #fff; }

                        /* colores por día */
                        .dia-0 { background: linear-gradient(135deg,#6c5ce7,#a29bfe); }
                        .dia-1 { background: linear-gradient(135deg,#00b894,#00cec9); }
                        .dia-2 { background: linear-gradient(135deg,#0984e3,#74b9ff); }
                        .dia-3 { background: linear-gradient(135deg,#e17055,#fab1a0); }
                        .dia-4 { background: linear-gradient(135deg,#fdcb6e,#f9ca24); }
                        .dia-5 { background: linear-gradient(135deg,#6ab04c,#badc58); }
                        .dia-6 { background: linear-gradient(135deg,#fd79a8,#e84393); }
                    </style>

                    <div class="horario-cards">
                        <c:forEach var="h" items="${horarios}">
                            <div class="h-card">
                                <%-- Header con color según día --%>
                                <div class="h-card-header dia-${h.diaSemana % 7}">
                                    <div>
                                        <div class="h-card-dia">
                                            <c:choose>
                                                <c:when test="${h.diaSemana == 1}"><fmt:message key="horario.lunes"/></c:when>
                                                <c:when test="${h.diaSemana == 2}"><fmt:message key="horario.martes"/></c:when>
                                                <c:when test="${h.diaSemana == 3}"><fmt:message key="horario.miercoles"/></c:when>
                                                <c:when test="${h.diaSemana == 4}"><fmt:message key="horario.jueves"/></c:when>
                                                <c:when test="${h.diaSemana == 5}"><fmt:message key="horario.viernes"/></c:when>
                                                <c:when test="${h.diaSemana == 6}"><fmt:message key="horario.sabado"/></c:when>
                                                <c:otherwise><fmt:message key="horario.domingo"/></c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div style="color:#fff;font-size:1.1rem;font-weight:800;line-height:1.1;margin-top:.15rem;">
                                            ${h.horaInicio} <span style="opacity:.6;font-size:.85rem;">→</span> ${h.horaFin}
                                        </div>
                                    </div>
                                    <i class="fas fa-clock h-card-icon" style="color:#fff;"></i>
                                </div>

                                <div class="h-card-body">
                                    <div class="h-time-row">
                                        <div class="h-time-badge">
                                            <i class="fas fa-play" style="font-size:.6rem;color:#00b894;"></i>
                                            ${h.horaInicio}
                                        </div>
                                        <span class="h-time-sep">→</span>
                                        <div class="h-time-badge">
                                            <i class="fas fa-stop" style="font-size:.6rem;color:#e17055;"></i>
                                            ${h.horaFin}
                                        </div>
                                    </div>

                                    <div>
                                        <span class="h-max-badge">
                                            <i class="fas fa-users"></i>
                                            <fmt:message key="horario.max"/>: ${h.maxCitas}
                                        </span>
                                    </div>

                                    <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA' || sessionScope.usuarioRol == 'ADMINISTRADOR'}">
                                        <div class="h-medico">
                                            <i class="fas fa-user-md" style="color:#6a9e8a;font-size:.9rem;"></i>
                                            ${h.nombreMedico}
                                        </div>
                                        <div class="h-actions">
                                            <a href="${pageContext.request.contextPath}/horarios?accion=editar&id=${h.idHorario}"
                                               class="h-btn h-btn-edit">
                                                <i class="fas fa-edit"></i> <fmt:message key="horario.btn.update"/>
                                            </a>
                                            <fmt:message key="horario.confirm.delete" var="confirmMsg"/>
                                            <a href="${pageContext.request.contextPath}/horarios?accion=eliminar&id=${h.idHorario}"
                                               class="h-btn h-btn-del"
                                               onclick="return confirm('${confirmMsg}')">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
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
                                                       onclick="return confirm('${msg["horario.confirm.delete"]}')">
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

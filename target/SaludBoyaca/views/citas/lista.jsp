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
                <title>${msg["cita.title"]} — SaludBoyacá</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <style>
                    body { background: #f0f7f4; font-family: 'Plus Jakarta Sans','Segoe UI',sans-serif; }

                    .page-card {
                        background: #fff;
                        border-radius: 14px;
                        box-shadow: 0 2px 12px rgba(74,120,100,.10);
                        border: 1px solid #dce9e4;
                    }

                    .table th {
                        font-size: .71rem; text-transform: uppercase;
                        letter-spacing: .06em; color: #4a6258;
                        background: #e8f2ee; font-weight: 700;
                    }
                    .table td { color: #1a2e26; font-size: .85rem; vertical-align: middle; }
                    .table-hover tbody tr:hover td { background: rgba(232,242,238,.5); }

                    .badge-estado { font-size: .7rem; padding: .25em .65em; border-radius: 20px; font-weight: 700; }
                    .estado-PROGRAMADA { background: #eef8f0; color: #2d7a4a; border: 1px solid #b3ddc0; }
                    .estado-CONFIRMADA { background: #e0f5eb; color: #1a6640; border: 1px solid #89d4a8; }
                    .estado-CANCELADA  { background: #fef0f0; color: #9a2020; border: 1px solid #f5b8b8; }
                    .estado-ATENDIDA,
                    .estado-COMPLETADA { background: #e8f2ee;  color: #4d7a68; border: 1px solid #8fbdaa; }
                    .estado-PENDIENTE  { background: #fff8e1;  color: #9a7200; border: 1px solid #f0d080; }

                    .empty-state { text-align: center; padding: 3rem; color: #aaa; }
                    .empty-state i { font-size: 2.8rem; opacity: .3; }

                    .rol-notice {
                        background: #e8f2ee; border-left: 4px solid #4d7a68;
                        border-radius: 10px; padding: .85rem 1.1rem;
                        font-size: .84rem; color: #2d5a47;
                    }
                </style>
            </head>

            <body>
                <%@ include file="/views/templates/header.jsp" %>
                    <c:set var="activePage" value="citas" scope="request" />
                    <%@ include file="/views/templates/sidebar.jsp" %>
                        <div class="sb-main">

                            <c:if test="${sessionScope.usuarioRol == 'ENFERMERO'}">
                                <div class="rol-notice mb-3">
                                    <i class="fas fa-lock me-2"></i>
                                    Modo <strong><fmt:message key="nav.readonly"/></strong> <fmt:message key="cita.readonly.notice"/>
                                </div>
                            </c:if>

                            <div class="page-card p-0 overflow-hidden">
                                <div class="d-flex align-items-center justify-content-between p-3"
                                    style="background:linear-gradient(135deg,#4d7a68,#6a9e8a);border-radius:16px 16px 0 0;">
                                    <div class="text-white">
                                        <h5 class="mb-0 fw-bold">
                                            <i class="fas fa-calendar-check me-2"></i>
                                            <c:choose>
                                                <c:when test="${sessionScope.usuarioRol == 'MEDICO'}"><fmt:message key="cita.my.title"/></c:when>
                                                <c:otherwise><fmt:message key="cita.title"/></c:otherwise>
                                            </c:choose>
                                        </h5>
                                        <small class="opacity-75">
                                            <c:choose>
                                                <c:when test="${sessionScope.usuarioRol == 'MEDICO'}"><fmt:message key="cita.agenda"/></c:when>
                                                <c:when test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}"><fmt:message key="cita.manage"/></c:when>
                                                <c:otherwise><fmt:message key="cita.readonly.subtitle"/></c:otherwise>
                                            </c:choose>
                                        </small>
                                    </div>

                                </div>

                                <div class="p-3">
                                    <c:choose>
                                        <c:when test="${empty citas}">
                                            <div class="empty-state">
                                                <i class="fas fa-calendar-times d-block mb-2"></i>
                                                <p class="mb-0"><fmt:message key="cita.empty"/></p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive">
                                                <table class="table table-hover align-middle mb-0">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th class="ps-3">NumCita</th>
                                                            <th><fmt:message key="cita.fecha"/></th>
                                                            <th><fmt:message key="cita.hora"/></th>
                                                            <th><fmt:message key="cita.motivo"/></th>
                                                            <th><fmt:message key="cita.estado"/></th>
                                                            <th class="th-actions">Acciones</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="cita" items="${citas}">
                                                            <tr>
                                                                <td class="ps-3 text-muted fw-semibold">#${cita.idCita}</td>
                                                                <td class="fw-bold" style="color:#4d7a68;">
                                                                    <fmt:formatDate value="${cita.fechaCita}"
                                                                        pattern="dd/MM/yyyy" />
                                                                </td>
                                                                <td>${cita.horaCita}</td>
                                                                <td class="text-muted"
                                                                    style="max-width:160px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                                                                    ${cita.motivo}
                                                                </td>
                                                                <td><span
                                                                        class="badge-estado estado-${cita.estado}">${cita.estado}</span>
                                                                </td>
                                                                <td class="td-actions">
                                                                    <c:choose>
                                                                        <c:when test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}">
                                                                            <div class="btn-fan">
                                                                                <a href="${pageContext.request.contextPath}/citas?accion=editar&id=${cita.idCita}"
                                                                                   class="fan-btn fan-edit" title="Editar cita">
                                                                                    <i class="fas fa-edit"></i>
                                                                                </a>
                                                                                <a href="accion=eliminar&id=${cita.idCita}"
   class="fan-btn fan-delete"
   onclick='return confirm("<fmt:message key="cita.confirm.delete"/>")'>
                                                                                <a href="${pageContext.request.contextPath}/citas?accion=detalle&id=${cita.idCita}"
                                                                                   class="fan-btn fan-view" title="Ver detalle">
                                                                                    <i class="fas fa-eye"></i>
                                                                                </a>
                                                                            </div>
                                                                        </c:when>
                                                                        <c:when test="${sessionScope.usuarioRol == 'MEDICO'}">
                                                                            <div class="btn-fan">
                                                                                <c:choose>
                                                                                    <c:when test="${cita.estado != 'CONFIRMADA' && cita.estado != 'ATENDIDA' && cita.estado != 'CANCELADA'}">
                                                                                        <button type="button" class="fan-btn fan-edit" title="Confirmar"
                                                                                            onclick="submitEstado('${cita.idCita}','CONFIRMADA')">
                                                                                            <i class="fas fa-calendar-check"></i>
                                                                                        </button>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span class="fan-btn fan-edit" style="opacity:.3;cursor:default;pointer-events:none;">
                                                                                            <i class="fas fa-calendar-check"></i>
                                                                                        </span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                                <c:choose>
                                                                                    <c:when test="${cita.estado != 'ATENDIDA' && cita.estado != 'CANCELADA'}">
                                                                                        <button type="button" class="fan-btn fan-delete" title="Marcar atendida"
                                                                                            onclick="submitEstado('${cita.idCita}','ATENDIDA')">
                                                                                            <i class="fas fa-check"></i>
                                                                                        </button>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span class="fan-btn fan-delete" style="opacity:.3;cursor:default;pointer-events:none;">
                                                                                            <i class="fas fa-check"></i>
                                                                                        </span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                                <a href="${pageContext.request.contextPath}/citas?accion=detalle&id=${cita.idCita}"
                                                                                   class="fan-btn fan-view" title="Ver detalle">
                                                                                    <i class="fas fa-eye"></i>
                                                                                </a>
                                                                            </div>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <div class="btn-fan">
                                                                                <a href="${pageContext.request.contextPath}/citas?accion=detalle&id=${cita.idCita}"
                                                                                   class="fan-btn fan-view" title="Ver detalle">
                                                                                    <i class="fas fa-eye"></i>
                                                                                </a>
                                                                            </div>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                        </div><%-- /sb-main --%>
                            </div><%-- /sb-layout --%>

<div id="toastContainer" style="position:fixed;top:70px;right:20px;z-index:9999;display:flex;flex-direction:column;gap:8px;max-width:320px;"></div>
<style>
.sb-toast{background:#fff;border-radius:12px;border-left:4px solid #4d7a68;box-shadow:0 8px 24px rgba(0,0,0,.12);padding:.7rem .95rem;display:flex;align-items:flex-start;gap:.55rem;animation:toastIn .3s ease;}
.sb-toast.toast-error{border-color:#e74c3c;}.sb-toast.toast-warning{border-color:#f39c12;}.sb-toast.toast-info{border-color:#3498db;}
.sb-toast-icon{font-size:1rem;color:#4d7a68;flex-shrink:0;}.sb-toast.toast-error .sb-toast-icon{color:#e74c3c;}.sb-toast.toast-warning .sb-toast-icon{color:#f39c12;}.sb-toast.toast-info .sb-toast-icon{color:#3498db;}
.sb-toast-text{font-size:.8rem;color:#1a2e26;font-weight:500;flex:1;}.sb-toast-close{background:none;border:none;color:#7a9a8e;cursor:pointer;font-size:.9rem;padding:0;}
@keyframes toastIn{from{opacity:0;transform:translateX(30px)}to{opacity:1;transform:none}}
</style>
<%-- Flash message: leer antes del script, limpiar en JSP --%>
<c:if test="${not empty sessionScope.flashMessage}">
  <div id="flashData"
       data-msg="${sessionScope.flashMessage}"
       data-type="${not empty sessionScope.flashType ? sessionScope.flashType : 'success'}"
       style="display:none;"></div>
</c:if>
<c:remove var="flashMessage" scope="session"/>
<c:remove var="flashType"    scope="session"/>

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
document.addEventListener('DOMContentLoaded', function(){
  var fd = document.getElementById('flashData');
  if(fd){ showToast(fd.getAttribute('data-msg'), fd.getAttribute('data-type')); }
});
</script>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <form id="frmEstado" method="post" action="${pageContext.request.contextPath}/citas" style="display:none;">
  <input type="hidden" name="accion" value="cambiarEstado">
  <input type="hidden" name="idCita" id="frmCitaId">
  <input type="hidden" name="estado" id="frmEstadoVal">
</form>
<script>
function submitEstado(id, estado){
  document.getElementById('frmCitaId').value = id;
  document.getElementById('frmEstadoVal').value = estado;
  document.getElementById('frmEstado').submit();
}
</script>
</body>

            </html>
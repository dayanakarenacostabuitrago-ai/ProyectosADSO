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
    <title>Detalle de Cita — SaludBoyacá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f0f7f4; font-family: 'Segoe UI', sans-serif; }

        .detail-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(74,120,100,0.10);
            max-width: 720px;
        }

        .detail-header {
            background: linear-gradient(135deg, #4d7a68, #6a9e8a);
            border-radius: 16px 16px 0 0;
        }

        .info-section-title {
            font-size: .7rem;
            font-weight: 800;
            color: #4d7a68;
            text-transform: uppercase;
            letter-spacing: .1em;
            padding: .8rem 0 .4rem;
            border-bottom: 2px solid #e8f2ee;
            margin-bottom: .25rem;
        }

        .info-row {
            display: flex;
            gap: 1rem;
            padding: .65rem 0;
            border-bottom: 1px solid #f0f4f8;
            align-items: flex-start;
        }
        .info-row:last-child { border-bottom: none; }

        .info-label {
            font-size: .73rem;
            font-weight: 700;
            color: #7F8C8D;
            text-transform: uppercase;
            letter-spacing: .04em;
            min-width: 140px;
            padding-top: .1rem;
            flex-shrink: 0;
        }

        .info-value {
            font-size: .92rem;
            color: #1A2530;
            font-weight: 500;
        }

        .badge-estado {
            font-size: .82rem;
            padding: .35em .9em;
            border-radius: 20px;
            font-weight: 700;
        }
        .estado-PROGRAMADA { background:#FEF9E7; color:#D4AC0D; }
        .estado-CONFIRMADA { background:#D5F5E3; color:#1E8449; }
        .estado-CANCELADA  { background:#FADBD8; color:#C0392B; }
        .estado-ATENDIDA   { background:#e8f2ee; color:#4d7a68; }

        /* ── Botones de acción mejorados ── */
        .btn-accion {
            display: inline-flex;
            align-items: center;
            gap: .4rem;
            padding: .5rem 1.1rem;
            border-radius: 10px;
            font-size: .84rem;
            font-weight: 600;
            border: none;
            cursor: pointer;
            text-decoration: none;
            transition: filter .15s, transform .1s;
        }
        .btn-accion:hover { filter: brightness(1.08); transform: translateY(-1px); }
        .btn-accion:active { transform: translateY(0); }

        .btn-volver      { background:#e8f2ee; color:#4d7a68; border:1.5px solid #8fbdaa; }
        .btn-editar      { background:linear-gradient(135deg,#E67E22,#F39C12); color:#fff; }
        .btn-confirmar   { background:linear-gradient(135deg,#4d7a68,#6a9e8a); color:#fff; }
        .btn-completar   { background:linear-gradient(135deg,#1E8449,#27AE60); color:#fff; }
        .btn-cancelar    { background:linear-gradient(135deg,#C0392B,#E74C3C); color:#fff; }

        .actions-panel {
            background: #F8FBFE;
            border-radius: 0 0 16px 16px;
            padding: 1rem 1.5rem;
            border-top: 1px solid #e8f0f7;
            display: flex;
            gap: .65rem;
            flex-wrap: wrap;
            align-items: center;
        }
    </style>
</head>
<body>
<%@ include file="/views/templates/header.jsp" %>
<c:set var="activePage" value="citas" scope="request" />
<%@ include file="/views/templates/sidebar.jsp" %>

<div class="sb-main">
    <div class="detail-card mx-auto">

        <%-- ── Cabecera ─────────────────────────── --%>
        <div class="detail-header p-4 text-white">
            <div class="d-flex align-items-center gap-3">
                <div style="width:46px;height:46px;border-radius:12px;background:rgba(255,255,255,.18);display:flex;align-items:center;justify-content:center;font-size:1.3rem;">
                    <i class="fas fa-calendar-alt"></i>
                </div>
                <div>
                    <h5 class="mb-0 fw-bold"><fmt:message key="cita.detail"/></h5>
                    <small class="opacity-75"><fmt:message key="cita.detail.subtitle"/></small>
                </div>
                <c:if test="${not empty cita}">
                    <span class="ms-auto badge-estado estado-${cita.estado}" style="font-size:.85rem;">${cita.estado}</span>
                </c:if>
            </div>
        </div>

        <%-- ── Cuerpo ─────────────────────────────── --%>
        <div class="px-4 py-3">
            <c:choose>
                <c:when test="${empty cita}">
                    <div class="text-center text-muted py-5">
                        <i class="fas fa-exclamation-circle fa-3x mb-3 opacity-25"></i>
                        <p><fmt:message key="cita.not.found"/></p>
                    </div>
                </c:when>
                <c:otherwise>

                    <%-- Sección: datos de la cita --%>
                    <p class="info-section-title"><i class="fas fa-info-circle me-1"></i><fmt:message key="cita.info.section"/></p>

                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-hashtag me-1"></i><fmt:message key="cita.id"/></span>
                        <span class="info-value text-muted">#${cita.idCita}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-calendar me-1"></i><fmt:message key="cita.fecha"/></span>
                        <span class="info-value fw-bold" style="color:#4d7a68;">
                            <fmt:formatDate value="${cita.fechaCita}" pattern="EEEE, dd 'de' MMMM 'de' yyyy" />
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-clock me-1"></i><fmt:message key="cita.hora"/></span>
                        <span class="info-value fw-bold">${cita.horaCita}</span>
                    </div>

                    <%-- Sección: personas --%>
                    <p class="info-section-title"><i class="fas fa-users me-1"></i><fmt:message key="cita.people.section"/></p>

                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-user me-1"></i><fmt:message key="cita.paciente"/></span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty paciente}">
                                    <i class="fas fa-user-circle me-1 opacity-50" style="color:#6a9e8a;"></i>
                                    ${paciente.nombres} ${paciente.apellidos}
                                    <small class="text-muted ms-1">(Doc: ${paciente.documento})</small>
                                </c:when>
                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-user-md me-1"></i><fmt:message key="cita.medico"/></span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty medico}">
                                    <i class="fas fa-stethoscope me-1 opacity-50" style="color:#6a9e8a;"></i>
                                    Dr. ${medico.nombres} ${medico.apellidos}
                                </c:when>
                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-stethoscope me-1"></i><fmt:message key="cita.specialty"/></span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty especialidad}">
                                    <span class="badge" style="background:#e8f2ee;color:#4d7a68;font-size:.82rem;padding:.3em .8em;border-radius:8px;">
                                        ${especialidad.nombre}
                                    </span>
                                </c:when>
                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <%-- Sección: notas --%>
                    <p class="info-section-title"><i class="fas fa-notes-medical me-1"></i><fmt:message key="cita.notes.section"/></p>

                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-comment-medical me-1"></i><fmt:message key="cita.motivo"/></span>
                        <span class="info-value">${not empty cita.motivo ? cita.motivo : '—'}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-comment me-1"></i><fmt:message key="cita.observaciones"/></span>
                        <span class="info-value">${not empty cita.observaciones ? cita.observaciones : '—'}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label"><i class="fas fa-calendar-plus me-1"></i><fmt:message key="cita.registered"/></span>
                        <span class="info-value text-muted">${cita.fechaRegistro}</span>
                    </div>

                </c:otherwise>
            </c:choose>
        </div>

        <%-- ── Panel de acciones ─────────────────── --%>
        <c:if test="${not empty cita}">
        <div class="actions-panel">

            <%-- Volver — siempre visible --%>
            <a href="${pageContext.request.contextPath}/citas" class="btn-accion btn-volver">
                <i class="fas fa-arrow-left"></i> <fmt:message key="cita.back.list"/>
            </a>

            <%-- Recepcionista: editar --%>
            <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}">
                <a href="${pageContext.request.contextPath}/citas?accion=editar&id=${cita.idCita}"
                   class="btn-accion btn-editar">
                    <i class="fas fa-edit"></i> <fmt:message key="cita.editar"/>
                </a>
            </c:if>

            <%-- Médico: cambiar estado --%>
            <c:if test="${sessionScope.usuarioRol == 'MEDICO'}">

                <c:if test="${cita.estado != 'CONFIRMADA' && cita.estado != 'ATENDIDA' && cita.estado != 'CANCELADA'}">
                <form method="post" action="${pageContext.request.contextPath}/citas" class="d-inline">
                    <input type="hidden" name="accion" value="cambiarEstado">
                    <input type="hidden" name="idCita" value="${cita.idCita}">
                    <input type="hidden" name="estado" value="CONFIRMADA">
                    <button type="submit" class="btn-accion btn-confirmar">
                        <i class="fas fa-calendar-check"></i> <fmt:message key="cita.confirmar"/>
                    </button>
                </form>
                </c:if>

                <c:if test="${cita.estado != 'ATENDIDA' && cita.estado != 'CANCELADA'}">
                <form method="post" action="${pageContext.request.contextPath}/citas" class="d-inline">
                    <input type="hidden" name="accion" value="cambiarEstado">
                    <input type="hidden" name="idCita" value="${cita.idCita}">
                    <input type="hidden" name="estado" value="ATENDIDA">
                    <button type="submit" class="btn-accion btn-completar">
                        <i class="fas fa-check-circle"></i> <fmt:message key="cita.atender"/>
                    </button>
                </form>
                </c:if>

                <c:if test="${cita.estado != 'CANCELADA' && cita.estado != 'ATENDIDA'}">
                <form method="post" action="${pageContext.request.contextPath}/citas" class="d-inline"
                      onsubmit="return confirm('¿Seguro que deseas cancelar esta cita?')">
                    <input type="hidden" name="accion" value="cambiarEstado">
                    <input type="hidden" name="idCita" value="${cita.idCita}">
                    <input type="hidden" name="estado" value="CANCELADA">
                    <button type="submit" class="btn-accion btn-cancelar">
                        <i class="fas fa-times-circle"></i> <fmt:message key="cita.cancel.action"/>
                    </button>
                </form>
                </c:if>

            </c:if>

        </div>
        </c:if>

    </div><%-- /detail-card --%>
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
<%-- Flash message via hidden div --%>



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

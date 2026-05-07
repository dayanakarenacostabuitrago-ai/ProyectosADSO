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
                <title>${msg["paciente.title"]} — SaludBoyacá</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <style>
                    body { background: #f0f7f4; font-family: 'Plus Jakarta Sans','Segoe UI',sans-serif; }
                    .page-card {
                        background: #fff; border-radius: 14px;
                        box-shadow: 0 2px 12px rgba(74,120,100,.10); border: 1px solid #dce9e4;
                    }
                    .table th {
                        font-size: .71rem; text-transform: uppercase; letter-spacing: .06em;
                        color: #4a6258; background: #e8f2ee; font-weight: 700;
                    }
                    .table td { color: #1a2e26; font-size: .85rem; vertical-align: middle; }
                    .table-hover tbody tr:hover td { background: rgba(232,242,238,.5); }
                    .empty-state { text-align: center; padding: 3rem; color: #aaa; }
                    .empty-state i { font-size: 2.8rem; opacity: .3; }
                    .search-box { max-width: 300px; }
                    .avatar-cell {
                        width: 36px; height: 36px; border-radius: 50%;
                        background: #e8f2ee; display: flex; align-items: center;
                        justify-content: center; font-size: .8rem; font-weight: 700;
                        color: #4d7a68; flex-shrink: 0;
                    }
                    .rol-notice {
                        background: #e8f2ee; border-left: 4px solid #4d7a68;
                        border-radius: 10px; padding: .85rem 1.1rem;
                        font-size: .84rem; color: #2d5a47;
                    }
                </style>
            </head>

            <body>
                <%@ include file="/views/templates/header.jsp" %>
                    <c:set var="activePage" value="pacientes" scope="request" />
                    <%@ include file="/views/templates/sidebar.jsp" %>
                        <div class="sb-main">

                            <!-- Aviso solo lectura para ENFERMERO -->
                            <c:if test="${sessionScope.usuarioRol == 'ENFERMERO'}">
                                <div class="rol-notice mb-3">
                                    <i class="fas fa-lock me-2"></i>
                                    Modo <strong><fmt:message key="nav.readonly"/></strong> <fmt:message key="paciente.readonly.notice"/>
                                </div>
                            </c:if>

                            <div class="page-card p-0 overflow-hidden">
                                <div class="d-flex align-items-center justify-content-between p-3"
                                    style="background:linear-gradient(135deg,#1E8449,#117A65);border-radius:16px 16px 0 0;">
                                    <div class="text-white">
                                        <h5 class="mb-0 fw-bold"><i class="fas fa-users me-2"></i><fmt:message key="paciente.title"/></h5>
                                        <small class="opacity-75">
                                            <c:choose>
                                                <c:when test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}"><fmt:message key="paciente.manage"/></c:when>
                                                <c:when test="${sessionScope.usuarioRol == 'MEDICO'}"><fmt:message key="paciente.my.title"/></c:when>
                                                <c:otherwise><fmt:message key="paciente.readonly"/></c:otherwise>
                                            </c:choose>
                                        </small>
                                    </div>

                                </div>

                                <div class="p-3">
                                    <!-- Buscador cliente -->
                                    <div class="mb-3">
                                        <input type="text" id="buscador" class="form-control search-box"
                                            placeholder="<fmt:message key='paciente.search'/>" onkeyup="filtrarTabla()">
                                    </div>

                                    <c:choose>
                                        <c:when test="${empty pacientes}">
                                            <div class="empty-state">
                                                <i class="fas fa-user-slash d-block mb-2"></i>
                                                <p class="mb-0"><fmt:message key="paciente.empty"/></p>

                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive">
                                                <table class="table table-hover align-middle mb-0" id="tablaPacientes">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th class="ps-3"><fmt:message key="paciente.nombre"/></th>
                                                            <th><fmt:message key="paciente.documento"/></th>
                                                            <th><fmt:message key="paciente.telefono"/></th>
                                                            <th><fmt:message key="paciente.eps"/></th>
                                                            <th><fmt:message key="paciente.correo"/></th>
                                                            <th class="th-actions">Acciones</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="p" items="${pacientes}">
                                                            <tr>
                                                                <td class="ps-3">
                                                                    <div class="d-flex align-items-center gap-2">
                                                                        <div class="avatar-cell">
                                                                            ${p.nombres.substring(0,1)}${p.apellidos.substring(0,1)}
                                                                        </div>
                                                                        <div>
                                                                            <div class="fw-bold text-dark"
                                                                                style="font-size:.9rem;">${p.nombres}
                                                                                ${p.apellidos}</div>
                                                                            <div class="text-muted"
                                                                                style="font-size:.75rem;">
                                                                                <fmt:formatDate
                                                                                    value="${p.fechaNacimiento}"
                                                                                    pattern="dd/MM/yyyy" />
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td class="text-muted">${p.documento}</td>
                                                                <td>${not empty p.telefono ? p.telefono : '—'}</td>
                                                                <td>${not empty p.eps ? p.eps : '—'}</td>
                                                                <td class="text-muted" style="font-size:.83rem;">${not
                                                                    empty p.email ? p.email : '—'}</td>
                                                                <td class="td-actions">
                                                                    <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}">
                                                                        <div class="btn-fan">
                                                                            <a href="${pageContext.request.contextPath}/pacientes?accion=editar&id=${p.idPaciente}"
                                                                               class="fan-btn fan-edit" title="<fmt:message key='btn.edit'/>">
                                                                                <i class="fas fa-edit"></i>
                                                                            </a>
                                                                            <a href="${pageContext.request.contextPath}/pacientes?accion=eliminar&id=${p.idPaciente}"
                                                                               class="fan-btn fan-delete" title="<fmt:message key='btn.delete'/>" onclick="return confirm('\u00bfEliminar paciente ${p.nombres} ${p.apellidos}?')">
                                                                                <i class="fas fa-trash"></i>
                                                                            </a>
                                                                            <a href="${pageContext.request.contextPath}/pacientes?accion=editar&id=${p.idPaciente}"
                                                                               class="fan-btn fan-view" title="Ver detalle">
                                                                                <i class="fas fa-eye"></i>
                                                                            </a>
                                                                        </div>
                                                                    </c:if>
                                                                    <c:if test="${sessionScope.usuarioRol == 'MEDICO'}">
                                                                        <span class="badge" style="background:#e8f2ee;color:#4d7a68;font-size:.75rem;">
                                                                            ID: ${p.idPaciente}
                                                                        </span>
                                                                    </c:if>
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

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
                                <script>
                                    function filtrarTabla() {
                                        const filtro = document.getElementById('buscador').value.toLowerCase();
                                        const filas = document.querySelectorAll('#tablaPacientes tbody tr');
                                        filas.forEach(fila => {
                                            const texto = fila.textContent.toLowerCase();
                                            fila.style.display = texto.includes(filtro) ? '' : 'none';
                                        });
                                    }
                                </script>

<div id="toastContainer" style="position:fixed;top:70px;right:20px;z-index:9999;display:flex;flex-direction:column;gap:8px;max-width:320px;"></div>
<style>.sb-toast{background:#fff;border-radius:12px;border-left:4px solid #4d7a68;box-shadow:0 8px 24px rgba(0,0,0,.12);padding:.7rem .95rem;display:flex;align-items:flex-start;gap:.55rem;animation:toastIn .3s ease;}.sb-toast.toast-error{border-color:#e74c3c;}.sb-toast.toast-warning{border-color:#f39c12;}.sb-toast.toast-info{border-color:#3498db;}.sb-toast-icon{font-size:1rem;color:#4d7a68;flex-shrink:0;}.sb-toast.toast-error .sb-toast-icon{color:#e74c3c;}.sb-toast.toast-warning .sb-toast-icon{color:#f39c12;}.sb-toast.toast-info .sb-toast-icon{color:#3498db;}.sb-toast-text{font-size:.8rem;color:#1a2e26;font-weight:500;flex:1;}.sb-toast-close{background:none;border:none;color:#7a9a8e;cursor:pointer;font-size:.9rem;padding:0;}@keyframes toastIn{from{opacity:0;transform:translateX(30px)}to{opacity:1;transform:none}}</style>
<script>
<%-- Flash message via hidden div para evitar error JSP dentro de script --%>



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
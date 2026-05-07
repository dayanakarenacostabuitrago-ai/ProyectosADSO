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
                <title>${not empty cita ? msg['cita.editar'] : msg['cita.new']} — SaludBoyacá</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <style>
                    body {
                        background: #f0f7f4;
                        font-family: 'Segoe UI', sans-serif;
                    }

                    .form-card {
                        background: #fff;
                        border-radius: 16px;
                        box-shadow: 0 4px 16px rgba(0, 0, 0, .08);
                        max-width: 680px;
                    }

                    .form-header {
                        background: linear-gradient(135deg, #117A65, #1E8449);
                        border-radius: 16px 16px 0 0;
                    }

                    .form-label {
                        font-size: .82rem;
                        font-weight: 600;
                        color: #4a5568;
                    }

                    .form-control,
                    .form-select {
                        border-radius: 10px;
                        border-color: #dee2e6;
                        font-size: .9rem;
                    }

                    .form-control:focus,
                    .form-select:focus {
                        border-color: #6a9e8a;
                        box-shadow: 0 0 0 .2rem rgba(46, 134, 193, .15);
                    }
                </style>
            </head>

            <body>
                <%@ include file="/views/templates/header.jsp" %>
                    <c:set var="activePage" value="citas-nueva" scope="request" />
                    <%@ include file="/views/templates/sidebar.jsp" %>
                        <div class="sb-main">

                            <div class="form-card mx-auto">
                                <div class="form-header p-3 text-white">
                                    <h5 class="mb-0 fw-bold">
                                        <i class="fas fa-calendar-plus me-2"></i>
                                        ${not empty cita ? 'Editar Cita #'.concat(cita.idCita) : ''}${empty cita ? '<fmt:message key="cita.new"/>' : ''}
                                    </h5>
                                    <small class="opacity-75"><fmt:message key="cita.all.required"/></small>
                                </div>

                                <div class="p-4">

                                    <%-- Alerta de hora ya ocupada --%>
                                    <c:if test="${not empty sessionScope.errorCita}">
                                        <div class="alert alert-warning d-flex align-items-center gap-2 mb-3" role="alert">
                                            <i class="fas fa-clock"></i>
                                            <span>${sessionScope.errorCita}</span>
                                        </div>
                                        <c:remove var="errorCita" scope="session"/>
                                    </c:if>

                                    <form method="post" action="${pageContext.request.contextPath}/citas">
                                        <input type="hidden" name="accion"
                                            value="${not empty cita ? 'actualizar' : 'insertar'}">
                                        <c:if test="${not empty cita}">
                                            <input type="hidden" name="idCita" value="${cita.idCita}">
                                        </c:if>

                                        <div class="row g-3">

                                            <!-- Especialidad -->
                                            <div class="col-md-6">
                                                <label class="form-label"><i
                                                        class="fas fa-stethoscope me-1 text-muted"></i><fmt:message key="cita.specialty"/>
                                                    <span class="text-danger">*</span></label>
                                                <select name="idEspecialidad" id="selEspecialidad" class="form-select"
                                                    required onchange="cargarMedicos(this.value)">
                                                    <option value="">— Selecciona especialidad —</option>
                                                    <c:forEach var="esp" items="${especialidades}">
                                                        <option value="${esp.idEspecialidad}" ${not empty cita &&
                                                            cita.idEspecialidad==esp.idEspecialidad ? 'selected' : '' }>
                                                            ${esp.nombre}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <!-- Médico -->
                                            <div class="col-md-6">
                                                <label class="form-label"><i
                                                        class="fas fa-user-md me-1 text-muted"></i><fmt:message key="cita.medico"/> <span class="text-danger">*</span></label>
                                                <select name="idUsuario" id="selMedico" class="form-select" required
                                                    onchange="cargarFechas(this.value)">
                                                    <c:choose>
                                                        <c:when test="${not empty medicosCita}">
                                                            <%-- Modo editar: ya tenemos los médicos de esa especialidad --%>
                                                            <option value="">${msg['cita.select.doctor']}</option>
                                                            <c:forEach var="med" items="${medicosCita}">
                                                                <option value="${med.idUsuario}"
                                                                    ${cita.idUsuario == med.idUsuario ? 'selected' : ''}>
                                                                    ${med.nombres} ${med.apellidos}
                                                                </option>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="">— Primero selecciona especialidad —</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </select>
                                            </div>

                                            <!-- Paciente -->
                                            <div class="col-md-6">
                                                <label class="form-label"><i class="fas fa-user me-1 text-muted"></i><fmt:message key="cita.paciente"/>
                                                    <span class="text-danger">*</span></label>
                                                <select name="idPaciente" class="form-select" required>
                                                    <option value="">— Selecciona paciente —</option>
                                                    <c:forEach var="pac" items="${pacientes}">
                                                        <option value="${pac.idPaciente}"
                                                            ${not empty cita && cita.idPaciente == pac.idPaciente ? 'selected' : ''}>
                                                            ${pac.nombres} ${pac.apellidos} — Doc: ${pac.documento}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <!-- Fecha -->
                                            <div class="col-md-6">
                                                <label class="form-label"><i
                                                        class="fas fa-calendar me-1 text-muted"></i><fmt:message key="cita.fecha"/> <span class="text-danger">*</span></label>
                                                <select name="fechaCita" id="selFecha" class="form-select" required
                                                    onchange="cargarHoras()">
                                                    <option value="">${msg['cita.select.doctor.first']}</option>
                                                    <c:if test="${not empty cita}">
                                                        <option value="${cita.fechaCita}" selected>${cita.fechaCita}</option>
                                                    </c:if>
                                                </select>
                                            </div>

                                            <!-- Hora -->
                                            <div class="col-md-6">
                                                <label class="form-label"><i
                                                        class="fas fa-clock me-1 text-muted"></i><fmt:message key="cita.hora"/> <span class="text-danger">*</span></label>
                                                <select name="horaCita" id="selHora" class="form-select" required>
                                                    <option value="">${msg['cita.select.doctor.and.date']}</option>
                                                    <c:if test="${not empty cita}">
                                                        <option value="${cita.horaCita}" selected>${cita.horaCita}
                                                        </option>
                                                    </c:if>
                                                </select>
                                            </div>

                                            <!-- Motivo -->
                                            <div class="col-12">
                                                <label class="form-label"><i
                                                        class="fas fa-notes-medical me-1 text-muted"></i><fmt:message key="cita.motivo"/> <span class="text-danger">*</span></label>
                                                <input type="text" name="motivo" class="form-control" required
                                                    maxlength="200" value="${not empty cita ? cita.motivo : ''}"
                                                    placeholder="Motivo de la consulta">
                                            </div>

                                            <!-- Observaciones -->
                                            <div class="col-12">
                                                <label class="form-label"><i
                                                        class="fas fa-comment me-1 text-muted"></i><fmt:message key="cita.observaciones"/></label>
                                                <textarea name="observaciones" class="form-control" rows="3"
                                                    placeholder="Observaciones adicionales (opcional)">${not empty cita ? cita.observaciones : ''}</textarea>
                                            </div>

                                        </div>

                                        <div class="d-flex gap-2 justify-content-end mt-4 pt-3 border-top">
                                            <a href="${pageContext.request.contextPath}/citas"
                                                class="btn btn-outline-secondary rounded-pill">
                                                <i class="fas fa-times me-1"></i><fmt:message key="btn.cancelar"/>
                                            </a>
                                            <button type="submit" class="btn btn-success rounded-pill px-4">
                                                <i class="fas fa-save me-1"></i>
                                                ${not empty cita ? '' : ''}<c:choose><c:when test="${not empty cita}"><fmt:message key="cita.update"/></c:when><c:otherwise><fmt:message key="cita.save"/></c:otherwise></c:choose>
                                            </button>
                                        </div>

                                    </form>
                                </div>
                            </div>

                        </div><%-- /sb-main --%>
                            </div><%-- /sb-layout --%>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
                                <script>
                                    const ctx = '${pageContext.request.contextPath}';

                                    // Días habilitados para el médico seleccionado (1=Lun...5=Vie)
                                    let diasHabilitados = [];

                                    function cargarMedicos(idEsp) {
                                        const sel = document.getElementById('selMedico');
                                        sel.innerHTML = '<option value="">Cargando...</option>';
                                        if (!idEsp) { sel.innerHTML = '<option value="">— Primero especialidad —</option>'; return; }
                                        fetch(ctx + '/citas?accion=medicosPorEspecialidad&idEspecialidad=' + idEsp)
                                            .then(r => r.json())
                                            .then(data => {
                                                sel.innerHTML = '<option value=""><fmt:message key="cita.select.doctor"/></option>';
                                                data.forEach(m => {
                                                    sel.innerHTML += '<option value="' + m.id + '">' + m.nombre + '</option>';
                                                });
                                                // Limpiar fechas y horas al cambiar especialidad
                                                document.getElementById('selFecha').innerHTML = '<option value=""><fmt:message key="cita.select.doctor.first"/></option>';
                                                document.getElementById('selHora').innerHTML = '<option value=""><fmt:message key="cita.select.doctor.and.date"/></option>';
                                                diasHabilitados = [];
                                            }).catch(() => { sel.innerHTML = '<option value="">Error al cargar</option>'; });
                                    }

                                    function cargarFechas(idMedico) {
                                        const selF = document.getElementById('selFecha');
                                        const selH = document.getElementById('selHora');
                                        selF.innerHTML = '<option value="">Cargando fechas...</option>';
                                        selH.innerHTML = '<option value=""><fmt:message key="cita.select.doctor.and.date"/></option>';
                                        diasHabilitados = [];

                                        if (!idMedico) {
                                            selF.innerHTML = '<option value=""><fmt:message key="cita.select.doctor.first"/></option>';
                                            return;
                                        }

                                        fetch(ctx + '/citas?accion=diasDisponibles&idUsuario=' + idMedico)
                                            .then(r => r.json())
                                            .then(dias => {
                                                diasHabilitados = dias; // [1,2,3,4,5]
                                                selF.innerHTML = '<option value="">— Elige una fecha —</option>';

                                                if (dias.length === 0) {
                                                    selF.innerHTML = '<option value="">No hay días disponibles</option>';
                                                    return;
                                                }

                                                // Generar fechas de hoy + 60 días que coincidan con dias[]
                                                const hoy = new Date();
                                                hoy.setHours(0,0,0,0);
                                                for (let i = 0; i <= 60; i++) {
                                                    const d = new Date(hoy);
                                                    d.setDate(hoy.getDate() + i);
                                                    // getDay(): 0=Dom,1=Lun...5=Vie,6=Sab → ajustar a 1=Lun...5=Vie
                                                    let dow = d.getDay(); // 0=Dom,1=Lun...6=Sab

// 🔥 Convertir a formato Java (1=Lun...7=Dom)
dow = (dow === 0) ? 7 : dow;

if (dow === 6 || dow === 7) continue; // excluir sábado y domingo
if (!dias.includes(dow)) continue;  // saltar días sin horario
                                                    const yyyy = d.getFullYear();
                                                    const mm   = String(d.getMonth()+1).padStart(2,'0');
                                                    const dd   = String(d.getDate()).padStart(2,'0');
                                                    const val  = yyyy+'-'+mm+'-'+dd;
                                                    const etiq = d.toLocaleDateString('es-CO', {weekday:'long', day:'numeric', month:'long'});
                                                    selF.innerHTML += '<option value="'+val+'">'+etiq+'</option>';
                                                }
                                            }).catch(() => { selF.innerHTML = '<option value="">Error al cargar fechas</option>'; });
                                    }

                                    function cargarHoras() {
                                        const idMedico = document.getElementById('selMedico').value;
                                        const fecha    = document.getElementById('selFecha').value;
                                        const sel      = document.getElementById('selHora');
                                        if (!idMedico || !fecha) { sel.innerHTML = '<option value=""><fmt:message key="cita.select.doctor.and.date"/></option>'; return; }
                                        sel.innerHTML = '<option value="">Cargando horas...</option>';
                                        fetch(ctx + '/citas?accion=horasDisponibles&idUsuario=' + idMedico + '&fecha=' + fecha)
                                            .then(r => r.json())
                                            .then(horas => {
                                                if (horas.length === 0) {
                                                    sel.innerHTML = '<option value="">No hay horas disponibles</option>';
                                                } else {
                                                    sel.innerHTML = '<option value="">— Elige hora —</option>';
                                                    horas.forEach(h => { sel.innerHTML += '<option value="' + h + '">' + h + '</option>'; });
                                                }
                                            }).catch(() => { sel.innerHTML = '<option value="">Error al cargar</option>'; });
                                    }

                                    // Al cambiar médico: cargar fechas disponibles
                                    document.getElementById('selMedico').addEventListener('change', function() {
                                        cargarFechas(this.value);
                                    });
                                </script>
            
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
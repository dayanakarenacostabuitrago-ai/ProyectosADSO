<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="${not empty sessionScope.lang ? sessionScope.lang : 'es'}" />
<fmt:setBundle basename="messages" />
<%
    co.sena.cimm.adso.saludboyaca.dto.Horario horario =
        (co.sena.cimm.adso.saludboyaca.dto.Horario) request.getAttribute("horario");
    boolean editing = (horario != null);
%>
<!DOCTYPE html>
<html lang="${not empty sessionScope.lang ? sessionScope.lang : 'es'}">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title><%= editing ? "${msg[\"horario.manage\"]}" : "${msg[\"horario.title\"]}" %> — SaludBoyacá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f0f7f4; font-family: 'Plus Jakarta Sans','Segoe UI',sans-serif; }
        .form-card {
            background: #fff; border-radius: 14px;
            box-shadow: 0 2px 12px rgba(74,120,100,.10);
            border: 1px solid #dce9e4; max-width: 680px;
        }
        .form-header {
            background: linear-gradient(135deg, #4d7a68, #6a9e8a);
            border-radius: 14px 14px 0 0;
        }
        .section-label {
            font-size: .71rem; font-weight: 800; color: #7a9a8e;
            text-transform: uppercase; letter-spacing: .08em;
            margin: 1.4rem 0 .6rem; padding-bottom: .4rem;
            border-bottom: 2px solid #e8f2ee;
        }
        .form-label { font-size: .82rem; font-weight: 600; color: #4a6258; }
        .form-control, .form-select {
            border-radius: 10px; border-color: #dce9e4;
            font-size: .88rem; color: #1a2e26; background: #fafcfa;
        }
        .form-control:focus, .form-select:focus {
            border-color: #6a9e8a;
            box-shadow: 0 0 0 .2rem rgba(106,158,138,.18);
            background: #fff;
        }
        .btn-volver {
            padding: .38rem .85rem; font-size: .82rem;
            background: rgba(255,255,255,.15); border: 1px solid rgba(255,255,255,.3);
            color: #fff; border-radius: 8px; cursor: pointer;
            text-decoration: none; display: inline-flex; align-items: center; gap: .4rem;
            transition: background .15s;
        }
        .btn-volver:hover { background: rgba(255,255,255,.25); color: #fff; }
        .btn-guardar {
            padding: .5rem 1.5rem; font-size: .88rem; font-weight: 600;
            background: linear-gradient(135deg, #4d7a68, #6a9e8a);
            border: none; color: #fff; border-radius: 10px;
            box-shadow: 0 4px 12px rgba(74,120,100,.25);
            transition: all .25s; cursor: pointer;
        }
        .btn-guardar:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(74,120,100,.35); }
        .btn-cancelar {
            padding: .5rem 1.2rem; font-size: .88rem; font-weight: 600;
            background: #fff; border: 1px solid #dce9e4; color: #4a6258;
            border-radius: 10px; text-decoration: none;
            display: inline-flex; align-items: center; gap: .35rem; transition: all .2s;
        }
        .btn-cancelar:hover { background: #e8f2ee; border-color: #6a9e8a; color: #4d7a68; }
    </style>
</head>
<body>

<%@ include file="/views/templates/header.jsp" %>
<c:set var="activePage" value="horarios" scope="request" />
<%@ include file="/views/templates/sidebar.jsp" %>

<div class="sb-main p-3 p-md-4">

    <div class="form-card mx-auto">

        <div class="form-header p-3 text-white d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-0 fw-bold">
                    <i class="fas fa-clock me-2"></i>
                    <%= editing ? "" : "" %><fmt:message key="<%= editing ? \"horario.btn.edit\" : \"horario.btn.new\" %>"/>
                </h5>
                <small class="opacity-75">
                    <%= editing ? "${msg[\"horario.form.edit.subtitle\"]}" : "${msg[\"horario.form.new.subtitle\"]}" %>
                </small>
            </div>
            <a href="${pageContext.request.contextPath}/horarios?accion=listar" class="btn-volver">
                <i class="fas fa-arrow-left"></i> <fmt:message key="horario.btn.back"/>
            </a>
        </div>

        <div class="p-4">
            <form method="post" action="${pageContext.request.contextPath}/horarios">
                <input type="hidden" name="accion" value="<%= editing ? "actualizar" : "insertar" %>"/>
                <% if (editing) { %>
                <input type="hidden" name="idHorario" value="${horario.idHorario}"/>
                <% } %>

                <p class="section-label"><i class="fas fa-user-md me-1"></i><fmt:message key="horario.assigned.doctor"/></p>

                <div class="mb-3">
                    <label class="form-label"><fmt:message key="horario.medico"/> <span class="text-danger">*</span></label>
                    <select name="idUsuario" class="form-select" required>
                        <option value=""><fmt:message key="horario.select.doctor"/></option>
                        <c:forEach var="med" items="${medicos}">
                            <option value="${med.idUsuario}"
                                <c:if test="${editing && horario.idUsuario == med.idUsuario}">selected</c:if>>
                                ${med.nombres} ${med.apellidos}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <p class="section-label"><i class="fas fa-calendar-alt me-1"></i><fmt:message key="horario.availability"/></p>

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label"><fmt:message key="horario.dia"/> <span class="text-danger">*</span></label>
                        <select name="diaSemana" class="form-select" required>
                            <option value=""><fmt:message key="horario.select.day"/></option>
                            <option value="0" <%= (editing && horario.getDiaSemana()==0)?"selected":"" %>>Domingo</option>
                            <option value="1" <%= (editing && horario.getDiaSemana()==1)?"selected":"" %>>Lunes</option>
                            <option value="2" <%= (editing && horario.getDiaSemana()==2)?"selected":"" %>>Martes</option>
                            <option value="3" <%= (editing && horario.getDiaSemana()==3)?"selected":"" %>>${msg["horario.miercoles"]}</option>
                            <option value="4" <%= (editing && horario.getDiaSemana()==4)?"selected":"" %>>Jueves</option>
                            <option value="5" <%= (editing && horario.getDiaSemana()==5)?"selected":"" %>>Viernes</option>
                            <option value="6" <%= (editing && horario.getDiaSemana()==6)?"selected":"" %>>${msg["horario.sabado"]}</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label"><fmt:message key="horario.max.appointments"/> <span class="text-danger">*</span></label>
                        <input type="number" name="maxCitas" class="form-control"
                               min="1" max="50"
                               value="<%= editing ? horario.getMaxCitas() : 10 %>"
                               required placeholder="Ej: 10"/>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label"><fmt:message key="horario.start.time"/> <span class="text-danger">*</span></label>
                        <input type="time" name="horaInicio" class="form-control" required
                               value="<%= (editing && horario.getHoraInicio()!=null) ? horario.getHoraInicio().toString() : "" %>"/>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label"><fmt:message key="horario.end.time"/> <span class="text-danger">*</span></label>
                        <input type="time" name="horaFin" class="form-control" required
                               value="<%= (editing && horario.getHoraFin()!=null) ? horario.getHoraFin().toString() : "" %>"/>
                    </div>
                </div>

                <div class="d-flex gap-2 justify-content-end mt-4 pt-3 border-top">
                    <a href="${pageContext.request.contextPath}/horarios?accion=listar" class="btn-cancelar">
                        <i class="fas fa-times"></i> <fmt:message key="horario.btn.cancel"/>
                    </a>
                    <button type="submit" class="btn-guardar">
                        <i class="fas fa-save me-1"></i>
                        <%= editing ? "${msg[\"horario.btn.update\"]}" : "${msg[\"horario.btn.save\"]}" %>
                    </button>
                </div>
            </form>
        </div>
    </div>

</div><%-- /sb-main --%>
</div><%-- /sb-layout --%>

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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

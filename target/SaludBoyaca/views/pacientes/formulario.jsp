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
                <title>${not empty paciente ? msg["paciente.edit"] : msg["paciente.new"]} — SaludBoyacá</title>
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
                        max-width: 720px;
                    }

                    .form-header {
                        background: linear-gradient(135deg, #1E8449, #117A65);
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
                        border-color: #1E8449;
                        box-shadow: 0 0 0 .2rem rgba(30, 132, 73, .15);
                    }

                    .section-title {
                        font-size: .72rem;
                        font-weight: 800;
                        color: #7F8C8D;
                        text-transform: uppercase;
                        letter-spacing: .08em;
                        margin: 1.2rem 0 .5rem;
                        padding-bottom: .4rem;
                        border-bottom: 2px solid #e8f2ee;
                    }
                </style>
            </head>

            <body>
                <%@ include file="/views/templates/header.jsp" %>
                    <c:set var="activePage" value="pacientes-nuevo" scope="request" />
                    <%@ include file="/views/templates/sidebar.jsp" %>
                        <div class="sb-main">

                            <div class="form-card mx-auto">
                                <div class="form-header p-3 text-white">
                                    <h5 class="mb-0 fw-bold">
                                        <i class="fas fa-user-plus me-2"></i>
                                        <fmt:message key="${not empty paciente ? 'paciente.edit' : 'paciente.new'}" />
                                    </h5>
                                    <small class="opacity-75">
                                        ${not empty paciente ? paciente.nombres.concat(' ').concat(paciente.apellidos) : ''}
                                    </small>
                                </div>

                                <div class="p-4">
                                    <form method="post" action="${pageContext.request.contextPath}/pacientes">
                                        <input type="hidden" name="accion"
                                            value="${not empty paciente ? 'actualizar' : 'insertar'}">
                                        <c:if test="${not empty paciente}">
                                            <input type="hidden" name="idPaciente" value="${paciente.idPaciente}">
                                        </c:if>

                                        <p class="section-title"><i class="fas fa-id-card me-1"></i><fmt:message key="paciente.personal.data"/></p>
                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <label class="form-label"><fmt:message key="paciente.nombres"/> <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" name="nombres" class="form-control" required
                                                    maxlength="100"
                                                    value="${not empty paciente ? paciente.nombres : ''}"
                                                    placeholder="${msg['paciente.placeholder.nombres']}">
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label"><fmt:message key="paciente.apellidos"/> <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" name="apellidos" class="form-control" required
                                                    maxlength="100"
                                                    value="${not empty paciente ? paciente.apellidos : ''}"
                                                    placeholder="${msg['paciente.placeholder.apellidos']}">
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label"><fmt:message key="paciente.documento"/> <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" name="documento" class="form-control" required
                                                    maxlength="20"
                                                    value="${not empty paciente ? paciente.documento : ''}"
                                                    placeholder="${msg['paciente.placeholder.documento']}">
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label"><fmt:message key="paciente.birthdate"/> <span
                                                        class="text-danger">*</span></label>
                                                <input type="date" name="fechaNacimiento" class="form-control" required
                                                    value="${not empty paciente ? paciente.fechaNacimiento : ''}">
                                            </div>
                                        </div>

                                        <p class="section-title"><i class="fas fa-phone me-1"></i><fmt:message key="paciente.contact"/></p>
                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <label class="form-label"><fmt:message key="paciente.telefono"/></label>
                                                <input type="tel" name="telefono" class="form-control" maxlength="20"
                                                    value="${not empty paciente ? paciente.telefono : ''}"
                                                    placeholder="Ej: 310 123 4567">
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label"><fmt:message key="paciente.correo"/></label>
                                                <input type="email" name="email" class="form-control" maxlength="100"
                                                    value="${not empty paciente ? paciente.email : ''}"
                                                    placeholder="Ej: usuario@correo.com">
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label"><fmt:message key="paciente.neighborhood"/></label>
                                                <input type="text" name="veredaBarrio" class="form-control"
                                                    maxlength="100"
                                                    value="${not empty paciente ? paciente.veredaBarrio : ''}"
                                                    placeholder="Ej: Barrio Centro, Vereda El Roble">
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label"><fmt:message key="paciente.eps"/></label>
                                                <input type="text" name="eps" class="form-control" maxlength="80"
                                                    value="${not empty paciente ? paciente.eps : ''}"
                                                    placeholder="Ej: Sura, Sanitas, Nueva EPS">
                                            </div>
                                        </div>

                                        <div class="d-flex gap-2 justify-content-end mt-4 pt-3 border-top">
                                            <a href="${pageContext.request.contextPath}/pacientes"
                                                class="btn btn-outline-secondary rounded-pill">
                                                <i class="fas fa-times me-1"></i><fmt:message key="btn.cancelar"/>
                                            </a>
                                            <button type="submit" class="btn rounded-pill px-4"
                                                style="background:#1E8449;color:#fff;">
                                                <i class="fas fa-save me-1"></i>
                                                <fmt:message key="${not empty paciente ? 'paciente.update' : 'paciente.register'}" />
                                            </button>
                                        </div>

                                    </form>
                                </div>
                            </div>

                        </div><%-- /sb-main --%>
                            </div><%-- /sb-layout --%>
                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            
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
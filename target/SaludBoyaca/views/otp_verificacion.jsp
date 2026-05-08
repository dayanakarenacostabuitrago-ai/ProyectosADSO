<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="${not empty sessionScope.lang ? sessionScope.lang : 'es'}"/>
<fmt:setBundle basename="messages"/>
<!DOCTYPE html>
<html lang="${not empty sessionScope.lang ? sessionScope.lang : 'es'}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><fmt:message key="otp.title"/> — SaludBoyacá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primario: #4d7a68;
            --celeste:  #6a9e8a;
            --morado:   #6C3483;
            --morado-d: #512E5F;
        }
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, var(--primario) 0%, var(--celeste) 100%);
            display: flex; align-items: center; justify-content: center;
            font-family: 'Segoe UI', sans-serif; padding: 1rem;
        }
        .otp-wrapper { width: 100%; max-width: 420px; animation: fadeUp .4s ease both; }
        @keyframes fadeUp {
            from { opacity:0; transform:translateY(20px); }
            to   { opacity:1; transform:translateY(0); }
        }
        .otp-card {
            background: #fff;
            border-radius: 18px;
            border-top: 5px solid var(--morado);
            box-shadow: 0 20px 50px rgba(0,0,0,.28);
            overflow: hidden;
        }
        .otp-header {
            background: var(--morado); color: #fff;
            text-align: center; padding: 1.75rem 1.5rem 1.5rem;
        }
        .otp-header .icon-wrap {
            width: 60px; height: 60px;
            background: rgba(255,255,255,.15);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto .75rem; font-size: 1.6rem;
        }
        .otp-header h2 { font-size: 1.1rem; font-weight: 700; margin: 0; }
        .otp-body { padding: 1.75rem 2rem 1.5rem; }

        /* Instrucción */
        .otp-hint {
            text-align: center; font-size: .88rem; color: #7F8C8D;
            margin-bottom: 1.5rem; line-height: 1.6;
        }
        .otp-hint strong { color: var(--morado); }

        /* Campo grande */
        .otp-input {
            display: block; width: 100%;
            font-size: 2.2rem; font-weight: 700;
            letter-spacing: 12px; text-align: center;
            border: 2px solid #ddd; border-radius: 12px;
            padding: .6rem 1rem; color: var(--morado);
            font-family: 'Courier New', monospace;
            transition: border-color .2s, box-shadow .2s;
        }
        .otp-input:focus {
            border-color: var(--morado);
            box-shadow: 0 0 0 .2rem rgba(108,52,131,.2);
            outline: none;
        }

        /* Contador */
        .otp-timer {
            text-align: center; font-size: .85rem; color: #7F8C8D;
            margin: .6rem 0 1.25rem;
        }
        #countdown { font-weight: 700; font-size: 1rem; }
        #countdown.urgente { color: #E74C3C; }

        /* Alerta */
        .alert-danger {
            font-size: .85rem; border-radius: 10px;
            border: none; background: #FADBD8; color: #922B21;
        }
        .alert-success {
            font-size: .85rem; border-radius: 10px;
            border: none; background: #D5F5E3; color: #1E8449;
        }

        /* Botones */
        .btn-verificar {
            width: 100%; background: var(--morado); color: #fff;
            border: none; border-radius: 10px;
            font-size: 1rem; font-weight: 700; padding: .65rem;
            margin-bottom: .75rem; transition: background .2s;
        }
        .btn-verificar:hover  { background: var(--morado-d); color:#fff; }
        .btn-verificar:disabled { background: #ccc; cursor: not-allowed; }
        .btn-reenviar {
            display: block; width: 100%; text-align: center;
            padding: .5rem; border-radius: 10px;
            border: 1.5px solid var(--morado); color: var(--morado);
            font-size: .85rem; font-weight: 600; text-decoration: none;
            transition: all .2s;
        }
        .btn-reenviar:hover { background: var(--morado); color: #fff; }
        .page-foot {
            text-align: center; margin-top: 1rem;
            font-size: .73rem; color: rgba(255,255,255,.6);
        }
    </style>
</head>
<body>
<div class="otp-wrapper">
  <div class="otp-card">

    <!-- Cabecera morada -->
    <div class="otp-header">
      <div class="icon-wrap"><i class="fas fa-shield-alt"></i></div>
      <h2><fmt:message key="otp.title"/></h2>
    </div>

    <div class="otp-body">

      <!-- Mensajes -->
      <c:if test="${not empty error}">
        <div class="alert alert-danger mb-3">
          <i class="fas fa-times-circle me-1"></i> ${error}
        </div>
      </c:if>
      <c:if test="${not empty mensaje}">
        <div class="alert alert-success mb-3">
          <i class="fas fa-check-circle me-1"></i> ${mensaje}
        </div>
      </c:if>

      <!-- Instrucción con email enmascarado -->
      <p class="otp-hint">
        <fmt:message key="otp.label"/>
        <c:if test="${not empty emailMasked}">
          <br><strong>${emailMasked}</strong>
        </c:if>
      </p>

      <!-- Formulario de verificación -->
      <form action="${pageContext.request.contextPath}/otp?accion=validar" method="post">

        <div class="mb-2">
          <input type="text"
                 id="otpInput"
                 name="otpCodigo"
                 class="otp-input"
                 maxlength="6"
                 pattern="[0-9]{6}"
                 placeholder="000000"
                 inputmode="numeric"
                 autocomplete="one-time-code"
                 required autofocus>
        </div>

        <!-- Contador regresivo 5:00 -->
        <div class="otp-timer">
          <i class="fas fa-clock me-1"></i>
          <span id="countdown">5:00</span>
        </div>

        <button type="submit" id="btnVerify" class="btn-verificar">
          <i class="fas fa-check-circle me-2"></i>
          <fmt:message key="otp.button"/>
        </button>

      </form>

      <!-- Reenviar → genera un nuevo OTP sin volver al login -->
      <a href="${pageContext.request.contextPath}/otp?accion=generar" class="btn-reenviar">
        <i class="fas fa-redo me-1"></i> <fmt:message key="otp.resend"/>
      </a>

    </div>
  </div><!-- /.otp-card -->

  <div class="page-foot"><fmt:message key="otp.footer"/></div>
</div>

<script>
(function () {
    var restante = 300; // 5 minutos en segundos
    var el  = document.getElementById('countdown');
    var btn = document.getElementById('btnVerify');

    var tick = setInterval(function () {
        restante--;
        var min = Math.floor(restante / 60);
        var seg = restante % 60;
        el.textContent = min + ':' + String(seg).padStart(2, '0');

        if (restante < 60) el.classList.add('urgente');

        if (restante <= 0) {
            clearInterval(tick);
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-clock me-2"></i><fmt:message key="otp.expired"/>';
        }
    }, 1000);

    // Solo dígitos en el campo OTP
    document.getElementById('otpInput').addEventListener('input', function () {
        this.value = this.value.replace(/\D/g, '').slice(0, 6);
    });
})();
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

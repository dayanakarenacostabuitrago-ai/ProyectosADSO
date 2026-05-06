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
    <title>Acceso — SaludBoyacá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        :root {
            --green:      #6a9e8a;
            --green-dark: #4d7a68;
            --green-pale: #e8f2ee;
            --text-dark:  #1a2e26;
            --text-mid:   #4a6258;
            --text-light: #7a9a8e;
            --white:      #ffffff;
            --gray-bg:    #f7f9f8;
            --border:     #dce9e4;
            --radius:     24px;
            --radius-sm:  12px;
            --shadow-lg:  0 32px 80px rgba(26,46,38,0.18);
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            background: #b8cfc7;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
        }
        .login-wrap { width:100%; max-width:420px; }
        .auth-card {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow-lg);
            padding: 2rem 2rem 1.5rem;
            animation: fadeUp .45s ease both;
            position: relative;
        }
        @keyframes fadeUp { from{opacity:0;transform:translateY(18px)} to{opacity:1;transform:translateY(0)} }

        /* lang selector */
        .lang-top {
            position: absolute;
            top: 1.1rem; right: 1.1rem;
            display: flex; align-items: center; gap: .3rem;
            border: 1.5px solid var(--border);
            border-radius: 50px;
            padding: .28rem .7rem;
            font-size: .72rem; font-weight: 600; color: var(--text-dark);
            cursor: pointer; background: #fff;
        }
        .lang-top i { color: var(--text-light); font-size: .7rem; }
        .lang-top select {
            border: none; outline: none; background: transparent;
            font-family: 'Inter', sans-serif;
            font-size: .72rem; font-weight: 700; color: var(--text-dark);
            cursor: pointer;
        }

        /* logo */
        .logo-area { text-align:center; padding-top:.3rem; margin-bottom:1.4rem; }
        .logo-circle {
            width:66px; height:66px;
            background: var(--green-pale);
            border-radius: 50%;
            display: inline-flex; align-items:center; justify-content:center;
            margin-bottom:.85rem;
        }
        .logo-circle svg { width:34px; height:34px; }
        .logo-area h1 { font-size:1.5rem; font-weight:800; color:var(--text-dark); letter-spacing:-.03em; margin-bottom:.2rem; }
        .logo-area p  { font-size:.8rem; color:var(--text-light); }

        /* fields */
        .field-group { margin-bottom:1rem; }
        .field-group label { display:block; font-size:.78rem; font-weight:600; color:var(--text-dark); margin-bottom:.4rem; }
        .field-wrap { position:relative; }
        .field-icon { position:absolute; left:.85rem; top:50%; transform:translateY(-50%); color:var(--text-light); font-size:.78rem; pointer-events:none; }
        .field-input {
            width:100%; padding:.7rem .9rem .7rem 2.2rem;
            border:1.5px solid var(--border); border-radius:var(--radius-sm);
            font-family:'Inter',sans-serif; font-size:.9rem;
            background:var(--gray-bg); color:var(--text-dark);
            transition:all .2s; outline:none;
        }
        .field-input::placeholder { color:#aab8b3; }
        .field-input:focus { border-color:var(--green); box-shadow:0 0 0 3px rgba(106,158,138,.14); background:#fff; }

        .forgot-link { text-align:right; margin-top:.3rem; margin-bottom:1.2rem; }
        .forgot-link a { font-size:.78rem; color:var(--green-dark); font-weight:600; text-decoration:none; }
        .forgot-link a:hover { text-decoration:underline; }

        .btn-main {
            width:100%; padding:.78rem;
            background:linear-gradient(135deg,var(--green-dark),var(--green));
            color:#fff; border:none; border-radius:var(--radius-sm);
            font-family:'Inter',sans-serif; font-size:.92rem; font-weight:700;
            cursor:pointer; transition:all .2s;
            display:flex; align-items:center; justify-content:center; gap:.5rem;
            box-shadow:0 4px 14px rgba(77,122,104,.3); margin-bottom:1.3rem;
        }
        .btn-main:hover { transform:translateY(-1px); box-shadow:0 8px 22px rgba(77,122,104,.4); }
        .btn-main:disabled { background:#cbd5e0; box-shadow:none; cursor:not-allowed; transform:none; }

        /* divider */
        .divider-quick { display:flex; align-items:center; gap:.7rem; margin-bottom:1.1rem; }
        .divider-quick::before,.divider-quick::after { content:''; flex:1; height:1px; background:var(--border); }
        .divider-quick span {
            font-size:.65rem; font-weight:700; letter-spacing:.08em; color:var(--text-light);
            text-transform:uppercase; border:1.5px solid var(--border); border-radius:50px;
            padding:.22rem .75rem; white-space:nowrap;
        }

        /* OTP section */
        .otp-section {
            background:var(--gray-bg); border:1.5px solid var(--border);
            border-radius:var(--radius-sm); padding:1.3rem 1.1rem 1.1rem;
            margin-bottom:1.2rem;
        }
        .otp-section-title { text-align:center; font-size:.92rem; font-weight:700; color:var(--text-dark); margin-bottom:.22rem; }
        .otp-section-sub   { text-align:center; font-size:.74rem; color:var(--text-light); margin-bottom:1.05rem; }

        .otp-boxes { display:flex; gap:.42rem; justify-content:center; margin-bottom:.9rem; }
        .otp-box {
            width:44px; height:52px;
            border:1.5px solid var(--border); border-radius:10px;
            font-family:'Inter',sans-serif; font-size:1.3rem; font-weight:700;
            text-align:center; color:var(--text-dark); background:#fff;
            transition:all .18s; outline:none; caret-color:transparent;
        }
        .otp-box:focus { border-color:var(--green); box-shadow:0 0 0 3px rgba(106,158,138,.15); }
        .otp-box.filled { border-color:var(--green); background:var(--green-pale); }

        .timer-bar-wrap { height:3px; background:var(--border); border-radius:4px; margin-bottom:.6rem; overflow:hidden; }
        .timer-bar-fill {
            height:100%; background:linear-gradient(90deg,var(--green-dark),var(--green));
            border-radius:4px; transition:width 1s linear; width:100%;
        }
        .otp-timer-text { text-align:center; font-size:.72rem; color:var(--text-light); margin-bottom:.75rem; display:none; }
        .otp-timer-text.visible { display:block; }
        #countdown { font-weight:700; color:var(--text-dark); }
        #countdown.urgente { color:#E53E3E; }

        .btn-verify {
            width:100%; padding:.7rem;
            background:#fff; color:var(--text-dark);
            border:1.5px solid var(--border); border-radius:var(--radius-sm);
            font-family:'Inter',sans-serif; font-size:.88rem; font-weight:700;
            cursor:pointer; transition:all .2s;
            display:flex; align-items:center; justify-content:center; gap:.4rem;
        }
        .btn-verify:hover { background:var(--green-pale); border-color:var(--green); color:var(--green-dark); }
        .btn-verify:disabled { opacity:.45; cursor:not-allowed; }

        /* disabled state */
        .otp-disabled .otp-box { background:#f0f4f2; color:#b0c4bc; cursor:not-allowed; }
        .otp-disabled .btn-verify { opacity:.45; cursor:not-allowed; pointer-events:none; }

        .alert-err {
            display:flex; align-items:center; gap:.5rem;
            font-size:.8rem; color:#922B21; background:#FADBD8;
            border-radius:var(--radius-sm); padding:.6rem .85rem; margin-bottom:1rem;
        }
        .register-link { text-align:center; font-size:.8rem; color:var(--text-light); }
        .register-link a { color:var(--text-dark); font-weight:700; text-decoration:none; }
        .register-link a:hover { text-decoration:underline; }
        .page-foot { text-align:center; margin-top:1.2rem; font-size:.72rem; color:rgba(77,122,104,.55); }
    </style>
</head>
<body>

    <%-- Toast: contraseña recuperada exitosamente --%>
    <c:if test="${param.recuperado == 'ok'}">
      <div id="recToast" style="
        position:fixed;top:1.2rem;left:50%;transform:translateX(-50%);
        background:#2d5a47;color:#fff;padding:.8rem 1.6rem;
        border-radius:12px;font-size:.85rem;font-weight:700;
        box-shadow:0 6px 24px rgba(0,0,0,.22);z-index:9999;
        display:flex;align-items:center;gap:.55rem;
        animation:fadeUp .4s ease both;">
        <i class="fas fa-check-circle"></i> ¡Contraseña actualizada! Inicia sesión con tu nueva clave.
      </div>
      <script>setTimeout(()=>{const t=document.getElementById('recToast');if(t)t.remove();},5000);</script>
    </c:if>

<div class="login-wrap">
  <div class="auth-card"
       data-otp-activo="${not empty emailMasked ? 'true' : 'false'}"
       data-email-masked="${not empty emailMasked ? emailMasked : ''}"
       id="authCard">

    <!-- Idioma top-right -->
    <div class="lang-top">
      <i class="fas fa-globe"></i>
      <select id="langSelect" onchange="cambiarIdioma(this.value)">
        <option value="es" ${(empty sessionScope.lang || sessionScope.lang=='es') ? 'selected' : ''}>ES</option>
        <option value="en" ${sessionScope.lang=='en' ? 'selected' : ''}>EN</option>
        <option value="it" ${sessionScope.lang=='it' ? 'selected' : ''}>IT</option>
      </select>
      <i class="fas fa-chevron-down" style="font-size:.55rem"></i>
    </div>

    <!-- Logo -->
    <div class="logo-area">
     <div class="logo-circle">
  <svg viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M22 10V24C22 31 27 36 34 36C41 36 46 31 46 24V10"
        stroke="#4d7a68" stroke-width="4" stroke-linecap="round"/>

    <path d="M18 10H26M42 10H50"
        stroke="#4d7a68" stroke-width="4" stroke-linecap="round"/>

    <path d="M34 36V44C34 50 39 55 45 55C51 55 56 50 56 44V40"
        stroke="#4d7a68" stroke-width="4" stroke-linecap="round"/>

    <circle cx="56" cy="36" r="6" fill="#6a9e8a"/>
    <circle cx="56" cy="36" r="2.5" fill="white"/>
  </svg>
</div>
      <h1>SaludBoyacá</h1>
      <p><fmt:message key="login.subtitle"/></p>
    </div>

    <!-- Errores -->
    <c:if test="${not empty error}">
      <div class="alert-err"><i class="fas fa-exclamation-circle"></i> ${error}</div>
    </c:if>
    <div class="alert-err" id="jsError" style="display:none">
      <i class="fas fa-exclamation-circle"></i><span id="jsErrorMsg"></span>
    </div>
    <c:if test="${not empty otpError}">
      <div class="alert-err"><i class="fas fa-times-circle"></i> ${otpError}</div>
    </c:if>

    <!-- Login Form -->
    <form id="loginForm" action="${pageContext.request.contextPath}/login" method="post">
      <div class="field-group">
        <label><fmt:message key="login.user"/></label>
        <div class="field-wrap">
          <i class="fas fa-user field-icon"></i>
          <input type="text" name="username" id="usernameInput" class="field-input"
                 placeholder="<fmt:message key='login.user.placeholder'/>"
                 autocomplete="username" required autofocus>
        </div>
      </div>
      <div class="field-group">
        <label><fmt:message key="login.pass"/></label>
        <div class="field-wrap">
          <i class="fas fa-lock field-icon"></i>
          <input type="password" name="password" id="passwordInput" class="field-input"
                 placeholder="<fmt:message key='login.pass.placeholder'/>" autocomplete="current-password" required>
        </div>
      </div>
      <div class="forgot-link"><a href="${pageContext.request.contextPath}/recuperar?paso=solicitar"><fmt:message key="login.forgot"/></a></div>
      <button type="submit" class="btn-main" id="btnLogin"><fmt:message key="login.button"/></button>
    </form>

    <!-- Divisor -->
    <div class="divider-quick"><span><fmt:message key="login.quick"/></span></div>

    <!-- OTP Section -->
    <div class="otp-section" id="otpSection">
      <div class="otp-section-title"><fmt:message key="otp.subtitle"/></div>
      <div class="otp-section-sub" id="otpSubtitle">Enviado a tu móvil por Gmail</div>

      <div class="otp-boxes">
        <input class="otp-box" type="text" maxlength="1" inputmode="numeric" pattern="[0-9]" id="otp0" autocomplete="off">
        <input class="otp-box" type="text" maxlength="1" inputmode="numeric" pattern="[0-9]" id="otp1" autocomplete="off">
        <input class="otp-box" type="text" maxlength="1" inputmode="numeric" pattern="[0-9]" id="otp2" autocomplete="off">
        <input class="otp-box" type="text" maxlength="1" inputmode="numeric" pattern="[0-9]" id="otp3" autocomplete="off">
        <input class="otp-box" type="text" maxlength="1" inputmode="numeric" pattern="[0-9]" id="otp4" autocomplete="off">
        <input class="otp-box" type="text" maxlength="1" inputmode="numeric" pattern="[0-9]" id="otp5" autocomplete="off">
      </div>

      <div class="timer-bar-wrap" id="timerBarWrap" style="display:none">
        <div class="timer-bar-fill" id="timerBarFill"></div>
      </div>
      <div class="otp-timer-text" id="otpTimerText">
        <i class="fas fa-clock"></i> Expira en <span id="countdown">5:00</span>
      </div>

      <form id="otpForm" action="${pageContext.request.contextPath}/otp?accion=validar" method="post">
        <input type="hidden" name="otpCodigo" id="otpHidden">
        <button type="button" class="btn-verify" id="btnVerify" onclick="submitOtp()">
          Verificar código
        </button>
      </form>
    </div>

    <!-- Registro -->
    <div class="register-link">
      <fmt:message key="login.register"/> <a href="${pageContext.request.contextPath}/"><fmt:message key="login.register.link"/></a>
    </div>

    <!-- Volver al inicio -->
    <div style="text-align:center;margin-top:.85rem;">
      <a href="${pageContext.request.contextPath}/"
         style="display:inline-flex;align-items:center;gap:.4rem;font-size:.78rem;font-weight:600;
                color:var(--text-mid);text-decoration:none;border:1.5px solid var(--border);
                padding:.35rem 1rem;border-radius:50px;transition:all .2s;"
         onmouseover="this.style.borderColor='var(--green)';this.style.color='var(--green-dark)'"
         onmouseout="this.style.borderColor='var(--border)';this.style.color='var(--text-mid)'">
        <i class="fas fa-arrow-left"></i> <fmt:message key="login.back.index"/>
      </a>
    </div>

  </div>
  <div class="page-foot"><fmt:message key="login.footer"/></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
var otpTimerInterval = null;
var timerSeconds = 300;
var _card     = document.getElementById('authCard');
var otpActivo = _card.dataset.otpActivo === 'true';

window.addEventListener('DOMContentLoaded', function () {
    initOtpBoxes();
    if (otpActivo) {
        activarSeccionOtp();
    } else {
        document.getElementById('otpSection').classList.add('otp-disabled');
        document.getElementById('btnVerify').disabled = true;
    }
});

function initOtpBoxes() {
    var boxes = document.querySelectorAll('.otp-box');
    boxes.forEach(function(box, idx) {
        box.addEventListener('focus', function () {
            if (!otpActivo) { this.blur(); return; }
        });
        box.addEventListener('input', function () {
            var val = this.value.replace(/\D/g,'');
            this.value = val ? val[0] : '';
            if (val) {
                this.classList.add('filled');
                if (idx < 5) boxes[idx+1].focus();
            } else {
                this.classList.remove('filled');
            }
            if (getOtpValue().length === 6 && otpActivo) {
                setTimeout(submitOtp, 180);
            }
        });
        box.addEventListener('keydown', function (e) {
            if (e.key === 'Backspace' && !this.value && idx > 0) {
                boxes[idx-1].focus();
                boxes[idx-1].value = '';
                boxes[idx-1].classList.remove('filled');
            }
            if (e.key === 'Enter' && otpActivo) submitOtp();
        });
        box.addEventListener('paste', function (e) {
            e.preventDefault();
            var pasted = (e.clipboardData||window.clipboardData).getData('text').replace(/\D/g,'').slice(0,6);
            boxes.forEach(function(b,i){ b.value = pasted[i]||''; b.classList.toggle('filled', !!pasted[i]); });
            boxes[Math.min(pasted.length,5)].focus();
            if (pasted.length === 6 && otpActivo) setTimeout(submitOtp, 180);
        });
    });
}

function getOtpValue() {
    var v = '';
    for (var i=0;i<6;i++) v += (document.getElementById('otp'+i).value||'');
    return v;
}

function activarSeccionOtp() {
    otpActivo = true;
    var sec = document.getElementById('otpSection');
    sec.classList.remove('otp-disabled');
    document.getElementById('btnVerify').disabled = false;
    document.getElementById('timerBarWrap').style.display = 'block';
    document.getElementById('otpTimerText').classList.add('visible');
    var sub = document.getElementById('otpSubtitle');
    // JSP expression for emailMasked
    var masked = _card.dataset.emailMasked || 'tu correo registrado';
    sub.textContent = 'Enviado a ' + masked;
    iniciarTimer();
    setTimeout(function(){ document.getElementById('otp0').focus(); }, 100);
}

function submitOtp() {
    var code = getOtpValue();
    if (code.length < 6) {
        var el = document.getElementById('jsError');
        document.getElementById('jsErrorMsg').textContent = 'Ingresa los 6 dígitos del código.';
        el.style.display = 'flex';
        return;
    }
    document.getElementById('otpHidden').value = code;
    document.getElementById('otpForm').submit();
}

function iniciarTimer() {
    if (otpTimerInterval) clearInterval(otpTimerInterval);
    timerSeconds = 300;
    var el  = document.getElementById('countdown');
    var bar = document.getElementById('timerBarFill');
    var btn = document.getElementById('btnVerify');
    otpTimerInterval = setInterval(function () {
        timerSeconds--;
        var m = Math.floor(timerSeconds/60);
        var s = timerSeconds%60;
        el.textContent = m+':'+String(s).padStart(2,'0');
        bar.style.width = (timerSeconds/300*100)+'%';
        if (timerSeconds < 60) { el.classList.add('urgente'); bar.style.background='#E53E3E'; }
        if (timerSeconds <= 0) { clearInterval(otpTimerInterval); btn.disabled=true; btn.textContent='Código expirado'; }
    }, 1000);
}

document.getElementById('loginForm').addEventListener('submit', function (e) {
    var user = document.getElementById('usernameInput').value.trim();
    var pass = document.getElementById('passwordInput').value.trim();
    if (!user || !pass) {
        e.preventDefault();
        var el = document.getElementById('jsError');
        document.getElementById('jsErrorMsg').textContent = 'Completa usuario y contraseña.';
        el.style.display = 'flex';
        return;
    }
    var btn = document.getElementById('btnLogin');
    btn.disabled = true;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Verificando...';
});

function cambiarIdioma(lang) {
    window.location.href = '${pageContext.request.contextPath}/login?lang=' + lang;
}
</script>
</body>
</html>

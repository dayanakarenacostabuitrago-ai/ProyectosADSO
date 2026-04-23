<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login — Biblioteca SENA</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,700;0,900;1,800&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

        <style>
            *, *::before, *::after {
                margin:0;
                padding:0;
                box-sizing:border-box;
            }

            html, body {
                width:100%;
                height:100%;
                overflow:hidden;
                font-family:'DM Sans', sans-serif;
                background:#060e1e;
            }

            /* ── SPLINE fullscreen ── */
            .spline-bg {
                position:fixed;
                inset:0;
                width:100%;
                height:100%;
                border:none;
                z-index:0;
            }

            /* ── very light dark overlay so spline shines through ── */
            .overlay {
                position:fixed;
                inset:0;
                z-index:1;
                pointer-events:none;
                background:rgba(4,10,24,.42);
            }

            /* ── centered shell ── */
            .shell {
                position:fixed;
                inset:0;
                z-index:2;
                display:flex;
                align-items:center;
                justify-content:center;
                pointer-events:none;
            }

            /* ── CARD ── lighter, more transparent, properly sized ── */
            .card {
                pointer-events:auto;
                width:390px;
                max-width:90vw;
                max-height:96vh;          /* never taller than viewport */
                overflow-y:auto;          /* scroll if tiny screen */
                border-radius:24px;
                padding:2.2rem 2.2rem 2rem;

                /* lighter transparent glass */
                background:rgba(14,35,80,.38);
                backdrop-filter:blur(36px) saturate(1.8);
                -webkit-backdrop-filter:blur(36px) saturate(1.8);

                /* bright top edge + subtle azure outline */
                border:1px solid rgba(100,160,255,.22);
                border-top:1px solid rgba(180,210,255,.28);

                box-shadow:
                    0 0 0 1px rgba(255,255,255,.06) inset,
                    0 1px 0  rgba(255,255,255,.12) inset,
                    0 32px 80px rgba(0,0,0,.55),
                    0  0  60px rgba(21,101,192,.12);

                animation:rise .75s cubic-bezier(.22,1,.36,1) both;
                scrollbar-width:none;
            }
            .card::-webkit-scrollbar{
                display:none;
            }

            @keyframes rise {
                from{
                    opacity:0;
                    transform:translateY(24px) scale(.96)
                }
                to  {
                    opacity:1;
                    transform:translateY(0)    scale(1)
                }
            }

            /* subtle corner glows */
            .card::before {
                content:'';
                position:absolute;
                top:-60px;
                right:-40px;
                z-index:-1;
                width:180px;
                height:180px;
                border-radius:50%;
                background:radial-gradient(circle,rgba(66,165,245,.1),transparent 70%);
                pointer-events:none;
            }

            /* ── LOGO ── */
            .logo-area {
                display:flex;
                flex-direction:column;
                align-items:center;
                gap:.45rem;
                margin-bottom:1.6rem;
                animation:up .55s .08s cubic-bezier(.22,1,.36,1) both;
            }
            @keyframes up{
                from{
                    opacity:0;
                    transform:translateY(14px)
                }
                to  {
                    opacity:1;
                    transform:translateY(0)
                }
            }

            .logo-icon {
                width:54px;
                height:54px;
                border-radius:15px;
                background:linear-gradient(145deg,#1565C0,#42A5F5);
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:1.25rem;
                color:#fff;
                box-shadow:0 6px 24px rgba(21,101,192,.5), 0 0 40px rgba(66,165,245,.18);
                position:relative;
            }
            .logo-icon::before {
                content:'';
                position:absolute;
                inset:-5px;
                border-radius:20px;
                border:1.5px solid rgba(66,165,245,.22);
                animation:pr 2.8s ease-in-out infinite;
            }
            @keyframes pr{
                0%,100%{
                    transform:scale(1);
                    opacity:.5
                }
                50%{
                    transform:scale(1.1);
                    opacity:.15
                }
            }

            .logo-name {
                font-family:'Playfair Display',serif;
                font-size:1.08rem;
                font-weight:900;
                color:rgba(232,240,255,.95);
            }
            .logo-name em{
                color:#FFD54F;
                font-style:italic;
            }

            /* ── HEADING ── */
            .heading {
                text-align:center;
                margin-bottom:1.6rem;
                animation:up .55s .15s cubic-bezier(.22,1,.36,1) both;
            }
            .heading h2 {
                font-family:'Playfair Display',serif;
                font-size:1.55rem;
                font-weight:900;
                color:#fff;
                line-height:1.2;
                margin-bottom:.25rem;
            }
            .heading h2 em{
                color:#64b5f6;
                font-style:italic;
            }
            .heading p{
                font-size:.81rem;
                color:rgba(255,255,255,.35);
                font-weight:400;
            }

            /* ── ERROR ── */
            .err-box {
                display:flex;
                align-items:center;
                gap:.5rem;
                background:rgba(248,113,113,.1);
                border:1px solid rgba(248,113,113,.25);
                border-radius:11px;
                padding:.65rem .9rem;
                font-size:.81rem;
                color:#fca5a5;
                margin-bottom:1rem;
            }

            /* ── FIELDS ── */
            .fields{
                display:flex;
                flex-direction:column;
                gap:.9rem;
            }

            .field-wrap{
                animation:up .55s cubic-bezier(.22,1,.36,1) both;
            }
            .field-wrap:nth-child(1){
                animation-delay:.24s;
            }
            .field-wrap:nth-child(2){
                animation-delay:.32s;
            }

            .field-label {
                display:block;
                font-size:.66rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:.1em;
                color:rgba(100,180,255,.65);
                margin-bottom:.38rem;
            }

            /* ── INPUT SHELL — lighter blue, truly transparent ── */
            .input-shell {
                display:flex;
                align-items:center;
                background:rgba(30,70,140,.25);
                border:1px solid rgba(100,160,255,.2);
                border-radius:13px;
                transition:border-color .25s, box-shadow .25s, background .25s;
            }
            .input-shell:hover{
                background:rgba(30,70,140,.32);
                border-color:rgba(100,160,255,.35);
            }
            .input-shell:focus-within{
                background:rgba(30,80,160,.3);
                border-color:rgba(66,165,245,.55);
                box-shadow:0 0 0 3px rgba(66,165,245,.12), 0 4px 20px rgba(66,165,245,.12);
            }

            /* icon zone */
            .input-ico {
                width:44px;
                flex-shrink:0;
                display:flex;
                align-items:center;
                justify-content:center;
                color:rgba(100,180,255,.5);
                font-size:.88rem;
                border-right:1px solid rgba(100,160,255,.12);
                align-self:stretch;
                transition:color .25s;
            }
            .input-shell:focus-within .input-ico{
                color:#64b5f6;
                border-right-color:rgba(100,160,255,.22);
            }

            /* THE INPUT — autofill killer */
            .input-shell input {
                flex:1;
                border:none;
                outline:none;
                background:transparent;
                padding:.82rem .85rem;
                color:rgba(232,240,255,.95);
                font-size:.92rem;
                font-weight:500;
                font-family:'DM Sans',sans-serif;
                caret-color:#64b5f6;
                -webkit-text-fill-color:rgba(232,240,255,.95) !important;
                transition:background-color 9999s 0s !important;
            }
            .input-shell input:-webkit-autofill,
            .input-shell input:-webkit-autofill:hover,
            .input-shell input:-webkit-autofill:focus {
                -webkit-box-shadow:0 0 0 9999px rgba(20,55,130,.35) inset !important;
                -webkit-text-fill-color:rgba(232,240,255,.95) !important;
            }
            .input-shell input::placeholder{
                color:rgba(255,255,255,.18);
            }

            /* eye button */
            .eye-btn {
                width:42px;
                flex-shrink:0;
                align-self:stretch;
                background:transparent;
                border:none;
                cursor:pointer;
                color:rgba(255,255,255,.22);
                font-size:.82rem;
                display:flex;
                align-items:center;
                justify-content:center;
                transition:color .2s;
            }
            .eye-btn:hover{
                color:rgba(255,255,255,.6);
            }

            /* ── REMEMBER ── */
            .row-opts{
                margin-top:.5rem;
                animation:up .55s .4s cubic-bezier(.22,1,.36,1) both;
            }
            .check-label{
                display:inline-flex;
                align-items:center;
                gap:.48rem;
                cursor:pointer;
                user-select:none;
            }
            .check-label input[type=checkbox]{
                display:none;
            }
            .chk-box {
                width:16px;
                height:16px;
                border-radius:5px;
                flex-shrink:0;
                border:1.5px solid rgba(100,160,255,.3);
                background:rgba(20,55,130,.25);
                display:flex;
                align-items:center;
                justify-content:center;
                transition:all .2s;
            }
            .check-label input[type=checkbox]:checked ~ .chk-box{
                background:#42A5F5;
                border-color:#42A5F5;
            }
            .check-label input[type=checkbox]:checked ~ .chk-box::after{
                content:'\f00c';
                font-family:'Font Awesome 6 Free';
                font-weight:900;
                color:#fff;
                font-size:.58rem;
            }
            .check-label:hover .chk-box{
                border-color:rgba(100,160,255,.55);
            }
            .check-label span{
                font-size:.8rem;
                color:rgba(255,255,255,.35);
                font-weight:500;
            }
            .check-label:hover span{
                color:rgba(255,255,255,.6);
            }

            /* ── BUTTON ── */
            .btn-submit {
                width:100%;
                margin-top:1.3rem;
                padding:.9rem 1.2rem;
                border:none;
                border-radius:13px;
                cursor:pointer;
                font-family:'DM Sans',sans-serif;
                font-size:.93rem;
                font-weight:700;
                letter-spacing:.025em;
                color:#fff;
                background:linear-gradient(135deg,#1565C0 0%,#1e88e5 50%,#42A5F5 100%);
                box-shadow:
                    0 2px 0 rgba(255,255,255,.14) inset,
                    0 8px 28px rgba(21,101,192,.4),
                    0 2px 8px rgba(21,101,192,.25);
                position:relative;
                overflow:hidden;
                transition:transform .22s, box-shadow .22s;
                animation:up .55s .48s cubic-bezier(.22,1,.36,1) both;
            }
            .btn-submit::before{
                content:'';
                position:absolute;
                top:0;
                left:-120%;
                width:55%;
                height:100%;
                background:linear-gradient(90deg,transparent,rgba(255,255,255,.2),transparent);
                transition:left .5s ease;
            }
            .btn-submit:hover{
                transform:translateY(-2px);
                box-shadow:0 14px 40px rgba(21,101,192,.5), 0 2px 0 rgba(255,255,255,.15) inset;
            }
            .btn-submit:hover::before{
                left:160%;
            }
            .btn-submit:active{
                transform:translateY(0);
            }
            .btn-inner{
                display:flex;
                align-items:center;
                justify-content:center;
                gap:.55rem;
                position:relative;
                z-index:1;
            }
            .btn-arrow{
                width:24px;
                height:24px;
                border-radius:50%;
                background:rgba(255,255,255,.2);
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:.68rem;
                transition:transform .25s;
            }
            .btn-submit:hover .btn-arrow{
                transform:translateX(4px);
            }

            /* ── DIVIDER ── */
            .divider{
                display:flex;
                align-items:center;
                gap:.75rem;
                margin:1.3rem 0 .9rem;
                animation:up .55s .54s cubic-bezier(.22,1,.36,1) both;
            }
            .divider::before,.divider::after{
                content:'';
                flex:1;
                height:1px;
                background:linear-gradient(to right,transparent,rgba(100,160,255,.18),transparent);
            }
            .divider span{
                font-size:.68rem;
                color:rgba(255,255,255,.2);
                white-space:nowrap;
            }

            /* ── REGISTER ── */
            .register{
                text-align:center;
                animation:up .55s .58s cubic-bezier(.22,1,.36,1) both;
            }
            .register p{
                font-size:.82rem;
                color:rgba(255,255,255,.3);
            }
            .register a{
                color:#FFD54F;
                font-weight:700;
                text-decoration:none;
                margin-left:.2rem;
                transition:all .22s;
            }
            .register a:hover{
                color:#ffe680;
                text-shadow:0 0 12px rgba(255,213,79,.35);
            }

            @media(max-width:480px){
                .card{
                    padding:1.8rem 1.4rem 1.6rem;
                    border-radius:20px;
                }
            }
        </style>
    </head>
    <body>

        <!-- SPLINE FULLSCREEN -->
        <iframe class="spline-bg"
                src="https://my.spline.design/r4xbot-G0kPuvpzXyp02L9KyiVJ1lAJ/"
                allowfullscreen></iframe>

        <!-- LIGHT OVERLAY -->
        <div class="overlay"></div>

        <!-- CENTERED FORM -->
        <div class="shell">
            <div class="card">

                <!-- Logo -->
                <div class="logo-area">
                    <div class="logo-icon"><i class="fas fa-book-open"></i></div>
                    <div class="logo-name">Biblioteca <em>SENA</em></div>
                </div>

                <!-- Heading -->
                <div class="heading">
                    <h2>Bienvenido <em>de vuelta</em></h2>
                    <p>Ingresa tus credenciales para continuar</p>
                </div>

                <%-- Error --%>
                <%
                    String errorLogin = (String) session.getAttribute("errorLogin");
                    if (errorLogin != null) {
                        session.removeAttribute("errorLogin");
                %>
                <div class="err-box">
                    <i class="fas fa-exclamation-circle"></i> <%=errorLogin%>
                </div>
                <% }%>

                <form action="${pageContext.request.contextPath}/loginServlet" method="post">

                    <div class="fields">

                        <div class="field-wrap">
                            <label class="field-label">Documento de identidad</label>
                            <div class="input-shell">
                                <div class="input-ico"><i class="fas fa-id-card"></i></div>
                                <input type="text" name="documento"
                                       placeholder="Número de documento"
                                       required autocomplete="username">
                            </div>
                        </div>

                        <div class="field-wrap">
                            <label class="field-label">Contraseña</label>
                            <div class="input-shell">
                                <div class="input-ico"><i class="fas fa-lock"></i></div>
                                <input type="password" name="password" id="pwdField"
                                       placeholder="••••••••••"
                                       required autocomplete="current-password">
                                <button type="button" class="eye-btn" onclick="togglePwd()" tabindex="-1">
                                    <i class="fas fa-eye" id="eyeIco"></i>
                                </button>
                            </div>
                        </div>

                    </div>

                    <!-- Recordarme -->
                    <div class="row-opts">
                        <label class="check-label">
                            <input type="checkbox" name="remember">
                            <div class="chk-box"></div>
                            <span>Recordarme en este dispositivo</span>
                        </label>
                    </div>

                    <!-- Botón -->
                    <button type="submit" class="btn-submit">
                        <div class="btn-inner">
                            <span>Ingresar al sistema</span>
                            <span class="btn-arrow"><i class="fas fa-arrow-right"></i></span>
                        </div>
                    </button>

                </form>

                <div class="divider"><span>¿Eres nuevo aquí?</span></div>

                <div class="register">
                    <p>¿No tienes cuenta?
                        <a href="${pageContext.request.contextPath}/registro">Regístrate ahora</a>
                    </p>
                </div>

            </div>
        </div>

        <script>
            function togglePwd() {
                const f = document.getElementById('pwdField');
                const i = document.getElementById('eyeIco');
                f.type = f.type === 'password' ? 'text' : 'password';
                i.className = f.type === 'password' ? 'fas fa-eye' : 'fas fa-eye-slash';
            }
        </script>

    </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="false"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>404 — Página no encontrada | Biblioteca SENA</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <style>
            *,*::before,*::after{
                box-sizing:border-box;
                margin:0;
                padding:0;
            }
            :root{
                --azul-oscuro:#0A1628;
                --azul-marino:#0D2855;
                --azul-primario:#1565C0;
                --azul-claro:#42A5F5;
                --dorado:#FFD54F;
            }
            body{
                font-family:'Lato',sans-serif;
                background:var(--azul-oscuro);
                color:#F8FBFF;
                min-height:100vh;
                display:flex;
                flex-direction:column;
                align-items:center;
                justify-content:center;
                overflow:hidden;
                position:relative;
            }

            /* BACKGROUND */
            .bg-glow{
                position:absolute;
                inset:0;
                pointer-events:none;
            }
            .bg-glow::before{
                content:'';
                position:absolute;
                top:-20%;
                left:-10%;
                width:60%;
                height:70%;
                border-radius:50%;
                background:radial-gradient(circle,rgba(21,101,192,.18) 0%,transparent 70%);
            }
            .bg-glow::after{
                content:'';
                position:absolute;
                bottom:-10%;
                right:-10%;
                width:50%;
                height:60%;
                border-radius:50%;
                background:radial-gradient(circle,rgba(255,213,79,.06) 0%,transparent 70%);
            }

            /* FLOATING BOOKS */
            .book-float{
                position:absolute;
                font-size:1.5rem;
                opacity:.08;
                animation:bookDrift linear infinite;
            }
            @keyframes bookDrift{
                0%{
                    transform:translateY(110vh) rotate(0deg);
                    opacity:0
                }
                10%{
                    opacity:.08
                }
                90%{
                    opacity:.05
                }
                100%{
                    transform:translateY(-20vh) rotate(360deg);
                    opacity:0
                }
            }

            /* GRID LINES */
            .grid-lines{
                position:absolute;
                inset:0;
                background-image:linear-gradient(rgba(66,165,245,.04) 1px,transparent 1px),linear-gradient(90deg,rgba(66,165,245,.04) 1px,transparent 1px);
                background-size:60px 60px;
                pointer-events:none;
            }

            /* CONTENT */
            .content{
                position:relative;
                z-index:10;
                text-align:center;
                padding:2rem;
            }

            /* ERROR CODE */
            .err-code{
                font-family:'Playfair Display',serif;
                font-size:clamp(7rem,18vw,14rem);
                font-weight:900;
                line-height:.9;
                background:linear-gradient(135deg,var(--azul-claro) 0%,var(--dorado) 60%,var(--azul-claro) 100%);
                background-size:200%;
                -webkit-background-clip:text;
                -webkit-text-fill-color:transparent;
                animation:shimmer 3s ease infinite;
                margin-bottom:1.5rem;
                letter-spacing:-4px;
            }
            @keyframes shimmer{
                0%,100%{
                    background-position:0%
                }
                50%{
                    background-position:100%
                }
            }

            /* OPEN BOOK ICON */
            .book-icon{
                font-size:3.5rem;
                color:var(--dorado);
                margin-bottom:1.2rem;
                display:block;
                animation:wobble 3s ease-in-out infinite;
            }
            @keyframes wobble{
                0%,100%{
                    transform:rotate(-5deg) scale(1)
                }
                50%{
                    transform:rotate(5deg) scale(1.08)
                }
            }

            /* TITLE & SUBTITLE */
            .err-title{
                font-family:'Playfair Display',serif;
                font-size:clamp(1.4rem,4vw,2.2rem);
                font-weight:700;
                margin-bottom:.8rem;
                color:#F8FBFF;
            }
            .err-sub{
                color:rgba(248,251,255,.45);
                font-size:1rem;
                max-width:480px;
                line-height:1.8;
                margin:0 auto 2.5rem;
            }
            .err-sub strong{
                color:var(--azul-claro);
            }

            /* BUTTONS */
            .btn-row{
                display:flex;
                gap:1rem;
                justify-content:center;
                flex-wrap:wrap;
            }
            .btn-primary{
                display:inline-flex;
                align-items:center;
                gap:.6rem;
                padding:.8rem 2rem;
                background:linear-gradient(135deg,var(--azul-primario),var(--azul-claro));
                color:#fff;
                border-radius:50px;
                text-decoration:none;
                font-weight:700;
                font-size:.95rem;
                transition:all .25s;
                box-shadow:0 8px 24px rgba(21,101,192,.4);
            }
            .btn-primary:hover{
                transform:translateY(-3px);
                box-shadow:0 14px 34px rgba(21,101,192,.55);
                color:#fff;
            }
            .btn-secondary{
                display:inline-flex;
                align-items:center;
                gap:.6rem;
                padding:.8rem 2rem;
                background:transparent;
                color:rgba(248,251,255,.55);
                border:1.5px solid rgba(255,255,255,.15);
                border-radius:50px;
                text-decoration:none;
                font-weight:600;
                font-size:.95rem;
                transition:all .25s;
            }
            .btn-secondary:hover{
                border-color:rgba(255,255,255,.35);
                color:rgba(248,251,255,.85);
                transform:translateY(-2px);
            }

            /* DIVIDER LINE */
            .divider{
                width:60px;
                height:3px;
                background:linear-gradient(90deg,var(--azul-claro),var(--dorado));
                border-radius:2px;
                margin:1.5rem auto;
            }

            /* TIPS */
            .tips{
                display:flex;
                gap:1.2rem;
                justify-content:center;
                flex-wrap:wrap;
                margin-top:2.5rem;
            }
            .tip-item{
                display:flex;
                align-items:center;
                gap:.5rem;
                padding:.45rem 1.1rem;
                background:rgba(255,255,255,.04);
                border:1px solid rgba(255,255,255,.08);
                border-radius:50px;
                font-size:.8rem;
                color:rgba(255,255,255,.4);
            }
            .tip-item i{
                color:var(--azul-claro);
                font-size:.75rem;
            }
        </style>
    </head>
    <body>
        <!-- Background -->
        <div class="bg-glow"></div>
        <div class="grid-lines"></div>

        <!-- Floating books -->
        <div class="book-float" style="left:8%;animation-duration:12s;animation-delay:0s">📚</div>
        <div class="book-float" style="left:22%;animation-duration:16s;animation-delay:3s">📖</div>
        <div class="book-float" style="left:55%;animation-duration:10s;animation-delay:6s">📕</div>
        <div class="book-float" style="left:75%;animation-duration:14s;animation-delay:1.5s">📗</div>
        <div class="book-float" style="left:88%;animation-duration:18s;animation-delay:4s">📘</div>

        <!-- Content -->
        <div class="content">
            <i class="fas fa-book-open book-icon"></i>
            <div class="err-code">404</div>
            <div class="divider"></div>
            <h1 class="err-title">Página no encontrada</h1>
            <p class="err-sub">
                El libro que buscas no está en nuestro catálogo — al menos no en esta dirección.<br>
                La página <strong>${pageContext.errorData.requestURI != null ? pageContext.errorData.requestURI : 'solicitada'}</strong> no existe o fue movida.
            </p>

            <div class="btn-row">
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn-primary">
                    <i class="fas fa-home"></i> Ir al Inicio
                </a>
                <a href="javascript:history.back()" class="btn-secondary">
                    <i class="fas fa-arrow-left"></i> Volver Atrás
                </a>
            </div>

            <div class="tips">
                <div class="tip-item"><i class="fas fa-check-circle"></i> Verifica la URL</div>
                <div class="tip-item"><i class="fas fa-search"></i> Usa la búsqueda</div>
                <div class="tip-item"><i class="fas fa-sign-in-alt"></i> Inicia sesión primero</div>
            </div>
        </div>
    </body>
</html>

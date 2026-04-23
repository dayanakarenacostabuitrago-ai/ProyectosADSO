<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib uri="jakarta.tags.core" prefix="c" %>
    <!DOCTYPE html>
    <html lang="es">

    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Acceso Administrativo — Registraduría de Nobsa</title>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
      <link
        href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@300;400;500;600&display=swap"
        rel="stylesheet">
      <style>
        *,
        *::before,
        *::after {
          box-sizing: border-box;
          margin: 0;
          padding: 0;
        }

        :root {
          --azul: #0b2346;
          --azul-med: #163a6b;
          --azul-suave: #1e4d8c;
          --oro: #c8a84b;
          --oro-claro: #e6c96a;
          --fondo: #f3f5f9;
          --blanco: #ffffff;
          --texto: #1a2535;
          --gris: #6b7c93;
          --borde: #dce3ef;
          --error: #b91c1c;
        }

        body {
          font-family: "DM Sans", sans-serif;
          min-height: 100vh;
          display: flex;
          flex-direction: column;
          color: var(--texto);
          background: var(--fondo);
        }

        /* ── Banda Colombia ── */
        .banda-gov {
          height: 4px;
          flex-shrink: 0;
          background: linear-gradient(90deg, #ffd900 33.33%, #003087 33.33% 66.66%, #ce1126 66.66%);
        }

        /* ── Top bar ── */
        .top-bar {
          flex-shrink: 0;
          background: var(--azul);
          padding: 8px 32px;
          display: flex;
          align-items: center;
          justify-content: space-between;
          gap: 16px;
        }

        .top-bar-brand {
          display: flex;
          align-items: center;
          gap: 10px;
        }

        .escudo-mini {
          width: 32px;
          height: 32px;
          background: var(--oro);
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
        }

        .escudo-mini i {
          color: var(--azul);
          font-size: 14px;
        }

        .top-bar-brand span {
          color: #fff;
          font-size: 12px;
          font-weight: 500;
        }

        .btn-volver-pub {
          color: var(--oro);
          text-decoration: none;
          font-size: 12px;
          font-weight: 600;
          padding: 6px 14px;
          border: 1.5px solid rgba(200, 168, 75, .5);
          border-radius: 20px;
          display: inline-flex;
          align-items: center;
          gap: 6px;
          transition: all .2s;
        }

        .btn-volver-pub:hover {
          background: rgba(200, 168, 75, .15);
          border-color: var(--oro);
        }

        /* ══════════════════════════════════════════
   HERO — fondo azul más compacto
══════════════════════════════════════════ */
        .hero {
          background: linear-gradient(135deg, var(--azul) 0%, var(--azul-med) 60%, var(--azul-suave) 100%);
          padding: 30px 20px 52px;
          text-align: center;
          display: flex;
          flex-direction: column;
          align-items: center;
          position: relative;
          overflow: hidden;
        }

        /* Ola inferior del hero */
        .hero::after {
          content: "";
          position: absolute;
          bottom: -1px;
          left: 0;
          right: 0;
          height: 48px;
          background: var(--fondo);
          clip-path: ellipse(56% 100% at 50% 100%);
          z-index: 1;
        }

        /* ── Escudo Colombia (MÁS PEQUEÑO) ── */
        .escudo-wrap {
          position: relative;
          z-index: 2;
          width: 88px;
          height: 88px;
          margin-bottom: 12px;
          filter: drop-shadow(0 6px 18px rgba(0, 0, 0, 0.35));
          animation: flotar 4s ease-in-out infinite;
        }

        #escudoCanvas {
          width: 100%;
          height: 100%;
          display: block;
        }

        #escudoImg {
          display: none;
        }

        @keyframes flotar {

          0%,
          100% {
            transform: translateY(0);
          }

          50% {
            transform: translateY(-5px);
          }
        }

        .hero-tag {
          position: relative;
          z-index: 2;
          display: inline-flex;
          align-items: center;
          gap: 6px;
          background: rgba(200, 168, 75, .18);
          border: 1px solid rgba(200, 168, 75, .4);
          color: var(--oro-claro);
          font-size: 10px;
          font-weight: 600;
          letter-spacing: .1em;
          text-transform: uppercase;
          padding: 4px 12px;
          border-radius: 20px;
          margin-bottom: 10px;
        }

        .hero h1 {
          position: relative;
          z-index: 2;
          font-family: "Playfair Display", Georgia, serif;
          font-size: clamp(24px, 3.8vw, 36px);
          font-weight: 900;
          color: #fff;
          line-height: 1.2;
          margin-bottom: 6px;
        }

        .hero h1 span {
          color: var(--oro);
        }

        .hero p {
          position: relative;
          z-index: 2;
          color: rgba(255, 255, 255, .65);
          font-size: 12px;
          font-weight: 300;
          max-width: 360px;
          margin: 0 auto;
        }

        /* ══════════════════════════════════════════
   CARD — más visible, con separación superior
══════════════════════════════════════════ */
        .login-wrap {
          width: 100%;
          max-width: 500px;
          margin: -18px auto 0;
          /* Menos negativo para que no quede tan pegada arriba */
          padding: 0 20px 48px;
          position: relative;
          z-index: 10;
        }

        .login-wrap {
          flex: 1;
        }

        .login-box {
          background: var(--blanco);
          border-radius: 20px;
          box-shadow: 0 20px 40px rgba(11, 35, 70, .25), 0 4px 12px rgba(11, 35, 70, .12);
          overflow: hidden;
          animation: subirBox .5s cubic-bezier(.16, 1, .3, 1) both;
          transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .login-box:hover {
          transform: translateY(-3px);
          box-shadow: 0 24px 48px rgba(11, 35, 70, .3);
        }

        @keyframes subirBox {
          from {
            opacity: 0;
            transform: translateY(15px);
          }

          to {
            opacity: 1;
            transform: translateY(0);
          }
        }

        /* Header azul de la card */
        .login-box-header {
          background: linear-gradient(120deg, var(--azul) 0%, var(--azul-med) 100%);
          padding: 16px 24px 14px;
          display: flex;
          align-items: center;
          gap: 12px;
          border-bottom: 2px solid rgba(200, 168, 75, .35);
        }

        .login-box-header-icon {
          width: 38px;
          height: 38px;
          background: rgba(200, 168, 75, .15);
          border: 1px solid rgba(200, 168, 75, .4);
          border-radius: 10px;
          display: flex;
          align-items: center;
          justify-content: center;
        }

        .login-box-header-icon i {
          color: var(--oro);
          font-size: 16px;
        }

        .login-box-header-text small {
          display: block;
          font-size: 9px;
          font-weight: 600;
          letter-spacing: .1em;
          text-transform: uppercase;
          color: rgba(255, 255, 255, .5);
          margin-bottom: 2px;
        }

        .login-box-header-text strong {
          font-family: "Playfair Display", serif;
          font-size: 17px;
          font-weight: 700;
          color: #fff;
        }

        .live-dot {
          margin-left: auto;
          display: flex;
          align-items: center;
          gap: 5px;
          font-size: 9px;
          color: rgba(255, 255, 255, .5);
          font-weight: 500;
        }

        .live-dot::before {
          content: "";
          width: 6px;
          height: 6px;
          border-radius: 50%;
          background: #22c55e;
          box-shadow: 0 0 5px #22c55e;
          animation: parpadeo 2s ease-in-out infinite;
        }

        @keyframes parpadeo {

          0%,
          100% {
            opacity: 1
          }

          50% {
            opacity: .3
          }
        }

        /* Cuerpo blanco */
        .login-box-body {
          padding: 24px 28px 28px;
        }

        .alert {
          display: flex;
          align-items: flex-start;
          gap: 10px;
          padding: 11px 14px;
          border-radius: 10px;
          font-size: 12px;
          margin-bottom: 18px;
        }

        .alert i {
          flex-shrink: 0;
          margin-top: 1px;
        }

        .alert-error {
          background: #fff1f1;
          border: 1px solid #fecaca;
          color: var(--error);
        }

        .alert-session {
          background: #fffbeb;
          border: 1px solid #fde68a;
          color: #92400e;
        }

        .field {
          margin-bottom: 16px;
        }

        .field-label {
          display: block;
          font-size: 10px;
          font-weight: 600;
          letter-spacing: .08em;
          text-transform: uppercase;
          color: var(--gris);
          margin-bottom: 6px;
        }

        .input-wrap {
          position: relative;
        }

        .input-wrap .ico {
          position: absolute;
          left: 12px;
          top: 50%;
          transform: translateY(-50%);
          color: #b0bbc9;
          font-size: 13px;
          pointer-events: none;
          transition: color .2s;
        }

        .input-field {
          width: 100%;
          padding: 11px 12px 11px 38px;
          border: 2px solid var(--borde);
          border-radius: 10px;
          font-family: "DM Sans", sans-serif;
          font-size: 13px;
          font-weight: 500;
          color: var(--texto);
          outline: none;
          background: #fafbfd;
          transition: border-color .2s, box-shadow .2s, background .2s;
        }

        .input-field::placeholder {
          color: #b0bbc9;
          font-weight: 400;
        }

        .input-field:focus {
          border-color: var(--azul-suave);
          box-shadow: 0 0 0 3px rgba(30, 77, 140, .10);
          background: #fff;
        }

        .input-wrap:focus-within .ico {
          color: var(--azul-suave);
        }

        .toggle-pass {
          position: absolute;
          right: 12px;
          top: 50%;
          transform: translateY(-50%);
          background: none;
          border: none;
          cursor: pointer;
          color: #b0bbc9;
          font-size: 13px;
          transition: color .2s;
        }

        .toggle-pass:hover {
          color: var(--azul-suave);
        }

        .sep {
          height: 1px;
          background: var(--borde);
          margin: 18px 0;
        }

        .btn-ingresar {
          width: 100%;
          background: var(--azul);
          color: #fff;
          border: none;
          padding: 12px 20px;
          border-radius: 10px;
          font-family: "DM Sans", sans-serif;
          font-size: 14px;
          font-weight: 600;
          cursor: pointer;
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 8px;
          box-shadow: 0 4px 12px rgba(11, 35, 70, .2);
          transition: background .2s, transform .15s, box-shadow .2s;
        }

        .btn-ingresar:hover {
          background: var(--azul-suave);
          transform: translateY(-1px);
          box-shadow: 0 6px 18px rgba(11, 35, 70, .28);
        }

        .btn-ingresar:active {
          transform: translateY(0);
        }

        .btn-ingresar i {
          font-size: 13px;
          transition: transform .2s;
        }

        .btn-ingresar:hover i {
          transform: translateX(4px);
        }

        .login-note {
          text-align: center;
          font-size: 10px;
          color: #b0bbc9;
          margin-top: 16px;
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 5px;
        }

        .login-note i {
          color: var(--azul-suave);
          font-size: 10px;
        }

        /* ── Footer ── */
        .footer {
          flex-shrink: 0;
          background: var(--azul);
          color: rgba(255, 255, 255, .45);
          text-align: center;
          padding: 12px;
          font-size: 11px;
          border-top: 3px solid var(--oro);
        }

        .footer span {
          color: var(--oro);
        }

        /* ── Responsive ── */
        @media (max-width: 540px) {
          .top-bar {
            padding: 6px 16px;
          }

          .hero {
            padding: 24px 16px 44px;
          }

          .login-wrap {
            padding: 0 16px 32px;
            margin: -12px auto 0;
          }

          .login-box-body {
            padding: 20px 18px 22px;
          }

          .login-box-header {
            padding: 14px 18px 12px;
          }

          .escudo-wrap {
            width: 70px;
            height: 70px;
          }
        }
      </style>
    </head>

    <body>

      <div class="banda-gov"></div>

      <div class="top-bar">
        <div class="top-bar-brand">
          <div class="escudo-mini"><i class="fas fa-landmark"></i></div>
          <span>Registraduría Municipal de Nobsa</span>
        </div>
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn-volver-pub">
          <i class="fas fa-arrow-left"></i> Portal ciudadano
        </a>
      </div>

      <div class="hero">
        <div class="escudo-wrap">
          <img id="escudoImg"
            src="data:image/png;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/4gHYSUNDX1BST0ZJTEUAAQEAAAHIAAAAAAQwAABtbnRyUkdCIFhZWiAH4AABAAEAAAAAAABhY3NwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAA9tYAAQAAAADTLQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlkZXNjAAAA8AAAACRyWFlaAAABFAAAABRnWFlaAAABKAAAABRiWFlaAAABPAAAABR3dHB0AAABUAAAABRyVFJDAAABZAAAAChnVFJDAAABZAAAAChiVFJDAAABZAAAAChjcHJ0AAABjAAAADxtbHVjAAAAAAAAAAEAAAAMZW5VUwAAAAgAAAAcAHMAUgBHAEJYWVogAAAAAAAAb6IAADj1AAADkFhZWiAAAAAAAABimQAAt4UAABjaWFlaIAAAAAAAACSgAAAPhAAAts9YWVogAAAAAAAA9tYAAQAAAADTLXBhcmEAAAAAAAQAAAACZmYAAPKnAAANWQAAE9AAAApbAAAAAAAAAABtbHVjAAAAAAAAAAEAAAAMZW5VUwAAACAAAAAcAEcAbwBvAGcAbABlACAASQBuAGMALgAgADIAMAAxADb/2wBDAAUDBAQEAwUEBAQFBQUGBwwIBwcHBw8LCwkMEQ8SEhEPERETFhwXExQaFRERGCEYGh0dHx8fExciJCIeJBweHx7/2wBDAQUFBQcGBw4ICA4eFBEUHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh7/wAARCAIxAscDASIAAhEBAxEB/8QAHQABAAEFAQEBAAAAAAAAAAAAAAEEBQYHCAMCCf/EAFsQAAEDAwEFAwcHBQwGCAYCAwEAAgMEBREGBxIhMUETUWEIFCIycYGRI0JSobHB0RUWYnKSFyQzVFWCk6KywuHwNENTc7PSJTU3Y3SUo/E2RGRldcODtEaE4v/EABwBAQABBQEBAAAAAAAAAAAAAAAGAgMEBQcBCP/EAEcRAAIBAwEEBgcECAQFBQEBAAABAgMEEQUGEiExE0FRYXGRIjKBobHB0QcUUvAVIzNCYnKy4RY0kvEXJDVUoiVTc4LCY9L/2gAMAwEAAhEDEQA/AOWkUogIRSiAhFKICEUogIRSiAhFKICEUogIRSiAhFKICEUogIRSiAhFKICEUogIRe8NLNK3fDQ1n03nDfiV6iOhiz2s7pXD5sQ4fEqxO4pw4Zy+4uRpSkUa9Y4JpBlkbiD1xwVR57GwYpqRjSOrvSK85aqskPF5aO4cP8Vjyu5v1Y48S6qEetk+ZSgZeWNHXJUebx/7cO/VCpZH+kS+UF3XJyVNNI+eQspy5zmjJwOiturWazkqUILqK+O3mT1d72khRLbpGc+PscFSPkrGuDMzAngA3KppHTPeWHtHuHPqqFKs365U1TX7pVSROYeIP1LyLscwqOXejzvtc3HgvltSc+jJnwKyYTqJc8lpxh2FcHNPIqVSsnjecPG6e9fTt6M8DwPJXY1+OJIodPsKhF8QyiThycF6K+mmsotNYIRSi9BCKVVxWu4y03nMVDUPh+m2MkIeqLlyRRopwiHhCKUQEIpRAQilEBCLwnrKeE4dICe5vEqjluo5RRe9xQFzRWKS4VT/AJ+6O5owvETSOdl0jne05QGR5CKzQSeKroXjHMe8KzKru9RcUMlWi+od1w9VpHgcKqbBE4DIe3PdxVr73Bc0VdBJ8ijRV35Pc7+ClY4joeC8ZqOpi4vhdjvHEK5C5pT4KRTKlOPNFOilFfLZCKUQEIpRAQilEBCKUQEIpRAQilEBCKUQEIpRAQilEBCKUQEIpRAQilEBCKUQEoiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiKQCTgAkoCEVS2gqXs3g1rfBxXw+kLCO3mjZ4Zyfgsad3TXBPLL0aE3zRTlw6cUbvl3o5J7gFUNjj3WOiifKHH1nHdbzVTHE4xvcZAGDDcMG6N493UrEqXUpF6FFIopGSE708mCPpHJX1TxNlyYo3yAHG870Wr1hjZSuAewEvfk55kDqvqJ+N9zH8H8S13DA8PqPBWXLhwLiXaeIbI5z2hzGtaMgN5k+C95rZlpJlLmt9Y73BeXbwwMb2O845IORxx3exUL6qdoxE50Y45APDj4L1RnJ+jwPG4rmV9ZTU8FIDBukEZ3lNoYAAC1jXluXv3+TenxVnq5KiWmZAQ4MbxOTxcVW29lP2Bo2Olc0Ave4DAceHvwq5U2qeGylSTlwRW1hYZAyIl73Z4k4AU0cD4sO9YesQOAzheT+zy1zch0QaQ1rcknuyVWNrZZQ0QUrn4d8oXnA9gwrDyo4RcWG8soJ6KWpkLiM5+CttZRsjJA4uWTuiqcvkkk3A7/VtHBo9qtNdEeO63PirlGs84yUzprBYN5zXbruIVbRvMjXRO44GQe5U00Lw/eeCPsVRbm+k93hhZtRpxyY8c5PumB84A8OKrVT0rcyPf0zgKoWRSXolqfMIiybZ/aYbjcpJ6lm/FTgHdPJzjyz4cCq28LJXRpSrTUI9ZW6G0127hcbjBmIfwMbx636RHd9q2xpbSt61FL2droi6FhDZJ3ejFGPF3gOOBk+CtEET5pmQxNy97g1o7yVn+uNX0GitK0ul7RIyWeNu/UStPCSY8Tw646Z7h3DNjO88skkaatYKnS5vr+ZjV78mS4Vfa1dr1fbJqyZ5ead8JYwEnJAeC4nH6oWldeaG1Poi4No9R2ySlMmTDKCHxygHm1w4H2cxkZAW19Pa01pQ36k88jkY+olcynj7Xfc8Dk4DuOeBHPjzW0NR6utGrbH+bGrbG9/nRDR2jCx0b+Qc13Qgnnj3c1cjNGoqWLkt6Dzk40RZFtE0xJpLVVVaDUCqgYd6nqA3d7WM8jjoehHeOo4rHVcNc008MIiIeBWe7VbzM6CNxa1vA46lXhY9cmltdKPHKAp1LGuccNGSoVxoIwcYwqZy3Vk9iss8YqGR3rZA9iuFFZI6h4Z2zmuI5fh3q629jDhsjchVraWIyYhe15HHAPEfgVrat5JcORlwoIx99sjppWCSV/ZvHBwHI+IVXQW/ffuukOAeY6q6VNEHtcSW4kO84k44jr9qoaKd0EbpSC+EHg7HHHirfTSqR4PiVdGovieVdE6krjDjMeAWPcMZ/yV7se6Ldc+KQA9WnIXje54+wjL5JJInOLoiOOD1ae7oQquGtgbamnIeHndGfm/4hePecE8ZPVjefEqKeeN7Qe0aQTw32q407iBw3gD1acge4q2xy0pY+OHErnAgtbxAd0Kp8vZVslje4MkAa4Md84c1iyp7+eovKe6X2WipqtvpRxud1IG64e3/FWuss00Yc6HeeB80jifZj/BesldUQVUcAMc7iMkOGCPHP+eSqmXiBj42TdpEXDILhvN9meeV5TqXNH1HldgnClU9bmY7Ix7HFr2lp7iFCy9xp6qPdljZIOuPSx94VtqrJG8F9HKP1HH71sKOqQlwqLD9xjVLOS4weSxIvappp6Z27NE5ncTyPvXitlGSksxeUYjTTwwiIqjwIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiICUUogIRSiAhFKICEUogIRSiAhFKICEUogIRSiAhFKjhnHVeN45gL6Yxz3brGlx7gMr1dEIou0lDj4cv8AFeMz6x0QaAYRIfQij4E+08/rWPK4T4Q4l1UsesVTKRjMmpmazd5sb6Tvq5L1iq6SJg83Yxpc7cDpHcSe8+HwX1Q2aubTmBsb5ZXu3i1jeRP+eqvMenIrQAK2lFwvE3ow0YyWQk8i/HrO/R5d/csaVKpWfpvh+fzxLynCn6qLCZX1b3MZWj0XbpDOG8cdPBU8j20z2sbC13o7pcT84nn4+xZnS6SprBSCuuYbNVOG92AOGk92R80de/kO9VemdH+dl2pr2zsqYHNNAwBvanvx0Hs9vdkrSSeFyDrJrPWYm21T09H57PvR00w9EPPAkcc48OXcviNnnlI6WOKR7WgvLsYwAcZPdxwB7Qs3fYK7VNyM0wEdDD6HD0WBreO4O4DqfvK96PTjNR3qHT1rhdFZqV4mrp2t3e1xyHgOjR3ZKqVlxzJlPT8OCMZi0xV1Fup6mKnl7aoIbBC1m96A6k9PDvVFerJNQV8VBSv88q3NxIyBu9uu6tHecc8Ldl8jka5lss1OTUS/JM7MYOMY3W9wx17u4Kps+kKXS9JJWVgjnuTmntJDxbGPojw7z1V2NrBLiUOtJmqbZoqKzUjLpqPdmmcC+KgB4E9N9w+aOuOZ5cOKoLZph9VPJdKuBpZI4mGGOPAcSejR0HQLMGUlVr7UM9PSyOFppnA1lWP9YfoMPj9nuzk1dQukmistmiDHub2faAfwbAOOO5oHvPLqrypxjyRQ5tmlK60VE9W6jpachzDhx4EMHeSvq/W+KwwRUkETn3J+HSDn2TMcGkdXHme7gOeVuO5W2j05R9jQxdpVO9VxG87ePzj3u7h0WNT2anslG+63iLziqlJc2Eu9Y9zj9Edcczw6ZVLpRawz3fa5Gt6UVvYv89puze9jXxDc3d5pyM+zgqKZlZFAWOqHtGd7dBxjqrvfqi5VFc66XOXdMpDwxrcYa3g3A5AAcAMKnmMdVRiZzTHvdHc1rKsXSny4GZBqcefEp6BskNBuCojL6h+8HPkHDIH1ryvMsggELnsbgYJHDP4qhjLYLlDKGnda8cgPvVdeYcuJ3mtz7ym6lUTfWeZzFosTmlkGN7Icc8OSqKYblIXd/wD7KnlBb6G/vAeGFVt/0RvsCzJ8kWI8yogbuxNHfxX2oj4safBfSzVyMdkLcGyXSNdT2V97vErKS2VID4o8fLSgcnDo1p8c5WomMe84Y0krYt411cLjYaG00VOYhTUscMj3O4AtaG8AOfFWqtSMVhnkbuFvPecsNGxPN9PVFuF2pNROs7YpHRPE27IXFoGd0DBzgjln2KyTXvQVv84lpo7jdLk5juxrKiJr2sfjgd1xA4HjyWEWrS91db5Kzz23VDXODgxtUBISefouweivum9GSXOjfU1VSab0ixsYZlwI+l3exUReVwJBbXULikpqeS2acuEzdSx1rzvTveTv45OPXA4f+63/AEbIbtQU4rImTRSxiTdd812Oh5habtGj7hR3+COR0Uu8D2ZjdzPLiDywMlbxtFGKSljjwfQYGNzzwPxXqL1Zr0WjWm3zTNsi0H5/SUrIpqOoa7fHElrzukEnpnHwXPS612q2W56h0NXWm0U3nFXMYyyPfDcgPaTxJA5Bcwal07etN1wor3b5qOZzd5ofghw7wRkH3K9DkaW9/aZLSilFUYhCtN9hw5kw5H0T9yu6prmwPoZcjkMhAY4rpanNyA7qrZ3qstnGQBW6qzErhzMxpIWiHtQ4Fg5nuX3Wuo6aSMyS9jM8EseAc4HfheNBAyeDs5BvNPjhUM80FVF2HZymaB5DCSDu8eIK0ihvT5mwcsRKo74ibFFWiRknHdfguB969Y6ecPI7Fga5oGW5HHOeK+aOibKGud6D28Q5XemoK66QSi2Sxmqii32wHg+UA8dzPAuHPd6jOOXFlyluxPOSyzGLw4smdFJCx0LncAW4wccx7wfavFlNHJBI2N7ongbxjPqvx3LJrTAy8U0lquIbBLvF9NM7IEchPFp7mOPwPHgCV90lifDW+Z3Fr6ZzSWlxZndPiO77uWeS2UaLUUjEdRN5MXtNPWVNWynoopJKg5LWMGXHAzwHVe8UzmARENaQ8k56dDw96yq46emtcjax0bsx4kbJEc5HR7SFeZbHRaupG1LCyG743hKwANqvaOj+/ln286p2+eIjVwYK4YlzCW9o05Ljx3u/3HmgjDwXTh4dG4uyBvbwPM+5Xy3WWKkqJbbeIXwuJHZ1TAS6I8eY+cw9RzGOHLBm6WGvtbJDIN8Ab7ZIzlsjPpNPUf55rGlazXIuqtF8y0D145wwxlzfTJPUcse7KRXSphhYx72zy5aS144tHtHu+KrK+nqqegp6yECopJD6L93nj1mOHzXj6xxHAqobbILlbJqmge3z2NuXwubglmOY78cjjiBg8eOLDoS5SjkuKoupnwLlTva5tSyVjc7pBG+37MrzktdFVs36GoaD3A5H+CtFmbNNUyQvbI+QcJGcyd37TwU+cCK6R0raSRxkOAGni8k+iWnx+1URo1Kcv1TafuKnUjNemsn1V0NTSn5WM7v0hxCplc47nWRvFNICyZhLZIp28/vBXzXvt+9GJo3Uz5ATvR+k3PiOfwWbSvJp7tWPl9DHnQi1mD8y3Ivd1OSztIXsnj+lGc49o5heKz4TjNZizGlFx5kIpRVHhCKUQEIpRAQilEBCKUQEIpRAQilEBCKUQEIpRAEUogIRSiAhFKICEUogIRSiAhFKICEUogIXrTU89VOyCmhfNK84axjcknwCy/Zzs4v+tJTNSxea21jsS1srTuDvDfpHwHvwt32bR1g0fQltBTiSbdxJVTcXye/oPAYXjYND2vQt7qJW+c0j6aLm+SQYaweJ+5XWotNptR7Oip/PajdwXEHdz345n6h4FbZr7ZWXH06pzoKceqw+ifh80fWvLT+m6O4XI0VJT9o1mHzy8mMH2uccHGe4nBxhWejTzv8AEubzXq8DUFu0rcrrOTFTl7yclxGI4vaeWfZ7lnOj9l0NZLLWTVHaCnfuyzkeq7Gd1jeQOCOJ5ZCyjW9zNLcqHQukqZlRfKxzYYYmerAD853uyePTifHLr3SWbZboERVdSZWwHeqZ/wDWVtU7mRx7xy6ADuKuKKXJFLbfWYJfobdpuhMdFG2J5OA/GXbx5Y6lx6d3RXa06Nh0/QflC4RCS7Ts3n73HsQfmDx7z7uSpPJ8tc+0fWFw1tfGt/J1jc0UVHzYJnZLXHvLQM57yOgwqPaTrlurdcUOhNJ1rWflCvjopriPVDnvDMM8Bn1uvTvVWCkqbBpP85quS71o37XBKWAZ/wBIkb8wfojqfDA64qrpRS3/AFB+QreWkwM7SpePUpYvpO8T0b18Bki/bftSWzZbpSg0pp1rG1wpxDSMOCYYhwdK7vcT38zk9CF5aBqrFonydKbWNyeX1l3kkqKp73Zlq5g97Y4weeMNz4eke9AWa/0bGz27Sdmi/fNY4QwQg+k8DiXO/RAy5x+9ZPquPT2z3SpYXNgpoeBd/rKiU8z4k/UPALH/ACXrlFdK3XW0fUs0bDRQRRMkfyp4nb7ntb3cGNHec+PHS+uNXVm0PaFBPXSGO3Pq2w0tOThsMJeB8SOJP3AJgHQexq1VVRp6p15eom00txBFvifyp6Uc35PVxyc9wb0K1TtA1ZX691RDozRjXyw1EvYmZuczd5z0jAySeoB6LPPK/wBd0drgg2daZkjhZHExtaIDgRRAYjgGOXDiR3Y71S+SRa9OWjQmpdol1lYyoo5HUpkkAxBEGNeS39Jxdj3ADmvQZCbFbNDaWo7FSZkdvNibutzJV1Dzj0R1c48AOg8ArjdbdbdF2GeuussMNSIw6tnLstYTxETO/py4nh4Aag0VtFZqbyhrFfdR1cFFZaWqkdTsneGRU7dx245xPDezu5Pf7l8bRNolDrzbBZaJ7DLpGmu0LDCSWiqYZQJJHcjlwJx3A9MleYBsTS9uqK21u1bcqd0DawE26B49JsP+1d3Od07m+0rE20kOqrrV1Yc2WhoHiNzs+g+QDO4O8AcT7ueSsu8pPUrqvVNt2a6bqGRXC5TxU88jDgU7HuDWs4cs5yfD2q7XDTNFpy00Oj7RwEcZ9Ij0nY/hJn+BJ+sDqEPTSF70+L3eKiZm5FR0zcvkkzjh3/HOPEBYHW2t01VNLC2SWKAFzT6mWj5x44HTrzOOK3lqOgj81dQwuEVBCT2rjzld1Jxz68OpzywtcXSJtQ2SWaR9HZYnDe3CO0qH9AO9xzwPJoOfbYq095cC5CWGa3rIe1cWR4c4HBDeOCq2Bpko207yxskbPVa0jgOGSV71gijuDuzPmseS4Njbn3KjjlfFW9rPhjZvRbkZP+HTitfNPl7TKi1zLVcoyx+eJxwSjkD4zE48RyV2uVKxzN5hDweIIOQrBKx8EnDIweBV+lJVI46y1NODyV8U3ZfJyg4HIqsoezqqpkDJBlytsNRHO0MlADvtVys1GwTum35AGDGAeeeiuOvKMcPmYd5JU6Mpp4+peI6dzpY6OhhMssjwxgAyXOJwB4nK9Yw5k8EeAXte3kOa+rBV1VJe4a6jlZDNSETR9+QRjHfxPLuyvejmilvkbXMLGTP7PDXAbpdwacnoCR7hhYby+HWRScXJJPmy4U8rmytY9ziHtw0DlxPBZBp/VE9nk82qWumpc8W59JniPDwVNbJqC06vt9ZVxMqqSjq45poxxE7Y3BxaM9HYxx7+KoLqBU5qWwdiyT02tbk7gPTj0WNCbptSTMK3ualrONanLDzj89qNw6VfBc9Qw1UHpxspA5p5cXHP2ErO1g+xaOh/NJk1LKZZ94xzkjBaRxA9mCOP/ss8p4ZqiZkMEb5JHnDWtGSSt1F5SZ1WjWVanGoutIvmjLeayoqZCMtiix7yf8CrBtG0bbNU2mez3SLiMmCcD04XdHN+8dVt7TliFmsLYJQPOJPTmI7+73fisS1PGGVmR1V+KwjV3FRTqNo4E1TZK3Tt/rLNcGBtRSybhI5OHMOHgRgj2q2LLfKbvRn2u3KKjezcp44oXOaAcvDBve8E49y1pFdKph9ItePEfgvSwX5Ut2kEdDJk8XeiFRm8nd4U4z+sqCrqZal4dIRw5NHIIDx71X2iMulHPGVRRsL3BoWRWOlw5uW5Vi4mowZcpRzIvcT/ADSgfOd70RgFoBIJ5HB8VY6OCUSdtFjfJyRyDlcbke1qhSPbuMYA5r+I4Y69CMqaWPJxF8qwA774iDuYGc/Dj7lq6eYx4c2Zk+L8D5lujn0wFM10c0bvlGubwVdZoKptUKtglDAWucWu4sd0I+CuD7fFBU0twbDFXUpOJDjn+i8A5BxniOfMHgs50/Z6WlrI3UmZrZWtIi3jkgHiY3HvB4g+w9QFnW9GMUpJfn88jGq1G3jJ8tsrbzTflFrWCvYA6QhuBO0/P/W7+/nzyrzQWmK6UnmlQ3M8I3GOPB2OjT9x/wAMTWOk0XWU1XVQulskz9ySRjfSp3nk7H0TxyO/68r1Pp2ufZotWaT3amqpohKI2ekyspzxLeHM9Rjjz71l4LJjtBa5IWut9ZCZIuJDSP6ze7xH+CxC/W2fQ92ZWMjdNZKqTDmgcYXeHu4/V0W6tGvt20DS4r7NKIagHd9MAupZwODXDq0/WD0PKh0x+RdoVjuNirImw1sO9T19GXenC9pxvN7wHDIK9QMdFnoNUWqKqZIyVzm70VSwZz7fHv8AxCtVFbzT1E1jrow/ssOdGebQeT2eB+vGDxHDGLPc7zsk13UWC8skntwk+VjA9dh9WWPuOMcOvI8Rw2ttXsUly0ZRbQtJSiaot8fbiSNuRPSn1g4dd3mQeXpdUwDXv5uSWWrlhfB5xaqp3pM6eBHc4ccHu4d4VFVaWktdXFV0byYHO3opW8C054ez2dCtnbN7vZtoFhlp2YhrGx7tTTZ9OPPz294zxB6FU+ng03yv0Ve4mMulOMhhGGVURHCRntB4t6ce7gBrTUGkfPGi92qIw1bCDPFEMHP02Y+7ly7lZp9PNvkW9IwMqwMhzRjtD347/Dr7ee3qjs9Kalp7VeXFlHXZNvrpODXd8Uh6OHf1BGeKjXen4rBEL92JbQGQNqy0fwJceEn6pOAcdTnvXmBk07JbHXMNoL4TFXRtDYK13EkdGyH5ze53MYweHK13PTlbA00twhIez1XjjunwPcfrW9LhpgXm1ecUfZSVBZ2lPLza84yOI6O6/FWHS0lJeqeSgqIyyopSY5YZR8pA4Hi0jq3Of85ColTi+oqU2jSLaCZpOMwVUfEZ4b/+K9qemmrHNhZHmpJwG44uPdw5/Wttas07QW6opY6yEtp6pxjZKR6McnRu90zxx7FbKzQ1W2B9RTlsrYznIHpAE9R1HLiPqVt26zlPBUqr5NGsqikqad5ZPC5pXgtpxUb2g013o+3iHolzuD2gdN7mOHR2QFTz7OmVzXSW2tDzzaxzMSAeIz6XtH1K4nOOE+PeUtRfLga0RXS/WK5WWbs66ncxpOGyAZa72H7lbFdKCEUogIRSiAhFKICEUogIRSiAhFKICEUogJREQBERAEREAREQBERAEREAW2vJw2Vfug3ue43USM0/bHNNSW5BneeIiB9nFxHEAjlkFalWcWnaXf7Vstn0Bat2jpautfU1VTG4iWVrmsb2fgPR494OOWcgdNVGr7DUagi0Tou3/lSWmbuOioQG0lGwdZJOWB+jnjw4lVdyt8FNv1VTMyR0QJdK7hHFjnu56/pH6uStz7jobYXsstlHLEPy5X0UVRU0kbgaipnLASXn5sYdkDpjlk5zzLtD2j6l1rUu8/qfN6EH5Oig9GJo6Z+kfE+7C8wDeNhu1PrvXkOkdMzMqHbrpautPGGCJvrEdXnJAGOGXDirntp1PZ9lFgFisQEt7rWlzXSHecwcjK/4cBy4cuedAbFdfybN9aDULLeLg11NJTyQdr2eWuxxzg8iAeSx/WGoLjqrUtdf7rL2lXWSl7u5o6NHgBgD2L0G1/JKv1sodql3vWprnTwONoqJBUVUgBL9+MuwTzduh3LjjKw/bdtCqNfarkqIt+K0Uziyhgdz3er3fpO+rgFgShAbD0htOrNMbJr5oy2Uzoqy7VgkfXB/FkJYGuYBjmd3n3OPXCwS11tVbLlS3KhlMNVSzMmgkAyWPaQWnj3EBU6IC6aq1BeNU3ue9X6ufW18+N+VwA4AYAAAAA8AF4VV2ulXa6S11NwqZqGjLjTU75CY4S45dut5DOOiokQFwo71d6Oz1lnpblVQW+uLHVVMyQiOYtOW7w5HCt6IgJe58jy97nOceZJyVV091udPaqm0wV9THQVT2vqKZshEcrm+qXN5EhUaIAjSWuDmkgg5BHREQF40xqGtsWrrfqVgbV1lFUsqWioJcHuac+kea7Bs9FXS6Yi1FdZ2TXzUcLK2YxcWUlO4ZiiZnkGg+9znHjhcURt35GsyBvEDJXflytNNp/SdHaRUbtPbbfH55WOcfUYwDOT34OO4DpwQGmtYxRyNkjLhFRwcJDnHLoD9pWvaelfqJzqqJhjpoS5sBe0tjZGBxkyenPj4K/PrnbTdTTUFsjkp9K28h08nFrqg9GnqATnhzwCTxwvTW08LTFYLeGxMeMkMbza0czjk0cgO9U+B6aq1RFbnz9na2uLWDs3SvPGV2SS/HzRx4DuA6lYy/s5YXNw97muEbHvPo45cFsLUlngpKRtEA51yqMCOIH+AZzLnd7iOncc88LFYbO+pun5O3RF5sDv9pwawtzvPeegbgk+xYVWnLOVx/P8At7zIhJYLfSVAic2kqZGNY0brHnkTn7l4XCkie6YBwPZkb3tPIL2uEdMysJpmSzRNJEHajBI+k4dCeePHCpoqYzvlefVB4gcsrHUN2W8n+clzeysFnmpnCRzWHeAOMrLqJgitNPHHwJjDnHxIyrW6naIWOAwHYxnxV3l3WQNjiOWNGN7vVVSpv4RodZWFCPazztwaKqb0iXhnA54rIdD0X5T1LBapYRKLgySniG7kmbcJi3e47+5y6EjkSsetu46GRzSN9ryc+BH+CueltQS6f1Pa7o2EVDaKviq+xLt3edG7ewD0zghUxa3ss1tOk53Ch18DKdZW9trvNXbWHtH00hge7PBz2nDiPDIOPDC9J6yquNnpJ6yBrGws80gljYGh7Y2t4HvcN4ZPiO5U91uNPcqaOthEhfOXSSl4wS8uPD2AY95KuFG64XTR5ihi3KCyvbvhvHMk5dmR3dncY3+a1YXVJI0ThuqpDs6vDq9iyZ55J+pH23aazTctNBUUN6BbI2VgJjkYxzmubn3g9+fALsyGkpKcl0FNDEe9jAPsXAuxa7UNh2wadud0jd2EdVuEt+aXtLA7xALgSu+ZpgG81t7CWaZKdEqudthvkyluLwIytPbXNRUum7HXXqqcNyliLmtPz38mt95ICz/WOobZZqCSrudwpqKBo4yTyhjfiVxB5Re0yLWl5bbLPK51npHl3aYI7eTlvY+iOntJ7lkVaigu83UI7zNOanknulVUXOodv1MsjpZXfSLjkn4lWD3rJiOisFwg7CoLQPQPFqtW9TPosrqx6zwUtaXO3WgklV1tEcjXCWIODcccdCr0y2xU+7NHGHMd8Wnoq6ldU3hophTcuRbrXQkvG8OPesj+ToaUyuALmkN4EcyqeCaFk7QIubOI5Yf3ew8OK+XkzzOmqWbrXkRmPuOOBWuqylVl6XIy4JQXA8mkR9pWTN7FzSDutBwQT0VztD6qhuQulEwNYSCC1vo5xwz0zz4HnxVNS709PGXjejblkkZHEZWUaLqPyfO621MQnop/RfG/k8fNI7nDPA/irtKLlLis/n5fMtzeFwZe7XTwSM/Kttha2CThV0RBIZ34H0frHwJzHT1vipnBrSXW+pI3mk8Yn9HZ+/u48MFY/PQ1enJortbWmstjsmVoHplvXh9JozkciFsTSTKGtt8VbRSNnts7fWaOER6gju788vZy2KMUyrT9qodRtq9G3uNhq5aZzmBwwKqHlvt/TacZA8DwB4aq2D7VqHR1ovOmNTzPjip4pn2ybs3Sbkwz8kQAeBPEHkDnPNZ/tgpmU2yWtrnyVNNdrS6OW21sDi14DnNY5u+3l6LiOPMY5kFclniclVHhmux3aFX7O9Wsu8ERq6OUdnW0hfuiZntxwcDxB+4lUlu1rX2vaVNrS2MMMslfJVGBzshzHvJdG49QQcfWsURAbs8qXWWlNZnStdpyWOWcUT31no+nCXFu7E897SHcPHxXlsQ2s0GmNF6h0lqZtRNQVVHN5g6Ju+6OV7C0x+DXZz4EHvWmEQF80JqSt0lqyhv1CcvppAXx54SMPBzD4EfitmeUXq+y3HX+nNXaKurHTi2RPeYj6cEoe87jx9IAgELS6IDfu2DaJpnXGwy2OjlhptQtuTPOaED0mlrHbz2/oHeGPbjoVkXk464sep9KV2itbVdOx9PSPayWpkDRUU2MFpJPFzR9WO4rmBSgNk7HNpEulLpFbbpvT2KaXDgeLqbJ9dvh1I+HFZV5TNv/ADT15ZdUafmbC650hm7WEgslc0gb3cQWubnoVotXS8agvN3tlsttyr5qmltUToaKN5yIWOOSB9XuAHIBAdM6DfZNq2haimmjY2UsEVZA0+lBJ82RvhkZB8MdCsL0hd5tN6vqtn+rpWNqqWTsaeqcfRkaQC1rj4tIIz34PFav2X60uWg9W019oPlGNO5U05OGzxH1mn7QehwvbbFqqk1ptIu2prfSzUlLVvZ2McpG+GsY1gJxwBO7nHHGeZQG97xZJqCrENREZ6V/8DI/1mfob3h0z078FU0NhEThLR8OOTG7gPd3e5VHkxa7p9XQ/mRqVzJ7hHH+9JJcHzmNvNhzze3Gc9QPA5xPU2t59ne1C8aWq2yXWzUdSGxOcfl4mOAduhx9fd3selxOOYXmOw9yZv8AkakvFLJTV1KybeGJY5WjPv8Ax+tap2j7Hq6108t304ySromZdLTc5IRzJH0mj4jx4lby0hcdO6ztxqLHcBPhvpsjduVNPnw5jiPYcdVZLnq7UWze/wAUWtqU3TTtU/dprxSwBr2foyMHok+zBxkjPIEDk7CLcflN6Os1nudp1bpqanks+oonysEBywSNxvFvcCHA46EHktOL08CIiAIiIAiIgCIiAIiIAiIgJRSiAhFKICEUogIRSiAhFKIC7aTnskV2ZHqOjmqLZN6Ezqd+7NCPpsJ4Ej6JGCMjgcEZ5qzYtfqSzRal0jUR6r0/OwSR1FE09swdQ+LmCORxnHXC1atm7CNqdy2fXtsEkrpbLUvHnNO45a08t4d3u+vkdTqcLynHp7N5kucXyku7sfx6yuOOTNZOa5ri1zSCDggjkoXdOqdm+zna3aBeIIG0ldM0OFdR7rZQSMgPA9F/t6jkcLmvafsK1portKuKn/LVqbx86o2EuYP04+bfaMjxWv0vaqzvpdFP9XU/DLt7n1+59x7Kk48TWVwray4VLqqvqp6qdwAMkzy9xAGBxPHgAAqdSRg4IwUUmLZMe6HtL2lzcjeAOCR7ccFufZhp3YXqyogt1zu2pLHcZTutZVVMXZPd3NkEeP2g3uWl0VupDe5PBVF4OldrPkuVNksFTfdGXWourKdvaPoKiMdsWDmWObweR3bo8MnguaSCDgjiux/Iu2o3DUFLUaDvsslTUUFP29DUPOXOhBDTG4nnulzceBI6BYV5Xux8WS5S6603S4ttU/Nxp428KeUn+EA+i48+4+B4UQqOL3ZnrjlZRzailFfKCEUoBnogIRThEBCKUQEIpRAQMg5HNbTqdr+rb/s3bs+midWVdVUtY6vMhdPOwnhGR1Od0Zz6oxhatWf+T3crFZtrdnu2o6iGnt9IJpXSStyA8Qv3PfvYx44QG9KLTkGzjZ9SWoxia4SEdqyPG9UVb/mNPcOWe4E9CsYu9NDYKKWuq3RSXBw35piPRB8PAcmj38yst05V1etK2q2i3WM0dtHaQ2OmlIHZQjhJUP8A0nYxnpg+1YbbpBrjUdRdWsI03aJMROII87nHEH9VvA49meeB4emNCknt1O68VUTnXOqJ82jfxcwn5x8Rz8D+qVj9fZJWRPsdJxqJ8PuU45gcxCD0HDLvEfo8dq3K3TyVrZezBrZfRgYRwhb9I+zn9XtxDV0Apqaa025z2g8KyqA3nuJ+Y36T3Hh9XAAkUg1xd47e1pipCyXzbeE9Rn13cMgdzRwA68yegFToq2xy0F2mqWN7KnDXvJ6tLXOcAe/DAP5yi7WueCgbapKdlJM9+HR5BMbSSBvEczwJJ9vTAGb3uzDTOxqHfY5lRdWCpkDubWPI3AP5oYfeVbhSUSuU2zVdQIqiqpmMwGFu84Dp3j6l61xAacjDQODQqK2hrq1pd04tHeeiqa9wGcHJ6la3dUZbqNJq05TuYp9h9UeBS9o1uHjIcPpDmF5sa2SpzjPDIVSMspmgt3XsG64eC+ba1slQ/hxA4HwVucsQbGnRVS99vivz2GRWve/JgfJuhrMtaO4dSqy06mr7dbquyskZDQXGRrp8N9KTd9Xe8ATkDHAnKo6KNz4N15xFGd7H0ie9U7sNropXt3xvY3COh8PesSnLg2jT3FFU76rT7c8u/lx7Xzfd7S5RV0ttuENayCnmfC8Paydm/G4jlvDuz4q7aj287VLtvRyalkomctyjiZFj+cBvfWrDcGt3CWcWYxjuWK1LcSOBOTk8e9X6NSUY4TNjsvPO/B+JF6ut0vFU6rutxq66odzkqJnSOPvJVtKqJAvByyE8ktaPgrwq6ZtSwMPrZ9EqoPJVunaZtbqC3Ub3brZ6qONx7g5wH3q7B4kmUSWUeWn7I6LVFtp5C3sqo9m8EcPSb92fqVyrGS00tTbWwHziEjdafnYwSB481mlxsLvPNN1LYy3s6l0EpHVwD8H62hXXW9hLLgbjTxHtoy2qBHUEjez7DuD3lZ1WmqqSZjwm4PKNWVLY3ugma07sgLXjqCP/AHVfZ2zUcrpK6DzmleCx2+MCVgA3gD0cBgg9Dgqo1nazaLv20THeaPYJY2ZyS08ce0Aj4K4UlRFSUzI6yB89pnwXyN4mEn1XgfUenIHmFjfd3HCX5619C70u9nJ4fkMi9x0zKlraetYDT1Jb6MjT6pP0SDgO7jlZZaKJtzpBbbkwQ3Ck+SjkdwyByY/w7j05cuU0lnDKf8mTPa6nlPbUFSPVY8jv+i4cPcM8jm6so6urpvOoWYulGN2WJ3Dtmjhg/Zn2dxWVGEY8iy5N8y7aJlnbUy2W6Rbspzuhw4StHd+m3r8e/FnudTdNlGsYbtb4zNYbi/8AfFKfU3h6wH0XY4g+0cgsqtEFPqSyxVdJK6KeM/Jy4+Ugkb0cO9p6HmOHEFZRFZ6PaXoq52GpZHT3im+TqIesE4GWSDruO7+4kdCq0UmS7S5tOwbE7tVV1TB+S7pa3SWt8jsb8rmb0cYzxJzhwA5YI4YC4fV5v9dqCKJmmbvXVboLTLJDHRySl0dO8OO+Gt5A5yrOqjwhFKICEUpg9yAhFKICEUq/6A0nc9Z6mprHa4/TldmWUj0YY/nPd4D6zgdVTOahFyk+CPUm3hF/2MbLL1tLvMlPRyCht1P/AKTXSMLmszya0cN5x7sj2rdWsth+xbZ9YYqvWer74KmQfJxwPjEk567kYYSB4k4HUraUf5C2O7JKmpoqQupbVT7+7nDqiZxDQXHvc8jJ6Z4cBhcP611PeNYajqr9fKp1RV1Ds/oxt6MaOjR0CwravK5bkuES9Ugqax1n1rSTST7pjR9JeIaFuRvXKeN8knccMaA32ZcrEpRZ6LBVWe411nulNdLZUyUtZSyCWGaM4cxw5EJeLlX3i6VN0ulVLV1tTIZJppDlz3HmSqVVlntVyvFfHQWqhqK2qkOGRQRl7j7gvJSUVmTwgLJdblZLlDcrVWTUdXC7ejlidgj/AA8F0daNpjNrOyq+6HulqqPzofSh9K+jpnSR1T2Pa5uQ0HsiSACThvM5HJU2zDyYa+rEVw13WmhiPpeYUrg6U8eT38Wt9gzz5hZVta19pfZHp5+ltn1voqW5yt3S+Ib3Z9C5zuJc4d5PPh0OItX2npVK6tdPj0tR9f7q72+v2eZdVJpZlwNBbQNMzaOsdJYtQ6g88u8bnSR2iml7SK37+7vOkdy33Bo9FvcCTyBwBe1ZU1FZVS1VVM+aeVxfJI85c5x5kleSkdtTqQppVZb0ut8l7F2fllt46iEUor54QilEBCKUQEIpRAQilEBCKUQEoiIAiIgCIiAIiIAiIgCIiA2vsF2pVujrpHbquqLbdK4Br38RESeTv0D9R4jrntLTN+or9RCWBzWzNAMsJcCWZ5Hxaeh6+0ED81luPYTtNns1ZT2a6VroY2kNoqon+Cyf4N3ew8OfL2YxBNqtmY3Sd1QWJrn39/5/3v0qmODOg9pGxbQWvJamalbFabzG7dkqKENGH8/lI+RPHOeBPDiuadb7EdWaQrybqY3WjP8A1pBG+WJgzwMjWguZ8MeJXX9untmqw0zb9BeoGcJqd+5IG55td85h6tOcZ9hXjSaluVruLrRqJkNTuvaw1LGhmWO4CRzeW6eZxjHEcccYppe0Go2H6pS3kv3Zc1/K/wAruLsqcZcTlnS+wqTUdOJrXrex1TevYBzy32jII96qNU+Tbra1WuWvtlTRXoRDedBT7zZiP0WkYPsznuysf2301TojbjenWCd9ucydtTTupT2fZiRgdgY5DJIxyW6dhPlDUVykgsWuXw0NaSGQ3ADdhlPdJ0Y7x9X2LplvWuqlKFxCW9GSTxhZ48eoo/VPhjDOftkOranZ3tLt1+lhlDKaUxVkBG650TvRe3B6jnjvAX6DVdRadS6aZUwOp7ja7hT7zSWh0c0bh1B5gg8isG2x7D9K7SaN1yh3bXfSwGOvgaCJeAwJW/PGBjPAjhxxwWg7ZdNr+wJzrPdLR+VNOdpvNwHPp+J4mOUDMZPPDh47vFZVddPD0eZTD0JceRS678nysZqOo/Ni5UjKCR29HDVucHRZPq5AO8B0J4/afXSfk2VtRUsfqDUEEMAILo6Jhe5w7t52A34FZtp/a3RajmbPJpm/0jz63Z0bp2D+c0Z+pbWsFQyqp46iNszWvGQJYnRuHta4Aj3hRd6pqNKbpVHj2L4mx+7W8lvRLNo3Yls0s7mSM01BWygYMlc50+f5rju/Utk2/Rej6anDafSljiHc23xD+6vi28MZVr1ftV0Bo6J8d91LRRVLDh1LC7tZge4sbkj34W6spzqLLbZiVVGPI+9TbPNCXSklhrtI2SQPaQXNo2MePY5oBB8QVxf5SGzSh0DqClmsrpfyVXh/ZxyHeML24y3e6jBBGePPmty6t8rKxtlfBpzS9bXNxhs1VMIQT+qA4ke8LF/KEvsmqNnLPP6RlLX00kVVusPonI3XNAPEEb/1FXZ1K1CvBvk3gpUYzg+1HNaIi3JiBERAF6UnZedRduCYt9vaY57ueP1LzRAdP7f7/DdrnpzZToCWIQV8VPG58TzuticAIo8/R3fSd4EeK2RQaQtumrFBZaCLfpLXG2MEDLpZyN5z3ADi7iCPF3LgFx1s31INI64tepXUpq/MJTKId7d3zukAZwccSF05f9qNPpO0bO4byO3q7uyG7XR27vGOOUl+8B3l7uA6BnDogK7UFrltMEj5t1ldUA9c9kwfh17zgchlYXVWuO0UxutbARJGCaSndxc0keu7PN558eQ59cbvq7W2q1Q5lU6J9TFF53NCeO61pxG32Bxzk8yHe7AJ4aLVVA2qgeJ4auvlpY5B8+OIntSD03ix+OPJrVS1k9yaAv8AS1NLo6r1JcQBPcKkw0oP6Q4nvwGA/t55rN/KZrmnS1qcMZqYafA7h2TXKzeUlU0X5N0zR0NTDMH+dVMpieHNyXhrRw6gNx7lT+UPdKOr01o6GnnjmfJbopiWOyBiJrftyPcV5UluxyexWXg1PaYjl8x4NaMA+K+pt6SoZGGjDjgZK9bWHupC9x9Bpw0fWT9a8iHurI8ODCT6JI6rU88mjq1m76UpNcPbyK2scS3ex6YHEJZQ0mR+OOcLzrH5y4AgjmF922Roj4c88f8APswrFb9lgv7P0/1rl2GR0g34nh7gIm+k7x9vgqKu4Htclrs+ie5TRSl87I94Bjjlw9nFfdfhrDI4cT6oKxaPDgavW6bo6m31Sw8e558Wn7MHq2XzqAOkaWvI4Pxje8VjdwjMU72HvyPYsjt73m3thmjLRx3CR6w/HOVYr4S2QNIz9F2eOO5XaXYXdIq9DqU6dNLdeVwfDHavzwLTIvF3NeshXi5ZcSZM+Sr5s+opK/WlqpowS4zh/Dub6R+xWM8lsryarc+47U6UNbvNgpppX+A3d37XBX6azNItTeEzbVdZ4oo9+X0WefwSNOORdIxuPfwVz1VZWdpDvtOI2EEDq153T9mfcFmF008Ja+xUG43NdeYhh3dC18x/4A+KuupLRDUVVU+B8c0UcghDmEOAIc0FvDqHF2fHK2ODFyc76/sEbdIipniGbdIGuPUxOdggH2O+pY7pey+eTMs007YKmEOfTOeMtkHEOYR1bxGfA+C3Btnthpdld+qC3GGxZPiXxfitcact0130RZtR0D3srqB74ZnN69ngZ97C3IPMNXq5ArtMUTaN77NXROFC+Tcax5y6klPzc/RPQ+w+zK4LXUwVAOAaqDhvHlMzpnh3fX3443Kgtv5xULallOIq5reykjJ9GQc90+B5g9CFl+lbP+W7cIJPQuVMzMbnjDnt6Zzx7g7xweHBeJA1JfZKjQt9h1hQwSTWOvkEN2pQOMb+jx3O+okc/Syst1h57Z6W2bW9EStqhRxt88jYTuVtETxDgOrTz6jn0WbMsVrutC+z3Vp8xvUZpw12BiXBIA4cHYB4nqwDnz560DtLdoTR+tdC3GKWrE8c0FuIGRFM7Mb855NI9L2t8VUeGtdY3cag1Zdr6KYUwuFZLU9iHb3Z77y7dz1xnmrUiIAqqz0E91u1JbaUZnqpmQxj9JxAH2qlWc7DYo/3RKOunYXw0LJKh4A5kN3W/wBZzVYuarpUZTXNJ+ZXTjvTUWdK7PNkmi7BRxtltNPdKstAlqKyMSbx8GnLWj2D3lbOtultMFgYdOWct7vMo8fYtC6j25TaTv7aGs042qppImyMfHUFjgCSCOLSDy8FnuhNv2zq8yRwVNxls9Q7huV0e4zP64y34kKLW1C9eKlXLz35NlUnR9WJsW5bKdnF5o3Q1+i7KQ7iXQ0zYX/tMw4fFai2jeSxpWrjNRpK5VNlmAPyE2aiF3dgkhzfbk+xdE2Wuo7jb46ygq4KunkGWSwyB7HDvBHAr4un8CVu5VZwhlMw1FN8That8nfVtLWdg+62YtzweHyfZuLfWxvQVr0LZvNqUiorZ8OqqtzcOkPcO5o6BfW0HV9FZrm9slrvlU6PORTW6V4PscQGn2grU1923aqukxs2itLVUFZJlrZJYjLNjvbGBgH27wUe6bUdQm4S9RPuXmZ+5QoLK5l08r/XsH5Og0Fbpd+Vz21FxLXcGAcWRnxJw7ww3vWo9lGyLWW0idzrLRtgoIziSvqssgafoggEud4AHxwtvbJvJ5rLrdPzi2lVD5HyyGZ1A2TL5XE5JleO/jkDj4jkt77Qdo2itkeloaedsEcrYt2htNIGte8DgMNHBjOHrH6zwUktZwpwVKlx7zX1E5PelwOeqvyTb7SUrp6rWVoiawZeXQvDR7yVqTVuhKez3FlstWqLdqS4SP3GU1sjklcT7QN33Zyqza3ta1btHuDnXSrdTW1r8wW6BxbCzuJ+m7xPuxyXUGyK0aX2d7PrLNHbGSXy4UDKmomZEO1fvgOw559VoyBjPHGcHitfrerz0ulGeN6UnhJY977CmEYy4YNRbMPJnvd17Kv1pUmz0Zw7zSEh1Q8dxPqs+s+AXTWidF6W0XbvNNO2mnomY+UlA3pJPFzzxPxwFT0RuN6o23e714ttq3O1ZT08u4XMwCHyS8DjmcNxwIz1WvNru0u3ae06YqaMU9A1vZUtNGNx1VgcG4+bGOo7ufcua3d9qWuVlRlLOX6sfVX1fn4l9RjBZPvbztepdM2mSktcgfUTAsiLXYMp6kEcQwfS5nkO9cZ3Wvq7pcJa6umdLPK7LnH7AOgHIDoqjUl6uGoLvNdLlMZJ5T/NYOjWjoArcun6DodLSqG6uM3zfyMWc3NhERb0oCIiAIiIAiIgCIiAIiICEUogJRSiAhFKICEUogIRSiAhFKICEUogIRSiA3Fss2tR2uigtmpJKn97kebVseS9gHIOxx4dCOnBbKum1nSt4fCai9RVlS+IU7Gx072vl543sDGST4Dj0XKaq7LUtorvSVjhlsMzHkeAIKjd7szZ15ussqXdj6cC5Go1wOn4tLzatuk19usUdTXTtAdIYxndAw1vLkBw+1a52wbPILdQy3Gip2wzQDee1gwHt68O8c1ufZ7quigt8crHxva5gLSDkEEK06wrbfqS9UVkmeAy51LKZwa7BLXHDseIbk+5Q6yvrq2uutRj8F1Y8C+4qSwao2P7f9YaAgjtc+7e7KwgNpal5D4R3Rv5t9hyO4BdDWDykNnGoKVra2sqbJVHgYqyIlufB7ctx7cLm3bRsavegp319IJLlYXO9Cqa30of0ZQOXdvcj4HgtWrolCra6lQVWjLMX2fPvLT36UsNHcFw1lpGat7eLU9lfERnfFdHj7VhustvemtPsdTWJn5crQCA6N27Aw+L/nfzfiuUUWut9nKFKq6kpN93IyZ385R3UsG4Ha02nbUqqanN7fbLWDiSOlzFE0fR4ek/2En3K4WvYfQzvDqu/wBU/PPs4WtJ+JKvmhbSLPp+3Uwj3O1po6gnHrF7Q4n4kj3LYNo6K3Wv5LhQ4R7iqFBP1+LMIs+xfSloq2VsstbXviIcxk7wGAjkSGgZ95wrDtyO7p+o44yWj+sFti+3yzWyJ35RutDSHHKadrSfcTlc+badW2y8uit9oqBUxtfvyytBDcjkBnn3/BLN1ritGU8vB7V3KcGkaxRSikxrSEUogIRSiAhV94vFzvE1NLc6yWqfS08dLAXn+DijGGMHgAqFEBsS6bY9ZVmqrvqCKpZTTXW3/k+WJmSxkW7j0M8WkOy4HvJVw2R7XqnSFtFjuVIau1sZOYXRj5aKSQDGMnG7kHx9InPRarRATK90j3OcScknj4qlkcXOPEkDgPBer3ni2MFzuuOipzvtOMD4rEuJp+ii/Si1xLtaZe0h82AwG5c4947lEzXvqmNYQ054OPeqO31Ip3SPLDks3WjvOf8ABVdaX9jC9vrhoeT7srBxhmguqLpXe9Hgm+vt6z7rid4O9U8iEgeWtAJGR3Jcd4wtlxnIB4Kla9UTjlI2Gh4VOT684LtRTtbVROkfusDgXHpjqrtVSiSB9Xj0ePZg93f71iwkKyaqlZFQMecehEA0DwCx3DDRr9pKcXVpTSy3w/Pj8D0t0va2lsbt4PjyDkceeQVEGmb7qOCae1298raVr3yOLgwENGSGkkbx5eiMnwXnNP5vaqed4OQwb468TxW5fJ5vNN+SqqjpvXbOXTk8nNeG7vEAnvAaOfpK/aUlObTMPRaHS30qjWFlvhyz1rw4nNjyvIrN9tmln6V11VwRwGKhqyamjw1wbuOJ9EbzQfRORy6LCWxvdyGPashUpZ3UiZSajzPgra/k5a505s6vd0vt+oa6tqJqPzalhp2NxxcHOLnOI3fVA4A81rBkQByTkr0AJOAMrNo0d3i+ZjVJ54I2vtn2z1mvqG2W6htbrPS0Bc8vFQXyzPLd0kkAADBPDxPFZ7sF2u6eoNOaa0DWU4pXCeaS4XOsmbHBEwOfKN0k8ScNHHHPrwXO9XarlSUcdXVUM8EEp3WPkYWhxxnhleL6OrjpW1T6aZtO5262UsIaT3A8srILeGdK+UHtW0Fedntx05pquluFbW1TPSZA5jI44yzJLnAZyWcMZ4HjhYj5PWtbJbbTBo64wTyVlwvjH0r2NG5HvxiMlxPjjgPFaSVTaa+ptV1pLnRPDKmkmZPC4gEB7SCDg8+IQ8Ot9V1tJs5uGmqm4ObDR1tfJQVLc8exHqzY/RIY7wBI6rI7pqS1Wa96xp7RUQi66ctzrq1m9lsmYy9zSBzG9jeH6YxggY4z1bqS86pvVTd73WyVNTUSuldk4Y0nA9FvJowAMDoAqGCvr4H1EkFZURvqY3RzuZIQZWO9Zru8HqCgNvab2hT12xPU9ur7sKe9WytprhaZN/Eji6oaXNZ+qcu/ndwWnK2omrKyarqXmSeeR0kjyMbzick/FeaICEUogIWbbGi0aqkBIBNM7HHnxasKVz0rdDZb/S3HdLmxP9No5lpGD9RVmvBzpyiiqDxJM6CvWkLNqunijuccgkiBEc0Tt17M8/A+8K1O2DWOWHegvdwjd+m1jh9gV50xq3TVaGdjeaNrnDgySQRu+DsFbFoHsfTBzHNc08iDkKMyuLih6KbRslTpz4tZNH1WiNa7OWPu+itXVjXxenJDFmIvA725LX+whZPoDyprpHHHb9dWxtcweia+kaGS+10fBp/m7vsKzLU/+iP9i5g2o2Y2XV09OWbnbRsqN3GMb4yRj25Wwsrn7z+qrcW+RYrU+j9KB1lJtB0VeXx1tDqW2GJw5SztjePa12CPeF81u1TQFjYDV6lopXYzuUru3d/Uzj3ridFjx2aoqq6jm+PgVvUJuO7g6R1v5TtQaeSj0XaTTucC0VtaAXN8WxjIz19In2LTViobxtB1XNVXWvqKqaQ9pU1Mjt55zyAzy8OgAWO2m2192uMNutlJNV1c7t2KGJpc5x9i6E0ds+rdm35PdfaiA1t1aZHwsOex3Mejn5x9MZxw9vNXdRu6Gm0OjpNKpLkuvvfkYy36r3nyRRP2Q2v8m5FE4Hd9cOdn281nsGp4ayngo7rU0VJU0lOyljhdIGB8bBwcMnJznB9nJZhLe7abD2QazfxzXLG3qsp6nUVNFAQXxscX47iRj7Cobp6r6zWVK4b4Zw+eP9yuWILKN9bRdrFnipXOuFypN2Mb0VvpJe0c5wHDexz8MgAfWuV9ZakuOqb1Jc7g/ifRiiB9GJnRo/zxVmRTbSdBt9MWYcX2/QsTqORCKUW7KCEUogIRSiAhFKICEUogIRSiAhFKICEUogCKUQEIpRAQilEBCKUQEIpUs3d8b+d3PHHPCA+UWYXHZ9fGabi1PZ2C9WOQelU0g3nU7urJo/WY4debeRBOViGFZo3FOsm6cs44PufY+xnrTRCKUV48IRStq7CNmc+qbnFe7vA5ljp37wDh/pTwfVH6OeZ93ss3FxC3pupN8EVwg5ywjMNgWz641NgN1vtXV09FUAGipWOwS3n2hyDgHoOvPuXjQVtsrvKS03ZLIzNLbal7JJi7edNKGOc857hugAd4J6rOtuGvKfRml3UdBKwXesYY6WNvOFvIyEdMdPH2FaP8mjek246fe8lzi+dxJ5k9hIorOnKtbXN5NY9GWPJmbLdhONOPasnblU2KSF9NWxMlp5Wljt9uWuB4EOH+Qua9uHk/Ph7fUGg4C+Pi+e1ji5vUmLvH6HPuzyXThAcCCAQeYKpHtlpMuiBlg6x/Ob7O/wBi5jper3OmVekoPxXU/E2NWjGqsSPzekjfHI6ORjmPacOa4YII6EL5XaG2TY1Y9fU0l4sjobffcE9qBiOoPdIByP6Q49+VyHqfT940zeJrTe6GWjq4j6THjgR3tPIg94XYtF1+21Wn6DxNc4vn7O1d/maWvbyovjyOv7VbqWr07bopWZ3KaMMeODm+iOR9wVp1vp7UNRpStotOVUba2UBscheY3AbwyAe8tyM8E2P6hp9RaGt88TwZ6eJtPUszxa9oxk+3mPas4iUFhXr2ddw7HyfLmb9whVgn2o401BoDW1ofI646fry1vpOljZ2zMd5czIWLOaWkhwII6ELv2PkqC7aW03e2kXWx2+sJ+dJA0u/a5hSi22mk+FWHl9P7mtqacl6rOEEXajtjmzaVxc7TEAz9GeVo+py9oNj2zGAGZ2maXdYMudJPIWgd5y7C2UdeoS/dfu+pjuymutHEq9IIJp3iOGGSV55NY0kn4Lt78j7JdPWKpvjbLY3W+lBM9TBRiq7MNzkktDiAMHKyK2X3TkF6orHRUMdJWV9I+poB2AZHURsxvbrmg4xvNODxwcgFXP0tverBnn3XHNnElr2da7ue4aLSF6ka8Za40b2NI9rgAszs/k6bUK8NM1qpLe1wyDU1jPsYXFdMaa1vdNRxTGhZbLXV0t6mtT6Kp35nzvhO9IGvBaGkxguBIcOWV5Xi93ql2wVumqm5XGW2VWnHV9FFSxNEkU7JSx+6WtyfRdGRvE8faq1e1ZPGEinoYo1DZ/JNvsse9eNW2ykPDhTQPmHxduLLNOeSromV8sNbrO4XGaHDZW0fZRGNx5bwO+R71ltjsMuvtikVwvF5pr1eqjT9TRCrpyRG2V+8C7d4YkaQ1pOAQWu5ZIWQ7Faqgk2S2PWUdI03KpsNNFVmMhrqh8LCADnhvb5eAf0uKuqrUfNlO7HsMCqfJQ2fz0r30Gpb5GWOc10jpIZGtLThwIDBxBBzxWGHyZtKVs2LRtWoJ2mY04Y6BhPag4MeWyetn5uMrb+xyet07tO1Zou6RVMLLiGagoPOJWvc7tMMqfVc4D5YbwGfn8gsWs3Yu2D7XIHND5pL3fI6VjeL3TueRCGDmXdoW4xxzhXd6T4ZKcJGtr55J+uKdp/Jd3sVZEOTTJJE8j2FhH1rAdQ7AtqtnaXy6Tnqox8+jljmz/Na4u+pd7aHju8WirJFqBwfd2W+Btc4EHM4jG+eH6WVdSsRwS5F7fbPy6vOmb/ZJGx3mx3G3Ody85pnx+zG8BlXTWtkksN4qrVK5z+wkMbHluC5oOA7Hiv0nqoYZmFk0TJGnm17QQfiuNPK9sclBtNbXtpxHS1tEx7HNbhpc30SPaMD4hW3JGr1eOaUamPVZpWre2oErgCY94jkvShoaGpp950TQ8hwJa4jBzw4ewq9ssFNBs6p9RS1b46uruM0MNO4ejLFG1mXt4cCHOIOTx6cuNfs30HdtX0lwnsdZQ9vRvaX0szy1zgeTmnBHeOixa+IU+DxgtaTXn98kp49Pj8zFjaKZ7miMSgv5DeyB3gr0u+7hkIOGBw38DoOiyW+aavumavza8291I6UF0b99rg4A8cFpPVWmjMcslTEWghrQD71apVG472cmDrV41fcY5jT6vHHH4YKbU0gbSTMzkEAj4hemyPVcWl9UsnrpJG0E4DJ9zJ3ccnYHXBcPY4rwqLReL86Ojs9uq6+aN268QRF2B0Lscveso0/sF13cnA1kNFa4+vnE+84+wMDvrwsmncUrfG/JJmw2dtpQtd5LOX/AGNuXzTWk9pOmoXQVVOXxt346ylaxkcDyB6OA3ed09EnPLiCtTXjYjrSnnlNqp4brStyWSseIXOHiyTdIPx8CVu/ZPstn0bTzR1OoHVrJnCTsGwbrI3gY3hknJx93ctl01BCxgDnyyEdXPxn4YCuz121j6uX7PqSB2zqLM1hnKWzHYrfb7enHVFPPZLVTPHbumAZJL+izP8Aa5DxXTNgsmhtO0b9P2rTXaNLWue1lvfIJj80umc3cJ9ruHgsf2p0ty00ItoNjnnkis7HSXK1Pmd2NTTY9NzW8mytHpA9cEHms70fFTfkaCtp44W+fNFS8x8jvjeABwMgAgDhyConrDcVKEeDFOlGnwXMx6i0PpGzWiSe6WiOuq5HndmukjZA17yQxjee7626A1ucnqVqk7DbxquOoNz1/A51M4OloaehfmE4y30HljgSCcZAz3rae12O7QXjRN6pGSS2223xrrkxvzI5I3xCVw+iwvyT0znkCR70VJUVG3yfUFFK19oZpltLVyseDGZvOHOjBxwLg3tD4Bw7xn2N9WnHOcfnkUVEm8YNI6f2ObNp7XbbzX6rvz7VcK/8nwVTaNkLHVG+6PcIJc5vptIyW48eIWWap8n3ZZYJ7dR19+1PTz3Sbzeicxrajfl3S7d3GRF3IE54DxVRp633a16BoaiGzVtybaNaTzT0D6Z8jTSuq5cVEbAN5xaHB7S3PfgrYGr6hlx236EcWTRUFqpa6unqJ4XRxNfJEyONu84Ab2HuOOY4+KyVVm5et2mPurHI1NP5K1BVRVE9n2hQOZC7ceypot0xPwCGvw/LTgtOCAeI4LGbv5K+0el3nUFTY7mzm3sapzHH3PaB9a3RUXGvtcO2fX8u9HZJaNjLXvtLRPJT0rmPkaDzDn7rQ7kd0YyMFZJsf05LS6b03bblbPyTPZqGiMNTDOQ6tkMDu1Y/gN4DmWnPEZ6ArIjVnjLZbcUcfXzYntTs7iKvRdxkA+dShtQD/Rlyw272G+WeUxXazXCgePm1NM+M/wBYBd0t1Xe9ObRJqG5XOessN/tU1bYi7dcYp6YudJC043nB8RY4bxPqnC2vDC6WiYyubBNIWjtMR4aT7DlV9M1zR5uJn5XYRfpzdNGaQuRJuGl7LVFwwTLQxuPxIWLXDYnsrqsmTRduaT/si+P+y4J96iuaHRs/O9F37JsE2TA5Gkov/NTf86q7bso2c2eQS0OkLW2RvJ0sXakftkq1O/hHqZVGg2cF2PTt+vkhZZrNX15HM09O54b7SBge9b42E7PtoWnbpLU3anFFbJ4SDTTVIJLsjDt1ucEAHng8V02+CGnjEcEMcTByaxoaB7grZW8lo9Q1ac4OCikn7TNoWqTTbMQntkbXiSocJntOWjGGju4d65q8pdrW7RIyObqCMn9p4+5dSXJwa1znEAAZJPRce7ZL/BqPX1bWUjt+lhAp4Xj54ZzcPAkkjwwtXs6qtXUHN8Uk/eZN/uxoKPazDVlGzrQmoNd3kW6x0pc1pHb1L+EUDT1cfjgDiVmOxbYteddSx3O5drbLCHcZy35SfwjB6fpHh3Zxhdcabs9m0va4rFpu3xQRRD1WdD1c93Mn28Vm7QbWUrDNG39Kp7o+Pa+7zMC3s3U9KXBGP7KtmenNnNuAo2edXSVobPWyNHaSHq1o+a3I5D3k4Wv/ACua42x+j7lIx5jhrJe0ZG/dcWEM3mg95AW+IIdw773dpKebj9g7gtAeW2zOl9Pyd1a8fFn+CgmgXFS71mnOvLecm858GZ9xFQoNRJumlbpX6TfddJ32OsE0Amo4pof4RpGd3eDvWx4c+eFy9dZK2W41Drj2nne+RKJBhwcOBBHTHLC3r5MOu2szoy6T4BJktz3nrzdF949/gq3yjdmr69r9XWGm3qljf3/BGOMjRykA7xyPhg9Dno9jKOn3UqFRJZ5P8/nJgVKaqU1OBzminCKSmEQilEBCKqtdur7pWx0VtoqisqZDhkUEZe93sAVRqCz1ViuLrbXuh88i4TxRvD+xd9BxHDeHUAnHI8cgUdJDf3M8ewYLailFWCEUogIRSiAhFKICEUogIRSiAlERAEREAREQBERAEREBmGyfX942f6jZcbdK59LLhlZSk+hMzPUd444P4rpO4bNtmm2Swt1Fp8Cy3OZoc+SlaMB3H+Ej4A8c8RunvOQQuPFnOyHaDctCX5k8E8goZXDt2Djjl6QHXkMjrjvAIjWuaRVrP73ZS3Ky7P3l2Pt7slyE0uEuR77StkGs9CvfNX0HnluB9GupAXxY/S6sPtHvK1/hfovonVtr1XbI5aeSIySRdp2YOQ9nLeb3jiM9QTg9M6+2m+T1pDVAlrLI0afuTuO9TszTvP6UfAD2tx71odN233J9BqUN1r95fNfTPgXJUeuJxSu3NnMDYNnVhip2sjxbYSMDhvGMHPx4rlnaNsu1joSYm9Wxz6POGVtPl8Du70vmnwdgroLYRrW2ai0fQ2tsrIrnbqdkE1OXek5rAGh7e8HhnuJx3LfavVhd20K1CSlHPNcS7Z+jNpnLmr5rvPqW4G+zSzXFk72TukOSHA4I8AOgHBZ/5Llurpdr9nr2Uc7qWEzdpMIzuMJheAC7kMlbqv2yHSN71dJqOvjqnyykOlpmyBsMjh1IA3uPXBWR2i96ftutrLoy3iFlUQ+QU1O0BsEbY3H0gOWeGB71janq8alhUpUocXB57FwK6ds41FKT6zZiIi42bYo6mkcJDUUjxFN1HzX+0fesV15o/Te0K1OtWoKPsqyMHsZ24EsLu9ruo8DwPwKzZUdzoWVcYIO5M3ix46K9Qr1KFRVKcsSXJo8lFSWGcc3ixa22Gas87a01lpnduCZoPYVLM8GuHzH4+HHGRlbs2f7QNO6vpmGhqmw1mMyUczgJGnrj6Q8R9S2BWOpLhRT2PUlFFV0srdyRsrN5rh4j6wVzTtm2H3LSz5NR6OdPW2hp7V0bCTPSDnnI4uaO/mOvep5Y6pa601Tu3uVuSl1S8e/8rsMTFS24w4x7Ow6LiVVGuQdLbaNb2NrYZquK6wN+ZWs3nY/XGHfElbAofKQpwwCs0rKHY4mKrBGfYWrZz0C8pPglJdz+uD1X1KS4vB0I+NksL45Gh7XNIIIyCsF8n+ogg2Q26orZWtPnFRDLLIeL3CpkjGT1PAD4LXVX5SdE6J0cOk6lwcCCXV24fcQ3IWHv20RUdvjt9i0ZQUtJHP5wyGqrJ6hgl7TtN/d3mjO/6Xt4rNoaXc7jhKOMtda6s9/eWZ3NPeymbo2eUMT7HtK0JXyRthhudaGBxADaaqj7Vvw7Ryo9nDdQVmmdml1tMFW+5UrI6G6MrqXDIaIMcJS1zmgtcTHHjdOXZGcgcNLfu166mrHC0/km0T1bwJX0dvjDpHE4y4uDiSu26O3wx0kcUpknO4A90ry7fOOJI5L3UK709LpFly+Sw/PJRTxV9XqNX2mzyaW1Tq+/19LYKWGsuTa201FwrGQvie6Ds5i5wDiGkjIAPEE5wrRftcbPaPUOl9SXHaJTT3WwUMtNM2307p/PTI1gfkjIxlgcOPPmStlahtGh9Y+daWutNba+ajwZKXgJafeAIcMYc3II4haB2k+THW07pK3Q9f53FnPmNW4Nkb+rJyd7CB7SvLLVbect24zB9/LGOHHvXsKalOaXocStj2/aB0tbLnbdH6bvlVT3CrlqpIqirFNHHJIcvMbm7z2gnJwCMdMLFYtvV/qKGOyWDSWl7RZ4HbzYPMzMGcz847uck8d3qVp7UFhvOn691Be7ZVW+pbx7OeMtJHeM8x4hVmnqguh80jgAIy50mfuW9umqVB1KXHvz7yzQW/UUZmza/bHrmWvbVtqLU2qa3DZfyTTFzG4wAHFhOMDGMqjp9suvKCoM1FW22me0kl8VopWuJPiI+awyRmMsafSPFzsKlka0DeA9FvqjvPetLC4qP95mxlSh2GzoPKJ2qxOw+80k3V2/RRcPDgArzb/Ki2gU0Q88tthrATwJgkY4+8Px9S0oYclsZxlxy77/AMF8yN3pwOjRvK8riXaW3Rj2HS9j8quOauipLxo97RI4N7Wkq94j+Y5o/tK8+VkyhumzltxkpKhlTRyjspgwOaGvI3muwcjOBxxjIxnitBbBtLjU+02kbURdpRUANVPkcDu4DW+8kcO4FdVbUbdLdtmmoLfBTvqJpaGTsomNy5zwMtAHU5AWwoUelpub9hZq20K1OUHyZxpT1kd3fbaGvuBpKCho5GwcMhrg18haB1L5CR/O8AvvRN/vek9QMvdlALmnspmEZZKw8S1w93uOFaYbNe4aUzPs1eWU5JlJgcBH6WBvHHDjgKom84EJIhijeRndY3j71jzWVhrmQi8jWsa8V+91P4eRl20rVU+rL8+4Pa6GHdEcEQOS1o7yORJyfvVvZJ5jbqqyVlPG2oZP2gkwC5rx6L2Z6t5H2t8VYoKWaGIiSNwfKQW5GN4EcD9a3PsJ2VU2rKQXW75ktrJRCxrH+vuEF+SOIycN7+Lj0CwK0qVtT4+qjGoQr3txKCeZyzl9WMdfuwZTsNsrbLpAVtTuxz3BwmO9wIZj0AfiT/OWdm72mGZkMtzo45X+qx07Q4+wZWv9o3k1RV5kq9JX+pgkAy2jr5HSx57myes0Y7w72rQWrdAa60HWiqulprKQQvBjrYMui3uhEjeAPwKwrawtb+o59P6T6sYfvZ0KlVdpRjSjDhFYOub1q3TlhpG1d2u0FLA526178kOOM4GBx9yxiu257OaJvoXWesd9GnpXn63ABc2681UzU9ptz5aus88gBE1O8kxZ6ubk8D/npxw1byns9bx5yb8voUVL6WfRSOl9X+UJpK42SrtUOnrpXQVkL4J45pGQB8bgWubkbx4gkcBnxWKUHlDXiy2mntWndN26ko6aMRwsq6iapLGgYA3i4HAAHBaTRbCnpltTWFHPtZjSuKknnJt2q8onaTMT2dTbacHpHSA4/aJVE3b7tSYMR3+GMdzaGDH9havRZCtaK5RXkW3Um+s2m3ygtq7f/wDJIz//AKMH/IrpbPKW2nUj2meotde0Hi2oowAf2C1aYRVdBT/Cjzfl2nTFJ5UFvvVAbTrrQFHcaCUbswhlDmEf7qQEH9pZ3pjbXscuFybXuveo7JWMhfFEa+aaaOPexlzWl0jA7hzI4DI6rje02y4XaujobXQ1FbVSnDIYIy97vYAt6bN/Jpv10dFWawqvyPSHDjTREPqHjuJ9Vn1nwWHd3FraRzVlju6/IuQjOb4I6Gnh0BtBs2nbZZtX26tqLDcKato3xTsMwEJ9JhaMHDoy5p4Acc44YW0gQRwII8Fq3TmmdBbMrWxtFBQWlkzmwmpneO1neTwaXu4kk9Bw8Fl7IY2Oc+JvZvdzdGd0n2kc1HJ7RwTz0b3Op9v58TLVs+3iZC5eUi4Z1Btu2qaV1perTT6mlmp6S4TQsiq6eOXDWyEAbxbvcvFXe2+VbryF2K6z2GsZ1xFJG74h+PqUjVGU4qUesxd9J4Z2PL1VFUciuaYPK2DsCq0Of0jHcPxjXtP5VtpdGSzR1bv9AaxuPjurFq2lZ8kXY1YrrN/VSx3Udzt9ooZK651sFHTRjLpJXhoHxXOWqvKZ1NXsMVis1Da2kY7SVxnkB7xyb8QVrOF2udqGpYaN1RXXqvectD3fJwtJGXY9Vje/kFgz0mTTnWkoxXP88i8rpR4RWWZ5tg2uTake/TukWTikmd2clQGkSVGTjdYOYafieXDrlmxPYEyFsOo9fxNG7iSG2OPAdQZv+T49Qs52TbJ9PbOKaO53Ix3PULm57Yty2EkcRGDy7t48T4ZwtiUsdRdZBPVZbTNPoRjk5Q3VdpYUqbtNN9GHXLrfh2ePPswZFO3lOW/W4vs7D3hL6mNtPQMFLRsG6HtbjgOGGjoFXU8EVPGI4m4HXvPiV6NAa0NaAAOAA6KVCW8mYFoXy1YC7QNnnAyGXQNPvikP91b6WK7SZrQy326mvQpnU1ZXCnDKhocx73RyYaQeHHHXrhbbQazo6jSqJZw/kWq8d6m0fn/BLLBMyaGR0csbg5j2HBaRyIPQrr/YRfr1qPZ7BcL6e0nEz4o5iMGaNuAHHxzvD+asY1zsGsl3rBWaeq/yM97syw9n2kR8WjILTz4Zx7Fs3T1soNLaXpbZC9kVHQQYdI87o4DLnnuyck+1dQ1TUKF1RioL0s+1GBb0Z05vPI5J22W2ntO1K+UdKxrIe2bK1rRgDtGNeQB7XFYass2qXiHVW0i63O2sfLDUTNjg3WkmQMY1gIHPju5962Dsy8nTVWo+yrtRE6ftzuO7IzNS8eDPm+13wK29XUbfT7WE7uajwXPnnHZzZgyjvTe6aXo6WpramOlpKeWonkcGsjjYXOcT0AHNb22Y+TZf7yI7hrCoNjoT6Xm7cOqXjx6M9+T4Lo/QWzvRuz+hc6y26KGVrD21dOQ6Zw5nLzyHDkMDwWpvKM2yfk6jm09YZB5xO0te7n6B+c4dx6N68zw4GHVNqL3Vq/3XTI7qf7z547exe/2FxUlBZkYrtW1rpbZ1bJtFbLKOClrJWllddWHfm3SOLWyHjk9/IdMcCueXuc95e9xc5xySTkkr6nllnmfNNI6SWRxc97jkuJ5klfCmmm6bCxpbqblJ+tJ8W33v4FmUt5hERbEpCIiAIiIAiIgCIiAIiICUUogIRSiAhFKICEUogIRSiAhFKIDYWx7aFU6SuUdJVVErba+TebI0+lTPPz2+HeOvxB7GsF+g1Rb4YDcJKKvLe0gnpZMNlGM7zQctdw+a4HvHevz3Wz9jm0E2aaOxXmdwtr3DsJy4g0z88DnmG5456HioXtNs5G7i7mgvTXPv/PWuvxL1OpjgzsCtvNRbXi3apoYailnBa2pgj3o5ABxD4zkg+Azz4dcc8eU5oPTmmrXbNc6HxbhPV9hM2jlLWBxa5wcwD1CN0ggY5jgtvTan/LOmzR1BjrJA5j6esiLSOB69OWRkcwTy64FtLc7UWmPzJ3A5hq2VhmYfSiwMbmMcSeJznhnkodoUqtndwnndWfSS5NduC9PDRoWk2n6+pYexj1PXObyzK4SO+LgSsu8liaortt1PV1c0k876eokkkkcXOcS3mSefNRfdkYgoTJSSTRyhuRvnLT7VU+SdSS0+2h1POwslgopw4HoQWj71PL+8tLjTLiVvjO688MMoo73SxUu07GREXFjehERAUV1oI62Lo2Vvqu+4qxU1XVW2d0MjSWg+lG7l7llSo7nQRVsWHejIPVf3L1MHDm32moYtrV9baqaKmp+0jd2MbQ0BxiYXEAd7iSsBHFZzt/ZLTbYL9G/0XsljH/pMWEhzJueGSd/Qr6r0zRYXOj2tSi8T6OGc/veivJ/EhVW8dO4nGfq5fs4nyikgh264YPci1FSnOlJwmsNGdGSksoyLZfQC6bR9OUBHozXOna/9XtG5+rK/RQcBhcI+TLRms226fYG5Eb5ZXZ6bsTz9oC7skcGMc88mglQDauebmEOxfF/2NnZL0Gzhna5f65m2m/3e2Vk1LUwV7o4poZC1zezwzgR+qtl7M/KOq6YRW/XFMauMYaK+nYBIPF7BwPtbg8ORWhbzO6tu9ZWPOXTzvkJ8S4lUm4vo252S03UdOo2t5TTcIxipLhJYSXB/Ll3Eejd1KdRzg+bO+4J9FbR9PndNsv1vePSY4B5jJ7weLHfArVWsfJosFVO6t0jdaiyz5yIJczQ+wEneHxK5nsl1utkrm11nuNVQVLeUkEpY7Hdw5jwW8NCeUheKLs6bV1uZcoRwNVTARzDxLfVd7t1cr1X7NtX0tuelVOkh+F8H5P0X7n3G1palRq4VVYfaY7qrY3ruyNeW2g19O3i6ahd2pd/N9f6lr6voKujqnQ1lLNTPj/1csZYc+wrtTRu0/ROq2xttl8p2VLx/otSeylB7sO9Y/q5WV1tFRV0XZVtJT1Mf0ZYw8fArnVa4urKo6V1ScZLqaafkzbxqRmsxeUcQ6C0Lc9VPmqIntpaRno9vI0kE9Q0df8FsKybDLcJXTXa+zzMI9WCIR478kk/YukoLBYqeJsUFmt8UbfVYymYAPcAqiG3UELg+Kipo3DkWxAELKp65a04/sm33s8abMG0Npuz6atrLfYbeY43HL3MaXukd9J7vx4dyy6CmrCOEbIvF5yfbgfiFdV4VtZSUMDqitqoKaFoy6SaQMaPeVRV2luqnoUYqPhxf59h7jBhe1XTVuu+ny+/3q4QW2mPavhpQ0GV/JrQCCSc8hx4lc+3vZZfbrajd6DS1RaqeHeFJCWTT1VSSeBezOG4HXDR3A5C3XrDbroGxZjp62S81LSfQoWbzQf1zhuPYStL6z8ofWN3a+nskNPY6d2RvRjtJiP1nDA9wB8VIdF2Y2k1NqfRtJ/vT9FY7lzfsTI9qVCzrVN+cuOOri/Pu7Fjvye/7l9w0jZ6PVV3ven7VUwSCZtpug3mVDAcljuZJP0QCePMFZPZvKA0NYahlJZdGz0NDO4S1ZphHG1shABLYxwdy55bnAXOd0r7hdat1Zc66prah3rSzyue8+88VS7i6bY/ZjZun/wCo1HUl3eil5cXjqb8jCoV42q3bdYXfxb/Pcd96L19pLV8QdYr1TTynnTuduTN9rDg48eSyWRjJGFj2te1wwQRkEL84oHywTMmgkfFKw7zXscQWnvBC2fonbnrvTjY6eorW3qjbw7Ouy54HhJ63xJHgolrX2RXFNuem1d5fhlwfsfJ+1I21HV4vhVWPA6G1rsQ2eaoMk0lnFtq3nPnFAeyOf1fUPvblaY1Z5Ll9pjLNpq+UlwjHFkNU0xSY7sjLSfgtl6O8ojR127KG9Q1VkqXD0nSN7SHPg5vH4tC2vZb1Z71TCptFzo6+IjO9TzNeB7cHgoHcw17QpblzCUV/Esr2Pl5Mzo/d7jjFpnA2pdmOvdOvc26aWuLGAZMsURmjx+uzI+tYi9j2OLXtLXA4IIwQv02VtulgsV1ObnZrfWnvqKZkn2hXqO1sl+1p58H/AL/EolZLqZ+bWF60tNUVU7YKWCWeVxw1kbC5x9gC/Q4aA0KHbw0bp4Hv/J0X/KrxbLVa7ZH2dtt1JRs5bsELWD6gr09rYY9Gk8+P9ilWT62cMaT2K7RtR7r4NPT0NO44M1f8gAO/DvSI9gK3PonyXbXTPZUatvUle4EE01GOzjPgXn0iPZurdmqdaaV0vHv32+UdG7GRE5+9IfYwZcfgtJ648pWJrXU+j7Q57iCPOq4YA8WsB4+8j2LJsaW0WvPFlSai/wB7GF/qfy4nk/u1v674/nqN1Wax6P0HZn/k+jttkoYx8rM4hmfF73cT7SVqPaT5Rtrt4kodGUwuVSOHnk7S2Bv6reBd9Q9q551hq7Uuraw1OoLvU1pzlsbnYjZ+qwei33BWHcXRtB+yq2oyVfVZ9LP8Kzu+185e7wZr6+qya3aSwi8al1XqDUl4bdb5daitqmOBY55w2PBzhrRwaPAALv6x1ba+y0NcwhzainjlBHXeaD96/OncXeGxCvNx2TabqXO3nCibET/u8s/urX/a5p1KjZWk6MFGMHKOEsJZSfV/KXNIqNzmm+ZyD5S9vjt+2zUMcQIZLJHOM974mOd/WJWuFu3yzKDzXaxBVDlV22KT3hz2/Y0LSa0Ol1Oks6Uv4UXKyxUZCIvprd4bzjux9/U+xbm0s613U3KSz8F4mNVqwpR3pMhjXPOG+8nkF21sjorFpnZ5aW2Ghiiqq6ihqKuoxl0kjmAnJ5nBJwOQXEckuW7kY3WDp3ruvZDazUaA07UVAIi/JlOQ36XybfqUV+1KxhY2FvGEm25Pe7Hw4cOxF/Ra8q1Wba4Y4F+tVvlrpfOqouMec8eb/wDBZG0BrQ1oAA4ABGgNAAAAHIBSuHNkjCIi8AWlvLGBOyqmcObbpEf6ki3StO+V5Hv7InO/2dfC7+0PvW52feNTofzIs3P7KXgaC07tu1pZ7RFbiaKvEQ3WTVbHOkDegJDhnHeeK9bDftabXtY2/SFxvr6ejrpT2jIIg1jGNaXEkNwXYAPrE8cLFdIaLuWoWdvH8jT5wHluS72BbW2L6fj2fbQor7dXyz04pZIY9yMAtkeWgE5ON3G9xXVdSurO1p1ehS6VJ44dfV3czTKVSWE3wN26S0Ps72WwtdQ0ZrLvjAme0T1chPINA9TPIYAB4DmVmcVbcmxuul3dDaqCIb3YZD5Hcx6buQ5jDWjOcceYWBaPqaK2Vorrq+WWaGHejayIvM0x5u3uQdz4kj1ufBYxtk2lfkqg87rC0zuyKGga7hn6Tu/HU+4cznmDs7m/uVBtzk+cnx9i/PAv5UUee3va0LXQ+aUgxNKD5tTE+t3SyjuHRvf9XKFfV1NfWS1lZM+aeZxfI9xyXEr1vNyrbxc57jcJ3T1M7t57j9g7gOQCpF1rRdGpaXQUIr0nzZiTm5MhFKLclBCKUQEIpRAQilEBCKUQEIpRAQilEARThMICEU4TCAhFOEwgIRThMICEU4TCAhFOEwgIRThMID1p6qqpwRBUTRb3PceRn4Lffk9VFKbJCZnBzxK/fJOTnezx92FoGON8kjY42lz3EBrQMkk9F1fYNnkdo0ZaLbSOEF4YwOnlyMOc47z97HMDOBjwUd2jhCdsqfJt/Av0ISk211GaauqLU61AQhodu8VrbYVZq2n273G6zUE8NFVWiV9LO5noSkSQtdunlwOc/wCKp6x9c3abY9C1lVHO+vdvVDqdxzFHhx6jmQ0+xdFU9FR0tJBRRQthhhaGQhvDdA7j3/audXVSelUXQaz0sX5Z5+aM6hS35bz6isRU4lfBhtR6TOkoH9odPby9iqFFWsGxCIi8AREQHDnlGMbLtk1GHf7ZmD3fJMWs5Y3RuwfcVs7yhf8Atl1H/v2f8JiwB7WvbuuGQvtbZ23VTQ7Nrn0VP+lHN7uo43VT+Z/Eo2Shw3JeI6HqF97jhkgbzQM7wHDHLj3c15zwujPe3oVdtHTdlcpN5jZGOhLXNdyIJCwNoaUVaTq1I5nBcH18+XejaaHR+83lOhvYjN47faba8jKkZPtXqJ3tyaa2SvYe4lzG/Y4rqraLVuoNA6grGHD4rbUOZ+t2bsfXhaJ8kWy0cGqr7dqLIj8zZCWH/Vlz849+59S21t9qzR7Ir/K12C+FkXt35GtP1Erh1w43+t0aa5SlCPm19SVXNpOwU6VRrMc8uXLKOISzJyo7NVfZ+Cvug9KXDVupKaz0ETzvnM0gbkRMHNx6ezOMkgL6yuLilbUpVqrxGKy2QqMXJpLmWvT2m71qCodBZ7bUVjmY7R0bPRjB6udyaPElZ7UbC9X01C+oqKm1RvaAeyM5LunUNwDkgY8fYuobbp+j0ppmG222nFNGxoLN0M3S7vLgN7ePecjj1Wk9tG0KotpjtFnkDKx4ZLLJu5ETcZDQDwyST7sLlq201XVb6NrptNRz28eHbJ9S8PDibX7lSpU3OqzQ96s9xslykt9zpn0tVGAXMdjOCMg5HAggg5V801tA1rpxkcVo1FXQwR+pA5/aRDw3HZH1K2Xm4V94uElwudTJVVUgAdI/mQAAB7gAFR9n4LpUrKF5bxp31OM3jisZjnrxk1iqOEs020batvlE67pw1tVTWisAGCXwOa4/suA+pVlR5SWrXRkQWWzxu+k4SOx7t4LTPZ+Cdn4LQz2E2enLedrHPtS8k8GQr+4Sxvmwr3tx2jXNjo23eKgY7mKSBrD+0cke4rAbzdbteanzq7XOrr5sY36iZzzjuySvPs/BOz8FubHRNO0//K0IwfaopPz5lmdepU9eTZSdmnZqr7PwUxwPkeGRsLnE4AAyStm2ksstFIIiTgDJXtLQVUVNBUyU8jIaje7F5b6Mm6cHB64K3RsrodMUWnaSuudNSuutPUSVTZXO3t1hZu7rmj1hgZAzwPvz7aF1vbLlWU9FcbDaqeks8jjat5riQDkOBJcfSwQc4PHj0XLr77R5wr1YWdq6kaTab3kt71kt3tTai89jlw4LO+t9DqVqXSOWPyv7miuzTs1m+0q22GnuzDpmGfzRsOahz3h4Ehe48COQwWjkOXvOJ9n4Kf6RqlLVbSF1STSl1PGV3PDZpq1KVGbhLqKTs170VRVUVSypo6mannjO8ySJ5a5p7wRyXp2fgnZ+C2MoRmnGSymWk8GbWHbFtFtADY9Qy1cY+ZWME2fefS+tZZReUfrKJm7U2qzVB+kGPYf7WFp3s/BOz8FHLrY7Qrt71W1hnuWPhgyYXteHKbNw13lHa0lbu0tts1N49m95+t2PqWGah2r7Qb5vNqtSVUETgQY6XELcd3o4J95WI9n4J2fgqrPZHRLN71G1gn2tZfm8nk7yvPnJnxS0lZca2OmpopqqpmfusYwFz3uPcOpWd0OxjXNZQ+cxUVK1/WB9S1rxwyc59EcO8hYjaK2stNyguNvmMFVTv34pAAd0+w8Ct2bHtpFXc7m+132VoqXjfhlY3d38bznAgcnYLiPE+CxNqb/V9Oo/eLGEXTisyzlvy5YS59fsLlpTo1Zbs28s0jqHTt50/Wuo71baihnaSN2VmAcdx5EeIVs7Nd3/AJHtup7DLbrvbYq+OZnBhjaezzyw4kbvsbxHDPeuQdpWja7RmqKi01Uchhzv00rm4EkZ5eGRyOOqs7L7X09ZfQ1Y7tTGe59uPDsPbq0dHiuKMO7Ndi+SxX+ebI6WDhmiqpqc4/W3/wC+uRez8F075H1Q06RvNHn0oq4SEeDmAD+wVqPtXt1V0Hf/AATi/ivmXdJli4x2owjy46YNvemqzd4yU08e937rmnH9f61ziSBzXXHlm2Spulg07U0zGl0FZLE4k4DQ9gOT4eguarzQ0Vssro4D21VvN35iOXgO4LmGzVxTqUKFCT4t44dWZcyRS0m4rUqt0liEE3l9bS5Lt+RjpDWelLxPRn4rykkdI7Lj7Avni53Ukqrp4N3Dn8Xd3cu1WlpGEeiorEfzxfayBVarb3pvLPinp/nSD2BfoJsq/wCzHS//AOIpf+E1cCrvjZMc7L9LH/7RS/8ACauTfbVSjTsrRL8UvgjebNycqlTPYjJ0RF88ktCIiALUvlZM3tjlYcZ3aqA/18fetryysjA3skng1o5n2Kkq6KCuYw3OCKWON4kZC9oc0OHFpPe4Hl3fWs3T7n7pc07hrO608duCipHfi49ppPY3b7ey1UUMjQxrYmggjB5dVkG0eitsdM8QFpGOatG2Xs9F6goLlSuc2C9VDozHwAim4cc9A7OfA593zT2O+XW4QwXyM0lG4En5RrnSY+YMHhkZ9wKk8KFS6qRu0/Rlx+vkat05JuGDna4671bT1tVS02oq0wMleyMl+TugkDjz5LGK+trLhUuqa6qmqZnc5JXlzj7yr7tL03JpXWtxs5a7sY5N+nceO9E7i0568OB8QVjeF1S1o0IwU6UUsrmklkwpZTwyEU4TCyikhFOEwgIRThMICEU4TCAhFOEwgIRThMICEU4TCAhFOEQEoiIAiIgCIiAIiIAiIgCIiAIiIDYXk/6fZe9oNPUVLA6ktjfO5d4c3A4YPE7xBx4FdTXa5Utks1Zebk/soYIjLJ4ADg0ePTxJWqvJYswptMVV2kjw+smO64jmxnoj+t2ixLymdX3Wp1JLpFvyFtpRHI8DnO8tDgSe4Z4DvGe7EVuqcr+/6JPhH4dZsaclRo73WyNg11q9UeUdTX6rHyshqZi3OQxvYva1o8ACAuw3ta9pa4Ag9CuPfI+gMu1iSQDPY22Z58PSY3+8uw1CNt2lqMYLlGKXxMmxz0bb7Sle6Sm9cGWDv5uZ7e8fWjGmNgkpCJIiM9mDw/mnp7OXsVUqKWnlgeZqLHHi+E+q72dxUPTMwqopWStJYeRwQeBB8V9qihlhqyXRkw1LBhwI9IeBHUL2ZOQ8RTgMkJw059F/s8cDOP8A3XuOwHuiIqQcO+UJ/wBsupP/ABDP+ExYEs72/u3tsepD/wDUtHwjasEX2/swsaLZ/wDxU/6Uczvv8zU/mfxDgHAgjIKqNPw9ncXkHLTEcfEKnV40nAyouUkb8/wLiCOhy1Wdq1H9E1pPqXzRuNk4ynq9CC638mdL+SBCRQaiqMcHSwMz7A8/esn8qOfstlskWf4esiZ8Mu/uq3eSjRvpdJXd7x69fug9+I2/inlY1Aboq2UY9aW4h/ubG8H+0FwbZyn0+1Fuv44vy4/Ime0TcalbPh8jl/cXRfkx26Ck0pVXOWMg1FUQSB6UgbgNb7M59uT3Ln7s/BdDbAbpDNo2KlY3MtuleHMPVz3EtI7uBI+K7h9pM6kNHW5y3458OPP24IhpiTrcew3TU00FZQFkopaYOGGhseXH3gjPsx4cVx/tk0jfrDq2sqrnHLPT1crpYars3BrgTwacgYIHDC61oKjzdzQflqqQAuPIAfcOeB/iVU3GKhutI+hvLTXRSt3ZKZrfRIPfjkPaVzHZraB6RddOoqWVhru7n1GzubfpobuTgjcTcXSuudhdjrI5JNJSSW+qYeNPNKZWHrjgHOb7SfctYXfY7tAt2878gy1cY+fTOD8+71vqXatO2s0q+jmNRRfZLg/p5M0lS0q03yz4GudxNxXG4W6st9U+kr6SalqGHD4pmFjm+0FeHZ+CkUZRmlKLymYzWCl3E3FVdn4J2fgqgUu4tubFNIQVVnqb3VxBz5nGGnLuTWDg5w8STj2ArVvZ+C6C2K1MMugaWJjhv08kkcjfEuJAPueCoH9o11WttGfQ8N6ST8OL97SRsdLhGdx6XUjCNp1jpbI6iprfBuz1rn4b6uGtAznHi4fA+xa6p4RTjemm3Z4JPQjOPTOckZ54wQto7f4JH1Nrq453NZHHMRu+sSXNPD3HktZuo2RtbVG4u9J5BaX8Bjrhcn01ydtH0vW5+9E3t1u08J8zobT+ibPJQNkZTRyQVMQ3mlvBzXAHH9YfWei0BrzT7tN6sr7PnejhkzE483RuAc0+3BGfHK6s0pKyKwWyBzt98VJEx2914NOf89y09rWxs1ptvqaKOQR0dNFG6unBGIo2sBfx7+O77Vb+zDaCrZajd/eZvoI03KX/ANWkn4vLXflI0WsW0Z04bq9LODTT4HsDHPYWh43mkjmMkZHvBXzuLK9olworrqqpktTGx2yANpqJjQQBEwboIzx48Xce9Y92fgvozT69S5tadarDclJJ7vWs8cPvXJ95F6kVGbinnBS7ibiqN30y3HQf5+pfXZ+Cy00+RQUu4m4qtsLnODWtLieAACym1bNtcXMt810xct1wyHyQFjcd+XYVi4u7e2Wa01Fd7S+JVGEpeqsmF7iv2grDd75qWkprOzEzZA90pOGRNB4uce77eS3JofYEHBs2rqqVsjsltHSPa13vc7n7APet3aasdm01bY7dYGiiDASIXsGXEYy53AF55ZOfeoFr+3NnTpToWi35PKy/V/v8O8z7exm2pT4HpYKAUVubJv09W8ACQbx4d5B5fUM/WtV+UhbKa46DmrmscX0crZGB4y6IlwDhnmAQeXLg3HBbXrqrzh7sjsKpgOC3jkZ6HqOWR/gVq/bRco6fQ9zdOGNNTH5vudTLvDGPdvH2ALk+kV509St1R578eXijb1Yp0pb3YzljcW/fI+nLK3UVJ0fHBIP5peP7y0Z2fgtyeSc8s1vc4M8H24ux7JGD+8u0/aHRVXZy5XYk/KSZpNOeLmP56jOvKtY/9zmlkYSN24xh2O4seuSr+C62SADJyPtXY/lLU3nGyaukH/y88Mv9cN/vLkS+Ub47G+oky0l7AG/zguDbJSTr0E/xr4o6ZRUqmi3GP3Yz/pMWp4RGMni77F6oi+loQUFhHEm23lhd57HXb+yrS5/+1wD4MAXBi7t2IO3tkmmT/wDQMHw4Liv22x/5C1f8b+BJdmX+tn4GZIi+ZHtjaXPcGgdSvnEmB9LwfM5zjHTgOcODnH1W/ifD7FHyk4yd6KHu5Od+A+v2KnFQ6b9729rWsbwMuPRb4DvK95A9S6OB+6MzVLx7z+AXtFG7O/K4Of4cm+z8VFLTsp2kNy5zuLnuOS4+K9l43kGifLQp3O0BaKto4RXQMJ7t6N5/uqq2J6qZq/QdP28ubhRAU9Tx45aPRf7wAfaCq7yt6U1GyCaUY/e1dDKfrZ/eXL+zHWldojUQuNMztqeVvZ1VOTgSM+4jofb3rqGzdt980Xdj60ZPHuePea2vU6K4y+TRtzypNP8AndlotSxsAqKJ/mtVgcSxxyx3sBz+34LnhdqamoqXWGgpmwEtjudEHRF45B4DmkjvBIPgQuLZGOjkdG8Yc0kEdxCk2h13Oi6b5xZjXcMS3l1nyiIt2YgREQBERAEREAREQBERAEREAREQEopRAQilEBCKUQEIpRAQilEBCKUQEIpRAdS+TTcGVOzynp+AdSzS059u8ZPsk+oql217LLhrLUVBdbRNSwOMfYVZmcRhoOWuAA48yPgsZ8k+4h097sUpJa9jKqMZxgg7riPi34LJNpO1i7aH1dLZprNT11MYmSwSmQxvc0jjngQeIPIKJVKVenqE+g9bn5myjKEqC3+RnGxrZ5aNEXZrre189TJQyMqquQ8XkviIAHJo4Hh8SVtZaN8mbVl11rqHVV5uOGRsZTRQQMJ3IWkyHA8TjievwW8lzjaXpVqM41XmSSz5J/MzrdxdNOPIIiLQl4pK+jFRiSN3ZTt9V4+w+CpKa4Ne51FcmBknIk+q5XZUN1t7K2LhhsrfVd9xXqB65kpxkl00PeBl7f8AmH1+1VDHNe0OY4OaeRBWN0VxqbfKaepa5zGnBaebfYse2xa8OhNP23UNvp46yKouTKapgLi3eYY5HEj6LstHH49MZtjY1tQuIW1BZnJ4S7WW6tWNKDnPkjlnbfJ2u1rUrs//ADzm/AAfcsMV51zeKe/6zvF4pmyMhrKuSeNkgw4Nc7IyrMvtnQqMqGmW9Kaw4wgmuxqKTRzS6kpV5yXJt/EK+6I/63k/3J+1qsSv2iP+tpP9yftCwdrf+jV/BfFEg2M/65bfzfJnX/k3M3NBTu+nXSH+qwfcsX8rN5NPp+DoXzvPuDB95WaeT7GGbNaZ45yTzOP7RH3LCPKr9Kr0+zujnP1sXEdgoqptVQz2y90JEq2plmrcP+J/E0N2fgtneTzVOj1LV28u3Y5YhOfEsy0D/wBQn3LXfZ+Cvug7m2yaqo6+QkQgmOXH0XAtJ92c+5fQ+1NhK/0ivQistxyvFcV8CF2lTo60ZM6cpah72NMTnNkqPT38cWN6eGcYHxPHiqykkEoLYyWU7ScuDuMnec88ePX2c7LBM2WnkmiefltxjHjnuloPD9olV8p9GKmaMMdxdj6Ixw+sL5ejUaJU0XGS6RU1I+odUR0NFE3Lp34bw7xngB7eaw+t2tadZUblDbZ7rjlLM7db/N3gT9QWptsOr571qeWy00xFut8hj3WnhJKODnH2HIHs8VaLR81bOEZRjllhtN4Nz3HU2ktVxCG+aMp3s6PY5pe32EBpHxWvddbKaM0Ut50VUyVVPGC6WhkOZWDj6vU8uR4nHAlV1m6LM7K+SN7JYnFr28uPAjqD4FbDTdptQ0mqpUJ+j1xfqv2fNcSipa06yxJHMhjwcEJ2fgtibZ7DBbdSR3Cjj7OnuTDNuYxuyfPH1g+8rBez8F9GaRqVPVLKnd0uU15Pk17HlEbrUnSm4PqIobZXV5eKGhqaosGX9jE5+6O84HBXrRupKzTU9RCGuME3CSMji1w5OHjzB8CqOx19TZ7rT3GkcWywv3uBxvDqPeMhXTWtbabtVG7UT445pOM7Bw3z9L296jmvajTheR03UoJ29dYUuPCSfKXualw4811lynJU0qkJYkivurLxrO3xzzUvaU8TjM3snguyGnLfAn8Fg2n7NJfruYLfC9/Y/KTlzstDWng3jwyeA9xVwo6iro5O0pKmanf9KJ5afqVTPV9kIzbpX0zpogavsnlplky7LnY5lRx7EVLOuqNOtmM87mV6uE288ePDljHHqJBba/GnSalF73Vx4GYP15eLNJNS1kLfOY2+g0PyA7jjPcBzx9xVsrbzNaNDy25r3G76glNVcZj64g+Yw/rHLvYR3q06ZpLfLWed3WQeaw+k5meMpHT2d/8AnFHVPlud1lnduMdPJn0nBrWgngB4AcMeCaXomiWNWdCDzGi4zqzxwclnchwzwi8za4+ko5b4paqtfVaq3s9yXZ2/QtXZ+Cdn4K+zWKaKOV8tXRxNjGC50notd0Du7OQvBtkuchZI2lO7g59JuQeHMZUpht5s/NSauo+j28M+Gefs4mv6KXYWhlP2ji5vE4yPHH/uti7ONl1RfqNl3vlU622s8WED5WYfog8h3HHHoFjVls0jbpJDKWgRZfv5y05zwz3cT8MLbdu2h2mCngpamirW9gxsPJpDA0Y4DP1rne0X2g1LevUoafUTUsPeXHn2fX3dm6oWNN0Y1avLkX+zt0JovH5J0zLUTNGHVMr/AE3+8kkezAHgrxSbV9MCbsqqkrrV3PaS6Me0NP3KxVgo7nRNraGVs8EnJzfsPcfBYLqC3et6KgX6RrXU3OtJyb628vzZn9FGK9HkdBNusVVRtnbUQ3Cikb6M0eHZ7yccD7gqerlEbPlH9pTH0t4uyWdxB7vsXP2znU9TpjUTKSaYm1VcgZOxx9GNx4CQd2OvePYFvOJ5ZI+mONzG+zjy7x7OIPvVmvKUGe03GSyiauaQ/Jk700Q34n/Sx3/YfArTHlE3HtPyfbosGKb99k+IBaPqJ+AW13SNbG1pLiYJhGPY7AA8eDh8FoDavdobzqkmmcHU9JCynYQOBI4u+ske5Sv7PrOV5rcJtZjTTk/LC97RjajPcoNdpg/Z+C2Z5NMroNpsbGkgTUcsZ8Rwd/dWvez8FnmwPMe1O1fpCVp/onLs+2FLpNCu4/wSfks/I0lm8V4eKN77boxJswvDSAQGxux7JGlcg6y/6hl/XZ/aC7H2ut39m18H/wBPn4OC441j/wBQTfrx/wBsL5p2VeLuj/8AJH4o67pvHQb1fwy/oMHREX1IcEC7q2FHOyLTX/gm/aVwqurNiW0uzy2vR2gLd2k9wlpHiqnAwyn3WvfujPrO9EeAzzPJcg+2KwuLzTaPQQctyUpSx1RUW232L/bmSHZ2rCnWlvPGUkvHJu6aYMcGMaXyHk0fae4LwnfFTN84rJQXD1R0HsHf4qmrbhTW9rooAJJjxPHPHvceqo7fST3OfzqscTEDwH0vAeC+ZfAmpVw9vdXb8gdFSA8Gjm/2+CukbGRsDGNDWjgAFLQGtDWgADgAFKpAREXgMS2t2Sj1FoeqtFe+VlNUTQte6IgOGZGgEZB6kLlq57EdT0WraSgp4xW2ueYDz1mAGMz6RePmkDPt6LqrawamPZxfamjf2dTS0rqqJ3c6IiQfW1aQt/lBWI22E1tnuPn+4BKyEMMZd4Euzg+xdE2QrXcLSaoLK3nleKXEwbqNJyW/wNvvjipaBkETQyKMMYxoHAAYAAXDd8mZUXquqIxhktTI9o8C4kLsDXd2nt+zi5X2YGlqBQF0cef4GR7cAZ6kFwGVxopXs/TaU5vuRi3suSIRSikZgkIpRAQilEBCKUQEIpRAQilEBCKUQEIpRAEUogIRSiAhFKICEUogIRSiAhFKICEUogNheTvXSUe1S2sY7dZUslhkGfWBYSB8Wg+5Zh5W1Ixt1sNaG+nJDLET3hrmkf2itcbIHbm07T5761g+JwtreVu3NHp53dJOPqYtJXW7qdNrrX1MuHG3kZN5FdI6PSl+ri3DZq1kQPfuMz/fW/1pjyPYTHsrnkIwJbnK4eOGMH3Lc65LtLPf1Wu+/HksG0tVilEIiLRF8IiICiulvjrY+jZQPRd9xXOvlaCek0fbYH5YfykCR0OI5OP1ldLrRHlowxSbP7QS0dp+VWgO6gdjLkfEBS7YNv8AxDaJfi+TMDVP8pU8DlGOVk2AfReOS+94tOH8ujlQyMdG7B4L3hqMDdk4jvX1/TuOOJ8H+eZz+VPrRVK/aI/62l/3J+0LHgC0As9Jvd+CyHQrg65ykH/Un7QtPtdL/wBGr+C+KJHsUv8A1238X8Gdn7AxjZlQf7yb/iOWvPKeJfqW1Rk5DaRxA9rz+C2LsF/7Mbd+vN/xHLXXlKAu1hQDuoR/beuO/ZxHO1MH2b/9LJHtQ/1lf+Z/1Gouz8E7PwVVueCbngvp8g5uDZFffyjYhb53DzqgkZgdXxkbgPu5fDvWwS14uJcfVMLQ32guz9oXNthuVXZrkyupCN9oLXNPqvaebT4Fb70hqGk1LaWVtLkVVNwqKfPpgHmcdQcZHsx3r59272Vq6ddyvKEc0ZvP8rfNPub5eRIrC7VSChJ8Uc0VbZWagr2T57VtVIH5+lvHKyS0fNWxtT7OKep2h0t73gLTWvMlWG4JZIBnOOrXHBP87wVfb9PU0lZJeZsRte4Npad0JcHMDgC4Z44xy68cKF3N/GOEl1dvIz6Vu5cSg03Zpqi3vrRU0zI4y0EOfxy48vdzPgsk0+YmQOrHvgkiYTGGb/pOfg/UMZK8GmC4ukrakxQZJEEcUPrvLt0DvwN0/DxVVHLTVdVWuu3m0b427sNO75NwccMaN0nPDmtHO6nVfDl/vxfZ4dZnRoxjzLbqixUF8t8DL3DVRPjcHUoY5o9F44k8+e7wH3LWms9AXCwySysdHJTMGTl43m8ASDwGcAhbTmfaRb3S11Wyple8CGKSoO+1jOHFpPXgOI71bKuxx3qgmiEFPDK2N5mYylLHNaAMHedhvjwz1Um2b2y1HRatOnCo3S4Zi1lJOWW8cPS61hmLdafRuE21x7e/HwNHdn4LF7xRGG4SbuQ1/pjj38/rytgXy0VNpr5KWoje3dcQ1zhjeA9isd2oHVMbXxAdozoeo7l33aO0hrmkqraPffCUcdfavLq7Vggd9QnuOGPSRbtPyl8Jp5Dl0Yy3PVv+C8o5zFRVVU3O/LMWx5+r7yvKne6mqMuBYcFrsjiMj/JXvQU76/s4hlkUIO8cdSeijOna3dXNrStoca8VOKT559FJvsxFyy+4waNzOcFFetxXwKWyU1RNVCR8khhj4uy44J6BZlbqFrW+ezyPaIncYoozJIDnhloBI4+HwXzbKBs1RBRRvhga927vyvDGN6kkngtt2fSekLdY6mnm1Db6qpqMOjqDM1m5gcAAHHhnOe8FRvbq/hsppMNNoVW6tZ5mow3nJPg+PFRXZwy+OOs3um6fOawmu9t4/v3GoKu1zX271lJLYBHFPEA6r3tyVzDkFg3Q7eOByyOB4gdfjzYtdBRv86DYH9m2SSd5ljHDIDwQeQ6+Cz+9XGisdrqK6B7ZZmOY2SVjhKCC5ud08j6J4dOSwTXlw7eGGZlQwy1JeXiH1N0HBAPUZzx6rkmnUrq8q06W7uxk8LOeaXF+RspStadCpV397cXHD78Y8TJdlWiJbmyV9BdZpqATvM/b7pbvPGTugelg9QTzOea3BNoew1VtbTVdvpWTBuO2pWdkRjgMcT06HIXOmynUFXYdZ28xVBipqudlNVAnDeze4NLj4tzkHwXUMlLFTyte0ebSuka0gykMLnAuIAzxIcD8VjbU7M6jbzqXCrrcit5YWG+ec46/czM0HUbe7o43HnOGm8ruNWxaf1vp99Wy0wvnoRKeLSx3aAcAdwneB9i8Teoq+2TuqY209bCQx8bjuguPDPHlxznuW54mCKMMBJxzJ5k9StEbWKign1pUuoHMcGsa2ZzSCHSDnjHhuj2grU7Na1cXlw6M45SWcr5+JVrm7pdt0sJc+GPHs8C01tPBMxwglZLuHDnAjie9dAQ73a0oPr9kd72boz9eFzbC50cjZG4DmnIOFveh1TSs0XFqm5kRCSPs2xt5vkBIcGjxcPcBlTaM53dVUaazLPBLjnPYYul3SqUE5LHD3fn/AHZb9pF8FksFW9o/fNTN2VNjvDQd/wBx+sBaC7PwWR6uvtXqK5eczjciYC2GIHgwE5PvJ4n8AFZtzwX0XsVs49EsMVV+tnxl3di9nxbNdfXPT1OHJcil7PwWabEW7u1CzH9OQf8ApPWK7ngst2O/J7S7K7/vXj4xuC220yzo12v/AOc/6WWbX9tDxXxOgNqgzs7vg/8ApHLjTWH/AMPz/rR/22rs3ah/2e3z/wAG/wCxcZ6w/wDh+f8AWZ/bC+Xtlv8AN0v54/FHXtK/6Je/yy/pZgqhzg0cT7PFQXcd1oyfqC+HvZFxcd55X1HKaSODqOT6cMgmTAb3fis48n6re3a9ZexJbwnG8Of8BItdSyukPE8O5bK8mSkbNtpsHbNywmf0e/5CRRPays56LeKK4dHPP+lmwsIKNzTb7V8TsCz2x1S4TzgiHPAdXf4LJGtDWhrQAAMADogAAAAwB0Ur40bOiBEReAIiICx6/hNRoS/wDnJbaho98blwboigFz1jZ7e71Z62JjvYXDP1L9BbrB51bKumJx20L4/i0hcJbI4SdqtjicMFtaM+7J+5dI2Gq7ttcpdWH7n9DW30czgbu8qO4Cl2fQULX4dWVjGlvexoLj9e6uYF0F5XD8UunI8831DiPYI/xXPymmiQUbRPtb+hiXbzUZCKUW2MYhFKICEUogIRSiAhFKICEUogIRSiAhFKICcJhEQDCYREAwmERAMJhEQDCYREAwmERAMJhEQGT7J+G0rT3/5CH+0FtzytR/0bYD/3032NWo9lP/aTp3/8jD/bC275Wv8A1bYP99N9jVpLr/qNHwfzMun+wkbO8lenMGxq3PIx2888g8flC3+6tprAvJ8pzTbHNOMcMF1MZP2nud96z1ca1ie/qFeX8Uvizb0VinFdwREWtLgREQBaG8s6QDRtki6uuJd8Inj71vlc/eWi7/oHTzO+qlPwYPxUz+z2O9tLaL+L5M12rPFnU8Dl+RjXt3XBUU0To3ceI6FV6hzQ5pa4ZBX2DWoKou857CbiUMUrozw4juV0tVwkpKjzmlcGvxhwIyCO4q2zwmM5HFq8mkg5BwVrKsIyhKhXjvRfNMzaFapRqRr0JOMlxTR315O8zqjZNaZnsDHPMjiAcgZeSsF8oxu9rKi4f/IN/tvWaeTW/f2R2wcBuSTMwPCQrHtvNpuVfqijmordV1LBRhpdDC54B33HGQPFcR+z6tTobURlUaivT5vC5MnO0W9N1et7z+Jp7s/BelPSzVEoighfK88msbkq8/m5fv5Euf8A5V/4Kpt1q1RbqkVFHarpFIOGRSPPj3eC+irrVaEaMnb1YOeOCc0lnvaz8CIwpNyW+njwPm0aYZHXiPU/ndppwRl7oT14njg44EdOquEVBTUF4hm0bd6s1HaYD3t4BufncAMYwSCCl2OuLq1wr6G6ShxJd+8nNznnyb/ngqqzVWsLXbX2+Gw1b4X4BD6F54A5xy7+a59qFbW68HcOvTcm8dEpwcHHHXvLjl81nPHhJcEtpSVtF7m6/HDzn2fnuM2udXdIa7MVXTmaON1PUSQx5Y+RwJAY3JIc7hwB4EnOMr4t09wo4qwV0MQnkaQY6iRrWx4yDuhpPJ2MYPHA5cVrySm1eaqOoitt2gfEMR9lTPbuezAV4s111tb2SMkslfVds1zJHzUspfuuOTg9/PicrnV3sJfKkriNWlKbeXFTjlZzlLOIvq6/A2tPU6OdzDS7cc/mZPT0sUNC2U0tbK+GoO5Vtm3owQ0kEN3hkkgH1eAVVdxU01ve+Wnpq9lQA8VT5CxzADlwGGkj0nDLs9feLBWXa6TU0UcekrzE4ZMgaZg1zjnedugAcRwxjv5rxuNxvDyx9Bpm+QOY0NAkM0rRgfRcMcTnoFG47O6g/RVPjy5xx3vn737GZjvKPPeL66q7CKOjqpaa6yyQsip2xycWOPHAwOOAeeeJPgqdszKetrGXSOqgq53mMMbVSdXceOd13IjmeKo6bUmpezkkrNKV89Y97XduKZ7S3Hd6PDOBy6DCp2XrUJopqeo0lW1D5H73ayUr3Oxx4HI7zk96yamyeqKbjGC4de/Dl/q4/Iojf0McX7n9C4VtBb6Jxg1DaG1MQ3ieyf2smSN7BcTvA8QPRz9qxmbRtorYpqiCrNpbGWtbHUYe6Thxdu5yBzPwCq7bddW0BnEOl53NmY6M71HLloPPB71ba92s6sBhtt3jjbndY2GYhvHOBnPBSnQ9J2k06cYWtxGkuL41YOCyuTjmWXz/AHcZ8zDubizqpucd72PPy+Jg2pbXTxCeMvjqDGwlkjPYrfppodbjgcRIQT38ll1RpvUEscm9Zbm5zwck0r+JPuVq0zpbU8FPLHUaeusfphzc0r+PD2eC61C5t6GpW06lWEpOEozmt1Za3Xl45Zw8eSIjVoy+8qUINJ56vDHE8ezVVQQRFzZH/KPBz2WBgAHBLs4zz4AH78XP83L9/Ilz/wDKv/BPzbv38iXL/wAo/wDBVa9p2maulL7zGE1wzvJ8OPDGe/qwa/U9Fd9Hg3GXbj5fTB5XGjgqo9yWEVIYXHccXNxu+jvEnJPLlnHHvVNtAswnsNLUW+lYDT8SyOHdO4R4k5xw+tV8Wnb/ABOzHZboziM7tNIM/AK6RR6tjzu2Oswf/oX8+/kuT63slqFC5o19PrU6nRtvjOMc54NYbx7clvSNDq2NGpQqTcoy7mse9mv9lumpdRawpKeRhbR08jZ6x5du7sYcAfeSQOHfnot+7TfN7ds/r7z5h21SyNm6zfcBvP3Ml2Dk7rjvce5a+kptWuO9HZq6B/LfjopN7HdlwJVRNJraoppKartlzqoZWubI2WmkO8HAgjOOueKy6ukajcKNSuqf8qqxfDr54XHxJHp1vC1t5U4tqTzxx5eRqyXV+qpInRP1FczG4bpb5w7GO7GVYg94ky55LjydniVmFbs81OJXOpbLcHRniGup35Hhnd4r5g2c6ok9Ke1XCHdOWgUj3Z9vBZ9tpNGjLdowhFvscF5tPBGa1rqFWW7U3pY7W2veW+w3SUyilqHF4I9Bx4uz3eKyOWprKikp6aome+KnDhFHn0WBzi44HtJ4patBXuiqO3farnK8D0f3m8AfUrt+bl+/kS5/+Vf+ClGy+h6Vpded7OcFUlwS3o4iuvHHg31/3ZuLaN0qKhVTyWLs/BOz8Fffzcv38iXP/wAq/wDBPzcv38iXP/yr/wAFOv0pY/8AvR/1L6lzop/hZYuz8FlGylhG0SykD/Xn+y5Un5uX7+RLn/5V/wCCyXZdYrvT6+tM9Taq6GFkji58lO9rW/Juxkkd6020WpWctIulGrFt05/vL8L7y/bUp9NDg+a+JuLao4M2dX1ziABRvySuH9X3UytfbWROYw7pe93AnkRgdPeu29r0rYdml+ld6raU5+IXBGsagzXd7mgta5oOPqXAvs8tqNa+zWjlRy14rGCdXt7WtdCrKjLDlJRf8rTyW6WdrRuRY9qpiS45OSSjQXHAGSqyngDPSdxd9i7wlO4l3HMHu00fNPT49J449AtneTV/22ae9tR//XlWuVsXya/+23Tv61R//WlWv2qpxhoF6l/7U/6WV2MnK7pt/iXxO2kRF8UHSQiIgCIiAhwy0jvC4e2d03m23qkpf9jdJmfs74+5dxLi/T8BpfKblgPzL3Uj3Zkwp3sVPCuo/wAP1+pg3q4wfeZN5XHPTg/8R/8ArWhMLfXlb+tp32VH/wCtaFXRNH/ycPb8Wa+6/asYTCItmY4wmERAMJhEQDCYREAwmERAMJhEQDCYREAwiIgJRSiAhFKICEUogIRSiAhFKICEUogIRSiA2TsH0ZeL3qmjv0DGw2+21LZHzSDg9zTncaOp7+74LZ3lLacvF601SXChgZLHbHSSzsa4l+4QMuAxxAxxVd5O1+ttTs6o7ZHMPPKJ0jJoWjLwC8uDsDjghw49+VmWsNR26wabrbpXEtjiidusewt7V2ODBkcSTwUQuryt9/UlHjF4S/PabOnSh0OM8zIdkERh2WaYjIwfyZAce1gP3rK1a9JUxo9K2mkc3dMNFFGR3YYArouSXU+krzn2tv3mxgsRSCIixyoIiIAuevLSP/RGnB/3839lq6FXO3lqPAotMx9XSVDvgI/xU3+ziO9tNaLvf9MjW6w8WVTw+aOaURF9inOwQCMEZCo6iAsO83i37FWIeRVmtSjUjxK4TcWdp+SxKZNmG4Tnsq6Vo8ODT962utO+Sc8DQVXCCeFUJOPe6Nn/ACrNte3S4W6ajbRVBhEjXlwDQc4x3+1fJM7Sd1fyoweG2+fhk6rqn6m4qOXb8TLEWrfzlv38fd+w38E/OW/fx9/7DfwWy/wrefij5v6Gq++0+xm0kWrfzlv38oP/AGG/go/OW/fyg/8AYb+Cf4VvPxR839B99p9jNpotWfnLfv5Qf+w38E/OW/fyg/8AYb+Cf4VvPxR839B99p9jNpotWfnNfv5Qd+w38E/Oa/8A8fd+w38E/wAK3n4o+b+g++0+xm00WrPzmv8A/H3fsN/BPzmv/wDH3fsN/BP8K3n4o+b+g++0+xm00WrPzmv/APH3fsN/BPzmv38oO/Yb+Cf4VvPxR839B99p9jNpotV/nNfv5Qd+w38E/Oa/fyg79hv4J/hW8/FHzf0H32n2M2oi1X+c1+/lB37DfwT85r9/H3fsN/BP8K3n4o+b+g++0+xm1EWq/wA57/8Ax937DfwT857/APx937DfwT/Ct5+KPm/oPvtPsZtRFqv857//AB937DfwT857/wDx937DfwT/AArefij5v6D77T7GbURar/Oe/fx937DfwT8579/H3fsN/BP8K3n4o+b+g++0+xm1EWq/znv38fd+w38E/Oe/fx937DfwT/Ct5+KPm/oPvtPsZtRFqv8AOe/fx937DfwUfnPfv4+/9hv4J/hW8/FHzf0H32n2M2qi1V+c9+/j7/2G/grrpO+3it1BS01TVukheXb7S1vHDSR078KzcbN3VClKrKUcJZ5v6FUbuEmkkz329SmLZLfiPnQsb8ZGhcIajaXXMNaMncH3ruTyipC3ZVcKdoy+plhib4fKBx+ppXFepIGwXV0YOSGNyfcph9mdNTvd19kvkZOsRlHQp1McN9L3FpghEY73dSvREXfoxUVhHMm23lhbB8nSVsO2rTj3cu1mb+1BIB9q18st2NymHarpl4OD+UYm/tHd+9aTaeHSaLdx7ac/6WZNi8XNN/xL4neSIi+IDpgREQBERAFyhPZa4eVdXupKWSeOmrfOp3MHBjHxA5J9rsLq9a2p57XBr3VVOOzir3VEEsxcQC9hgYGe4Fr/AK+9SjZa5lQrVcLOYNe9GPcQU93xNW+VBZLvdbXbLpR2+WSmt/a+ckEFzA7dw7Azw9E5PRc7LvB81O5jmukic0g5BcOXVcQamfRy6juclujbFRvq5TTsbybGXndA92F0zQrmU6bpNer8zW3lNKW92luRSi3xhkIpRAQilEBCKUQEIpRAQilEBCKUQEIpRASiIgCIiAIiIAiIgCIiAIiIAiIgN7eShaJfObxfXtxEGNpYz3uyHO+Ho/FZr5RlKanZu8hueyrIHHwy7d/vLANku13T+l9JQ2O5WmsY+BziJaVrXiXeJOXZLcHjjryVVUbTrPqixT2B8NabhdLxF2QdG0MbH5wwsyQeYY1oPj8VFbmhcu8ddx4JryRsITpqluZ4nVMAxBGO5o+xfahvqj2KVxhm2CIi8AREQBc3eWuflNJt7xWH/grpFcu+WhXGXU+n7bjhT0cs2f8AePA//UugfZdBz2otsdW+/wDwkarXHixn7PijQSIi+vDnwRFKA648kicu0/cqfPBraZ/xa4fctg7SYXOFBNj0Wl7M+Jwcf1T8FqXyTqksus9Ln0ZbYx/vaW/8xW6deM37VB+jUA/1XL5RoPo9Yi+/48Dr+0dPduJ96i//ABRgHZp2aq+z8E7NdEIgUnZqOz8FWdmnZoCj7PwTs/BVnZqOyQFJ2fgnZ+Cq+z8E7PwQFH2admqzs/BOz8EBR9msT15ra2aVYIXtNVXvbllOw4wO9x6D61l9zkfSW6pqo4HzvhidI2JnFzyBndHiVyrfH3WvvVRU3SOZtXM8vkErS0jwweg5ALBvrl0IejzZudG02N7Ve/yXV1syyt2qaoqZHebNpKVhPAMi3iPecqnZtB1mTn8pt9nm8f4LGY6OTHrO9yPgnj4tkePrWhlfVZPhMnNPRLWC40l5GbW7adqemkaaplJWR/ODo9wn2EfgtsaNv1Jqaztr6ZjontduSxOOSx2AceI48Cud6KYSSdhOA159U9D4LZuxCpdTX6rtriBHUw74B+kw9PcT8FlWOoVemVKo8pms1vQbdWcrm3jhx549/D3m1ez8E7NVfZ+Cdn4KREAKPs07NVnZ+CdmgKPs07PwVX2admgKTs/BR2fgqzs07JAUfZ+Cdn4Ks7PwUdn4ICk7NZDs+gDtRbzh/BwPcPblo+wlWns/BZLs/i/6SqZAPUhAPhvHh/ZK1OuT3LCo+74tIvW6zVRZPKUlLNDUsQP8JXsz7mPXHerDm+z+Ab/ZC6t8qCsLaOyUDXcHySyuH6oaB/acuT9UnOoKsdxYP6jVf+zCH/P5/hl8USTaOO5stB/iqfKX0LYiIu8nJQsl2WO3dpmmHZx/0tTf8VqxpXzZ+8s15p945i6Ux/8AVatZrMOk064h2wkv/Fl+2eK0H3r4n6BoiL4WOnhERAEREAWkr1by3yn5KhxIa7T7Zxjqe07Pj8Ct2rT20W72bT22imuV6ro6KOfT5gikkBw5wnLiMgdykOzUpK7lGPNxkizXxupvtPvbNRVFfszvUVKXiZkHajcJBIaQ5w4d7QR71x2updPbXtGnTEBu95xWxxmOaMwSOdIWkt3uDcekAD7+K5kvElFLdquW3RyRUb5nugZJjeawk7oOOoGF1TRIVaSnTnFrjzNXduMmpJlKiIt6YYREQBERAEREAREQBERAEREAREQEIiIAiIgCIiAIiIAiIgCIiAIiIAsm2Uxtl2maZa/G6LrTOdnuEjT9yxlZdsajEu06xNIzio3vg0n7lh6jLdtKsuyMvgyumszXid6ovC3y9vRQyk5LmjPt6r3XzySMIiIAiIgC5J8sOUP2n0TB/q7TED7TJKfvC62XG3lV1ravbBVwtaQaSlggd4nd3/seF1D7IaXSbRxl+GEn8F8zSbQSxZtdrRqlERfVhBAiIgOgvJprzSaxsrM4ZV0Zhf8A0e8PraF0nquEzWOZrfWaWOB7sOGfqyuR9k1wFuvGmq7ewyKWDtCPo5Ad9WV2Jc4XVNtqYGENdJE5rT3EjgV8n6o+g1FVOyXwkdt2jpZVGp+KnH4f7Gvuz8E7PwVW1gLQe8KezXReZAij7PwTs/BVfZp2aApOzUdmqzs07PwXoKPs07NVnZqOzXgKTs07PwVX2admgLbXyso6GerlHycMbpHY7gMlc13evrNQ3ma51zsySu9FvRjejR4BdC7SaltBoW7zu+dTOiHtf6A+ty5+s8bXPaCo5r9eUd2mjoewtlCo6leS4rgvi/kfcFsc5uQxeFZbywcWrYVnoYZIeOBwVp1FTRsDsYUccJRjvZOgxrU5z6PBrS4U+6cjgRywsy2dVZiv1mr3Hd3phG88uZLD9qx66tHFVunpALUx7Th0Ux4/A/esiNVxUanY0YFS1U5VKHVOLR032ajs1UUxbPTRTMIc2RgcCOoIyvTs1PjhT4FH2fgnZ+CrOzUdmvQUnZ+CjsvBVnZp2a8BR9mnZqs7NOy8F6Cj7NOzVX2admvAUnZrKNCQtbFWTDm57WH3An+8rF2ayzScLIrQHtHGWRz3e3O79jQo7tPV3LLd7Wl8/kZVms1MmkvKXrBLq6gomkEQUYcfBznu4fBo+K5q1Mc6hrSOW83+w1by21VzK/aTdXxu3mQubAPa1oDh+1laIvTi671bjz7Zw+Bx9y3/ANmVLF6+6m/e4kp22j0OzdrT7ZJ/+Mn8yjREXbjjgVbYas0F9t9cOdNVRTD+a8H7lRKeSs3FPpaUoPrTXmiqEt2SZ+jrDvMae8ZUqjstSayzUVWRgz08cmO7eaD96rF8Fyi4yaZ1RPIREVICIiALmPy1Yt28abmx68E7fg5n4rpxc0eWWe3FjmHFsEs8QPtaw/a0qS7Iy3dXpd+f6WY14s0Wc5oiLtpogiIgCIiAIiIAiIgCIiAIiIAiIgCIiAhFCICUUIgJRQiAlFCICUUIgJRQiAlFCICVnmwCIzbWLOAM7onefdC8rAltTyV4BPtgoQ4ZDaaoJ98Th961ety3dOrv+CXwZdoLNWPidd6Ym36N8RPGN31H/JV2WOWIupbs+mfwLgW+8cVka4EyQhEReAIiIAuHPKCqHVW2PUcjubahsfuZG1o+xdxrhTbn/wBrupv/ABzvsC7F9i0U9arN9VN/1RI9tI/+Wj/N8mYWiIvpohQREQGd6Oe78g0zs4c1zwD7HnC7e0xcPytp23XPdDTVU0cpaOQJaCQuHtHf9QxDue/+0T966w8n+5+f7PYadzsyUMz4Dx44zvN+p2Pcvlnamju3dbunL4s73qdLpdEs666ox98V9C4Pp+xlkhxwje5o9gPD6lHZ+Cud0hay6S4DvlGtkyeWfVOP2R8VT9mpdp1fp7WnU7UvPrOcVY7s2ik7PwUdmqzs/BOz8Fmlso+zTs1Wdn4KOy8EBSdmnZKr7NOzQFJ2fgo7PwVZ2admgNL+Uje/NLZbrHFIA6qkM0wHPcb6vuJP9ValtdSGlpzyV229G6y7Ta78qtkgiY1rKLI9F0QHAtPI8ck+JPcsPZvNaAHv9xUR1VdNWeergdX2Xf3Szjjjni/b+cGxKG89nFjewqG73PtgfSXQugdnthtmiLVDdbFQ1NxNO2SokqqZr5N93pFpLgTwzj3LStVarfNqe80hpIWxCuqI2BrANwdo4Dd7sdMKOyuEpOD6i+9qbeE8xpPzNc3OYHPFfenqj94zx90u98QB9yo7xSOpKuelqJHMdDIWOJPPB8UoIaqjpu0nglijqBvwue0tEjQSN4Z5jgtp0SdF47jYU7xO4jPqafwOtdEO840dZ5TxJooc+0MAKvHZ+CxzY5VsuOze0TNIJZE6JwB5Fji37s+9Zd2anFF71OL7kcZvI7lxOPY38Sk7PwTs/BVfZp2fgrhjlJ2fgo7NVnZ+Cdn4ICj7NOzVZ2fgo7LwQFJ2adkqvs07NAUT2hjC53AAZJWW0YZQ2ePtDuthh3nk+AySfrVgjg7WeKEND+0kALTyIzl31Ar62r3M2jZ9d6puN98HYM49Xnc+oEn3KGbU1N+pSoLx8+C+ZtdLoOrUUVzbSOWr1WG4Xitr3DBqah8pHdvOJ+9asupzdKv/AH7/AO0Vsda2uJDrjVEHIM8hB/nFT37N4L75VfZH5r6En+1HFOwt6a5b3wR4IiLsJxMIiIDv7ZpO+p2dacqJDl8lrpnE+JiashWMbJs/uX6Xz/JNN/wmrJ18IajFRvKqXVKXxZ1Ki804vuQREWEXAiIgPmV4jjc88mgkrmzyqgZdI0FQef5Q4n2scfuXQt/m7K2vAOC8ho+/6lovypKUt2UUNUW+td4x7uyl+/K3uzTxqlF95Yuv2Ujl9FCLupoCUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAhFCICUUIgJRQiAlFCICUUIgJRQiAlFCICVuLyQ2tdtZLjzbb5iPi0fetOLbnklTdntfgb0ko52n9nP3LT7QJvTK+PwsvW/7WPidYX2I09XDcGDk4B/uV6Y4OaHA5BGQvOrhbU0z4XcnDn3HvVHY5nGB1LLwlgO6R4dFwYkBcURF4AiIgC4d8oOnNNtk1HGfnVDZP2o2O+9dxLjTyqKLzTbDXTb2fO6aCf2ehuY/qLrf2NVtzXpw/FTl7nFmh2jjm1T7GvmarREX1CQcIiIDNNEyb9oezH8HM5vxAP3rfHk0XcU9/uFmkPo1cIlj4/OYeWPEOJ9y5/0G8+bVUfQSB3xGPuWcaUvp01qa23vLhHTVDDLu8zGTuvH7JK+cNq7bOpXNPtk358T6M0qn9+2XpR69xY8Y/wCx1reY89hNkYa4sOe53+IA96pOzV1mayroiGFrmyMDmEjIzzB+OCqKEdpE1+MZHEdx6hWtlrnfoSovnF+5/wBzl97DElLtKfs1HZqs7PwTs/BSkwyj7PwTs/BVnZ+Cjs0BSdn4KOy8FWdmnZoCj7NOzVZ2adkgLNd7La7xTebXW30tbDnIZPEHgHvGViMWxzQbrvSTQWmSCQTteGR1Em4d07xBbnGMArY3Z+Cq7PDmeafPCNvZj2nifq3fisO+3I0ZSa4mVbVqsJJQk14Miu4AhcxSjGtbyP8A7jP/AMRy6dr+q5jn/wDja8//AJGf/iFcvl+1mbteqjYmitLaZrKuor6yy0VTXvLX9tPEHnAAHDPLGBy71YPKQ0Xdr1QUF2sdE6qkomujngibmQsOC0tA54OeA48fasv0VIYpIZN7Dc7r+Gcg/Zxwfcs97NTjQasL3T+jlzjwfxXuMGrcVbO7VaL8M+TRxhonaRqrQ9PNbaNkDoHSmR1PVwk7ruRxggjkOC3rsP2iXLXklxhuNtp6c0bWO7WAu3XbxPDBzg8O9bNuNktVxaG3C2UdWByE0DX/AGhTarNbLTC6G126koY3u3nMp4WxgnvIA5rcULepSaW/mK6j291C3uoN9Fib68js07NVnZJ2fgsw05R9mnZqr7PwTs/BAUnZ+Cdn4Kr7PwTs0BSdn4KOyVZ2admgPK1RB1x3s/wLN4jHV3AH4By1j5Tl6aymtWn2P9OVzquUDoG+i3PtLnfsrblpbilMuc9q4vHs5D6gD71yltZ1CdRbU7rPHL2lNSDzSn7t1h4478uLjnxXPbip981GpU6o8vZw/uTbZS13runnq4/Qx5xw0nwWrYiXRtc7iSMn2rZlc9sVFPI84a2NxJ9y1qOQXWPs2p+lcT/lXxLX2rVP8rT/AJ3/AEhERdVOPBERePgDvrZW0t2ZaYaeYtNMP/SaslVs0nB5tpa005ZuGKihYW92GAYVzXwde1Okuak11yb82dTprdgkERFilYRF8yOaxjnuOGtGSUBZr9vVNdT0TPaff/gCtaeV1E1myKFjRhsdyhx+w8LaNmYZ6ia4yDjId1g7gtXeWE8M2UQt+ndIR/UkP3LdbP8A/U6H8yLNz+yl4HH6KEXeCPkooRASihEBKKEQEooRASihEBKKEQEooRASihEBCKEQEooRASihEBKKEQEooRASihEBKKEQErZ3kvTiHbXZWuOBKyoZ/wCg8j6wtYLOdglQ2l2wabkccA1gj97mlo+1a7V4b9hXj2wl8GXKLxUi+9HdNG/ejcwkl0biw58OR+GFQ148zuUVa3hHJ6Ev3H/PcvZz/N7wAeDKln9Yf4KprIG1NM+F3Jw4HuPRfP5Ij2RUVolc+m7KXhLCdx49nIqtQBEReALlTyybdLBrq03QsAhq7f2TXZ5vjeS76pGLqkPYZDHvDeAzjwWgvLQt7pNN2C6gAtp6ySnJ6gyM3h7vkj9Sn32ZXf3baW3bfCW9Hzi8e/Bq9ap79lPuw/ecvoiL6+OehERAZFoWUNramDBy+MPB/VOP7yyW6jNBL7vtCw3Ss5gvkAwN2UOjce7IyPrAWaXAZoph+iVwzbi3dHWZS/Eov3Y+R9BfZ/cqvoCp/gco/P5nTnk86mGodnVLFLJvVdtPmk2TxIA9B3vbge0FZ0xgZVSRcA1/yjOGP1h8eP8AOXKPk66q/NzX0VJUSbtDdQKaXPIPz8m748PY4rrOrad1srAS6J29gHmOo8eH14UFt6v6O1FTfqy5+D+jItrdl0dWUVyfFDs07NVTAx7GvY4Oa4ZBHIhT2YXQSLFH2fgnZ+CrOzCjs16Ck7PwTs1V9mnZoCk7NOzVX2admgKTs19RTSUodw34DxcAOLT3jv8AZ8O5VPZp2atVqUasHCXJlUZOLyihrHNe3ea4OaeIIPArmWo/+N7z/wDkJ/8AiFdLVLDFLJHjDDh7ffzHxGfeud7RRi4bU6yic0ubNd5GvAPze1O99WVzOvaThezodfBefI30aidJTNpaDtNRVUraiQGOm78cZPAeHj8PDPOz8FUx07Io2xxsaxjAGta0YAA6L67NdA03TaWn0tynzfN9rNNXryrSzIpOzUdmqzs07NbEsFH2admqvsk7NeApOzTs/BVfZp2a9BR9n4J2fgqzs1HZoCk7PwXlUxlzRE3IMh3cjoOp+GVcOzVNABJUyT8CGZjYff6X1jHuWr1i9+52sprm+C8X9OZeoU+kmkY7tV1IzSeg7jdWv3JxF2VKOpldwb8OfsBXHFkc59XK9xJcRkk9SStreVPqv8o6kp9M0sgNNbR2k+6fWmcOR/Vb/aK1VYB6cp8Aopp9DorZyfOXH6HUtmbXot2b5y4+zqPXUr+zsVWeHpR7n7XD71gCzPW8rmWlkTcfKygO9gyftAWGLtP2d2+5YVKr/el8EvqyA/ahcqpqdOkv3YLzbfywERF0E5qFXWChNzv1vtodu+d1UUG9jON94bn61QrNdhdr/LG1vTlIXbrWVYqHHGeETTLj37mPetZrN0rPTq9w/wByEn5Jsv21PpK0IdrXxO6GDdY1vcML6Q8BkqAQRkcl8LnTyURF4Arbe5HPbHQxH5Sd2D4N6q4kgDJ5BW62NNTVzXBw9E+hFn6I6r0FfBG2GFsTBhrRgLRflhzb+zS3HjiS7NIHgI5APx963ZdpjFSFrD8pIdxntK0J5aU/YaX01bmn0X1Mr8fqMaP763uzEN7VaC7/AIJsx7p4oyOXUUIu6GhJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCIAihEBKKEQEooRASihEBKKEQEooRASihEBKvmz2tFu17p+vPq09yp5HewSNJ+pWJfcMhimZK3mxwcPcrdamqlOUH1po9i8PJ+i1+jc+ibPHwfC4PBCq6KdtTSxzN+cOI7j1XjbKiG52amqozvQ1VO2RuerXNB+wq1Wqp/J9bJRznEZdwPce/3r5zcWm0+okpd5YjFWCpYODxuSj7CqpRwI7wpVICIiAorrTPmhEkBLZ4+LCOZ7wtXeUCX3zZDdYHRZq6Qx1LMDgQx43z4YYXH3LbyxfW2n2XS1V0DQezq4HxTBvMBzSCR8VstIvXYX9G6X7koy8mmWq9PpaUodqaOCEXjOJaGtmo6gelDI6N3gQcFewIIyDkL7joV4VoqUWcxnBweGERFfKD7ikfDKyaP143B7faDkLY8b4qyjbJG7ejmjy0+BC1qsy0VWdtb30rnEvgdwz9E8R94+C5v9omnOpQp3kVxi8PwfLyfxOpfZhqapXVWxm+E1leK5+a+B5TxTUk4yS1zTljh9oXZmx7VbNX6Forg94NZEPN6sZ4iRoGT/OGHe9co1UEdREWPHsPcsz8nrVL9K65FnrpN233XERJOGtl+Y76y33+C47f0/vNHh60eP1J3tFpTdHfhxxx+qOpxAwcA6Vo7hI4AfWnYN+nN/Su/FWvWtNdqnTVW2x1clLcWM34HMx6RHHdOeHHktGt1HtCkgEsOqC8OGQCwA/2eBVnTbKte03L7yoYeMScvkmsfQ5lc3NO3aUoZz4HQ3YN+nN/Su/FOwb9Ob+ld+K5mq9b7R6WZsUt2q953qhsbHZ9mAvA7QtoAldF+WK3tG82di3I926pJT2L1GrFSheQa5+vLl5GI9Wt1+4/JfU6g7Bv05v6V34p2Dfpzf0rvxXLX7pet/wCX5/2Gfgn7peuP5fn/AGGfgsv/AIe63/3Ef9UvoU/pi2/A/JfU6l7Bv05v6V34p2Dfpzf0rvxXLX7peuP5fn/YZ+Cful64/l+f9hn4J/w91v8A7iP+qX0H6YtvwPyX1Opewb9Ob+ld+Kdg36c39K78Vy1+6Xrj+X5/2Gfgn7peuP5fn/YZ+Cf8Pdb/AO4j/ql9B+mLb8D8l9TqGWip5XB0nauLQQD2rsgHn18AqCk0vYKS4G4U1sgiqy5zzOzIeXHOTnnk5PxXNv7peuP5fn/YZ+Cful64/l+f9hn4K2/s41hy3nWhnxl//kq/TVvjG6/d9TqXsG/Tm/pXfinYN+nN/Su/Fctful64/l+f9hn4J+6Xrj+X5/2Gfgrn/D3W/wDuI/6pfQp/TFt+B+S+p1L2Dfpzf0rvxTsG/Tm/pXfiuWv3S9cfy/P+wz8E/dL1x/L8/wCwz8E/4e63/wBxH/VL6D9MW34H5L6nUvYN+nN/Su/FOwb9Ob+ld+K5a/dL1x/L8/7DPwT90vXH8vz/ALDPwT/h7rf/AHEf9UvoP0xbfgfkvqdS9g36c39K78U7Bv05v6V34rlr90vXH8vz/sM/BP3S9cfy/P8AsM/BP+Hut/8AcR/1S+g/TFt+B+S+p1L2Dfpzf0rvxTsG/Tm/pXfiuWv3S9cfy/P+wz8FI2la4JAF/qCTwA3GfgvH9n2tJZdxH/VL6D9L234H5L6nUnYN+nN/Su/FWnWt+pdKaSrr1UAFlLCTGwnG+88Gt95ICx7YvLqWu07JdtSVs07qp/72jkAG7GOG9gAcSc8+gHetT+VRq8115p9JUcuYKIiarweDpSPRH81p+LvBQqrZ1Xeu1nU31F8Wm2uHPGfIkOl0FeVIpLCfF+Bpi51tTcrjUXCsldLUVEjpZXnm5xOSVc7NA+KFz3jBeQQPBeNroMYnmHHm1p+0q5TSMhhfLIcMY0uce4BbqpPPoROsWNr0S6SfDHwMP1tUCW5x07TkQM4+13Ej4AfFWFetXO+qqpamQneleXcTy7h7hge5eS+hdB0/9H6dSt3zS4+L4v3nzbtDqX6T1OtdLlJ8PBcF7kERFuDShbl8kmhiftCq7vUndht9A8tOePaPc1oGOvo7/wBS0tNK2Md7ugXR3klWSWXTNwuQY7tK2rEe8eQjjHA/F7vguefadqcbPZ2vBP0p4j5tZ92TcaJQdS7i+pcTftLPNdKknBjpIzkt+megKvC8qSnjpoGwxjg0c+8969V8jk+CIi8BS3DfkjFNGcOl4E/Rb1P3e9VETGxRtjYMNaMAKcDezjiqS7VraOmJz8o4YYPHvXoKVz/PL6xg4xUwJP63+cfBc5+WzVB9805Rb3GKmml3e7fc0Z/qfUujtOQFlI6d/rynOfD/ADlcneWBcBV7V2UreVFbooj7S57/ALHBSvYulv6rF/hTfux8zEvniizTaKEXZjSEooRASihEBKKEQEooRASihEBKKEQEooRASihEBCKEQEooRASihEBKKEQEooRASihEBKKEQEooRAd8bDa9ty2R6aqQ4u3aFkJJ74/QP1tV71HRdpH53GPSYMPHeO9aw8j25is2VyUJeC+gr5GbueIa4B4+su+BW5yAQQRkHmuAazQ+76hWp9kn5ZyiRUJb1OL7iy6fuG8BSTO4j+Dcevgr2sSutK6irSG5DD6TCr7Zrg2rhDHkCZvMd/itc0XC4IiKkBERAcNeUfpp1i2s3hsUJihrXith48Htk4uI/nh4x4LW0Ur4jjp1BXWflg6UfXaeoNWUsW9Jbn9hVEH/AFLyN1x9j+HD6fw5XmhbJx5O719d7A6j+ltBoVoP04Lcl4x4e9YftIDqtLoLqUZLg+K9p9RyNkGWn3L6VA9kkL88u4hVME4f6LuDvtU3pXGXuz4M1cqeOK5Hsrhp6t8xusUrnYjf8nJk4AB6+44PsyrPLLLE70mtLe9G1LHDD2kZ96x9QpUL23qWtXgpLH9/ZzMvTrqtYXVO6pc4NP8At7eRthedRAybdJy17Tlr2nBaVa9M3SKstMTpZmiVnoOLjjOOvwwq2ouNNECGu7R3c38V8617arb1pUpL0otryPqShe215axrprdmk/M6z2Qao/OjR1PLUSh9wpQIKvjxLgOD/wCcMH25HRYbtGsv5F1K6eFmKK5F0seOTJeb2+/1h7Xdy1psh1odJ6mpp66QxUFc4Q1TcnDQfVefFv2ErpfV1mh1DYJqEva2RwElPLz3JBxa72d/eCQtJF/c7nj6kvz7vgcp2m0hUa0oQ5PjH6fnuNJImJWOfFURGKeJxjljPNjgcEfFfMu92T9wZdunA8VuMccHP2sPDNc3aeaetk7eOGORr3BwiaAM548evvVIq6qtFypmF81HI1o4kghwA8cE4VCu76bO2dCMLeSkorHovP1MKWc5YREWwKQiIgJYAXtBOATxW6tZ6B2XUttt8ln1OySrmrYIXtbcon7sb3APdujuBzk8AovEOw9ujpjbJac6j8wa6NokqN7tcdx9H1s+C2HtIrL8+x2ds+maaBgutGQ8VrXFzhI3DcbvXlnoovd6lOtOnuZjxa7M8jY0qCinnDNc3vZNo5l0tFusWtBVS3CrfFK4zRTdi0RudndaR1aBxPVYftV2fw6BmttJFfBdvOYnOdJ2QYW7pA+kc5yt8a3fdqy+6XhuOj6Mxm4ybsJqmSNmPYScDloA7+PctV+UjSiluFmaNNUti3oZPQgMZEnEcTuAclTpt5XqV6cZSymn2d57cUoRhJpdhqRERSo1oREQBEX3TxOmnjhZjekcGjPeThUTnGEXKXJHpV2u11lxcfN2DcacOkccNBWw9G6Xiq7lSWmmjBkeS6ao3cObGPXdnpzwPEhU1upYbZb2wNeezjBcXOPjkkrcGy+xOttnNxq4iysrgHlrgQY4vmNPceOT4nHRcU2m2orXilh4gn6K7e9/Hs6jbafaKpUWeS5lbri+0ei9F1NwZG0CmhEVJAPnvxhjAO7lnuAJ6Ljx8FTXXGa5XOUy1E8rpZM/OcTkk+9bU2+6wjvWqW2OlnBpLeS3APCSX5x93qj2HvWr21kPauikPZvacEO/FRewpSpU2+tnbtndKp29BVq3rS6uxdX1KhWDWtZ2NA2kYfTnPpceTBz+JwPir/kYzkYWur9cmVtzlnMmWA7kY7mj8eJ96mmx2lq+1GMp+pT9J/JefuTLG3msfo7SpQg/Tq+ivD95+XDxaKRF4GqbnDWuK9d/DN+Qbvgu6xqwlyZ86uLXM+l4T1Ab6LOJ7+5eM07n+i3g37V9RUznYL/RHd1WPOvKo92l5lxQUeMjzjjfK/PHxK7+2M6f/NnZlYrU+Ls520rZJx1Ej/TcD7C4hcf7GtLHVe0S02cwiSkEwnqwc47FnpOBxx443fa4Lu8AAADkFwP7ZdRjGVvpsXlrM5e3hH/9eaJVs7SbU6z5cl8/kSiIuGEmCIvl7msYXuIDQMknogPOsqI6WB00h4DkO89yxqJs12uOXngeLu5rV83audW1Ho5EbeDB96v9loxSUg3h8o/i/wDBVcgVjGtYxrGjDWjAC4R2/wBzZddsOo6mPG4yq83HHP8ABtaw/W0ruurnjpqWaplcGxxMc95PQAZJX5y36udcr5X3F/rVVTJMf5zifvU/2AoZuK1bsSXm8/I12oy9FRKNFCLqJqiUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAhFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgOh/IovDIdQ36xPcQaqmjqYwTwzG7dI9uJB8F1OuEPJ6vn5C2vWGocT2VRP5pIM4yJQWD4OLT7l3euPbb2vQ6l0i5TSftXD5I3VhPNLHYUN6pPOqMho+UZ6TfwWKsc6N4cxxa4ciOYWcKxXa0SOldPSgHe4uZ1z4KIJmYelqvDZMQ1ZDX8g/ofb3K8AgjIIIWESRvjcWyMc1w6EYXrTVdTTnMMzm+Gcj4JgGZosfpr9IBiohDv0mnC9XagZ82lcfa/H3LzAK2/WukvVlrLRXRiSmrIXQyDwcMZHj1XAusrBWaX1RcLDXNImo5jHvEY3282vHg5pB9677t1xgrBhp3JOrCfs71oryutEed26m1tb4czUoFPXhrfWiJ9B5/VJwfBw6NXVPso2l/Req/cqzxTr4XhP91+3l7V2Gi16y6eh0kecfh1/U5hc0ObhwyFRTwujORxb3quQgEYPEL6grUY1F3kJhNxKaGZr29nLx8SvOeEx8RxavWSlaeLDjwRjnxehKMs71jShJrdqr2lxSWcx8io0/V+b1XZPPycvD2HosrpQHVMTTxBeM/FYVLT8d6I8O5Zhprtq6Fknoh8LgJATx9vvXNNs9JlQkrxLg+D8ep+3l5HUtg9V6b/kZcWuMfDrXs5+Zc7849vGzoG5+v/BdL+TZrb84NMfkGum3rja2hrS48ZYOTT4lvqn+b3rmu/s/gn+0FVmhbzdNK6ho9RUDHO7B/pszwkjPBzT4EZ49Oa5tc28bi33evq8Sda5Yyu3OKXpLijpXazYvNqpuoqWMCKUtjrQOjuTJPsaf5vcVg63ja6216p01FWU5bU2+4Qcj1a4YLT3EcQfFaavtqnsd4ntdQXPEfpQSn/WxH1Xe3ofEdxCw7C4c4dHP1o/D+xx/U7Vwl0iXj4lGsI1bQVLLrNUtge6F4Dt9rcgYABz3clm6KR6RqlTTLjp4JPhjD7DTyjvLBqxFnFx01QVLjJDmmeTk7nFp93T3Kk/NGL+OP/Y/xXSKO2enTgnPMX2Yz8DHdGRiShw3mlpzxGOCqa+jnop3RTxPYN4hrnNwHAHmFTqUUa1OvTVSm8pltppmHVDqqkr3fLy9rG7AeXHJGcj3dcLNrrtj2g3SGCCuvr5YYJGSsZ2TAA9pBa7IGcghW+qt1JUy9rNGS/GMgkLy/I1B/snftFQSps1qlOrN29WO63lZbbXZzi/bjn1kijqdnOEelg8444/3RX1O1zX9XJBLWahqqiSmlMsD3HDonFpbwIx0JHvVsvGvNTXsQm93KW5yQAtjkqXFxAJyeq9PyNQf7J37RT8jW/8A2R/aK9p6FrtNpxrRWOC/O6eSv9OlnNN8fz2lLam1lfIKqrlcIWuyxg4An8Ar0phjJLYoYyTya1o+oBQpjY2ytafRue9Lm23xf0XYjSXFbpZ7yWF1JBERZreCwFkWlrLJNNFcKgBsLTvRtz6TiDwPs/Betq0t2kTJq+VzCePZM5jwJWVQwyEwUNDD2k8rhDTxDq7p7gBknoASue7RbU06lN21lLOcqT6sd31MmlSbfEv2grH+X9QNEzN630RbJUZHB7+bI/HvPgAPnLLttmtI9G6PllheBcawGGkaOYOOL/5oPxwsg09bKHSemRDJOxscDHTVVS/0Q92Mvee4fYAB0XJG1fV1TrjWVRcGCTzOL5Kjix6sQPAkd55n246Lk8Ur65z+5H3/AO/wOg7P6XvTSaylxf0MWbUyvr21Mji55fkknmqm+saJo3gcXA59yo6RhfVxMx88ZVxvcUsjo3MY5zWg5IHJbqWFNHTKalK3n4oxy9VppaIhryHv9Foz8SsTALnYAySq+6zSVtaS0Hs2+izux3rz+Tp2/SeV2PZvR3Z2idRYcuL+S9nxycI2o1j9IXr3HmMeC+b9vwwRHGyBm/J6y8JJHyv+wL0MU0x3ncPaveGFsY4cT3qTKnKp6MViJGd5R4viz5p4Az0ncXfYvZFlOyzSVTrXW1BY4Wv7B7+0q5Gj+Dhb65z07h4kKu7uqGm2s7iq8Qgm2+5FNOE69RQjzZ0P5JejvyRpOfVFZBu1l2O7Bvtw5lO08MdRvHj4gNK3evCmgpqCiipqeOOnpoIwyNjQGtY0DAAHQAKkdeqEPLd55x1DeBXxRr2r1dZ1GrfVec3nHYuSXsWEdKtbeNvRjSj1FyRWx97omty0vce4NVuqr5UycIWNiHfzK1GC+X6rqYaWIyTOwOg6n2LGbncpqxxaPQiHJo6+1Uk0sszt6WRzz3uOV6UlJUVT92GMnvPQL1LAKzT9J29V2zx8nFx9p6LJ1T0FMykpmwt444uPeVULxgwvbheW2LZRqGvOd51G6BmD86X5MH3b2fcuBl1l5aF7NJoq1WON+6+4VhleB1ZE3iP2ntPuXJi67sNa9Fp7qv8Afk/JcPjk09/PNTHYSihFNDBJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCIAihEBKKEQEooRASihEBKKEQEooRASihEBKKEQHpBLJBPHNE4skjcHMcOYIOQV+hOj9S0160XZb+M9lXwRl7hyjeRg73scC32r88l1b5H2oo7xom56OrZN99DIZIWu4/IycwPY8E/zgoTtxY9NZxuEvUfHwfD44M6wqbs3HtOgkVjsVZJTzus9dITNGSIZHf6xo449oHvI7yCr4uSyjus3B8TQxTN3ZY2vHc4ZVvnslHJks34j+icj61c0XgLBJp9+Pk6lpPc5uFSS2euj4iNrx+i5ZUiZBhBEkMmCHMe0+wgqtmrobhbai13eBtVSVMToZQR6zXDBBHXgsjq6Snqm7s0Yd3HqPerLWWKVuXUzw8fRdwKqjNxaa4NBrJxHtF0zLpLV1ZZXvMsMbt+mlIx2sR4td7eh8QVjq6p29bPanU+lnVFPRvF2t4MlM4NOZG/OjyO/mPEDvK5LE8sbiyQZIOCCMEL662F2whrumxlVf62GIz8eqX/ANufjldRANU052tZ7vqvivp7CrReUc8b+Gd09xXqp7GcZLKZqWmuZDWhowBgdyr7BcfyfcGzZ+Sd6Ew8O/2j8e9UJIAyeSo2z7sznD1SeIWBqVvRubeVtWXoy4f39jM3TrytZXMLmg8Sg8r6e3kzZ91DZqDtGODmghwIPAj/ACVVxNDY2tbyAACxLSl2ZJH+S6mTMbxiF5PL9E/d8O5ZeAAAByC+ftW02tplw7ar1cn1NdTR9MaFqtDV7dXlHrSTXWmuaf54ribY8nzWDbXcjpqul3aSsfmmJPCOY/N8A77fatt7RNOG/WcSUrW/lKkzJTOPDe+lGT3OA9xDT0XJrHOY4OY4tcDkEHBBXUGx3WQ1Xp0R1Ug/KdGBHUDq8fNk9/Xxz4KM3UJUaiuKft/PfyZF9rdGim7mC9GXrdz7fb8fE1jE/fZndc0gkOa4Yc0g4II6EHhhfSzLapp38n1h1DRMxS1DgK1jRwjeeAl9h5O8cHvKw1bWnUjVgpw5P84/PickuKEqM3FhERVlk8qump6qLsqiJsjM5w4cirNX6XoZm5pXOpnjxLmn3E/er8izLTUbqzeaFRx8Hw8uR44p8zDqjSdWxmYamKV2fVILfxXh+bFz7MuxDnPq7/H8FW1up6unuU0Ip4XRRyOZjjkgHHP/AAVsvV7qrhIWtc6Gn4YjB5+09V0KxqbSVnDecVGSzvNLl2YX57yxLo0e0OmLm9ji7sYyOQc/n8Mr2ptKVj2kzzxQnPAAb3BWqmulwp2hsNXK1o5AuyB7irk/VVwMO4I4Gvxgv3Tn24zhZN3S2kjLFKcWn2JLHn/c8TpmSWuzUVvkMsLXOkIxvPOcexY5q20so5W1dOD2Urjvjnuu5/BXLSl5lq3SU9dUNdLkGMkBpd3jhjl96yCWNkrDHIxr2Hm1wyCoar6/0bU3O4blJc+L9JeL93YXcRnHga+sNNQ1laKeskmYX8IywjBPcchZhS2G1007Jo6c9oziC57jx78E4XkNO0Lbkysj34w1weIm43QR93grwqte12V5VUrapJRa4xzhJ9a4c0IQwuIPAZK2Fsm08WsOpK2P05mllExw9SM83+13T9EDvKxbRmn3akvHYStP5OpiHVbvp9REPb1/R7shbG2iaopdH6YkrnBhnI7Kkh+m/HD3DmfZ4hQe/rtLoIetLn4f3+Hib/SLCdaomllvgka28pLV73QjRltmLHSASXCRp5N5ti9/Anwx3rSFPBHAzcjaAOp6lVdfV1FdWzVtXK6WoneZJHu5ucTkleCv0KapU1BHddJ0unp9FQXGXW+8t7IAL05w4Dd3/eeCoNZXEQUnmMTvlZx6fgzr8eXxVwuVTBbY5q6V2S4BrGZ4uPcFry6V0tRUSTSv3ppDlxHIeAU52S0T7/cK6rL9VT976l9f7kP222gWl2krOg/1tXP/ANYvm/byXn1H1zHBfLWNac4yT1PNfNOQYW46DC9F26OJJSOBvg8BEJAGSQAvCSpYPVG8V5OpGHrMKLfI911l5N2l6bR2jzerjGHXi7tbJuADehg5sYT0z6x9oBGWrQ2wnRkmsNTeeV8ZNot7mvmGPRlfzbH4g8z4e0LrWloKqowIoXbveRgLgf2ubWxqRWj2z7HU+MY/N+wlmgae4t3E/Z838j7uFwnrHYed2Powcv8AFU8UM0p+Sie/9VuVfqKxxR4fUu7R30RwCuzGNY0NY0NaOQAwFwXJKTForRXSDPZBg/SOFVRWCY/ws7G/qjKyFF5kFuprPRQnLmGV36Z4fBXBrWtaGtaGgcgApRAF5STwxzxQPkAklzuN6nAyT7PxHevmuqYqOlkqZ3YYwcccyegHiTwVgmuUdpsd01ddwWtgp3ybo47kTATut8SR7zjwxcp03N4XXwXieN4OVfK01A287VZaCJxMNpp2U3PILz6biP2gP5q1Cqu+XGou95rbpVvL56ud80jj1c45P2qjX0BptorO0p0F+6kvb1+8j1We/NyJRQizS2SihEBKKEQEooRASihEBKKEQEooRASihEAREQEIoRASihEBKKEQEooRASihEBKKEQEooRASihEBKzjYZq46M2kW26SPLaOV3m1YM4HZPwCT+qcO/mrBkVi5t4XNGVGpykmn7SqMnGSkj9FNS0YngZXQOwW4O+w8cc2uB8FVWG5+fwmOYNbVRYEgAwHdzh4H6uXitY+S5rtmrNCNstfMH3S0NEEgdjMsPKN/jgeifYCeazG50s9tuDZaZ25IzJhkIyCDzae8d49h4HC4Je2c7OvO2q84v/Z+DJDTmpxUl1mYIsarr6yrtoip5JaatLhvtb60eOOc8i04xnrnHfi62K4i4Up3wGVEXozMHIHvHgenw5grDdNpZZXkuCIitgIiIAeK5b8qLZO2iq5tb2Gl/ec7t64wxtx2Lz/rQB81x59x48jw6kXxNFHPC+GaNskb2lr2OGQ4HmCOoUg2a2hudAvo3dDiuUo9Ul1p/J9TMW8tIXVJ05ex9jPzYfSuHqEFfGZouHpNW/Nv+xubTUs+pdMwOmsryX1FOwZdR9SR3x+PzevDitIr630LVbHXrSN5Yz4PmuuL7Gup/HmuBAbqjVtajp1V/coS6aUY9IjwCkU0pGcAe0qtRbr7onxk2zG6VrkigLJYznDh4hZ3pG/iuY2irHYqmj0XH/WD8ViD5Y2Z3njI5jmV9RvJIe0OaQctPI571ota2dt9Vouk5YkuT7H9H1kh2d2kuNEuVVgsxfrLtX1XU/kbRV70TqKs0tqGnu1GS7cO7LHnAljPrNP+eYBUbMtDa11Zao6t1r80pnY7OsqndmyYfSDfW94GD0PQbXsexGhjIfebvNUHA+TpmBgB/WOSR7gvnfU7u2sKs7evNOUW00uPw4Hd57Q6Xc2qlKWYzXLDzx7ez84NsWystuo7BHVwblVQ1sPFrhkOaRgtcPiCFpzUtkn05eHW6QufTPBfRzHjvx/RJ+k3IB8CD14bT07aLdpahbSWyIw0OcyNc8uwfp5J+P8AgqnV1hp9Q2d9HKRHK09pTzYyYpAOB9nEgjqCQtVpuo01J7vqPzXf+eo5TqNpCtlU+rlnn7TSSLEdTXDUNsuVRaLg2OkqIH7r+zaQT3EEk8CMEEKbDqNzXvjukxcwgbkm5y8DhdInsvfK1+8xxJc8J5bT61jn5kSc0pbr5mWPc1jC9xAaBkk9FgFTeqtxqI6aaWOnmdkNc4lzfYeY9ivl71I2IRttj4pnHJeXsJAHTqOKxFxyScAZ7uSkOyehPEq13T4PGM9z7Pgy3Vn1IhelPT1NRMYaemnmlHzGRlzjwzwAHHgvmP8AhG+0LqS618/50aVfU3itc1j58OgsMsb2fIHkHNdv+4eKmOoX7tN1RjnOfchQoqpnLObrdpvUdxmlhobBdamSFrXStjo5HGMO9XeAHDODjPcVbZ4pYJ5IJo3xyxuLHseMOa4HBBHQrqSxV8X7oeppPy5qGMPgo8PjtDi9+Gyeu3sDu46cBnJ544asvezTzyx3fWQ1RR7u/VVHmksW7O7dleMEZGCcct0YzyWJa6ypzarcFwxz5su1LXC9HiathkfFKyVhw9jg5p8Qtg2CvmuNB5xNB2R3i0YPBwHUfWPcteLMtPXyhbbYKepnEUsY3MFpwQORzy5YWn20spVreFSnT3pJ4ys5S8F1fD2lii8MyFfdLTVVfXQW6gYJKuoduxg+q3vc7uaBxPw5kLwdNGIO3Dt5hALS3jvZ5Yxzz0W2dmumHWahdcbhGBdKto3wePYM5iMHv6nHM+wLk9xXVvBzlz6l2v8At1/3NnaWzrzx1LmXmyW636W06KcSNZBTsdLPO/gXnGXPcf8APd0XNG1DV0+rtSSVQLm0MGY6SM9GZ9Y+LuZ9w6LpHU9spdSW6e01jpRROID+yeWl7gc8+4EfH2LVN+2IHL5LHeBj5kNWz++3/lUdttTtoVpOtL0u3qOm7NV7Gzm6ld4lyXDgl9TTC8a6qgoqV9TUPDI2DJJ+z2rLdR6B1ZYonzVVmqaiFgJ7Skb2+QPBmXfELS9+uct0nzICynYfk4j08T4/Zy9s+2Z0aWvV92jJbkfWfZ3eLJBtDtdZ6TadJTkpzl6qT977Ev7FBfrxUXSsMriWRDhGzPqj8VbxFIRkMKrYzET6G5nwX2u6Wel0rejGlTeIrlg+e73Ua15XlXrPMpcW3+fIoGPkhdyI7wV9uqpDyACrCAeYyvkRsByGNz7FlK3qRWIy4GL0kXxaKPdmlOcE+3kr7onSN11ZqKmsdqi7SpndxPHcjb1e49GjqfvXvpPT121RfILNZaR9TVTHkPVY3q5x6NHUrtLZFs6tWz6xebU+Ki4zgOrKsjjI76Le5o6D3qA7c7X2uzVu4Re/cSXors/il3di633ZZtdMsKl7PL4QXP6Iuez3Rto0VpmkslshYRA3Mk5aN+aQ+s8+JPwGB0WSIi+U7ivUuKsq1WWZSeW31tk6jFQioxXBBERWT0IiE4GSgC+XvbGxz3uDWtGXOJwAO9Wahvfnd4MLNzzN7S2F/V7hxJz9EjOPZnjnhb73c/yi/wA3pXE0Y9Z4/wBee4fo/b7Odzo3niMkvlkv11ja0ObSxkmMEYOORee4kcB1APHmQtWeWJq1lq0hR6Qo3hs9ycJJ2tON2CMjAI8XYx+qVuWjFNZLNUXC4SsgZHGZp5HnAjY0E8fYMrhHaxq6fW+urhfpN9sMj9yljdzjhbwYPbjifElS7ZDTXeXyrSXoU+Pt6l8/Z3mHe1dynurmzFUUIuwGlJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgIRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgMm2aawuGh9X0l/t5LuyO7PDnAmiPrMP2juIBXd9kulp1ppalu9qqBJS1TA+J+PSjd1a4dCDkEL86lt7yadpcujNTttFyqSLFcXhsgefRgkPASDuHQ+GO5Q3a3Qfv1H7zRX6yC812eK6vIzbO46N7suTOn6mCSnmdFK3dc36/EL4hlmpallXTECVnDB5Pb1afx6Hv5LMZ4KWuhaXtbIwjLXA/YVY7lZpYAZKfMsY5j5w/FcjUsM3Jcrde6CsLY+0ME5x8jN6Lskch0d/NJVyWByxskYWSsa9p5tcMhe1HV19Ef3rVOLMkmKbMjePdk5HgAcDuXu7F8uA4mbIrJRakonMxcC2gkHMyO+TPsfwHxwfBVRv1kAz+V6HH+/b+K86KfYMouKK1nUFm+ZcIpv9zmT+zleE+pKNoApoKmocf+7LAPEl2OHsynRz7BlF2qnwR0731Lo2w49MvI3ceOVy1tq2UQSVk980DQzOgc0yz0O7uNB69iD6XjuED9HoBvStqamvmbNVuHo8WRNPoM/E+J92Mlea32z+0V7s9c/eLOfHrX7rXY11+PV1GLd2dK7huVF9UcH1ElTHK6KVroZGOLXNLcEEcwQV5ZkkdjLnHuyuvtoGyC16+36mlY233Vo/0xjfRf4SD53tHHl04LQ+rNk2uNKvlFXYaiopYz/pVI0zRkfSyOIH6wC+jtmtu9M16KjUqqlU64yeP9LfB/HuIfe6ZWtHmMd5dq+ZgdPThnF2C77F0b5PGxptYyDVmrqTNOcPoaGQfwndJIO7ub15nhz99g2w94kp9Ta1pd0DElLbZBxzzDpR/c+PcukAAAABgDkFCPtC+0aG5LS9Inw5Tmv6Yv4v2I2Ok6O8qvcLwXzf0DWta0NaA1oGAAOAUoqS518Fvp+1mySeDGN5uK4Ok2yUlWeXFUttuNKas29s7XkDMZHLH0c9SPs9ixisuFZWNInkDYyc9kzl7Cebufs8FWWG2OqCKubejibxhwcFx6O8AOnf7OeXbVeglnq6ymSyi27ZtCt1RafyhQRgXakadzA4zs5lh8eo946rmuRjo3uY9pa5pw5pGCD3Ls6jmdI0xy4ErPWxycOhHt+pac28aByZdV2eHj61fCwf+qB/a+Peu3bAbWKg46fcy9CXqPsb6vB9XY/HhHtVsN9dNBcVzNJL4mYZInMD3MJHBzTxC+0XaWk1hkbTxxLBPcrlbpuymEchHFry3GR7llMu2vaLLV0tXLfN+ejc40rzTx/Jbzd04G7g8CeeVRSRxyACSNj8ct4ZXx5rTfxeH9gKK3Wg3tWfoXPorknFSaz1ZfM21K/t4x9Klx68PHuLrb9uO0aiudVcorvCausZGypkfSxntAwEM4buBjePLvWGi43S86hkraipeaipkdJM9oAHpO3ncOQ4lX3zWm/i8P7AX1HDDG7ejijYeWWtAVihs1dxqxnUuMpNNpLGcdWUyuep0HBqFLDfa8noiLYexrQjtUXT8o3CNwtNK8b/AP37xx3B4d/w68JFqepUNMtpXNd4jH3vqS72auhRnXmoQ5sy7YJo2oNLHqG7h/YB2/QU7xwz/tSPs+PcVta63GnppY6R07YpJebifUb3+GeQz/gqmeRlJAyOKNoONyKNvAezwAVhvNpdKw1cLnPqcfKDPCT2DoR08OHdj5e2h1ud9dTryWHLklyS/PX1viTW0to0KahHqLzGGtY1rAA0DAwvpYbQ19VR4EEnyYPGNwy32d49yyCz3WKvBje3sahvF0ec5HeD1Ch7i+ZmlyWmNu2xmj1PSzX3TNPDS3xgL5Im+iysHcegf3Hr17xudFstG1q80a7jd2c92S8muxrrT/PEsXFtTuabp1FlH5v3CikinkgqInwVETix7Htw5rhwIIPIqhc6aI7u+4fWuy9vex6HWEb7/YGx099jZ8pHwaysA6E9H9zuvAHoRybW2uup7jLbKqhnZWRPMckDozvtcOmF9X7L7VWO0tp09KW5VivTjniu/vj2Pz4kFvbGrZVN2SzF8n+estIqpAeIafqWSaH03dtW3JtJbqWRsTXDt6lzHGKFpOMkgE+4DP1rPNn+we/XN0V01NBParVnPZOGKiTlwwfUB7zx8Oq6CsNntlitsVutNHFSU0YwGMHM95PMnxPFRHav7UKOl71tYSVWr284x9vW+5cO3sNhY6I6+J1Vux97Lpsl0LpzRVhFPZnx1lTKB51XcC+Zw6cPVaM8G9OuTknNVg1PJNSz+cUr+yl5Hhlrx3OHX7R0V/o9RUToh58fMpB62+cx+0PxjHtwfBfO15c176vK4rTc5yeW3z/PwJdTpxpRUIrCRekVNT19DUMD4Kynla7kWSA5VRvN+kPisNprmVkovGpqaemhdNUTRxRt5uc7AVhrdRTSEst1OGtyR21QDx7iGDBI9pHLkqowbGTInuaxhe9wa0DJJOAFjV+urK0Gio3h9P8A66Vp4P8A0B3jvPu78Wqo7WqcH1tRLVOAAxIfQGDn1Rhuc9cZ8V70tPLUyiKFm8fqA71Uko8uYPCRjJGFj2Nc09CMhXzT9u33Nq5mjcbxjaRzPeqihscUbhJUv7Vw47o9X/FYR5Qe0lmz/ShjoHMN6rgY6NhGREOshHh08cdFftLareVo0KKzKTKZzUIuTNb+VxtMb2Z0DZajLiQ66SMPLq2H7CfcO9cyL7qZ5qmokqaiV8s0ry+SR5y5zickk9SSvNdz0jS6WmWsaFP2vtfW/wA9RoK1V1Z7zJRQi2ZaJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgCKEQEooRASihEBKKEQEooRASihEBKKEQEooRASihEBKKEQHW/kubT2XmyN0xeanNyoW/JOe7jNCOTh3lvzvDB+kt+AgjI4hfmtabjW2m5U9yt1TJS1dO8SRSxnDmuHIrs3YNtaotbWwUVYWQXmnZmophwDwOckY6t72829OGFyrazZuVvN3luvQfNdj+nwNvZ3O8tyXM2TdLRFU5lg3YpuZ7ne38VYKqlqKZ2JonNGcA9D71mTHNe0Oa4OaRkEHgVJ4jBUEyZ5gqLM5KSlkO8+mhccYyWDK8DareQR5uOP6R/FMgxNFlX5Gt+MCEj+e78V8MsdC1xLhI8HoXYx8F7lAxhV1rt0tbICQ5kI9Z+OfgPFZFDb6KI5ZTR56EjJHxVUvMg8oIoqaARxgMjYP8lecealwkeMQg5jb9L9I/cPf7I/0twwf3u09D/CH/l+32c6pOXiAiL4mkZDE6WRwaxoySegXgPisqI6WnfPKTut6DmT3BYZUVEtfUmqnI4+o0HIaPBe12rn3KqOQWwM9Rv4+P8A7d6iip31dWymYcF3FxHzWjmfu9pCuJY4Aq7JbRXPM07c0zTjdI4SHu9nf38u9ZSOAwviCJkMLIo27rGDDR3BJ5GQwvmkOGMaXOPcAqG88gY/eLjNFfmOp3n96s3XNzhri7BLT38A3j0ysmoaqCvpBNFxa7g5rubT1BWBb75XPmlLt+Vxe7eOSMnOPdy9gWMaw2nUezm9WUVsbpaW4zOZVhvExxNA+UA6kFw9oz4Lc6X0tasrems55exZLVRqMd5mPbaNn7tO1zrzaoibTUP9JjR/o7z0/VJ5fDuzrRdlA2y/2UOa6Cut1bDkFpDmSxuHMHuIXNO1TQ1To+7b0QdLa6hxNNN9H9B36Q+sce/Hf9iNrfvkVYXj/WR9Vv8AeS6n/Eveu8i2p6f0b6WmvRfPu/sYWiIulGlCIrxo/Ttw1Pe4rXbmZe7jJIR6MTOrj4KzcXFK2pSq1ZYjFZbZVCEpyUYrLZcNm2j6vWF9bSR70dHFh1VOB6je4fpHp/guoaKmt1gssdLTRspqKljDWtHQfeSfeSVS6UsFt0rYY7dQtDIoxvSyu5yO6vcf84WjLttrg1Jtmt+mLRMw6fjMkLp/4zPundcD9EEYHfknuXz/ALTa5dbQ1pzop9FSTaXh1vvfV2eZLbK1hZxSl6zNpXC6Sy3OO5EOaIHZYwH1WfOHiSM+/HcFlwORlYMsl0vN2lpZCeBpz2PPPAer/VIXKKs3U9KXM3CWDxv1r396spmnfAzJGB63iPH7Vj2XB0c8L8SM9Jjgs8WLX+iFJVCWMYhmJx+i/mR7+fuKoiz0vNjuLbjSBxwJmcJGjhx7x4f+yuCwWGaWkqW1MDg1w555EePh3/4LMbdWRVtM2eLh0c082nuK8kutAqVRPt9LHXSXKnpIG1j2hssgjAfK0cgXczjoq1F5GTjyGDzY6KpgzgOY8EFrh7iCPuWPXm1Opsz04LofnDqz/BX2ZjopDPEM5/hGfSHePH7fgvZjmSRh7SHNcOB705cUDB0WWVFqoZt4mEMcfnMOMeOOSo5bBEWnsqh7T03gD+C9ygY5LDDMwslijkaeYc0EFUzbVbGnLLfSMPe2Fo+wLLI9PxgfKVDyf0WgL7bYKYH0ppT8PwVSqSjwTGEzFIaGihl7aKkgZJjG+2MB3x5qoWTxWShY3DxJKc83Ox9mFVQUNHC7ejp2B3PJGSPivJTcnxeQY9brVPVEPeDFF1cRxPs/FZJS08NNEI4WBo695PeV7KhvFzo7VQzVdZPFDFCwySPkeGtY0c3OPQLxJzeEhyPDVV8odO2Oqu1xnbDT00Zke93IAfaeQA6kgLgbaZq+u1tq+rvlYXBsjt2niJz2UY9Vvt6nxJWW7etqtVru7OoLdJJFYaeTMbDkGocOHaOHd9FvQeJK1YuvbKbPvTqfT11+sl7l2eL6zTXdz0j3Y8kSihFMTCJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAhFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICVV2i5V1oudPcrZVS0tZTvD4pY3Yc0hUaLyUVJNNZTHI7H2G7aqDVscVpvEsNBfxw7N3ow1h+kw/Nfw4t654Z6bnp6uKU7hzHJ9B/A+7ofdlfmk1zmODmuLXA5BHRbr2abfrxZ4o7Xq2J95twAaJ+BnYPHPB49uD4rm+ubFtydax5fh+n08uw2dC+4btTzOykWAaT1vYdT0Yq7DeROABvMbId+Pwcx3L3hZA25TBvCpyem8wH7MKAVbSrSk4zWGup8DYqaayi/orG25Vh51FN/Qn/AJl9tr6s/wCvpv6E/wDMrfQyPcl5VK5xqnFjCRAOD3j5/gPDvP8AkUZnMoAlmc4dWt9EH7/rVQyqaAADgDovNxoZK0AAAAYA5BSqUVTe9JKyKKMySyNYwcySqN1npUSPZHG6SRwYxoy5xOAAsSvVykuE3YxZZTtOW95/SI+we89wXm6S18hii9GAYIaRzP0nfcPf7KNjQ0cOZ4k96rS3fEABrGdA0K/6fjFNTGV+RLNgkH5o6D7/AHrG5ZW9uyJ3qj0n+I6D3/d4q4MuI71ehRco57SlywzKBOO9WrVFX+82UjSd6d3pYOMMbxPtBOAR+kqJlxHerHeb3QUsU13ulZBR0cY3GSzSbrcDrx6k55c8BFQknwWX1eI3kVM8sUED55ntjjjaXPc44DQOZK442w6t/PDWtTcIXE0UI7CkBz/BtJ9LHiST71l22ra67UkUlh06ZIbUTiedw3X1PgBzaz6z4clp9dP2R2fnZJ3VwsTawl2Lv737kaq8uVU9CPI6t8iq96hlsN3oax7prDRSMFO5+SYpHZL2tP0cYJHTOepXQt9tNvvtomttxhbPTTtwR3dxB6EcwVr/AMnXS40tsotNNJEY6usZ57U5570nEA+Ibuj3LYEcvmjsPP72PUn+DP8Ay/Z7OUVvdWjU1OpKl6OJei1w4rr8W1kzKdLFJKRy7tF0bX6PvBpp8y0kpJpqgDg9vce5w6hYwuxdTWO3ais8trucIkhkGQR6zHdHNPQhc16h2d6htmrIrDDSvqjUuPms7W4ZIzqSfm46g8vgu6bJ7Z0dQodFeSUasFlt8FJLr8V1r2rujN/psqMt6msxfuMe07Zq+/XeC122Ey1ExwO5o6uJ6ALqTZ9pGg0hZG0VLiSokw6pqCPSkd9zR0H3krw2b6KoNH2nsow2avmANTU44uP0R3NH+Kw3bhtKFmb+bdkmzXzZZUzsP+jggndB+kce728oLtVtPV12v91teFFf+Xe+7sXt58t/oWiVJ1FGKzN+SRadvevo6uCp0hZ5iYnAx3CZjsb3QxAj6/h3rj9r6qy3tskTyypoqgOjdjk5rsg/UCttHicrX+0Si7C6R1jG4bUN9I/pDh9mFToahRbodUl5sm21GgU7XTYVKK4wfF9bz1+eMdh1zobUVJqrS9FeqNzcTxjtGD/VyD1mn2FZVp2oFNddw43alm6ePzm5I+re+pcYbH9olXoa7lsrX1FoqXDzqAc2/ps/SH1jh3EdWWK92zUVpjudjroaqI4cx7eO48YIDm8wQcZBwVz3X9CqaXcPC/VS5P5PvXvIlb3Cqx7zZRlAVNXtjqqWSnkOA4cx0PMH4qzwXVk9OyVpIDhxB5g9R7QV8vuA71olQkmZG8i2FrmOdHIAHsO64Dv/AAX3QVUluqhLH6juBB5Ed34d31L5r52OqGzDHpYa/wBvQ/d8O5QQCCCMg8wvJxcHxCeTM6Kpiq6ds0LstPMHmD3Fe6wq31s1vqA9hLmHgWk8HeB8e4rK6SvgqoRLE7I5EHm09xVpx60elUqV7XU0jpYw50TzmRg47p+kB9o9/POfQztC+TUN70SYPdjmvaHNIc0jIIPAqVbe07J5dTvaxpdlzCMtPeR3E/5CG4VAcR2EBb39qc/DdXvRvqGS5IrY65SgcIIT/wDyn/lXwLrNx34YW92JSf7oTopHmUXZQSAMk4AVkfc6jeJM8TWdzY+I95P3LWe0vbTpjSjZaUVDr3dWHApYnjdY4H57gN1uO7BPgsu1064u6ip0Y7z7imdWMFmTNm6j1HbLJap7ncKyGkoYBmSplOGjwaObjywB/guN9t2124a7qn223CWisEcm82Jx+UqXDk+Q/Y3kFjO0faFqTXdwFReavFPGcwUkWRFF7B1PieKxJdS2e2Vp6fivX9Kp1di+r7/LtNTc3bqejHkSihFMTCJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICEUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICpt9dWW6qZVUFVNSzsOWyRPLXD3hbS0jt21PawyC8xRXaAc3n5Ob9ocD7x71qRFh3en214sV4J/Hz5lcKkoeqzrDTe2nSV23I5a2S3Tu4dnVN3Rn9YZb8SFnVHf6eqibNTVMc0buT43hwPvC4VVbbLtc7XL2luuFVSOznMMpbn245qL3WxtCXGhNrufH8+8y4Xsl6yO6WXYfTXqLuxuN6RoycDJ5rkeybYdX27hOaC5NxjFXAT/AGS1X5u3/UcbcwWGxxvxjeEUn/MtBW2RvovEIp+36mRG8p9bOoGXOZ4+Sic7jjLvRH4/AKxXLVthhr3Ulx1JbIamM+lHLVMZ2fDo0nOfb/guWdRbX9d3qJ8D7sKKF/NlHGIv63F31rA5Hvke6SR7nvccuc45JPisu12HqzTdzUUe6PHzbwUTv0vVWTuFmq9Ktb6Oo7Pj/wAbH+Kx3Um1rRlomZSw3SK4Vcj2saymdvMbk4y6T1QB14k+C4+RZtHYO1jLNSo5Ls4IoeoTa4I7Tkrgxr6mapjaHek55cA3/wBlieotq2l7JvsNx8+naOEVIO0z/O9X61y46onewMdNI5o5NLiQF5rLobIUYv8AWzyuxLH1KJXknyRtzU+3TUVa18FkporbERgSO+Ul+vgPgVrS9Xu7XqcT3W41NY8DDe1kJDR3AcgPAK3IpFa6ba2i/UwS7+vz5mNOrOfrMlZbsg0ydX7RrPY3RufBLOH1ODjELfSfx6cAR7SFiK6a8ijTLWNvOsqtga0YoaV7jgdHSH+wM+1YuvX/ANwsKlZPjjC8XwX1Kren0lRROnWNaxgY0BrWjAA6BeNaGujZG4j0pG4Hfg5+wFewIIyOIXhUBrqqnaT6TS54Hux/eXB48yQHrTy+bObDIfkScMcfmno0/d8O5VuASDgZHIrAtuFSaTZPqKYOLSKMtBBwQXENH2rQ9l8ou/0Oz2Szz0oqb9GBFTXF5yOzwfSe35zxwx0Ocnkd7ouzOzGo67Yu4tkpbs9xrlzSefBZ49fiau81Cja1Nypwys/2Nvbatq9Hpeoj0xZ5WT32qad9zXAijYQSHO/TOODfeemeerhJJKXTzSOfIZA973HJJ3uJJWCWSsqK3VvnlbPJPUTTF8ksjsue4g5JKzmqYJIJGHk5pH1KWa1s/S0KrSt4PLccyfa8tPHdw4E92BuFd2Faru4e817N2LXxZ6qya2ofPbDKWtzJB8q33c/qyr1G4OY1wOQQCjmhzS1wBBGCD1WnpVHSmprqJzeW0Lu3nRlykmvM0wrlp+/XnT9YKuzXGoopupidgOHcRyI9q8L1Rut90qKQjAjed3jzbzB+GFRqZtQr08SWYvtPnyrSnQqypy4Si8PxRuPS23m+UREV8oYa+I+tJF8nJnqceqfYAFtDTm1XTF+DWQXJtLORkw1XybvYCeB9xK5MRaC72Xsa/GEdx93Ly+mC5C7qR58Ttp1Y+Vh4hzHD2ghRDq+y0lyhs11uMNJXSRdpF2zt1src4yHHhvcOXwXHlr1LqC2NDKC811OwcAxkzt34clS3a6XG7VXnVzrZ6ufG6HyvLiB3DuC0stilUe7UqcOppccl9X2OSO8A+ORmQ5rmkcwcghfMcz6WTtI5t3pvZ+ojqP8APiuD4blcIY+zhr6qNn0WTOA+AKiWvrZf4WsqH/rSkrEWwM0/2/D+X+5X+kV+H3nf/wCVngDtmFueTm8Wn8Pevk3ZrhlrwQeRBXH2i9sWsNNwMpHVEVzo2DDYqsFzmjweCD8chZzT+UDbp4yLhpF7Hn1nwVnE/wBUEfFauvslqFCWIwU12pr4PBdjeU5Lng6DfdR9JeD7sPphc83PbzRuY5tv0zUNceT5a7l7tw/asJvu1rV9y32QVbLfC4Y3YGDex+seOfZhZFtsle1fXju+LXyyUyvILk8nVl01Pb7dCZq+vp6WP6U0gYPrWttU7fNOW9ro7RHUXafoWgxR+9zhn4ArmaurqyumM1bVz1Mh5vlkLz8SqdSO02NtafGvJy7uS+vwMad7N+rwM+1rtZ1jqdr4JK7zCicMGnpMsDh+k7mfjjwWBkknJJJXyilNva0baG5RioruMSU5SeZMlFCLIKSUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREB9RsdJI2NgLnOIAA6krvTQWlJNMbP9PaZjjDamKn7SqAOR2rvSeSeoDiRnuAXK3kz6SOq9qlB20QfRW39+1O8Mg7hG433uI4dwK7krZY6WGSqcBvBuB49wXMtvNQ3p07SL5ek/HkvdnzNpp9PCc2eVK6GiMNAZXPkcOGen4L7d6VyafoRf2j/wD8rFoZ3+fMqHuJdvhxPvWVDjcX+EbR9blz1LBsjA/KSmEOxe/uzgubCweOZ4wuJV2P5VsvZ7Iapmf4Sqgb/Wz9y44X039jFPd0KrLtqP8ApgQnaR5uor+H5s9LG4tvkJH+3jH14Wy3dVq+2u3bsx3dIw/AhbQKs/aDH/mqUu5ryk/qdP8Asvnmzrw7JJ+cf7HlQAtooWHmxgafdwXsvKlOYf5zv7RXqufy5s6hT9RGD7SqHdlp7ixvB47KQ+I4j6s/BYattaioRcbPUUuBvubmPP0hxC1K4Fri0ggjmCFJtJr9JR3Hzich210/7tf9NFejUWfauD+T9oREW0IcEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREBCKEQEooRASihEBKKEQEooRASihEBKKEQEooRASihEBKKEQEooRASihEBKKEQEooRASihEBKKEQEooRASihEBKKFsvycdCnW+0SnZUxb1rt2KqsJ5OAPoM/nO6dwcsa8uqdpQnXqcorJVCDnJRXWdL+S7oc6Q2dRVlZDuXO8btVUZ5tZj5Nnuac+1xWaahre3n83jOY4zx8Srhea4xN80pQXTOGDujJaPxVljttdJ6tM/8AncPtXAry7neXE7ipzk8/nw5EipwUIqK6imZ67fasticH3GfHzN1h9uM/3gsdmt9XTbkk0eG7wGQQcLIKVpFdVOPJ0gI9zWj7ljrkyo1N5X8hZsupm5xv3OJp/YkP3LkZdU+WbVbmhbPR9ZbkJM/qxvH95crL6o+yKG7s5F9s5P5fIgu0DzePwR5Up3a9zu4granMZWrWN3XPd1cVtCNwdE1w5FoIWL9olPdlbyfXv/FHSPssqZhcx/k//R8UX8CR1Ej/AO0V7OIaMuIAHUqkbM2nbUyPzuiTgB+q1Wirqpal+XnDRyaOQXOo03NnUKl3GhBLmyqqq/erY3MJ7ON3x7ysQ19bPM7p55E35Gqy7h0f1+PP4q/Kqq6dl6sctvfgTsG9ET3jkfuPtWdbVPu1RSXLkyN6rafpW1qUn6/rR8V1e1cDWaKZGOjkdG9pa5pIcD0IXypOcgaaeGSihEPCUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICEUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCID6ALnBoBJPAALvDyedB/mPs6p4J2dndbhiprnYBLXEeiz+aPrLlxJo2709g1PQXqptzLiyimEzaZ791r3Di3JweAODjrhbxn8qrUhGINMWpn68r3fZhRDaux1DUKcLe1j6PNvKXgvn5GZaVKdNuU3xOr6emhgz2bPSPFzjxJ9pXsuQXeVPrM+rYbEPa2X/nXQOjNW3y7aWtl0uMFFDU1dMyd8ccbgG7wyBxcTyIXNtS0G802EZ3CST4Ljk2lK4hVeImb1kQmpnxkZ4ZHtHEKnoJO1kmfjHyz2/BxH3Khob92kojqoGxgg/KMfkcASSRjhy8VV2nPYtJbuuPFw8TxK1SjiLL3WaD8tifFHpimHz5Z3n3CMfeVzauhfLYkBuelYc8ezqHY97Fz0vrT7LYKOzNv3739ciAa683s/Z8EFsa2HetlK7vhYf6oWuVsSzHNopP8Act+xY32kQzSt5d8vgvodA+yueLi5j3R+L+p9BrJX1FO/rhx9h4D+yV4OtMXzZXj2gL7q5/NHPnEe8SzHPHLiPtKt0tyrZPVkZGP0GcfryuXRjN+qzrFapQjwqrLKt1o+jP8AFv8AivHzGsppBLEA8t45aVj2or5eaF8JgrDuPBzmNp4j3K0jV1+H/wA20/8A8TfwWfSsbipHeTTT/PYRm82j0y2rOlOE1JdmPqVmvLcY6ll0ijcyOo4SNI9WQfiPsKxdXa4ajulfRvpauSOSJ+MjswDw68FaFu7SFSnTUKnNfA55rde1ubuVa1ziXF5WOPX28+ZKKEWSaklFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAlFCICUUIgJRQiAhERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAXzQVkfqPWVrsrOAqahrXnuYOLj+yCu36iopqCFjDhoDcRxtHEgcOA7uS5B2A3ais+0631Fc9kccjJIWyPOA17mkNz7Tw966RuN1oKPenuVxpoC7iXzytZ9p5Lm+2NKpc3tOm16MY5Xe2+PwRs7JqEG+syu0SyVVR2sp3W8hGOQ9/MrN7d6gXPVbts0VYI3thqJrpUMOBHSs9En9c4GPEZWt9e7edVaphmobZ/wBBW4t3THTyEyyA896TgceAxz45Wv03Y2/1W4jRhHci+uXDC58ub/PErr39O3g5vi+4yPyv7xQ3LaFbKOirIak0NE5s4jeHdnIXnLTjkcAcFphUdM/5cueSS7qe9Vi+otl9KhpGmUrKEt5Q4Z5Z6+RBb+u69d1GsZCzfTNfTz26GmErRPGzdcw8DgdR39FhCkEgggkEcQQeIXm0WgQ1q3VNz3XF5T5+ZudmNo6mg3LrRhvRksNcu/g+02NO1rmFrhkK0T0rIWgQ5DRwwTn7Vj0GqK2i+TqA2qjA5uOH/Hqq1mqbZUs9N0kDj0e3I+IXG7/Q7zTavR1FnvXFHZbXajS9UpqcZ7suyXBr28veU+paft7XIR60Xpj3c/qysMWY3O50go6js6iKQuYWta1wJJPBYcszT95U2mQrah0pXMZU3ltccePAIiLPI0EREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREBCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAlnrD2qouX+mye1EVD9dHvUUy9qX53uRFt9G/zkfb8DFu/2TKlnrt9quKIuj2XJkfrdQREWeWC2XT1z7QqJEXM9o/8AOvw+bJFp/wCxCIi0JnBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAQiIgP//Z"
            alt="Escudo de Colombia" />
          <canvas id="escudoCanvas"></canvas>
        </div>
        <div class="hero-tag"><i class="fas fa-shield-halved"></i> Portal Administrativo</div>
        <h1>Acceso al <span>Sistema</span></h1>
        <p>Ingresa tus credenciales para gestionar la Registraduría Municipal de Nobsa.</p>
      </div>

      <div class="login-wrap">
        <div class="login-box">

          <div class="login-box-header">
            <div class="login-box-header-icon"><i class="fas fa-lock"></i></div>
            <div class="login-box-header-text">
              <small>Zona restringida</small>
              <strong>Iniciar sesión</strong>
            </div>
            <div class="live-dot">Sistema activo</div>
          </div>

          <div class="login-box-body">

            <c:if test="${not empty error}">
              <div class="alert alert-error">
                <i class="fas fa-circle-exclamation"></i>
                <span>${error}</span>
              </div>
            </c:if>

            <c:if test="${param.exp eq '1'}">
              <div class="alert alert-session">
                <i class="fas fa-clock"></i>
                <span>Tu sesión ha expirado. Por favor ingresa nuevamente.</span>
              </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post" autocomplete="off">

              <div class="field">
                <label class="field-label" for="usuario">Usuario</label>
                <div class="input-wrap">
                  <i class="fas fa-user ico"></i>
                  <input type="text" id="usuario" name="usuario" class="input-field" placeholder="Nombre de usuario"
                    value="${not empty param.usuario ? param.usuario : ''}" required autofocus
                    autocomplete="username" />
                </div>
              </div>

              <div class="field">
                <label class="field-label" for="password">Contraseña</label>
                <div class="input-wrap">
                  <i class="fas fa-lock ico"></i>
                  <input type="password" id="password" name="password" class="input-field" placeholder="••••••••"
                    required autocomplete="current-password" />
                  <button type="button" class="toggle-pass" onclick="togglePass()" title="Mostrar/ocultar">
                    <i class="fas fa-eye" id="eyeIcon"></i>
                  </button>
                </div>
              </div>

              <div class="sep"></div>

              <button type="submit" class="btn-ingresar">
                <span>Ingresar al sistema</span>
                <i class="fas fa-arrow-right"></i>
              </button>

            </form>

            <div class="login-note">
              <i class="fas fa-shield-halved"></i>
              Conexión segura · Solo personal autorizado
            </div>

          </div>
        </div>
      </div>

      <div class="footer">
        Registraduría Municipal de Nobsa &nbsp;·&nbsp;
        <span>Boyacá, Colombia</span> &nbsp;·&nbsp;
        Sistema de Gestión Electoral 2026
      </div>

      <script>
        function togglePass() {
          const input = document.getElementById("password");
          const icon = document.getElementById("eyeIcon");
          const vis = input.type === "text";
          input.type = vis ? "password" : "text";
          icon.className = vis ? "fas fa-eye" : "fas fa-eye-slash";
        }

        (function () {
          const img = document.getElementById("escudoImg");
          const canvas = document.getElementById("escudoCanvas");
          const ctx = canvas.getContext("2d");

          function removeBlack(image) {
            canvas.width = image.naturalWidth || 300;
            canvas.height = image.naturalHeight || 300;
            ctx.drawImage(image, 0, 0);
            const d = ctx.getImageData(0, 0, canvas.width, canvas.height);
            for (let i = 0; i < d.data.length; i += 4) {
              const br = (d.data[i] + d.data[i + 1] + d.data[i + 2]) / 3;
              if (br < 35) d.data[i + 3] = 0;
              else if (br < 80) d.data[i + 3] = Math.round(((br - 35) / 45) * 255);
            }
            ctx.putImageData(d, 0, 0);
          }

          if (img.complete && img.naturalWidth) removeBlack(img);
          else img.addEventListener("load", () => removeBlack(img));
        })();
      </script>

    </body>

    </html>
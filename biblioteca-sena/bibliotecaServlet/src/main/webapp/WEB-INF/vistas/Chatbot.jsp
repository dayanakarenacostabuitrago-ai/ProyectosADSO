<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>
    #chat-fab {
        position: fixed;
        bottom: 28px;
        right: 28px;
        width: 56px;
        height: 56px;
        border-radius: 50%;
        background: linear-gradient(135deg, #1a3c5e, #2d6a9f);
        color: #fff;
        border: none;
        cursor: pointer;
        box-shadow: 0 4px 16px rgba(45,106,159,.45);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.4rem;
        z-index: 9999;
        transition: transform .2s, box-shadow .2s;
    }
    #chat-fab:hover {
        transform: scale(1.1);
    }
    #chat-fab .notif {
        position: absolute;
        top: 4px;
        right: 4px;
        width: 12px;
        height: 12px;
        background: #ef4444;
        border-radius: 50%;
        border: 2px solid #fff;
        animation: blink 2s infinite;
    }
    @keyframes blink {
        0%,100%{
            opacity:1
        }
        50%{
            opacity:.3
        }
    }

    #chat-panel {
        position: fixed;
        bottom: 96px;
        right: 28px;
        width: 360px;
        height: 500px;
        border-radius: 18px;
        box-shadow: 0 8px 32px rgba(0,0,0,.18);
        display: flex;
        flex-direction: column;
        overflow: hidden;
        z-index: 9998;
        background: #f8fafc;
        transform: scale(.85) translateY(30px);
        opacity: 0;
        pointer-events: none;
        transition: transform .25s cubic-bezier(.34,1.56,.64,1), opacity .2s;
    }
    #chat-panel.open {
        transform: scale(1) translateY(0);
        opacity: 1;
        pointer-events: all;
    }

    .cp-header {
        background: linear-gradient(135deg, #1a3c5e 0%, #2d6a9f 100%);
        color: #fff;
        padding: .75rem 1rem;
        display: flex;
        align-items: center;
        gap: .6rem;
        flex-shrink: 0;
    }
    .cp-header .avatar {
        width: 36px;
        height: 36px;
        background: rgba(255,255,255,.2);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1rem;
    }
    .cp-header .info h6 {
        margin:0;
        font-size:.9rem;
        font-weight:600;
    }
    .cp-header .info small {
        opacity:.8;
        font-size:.72rem;
    }
    .cp-status {
        width:9px;
        height:9px;
        background:#4ade80;
        border-radius:50%;
        display:inline-block;
        margin-right:4px;
        animation:blink 2s infinite;
    }
    .cp-close {
        margin-left: auto;
        background: rgba(255,255,255,.15);
        border: none;
        color:#fff;
        width:28px;
        height:28px;
        border-radius:50%;
        cursor:pointer;
        font-size:.85rem;
        display:flex;
        align-items:center;
        justify-content:center;
    }
    .cp-close:hover {
        background: rgba(255,255,255,.3);
    }

    .cp-messages {
        flex: 1;
        overflow-y: auto;
        padding: .9rem;
        display: flex;
        flex-direction: column;
        gap: .6rem;
        background: #f8fafc;
    }
    .cp-messages::-webkit-scrollbar {
        width: 4px;
    }
    .cp-messages::-webkit-scrollbar-thumb {
        background:#cbd5e1;
        border-radius:4px;
    }

    .cmsg {
        display:flex;
        align-items:flex-end;
        gap:.4rem;
        max-width:88%;
        animation:fadeUp .2s ease;
    }
    @keyframes fadeUp {
        from{
            opacity:0;
            transform:translateY(6px)
        }
        to{
            opacity:1;
            transform:translateY(0)
        }
    }
    .cmsg.user {
        margin-left:auto;
        flex-direction:row-reverse;
    }
    .cmsg.bot  {
        margin-right:auto;
    }
    .cbubble {
        padding:.5rem .85rem;
        border-radius:16px;
        font-size:.84rem;
        line-height:1.5;
        word-break:break-word;
        white-space:pre-wrap;
    }
    .cmsg.user .cbubble {
        background:#2d6a9f;
        color:#fff;
        border-bottom-right-radius:4px;
    }
    .cmsg.bot  .cbubble {
        background:#fff;
        color:#1e293b;
        border:1px solid #e2e8f0;
        border-bottom-left-radius:4px;
    }
    .cicon {
        width:26px;
        height:26px;
        border-radius:50%;
        display:flex;
        align-items:center;
        justify-content:center;
        font-size:.72rem;
        flex-shrink:0;
    }
    .cmsg.bot  .cicon {
        background:#2d6a9f;
        color:#fff;
    }
    .cmsg.user .cicon {
        background:#64748b;
        color:#fff;
    }

    .typing-dots {
        display:flex;
        gap:3px;
        align-items:center;
        padding:2px 0;
    }
    .typing-dots span {
        width:6px;
        height:6px;
        background:#94a3b8;
        border-radius:50%;
        animation:tdot 1.2s infinite;
    }
    .typing-dots span:nth-child(2){
        animation-delay:.2s
    }
    .typing-dots span:nth-child(3){
        animation-delay:.4s
    }
    @keyframes tdot {
        0%,60%,100%{
            transform:translateY(0)
        }
        30%{
            transform:translateY(-5px)
        }
    }

    .cp-suggestions {
        padding:.4rem .8rem;
        display:flex;
        flex-wrap:wrap;
        gap:.3rem;
        background:#f8fafc;
        border-top:1px solid #e2e8f0;
        flex-shrink:0;
    }
    .cp-suggestions button {
        font-size:.72rem;
        padding:.25rem .65rem;
        border-radius:20px;
        border:1px solid #cbd5e1;
        background:#fff;
        color:#2d6a9f;
        cursor:pointer;
        transition:all .15s;
        white-space:nowrap;
    }
    .cp-suggestions button:hover {
        background:#2d6a9f;
        color:#fff;
        border-color:#2d6a9f;
    }

    .cp-input {
        background:#fff;
        border-top:1px solid #e2e8f0;
        padding:.55rem .75rem;
        display:flex;
        gap:.4rem;
        align-items:center;
        flex-shrink:0;
    }
    #cpInput {
        flex:1;
        border:1px solid #e2e8f0;
        border-radius:20px;
        padding:.45rem .9rem;
        font-size:.84rem;
        outline:none;
        resize:none;
        max-height:90px;
        overflow-y:auto;
        transition:border-color .2s;
        font-family:inherit;
    }
    #cpInput:focus {
        border-color:#2d6a9f;
    }
    #cpSend {
        width:36px;
        height:36px;
        border-radius:50%;
        background:#2d6a9f;
        color:#fff;
        border:none;
        display:flex;
        align-items:center;
        justify-content:center;
        cursor:pointer;
        font-size:.85rem;
        flex-shrink:0;
        transition:background .2s, transform .1s;
    }
    #cpSend:hover {
        background:#1a3c5e;
    }
    #cpSend:active {
        transform:scale(.9);
    }
    #cpSend:disabled {
        background:#94a3b8;
        cursor:not-allowed;
    }
    @media(max-width:480px){
        #chat-panel {
            width:calc(100vw - 20px);
            right:10px;
            bottom:82px;
        }
    }
</style>

<!-- Boton burbuja -->
<button id="chat-fab" onclick="toggleChat()" title="Asistente virtual">
    <i class="fas fa-robot"></i>
    <span class="notif"></span>
</button>

<!-- Panel de chat -->
<div id="chat-panel">
    <div class="cp-header">
        <div class="avatar"><i class="fas fa-robot"></i></div>
        <div class="info">
            <h6>Asistente Biblioteca SENA</h6>
            <div><span class="cp-status"></span><small>En linea - Claude AI</small></div>
        </div>
        <button class="cp-close" onclick="toggleChat()"><i class="fas fa-times"></i></button>
    </div>

    <div class="cp-messages" id="cpMessages">
        <div class="cmsg bot">
            <div class="cicon"><i class="fas fa-robot"></i></div>
            <div class="cbubble">Hola! Soy el asistente de la Biblioteca SENA. En que te puedo ayudar?</div>
        </div>
    </div>

    <div class="cp-suggestions" id="cpSuggestions">
        <button onclick="cpSuggest(this)">Como hago un prestamo?</button>
        <button onclick="cpSuggest(this)">Como veo mis multas?</button>
        <button onclick="cpSuggest(this)">Como busco un libro?</button>
    </div>

    <div class="cp-input">
        <textarea id="cpInput" rows="1" placeholder="Escribe tu pregunta..."
                  onkeydown="cpKey(event)"></textarea>
        <button id="cpSend" onclick="cpSend()"><i class="fas fa-paper-plane"></i></button>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        var chatHistory = [];
        var panelOpen = false;
        var SERVLET_URL = '${pageContext.request.contextPath}/chatbot';

        window.toggleChat = function () {
            panelOpen = !panelOpen;
            document.getElementById('chat-panel').classList.toggle('open', panelOpen);
            if (panelOpen) {
                var n = document.querySelector('#chat-fab .notif');
                if (n)
                    n.style.display = 'none';
                document.getElementById('cpInput').focus();
            }
        };

        window.cpSuggest = function (btn) {
            document.getElementById('cpInput').value = btn.textContent;
            document.getElementById('cpSuggestions').style.display = 'none';
            cpSend();
        };

        window.cpKey = function (e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                cpSend();
            }
        };

        window.cpSend = function () {
            var input = document.getElementById('cpInput');
            var sendBtn = document.getElementById('cpSend');
            var text = input.value.trim();
            if (!text)
                return;

            addMsg('user', text);
            input.value = '';
            input.style.height = 'auto';
            sendBtn.disabled = true;
            chatHistory.push({role: 'user', content: text});

            var typingId = showTyping();

            fetch(SERVLET_URL, {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({messages: chatHistory})
            })
                    .then(function (r) {
                        var status = r.status;
                        return r.text().then(function (t) {
                            return {status: status, body: t};
                        });
                    })
                    .then(function (res) {
                        removeTyping(typingId);
                        if (res.status !== 200) {
                            addMsg('bot', 'Error HTTP ' + res.status + '. Respuesta: ' + res.body.substring(0, 100));
                            return;
                        }
                        try {
                            var data = JSON.parse(res.body);
                            var reply;
                            if (data.content && data.content[0] && data.content[0].text) {
                                reply = data.content[0].text;
                                chatHistory.push({role: 'assistant', content: reply});
                            } else if (data.error && typeof data.error === 'object') {
                                reply = 'Error API: ' + (data.error.message || JSON.stringify(data.error));
                            } else if (data.error) {
                                reply = 'Error: ' + data.error;
                            } else {
                                reply = 'Respuesta inesperada del servidor.';
                            }
                            addMsg('bot', reply);
                            chatHistory.push({role: 'assistant', content: reply});
                        } catch (e) {
                            addMsg('bot', 'Respuesta no valida: ' + res.body.substring(0, 100));
                        }
                    })
                    .catch(function (err) {
                        removeTyping(typingId);
                        addMsg('bot', 'Error de red: ' + (err.message || 'desconocido'));
                        console.error('Chatbot error:', err);
                    })
                    .finally(function () {
                        sendBtn.disabled = false;
                    });
        };

        function addMsg(role, text) {
            var c = document.getElementById('cpMessages');
            var icon = role === 'user' ? 'fa-user' : 'fa-robot';
            var d = document.createElement('div');
            d.className = 'cmsg ' + role;
            // usuarios: escapar HTML; bot: renderizar markdown
            var content = (role === 'bot') ? formatReply(text) : esc(text);
            d.innerHTML = '<div class="cicon"><i class="fas ' + icon + '"></i></div>'
                    + '<div class="cbubble">' + content + '</div>';
            c.appendChild(d);
            c.scrollTop = c.scrollHeight;
        }

        function showTyping() {
            var id = 'ty' + Date.now();
            var c = document.getElementById('cpMessages');
            var d = document.createElement('div');
            d.className = 'cmsg bot';
            d.id = id;
            d.innerHTML = '<div class="cicon"><i class="fas fa-robot"></i></div>'
                    + '<div class="cbubble"><div class="typing-dots"><span></span><span></span><span></span></div></div>';
            c.appendChild(d);
            c.scrollTop = c.scrollHeight;
            return id;
        }

        function removeTyping(id) {
            var e = document.getElementById(id);
            if (e)
                e.remove();
        }

        // Convierte markdown basico a HTML
        function formatReply(s) {
            s = String(s);

            // Escapar HTML primero
            s = s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');

            // Negritas: **texto**
            var boldRe = new RegExp('\\*\\*(.+?)\\*\\*', 'g');
            s = s.replace(boldRe, '<strong>$1</strong>');

            // Cursiva: *texto*
            var italicRe = new RegExp('\\*([^*]+?)\\*', 'g');
            s = s.replace(italicRe, '<em>$1</em>');

            // Listas: - item o * item al inicio de linea
            var listRe = new RegExp('(^|\n)[\-\*] (.+)', 'g');
            s = s.replace(listRe, '$1&bull; $2');

            // Saltos de linea
            s = s.replace(/\n/g, '<br>');

            return s;
        }

        function esc(s) {
            return String(s)
                    .replace(/&/g, '&amp;').replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;').replace(/\n/g, '<br>');
        }

        document.getElementById('cpInput').addEventListener('input', function () {
            this.style.height = 'auto';
            this.style.height = Math.min(this.scrollHeight, 90) + 'px';
        });
    });
</script>

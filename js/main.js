const qs = (selector) => document.querySelector(selector);
    const storageKey = "fakejob-history";
    const reportsKey = "fakejob-reports";
    let lastAnalysis = null;

    const menuToggle = qs("#menuToggle");
    const mainMenu = qs("#mainMenu");

    function closeMenu() {
      mainMenu.classList.remove("open");
      menuToggle.setAttribute("aria-expanded", "false");
      menuToggle.setAttribute("aria-label", "Abrir menu");
      document.querySelectorAll(".dropdown").forEach(dropdown => {
        dropdown.classList.remove("open");
        dropdown.querySelector(".dropdown-button")?.setAttribute("aria-expanded", "false");
      });
    }

    menuToggle.addEventListener("click", () => {
      const expanded = menuToggle.getAttribute("aria-expanded") === "true";
      mainMenu.classList.toggle("open", !expanded);
      menuToggle.setAttribute("aria-expanded", String(!expanded));
      menuToggle.setAttribute("aria-label", expanded ? "Abrir menu" : "Cerrar menu");
    });

    mainMenu.querySelectorAll("a").forEach(link => {
      link.addEventListener("click", closeMenu);
    });

    document.querySelectorAll(".dropdown-button").forEach(button => {
      button.addEventListener("click", () => {
        const dropdown = button.closest(".dropdown");
        const isOpen = dropdown.classList.contains("open");
        document.querySelectorAll(".dropdown").forEach(item => {
          item.classList.remove("open");
          item.querySelector(".dropdown-button")?.setAttribute("aria-expanded", "false");
        });
        dropdown.classList.toggle("open", !isOpen);
        button.setAttribute("aria-expanded", String(!isOpen));
      });
    });

    document.querySelectorAll(".segment-tab").forEach(tab => {
      tab.addEventListener("click", () => {
        const segment = tab.dataset.segment;
        document.querySelectorAll(".segment-tab").forEach(item => item.classList.toggle("active", item === tab));
        document.querySelectorAll(".segment-panel").forEach(panel => panel.classList.toggle("active", panel.id === `segment-${segment}`));
      });
    });

    window.addEventListener("resize", () => {
      if (window.innerWidth > 760) closeMenu();
    });

    const riskyPatterns = [
      { key: "pago previo", words: ["paga", "pago", "deposito", "transferencia", "separar tu vacante"], points: 22 },
      { key: "salario irreal", words: ["s/500 diarios", "gana", "diarios", "dinero rapido", "ingresos inmediatos"], points: 18 },
      { key: "urgencia artificial", words: ["urgente", "inmediato", "hoy mismo", "cupos limitados"], points: 14 },
      { key: "contacto informal", words: ["whatsapp", "telegram", "inbox"], points: 12 },
      { key: "datos personales", words: ["dni", "cuenta bancaria", "foto de documento", "datos personales"], points: 15 },
      { key: "sin entrevista", words: ["sin entrevista", "sin experiencia", "vacante asegurada"], points: 10 },
      { key: "phishing/enlace externo", words: ["http://", "bit.ly", "tinyurl", "forms.gle", ".ru/", ".click"], points: 15 }
    ];

    const recommendations = [
      "No realices pagos para reservar vacantes o acceder a entrevistas.",
      "Valida la empresa por canales oficiales antes de enviar documentos.",
      "Desconfia de promesas de ingresos altos con poca informacion.",
      "Evita abrir enlaces acortados o dominios que no pertenezcan a la empresa.",
      "Reporta la oferta si solicita dinero, DNI o cuenta bancaria antes de validar."
    ];

    function readJson(key, fallback) {
      try { return JSON.parse(localStorage.getItem(key)) || fallback; }
      catch { return fallback; }
    }

    function writeJson(key, value) {
      localStorage.setItem(key, JSON.stringify(value));
    }

    function isProbablyUrl(value) {
      return /^(https?:\/\/|www\.)\S+$/i.test(value.trim());
    }

    function isValidUrl(value) {
      try {
        const raw = value.trim().startsWith("www.") ? `https://${value.trim()}` : value.trim();
        const url = new URL(raw);
        return ["http:", "https:"].includes(url.protocol) && url.hostname.includes(".");
      } catch {
        return false;
      }
    }

    function validateAnalysisInput(showMessage = false) {
      const value = qs("#offerText").value.trim();
      const button = qs("#analyzeButton");
      let message = "Ingresa al menos 25 caracteres o una URL completa. El boton se activara cuando el contenido sea suficiente.";
      let valid = value.length >= 25;
      if (!value) {
        valid = false;
        message = "Ingresa el texto o enlace de una oferta para continuar.";
      } else if (isProbablyUrl(value) && !isValidUrl(value)) {
        valid = false;
        message = "El enlace ingresado no parece valido. Revisa la URL o pega el texto completo de la oferta.";
      } else if (value.length > 0 && value.length < 25) {
        valid = false;
        message = "La informacion es insuficiente. Agrega cargo, empresa, contacto, salario o enlace para analizar mejor.";
      }
      button.disabled = !valid;
      qs("#analysisHelp").textContent = message;
      if (!valid && showMessage) {
        qs("#analysisResult").innerHTML = `
          <span class="badge mid">No se puede analizar aun</span>
          <div class="error-note">${message}</div>
          <ul class="help-list">
            <li>Pega el texto completo de la oferta o una URL valida.</li>
            <li>Incluye empresa, canal de contacto y condiciones ofrecidas.</li>
            <li>Vuelve a intentar cuando el boton este activo.</li>
          </ul>
        `;
      }
      return valid;
    }

    function analyzeOffer(text) {
      const normalized = text.toLowerCase();
      const signals = [];
      let score = 8;
      riskyPatterns.forEach(pattern => {
        if (pattern.words.some(word => normalized.includes(word))) {
          score += pattern.points;
          signals.push(pattern.key);
        }
      });
      if (normalized.length < 40) {
        score += 8;
        signals.push("informacion insuficiente");
      }
      score = Math.min(score, 96);
      let level = score >= 70 ? "Riesgo alto" : score >= 40 ? "Riesgo medio" : "Riesgo bajo";
      if (signals.length <= 1 && text.trim().length < 55) level = "Resultado no concluyente";
      const cls = score >= 70 ? "high" : score >= 40 ? "mid" : "low";
      return { score, level, cls, signals: [...new Set(signals)] };
    }

    function renderAnalysis(result, text) {
      const symbol = result.cls === "high"
        ? `<span class="risk-symbol high" aria-hidden="true">!</span>`
        : result.cls === "mid"
          ? `<span class="risk-symbol mid" aria-hidden="true"><span>?</span></span>`
          : `<span class="risk-symbol low" aria-hidden="true">OK</span>`;
      const actionMessage = result.cls === "high"
        ? "No recomendamos postular a esta oferta hasta verificar empresa, RUC y canal oficial."
        : result.cls === "mid"
          ? "Revisa los datos antes de postular y confirma la empresa por fuentes oficiales."
          : "Puedes continuar con cautela, manteniendo buenas practicas de privacidad.";
      const signalChips = result.signals.length
        ? result.signals.map(signal => `<span class="chip danger">${signal}</span>`).join("")
        : `<span class="chip safe">sin seÃ±ales crÃ­ticas</span>`;
      const recommended = recommendations.slice(0, result.score >= 70 ? 5 : 3)
        .map(item => `<li>${item}</li>`).join("");
      qs("#analysisResult").innerHTML = `
        <span class="badge ${result.cls}">${result.level}: ${result.score}%</span>
        <div class="risk-card ${result.cls}">
          <div class="risk-title">${symbol}<span>${result.level}</span></div>
          <p><strong>Accion sugerida:</strong> ${actionMessage}</p>
          <p class="muted">Este resultado usa etiqueta, texto, icono, borde y patron visual para no depender solo del color.</p>
        </div>
        <div class="chips">${signalChips}</div>
        <p><strong>Explicacion:</strong> El sistema encontro ${result.signals.length || "pocas"} seÃ±ales de riesgo asociadas a fraude laboral, phishing o manipulacion.</p>
        <ul>${recommended}</ul>
        <div class="actions">
          <button class="btn secondary small" type="button" id="saveAnalysis">Guardar historial</button>
          <button class="btn ghost small" type="button" id="shareAnalysis">Compartir resultado</button>
          <button class="btn ghost small" type="button" id="reportAnalysis">Reportar oferta</button>
        </div>
      `;
      lastAnalysis = {
        id: Date.now(),
        text: text.trim(),
        score: result.score,
        level: result.level,
        signals: result.signals,
        date: new Date().toLocaleString("es-PE")
      };
      qs("#saveAnalysis").addEventListener("click", saveLastAnalysis);
      qs("#shareAnalysis").addEventListener("click", () => alert(`Enlace generado: fakejob://resultado/${lastAnalysis.id}`));
      qs("#reportAnalysis").addEventListener("click", () => {
        qs("#reportText").value = lastAnalysis.text;
        location.hash = "#comunidad";
      });
    }

    function saveLastAnalysis() {
      if (!lastAnalysis) return;
      const history = readJson(storageKey, []);
      writeJson(storageKey, [lastAnalysis, ...history].slice(0, 20));
      renderHistory();
      alert("Analisis guardado en historial local.");
    }

    function renderHistory() {
      const search = qs("#historySearch").value.toLowerCase();
      const sort = qs("#historySort").value;
      let history = readJson(storageKey, []);
      if (search) {
        history = history.filter(item => `${item.text} ${item.level}`.toLowerCase().includes(search));
      }
      if (sort === "risk") history.sort((a, b) => b.score - a.score);
      if (sort === "label") history.sort((a, b) => a.level.localeCompare(b.level));
      const list = qs("#historyList");
      if (!history.length) {
        list.innerHTML = `<div class="item"><strong>Sin analisis guardados</strong><p class="muted">Guarda un resultado desde la seccion Analizar para verlo aqui.</p></div>`;
        return;
      }
      list.innerHTML = history.map(item => `
        <article class="item">
          <div class="item-head">
            <div>
              <span class="badge ${item.score >= 70 ? "high" : item.score >= 40 ? "mid" : "low"}">${item.level}: ${item.score}%</span>
              <p style="margin:10px 0">${item.text.slice(0, 180)}${item.text.length > 180 ? "..." : ""}</p>
              <p class="muted">${item.date} Â· SeÃ±ales: ${item.signals.join(", ") || "sin seÃ±ales crÃ­ticas"}</p>
            </div>
            <div class="actions" style="margin-top:0">
              <button class="btn ghost small" type="button" onclick="showDetail(${item.id})">Ver detalle</button>
              <button class="btn danger small" type="button" onclick="deleteItem(${item.id})">Eliminar</button>
            </div>
          </div>

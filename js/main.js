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

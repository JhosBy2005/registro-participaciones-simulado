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

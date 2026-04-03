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


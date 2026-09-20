/* ============================================================
   SISTEMA DE GESTIÓN DE TEMA Y MENÚ DESPLEGABLE MÓVIL
   ============================================================ */

document.addEventListener("DOMContentLoaded", function () {
    
    // 1. ALTERNADOR DE TEMA (DARK / LIGHT MODE)
    const themeButtons = document.querySelectorAll("#themeToggle, .theme-toggle");
    
    function applyTheme(theme) {
        document.documentElement.setAttribute("data-theme", theme);
        localStorage.setItem("academia-theme", theme);
        
        // Actualiza los íconos de todos los botones de tema en la pantalla
        themeButtons.forEach(btn => {
            const iconSpan = btn.querySelector(".theme-icon");
            if (iconSpan) {
                iconSpan.textContent = theme === "dark" ? "🌙" : "☀️";
            } else {
                btn.textContent = theme === "dark" ? "🌙" : "☀️";
            }
        });
    }

    // Inicialización del estado del tema al cargar
    const savedTheme = localStorage.getItem("academia-theme") || "dark";
    applyTheme(savedTheme);

    // Asignar evento click a todos los botones de tema
    themeButtons.forEach(btn => {
        btn.addEventListener("click", function () {
            const currentTheme = document.documentElement.getAttribute("data-theme") || "dark";
            const newTheme = currentTheme === "dark" ? "light" : "dark";
            applyTheme(newTheme);
        });
    });


    // 2. CONTROL DEL MENÚ LATERAL FLOATING (OFF-CANVAS DRAWER)
    const menuToggle = document.getElementById("menuToggle");
    const closeSidebar = document.getElementById("closeSidebar");
    const mobileSidebar = document.getElementById("mobileSidebar");
    const sidebarOverlay = document.getElementById("sidebarOverlay");

    function openMenu() {
        if (mobileSidebar && sidebarOverlay) {
            mobileSidebar.classList.add("open");
            sidebarOverlay.classList.add("active");
            document.body.style.overflow = "hidden"; // Deshabilita el scroll del fondo
        }
    }

    function closeMenu() {
        if (mobileSidebar && sidebarOverlay) {
            mobileSidebar.classList.remove("open");
            sidebarOverlay.classList.remove("active");
            document.body.style.overflow = ""; // Restaura el scroll
        }
    }

    if (menuToggle) menuToggle.addEventListener("click", openMenu);
    if (closeSidebar) closeSidebar.addEventListener("click", closeMenu);
    if (sidebarOverlay) sidebarOverlay.addEventListener("click", closeMenu);
});
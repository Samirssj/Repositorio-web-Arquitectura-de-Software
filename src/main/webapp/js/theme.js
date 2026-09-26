/* ============================================================
   SISTEMA DE GESTIÓN DE TEMA Y MENÚ DESPLEGABLE MÓVIL
   ============================================================ */

document.addEventListener("DOMContentLoaded", function () {
    
    // 1. TEMA OSCURO PREDETERMINADO
    document.documentElement.setAttribute("data-theme", "dark");
    localStorage.setItem("academia-theme", "dark");


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


    // 3. PROTECCIÓN INTEGRAL CONTRA COPIA Y SELECCIÓN DE TEXTO
    // Previene el evento de copiado en cualquier parte del sitio (excepto formularios)
    document.addEventListener("copy", function (e) {
        if (!e.target.closest("input, textarea")) {
            e.preventDefault();
        }
    });

    // Previene el corte de texto
    document.addEventListener("cut", function (e) {
        if (!e.target.closest("input, textarea")) {
            e.preventDefault();
        }
    });

    // Previene el inicio de selección de texto con mouse o teclado
    document.addEventListener("selectstart", function (e) {
        if (!e.target.closest("input, textarea")) {
            e.preventDefault();
        }
    });

    // Previene el menú contextual del clic derecho para evitar "Copiar" o "Inspeccionar"
    document.addEventListener("contextmenu", function (e) {
        if (!e.target.closest("input, textarea")) {
            e.preventDefault();
        }
    });

    // Previene arrastrar texto o imágenes
    document.addEventListener("dragstart", function (e) {
        if (!e.target.closest("input, textarea")) {
            e.preventDefault();
        }
    });

    // Bloquea atajos de teclado de copiado y selección (Ctrl+C, Ctrl+A, Ctrl+X, Ctrl+U, Ctrl+S)
    document.addEventListener("keydown", function (e) {
        if (e.target.closest("input, textarea")) return;

        if (e.ctrlKey || e.metaKey) {
            const key = (e.key || "").toLowerCase();
            if (key === "c" || key === "a" || key === "x" || key === "u" || key === "s") {
                e.preventDefault();
            }
        }
    });
});
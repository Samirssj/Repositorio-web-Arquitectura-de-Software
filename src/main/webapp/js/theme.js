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
});
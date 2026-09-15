/* ============================================================
   ACADEMIA
   CAMBIO DE MODO CLARO / OSCURO
   ============================================================ */

(function () {

    "use strict";


    const STORAGE_KEY =
        "academia-theme";


    /* ========================================================
       ELEMENTO HTML
    ======================================================== */

    const html =
        document.documentElement;


    /* ========================================================
       OBTENER TEMA
    ======================================================== */

    function getTheme() {

        const saved =
            localStorage.getItem(
                STORAGE_KEY
            );


        if (
            saved === "dark" ||
            saved === "light"
        ) {

            return saved;

        }


        return "light";

    }


    /* ========================================================
       ACTUALIZAR BOTÓN
    ======================================================== */

    function updateButton(theme) {

        const button =
            document.getElementById(
                "themeToggle"
            );


        if (!button) {

            return;

        }


        const icon =
            button.querySelector(
                ".theme-icon"
            );


        const label =
            button.querySelector(
                ".theme-label"
            );


        if (theme === "dark") {


            if (icon) {

                icon.textContent =
                    "☀";

            }


            if (label) {

                label.textContent =
                    "Modo claro";

            }


            button.setAttribute(
                "aria-label",
                "Cambiar a modo claro"
            );


            button.setAttribute(
                "title",
                "Cambiar a modo claro"
            );


        } else {


            if (icon) {

                icon.textContent =
                    "☾";

            }


            if (label) {

                label.textContent =
                    "Modo oscuro";

            }


            button.setAttribute(
                "aria-label",
                "Cambiar a modo oscuro"
            );


            button.setAttribute(
                "title",
                "Cambiar a modo oscuro"
            );

        }

    }


    /* ========================================================
       APLICAR TEMA
    ======================================================== */

    function applyTheme(theme) {

        html.setAttribute(
            "data-theme",
            theme
        );


        localStorage.setItem(
            STORAGE_KEY,
            theme
        );


        updateButton(
            theme
        );

    }


    /* ========================================================
       CAMBIAR TEMA
    ======================================================== */

    function toggleTheme() {

        const current =
            html.getAttribute(
                "data-theme"
            ) || "light";


        const next =
            current === "dark"
                ? "light"
                : "dark";


        applyTheme(next);

    }


    /* ========================================================
       INICIALIZAR
    ======================================================== */

    const initialTheme =
        getTheme();


    html.setAttribute(
        "data-theme",
        initialTheme
    );


    /* ========================================================
       DOM READY
    ======================================================== */

    document.addEventListener(
        "DOMContentLoaded",
        function () {


            applyTheme(
                getTheme()
            );


            const button =
                document.getElementById(
                    "themeToggle"
                );


            if (button) {

                button.addEventListener(
                    "click",
                    toggleTheme
                );

            }


        }
    );


})();
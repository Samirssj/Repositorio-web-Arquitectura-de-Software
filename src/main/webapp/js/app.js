document.addEventListener("DOMContentLoaded", () => {
    // 1. Capturar el número de semana desde los parámetros de la URL (?num=X)
    const urlParams = new URLSearchParams(window.location.search);
    const numeroSemana = parseInt(urlParams.get("num")) || 1;

    // Actualizar títulos o indicadores de la interfaz si existen
    const tituloSemana = document.getElementById("tituloSemana");
    if (tituloSemana) {
        tituloSemana.textContent = `Semana ${String(numeroSemana).padStart(2, '0')}`;
    }

    // 2. Cargar los archivos de la semana correspondiente
    cargarRecursosPorSemana(numeroSemana);
});

async function cargarRecursosPorSemana(semana) {
    const contenedor = document.getElementById("contenedorRecursos");
    if (!contenedor) return;

    try {
        // Consulta filtrando por la columna 'semana'
        const { data: recursos, error } = await supabaseClient
            .from('archivos')
            .select('*')
            .eq('semana', semana)
            .order('created_at', { ascending: false });

        if (error) {
            console.error("Error consultando Supabase:", error);
            contenedor.innerHTML = `<p style="color: var(--red);">Error al cargar los recursos: ${error.message}</p>`;
            return;
        }

        // Renderizado de la lista
        if (recursos && recursos.length > 0) {
            contenedor.innerHTML = recursos.map(recurso => `
                <article class="week-content-card">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px; gap: 12px; flex-wrap: wrap;">
                        <div>
                            <span class="section-label">${(recurso.tipo || 'RECURSO').toUpperCase()}</span>
                            <h3 style="margin-top: 4px;">${recurso.titulo || recurso.nombre}</h3>
                        </div>
                        <a href="${recurso.url}" target="_blank" class="btn btn-primary" style="font-size: 12px;">
                            Descargar / Ver recurso →
                        </a>
                    </div>
                    <p style="color: var(--muted); font-size: 13px;">
                        ${recurso.descripcion || 'Sin descripción disponible.'}
                    </p>
                </article>
            `).join('');
        } else {
            contenedor.innerHTML = `
                <article class="week-content-card" style="text-align: center; padding: 40px;">
                    <h3>No hay materiales cargados para esta semana</h3>
                    <p style="color: var(--muted); margin-top: 8px;">
                        Los recursos agregados en Supabase para la semana ${semana} aparecerán aquí.
                    </p>
                </article>
            `;
        }
    } catch (err) {
        console.error("Error inesperado:", err);
        contenedor.innerHTML = `<p style="color: var(--red);">Ocurrió un error inesperado al conectar con el servidor.</p>`;
    }
}
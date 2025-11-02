function cargar(id) {
    $.ajax({
        url: '/Planificacion/ListarAccionIntegradoraTipoEvaluacionPorId',
        type: 'GET',
        data: { idEncriptado: id },
        dataType: 'json',
        beforeSend: () => $('#items').LoadingOverlay("show"),
        success: function (response) {
            if (response.success && response.data && response.data.length > 0) {
                const html = response.data.map(generarHtml).join("");
                $('#items').html(html);
            } else {
                $('#items').html('<div class="alert alert-light text-center">No hay registros</div>');
            }
        },
        error: function () {
            $('#items').html('<div class="alert alert-danger text-center">Error al los registros</div>');
        },
        complete: () => $('#items').LoadingOverlay("hide")
    });
}

function generarHtml(Item) {
    // Determinar color y icono según el estado
    var colorEstado = '';
    var iconoEstado = '';

    switch (Item.estado) {
        case 'Pendiente':
            colorEstado = 'secondary';
            iconoEstado = 'fa-play-circle';
            break;
        case 'En proceso':
            colorEstado = 'primary';
            iconoEstado = 'fa-spinner';
            break;
        case 'Finalizado':
            colorEstado = 'success';
            iconoEstado = 'fa-check-circle';
            break;
        default:
            colorEstado = 'secondary';
            iconoEstado = 'fa-circle';
    }

    return `
    <div class="col-sm-12 col-md-6 col-lg-4 mb-3">
        <div class="card h-100 shadow-sm groud-semana estado-${colorEstado} card-semana-accion" 
             data-id-matriz="${Item.fk_matriz_integracion_encriptado}" 
             data-semana="${Item.numero_semana}">
            <div class="card-header bg-light d-flex justify-content-between align-items-center py-2">
                <div class="d-flex align-items-center">
                    <span class="fw-bold text-${colorEstado} me-2 btn-titulo-semana estado-${colorEstado}">${Item.numero_semana}</span>
                </div>
                <button class="btn btn-sm btn-outline-${colorEstado} btn-editar-accion" 
                        data-id="${Item.id_accion_tipo}">
                    <i class="fas fa-edit"></i>
                </button>
            </div>
            <div class="card-body p-3">
                <!-- Información de tipo de evaluación -->
                <div class="d-flex justify-content-between align-items-start mb-3">                    
                    <div class="mb-3">
                        ${Item.tipo_evaluacion ? `
                        <div class="d-flex align-items-center mb-1">
                            <i class="fas fa-clipboard-list text-muted me-2 small"></i>
                            <small class="text-muted">Tipo: <strong>${Item.tipo_evaluacion}</strong></small>
                        </div>
                        ` : ''}
                        ${Item.fecha_registro ? `
                        <div class="d-flex align-items-center">
                            <i class="fas fa-calendar-alt text-muted me-2 small"></i>
                            <small class="text-muted">Registro: <strong>${formatASPNetDate(Item.fecha_registro, false)}</strong></small>
                        </div>
                        ` : ''}
                    </div>

                    <div class="text-center">
                        <i class="fas ${iconoEstado} fa-lg fa-2x text-${colorEstado}" title="${Item.estado}"></i>
                        <div class="small text-${colorEstado} fw-bold mt-1">${Item.estado}</div>
                    </div>
                </div>
                
                <!-- Acción Integradora -->
                ${Item.accion_integradora ? `
                    <div class="mb-2">
                        <small class="text-muted d-block">Acción Integradora:</small>
                        <p class="card-text small text-dark mb-2">${Item.accion_integradora}</p>
                    </div>
                ` : `
                    <div class="mb-2">
                        <small class="text-muted d-block">Acción Integradora:</small>
                        <p class="card-text small text-muted fst-italic mb-2">Sin acción integradora asignada</p>
                    </div>
                `}
                
                <!-- Tipo de Evaluación -->
                ${Item.tipo_evaluacion ? `
                    <div class="mb-2">
                        <small class="text-muted d-block">Tipo de Evaluación:</small>
                        <p class="card-text small text-dark mb-2">${Item.tipo_evaluacion}</p>
                    </div>
                ` : `
                    <div class="mb-2">
                        <small class="text-muted d-block">Tipo de Evaluación:</small>
                        <p class="card-text small text-muted fst-italic mb-2">Sin tipo de evaluación asignado</p>
                    </div>
                `}
            </div>
        </div>
    </div>`;
}

// Evento para hacer click en la card de la semana
$(document).on('click', '.card-semana-accion', function (e) {
    // Evitar que se active cuando se hace click en el botón editar
    if (!$(e.target).closest('.btn-editar-accion').length) {
        const idMatriz = $(this).data('id-matriz');
        const semana = $(this).data('semana');

        // Navegar a la pantalla de contenidos por semana
        window.location.href = `/Planificacion/ContenidosPorSemana?idEncriptado=${idMatriz}&semana=${encodeURIComponent(semana)}`;
    }
});

// Evento para el botón editar (separado)
$(document).on('click', '.btn-editar-accion', function (e) {
    e.stopPropagation(); // Evitar que se active el evento de la card
    const idAccion = $(this).data('id');
    // Tu lógica para editar la acción integradora
    abrirModalEditarAccion(idAccion);
});
function cargarSemanasDeLaAsignaturasDeLaMatriz(idAsignatura) {
    $.ajax({
        url: '/Planificacion/ListarSemanasDeAsignaturaPorId',
        type: 'GET',
        data: { id: idAsignatura },
        dataType: 'json',
        beforeSend: () => $('#semanasAsignatura').LoadingOverlay("show"),
        success: function (response) {
            if (response.success && response.data && response.data.length > 0) {
                const html = response.data.map(generarHtmlSemanasAsignatura).join("");
                $('#semanasAsignatura').html(html);
            } else {
                $('#semanasAsignatura').html('<div class="alert alert-light text-center">No hay semanas asignadas a esta asignatura</div>');
            }
        },
        error: function () {
            $('#semanasAsignatura').html('<div class="alert alert-danger text-center">Error al cargar las semanas de la asignatura</div>');
        },
        complete: () => $('#semanasAsignatura').LoadingOverlay("hide")
    });
}

function generarHtmlSemanasAsignatura(Semana) {
    // Determinar color y icono según el estado
    var colorEstado = '';
    var iconoEstado = '';

    switch (Semana.estado) {
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
    console.log(Semana);
    return `
    <div class="col-sm-12 col-md-6 col-lg-4 mb-3">
        <div class="card h-100 shadow-sm border-0">
            <div class="card-header bg-light d-flex justify-content-between align-items-center py-2">
                <div class="d-flex align-items-center">
                    <span class="fw-bold text-${colorEstado} me-2">${Semana.numero_semana}</span>
                </div>
                <button class="btn btn-sm btn-outline-${colorEstado} btn-editar-semana" 
                        data-id="${Semana.id_semana}">
                    <i class="fas fa-edit"></i>
                </button>
            </div>
            <div class="card-body p-3">
                <!-- Información de fechas -->
                <div class="d-flex justify-content-between align-items-start mb-3">                    
                    <div class="mb-3">
                        <div class="d-flex align-items-center mb-1">
                            <i class="fas fa-calendar-day text-muted me-2 small"></i>
                            <small class="text-muted">Inicio: <strong>${formatASPNetDate(Semana.fecha_inicio, false)}</strong></small>
                        </div>
                        <div class="d-flex align-items-center">
                            <i class="fas fa-calendar-check text-muted me-2 small"></i>
                            <small class="text-muted">Fin: <strong>${formatASPNetDate(Semana.fecha_fin, false)}</strong></small>
                        </div>
                    </div>

                    <div class="text-center">
                        <i class="fas ${iconoEstado} fa-lg fa-2x text-${colorEstado}" title="${Semana.estado}"></i>
                        <div class="small text-${colorEstado} fw-bold mt-1">${Semana.estado}</div>
                    </div>
                </div>
                ${Semana.descripcion ? `
                    <p class="card-text small text-muted mb-2">${Semana.descripcion}</p>
                ` : ''}
            </div>
        </div>
    </div>`;
}
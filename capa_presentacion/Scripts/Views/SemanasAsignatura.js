function cargarSemanasDeLaAsignaturasDeLaMatriz(idAsignatura) {
    $.ajax({
        url: '/Planificacion/ListarSemanasDeAsignaturaPorId',
        type: 'GET',
        data: { idEncriptado: idAsignatura },
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

    return `
    <div class="col-sm-12 col-md-6 col-lg-4 mb-3">
        <div class="card h-100 shadow-sm groud-semana estado-${colorEstado}">
            <div class="card-header bg-light d-flex justify-content-between align-items-center py-2">
                <div class="d-flex align-items-center">
                    <span class="fw-bold text-${colorEstado} me-2 btn-titulo-semana estado-${colorEstado}">${Semana.numero_semana}</span>
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
function abrirModal(semanaId) {
    // Limpiar los campos
    $("#idSemana").val("0");
    $('#descripcionSummernote').summernote('code', '');
    $("#accionIntegradora").val("");
    $("#tipoEvaluacion").val("");
    $("#estado").val("Pendiente");

    // Resetear información de la semana
    $("#numeroSemanaText").text("-");
    $("#periodoSemanaText").text("-");
    $("#modalTitulo").text("Nueva Semana");

    // Habilitar todos los campos inicialmente
    $("#estado").prop("disabled", false);
    $("#accionIntegradora").prop("disabled", false);
    $("#tipoEvaluacion").prop("disabled", false);
    $('#descripcionSummernote').summernote('enable');

    // Si se proporciona un ID, buscar la semana en los datos del ViewBag
    if (semanaId && window.semanasData) {
        const semana = window.semanasData.find(s => s.id_semana === semanaId);

        if (semana) {
            $("#idSemana").val(semana.id_semana);
            $("#accionIntegradora").val(semana.accion_integradora);
            $("#tipoEvaluacion").val(semana.tipo_evaluacion);
            $("#estado").val(semana.estado);

            // Establecer el contenido en Summernote
            $('#descripcionSummernote').summernote('code', semana.descripcion || '');

            // Mostrar información de la semana
            $("#numeroSemanaText").text(semana.numero_semana);

            // Formatear fechas
            const fechaInicio = formatASPNetDate(semana.fecha_inicio, false);
            const fechaFin = formatASPNetDate(semana.fecha_fin, false);
            $("#periodoSemanaText").text(`${fechaInicio} - ${fechaFin}`);

            $("#modalTitulo").text(`Editando: ${semana.numero_semana}`);

            aplicarReglasEstado(semana);
        }
    }
    $("#semanas").modal("show");
}

// Función para aplicar reglas de estado
function aplicarReglasEstado(semana) {
    const tieneDescripcion = semana.descripcion && semana.descripcion.trim() !== '' &&
        semana.descripcion !== '<p><br></p>' && semana.descripcion !== '<p></p>';
    const tieneAccionIntegradora = semana.accion_integradora && semana.accion_integradora.trim() !== '';
    const tieneTipoEvaluacion = semana.tipo_evaluacion && semana.tipo_evaluacion.trim() !== '';

    const todosCompletos = tieneDescripcion && tieneAccionIntegradora && tieneTipoEvaluacion;

    // Regla 1: Si está "Pendiente" y sin datos, deshabilitar estado
    if (semana.estado === 'Pendiente' && !tieneDescripcion && !tieneAccionIntegradora && !tieneTipoEvaluacion) {
        $("#estado").prop("disabled", true);
        $("#estado").attr("title", "Complete al menos un campo para habilitar el estado");
    }
    // Regla 2: Si está "En proceso" y no tiene todos los campos completos, solo permitir "En proceso"
    else if (semana.estado === 'En proceso' && !todosCompletos) {
        // Remover la opción "Finalizado" temporalmente
        $("#estado option[value='Finalizado']").prop('disabled', true);
        $("#estado option[value='Pendiente']").prop('disabled', true);
        $("#estado").attr("title", "Complete todos los campos para poder finalizar");
    }
    // Regla 3: Si tiene todos los campos completos, permitir cambiar a "Finalizado"
    else if (todosCompletos) {
        $("#estado option[value='Finalizado']").prop('disabled', false);
        $("#estado option[value='Pendiente']").prop('disabled', true);
        $("#estado").removeAttr("title");
    }
}

function GuardarSemana() {
    var Semana = {
        id_semana: $("#idSemana").val().trim(),
        accion_integradora: $("#accionIntegradora").val().trim(),
        tipo_evaluacion: $("#tipoEvaluacion").val().trim(),
        descripcion: $('#descripcionSummernote').summernote('code'),
        estado: $("#estado").val().trim(),
    };

    // Validaciones básicas
    if (!Semana.estado) {
        showAlert("Error", "Debe seleccionar un estado", "error");
        return;
    }

    // Validar que Summernote no esté vacío (elimina etiquetas HTML vacías)
    const descripcionLimpia = Semana.descripcion.replace(/<[^>]*>/g, '').trim();

    if (!descripcionLimpia && !Semana.accion_integradora && !Semana.tipo_evaluacion) {
        showAlert("Información", "Debe ingresar al menos un valor en: Descripción, Acción Integradora o Tipo de Evaluación", "info");
        return;
    }

    showLoadingAlert("Procesando", "Guardando semana...");

    jQuery.ajax({
        url: '/Planificacion/GuardarSemanaAsignatura',
        type: "POST",
        data: JSON.stringify({ semana: Semana }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            Swal.close();
            $("#semanas").modal("hide");

            if (data.Resultado || data.Respuesta) {
                const mensaje = data.Mensaje || (Semana.id_semana == "0" ? "Semana creada correctamente" : "Semana actualizada correctamente");
                showAlert("¡Éxito!", mensaje, "success").then((result) => {
                    location.reload();
                });
            }
            else {
                const mensaje = data.Mensaje || (Semana.id_semana == "0" ? "No se pudo crear la semana" : "No se pudo actualizar la semana");
                showAlert("Error", mensaje, "error");
            }
        },
        error: (xhr) => {
            Swal.close();
            showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
        }
    });
}

// Seleccionar los datos para editar
$(document).on('click', '.btn-editar-semana', function (e) {
    e.preventDefault();
    const semanaId = $(this).data('id');
    abrirModal(semanaId);
});

$(document).ready(function () {
    $('#descripcionSummernote').summernote(summernoteConfig);
});
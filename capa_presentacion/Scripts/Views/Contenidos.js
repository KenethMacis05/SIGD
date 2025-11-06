function cargarContenidos(idAsignatura) {
    $.ajax({
        url: '/Planificacion/ListarContenidosPorId',
        type: 'GET',
        data: { idEncriptado: idAsignatura },
        dataType: 'json',
        beforeSend: () => $('#contenidosAsignatura').LoadingOverlay("show"),
        success: function (response) {
            if (response.success && response.data && response.data.length > 0) {
                const html = response.data.map(generarHtmlContenidosAsignatura).join("");
                $('#contenidosAsignatura').html(html);
            } else {
                $('#contenidosAsignatura').html('<div class="alert alert-light text-center">No hay contenidos en esta asignatura</div>');
            }
        },
        error: function () {
            $('#contenidosAsignatura').html('<div class="alert alert-danger text-center">Error al cargar las semanas de la asignatura</div>');
        },
        complete: () => $('#contenidosAsignatura').LoadingOverlay("hide")
    });
}

function generarHtmlContenidosAsignatura(Contenido) {
    // Determinar color y icono según el estado
    var colorEstado = '';
    var iconoEstado = '';
    var TipoSemana = '';
    var esCorte = false;
    var badgeColor = '';
    var badgeIcon = '';

    // Verificar si es corte evaluativo o final
    if (Contenido.tipo_semana && Contenido.tipo_semana !== 'Normal') {
        TipoSemana = Contenido.tipo_semana;
        esCorte = true;

        // Definir colores e iconos específicos para cortes
        if (Contenido.tipo_semana === 'Corte Evaluativo') {
            badgeColor = 'warning';
            badgeIcon = 'fa-star';
        } else if (Contenido.tipo_semana === 'Corte Final') {
            badgeColor = 'danger';
            badgeIcon = 'fa-trophy';
        }
    }

    switch (Contenido.estado) {
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
        <div class="card h-100 shadow-sm groud-Contenido estado-${colorEstado}">
            <div class="card-header bg-light d-flex justify-content-between align-items-center py-2 position-relative">
                <div class="d-flex align-items-center">
                    <span class="fw-bold text-${colorEstado} me-2 btn-titulo-Contenido estado-${colorEstado}">
                        ${Contenido.descripcion_semana}
                    </span>
                    ${esCorte ? `
                    <div>
                        <span class="badge bg-${badgeColor} bg-gradient">
                            <i class="fas ${badgeIcon} me-1"></i>${TipoSemana}
                        </span>
                    </div>
                    ` : ''}
                </div>
                <button class="btn btn-sm btn-outline-${colorEstado} btn-editar-contenido" 
                        data-id="${Contenido.id_contenido}">
                    <i class="fas fa-edit"></i>
                </button>
            </div>
            <div class="card-body p-3">
                <!-- Información de fechas -->
                <div class="d-flex justify-content-between align-items-start mb-3">                    
                    <div class="mb-3">
                        <div class="d-flex align-items-center mb-1">
                            <i class="fas fa-calendar-day text-muted me-2 small"></i>
                            <small class="text-muted">Inicio: <strong>${formatASPNetDate(Contenido.fecha_inicio, false)}</strong></small>
                        </div>
                        <div class="d-flex align-items-center">
                            <i class="fas fa-calendar-check text-muted me-2 small"></i>
                            <small class="text-muted">Fin: <strong>${formatASPNetDate(Contenido.fecha_fin, false)}</strong></small>
                        </div>
                    </div>

                    <div class="text-center">
                        <i class="fas ${iconoEstado} fa-lg fa-2x text-${colorEstado}" title="${Contenido.estado}"></i>
                        <div class="small text-${colorEstado} fw-bold mt-1">${Contenido.estado}</div>
                    </div>
                </div>
                ${Contenido.contenido ? `
                    <p class="card-text small text-muted mb-2">${Contenido.contenido}</p>
                ` : `
                    <p class="card-text small text-muted mb-2">Contenido pendiente</p>
                `}
            </div>
        </div>
    </div>`;
}

function abrirModal(contenidoId) {
    // Limpiar los campos
    $("#idContenido").val("0");
    $('#descripcionSummernote').summernote('code', '');
    $("#estado").val("Pendiente");

    // Resetear información de la semana
    $("#numeroSemanaText").text("-");
    $("#periodoSemanaText").text("-");
    $("#modalTitulo").text("Nueva Semana");

    // Habilitar todos los campos inicialmente
    $("#estado").prop("disabled", false);
    $('#descripcionSummernote').summernote('enable');

    // Si se proporciona un ID, buscar la semana en los datos del ViewBag
    if (contenidoId && window.contenidosData) {
        const contenido = window.contenidosData.find(c => c.id_contenido === contenidoId);

        if (contenido) {
            $("#idContenido").val(contenido.id_contenido);
            $("#estado").val(contenido.estado);

            // Establecer el contenido en Summernote
            $('#descripcionSummernote').summernote('code', contenido.contenido || '');

            // Mostrar información de la contenido
            $("#numeroSemanaText").text(contenido.descripcion_semana);

            // Formatear fechas
            const fechaInicio = formatASPNetDate(contenido.fecha_inicio, false);
            const fechaFin = formatASPNetDate(contenido.fecha_fin, false);
            $("#periodoSemanaText").text(`${fechaInicio} - ${fechaFin}`);

            $("#modalTitulo").text(`Editando: ${contenido.descripcion_semana}`);

            aplicarReglasEstado(contenido);
        }
    }
    $("#contenido").modal("show");
}

// Función para aplicar reglas de estado mejorada
function aplicarReglasEstado(contenido) {
    const tieneContenidoValido = validarContenido(contenido.contenido);
    const estadoActual = contenido.estado;
    const selectEstado = $("#estado");

    // Resetear estado del select
    selectEstado.prop("disabled", false);
    selectEstado.removeAttr("title");
    $("option", selectEstado).prop('disabled', false);

    // Aplicar reglas según el estado actual y contenido
    switch (estadoActual) {
        case 'Pendiente':
            aplicarReglasPendiente(tieneContenidoValido, selectEstado);
            break;

        case 'En proceso':
            aplicarReglasEnProceso(tieneContenidoValido, selectEstado);
            break;

        case 'Finalizado':
            aplicarReglasFinalizado(selectEstado);
            break;

        default:
            // Estado no reconocido, permitir todo
            break;
    }
}

// Función auxiliar para validar contenido
function validarContenido(contenido) {
    if (!contenido) return false;

    const contenidoLimpio = contenido
        .replace(/<p><br><\/p>/gi, '')
        .replace(/<p><\/p>/gi, '')
        .replace(/&nbsp;/gi, '')
        .trim();

    return contenidoLimpio.length > 0 && contenidoLimpio !== '<p></p>';
}

// Reglas específicas para estado "Pendiente"
function aplicarReglasPendiente(tieneContenido, selectEstado) {
    if (!tieneContenido) {
        selectEstado.prop("disabled", true);
        selectEstado.attr("title", "Complete el contenido para habilitar el cambio de estado");
    } else {
        // Si tiene contenido, permitir cambiar a "En proceso" o "Finalizado"
        selectEstado.attr("title", "Puede avanzar a 'En proceso' o 'Finalizado'");
    }
}

// Reglas específicas para estado "En proceso"
function aplicarReglasEnProceso(tieneContenido, selectEstado) {
    if (!tieneContenido) {
        // Sin contenido: solo permitir mantener "En proceso" o retroceder a "Pendiente"
        selectEstado.attr("title", "Complete el contenido para poder finalizar");
        selectEstado.find("option[value='Finalizado']").prop('disabled', true);
    } else {
        // Con contenido: permitir cambiar a "Finalizado" pero no retroceder a "Pendiente"
        selectEstado.attr("title", "Puede finalizar el contenido");
        selectEstado.find("option[value='Pendiente']").prop('disabled', true);
    }
}

// Reglas específicas para estado "Finalizado"
function aplicarReglasFinalizado(selectEstado) {
    // Una vez finalizado, no permitir cambios
    selectEstado.prop("disabled", true);
    selectEstado.attr("title", "Estado finalizado - No se puede modificar");

    // También deshabilitar todas las opciones excepto la actual
    $("option:not(:selected)", selectEstado).prop('disabled', true);
}
function GuardarSemana() {
    var Contenido = {
        id_contenido: $("#idContenido").val().trim(),
        contenido: $('#descripcionSummernote').summernote('code'),
        estado: $("#estado").val().trim(),
    };

    // Validaciones básicas
    if (!Contenido.estado) {
        showAlert("Error", "Debe seleccionar un estado", "error");
        return;
    }

    // Validar que Summernote no esté vacío (elimina etiquetas HTML vacías)
    const descripcionLimpia = Contenido.contenido.replace(/<[^>]*>/g, '').trim();

    if (!descripcionLimpia) {
        showAlert("Información", "Debe ingresar al menos un valor en el contenido", "info");
        return;
    }

    showLoadingAlert("Procesando", "Guardando contenido...");

    jQuery.ajax({
        url: '/Planificacion/GuardarContenido',
        type: "POST",
        data: JSON.stringify({ contenido: Contenido }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            Swal.close();
            $("#contenido").modal("hide");

            if (data.Resultado || data.Respuesta) {
                const mensaje = data.Mensaje || (Contenido.id_contenido == "0" ? "Contenido creado correctamente" : "Contenido actualizado correctamente");
                showAlert("¡Éxito!", mensaje, "success").then((result) => {
                    location.reload();
                });
            }
            else {
                const mensaje = data.Mensaje || (Contenido.id_contenido == "0" ? "No se pudo crear el contenido" : "No se pudo actualizar el contenido");
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
$(document).on('click', '.btn-editar-contenido', function (e) {
    e.preventDefault();
    const contenidoId = $(this).data('id');
    abrirModal(contenidoId);
});

$(document).ready(function () {
    $('#descripcionSummernote').summernote(summernoteConfig);
});
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
    var TipoSemana = '';
    var esCorte = false;
    var badgeColor = '';
    var badgeIcon = '';

    // Verificar si es corte evaluativo o final
    if (Item.tipo_semana && Item.tipo_semana !== 'Normal') {
        TipoSemana = Item.tipo_semana;
        esCorte = true;

        // Definir colores e iconos específicos para cortes
        if (Item.tipo_semana === 'Corte Evaluativo') {
            badgeColor = 'warning';
            badgeIcon = 'fa-star';
        } else if (Item.tipo_semana === 'Corte Final') {
            badgeColor = 'danger';
            badgeIcon = 'fa-trophy';
        }
    }

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
                    <span class="fw-bold text-${colorEstado} me-2 btn-titulo-semana estado-${colorEstado}">${Item.descripcion_semana}</span>
                    ${esCorte ? `
                    <div>
                        <span class="badge bg-${badgeColor} bg-gradient">
                            <i class="fas ${badgeIcon} me-1"></i>${TipoSemana}
                        </span>
                    </div>
                    ` : ''}
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
    const idAccionTipo = $(this).data('id');
    // Tu lógica para editar la acción integradora
    abrirModal(idAccionTipo);
});

function abrirModal(idAccionTipo) {
    // Limpiar los campos
    $("#idAccionTipo").val("0");
    $("#accionIntegradora").val("");
    $("#tipoEvaluacion").val("");
    $("#estado").val("Pendiente");


    if (idAccionTipo && window.accionTipoData) {
        const accionTipo = window.accionTipoData.find(a => a.id_accion_tipo === idAccionTipo);

        if (accionTipo) {
            $("#idAccionTipo").val(accionTipo.id_accion_tipo);
            $("#accionIntegradora").val(accionTipo.accion_integradora);
            $("#tipoEvaluacion").val(accionTipo.tipo_evaluacion);
            $("#estado").val(accionTipo.estado);
        }

        aplicarReglasEstado(accionTipo);
    }

    $("#accionTipo").modal("show");
}

function aplicarReglasEstado(contenido) {
    const tieneContenidoValido = validarContenido(contenido.accion_integradora);
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

function guardarAccionTipo() {
    var accionTipo = {
        id_accion_tipo: $("#idAccionTipo").val().trim(),
        accion_integradora: $('#accionIntegradora').val().trim(),
        tipo_evaluacion: $("#tipoEvaluacion").val().trim(),
        estado: $("#estado").val().trim(),
    };

    // Validaciones básicas
    if (!accionTipo.estado) {
        showAlert("Error", "Debe seleccionar un estado", "error");
        return;
    }

    // Validaciones de accion integradora y tipo de evaluacion
    if (!accionTipo.accion_integradora || !accionTipo.tipo_evaluacion) {
        showAlert("Error", "Debe ingresar la acción integradora y el tipo de evaluación", "error");
        return;
    }

    showLoadingAlert("Procesando", "Guardando registro...");

    jQuery.ajax({
        url: '/Planificacion/GuardarAccionIntegradoraTipoEvaluacion',
        type: "POST",
        data: JSON.stringify({ accionTipo: accionTipo }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            Swal.close();
            $("#accionTipo").modal("hide");

            if (data.Resultado || data.Respuesta) {
                const mensaje = data.Mensaje || (accionTipo.id_accion_tipo == "0" ? "Registro creado correctamente" : "Registro actualizado correctamente");
                showAlert("¡Éxito!", mensaje, "success").then((result) => {
                    location.reload();
                });
            }
            else {
                const mensaje = data.Mensaje || (accionTipo.id_accion_tipo == "0" ? "No se pudo crear el registro" : "No se pudo actualizar el registro");
                showAlert("Error", mensaje, "error");
            }
        },
        error: (xhr) => {
            Swal.close();
            showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
        }
    });
}
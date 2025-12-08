$(document).on('click', '.btn-editar-planindividual', function (e) {
    e.preventDefault();
    var Plan = {
        id_planificacion: $(this).data('id'),
        semana: $(this).data("semana"),
        contenido: $(this).data("contenido"),
        estrategias_aprendizaje: $(this).data('estrategia_aprendizaje'),
        estrategias_evaluacion: $(this).data('estrategia_evaluacion'),
        tipo_evaluacion: $(this).data('tipo_evaluacion'),
        instrumento_evaluacion: $(this).data('instrumento_evaluacion'),
        evidencias_aprendizaje: $(this).data('evidencias_aprendizaje')
    };
    abrirModal(Plan)
});

function abrirModal(datos) {
    if (datos != null) {
        $("#idPlanificacion").val(datos.id_planificacion);
        $('#infoSemana').text(datos.semana);
        $('#infoContenido').text(datos.contenido);
        $('#estrategiasAprendizaje').summernote('code', datos.estrategias_aprendizaje || '');
        $('#estrategiasEvaluacion').summernote('code', datos.estrategias_evaluacion || '');
        $('#tipoEvaluacion').summernote('code', datos.tipo_evaluacion || '');
        $('#instrumentoEvaluacion').summernote('code', datos.instrumento_evaluacion || '');
        $('#evidenciasAprendizaje').summernote('code', datos.evidencias_aprendizaje || '');
    }

    $("#modalPlanIndividual").modal("show");
}

function Guardar() {
    PlanIndividual = {
        id_planificacion: $("#idPlanificacion").val().trim(),
        estrategias_aprendizaje: $('#estrategiasAprendizaje').summernote('code'),
        estrategias_evaluacion: $('#estrategiasEvaluacion').summernote('code'),
        tipo_evaluacion: $('#tipoEvaluacion').summernote('code'),
        instrumento_evaluacion: $('#instrumentoEvaluacion').summernote('code'),
        evidencias_aprendizaje: $('#evidenciasAprendizaje').summernote('code')
    }

    // Función para limpiar y verificar contenido HTML
    const tieneContenidoReal = (html) => {
        if (!html) return false;
        const textoLimpio = html.replace(/<[^>]*>/g, '').trim();
        return textoLimpio !== '' &&
            html !== '<p><br></p>' &&
            html !== '<p></p>' &&
            html !== '<br>' &&
            !html.startsWith('<p>&nbsp;</p>');
    };

    // Verificar cada campo individualmente
    const campos = {
        'Estrategias de Aprendizaje': tieneContenidoReal(PlanIndividual.estrategias_aprendizaje),
        'Estrategias de Evaluación': tieneContenidoReal(PlanIndividual.estrategias_evaluacion),
        'Tipo de Evaluación': tieneContenidoReal(PlanIndividual.tipo_evaluacion),
        'Instrumento de Evaluación': tieneContenidoReal(PlanIndividual.instrumento_evaluacion),
        'Evidencias de Aprendizaje': tieneContenidoReal(PlanIndividual.evidencias_aprendizaje)
    };

    // Contar campos llenos
    const camposLlenos = Object.values(campos).filter(Boolean).length;
    const alMenosUnoLleno = camposLlenos > 0;

    if (!alMenosUnoLleno) {
        showAlert("Información",
            "Debe completar al menos uno de los siguientes campos:\n\n" +
            "• Estrategias de Aprendizaje\n" +
            "• Estrategias de Evaluación\n" +
            "• Tipo de Evaluación\n" +
            "• Instrumento de Evaluación\n" +
            "• Evidencias de Aprendizaje",
            "info");
        return;
    }

    showLoadingAlert("Procesando", "Guardando plan individual...");

    jQuery.ajax({
        url: '/Planificacion/GuardarPlanificacionIndividual',
        type: "POST",
        data: JSON.stringify({ PlanIndividual: PlanIndividual }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            Swal.close();
            $("#modalPlanIndividual").modal("hide");

            if (data.Resultado || data.Respuesta) {
                const mensaje = data.Mensaje || (PlanIndividual.id_planificacion == "0" ? "Plan creado correctamente" : "Plan actualizado correctamente");
                showAlert("¡Éxito!", mensaje, "success").then((result) => {
                    location.reload();
                });
            }
            else {
                const mensaje = data.Mensaje || (PlanIndividual.id_planificacion == "0" ? "No se pudo crear el plan" : "No se pudo actualizar el plan");
                showAlert("Error", mensaje, "error");
            }
        },
        error: (xhr) => {
            Swal.close();
            showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
        }
    });
}

function cargarPlanIndividual(idEncriptado) {
    $.ajax({
        url: '/Planificacion/ListarPlanificacionIndividual',
        type: 'GET',
        data: { idEncriptado: idEncriptado },
        dataType: 'json',
        beforeSend: () => $('#planesIndividuales').LoadingOverlay("show"),
        success: function (response) {
            if (response.success && response.data && response.data.length > 0) {
                const html = response.data.map(generarHtmlPlanIndividual).join("");
                $('#planesIndividuales').html(html);
            } else {
                $('#planesIndividuales').html('<div class="alert alert-light text-center">No hay planes individuales</div>');
            }
        },
        error: function () {
            $('#planesIndividuales').html('<div class="alert alert-danger text-center">Error al cargar los planes individuales</div>');
        },
        complete: () => $('#planesIndividuales').LoadingOverlay("hide")
    });
}

function generarHtmlPlanIndividual(PLANINDIVIDUAL) {
    // Función para verificar si un campo tiene contenido
    const tieneContenido = (campo) => campo && campo.trim() !== '';

    // Determinar icono y color para cada campo
    const getCampoInfo = (campo) => {
        if (tieneContenido(campo)) {
            return { icon: 'fa-check-circle', color: 'success', texto: 'Completado' };
        } else {
            return { icon: 'fa-times-circle', color: 'danger', texto: 'Pendiente' };
        }
    };

    // Información para cada campo
    const estrategiasAprendizaje = getCampoInfo(PLANINDIVIDUAL.estrategias_aprendizaje);
    const estrategiasEvaluacion = getCampoInfo(PLANINDIVIDUAL.estrategias_evaluacion);
    const tipoEvaluacion = getCampoInfo(PLANINDIVIDUAL.tipo_evaluacion);
    const instrumentoEvaluacion = getCampoInfo(PLANINDIVIDUAL.instrumento_evaluacion);
    const evidenciasAprendizaje = getCampoInfo(PLANINDIVIDUAL.evidencias_aprendizaje);

    // Calcular estado general de la semana
    const campos = [estrategiasAprendizaje, estrategiasEvaluacion, tipoEvaluacion, instrumentoEvaluacion, evidenciasAprendizaje];
    const camposCompletados = campos.filter(campo => campo.color === 'success').length;

    let estadoGeneral = '';
    let colorEstado = '';
    let iconoEstado = '';
    let textoEstado = '';

    if (camposCompletados === 0) {
        // Todos pendientes
        estadoGeneral = 'Pendiente';
        colorEstado = 'secondary';
        iconoEstado = 'fa-play-circle';
    } else if (camposCompletados === 5) {
        // Todos completados
        estadoGeneral = 'Finalizado';
        colorEstado = 'success';
        iconoEstado = 'fa-check-circle';
    } else {
        // Al menos uno completado pero no todos
        estadoGeneral = 'En proceso';
        colorEstado = 'primary';
        iconoEstado = 'fa-spinner';
    }

    // Verificar si es corte evaluativo o final
    const esCorte = PLANINDIVIDUAL.SEMANA.tipo_semana && PLANINDIVIDUAL.SEMANA.tipo_semana !== 'Normal';
    let badgeHtml = '';

    if (esCorte) {
        let badgeColor = '';
        let badgeIcon = '';

        if (PLANINDIVIDUAL.SEMANA.tipo_semana === 'Corte Evaluativo') {
            badgeColor = 'warning';
            badgeIcon = 'fa-star';
        } else if (PLANINDIVIDUAL.SEMANA.tipo_semana === 'Corte Final') {
            badgeColor = 'danger';
            badgeIcon = 'fa-trophy';
        }

        badgeHtml = `
            <div>
                <span class="badge bg-${badgeColor} bg-gradient">
                    <i class="fas ${badgeIcon} me-1"></i>${PLANINDIVIDUAL.SEMANA.tipo_semana}
                </span>
            </div>
        `;
    }

    return `
    <div class="col-sm-12 col-md-6 col-lg-4 mb-3">
        <div class="card h-100 shadow-sm groud-Contenido estado-${colorEstado} border-${colorEstado}">
            <div class="card-header bg-light d-flex justify-content-between align-items-center py-2 position-relative border-${colorEstado}">
                <div class="d-flex align-items-center">
                    <span class="fw-bold text-${colorEstado} me-2 btn-titulo-Contenido estado-${colorEstado}">
                        ${PLANINDIVIDUAL.SEMANA.descripcion}
                    </span>
                    ${badgeHtml}
                </div>
                <div class="d-flex align-items-center">
                    <!-- Estado general -->
                    <div class="me-2 text-center">
                        <i class="fas ${iconoEstado} text-${colorEstado}" title="${estadoGeneral}"></i>
                        <div class="small text-${colorEstado} fw-bold">${estadoGeneral}</div>
                    </div>
                    
                    <button class="btn btn-sm btn-outline-${colorEstado} btn-editar-planindividual" 
                            data-id="${PLANINDIVIDUAL.id_planificacion}"
                            data-semana="${PLANINDIVIDUAL.SEMANA.descripcion}"
                            data-contenido="${PLANINDIVIDUAL.CONTENIDO.contenido}"
                            data-estrategia_aprendizaje="${PLANINDIVIDUAL.estrategias_aprendizaje}"
                            data-estrategia_evaluacion="${PLANINDIVIDUAL.estrategias_evaluacion}"
                            data-tipo_evaluacion="${PLANINDIVIDUAL.tipo_evaluacion}"
                            data-instrumento_evaluacion="${PLANINDIVIDUAL.instrumento_evaluacion}"
                            data-evidencias_aprendizaje="${PLANINDIVIDUAL.evidencias_aprendizaje}">
                        <i class="fas fa-edit"></i>
                    </button>
                </div>
            </div>
            <div class="card-body p-3">
                <!-- Información de estado general -->
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <div class="mb-3">
                        <div class="d-flex align-items-center mb-1">
                            <i class="fas fa-tasks text-muted me-2 small"></i>
                            <small class="text-muted">Progreso: <strong>${camposCompletados}/5 campos</strong></small>
                        </div>
                        <div class="progress" style="height: 8px;">
                            <div class="progress-bar bg-${colorEstado}" 
                                 style="width: ${(camposCompletados / 5) * 100}%"
                                 title="${camposCompletados} de 5 campos completados">
                            </div>
                        </div>
                    </div>

                    <div class="text-center">
                        <i class="fas ${iconoEstado} fa-lg fa-2x text-${colorEstado}" title="${estadoGeneral}"></i>
                        <div class="small text-${colorEstado} fw-bold mt-1">${estadoGeneral}</div>
                    </div>
                </div>

                <!-- Contenido esencial -->
                <div class="mb-3">
                    <h6 class="text-muted small mb-2">
                        <i class="fas fa-book me-1"></i>Contenido Esencial:
                    </h6>
                    <p class="small mb-3">${PLANINDIVIDUAL.CONTENIDO.contenido || 'Sin contenido definido'}</p>
                </div>

                <!-- Objetivos de aprendizaje 
                <div class="mb-3">
                    <h6 class="text-muted small mb-2">
                        <i class="fas fa-bullseye me-1"></i>Objetivos:
                    </h6>
                    <p class="small mb-3">${PLANINDIVIDUAL.PLANSEMESTRAL.objetivos_aprendizaje || 'Sin objetivos definidos'}</p>
                </div> -->

                <!-- Campos de planificación individual -->
                <div class="row g-2">
                    <!-- Estrategias de Aprendizaje -->
                    <div class="col-12">
                        <div class="d-flex justify-content-between align-items-center border rounded p-2 ${estrategiasAprendizaje.color === 'success' ? 'border-success' : 'border-danger'}">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-chalkboard-teacher text-muted me-2"></i>
                                <span class="small">Estrategias Aprendizaje</span>
                            </div>
                            <div class="d-flex align-items-center">
                                <i class="fas ${estrategiasAprendizaje.icon} text-${estrategiasAprendizaje.color} me-1"></i>
                                <small class="text-${estrategiasAprendizaje.color}">${estrategiasAprendizaje.texto}</small>
                            </div>
                        </div>
                    </div>

                    <!-- Estrategias de Evaluación -->
                    <div class="col-12">
                        <div class="d-flex justify-content-between align-items-center border rounded p-2 ${estrategiasEvaluacion.color === 'success' ? 'border-success' : 'border-danger'}">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-clipboard-check text-muted me-2"></i>
                                <span class="small">Estrategias Evaluación</span>
                            </div>
                            <div class="d-flex align-items-center">
                                <i class="fas ${estrategiasEvaluacion.icon} text-${estrategiasEvaluacion.color} me-1"></i>
                                <small class="text-${estrategiasEvaluacion.color}">${estrategiasEvaluacion.texto}</small>
                            </div>
                        </div>
                    </div>

                    <!-- Tipo de Evaluación -->
                    <div class="col-12">
                        <div class="d-flex justify-content-between align-items-center border rounded p-2 ${tipoEvaluacion.color === 'success' ? 'border-success' : 'border-danger'}">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-tasks text-muted me-2"></i>
                                <span class="small">Tipo Evaluación</span>
                            </div>
                            <div class="d-flex align-items-center">
                                <i class="fas ${tipoEvaluacion.icon} text-${tipoEvaluacion.color} me-1"></i>
                                <small class="text-${tipoEvaluacion.color}">${tipoEvaluacion.texto}</small>
                            </div>
                        </div>
                    </div>

                    <!-- Instrumento de Evaluación -->
                    <div class="col-12">
                        <div class="d-flex justify-content-between align-items-center border rounded p-2 ${instrumentoEvaluacion.color === 'success' ? 'border-success' : 'border-danger'}">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-toolbox text-muted me-2"></i>
                                <span class="small">Instrumento Evaluación</span>
                            </div>
                            <div class="d-flex align-items-center">
                                <i class="fas ${instrumentoEvaluacion.icon} text-${instrumentoEvaluacion.color} me-1"></i>
                                <small class="text-${instrumentoEvaluacion.color}">${instrumentoEvaluacion.texto}</small>
                            </div>
                        </div>
                    </div>

                    <!-- Evidencias de Aprendizaje -->
                    <div class="col-12">
                        <div class="d-flex justify-content-between align-items-center border rounded p-2 ${evidenciasAprendizaje.color === 'success' ? 'border-success' : 'border-danger'}">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-file-alt text-muted me-2"></i>
                                <span class="small">Evidencias Aprendizaje</span>
                            </div>
                            <div class="d-flex align-items-center">
                                <i class="fas ${evidenciasAprendizaje.icon} text-${evidenciasAprendizaje.color} me-1"></i>
                                <small class="text-${evidenciasAprendizaje.color}">${evidenciasAprendizaje.texto}</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>`;
}

$(document).ready(function () {
    $("#estrategiasAprendizaje").summernote(summernoteConfig);
    $("#estrategiasEvaluacion").summernote(summernoteConfig);
    $("#tipoEvaluacion").summernote(summernoteConfig);
    $("#instrumentoEvaluacion").summernote(summernoteConfig);
    $("#evidenciasAprendizaje").summernote(summernoteConfig);
});
let dataTable;
let dataTableMatriz;
var filaSeleccionada;
const $tabs = $('.tab-pane');
const $tabButtons = $('.nav-link-tab');
let currentTabIndex = 0;

// Limpiar mensajes de error al corregir
document.querySelectorAll('#formPlanSemestral input[required]').forEach(function (input) {
    input.addEventListener('input', function () {
        if (this.value.trim() !== "") this.classList.remove('is-invalid');
    });
});

// Función para validar el tab actual
function validarTabActual() {
    const $tabActual = $($tabs[currentTabIndex]);
    let valido = true;
    let camposFaltantes = [];

    $tabActual.find('.is-invalid').removeClass('is-invalid');

    $tabActual.find('input[required], textarea[required], select[required]').each(function () {
        const $elemento = $(this);
        let valor = '';
        let nombreCampo = '';
        let esSummernote = false;

        if ($elemento.hasClass('summernote') || $elemento.next('.note-editor').length) {
            esSummernote = true;
            valor = $elemento.summernote('code').replace(/<[^>]*>/g, '').trim();
        } else {
            valor = $elemento.val().trim();
        }

        if (!valor) {
            valido = false;

            if (esSummernote) {
                $elemento.next('.note-editor').css('border', '1px solid #dc3545');
            } else {
                $elemento.addClass('is-invalid');
            }

            nombreCampo = obtenerNombreCampo($elemento);
            camposFaltantes.push(nombreCampo);
        }
    });

    if (!valido && camposFaltantes.length > 0) {
        const mensaje = `Por favor complete los siguientes campos:<br><br>- ${camposFaltantes.join('<br>- ')}`;
        showAlert("Campos requeridos", mensaje, "error", true, true);
    }
    return valido;
}

// Función auxiliar para obtener el nombre del campo
function obtenerNombreCampo($elemento) {
    return $elemento.closest('.input-group').find('.input-group-text').text().trim() ||
        $elemento.attr('placeholder') ||
        $elemento.closest('.card').find('.form-label').text().trim() ||
        $elemento.attr('name') ||
        $elemento.closest('.form-group').find('label').text().trim() ||
        'Campo sin nombre';
}

// Botón de navegación Siguiente
$('#btnSiguiente').click(function () {
    if (validarTabActual()) {
        if (currentTabIndex < $tabs.length - 1) {
            $tabs.eq(currentTabIndex).animate({ opacity: 0 }, 200, function () {
                $(this).removeClass('active show').css('display', 'none');

                $tabButtons.eq(currentTabIndex).removeClass('active').attr('aria-selected', 'false');
                currentTabIndex++;

                $tabs.eq(currentTabIndex).css('display', 'block').animate({ opacity: 1 }, 200, function () {
                    $(this).addClass('active show');
                });
                $tabButtons.eq(currentTabIndex).addClass('active').attr('aria-selected', 'true');

                if (currentTabIndex === $tabs.length - 1) {
                    $('#btnSiguiente').hide();
                    var idPlanSemestral = $('#idPlanSemestral').val();
                    if (idPlanSemestral == 0) {
                        $('#btnGuardar').show();
                    }
                }
                $('#btnAnterior').show();
            });
        }
    }
});

// Botón de navegación Anterior
$('#btnAnterior').click(function () {
    if (currentTabIndex > 0) {
        $tabs.eq(currentTabIndex).animate({ opacity: 0 }, 200, function () {
            $(this).removeClass('active show').css('display', 'none');

            $tabButtons.eq(currentTabIndex).removeClass('active').attr('aria-selected', 'false');
            currentTabIndex--;

            $tabs.eq(currentTabIndex).css('display', 'block').animate({ opacity: 1 }, 200, function () {
                $(this).addClass('active show');
            });
            $tabButtons.eq(currentTabIndex).addClass('active').attr('aria-selected', 'true');

            if (currentTabIndex === 0) {
                $('#btnAnterior').hide();
            }
            $('#btnSiguiente').show();
            $('#btnGuardar').hide();
        });
    }
});


// Redirigir a la pantalla de edición
$('#datatable tbody').on('click', '.btn-editar', function () {
    const idEncriptado = $(this).data('id');
    window.location.href = `/Planificacion/EditarPlanDidactico?idEncriptado=${idEncriptado}`;
});

// Redirigir a la pantalla de temas
$('#datatable tbody').on('click', '.btn-temas', function () {
    const idEncriptado = $(this).data('id');
    window.location.href = `/Planificacion/TemasPlanSemestral?idEncriptado=${idEncriptado}`;
});

// Redirigir a la pantalla de planes individuales
$('#datatable tbody').on('click', '.btn-planIndividual', function () {
    const idEncriptado = $(this).data('id');
    window.location.href = `/Planificacion/Planificacion_Individual?idEncriptado=${idEncriptado}`;
});

// Redirigir a la pantalla de reporte PDF
$('#datatable tbody').on('click', '.btn-pdf', function () {
    const id = $(this).data('id');
    window.open('/Reportes/ReporteViewer.aspx?Reporte=PlanDidacticoSemestral&id=' + id, '_blank');
});

function abrirModal() {
    $("#crearPlanSemestral").modal("show");
}

$(document).ready(function () {
    $('#asignaturaNombre').on('focus', function () {
        abrirModal();
    });
});

function Buscar() {
    const filtros = {
        periodo: limpiarFiltro($("#inputGroupSelectPeriodo").val().trim())
    }

    if (!filtros.periodo) {
        showAlert("Advertencia", "El periodo es obligatorio.", "warning", true);
        return;
    }

    dataTableMatriz.clear().draw();

    $.ajax({
        url: '/Planificacion/BuscarMatrizAsignatura',
        type: "GET",
        dataType: "json",
        data: filtros,
        beforeSend: () => $("#datatableMatriz tbody").LoadingOverlay("show"),
        success: function (response) {
            if (response && Array.isArray(response.data) && response.data.length > 0) {
                dataTableMatriz.rows.add(response.data).draw();
            } else {
                showAlert("Advertencia", "No se encontraron resultados", "warning", true);
            }
        },
        complete: () => $("#datatableMatriz tbody").LoadingOverlay("hide"),
        error: () => showAlert("Error", "Error al conectar con el servidor", "error")
    });
}

function limpiarFiltro(texto) {
    return texto
        .replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ0-9 ]/g, '')
        .replace(/\s+/g, ' ')
}

$("#btnLimpiar").click(function () {
    const usuario = $("#usuario").val().trim();
    const nombres = $("#nombrecompleto").val().trim();
    const periodo = $("#inputGroupSelectPeriodo").val('').trigger('change');

    if (!usuario && !nombres && !periodo) {
        showAlert("Información", "Los filtros ya están limpios.", "info", true);
        return;
    }

    $("#datatableMatriz tbody").LoadingOverlay("show");
    $("#usuario, #nombrecompleto, #inputGroupSelectPeriodo").val("");
    dataTableMatriz.clear().draw();

    setTimeout(function () {
        $("#datatableMatriz tbody").LoadingOverlay("hide");
    }, 1500);
});


function inicializarSelect2Periodo() {
    $('#inputGroupSelectPeriodo').select2({
        placeholder: "Buscar periodo...",
        allowClear: true,
        dropdownParent: $('#crearPlanSemestral'),
        language: {
            noResults: function () {
                return "No se encontraron resultados";
            }
        }
    });
}

function cargarPeriodos() {
    jQuery.ajax({
        url: "/Catalogos/ListarPeriodos",
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {
            $('#inputGroupSelectPeriodo').empty()
                .append('<option value="">Seleccione un periodo...</option>');

            $.each(response.data, function (index, periodo) {
                $('#inputGroupSelectPeriodo').append(
                    $('<option>', {
                        value: periodo.id_periodo,
                        text: periodo.anio + " || " + periodo.semestre,
                    })
                );
            });
            $('#inputGroupSelectPeriodo').trigger('change.select2');
        },

        error: (xhr) => {
            showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
        }
    });
}

function Seleccionar() {
    var asignaturasSeleccionadas = [];
    var datosAsignatura = null;

    $('#datatableMatriz tbody').find('.matrizAsignaturaCheckbox:checked').each(function () {
        const id = $(this).data('id');
        asignaturasSeleccionadas.push(id);

        // Obtener los datos completos de la fila
        const fila = $(this).closest('tr');
        datosAsignatura = dataTableMatriz.row(fila).data();
    });

    if (asignaturasSeleccionadas.length === 0) {
        showAlert("!Atención¡", "Debe seleccionar una asignatura", "warning", true);
        return;
    }

    if (asignaturasSeleccionadas.length > 1) {
        showAlert("!Atención¡", "Solo debe seleccionar una asignatura", "warning", true);
        return;
    }

    // Cargar datos en los inputs
    if (datosAsignatura) {
        cargarDatosEnFormulario(datosAsignatura);
    }
}

// Función para cargar datos en los inputs
function cargarDatosEnFormulario(datos) {
    if (datos.nombre_asignatura) $('#asignaturaNombre').val(datos.nombre_asignatura);
    if (datos.carrera) $('#carrera').val(datos.carrera);
    if (datos.nombre_profesor) $('#usuarioPropietario').val(datos.nombre_profesor);
    if (datos.area) $('#areaConocimiento').val(datos.area);
    if (datos.departamento) $('#departamento').val(datos.departamento);
    if (datos.modalidad) $('#modalidad').val(datos.modalidad);
    if (datos.periodo_matriz) $('#periodo').val(datos.periodo_matriz);
    if (datos.id_matriz_asignatura) $('#fkMatrizAsignatura').val(datos.id_matriz_asignatura);

    
    // Mostrar mensaje de éxito
    showAlert("Éxito", "Datos cargados correctamente en el formulario", "success", false);

    $('#crearPlanSemestral').modal('hide');
}

//Boton eliminar plan didáctico semestral
$("#datatable tbody").on("click", '.btn-eliminar', function (e) {
    e.stopPropagation();

    const $button = $(this);
    const idPlanSemestral = $button.data('id');

    if (!idPlanSemestral) {
        showAlert("Error", "No se pudo obtener el ID del plan didáctico semestral", "error");
        return;
    }

    confirmarEliminacion().then((result) => {
        if (result.isConfirmed) {
            showLoadingAlert("Eliminando plan semestral", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: "/Planificacion/EliminarPlanDidactico",
                type: "POST",
                data: JSON.stringify({ id_plan_semestral: idPlanSemestral }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        // Encontrar la fila correctamente
                        let $tr = $button.closest('tr');
                        if ($tr.hasClass('child')) {
                            $tr = $tr.prev('tr');
                        }
                        dataTable.row($tr).remove().draw();
                        showAlert("¡Eliminado!", response.Mensaje || "Plan didáctico semestral eliminado correctamente", "success")
                    } else { showAlert("Error", response.Mensaje || "No se pudo eliminar el plan didáctico semestral", "error") }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
});

const dataTableOptions = {
    ...dataTableConfig,
    ajax: {
        url: '/Planificacion/ListarDatosGeneralesPlanSemestral',
        type: "GET",
        dataType: "json"
    },

    columns: [
        {
            data: null,
            title: "#",
            render: function (data, type, row, meta) {
                return meta.row + 1;
            },
            orderable: false
        },
        { data: "codigo", title: "Codigo" },
        { data: "nombre", title: "Nombre" },
        { data: "Asignatura.nombre", title: "Asignatura" },
        { data: "Matriz.numero_semanas", title: "# de Semanas" },
        { data: "Matriz.periodo", title: "Periodo" },
        { data: "Matriz.carrera", title: "Carrera" },
        { data: "Matriz.modalidad", title: "Modalidad" },
        {
            data: "estado_proceso_pds", title: "Estado",
            render: function (data) {
                let badgeClass = 'secondary';
                let icon = 'fa-clock';

                if (data === 'En proceso') {
                    badgeClass = 'primary';
                    icon = 'fa-spinner';
                } else if (data === 'Finalizado') {
                    badgeClass = 'success';
                    icon = 'fa-check';
                }

                return `
                    <span class="badge bg-${badgeClass} bg-gradient">
                        <i class="fas ${icon} me-1"></i>${data}
                    </span>
                `;
            }
        },
        {
            data: null,
            title: "Acciones",
            render: function (data, type, row) {
                return `
                    <div class="btn-group" role="group">
                        <button type="button" data-id="${row.id_plan_didactico}" class="btn btn-success btn-sm ms-1 btn-pdf" title="Ver informe">
                            <i class="fa fa-file-pdf"></i>
                        </button>
                        <button type="button" data-id="${row.id_encriptado}" class="btn btn-primary btn-sm btn-editar" title="Editar registro">
                            <i class="fa fa-pen"></i>
                        </button>
                        <button type="button" data-id="${row.id_encriptado}" class="btn btn-warning btn-sm btn-temas" title="Gestionar temas">
                            <i class="fa fa-list-alt"></i>
                        </button>
                        <button type="button" data-id="${row.id_encriptado}" class="btn btn-secondary btn-sm btn-planIndividual" title="Generar plan individual">
                            <i class="fa fa-tasks"></i>
                        </button>
                        <button type="button" data-id="${row.id_plan_didactico}" class="btn btn-danger btn-sm btn-eliminar" title="Eliminar registro">
                            <i class="fa fa-trash"></i>
                        </button>
                    </div>
                `;
            },
            orderable: false,
            width: "200px"
        },
    ]
};

const dataTableMatrizOptions = {
    ...dataTableConfig,
    columns: [
        {
            data: null,
            render: function (data, type, row, meta) {
                return meta.row + 1;
            },
            title: "#",
            width: "50px",
            orderable: false
        },
        { data: "codigo_matriz", title: "Codigo" },
        { data: "nombre_matriz", title: "Nombre" },
        { data: "periodo_matriz", title: "Periodo" },
        { data: "nombre_asignatura", title: "Asignatura" },
        { data: "carrera", title: "Carrera" },
        {
            data: "id_matriz_asignatura",
            render: function (data) {
                return `
                    <div class="icheck-primary">
                    <input type="checkbox" class="checkboxIcheck matrizAsignaturaCheckbox"
                        id="matriz_${data}" 
                        data-id="${data}">
                    <label for="matriz_${data}"></label>
                    </div>
                `;
            },
            orderable: false,
            width: "100px"
        }
    ],
};

$(document).ready(function () {
    dataTable = $("#datatable").DataTable(dataTableOptions);
    dataTableMatriz = $("#datatableMatriz").DataTable(dataTableMatrizOptions)
    inicializarSelect2Periodo();
    cargarPeriodos();
    $('#ejeDisciplinarSummernote').summernote(summernoteConfig);
    $('#curriculumSummernote').summernote(summernoteConfig);
    $('#competenciasEspecificasSummernote').summernote(summernoteConfig);
    $('#competenciasGenericasSummernote').summernote(summernoteConfig);
    $('#objetivosAprendizajeSummernote').summernote(summernoteConfig);
    $('#objetivoIntegradorSummernote').summernote(summernoteConfig);
    $('#competenciaGenericaSummernote').summernote(summernoteConfig);
    $('#temaTransversalSummernote').summernote(summernoteConfig);
    $('#valoresTransversalesSummernote').summernote(summernoteConfig);
    $('#estrategiaMetodologicaSummernote').summernote(summernoteConfig);
    $('#estrategiaEvaluacionSummernote').summernote(summernoteConfig);
    $('#recursosSummernote').summernote(summernoteConfig);
    $('#bibliografiaSummernote').summernote(summernoteConfig);
    $tabs.not(':first').removeClass('active show');
    $tabButtons.not(':first').removeClass('active').attr('aria-selected', 'false');

    $('.nav-tabs').on('click', 'button', function (e) {
        e.preventDefault();
        e.stopPropagation();
        return false;
    });

    $tabButtons.each(function () {
        $(this).attr('data-bs-toggle', '');
        $(this).css('pointer-events', 'none');
        $(this).css('cursor', 'default');
    });

    $('#btnAnterior').hide();
    $('#btnGuardar').hide();
});

// Función específica para mostrar pasos después de crear un plan didáctico semestral
function MostrarPasosCreacionPlanSemestral(mensaje) {
    const pasos = `
        <p class="mb-3"><strong>Plan didáctico semestral creado exitosamente:</strong> ${mensaje}</p>
        
        <h6 class="text-primary mb-2">📋 Acciones disponibles en la tabla:</h6>
        <div class="mb-4 d-flex justify-content-between">
            <button type="button" class="btn btn-warning btn-sm me-2 mb-2">
                <i class="fas fa-list-alt me-1"></i> Gestionar Temas
            </button>
            <button type="button" class="btn btn-secondary btn-sm mb-2">
                <i class="fas fa-tasks me-1"></i> Generar Plan Individual
            </button>
        </div>
        
        <h6 class="text-primary mb-3">🚀 Pasos a seguir para completar la configuración:</h6>
        <ol class="list-group list-group-numbered">
            <li class="list-group-item border-0 ps-0">
                <strong>Gestionar temas del plan:</strong> Haz clic en el botón 
                <span class="badge bg-warning text-white">
                    <i class="fas fa-list-alt"></i>
                </span> 
                para organizar y estructurar los contenidos temáticos del semestre.
            </li>
            <li class="list-group-item border-0 ps-0">
                <strong>Generar planes individuales:</strong> Una vez estructurado el plan general, 
                presiona el botón 
                <span class="badge bg-secondary text-white">
                    <i class="fas fa-tasks"></i>
                </span> 
                para crear planes específicos para los contenidos elaborados anteriormente en la Matriz de Integración de Componentes.
            </li>
        </ol>
        
        <div class="alert alert-warning mt-3 mb-0">
            <i class="fas fa-lightbulb me-2"></i>
            <strong>Recomendación:</strong> Sigue el orden de los pasos para una planificación didáctica óptima.
        </div>
    `;

    return ModalNota(pasos);
}

// Función para mostrar modal desde TempData automáticamente
function MostrarModalTempData() {
    const tempDataCREATE = {
        mensaje: $('#tempDataCreate').text(),
    };

    if (tempDataCREATE) {
        setTimeout(() => {
            MostrarPasosCreacionPlanSemestral(tempDataCREATE.mensaje);

            $('[id^="tempData"]').remove();
        }, 800);
    }
}
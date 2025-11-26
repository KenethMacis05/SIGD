let dataTable;
let dataTablePDS;
const $tabs = $('.tab-pane');
const $tabButtons = $('.nav-link-tab');
let currentTabIndex = 0;

// Limpiar mensajes de error al corregir
document.querySelectorAll('#formPlanClasesDiario input[required]').forEach(function (input) {
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

// Redirigir a la pantalla de detalles
$('#datatable tbody').on('click', '.btn-detalles', function () {
    var data = dataTable.row($(this).parents('tr')).data();
    window.location.href = "/Planificacion/DetallePlanDiario?id=" + data.id_plan_diario_encriptado;
});

// Redirigir a la pantalla de edición
$('#datatable tbody').on('click', '.btn-editar', function () {
    var data = dataTable.row($(this).parents('tr')).data();
    window.location.href = "/Planificacion/EditarPlanDiario?id=" + data.id_plan_diario_encriptado;
});

// Redirigir a la pantalla de reporte PDF
$('#datatable tbody').on('click', '.btn-pdf', function () {
    var data = dataTable.row($(this).parents('tr')).data();
    window.open('/Reportes/ReporteViewer.aspx?Reporte=PlanClasesDiario&id=' + data.id_plan_diario, '_blank');
});

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
                    var idPlan = $('#idPlan').val();
                    if (idPlan == 0) {
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

function abrirModal() {
    $("#crearPlanClasesDiario").modal("show");
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

    dataTablePDS.clear().draw();

    $.ajax({
        url: '/Planificacion/BuscarPlanDidacticoSemestral',
        type: "GET",
        dataType: "json",
        data: filtros,
        beforeSend: () => $("#dataTablePDS tbody").LoadingOverlay("show"),
        success: function (response) {
            if (response && Array.isArray(response.data) && response.data.length > 0) {
                dataTablePDS.rows.add(response.data).draw();
            } else {
                showAlert("Advertencia", "No se encontraron resultados", "warning", true);
            }
        },
        complete: () => $("#dataTablePDS tbody").LoadingOverlay("hide"),
        error: () => showAlert("Error", "Error al conectar con el servidor", "error")
    });
}

function inicializarSelect2Periodo() {
    $('#inputGroupSelectPeriodo').select2({
        placeholder: "Buscar periodo...",
        allowClear: true,
        dropdownParent: $('#crearPlanClasesDiario'),
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
    var planDidacticoSeleccionado = [];
    var datosPlanSemestral = null;

    $('#dataTablePDS tbody').find('.planSemestralCheckbox:checked').each(function () {
        const id = $(this).data('id');
        planDidacticoSeleccionado.push(id);

        // Obtener los datos completos de la fila
        const fila = $(this).closest('tr');
        datosPlanSemestral = dataTablePDS.row(fila).data();
    });

    if (planDidacticoSeleccionado.length === 0) {
        showAlert("!Atención¡", "Debe seleccionar un plan semestral", "warning", true);
        return;
    }

    if (planDidacticoSeleccionado.length > 1) {
        showAlert("!Atención¡", "Solo debe seleccionar un plan semestral", "warning", true);
        return;
    }

    // Cargar datos en los inputs
    if (datosPlanSemestral) {
        cargarDatosEnFormulario(datosPlanSemestral);
    }
}

// Función para cargar datos en los inputs
function cargarDatosEnFormulario(datos) {
    if (datos.Asignatura.nombre) $('#asignaturaNombre').val(datos.Asignatura.nombre);
    if (datos.usuario_asignado) $('#usuario').val(datos.usuario_asignado);
    if (datos.Matriz.area) $('#areaConocimiento').val(datos.Matriz.area);
    if (datos.Matriz.departamento) $('#departamento').val(datos.Matriz.departamento);
    if (datos.Matriz.carrera) $('#carrera').val(datos.Matriz.carrera);
    if (datos.Matriz.modalidad) $('#modalidad').val(datos.Matriz.modalidad);
    if (datos.Matriz.periodo) $('#periodo').val(datos.Matriz.periodo);
    if (datos.id_plan_didactico) $('#fkPlanSemestral').val(datos.id_plan_didactico);
    if (datos.id_encriptado) {
        $('#idEncriptadoPlanSemestral').val(datos.id_encriptado);
        cargarTemas();
        cargarContenidosSemana();
    } 

    // Mostrar mensaje de éxito
    showAlert("Éxito", "Datos cargados correctamente en el formulario", "success", false);

    $('#crearPlanClasesDiario').modal('hide');
}

//Boton eliminar plan de clases diario
$("#datatable tbody").on("click", '.btn-eliminar', function () {
    const planseleccionado = $(this).closest("tr");
    const data = dataTable.row(planseleccionado).data();

    confirmarEliminacion().then((result) => {
        if (result.isConfirmed) {
            showLoadingAlert("Eliminando plan de clases", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: "/Planificacion/EliminarPlanClasesDiario",
                type: "POST",
                data: JSON.stringify({ id_plan_diario: data.id_plan_diario }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        dataTable.row(planseleccionado).remove().draw();
                        showAlert("¡Eliminado!", response.Mensaje || "Plan de clases eliminado correctamente", "success")
                    } else { showAlert("Error", response.Mensaje || "No se pudo eliminar el plan de clases", "error") }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
});

const dataTableOptions = {
    ...dataTableConfig,
    ajax: {
        url: "/Planificacion/ListarPlanesClases",
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
        { data: "asignatura", title: "Asignatura" },
        {
            data: "fecha_inicio",
            render: function (data, type, row) {
                return formatASPNetDate(data, false) + ' - ' + formatASPNetDate(row.fecha_fin, false);
            }, title: "Inicio/Fin"
        },
        { data: "periodo", title: "Periodo" },
        {
            defaultContent:
                '<button type="button" class="btn btn-success btn-sm ms-1 btn-pdf" title="Ver informe"><i class="fa fa-file-pdf"></i></button>' +
                '<button type="button" class="btn btn-warning btn-sm ms-1 btn-editar" title="Modificar registro"><i class="fa fa-pen"></i></button>' +
                '<button type="button" class="btn btn-danger btn-sm ms-1 btn-eliminar" title="Eliminar registro"><i class="fa fa-trash"></i></button>',
            width: "100"
        },
    ]
};

const dataTablePDSOptions = {
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
        { data: "codigo", title: "Codigo" },
        { data: "nombre", title: "Nombre" },
        { data: "Matriz.periodo", title: "Periodo" },
        { data: "Asignatura.nombre", title: "Asignatura" },
        { data: "Matriz.carrera", title: "Carrera" },
        {
            data: "id_plan_didactico",
            render: function (data) {
                return `
                    <div class="icheck-primary">
                    <input type="checkbox" class="checkboxIcheck planSemestralCheckbox"
                        id="planSemestral_${data}" 
                        data-id="${data}">
                    <label for="planSemestral_${data}"></label>
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
    dataTablePDS = $("#dataTablePDS").DataTable(dataTablePDSOptions)
    inicializarSelect2Periodo();
    cargarPeriodos();
    $('#competenciasGenericasSummernote').summernote(summernoteConfig);
    $('#competenciasEspecificasSummernote').summernote(summernoteConfig);
    $('#ejesSummernote').summernote(summernoteConfig);
    $('#boaSummernote').summernote(summernoteConfig);
    $('#objetivoSummernote').summernote(summernoteConfig);
    $('#indicadorSummernote').summernote(summernoteConfig);
    $('#inicialesSummernote').summernote(summernoteConfig);
    $('#desarrolloSummernote').summernote(summernoteConfig);
    $('#sintesisSummernote').summernote(summernoteConfig);

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
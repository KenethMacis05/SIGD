let dataTable;

// Validación para fechas
//document.querySelector('form').addEventListener('submit', function (e) {
//    const inicio = new Date(document.getElementById('fecha_inicio').value);
//    const fin = new Date(document.getElementById('fecha_fin').value);

//    if (fin < inicio) {
//        alert('La fecha final debe ser posterior a la fecha inicial');
//        e.preventDefault();
//    }
//});

// Limpiar mensajes de error al corregir
document.querySelectorAll('[required]').forEach(input => {
    input.addEventListener('input', function () {
        this.setCustomValidity('');
    });
});

// Validación antes de enviar el formulario
//$('form').submit(function (e) {
//    let isValid = true;

//    // Validar campos requeridos
//    $('[required]').each(function () {
//        const $editor = $(this).next('.note-editor');
//        if ($editor.length) {
//            // Es un campo Summernote
//            if ($editor.find('.note-editable').text().trim() === '') {
//                this.setCustomValidity('Este campo es requerido');
//                isValid = false;
//            }
//        } else if (this.value.trim() === '') {
//            this.setCustomValidity('Este campo es requerido');
//            isValid = false;
//        }
//    });

//    if (!isValid) {
//        e.preventDefault();
//        // Mostrar el primer tab con errores
//        $('.is-invalid').first().closest('.tab-pane').each(function () {
//            const tabId = $(this).attr('id');
//            $(`a[href="#${tabId}"]`).tab('show');
//        });
//        alert('Por favor complete todos los campos requeridos');
//    }
//});

// Limpiar validaciones al cambiar de tab
$('a[data-toggle="tab"]').on('shown.bs.tab', function () {
    $('.is-invalid').removeClass('is-invalid');
});

// Redirigir a la pantalla de detalles
$('#datatable tbody').on('click', '.btn-detalles', function () {
    var data = dataTable.row($(this).parents('tr')).data();
    window.location.href = "/Planificacion/DetallePlanDiario?id=" + data.id_plan_diario;
});

// Redirigir a la pantalla de edición
$('#datatable tbody').on('click', '.btn-editar', function () {
    var data = dataTable.row($(this).parents('tr')).data();
    window.location.href = "/Planificacion/EditarPlanDiario?id=" + data.id_plan_diario;
});

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
            data: "fecha_registro", title: "Fecha",
            render: function (data) {
                return data ? formatASPNetDate(data) : "N/A";
            }
        },
        {
            defaultContent:
                '<button type="button" class="btn btn-primary btn-sm btn-detalles"><i class="fa fa-eye"></i></button>' +
                '<button type="button" class="btn btn-success btn-sm ms-1 btn-pdf"><i class="fa fa-file-pdf"></i></button>' +
                '<button type="button" class="btn btn-warning btn-sm ms-1 btn-editar"><i class="fa fa-pen"></i></button>' +
                '<button type="button" class="btn btn-danger btn-sm ms-1 btn-eliminar"><i class="fa fa-trash"></i></button>',
            width: "130"
        },
    ]
};

$(document).ready(function () {
    dataTable = $("#datatable").DataTable(dataTableOptions);
    $('#competenciasSummernote').summernote(summernoteConfig);
    $('#ejesSummernote').summernote(summernoteConfig);
    $('#boaSummernote').summernote(summernoteConfig);
    $('#objetivoSummernote').summernote(summernoteConfig);
    $('#temaSummernote').summernote(summernoteConfig);
    $('#indicadorSummernote').summernote(summernoteConfig);
    $('#inicialesSummernote').summernote(summernoteConfig);
    $('#desarrolloSummernote').summernote(summernoteConfig);
    $('#sintesisSummernote').summernote(summernoteConfig);
    $('#estrategiaSummernote').summernote(summernoteConfig);
    $('#instrumentoSummernote').summernote(summernoteConfig);
    $('#evidenciasSummernote').summernote(summernoteConfig);
    $('#criteriosSummernote').summernote(summernoteConfig);
    $('#indicadoresSummernote').summernote(summernoteConfig);
    $('#nivelSummernote').summernote(summernoteConfig);
});











































$(document).ready(function () {
    const $tabs = $('.tab-pane');
    const $tabButtons = $('.nav-link-tab');
    let currentTabIndex = 0;

    // Ocultar todos los tabs excepto el primero
    $tabs.not(':first').hide();
    $tabButtons.not(':first').removeClass('active').attr('aria-selected', 'false');

    // Deshabilitar navegación por clicks en tabs
    $('.nav-tabs').on('click', 'button', function (e) {
        e.preventDefault();
    });

    // Función para validar el tab actual
    function validarTabActual() {
        const $tabActual = $($tabs[currentTabIndex]);
        let valido = true;

        $tabActual.find('[required]').each(function () {
            const $elemento = $(this);
            let valor = '';

            // Manejar campos Summernote
            if ($elemento.hasClass('summernote')) {
                valor = $elemento.summernote('code').replace(/<[^>]*>/g, '').trim();
            } else {
                valor = $elemento.val().trim();
            }

            if (!valor) {
                valido = false;
                $elemento.addClass('is-invalid');
                // Mostrar mensaje específico para el campo
                const nombreCampo = $elemento.closest('.card').find('.form-label').text().trim();
                showAlert("Campo requerido", `Por favor complete el campo: ${nombreCampo}`, "error");
                return false; // Salir del each
            }
        });

        return valido;
    }

    // Botón Siguiente
    $('#btnSiguiente').click(function () {
        if (validarTabActual()) {
            if (currentTabIndex < $tabs.length - 1) {
                // Cambiar al siguiente tab
                $tabs.eq(currentTabIndex).hide();
                $tabButtons.eq(currentTabIndex).removeClass('active').attr('aria-selected', 'false');

                currentTabIndex++;
                $tabs.eq(currentTabIndex).show();
                $tabButtons.eq(currentTabIndex).addClass('active').attr('aria-selected', 'true');

                // Mostrar/ocultar botones según posición
                if (currentTabIndex === $tabs.length - 1) {
                    $('#btnSiguiente').hide();
                    $('#btnGuardar').show();
                }

                $('#btnAnterior').show();
            }
        }
    });

    // Botón Anterior
    $('#btnAnterior').click(function () {
        if (currentTabIndex > 0) {
            $tabs.eq(currentTabIndex).hide();
            $tabButtons.eq(currentTabIndex).removeClass('active').attr('aria-selected', 'false');

            currentTabIndex--;
            $tabs.eq(currentTabIndex).show();
            $tabButtons.eq(currentTabIndex).addClass('active').attr('aria-selected', 'true');

            // Mostrar/ocultar botones según posición
            if (currentTabIndex === 0) {
                $('#btnAnterior').hide();
            }

            $('#btnSiguiente').show();
            $('#btnGuardar').hide();
        }
    });

    // Estado inicial de los botones
    $('#btnAnterior').hide();
    $('#btnGuardar').hide();
});
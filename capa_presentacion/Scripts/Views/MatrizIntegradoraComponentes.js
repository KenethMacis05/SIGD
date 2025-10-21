let dataTable;
const $tabs = $('.tab-pane');
const $tabButtons = $('.nav-link-tab');
let currentTabIndex = 0;

// Limpiar mensajes de error al corregir
document.querySelectorAll('#formMatrizIntegradora input[required]').forEach(function (input) {
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
    window.location.href = "/Planificacion/DetalleMatrizIntegracion?id=" + data.id_matriz_integracion;
});

// Redirigir a la pantalla de edición
$('#datatable tbody').on('click', '.btn-editar', function () {
    var data = dataTable.row($(this).parents('tr')).data();
    window.location.href = "/Planificacion/EditarMatrizIntegracion?id=" + data.id_matriz_integracion;
});

// Redirigir a la pantalla de asignar asignaturas
$('#datatable tbody').on('click', '.btn-viewAsignar', function () {
    var data = dataTable.row($(this).parents('tr')).data();
    window.location.href = "/Planificacion/AsignarAsignaturasMatrizIntegracion?id=" + data.id_matriz_integracion;
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
                    var idPlan = $('#idMatriz').val();
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

//Boton eliminar matríz de integración
$("#datatable tbody").on("click", '.btn-eliminar', function () {
    const matrizseleccionada = $(this).closest("tr");
    const data = dataTable.row(matrizseleccionada).data();

    confirmarEliminacion().then((result) => {
        if (result.isConfirmed) {
            showLoadingAlert("Eliminando matríz de integración", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: "/Planificacion/EliminarMatrizIntegracion",
                type: "POST",
                data: JSON.stringify({ id_matriz_integracion: data.id_matriz_integracion }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        dataTable.row(matrizseleccionada).remove().draw();
                        showAlert("¡Eliminado!", response.Mensaje || "Matríz de Integración eliminada correctamente", "success")
                    } else { showAlert("Error", response.Mensaje || "No se pudo eliminar la Matríz de Integración", "error") }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
});

const dataTableOptions = {
    ...dataTableConfig,
    ajax: {
        url: "/Planificacion/ListarMatricesIntegracion",
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
        {
            data: "fecha_registro",
            render: function (data, type, row) {
                return formatASPNetDate(data, false);
            }, title: "Inicio/Fin"
        },
        { data: "periodo", title: "Periodo" },
        { data: "carrera", title: "Carrera" },
        {
            defaultContent:
                '<button type="button" class="btn btn-success btn-sm ms-1 btn-pdf"><i class="fa fa-file-pdf"></i></button>' +
                '<button type="button" class="btn btn-warning btn-sm ms-1 btn-editar"><i class="fa fa-pen"></i></button>' +
                '<button type="button" class="btn btn-info btn-sm ms-1 btn-viewAsignar"><i class="fa fa-user-graduate"></i></button>' +
                '<button type="button" class="btn btn-danger btn-sm ms-1 btn-eliminar"><i class="fa fa-trash"></i></button>',
            width: "130"
        },
    ]
};

$(document).ready(function () {
    dataTable = $("#datatable").DataTable(dataTableOptions);
    $('#competenciasSummernote').summernote(summernoteConfig);
    $('#estrategiaIntegradoraSummernote').summernote(summernoteConfig);
    $('#objetivoAnioSummernote').summernote(summernoteConfig);
    $('#objetivoSemestreSummernote').summernote(summernoteConfig);
    $('#objetivoIntegradorSummernote').summernote(summernoteConfig);

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
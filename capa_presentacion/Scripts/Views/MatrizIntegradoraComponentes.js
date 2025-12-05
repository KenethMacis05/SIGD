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

// Redirigir a la pantalla de edición
$('#datatable tbody').on('click', '.btn-editar', function () {
    var data = dataTable.row($(this).parents('tr')).data();
    window.location.href = "/Planificacion/EditarMatrizIntegracion?idEncriptado=" + data.id_encriptado;
});

// Redirigir a la pantalla de asignar asignaturas
$('#datatable tbody').on('click', '.btn-viewAsignar', function () {
    var data = dataTable.row($(this).parents('tr')).data();
    window.location.href = "/Planificacion/AsignarAsignaturasMatrizIntegracion?idEncriptado=" + data.id_encriptado;
});

// Redirigir a la pantalla Acción Integradora Tipo Evaluacion
$('#datatable tbody').on('click', '.btn-viewAccionIntegradoraTipoEvaluacion', function () {
    var data = dataTable.row($(this).parents('tr')).data();
    window.location.href = "/Planificacion/AccionIntegradoraTipoEvaluacion?idEncriptado=" + data.id_encriptado;
});

// Redirigir a la pantalla de semanas
$("#datatable tbody").on("click", '.btn-viewSemanas', function () {
    var data = dataTable.row($(this).parents('tr')).data();
    window.location.href = "/Planificacion/SemanasMatriz?idEncriptado=" + data.id_encriptado;
});

// Redirigir a la pantalla de reporte PDF
$('#datatable tbody').on('click', '.btn-pdf', function () {
    var data = dataTable.row($(this).parents('tr')).data();
    window.open('/Reportes/ReporteViewer.aspx?Reporte=MatrizIntegracionComponente&id=' + data.id_matriz_integracion, '_blank');
});

//$('#datatable tbody').on('click', '.btn-pdf', function () {
//    var data = dataTable.row($(this).parents('tr')).data();
//    window.open('/ReportesRDLC/ReporteViewerRDLC.aspx?Reporte=MatrizIntegracionComponente&id=' + data.id_matriz_integracion, '_blank');
//});

function abrirModal(json) {
  
    $("#createUser").modal("show");
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
        { data: "numero_semanas", title: "# de Semanas" },
        { data: "periodo", title: "Periodo" },
        { data: "carrera", title: "Carrera" },
        { data: "modalidad", title: "Modalidad" },
        {
            data: "estado_proceso", title: "Estado",
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
            defaultContent:
                '<button type="button" class="btn btn-success btn-sm ms-1 btn-pdf" title="Ver informe"><i class="fa fa-file-pdf"></i></button>' +
                '<button type="button" class="btn btn-warning btn-sm ms-1 btn-editar" title="Modificar registro"><i class="fa fa-pen"></i></button>' +
                '<button type="button" class="btn btn-info btn-sm ms-1 btn-viewAsignar" title="Asignaturas"><i class="fa fa-user-graduate"></i></button>' +
                '<button type="button" class="btn btn-primary btn-sm ms-1 btn-viewSemanas" title="Configurar semanas académicas"><i class="fa fa-calendar"></i></button>' +
                '<button type="button" class="btn btn-dark btn-sm ms-1 btn-viewAccionIntegradoraTipoEvaluacion" title="Gestionar evaluaciones integradoras"><i class="fa fa-tasks"></i></button>' +
                '<button type="button" class="btn btn-danger btn-sm ms-1 btn-eliminar" title="Eliminar registro"><i class="fa fa-trash"></i></button>',
            width: "200"
        },
    ]
};

$(document).ready(function () {
    dataTable = $("#datatable").DataTable(dataTableOptions);
    $('#competenciasGenericasSummernote').summernote(summernoteConfig);
    $('#competenciasEspecificasSummernote').summernote(summernoteConfig);
    $('#estrategiaIntegradoraSummernote').summernote(summernoteConfig);
    $('#objetivoAnioSummernote').summernote(summernoteConfig);
    $('#objetivoSemestreSummernote').summernote(summernoteConfig);
    $('#objetivoIntegradorSummernote').summernote(summernoteConfig);

    inicializarSelect2Area();
    inicializarSelect2Departamento();
    inicializarSelect2Carrera();
    inicializarSelect2Modalidad();
    inicializarSelect2Periodo();

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

// Función específica para mostrar pasos después de crear matriz
function MostrarPasosCreacionMatriz(mensaje) {
    const pasos = `
        <p class="mb-3"><strong>Matriz creada exitosamente:</strong> ${mensaje}</p>
        
        <h6 class="text-primary mb-2">📋 Acciones disponibles en la tabla:</h6>
        <div class="mb-4 d-flex justify-content-between">
            <button type="button" class="btn btn-info btn-sm me-2 mb-2">
                <i class="fas fa-user-graduate me-1"></i> Gestionar Asignaturas
            </button>
            <button type="button" class="btn btn-primary btn-sm me-2 mb-2">
                <i class="fas fa-calendar me-1"></i> Semanas Académicas
            </button>
            <button type="button" class="btn btn-dark btn-sm mb-2">
                <i class="fas fa-tasks me-1"></i> Evaluaciones Integradoras
            </button>
        </div>
        
        <h6 class="text-primary mb-3">🚀 Pasos a seguir para completar la configuración:</h6>
        <ol class="list-group list-group-numbered">
            <li class="list-group-item border-0 ps-0">
                <strong>Asignar asignaturas:</strong> Haz clic en el botón 
                <span class="badge bg-info text-white">
                    <i class="fas fa-user-graduate"></i>
                </span> 
                para agregar las asignaturas que integrarán esta matriz.
            </li>
            <li class="list-group-item border-0 ps-0">
                <strong>Configurar semanas:</strong> Presiona el botón 
                <span class="badge bg-primary text-white">
                    <i class="fas fa-calendar"></i>
                </span> 
                para definir el calendario académico, incluyendo cortes evaluativos.
            </li>
            <li class="list-group-item border-0 ps-0">
                <strong>Gestionar evaluaciones:</strong> Usa el botón 
                <span class="badge bg-dark text-white">
                    <i class="fas fa-tasks"></i>
                </span> 
                para establecer las acciones integradoras y tipo de eveluación por semana.
            </li>
            <li class="list-group-item border-0 ps-0">
                <strong>Contenidos:</strong> Finalmente, desde la gestión de asignaturas, 
                al ingresar una asignatura vera los contenidos específicos para cada materia en las semanas correspondientes.
            </li>
        </ol>
        
        <div class="alert alert-warning mt-3 mb-0">
            <i class="fas fa-lightbulb me-2"></i>
            <strong>Recomendación:</strong> Sigue el orden de los pasos para una configuración óptima.
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
            MostrarPasosCreacionMatriz(tempDataCREATE.mensaje);

            $('[id^="tempData"]').remove();
        }, 800);
    }
}
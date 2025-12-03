let dataTable;
var filaSeleccionada;

function abrirModal(json) {
    $("#idReporte").val("0");
    $("#nombreReporte").val("");

    ocultarTodosLosParametros();

    if (json !== null) {
        $("#idReporte").val(json.id_reporte);
        $("#nombreReporte").val(json.nombre);

        mostrarParametrosPorReporte(json.nombre);
    }

    $("#VerReporte").modal("show");
}

// Ocultar todos los parámetros
function ocultarTodosLosParametros() {
    $(".parametro-input").closest('.col-md-12').hide();
    $(".parametro-select").closest('.col-md-12').hide();
}

// Mostrar parámetros según el reporte
function mostrarParametrosPorReporte(nombreReporte) {
    ocultarTodosLosParametros();

    // Mostrar parámetros según el tipo de reporte
    switch (nombreReporte) {
        case "MIC-1 - Resumen de Matriz	":
            mostrarParametros(['area']);
            break;
        case "MIC-2 - Avance y Cumplimiento por Profesor":
            mostrarParametros(['nombre', 'codigo', 'departamento']);
            break;
        case "MIC-3 - Inventario de Contenidos Pendientes":
            mostrarParametros(['nombre', 'codigo', 'carrera', 'modalidad']);
            break;
        case "MIC-4 - Detalle de Matriz por Semana":
            mostrarParametros(['nombre', 'codigo', 'area', 'departamento', 'periodo']);
            break;
        case "MIC-5 - Resumen de Matrices por Carrera":
            mostrarParametros(['carrera']);
            /*$(".parametro-input, .parametro-select").closest('.col-md-12').show();*/
            break;
        default:
            mostrarParametros(['nombre', 'codigo']);
    }

    /*cargarSelectsVisibles();*/
}

// Mostrar parámetros específicos
function mostrarParametros(parametros) {
    parametros.forEach(function (param) {
        $(`#parametro-${param}`).closest('.col-md-12').show();
    });
}

// Cargar solo los selects que están visibles
function cargarSelectsVisibles() {
    if ($("#inputGroupSelectArea").is(":visible")) {
        cargarAreas();
    }
    if ($("#inputGroupSelectDepartamento").is(":visible")) {
        cargarDepartamentos();
    }
    if ($("#inputGroupSelectCarrera").is(":visible")) {
        cargarCarreras();
    }
    if ($("#inputGroupSelectModalidad").is(":visible")) {
        cargarModalidades();
    }
    if ($("#inputGroupSelectPeriodo").is(":visible")) {
        cargarPeriodos();
    }
}

//Seleccionar reporte
$("#datatable tbody").on("click", '.btn-verReporte', function () {
    filaSeleccionada = $(this).closest("tr");
    var data = dataTable.row(filaSeleccionada).data()
    abrirModal(data)
});

function VerInforme() {
    var nombreReporte = $("#nombreReporte").val();

    var parametros = obtenerParametrosPorReporte(nombreReporte);

    var url = construirUrlReporte(nombreReporte, parametros);

    window.open(url, '_blank');
}

function obtenerParametrosPorReporte(nombreReporte) {
    var parametros = {};

    switch (nombreReporte.toLowerCase()) {
        case "reporte de áreas":
            if ($("#inputParametroNombre").val()) {
                parametros.nombre = $("#inputParametroNombre").val();
            }
            if ($("#inputGroupSelectArea").val()) {
                parametros.area = $("#inputGroupSelectArea").val();
            }
            break;

        case "reporte de departamentos":
            if ($("#inputParametroNombre").val()) {
                parametros.nombre = $("#inputParametroNombre").val();
            }
            if ($("#inputParametroCodigo").val()) {
                parametros.codigo = $("#inputParametroCodigo").val();
            }
            if ($("#inputGroupSelectDepartamento").val()) {
                parametros.departamento = $("#inputGroupSelectDepartamento").val();
            }
            break;

        case "reporte de carreras":
            if ($("#inputParametroNombre").val()) {
                parametros.nombre = $("#inputParametroNombre").val();
            }
            if ($("#inputParametroCodigo").val()) {
                parametros.codigo = $("#inputParametroCodigo").val();
            }
            if ($("#inputGroupSelectCarrera").val()) {
                parametros.carrera = $("#inputGroupSelectCarrera").val();
            }
            if ($("#inputGroupSelectModalidad").val()) {
                parametros.modalidad = $("#inputGroupSelectModalidad").val();
            }
            break;

        case "reporte de asignaturas":
            if ($("#inputParametroNombre").val()) {
                parametros.nombre = $("#inputParametroNombre").val();
            }
            if ($("#inputParametroCodigo").val()) {
                parametros.codigo = $("#inputParametroCodigo").val();
            }
            if ($("#inputGroupSelectArea").val()) {
                parametros.area = $("#inputGroupSelectArea").val();
            }
            if ($("#inputGroupSelectDepartamento").val()) {
                parametros.departamento = $("#inputGroupSelectDepartamento").val();
            }
            if ($("#inputGroupSelectPeriodo").val()) {
                parametros.periodo = $("#inputGroupSelectPeriodo").val();
            }
            break;

        case "MIC-5 - Resumen de Matrices por Carrera":
                parametros.carrera = getSafeParameterValue($("#inputGroupSelectCarrera").val());
            break;

        default:
            // Para reportes generales, enviar todos los parámetros que tengan valor
            if ($("#inputParametroNombre").val()) {
                parametros.nombre = $("#inputParametroNombre").val();
            }
            if ($("#inputParametroCodigo").val()) {
                parametros.codigo = $("#inputParametroCodigo").val();
            }
            if ($("#inputGroupSelectArea").val()) {
                parametros.area = $("#inputGroupSelectArea").val();
            }
            if ($("#inputGroupSelectDepartamento").val()) {
                parametros.departamento = $("#inputGroupSelectDepartamento").val();
            }
            if ($("#inputGroupSelectCarrera").val()) {
                parametros.carrera = $("#inputGroupSelectCarrera").val();
            }
            if ($("#inputGroupSelectModalidad").val()) {
                parametros.modalidad = $("#inputGroupSelectModalidad").val();
            }
            if ($("#inputGroupSelectPeriodo").val()) {
                parametros.periodo = $("#inputGroupSelectPeriodo").val();
            }
    }

    return parametros;
}

function getSafeParameterValue(value) {
    return (value && value !== '' && value !== '0') ? value : "NULL";
}

function construirUrlReporte(nombreReporte, parametros) {
    var baseUrl = '/Reportes/ReporteViewer.aspx';
    var queryParams = [];

    queryParams.push('Reporte=' + encodeURIComponent(nombreReporte));

    // Agregar parámetros
    for (var key in parametros) {
        if (parametros[key]) {
            queryParams.push(key + '=' + encodeURIComponent(parametros[key]));
        }
    }

    return baseUrl + '?' + queryParams.join('&');
}

const dataTableOptions = {
    ...dataTableConfig,

    ajax: {
        url: "/Reporte/GetReporte",
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
            orderable: false, width: "30"
        },
        { data: "nombre" },
        { data: "descripcion" },
        {
            defaultContent:
                '<button type="button" class="btn btn-primary btn-sm btn-verReporte"><i class="fa fa-eye"></i></button>',
            width: "90"
        }
    ],
};

$(document).ready(function () {
    dataTable = $("#datatable").DataTable(dataTableOptions);

    inicializarSelect2Area($("#VerReporte"));
    inicializarSelect2Departamento($("#VerReporte"));
    inicializarSelect2Carrera($("#VerReporte"));
    inicializarSelect2Periodo($("#VerReporte"));

    $('#VerReporte').on('hidden.bs.modal', function () {
        limpiarModal();
    });
});

function limpiarModal() {
    $(".parametro-input").val('');
    $(".parametro-select").val('').trigger('change');

    ocultarTodosLosParametros();
}
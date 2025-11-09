let dataTable;
let dataTableMatriz;
var filaSeleccionada;


function abrirModal(json) {
    $("#crearPlanSemestral").modal("show");
}

function Buscar() {
    const filtros = {
        usuario: limpiarFiltro($("#usuario").val().trim()),
        nombres: limpiarFiltro($("#nombrecompleto").val().trim()),
        periodo: limpiarFiltro($("#inputGroupSelectPeriodo").val().trim())
    }

    if (!filtros.usuario && !filtros.nombres) {
        showAlert("Advertencia", "Debe ingresar al menos un dato en algún filtro de Usuario y Nombre completo.", "warning", true);
        return;
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

function Guardar() {
    var asignaturasSeleccionadas = [];

    $('#datatableMatriz tbody').find('.matrizAsignaturaCheckbox:checked').each(function () {
        asignaturasSeleccionadas.push($(this).data('id'));
    });

    if (asignaturasSeleccionadas.length === 0) {
        showAlert("!Atención¡", "Debe seleccionar una asignatura", "warning", true);
        return;
    }

    if (asignaturasSeleccionadas.length > 1) {
        showAlert("!Atención¡", "Solo debe seleccionar una asignatura", "warning", true);
        return;
    }

    $.LoadingOverlay("hide");

    console.log(asignaturasSeleccionadas)
}

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
        { data: "Asignatura.asignatura", title: "Asignatura" },
        { data: "Matriz.numero_semanas", title: "# de Semanas" },
        { data: "Matriz.periodo", title: "Periodo" },
        { data: "Matriz.carrera", title: "Carrera" },
        { data: "Matriz.modalidad", title: "Modalidad" },
        {
        },
        {
            defaultContent:
                '<button type="button" class="btn btn-primary btn-sm btn-editar"><i class="fa fa-pen"></i></button>' +
                '<button type="button" class="btn btn-danger btn-sm ms-2 btn-eliminar"><i class="fa fa-trash"></i></button>',
            width: "90"
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
});

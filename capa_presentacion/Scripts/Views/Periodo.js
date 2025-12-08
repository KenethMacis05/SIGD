let dataTable;
var filaSeleccionada;

function abrirModal(json) {
    $("#idPeriodo").val("0");
    $("#anio").val("");
    $("#semestre").val("");
    $("#estado").prop("checked", true);

    if (json !== null) {
        $("#idPeriodo").val(json.id_periodo);
        $("#anio").val(json.anio);
        $("#semestre").val(json.semestre);
        $("#estado").prop("checked", json.estado === true);
    }

    $("#Guardar").modal("show");
}

//Seleccionar periodo para editar
$("#datatable tbody").on("click", '.btn-editar', function () {
    filaSeleccionada = $(this).closest("tr");
    var data = dataTable.row(filaSeleccionada).data()
    abrirModal(data)
});

//Crear o editar asignatura
function Guardar() {
    var periodo = {
        id_periodo: $("#idPeriodo").val().trim(),
        anio: $("#anio").val().trim(),
        semestre: $("#semestre").val().trim(),
        estado: $("#estado").prop("checked")
    };

    showLoadingAlert("Procesando", "Guardando datos del periodo...");

    jQuery.ajax({
        url: config.guardarPeriodoUrl,
        type: "POST",
        data: JSON.stringify({ periodo: periodo }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            Swal.close();
            $("#Guardar").modal("hide");

            // Periodo Nuevo
            if (periodo.id_periodo == 0) {
                if (data.Resultado != 0) {
                    periodo.id_periodo = data.Resultado;
                    dataTable.row.add(periodo).draw(false);
                    showAlert("¡Éxito!", `Periodo creado correctamente`, "success");
                } else { showAlert("Error", data.Mensaje || "Error al crear el periodo", "error"); }
            }
            // Actualizar periodo
            else {
                if (data.Resultado) {
                    dataTable.row(filaSeleccionada).data(periodo);
                    filaSeleccionada = null;
                    showAlert("¡Éxito!", `Periodo actualizado correctamente`, "success");
                } else { showAlert("Error", data.Mensaje || "Error al actualizar el periodo", "error"); }
            }
        },
        error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
    });
}

// Botón eliminar carrera
$("#datatable tbody").on("click", '.btn-eliminar', function () {
    const periodoseleccionado = $(this).closest("tr");
    const data = dataTable.row(periodoseleccionado).data();

    confirmarEliminacion().then((result) => {
        if (result.isConfirmed) {
            showLoadingAlert("Eliminando periodo", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: config.eliminarPeriodoUrl,
                type: "POST",
                data: JSON.stringify({ idPeriodo: data.id_periodo }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        dataTable.row(periodoseleccionado).remove().draw();
                        showAlert("¡Eliminado!", response.Mensaje || "Periodo eliminado correctamente", "success");
                    } else { showAlert("Error", response.Mensaje || "No se pudo eliminar el periodo", "error"); }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
});

const dataTableOptions = {
    ...dataTableConfig,

    ajax: {
        url: config.listarPeriodosUrl,
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
        { data: "anio" },
        { data: "semestre" },
        {
            data: "estado",
            render: function (valor) {
                return valor
                    ? "<div class='d-flex justify-content-center align-items-center'><span class='badge text-bg-success'>ACTIVO</span></div>"
                    : "<div class='d-flex justify-content-center align-items-center'><span class='badge text-bg-danger'>NO ACTIVO</span></div>";
            },
            width: "90"
        },
        {
            defaultContent:
                '<button type="button" class="btn btn-primary btn-sm btn-editar"><i class="fa fa-pen"></i></button>' +
                '<button type="button" class="btn btn-danger btn-sm ms-2 btn-eliminar"><i class="fa fa-trash"></i></button>',
            width: "90"
        }
    ],
};

$(document).ready(function () {
    dataTable = $("#datatable").DataTable(dataTableOptions);
});
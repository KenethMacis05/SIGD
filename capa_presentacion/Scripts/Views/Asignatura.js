let dataTable;
var filaSeleccionada;

function abrirModal(json) {
    $("#idAsignatura").val("0");
    $("#nombre").val("");
    $("#codigo").val("");
    $("#estado").prop("checked", true);

    if (json !== null) {
        $("#idAsignatura").val(json.id_asignatura);
        $("#nombre").val(json.nombre);
        $("#codigo").val(json.codigo);
        $("#estado").prop("checked", json.estado === true);
    }

    $("#Guardar").modal("show");
}

//Seleccionar asignatura para editar
$("#datatable tbody").on("click", '.btn-editar', function () {
    filaSeleccionada = $(this).closest("tr");
    var data = dataTable.row(filaSeleccionada).data()
    abrirModal(data)
});

//Crear o editar asignatura
function Guardar() {
    var asignatura = {
        id_asignatura: $("#idAsignatura").val().trim(),
        nombre: $("#nombre").val().trim(),
        codigo: $("#codigo").val().trim(),
        estado: $("#estado").prop("checked")
    };

    showLoadingAlert("Procesando", "Guardando datos de la asignatura...");

    jQuery.ajax({
        url: config.guardarAsignaturaUrl,
        type: "POST",
        data: JSON.stringify({ asignatura: asignatura }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            Swal.close();
            $("#Guardar").modal("hide");

            // Asignatura Nueva
            if (asignatura.id_asignatura == 0) {
                if (data.Resultado != 0) {
                    asignatura.id_asignatura = data.Resultado;
                    dataTable.row.add(asignatura).draw(false);
                    showAlert("¡Éxito!", `Asignatura creada correctamente`, "success");
                } else { showAlert("Error", data.Mensaje || "Error al crear la Asignatura", "error"); }
            }
            // Actualizar asignatura
            else {
                if (data.Resultado) {
                    dataTable.row(filaSeleccionada).data(asignatura);
                    filaSeleccionada = null;
                    showAlert("¡Éxito!", `Asignatura actualizada correctamente`, "success");
                } else { showAlert("Error", data.Mensaje || "Error al actualizar la asignatura", "error"); }
            }
        },
        error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
    });
}

// Botón eliminar carrera
$("#datatable tbody").on("click", '.btn-eliminar', function () {
    const asignaturaseleccionada = $(this).closest("tr");
    const data = dataTable.row(asignaturaseleccionada).data();

    confirmarEliminacion().then((result) => {
        if (result.isConfirmed) {
            showLoadingAlert("Eliminando asignatura", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: config.eliminarAsignaturaUrl,
                type: "POST",
                data: JSON.stringify({ idAsignatura: data.id_asignatura }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        dataTable.row(asignaturaseleccionada).remove().draw();
                        showAlert("¡Eliminado!", response.Mensaje || "Asignatura eliminada correctamente", "success");
                    } else { showAlert("Error", response.Mensaje || "No se pudo eliminar la asignatura", "error"); }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
});

const dataTableOptions = {
    ...dataTableConfig,

    ajax: {
        url: config.listarAsignaturasUrl,
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
        { data: "codigo" },
        { data: "nombre" },
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
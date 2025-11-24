let dataTable;
var filaSeleccionada;

// Abrir modal para crear/editar Modalidad
function abrirModal(json) {
    $("#idModalidad").val("0");
    $("#nombre").val("");
    $("#estado").prop("checked", true);

    if (json !== null) {
        $("#idModalidad").val(json.id_modalidad);
        $("#nombre").val(json.nombre);
        $("#estado").prop("checked", json.estado === true);
    }

    $("#Guardar").modal("show");
}

// Seleccionar Modalidad para editar
$("#datatable tbody").on("click", '.btn-editar', function () {
    filaSeleccionada = $(this).closest("tr");
    var data = dataTable.row(filaSeleccionada).data();
    abrirModal(data);
});

// Crear o editar Modalidad
function Guardar() {
    var modalidad = {
        id_modalidad: $("#idModalidad").val().trim(),
        nombre: $("#nombre").val().trim(),
        estado: $("#estado").prop("checked")
    };

    showLoadingAlert("Procesando", "Guardando datos de la modalidad...");

    jQuery.ajax({
        url: "/Catalogos/GuardarModalidad",
        type: "POST",
        data: JSON.stringify({ modalidad: modalidad }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            Swal.close();
            $("#Guardar").modal("hide");

            // Modalidad Nueva
            if (modalidad.id_modalidad == 0) {
                if (data.Resultado != 0) {
                    modalidad.id_modalidad = data.Resultado;
                    dataTable.row.add(modalidad).draw(false);
                    showAlert("¡Éxito!", `Modalidad creada correctamente`, "success");
                } else {
                    showAlert("Error", data.Mensaje || "Error al crear la modalidad", "error");
                }
            }
            // Actualizar modalidad
            else {
                if (data.Resultado) {
                    dataTable.row(filaSeleccionada).data(modalidad).draw(false);
                    filaSeleccionada = null;
                    showAlert("¡Éxito!", `Modalidad actualizada correctamente`, "success");
                } else {
                    showAlert("Error", data.Mensaje || "Error al actualizar la modalidad", "error");
                }
            }
        },
        error: (xhr) => {
            showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
        }
    });
}

// Botón eliminar Modalidad
$("#datatable tbody").on("click", '.btn-eliminar', function () {
    const modalidadSeleccionada = $(this).closest("tr");
    const data = dataTable.row(modalidadSeleccionada).data();

    confirmarEliminacion().then((result) => {
        if (result.isConfirmed) {
            showLoadingAlert("Eliminando modalidad", "Por favor espere...");

            $.ajax({
                url: "/Catalogos/EliminarModalidad",
                type: "POST",
                data: JSON.stringify({ IdModalidad: data.id_modalidad }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        dataTable.row(modalidadSeleccionada).remove().draw();
                        showAlert("¡Eliminado!", response.Mensaje || "Modalidad eliminada correctamente", "success");
                    } else {
                        showAlert("Error", response.Mensaje || "No se pudo eliminar la modalidad", "error");
                    }
                },
                error: (xhr) => {
                    showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
                }
            });
        }
    });
});

const dataTableOptions = {
    ...dataTableConfig,

    ajax: {
        url: "/Catalogos/ListarModalidad",
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
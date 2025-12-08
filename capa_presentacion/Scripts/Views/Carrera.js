let dataTable;
var filaSeleccionada;

function abrirModal(json) {
    $("#idCarrera").val("0");
    $("#nombre").val("");
    $("#codigo").val("");
    $("#estado").prop("checked", true);

    if (json !== null) {
        $("#idCarrera").val(json.id_carrera);
        $("#nombre").val(json.nombre);
        $("#codigo").val(json.codigo);
        $("#estado").prop("checked", json.estado === true);
    }

    $("#Guardar").modal("show");
}

//Seleccionar carrera para editar
$("#datatable tbody").on("click", '.btn-editar', function () {
    filaSeleccionada = $(this).closest("tr");
    var data = dataTable.row(filaSeleccionada).data()
    abrirModal(data)
});

//Crear o editar departamento
function Guardar() {
    var carrera = {
        id_carrera: $("#idCarrera").val().trim(),
        nombre: $("#nombre").val().trim(),
        codigo: $("#codigo").val().trim(),
        estado: $("#estado").prop("checked")
    };

    showLoadingAlert("Procesando", "Guardando datos de la carrera...");

    jQuery.ajax({
        url: config.guardarCarreraUrl,
        type: "POST",
        data: JSON.stringify({ carrera: carrera }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            Swal.close();
            $("#Guardar").modal("hide");

            // Carrera Nueva
            if (carrera.id_carrera == 0) {
                if (data.Resultado != 0) {
                    carrera.id_carrera = data.Resultado;
                    dataTable.row.add(carrera).draw(false);
                    showAlert("¡Éxito!", `Carrera creada correctamente`, "success");
                } else { showAlert("Error", data.Mensaje || "Error al crear el Departamento", "error"); }
            }
            // Actualizar carrera
            else {
                if (data.Resultado) {
                    dataTable.row(filaSeleccionada).data(carrera);
                    filaSeleccionada = null;
                    showAlert("¡Éxito!", `Carrera actualizada correctamente`, "success");
                } else { showAlert("Error", data.Mensaje || "Error al actualizar la carrera", "error"); }
            }
        },
        error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
    });
}

// Botón eliminar carrera
$("#datatable tbody").on("click", '.btn-eliminar', function () {
    const carreraseleccionada = $(this).closest("tr");
    const data = dataTable.row(carreraseleccionada).data();

    confirmarEliminacion().then((result) => {
        if (result.isConfirmed) {
            showLoadingAlert("Eliminando carrera", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: config.eliminarCarreraUrl,
                type: "POST",
                data: JSON.stringify({ idCarrera: data.id_carrera }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        dataTable.row(carreraseleccionada).remove().draw();
                        showAlert("¡Eliminado!", response.Mensaje || "Carrera eliminada correctamente", "success");
                    } else { showAlert("Error", response.Mensaje || "No se pudo eliminar la carrera", "error"); }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
});

const dataTableOptions = {
    ...dataTableConfig,

    ajax: {
        url: config.listarCarreraUrl,
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
let dataTable;
var filaSeleccionada;

function abrirModal(json) {
    $("#idArea").val("0");
    $("#nombre").val("");
    $("#codigo").val("");
    $("#estado").prop("checked", true);

    if (json !== null) {
        $("#idArea").val(json.id_area);
        $("#nombre").val(json.nombre);
        $("#codigo").val(json.codigo);
        $("#estado").prop("checked", json.estado === true);
    }

    $("#Guardar").modal("show");
}

//Seleccionar área de conocimiento para editar
$("#datatable tbody").on("click", '.btn-editar', function () {
    filaSeleccionada = $(this).closest("tr");
    var data = dataTable.row(filaSeleccionada).data()
    abrirModal(data)
});

//Crear o editar área de conocimiento
function Guardar() {
    var area = {
        id_area: $("#idArea").val().trim(),
        nombre: $("#nombre").val().trim(),
        codigo: $("#codigo").val().trim(),
        estado: $("#estado").prop("checked")
    };

    showLoadingAlert("Procesando", "Guardando datos del área de conocimiento...");

    jQuery.ajax({
        url: config.guardarAreaDeConocimientoUrl,
        type: "POST",
        data: JSON.stringify({ area: area }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            Swal.close();
            $("#Guardar").modal("hide");

            // Área Nueva
            if (area.id_area == 0) {
                if (data.Resultado != 0) {
                    area.id_area = data.Resultado;
                    dataTable.row.add(area).draw(false);
                    showAlert("¡Éxito!", `Área de conocimiento creada correctamente`, "success");
                } else { showAlert("Error", data.Mensaje || "Error al crear el Área de conocimiento", "error"); }
            }
            // Actualizar área
            else {
                if (data.Resultado) {
                    dataTable.row(filaSeleccionada).data(area);
                    filaSeleccionada = null;
                    showAlert("¡Éxito!", `Área de conocimiento actualizada correctamente`, "success");
                } else { showAlert("Error", data.Mensaje || "Error al actualizar el Área de conocimiento", "error"); }
            }
        },
        error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
    });
}

// Botón eliminar área de conocimiento
$("#datatable tbody").on("click", '.btn-eliminar', function () {
    const areaseleccionada = $(this).closest("tr");
    const data = dataTable.row(areaseleccionada).data();

    confirmarEliminacion().then((result) => {
        if (result.isConfirmed) {
            showLoadingAlert("Eliminando área de conocimiento", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: config.eliminarAreaDeConocimientoUrl,
                type: "POST",
                data: JSON.stringify({ IdArea: data.id_area }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        dataTable.row(areaseleccionada).remove().draw();
                        showAlert("¡Eliminado!", response.Mensaje || "Área de conocimiento eliminada correctamente", "success");
                    } else { showAlert("Error", response.Mensaje || "No se pudo eliminar el área de conocimiento", "error"); }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
});

const dataTableOptions = {
    ...dataTableConfig,

    ajax: {
        url: config.listarAreasDeConocimientoUrl,
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
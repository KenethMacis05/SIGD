let dataTable;
var filaSeleccionada;

function abrirModal(json) {
    $("#idDepartamento").val("0");
    $("#nombre").val("");
    $("#codigo").val("");
    $("#estado").prop("checked", true);

    if (json !== null) {
        $("#idDepartamento").val(json.id_departamento);
        $("#nombre").val(json.nombre);
        $("#codigo").val(json.codigo);
        $("#estado").prop("checked", json.estado === true);
    }

    $("#Guardar").modal("show");
}

//Seleccionar departamento para editar
$("#datatable tbody").on("click", '.btn-editar', function () {
    filaSeleccionada = $(this).closest("tr");
    var data = dataTable.row(filaSeleccionada).data()
    abrirModal(data)
});

//Crear o editar departamento
function Guardar() {
    var departamento = {
        id_departamento: $("#idDepartamento").val().trim(),
        nombre: $("#nombre").val().trim(),
        codigo: $("#codigo").val().trim(),
        estado: $("#estado").prop("checked")
    };

    showLoadingAlert("Procesando", "Guardando datos del departamento...");

    jQuery.ajax({
        url: config.guardarDepartamentoUrl,
        type: "POST",
        data: JSON.stringify({ departamento: departamento }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            Swal.close();
            $("#Guardar").modal("hide");

            // Carrera Nueva
            if (departamento.id_departamento == 0) {
                if (data.Resultado != 0) {
                    departamento.id_departamento = data.Resultado;
                    dataTable.row.add(departamento).draw(false);
                    showAlert("¡Éxito!", `Departamento creado correctamente`, "success");
                } else { showAlert("Error", data.Mensaje || "Error al crear el Departamento", "error"); }
            }
            // Actualizar área
            else {
                if (data.Resultado) {
                    dataTable.row(filaSeleccionada).data(departamento);
                    filaSeleccionada = null;
                    showAlert("¡Éxito!", `Departamento actualizado correctamente`, "success");
                } else { showAlert("Error", data.Mensaje || "Error al actualizar el Departamento", "error"); }
            }
        },
        error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
    });
}

// Botón eliminar departamento
$("#datatable tbody").on("click", '.btn-eliminar', function () {
    const departamentoseleccionado = $(this).closest("tr");
    const data = dataTable.row(departamentoseleccionado).data();

    confirmarEliminacion().then((result) => {
        if (result.isConfirmed) {
            showLoadingAlert("Eliminando departamento", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: config.eliminarDepartamentoUrl,
                type: "POST",
                data: JSON.stringify({ idDepartamento: data.id_departamento }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        dataTable.row(departamentoseleccionado).remove().draw();
                        showAlert("¡Eliminado!", response.Mensaje || "Departamento eliminado correctamente", "success");
                    } else { showAlert("Error", response.Mensaje || "No se pudo eliminar el departamento", "error"); }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
});

const dataTableOptions = {
    ...dataTableConfig,

    ajax: {
        url: config.listarDepartamentosUrl,
        type: "GET",
        dataType: "json"
    },

    columns: [
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
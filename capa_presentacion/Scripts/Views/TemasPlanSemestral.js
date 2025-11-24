let dataTable;
var filaSeleccionada;

function abrirModal(json) {
    $("#idTema").val("0");
    $("#tema").val("");
    $("#horasTeoricas").val("");
    $("#horasLaboratorio").val("");
    $("#horasPracticas").val("");
    $("#horasInvestigacion").val("");

    if (json !== null) {
        $("#idTema").val(json.id_tema);
        $("#idPlanDidactico").val(json.fk_plan_didactico);
        $("#tema").val(json.tema);
        $("#horasTeoricas").val(json.horas_teoricas);
        $("#horasLaboratorio").val(json.horas_laboratorio);
        $("#horasPracticas").val(json.horas_practicas);
        $("#horasInvestigacion").val(json.horas_investigacion);
    }

    $("#modalTemas").modal("show");

}

$("#datatable tbody").on("click", '.btn-editar', function () {
    filaSeleccionada = $(this).closest("tr");
    var data = dataTable.row(filaSeleccionada).data()
    abrirModal(data)
});

function Guardar() {

    var Tema = {
        id_tema: $("#idTema").val().trim(),
        fk_plan_didactico: $("#idPlanDidactico").val().trim(),
        tema: $("#tema").val().trim(),
        horas_teoricas: $("#horasTeoricas").val().trim(),
        horas_laboratorio: $("#horasLaboratorio").val().trim(),
        horas_practicas: $("#horasPracticas").val().trim(),
        horas_investigacion: $("#horasInvestigacion").val().trim(),
    };

    showLoadingAlert("Procesando", "Guardando datos del tema...");

    jQuery.ajax({
        url: '/Planificacion/GuardarTemasPlanSemestral',
        type: "POST",
        data: JSON.stringify({ tema: Tema }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            Swal.close();
            $("#modalTemas").modal("hide");

            // Tema Nuevo
            if (Tema.id_tema == 0) {
                if (data.Resultado != 0) {
                    Tema.id_tema = data.Resultado;
                    dataTable.row.add(Tema).draw(false);
                    showAlert("¡Éxito!", `Tema creado correctamente`, "success");
                } else { showAlert("Error", data.Mensaje || "Error al crear el tema", "error"); }
            }
            // Actualizar tema
            else {
                if (data.Resultado) {
                    dataTable.row(filaSeleccionada).data(Tema);
                    filaSeleccionada = null;
                    showAlert("¡Éxito!", `Tema actualizado correctamente`, "success");
                } else { showAlert("Error", data.Mensaje || "Error al actualizar el tema", "error"); }
            }
        },
        error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
    });
}

function cargarTemas(id) {
    $.ajax({
        url: '/Planificacion/ListarTemasPlanSemestral',
        type: "GET",
        dataType: "json",
        data: { idEncriptado: id },
        beforeSend: () => $("#datatable tbody").LoadingOverlay("show"),
        success: function (response) {
            if (response && response.resultado === 1 && Array.isArray(response.data)) {
                // Limpiar y agregar nuevos datos
                dataTable.clear();
                dataTable.rows.add(response.data).draw();

                if (response.data.length === 0) {
                    showAlert("Advertencia", "No se encontraron temas para este plan", "warning");
                }
            } else {
                showAlert("Advertencia", response.mensaje || "No se encontraron resultados", "warning");
            }
        },
        complete: () => $("#datatable tbody").LoadingOverlay("hide"),
        error: function (xhr, status, error) {
            showAlert("Error", "Error al conectar con el servidor: " + error, "error");
        }
    });
}

$("#datatable tbody").on("click", '.btn-eliminar', function () {
    filaSeleccionada = $(this).closest("tr");
    const data = dataTable.row(filaSeleccionada).data();

    confirmarEliminacion().then((result) => {
        if (result.isConfirmed) {
            showLoadingAlert("Eliminando tema", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: "/Planificacion/EliminarTemasPlanSemestral",
                type: "POST",
                data: JSON.stringify({ id_tema: data.id_tema }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        dataTable.row(filaSeleccionada).remove().draw();
                        showAlert("¡Eliminado!", response.Mensaje || "Tema eliminado correctamente", "success")
                    } else { showAlert("Error", response.Mensaje || "No se pudo eliminar el tema", "error") }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
});

const dataTableOptions = {
    ...dataTableConfig,
    data: [],
    columns: [
        {
            data: null,
            title: "#",
            render: function (data, type, row, meta) {
                return meta.row + 1;
            },
            orderable: false, width: "30"
        },
        { data: "tema", title: "Tema" },
        { data: "horas_teoricas", title: "HT", width: "50" },
        { data: "horas_laboratorio", title: "HL", width: "50" },
        { data: "horas_practicas", title: "HPr", width: "50" },
        { data: "horas_investigacion", title: "HTI", width: "50" },
        {
            defaultContent:
                '<button type="button" class="btn btn-primary btn-sm btn-editar"><i class="fa fa-pen"></i></button>' +
                '<button type="button" class="btn btn-danger btn-sm ms-2 btn-eliminar"><i class="fa fa-trash"></i></button>',
            width: "90"
        },
    ]
};

$(document).ready(function () {
    dataTable = $("#datatable").DataTable(dataTableOptions);
});
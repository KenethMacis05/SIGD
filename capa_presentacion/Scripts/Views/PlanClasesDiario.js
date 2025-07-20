let dataTable;

$('#datatable tbody').on('click', '.btn-detalles', function () {
    var data = dataTable.row($(this).parents('tr')).data();
    // Redirigir a la pantalla de detalles
    window.location.href = "/Planificacion/DetallePlanDiario";
});

$('#datatable tbody').on('click', '.btn-editar', function () {
    var data = dataTable.row($(this).parents('tr')).data();
    // Redirigir a la pantalla de edición
    window.location.href = "/Planificacion/EditarPlanDiario?id=" + data.id_plan_diario;
});

//Boton eliminar plan de clases diario
$("#datatable tbody").on("click", '.btn-eliminar', function () {
    const planseleccionado = $(this).closest("tr");
    const data = dataTable.row(planseleccionado).data();

    confirmarEliminacion().then((result) => {
        if (result.isConfirmed) {
            showLoadingAlert("Eliminando plan de clases", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: "/Planificacion/EliminarPlanClasesDiario",
                type: "POST",
                data: JSON.stringify({ id_plan_diario: data.id_plan_diario }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        dataTable.row(planseleccionado).remove().draw();
                        showAlert("¡Eliminado!", response.Mensaje || "Plan de clases eliminado correctamente", "success")
                    } else { showAlert("Error", response.Mensaje || "No se pudo eliminar el plan de clases", "error") }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
});

const dataTableOptions = {
    ...dataTableConfig,
    ajax: {
        url: "/Planificacion/ListarPlanesClases",
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
        { data: "asignatura", title: "Asignatura" },
        {
            data: "fecha_inicio",
            render: function (data, type, row) {
                return formatASPNetDate(data, false) + ' - ' + formatASPNetDate(row.fecha_fin, false);
            }, title: "Inicio/Fin"
        },
        { data: "periodo", title: "Periodo" },
        {
            data: "fecha_registro", title: "Fecha",
            render: function (data) {
                return data ? formatASPNetDate(data) : "N/A";
            }
        },
        {
            defaultContent:
                '<button type="button" class="btn btn-primary btn-sm btn-detalles"><i class="fa fa-eye"></i></button>' +
                '<button type="button" class="btn btn-success btn-sm ms-1 btn-pdf"><i class="fa fa-file-pdf"></i></button>' +
                '<button type="button" class="btn btn-warning btn-sm ms-1 btn-editar"><i class="fa fa-pen"></i></button>' +
                '<button type="button" class="btn btn-danger btn-sm ms-1 btn-eliminar"><i class="fa fa-trash"></i></button>',
            width: "130"
        },
    ]
};

$(document).ready(function () {
    dataTable = $("#datatable").DataTable(dataTableOptions);
});
let dataTable;
var IdMatriz = $('#idEncriptado').val()
var filaSeleccionada;

// Redirigir a la pantalla de contenidos por semana
$('#datatable tbody').on('click', '.btn-viewContenidosSemana', function () {
    var data = dataTable.row($(this).parents('tr')).data();
    window.location.href = `/Planificacion/ContenidosPorSemana?idEncriptado=${data.fk_matriz_integracion_encriptado}&semana=${encodeURIComponent(data.numero_semana)}`;
});

// Evento para editar
$("#datatable tbody").on("click", '.btn-editar', function () {
    filaSeleccionada = $(this).closest("tr");
    const data = dataTable.row(filaSeleccionada).data();
    abrirModal(data);
});

// Función para abrir modal en modo edición
function abrirModal(json) {
    $("#idSemana").val("0");
    $("#numeroSemana").val("");
    $("#descripcion").val("");
    $("#fechaInicio").val("");
    $("#fechaFin").val("");
    $("#tipoSemana").val("");


    if (json != null) {
        $("#idSemana").val(json.id_semana || "0");
        $("#numeroSemana").val(json.numero_semana);
        $("#descripcion").val(json.descripcion);
        $("#fechaInicio").val(formatDateForInput(json.fecha_inicio));
        $("#fechaFin").val(formatDateForInput(json.fecha_fin));
        $("#tipoSemana").val(json.tipo_semana);
    }

    $("#semanasModal").modal("show");
}

function Guardar() {
    var Semana = {
        id_semana: $("#idSemana").val().trim(),
        numero_semana: $("#numeroSemana").val().trim(),
        descripcion: $("#descripcion").val().trim(),
        fecha_inicio: $("#fechaInicio").val().trim(),
        fecha_fin: $("#fechaFin").val().trim(),
        tipo_semana: $("#tipoSemana").val().trim(),
    };

    showLoadingAlert("Procesando", "Guardando datos de la semana...");

    jQuery.ajax({
        url: '/Planificacion/GuardarSemanaMatriz',
        type: "POST",
        data: JSON.stringify({ semana: Semana }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            Swal.close();
            $("#semanasModal").modal("hide");

            // Nueva semana
            if (Semana.id_semana == 0) {
                if (data.Resultado != 0) {
                    Semana.id_semana = data.Resultado;
                    dataTable.row.add(Semana).draw(false);
                    showAlert("¡Éxito!", `Semana creada correctamente`, "success");
                } else { showAlert("Error", data.Mensaje || "Error al crear la Semana", "error"); }
            }
            // Actualizar semana
            else {
                if (data.Resultado) {
                    dataTable.row(filaSeleccionada).data(Semana);
                    filaSeleccionada = null;
                    showAlert("¡Éxito!", `Semana actualizada correctamente`, "success");
                } else { showAlert("Error", data.Mensaje || "Error al actualizar la semana", "error"); }
            }
        },
        error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
    });
}

const dataTableOptions = {
    ...dataTableConfig,
    ajax: {
        url: "/Planificacion/ListarSemanasMatriz",
        type: "GET",
        dataType: "json",
        data: function (d) {
            d.idEncriptado = IdMatriz;
        },
    },

    columns: [
        { data: "numero_semana", title: "Semana" },
        {
            data: "fecha_inicio", title: "Fecha Inicio",
            render: function(data){
                return data ? formatASPNetDate(data, false) : "N/A";
            }
        },
        {
            data: "fecha_fin", title: "Fecha Fin",
            render: function (data) {
                return data ? formatASPNetDate(data, false) : "N/A";
            }
        },
        { data: "descripcion", title: "Descripción" },
        {
            data: "tipo_semana", title: "Tipo",
            render: function (data) {
                let badgeClass = 'success';
                let icon = 'fa-pen';

                if (data === "Corte Final") {
                    badgeClass = 'danger'
                    icon = 'fa-trophy'
                } else if (data === "Corte Evaluativo") {
                    badgeClass = 'warning'
                    icon = 'fa-star'
                }
                return `
                    <span class="badge bg-${badgeClass} bg-gradient">
                        <i class="fas ${icon} me-1"></i>${data}
                    </span>
                `;
            }
        },
        {
            data: "estado", title: "Estado",
            render: function (data) {
                let badgeClass = 'secondary';
                let icon = 'fa-clock';

                if (data === 'En proceso') {
                    badgeClass = 'primary';
                    icon = 'fa-spinner';
                } else if (data === 'Finalizado') {
                    badgeClass = 'success';
                    icon = 'fa-check';
                }

                return `
                    <span class="badge bg-${badgeClass} bg-gradient">
                        <i class="fas ${icon} me-1"></i>${data}
                    </span>
                `;
            }
        },
        {
            defaultContent:
                '<button type="button" class="btn btn-warning btn-sm ms-1 btn-editar"><i class="fa fa-pen"></i></button>' +
                '<button type="button" class="btn btn-primary btn-sm ms-1 btn-viewContenidosSemana"><i class="fa fa-eye"></i></button>' ,
            width: "50"
        },
    ]
};


$(document).ready(function () {
    dataTable = $("#datatable").DataTable(dataTableOptions);
});
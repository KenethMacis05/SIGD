let dataTable;

// Configuración de DataTable
const dataTableOptions = {
    ...dataTableConfig,
    columnDefs: [
        { orderable: false, targets: [6] },
        { searchable: false, targets: [6] }
    ],
    order: [[0, 'asc']]
};

$(document).ready(function () {
    dataTable = $("#datatable").DataTable(dataTableOptions);
});

// Función para abrir modal en modo edición
function abrirModal(data) {
    $("#idSemana").val(data.id_semana || "0");
    $("#numeroSemana").val(data.numero_semana);
    $("#descripcion").val(data.descripcion);
    $("#fechaInicio").val(formatDateForInput(data.fecha_inicio));
    $("#fechaFin").val(formatDateForInput(data.fecha_fin));
    $("#tipoSemana").val(data.tipo_semana);
    $("#estado").val(data.estado);

    $("#semanasModalLabel").text("Editar Semana");
    $("#semanasModal").modal("show");
}

// Función para formatear fecha para input type="date"
function formatDateForInput(dateString) {
    if (!dateString) return '';
    const date = new Date(dateString);
    return date.toISOString().split('T')[0];
}

// Evento para editar
$("#datatable tbody").on("click", '.btn-editar', function () {
    const filaSeleccionada = $(this).closest("tr");
    const data = dataTable.row(filaSeleccionada).data();
    abrirModal(data);
});
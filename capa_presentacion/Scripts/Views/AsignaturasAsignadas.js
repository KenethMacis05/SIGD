let dataTable;

// Redirigir a la pantalla de asignar asignaturas
$('#datatable tbody').on('click', '.btn-viewSemanas', function () {
    var data = dataTable.row($(this).parents('tr')).data();
    const idEncriptado = data.id_matriz_asignatura_encriptado;
    window.location.href = "/Planificacion/Contenidos?idEncriptado=" + idEncriptado;
});

const dataTableOptions = {
    ...dataTableConfig,
    ajax: {
        url: "/Planificacion/ListarAsignaturaAsignadas",
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
        { data: "codigo_matriz", title: "Codigo" },
        { data: "nombre_matriz", title: "Nombre" },
        { data: "nombre_profesor", title: "Propietario" },
        { data: "nombre_asignatura", title: "Asignatura" },
        { data: "total_contenidos", title: "# de Semanas" },
        {
            data: "estado",
            title: "Estado",
            render: function (valor) {
                if (valor === "Finalizado") {
                    return "<div class='d-flex justify-content-center align-items-center'><span class='badge text-bg-success'><i class='fas fa-check-circle fa-2x'></i></span></div>";
                } else if (valor === "En proceso") {
                    return "<div class='d-flex justify-content-center align-items-center'><span class='badge text-bg-primary'><i class='fas fa-spinner fa-spin fa-2x'></i></span></div>";
                } else {
                    return "<div class='d-flex justify-content-center align-items-center'><span class='badge text-bg-secondary'><i class='fas fa-clock fa-2x'></i></span></div>";
                }
            }
        },
        {
            data: "fecha_registro", title: "Asignada",
            render: function (data) {
                return data ? formatASPNetDate(data) : "N/A";
            }
        },
        {
            defaultContent:
                '<button type="button" class="btn btn-info btn-sm ms-1 btn-viewSemanas"><i class="fa fa-user-graduate"></i></button>',
            width: "50"
        },
    ]
};

$(document).ready(function () {
    dataTable = $("#datatable").DataTable(dataTableOptions);
});
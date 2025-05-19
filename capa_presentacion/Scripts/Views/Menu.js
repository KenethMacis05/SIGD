let datatableMenus;

// Cargar roles en el selec
jQuery.ajax({
    url: config.listarRolesUrl,
    type: "GET",
    dataType: "json",
    contentType: "application/json; charset=utf-8",
    success: function (response) {
        $('#obtenerRolMenu').empty().append('<option value="" disabled selected>Seleccione un rol</option>');
        $.each(response.data, function (index, rol) {
            $('#obtenerRolMenu').append(`<option value="${rol.id_rol}">${rol.descripcion}</option>`);
        });
    },
    error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
})

// Mostrar menus del Rol
$("#btnBuscarMenu").off("click").on("click", function () {
    idRol = $('#obtenerRolMenu').val();
    if (!idRol) {
        showAlert("¡Atención!", "Primero debe seleccionar un rol", "warning");
        return false;
    }    
    carparMenus(idRol)
});

function carparMenus(idRol) {
    $.ajax({
        url: config.listarMenusPorRolUrl,
        type: "GET",
        dataType: "json",
        data: { IdRol: idRol },
        contentType: "application/json; charset=utf-8",
        beforeSend: () => $("#datatableMenus tbody").LoadingOverlay("show"),

        success: function (data) {
            datatableMenus.clear().rows.add(data.data).draw();
            console.log(data.data)
        },

        complete: () => $("#datatableMenus tbody").LoadingOverlay("hide"),
        error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
    });
}


const dataTableOptions = {
    ...dataTableConfig,
    columns: [
        {

            data: null,
            title: "#",
            render: function (data, type, row, meta) {
                return meta.row + 1;
            },
            orderable: false

        },        
        {
            title: "Menu",
            data: "nombre",
            render: function (data, type, row) {
                return `
                    <div class='d-flex flex-row align-items-center esp-link'>
                        <div class='sb-nav-link-icon me-1'>
                             <i class='${row.icono}'></i>
                         </div>
                             ${data}
                    </div>
                `;
            }
        },
        { data: "Controller.controlador", title: "Controlador" },
        { data: "Controller.accion", title: "Acción" },
        {
            data: "orden",
            title: "Orden",
            render: function (valor) {
                return `
                    <div class='d-flex justify-content-center align-items-center'>
                        <span class='badge text-bg-primary'>${valor}</span>
                    </div>
                `;
            },
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
    datatableMenus = $("#datatableMenus").DataTable(dataTableOptions);
});
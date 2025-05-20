let datatableMenus;
let datatableMenusNoAsignados;

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
    cargarMenus(idRol)
});

// Función para abrir el modal y cargar menus no asignados
function abrirModal() {
    var IdRol = $('#obtenerRolMenu').val();
    if (!IdRol) {
        showAlert("¡Atención!", "Primero debe seleccionar un rol", "warning");
        return false;
    }

    cargarMenusNoAsignados(IdRol);
    $("#modalMenus").modal("show");
}

// Cargar menus del rol
function cargarMenus(idRol) {
    $.ajax({
        url: config.listarMenusPorRolUrl,
        type: "GET",
        dataType: "json",
        data: { IdRol: idRol },
        contentType: "application/json; charset=utf-8",
        beforeSend: () => $("#datatableMenus tbody").LoadingOverlay("show"),

        success: function (data) {
            datatableMenus.clear().rows.add(data.data).draw();
        },

        complete: () => $("#datatableMenus tbody").LoadingOverlay("hide"),
        error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
    });
}

// Cargar menus no asignados del rol
function cargarMenusNoAsignados(IdRol) {
    $.ajax({
        url: config.listarMenusNoAsignadosPorRolUrl,
        type: "GET",
        dataType: "json",
        data: { IdRol: IdRol },
        contentType: "application/json; charset=utf-8",
        beforeSend: () => $("#datatableMenusNoAsignados tbody").LoadingOverlay("show"),

        success: function (data) {
            datatableMenusNoAsignados.clear().draw();

            if (data && data.data && Array.isArray(data.data)) {
                $.each(data.data, function (index, menu) {
                    datatableMenusNoAsignados.row.add([
                        index + 1,
                        `<div class='d-flex flex-row align-items-center esp-link'>
                            <div class='sb-nav-link-icon me-1'>
                                <i class='${menu.icono}'></i>
                            </div>
                            ${menu.nombre}
                        </div>`,
                        menu.Controller.controlador,
                        menu.Controller.accion,
                        `<div class='d-flex justify-content-center align-items-center'>
                            <span class='badge text-bg-primary'>${menu.orden}</span>
                        </div>`,
                        `<div class="icheck-primary">
                            <input type="checkbox" class="checkboxIcheck menuCheckbox"
                                   id="menu_${menu.id_menu}" 
                                   data-id="${menu.id_menu}">
                            <label for="menu_${menu.id_menu}"></label>
                         </div>`
                    ]);
                });
                datatableMenusNoAsignados.draw();

            } else {
                showAlert("Error", `Datos no válidos recibidos: ${data}`, "error");
            }
        },

        complete: () => $("#datatableMenusNoAsignados tbody").LoadingOverlay("hide"),
        error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
    });
}

// Seleccionar Todo
$('#selectAll').on('click', function () {
    const totalCheckboxes = $('.menuCheckbox').length;
    const checkedCheckboxes = $('.menuCheckbox:checked').length;

    if (checkedCheckboxes === totalCheckboxes) {
        showAlert("¡Atención!", "Todos los elementos ya están seleccionados.", "info", true);
        return;
    }

    $("#datatableMenusNoAsignados .tbody").LoadingOverlay("show");

    setTimeout(() => {
        $('.menuCheckbox').prop('checked', true);
        $("#datatableMenusNoAsignados .tbody").LoadingOverlay("hide");
    }, 300);
});

// Deseleccionar Todo
$('#deselectAll').on('click', function () {    
    const checkedCheckboxes = $('.menuCheckbox:checked').length;

    if (checkedCheckboxes === 0) {
        showAlert("¡Atención!", "Todos los elementos ya están desmarcados.", "info", true);
        return;
    }
    $("#datatableMenusNoAsignados .tbody").LoadingOverlay("show");

    setTimeout(() => {
        $('.menuCheckbox').prop('checked', false);
        $("#datatableMenusNoAsignados .tbody").LoadingOverlay("hide");
    }, 300);
});

// Guardar nuevos menus
$('#btnGuardarMenus').click(function () {
    var IdRol = $('#obtenerRolMenu').val();
    var menusSeleccionados = [];

    $('#datatableMenusNoAsignados tbody').find('.menuCheckbox:checked').each(function () {
        menusSeleccionados.push($(this).data('id'));
    });

    if (menusSeleccionados.length === 0) {
        showAlert("!Atención¡", "Debe seleccionar al menos un menú", "warning", true);
        return;
    }

    $.LoadingOverlay("hide");

    $.ajax({
        url: config.guardarMenusPorRolUrl,
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
            IdRol: IdRol,
            IdsMenus: menusSeleccionados
        }),
        success: function (response) {
            $.LoadingOverlay("hide");

            if (response.success) {
                var exitosos = response.totalExitosos;
                var fallidos = response.totalFallidos;

                if (fallidos > 0) {
                    showAlert(
                        exitosos > 0 ? "Proceso parcialmente exitoso" : "Proceso con errores",
                        `${exitosos} menús procesados correctamente | ${fallidos} con inconvenientes`,
                        exitosos > 0 ? "info" : "warning"
                    );
                } else {
                    showAlert("¡Éxito!", `Todos los menús (${exitosos}) fueron procesados correctamente`, "success");
                }

                $('#modalMenus').modal('hide');                
            } else {
                showAlert("Error", response.message || "Ocurrió un error al asignar los menus", "error");
            }
        },
        error: (xhr) => {
            $.LoadingOverlay("hide");
            showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
        }
    });
});

//Boton eliminar un menu
$("#datatableMenusNoAsignados tbody").on("click", '.btn-eliminar', function () {
    const menuSeleccionado = $(this).closest("tr");
    const data = datatableMenusNoAsignados.row(menuSeleccionado).data();

    confirmarEliminacion().then((result) => {
        if (result.isConfirmed) {
            showLoadingAlert("Eliminando menú", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: config.eliminarMenuUrl,
                type: "POST",
                data: JSON.stringify({ IdRol: data.id_menu_rol }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        dataTable.row(permisoSeleccionado).remove().draw();
                        showAlert("¡Eliminado!", response.Mensaje || "Permiso eliminado correctamente", "success")
                    } else { showAlert("Error", response.Mensaje || "No se pudo eliminar el permiso", "error") }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
});

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
        { data: "Controller.accion", title: "Vista" },
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

const dataTableNoAsignadosOptions = {
    ...dataTableConfig,
    columns: [
        { title: "#" },
        { title: "Menu" },
        { title: "Controlador" },
        { title: "Vista" },
        { title: "Orden" },
        {
            title: "Seleccionar",
            orderable: false,
            width: "100px"
        }
    ],
};

$(document).ready(function () {
    datatableMenus = $("#datatableMenus").DataTable(dataTableOptions);
    datatableMenusNoAsignados = $("#datatableMenusNoAsignados").DataTable(dataTableNoAsignadosOptions);
});
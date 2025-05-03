const listarPermisosPorRolUrl = config.listarPermisosPorRolUrl;
const listarPermisosNoAsignados = config.listarPermisosNoAsignados;
const listarRolesUrl = config.listarRolesUrl;
const AsignarPermisos = config.AsignarPermisos;
let dataTableNoAsignados;
let dataTable;

// Cargar roles en el selec
jQuery.ajax({
    url: listarRolesUrl,
    type: "GET",
    dataType: "json",
    contentType: "application/json; charset=utf-8",

    success: function (response) {
        $('#obtenerRol').empty().append('<option value="" disabled selected>Seleccione un rol</option>');
        $.each(response.data, function (index, rol) {
            $('#obtenerRol').append(`<option value="${rol.id_rol}">${rol.descripcion}</option>`);
        });
    },

    error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
})

// Mostrar permisos del Rol
$("#btnBuscar").off("click").on("click", function () {
    IdRol = $('#obtenerRol').val();
    if (!IdRol) {
        showAlert("¡Atención!", "Primero debe seleccionar un rol", "warning");
        return false;
    }    
    dataTable.column(1).search('').draw();
    dataTable.column(4).search('').draw();
    carparPermisos(IdRol)
});

function carparPermisos(IdRol) {
    $.ajax({
        url: listarPermisosPorRolUrl,
        type: "GET",
        dataType: "json",
        data: { IdRol: IdRol },
        contentType: "application/json; charset=utf-8",
        beforeSend: () => $("#datatable tbody").LoadingOverlay("show"),
        
        success: function (data) {
            dataTable.clear().rows.add(data.data).draw();
        },

        complete: () => $("#datatable tbody").LoadingOverlay("hide"),
        error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
    });
}

// Función para cargar permisos no asignados
function cargarPermisosNoAsignados(IdRol) {

    $.ajax({
        url: listarPermisosNoAsignados,
        type: "GET",
        dataType: "json",
        data: { IdRol: IdRol },
        contentType: "application/json; charset=utf-8",

        beforeSend: () => $("#dataTablePermisosNoAsignados tbody").LoadingOverlay("show"),

        success: function (data) {
            dataTableNoAsignados.clear().draw();

            if (data && data.data && Array.isArray(data.data)) {
                $.each(data.data, function (index, permiso) {
                    dataTableNoAsignados.row.add([
                        index + 1,
                        permiso.controlador,
                        permiso.accion,
                        permiso.descripcion,
                        permiso.tipo,
                        `<div class="icheck-primary">
                            <input type="checkbox" class="checkboxIcheck permisoCheckbox"
                                   id="permiso_${permiso.id_controlador}" 
                                   data-id="${permiso.id_controlador}">
                            <label for="permiso_${permiso.id_controlador}"></label>
                         </div>`
                    ]);
                });
                dataTableNoAsignados.draw();

            } else {
                console.warn("Datos no válidos recibidos", data);
            }
        },
        complete: () => $("#dataTablePermisosNoAsignados tbody").LoadingOverlay("hide"),
        error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
    });
}

// Obtener controladores del rol
$("#obtenerRol").on("change", function () {
    var IdRol = $(this).val();
    
    if (!IdRol) {
        showAlert("¡Atención!", "Primero debe seleccionar un rol", "warning");        
        return false;
    }     

    $('#inputGroupSelectControlador').empty().append('<option value="Todos">Todos</option>');

    jQuery.ajax({
        url: listarPermisosPorRolUrl,
        type: "GET",
        dataType: "json",
        data: { IdRol: IdRol },
        contentType: "application/json; charset=utf-8",        
        success: function (response) {
            // Utilizar un Set para evitar duplicados
            let controladoresSet = new Set();

            $.each(response.data, function (index, registro) {
                if (!controladoresSet.has(registro.Controller.controlador)) {
                    controladoresSet.add(registro.Controller.controlador);
                    $('#inputGroupSelectControlador').append(`<option value="${registro.Controller.controlador}">${registro.Controller.controlador}</option>`);
                }
            });
        },
        complete: () => $("#datatable tbody").LoadingOverlay("hide"),
        error: () => {
            showAlert("Error", "Error al cargar los controladores", "error");                        
        }
    });
});

// Manejar el cambio en el select de controladores
$("#inputGroupSelectControlador").on("change", function () {
    var controladorSeleccionado = $(this).val();    
    var IdRol = $('#obtenerRol').val();

    if (controladorSeleccionado === "Todos") {        
        carparPermisos(IdRol)
        dataTable.column(1).search('').draw();               
    } else {
        // Mostrar registros filtrados por el controlador seleccionado
        carparPermisos(IdRol)
        dataTable.column(1).search(controladorSeleccionado).draw();        
    }
});

// Filtro por Tipo
$("#inputGroupSelectTipo").on("change", function () {
    const tipoSelecionado = $(this).val();
    var IdRol = $('#obtenerRol').val();

    if (tipoSelecionado === "Todos") {
        carparPermisos(IdRol)
        dataTable.column(4).search('').draw();
    } else {
        carparPermisos(IdRol)
        dataTable.column(4).search(tipoSelecionado).draw();
    }

});


// Función para abrir el modal y cargar permisos no asignados
function abrirModal() {
    var IdRol = $('#obtenerRol').val();
    if (!IdRol) {
        showAlert("¡Atención!", "Primero debe seleccionar un rol", "warning");
        return false;
    }

    cargarPermisosNoAsignados(IdRol);
    $("#modalPermisos").modal("show");
}

// Guardar nuevos permisos
$('#btnGuardarPermisos').click(function () {
    var IdRol = $('#obtenerRol').val();
    var permisosSeleccionados = [];

    $('#dataTablePermisosNoAsignados tbody').find('.permisoCheckbox:checked').each(function () {
        permisosSeleccionados.push($(this).data('id'));
    });

    if (permisosSeleccionados.length === 0) {
        showAlert("!Atención¡", "Debe seleccionar al menos un permiso", "warning", true);
        return;
    }

    $.LoadingOverlay("hide");

    $.ajax({
        url: AsignarPermisos,
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
            IdRol: IdRol,
            IdsControladores: permisosSeleccionados
        }),
        success: function (response) {
            $.LoadingOverlay("hide");

            if (response.success) {
                var exitosos = response.totalExitosos;
                var fallidos = response.totalFallidos;

                if (fallidos > 0) {
                    showAlert(
                        exitosos > 0 ? "Proceso parcialmente exitoso" : "Proceso con errores",
                        `${exitosos} permisos procesados correctamente | ${fallidos} con inconvenientes`,
                        exitosos > 0 ? "info" : "warning"
                    );
                } else {
                    showAlert("¡Éxito!", `Todos los permisos (${exitosos}) fueron procesados correctamente`, "success");
                }

                $('#modalPermisos').modal('hide');
                $('#btnBuscar').click();
            } else {
                showAlert("Error", response.message || "Ocurrió un error al asignar los permisos", "error");
            }
        },
        error: (xhr) => {
            $.LoadingOverlay("hide");
            showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
        }
    });
});


//Boton eliminar un permiso
$("#datatable tbody").on("click", '.btn-eliminar', function () {
    const permisoSeleccionado = $(this).closest("tr");
    const data = dataTable.row(permisoSeleccionado).data();
    
    confirmarEliminacion().then((result) => {
        if (result.isConfirmed) {
            showLoadingAlert("Eliminando permiso", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: config.eliminarPermisoUrl,
                type: "POST",
                data: JSON.stringify({ id_permiso: data.id_permiso }),
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
        { data: "Controller.controlador", title: "Controlador" },
        { data: "Controller.accion", title: "Acción" },
        { data: "Controller.descripcion", title: "Descripción" },
        {
            data: "Controller.tipo",
            title: "Tipo",
            render: function (data, type, row) {
                if (row.Controller.tipo === "API" || row.Controller.tipo === "Vista") {
                    // Mostrar el ícono y el texto según el tipo
                    const icon = row.Controller.tipo === "API"
                        ? '<i class="fa fa-cogs  text-warning"></i>' // Ícono para API
                        : '<i class="fa fa-eye text-primary"></i>'; // Ícono para Vista

                    return `${icon} ${data}`;
                } else {
                    // Si no es ni API ni Vista, devolver el texto sin ícono
                    return data;
                }
            }
        },
        {
            defaultContent:                
                '<button type="button" class="btn btn-danger btn-sm ms-2 btn-eliminar"><i class="fa fa-trash"></i></button>',
            width: "50"
        }
    ],
};

const dataTableNoAsignadosOptions = {
    ...dataTableConfig,
    columns: [
        { title: "#" },
        { title: "Controlador" },
        { title: "Acción" },
        { title: "Descripción" },
        { title: "Tipo" },
        {
            title: "Seleccionar",
            orderable: false,
            width: "100px"
        }
    ],
};

$(document).ready(function () {
    dataTable = $("#datatable").DataTable(dataTableOptions);
    dataTableNoAsignados = $("#dataTablePermisosNoAsignados").DataTable(dataTableNoAsignadosOptions);
});
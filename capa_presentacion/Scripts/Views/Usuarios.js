const listarUsuariosUrl = config.listarUsuariosUrl;
const listarRolesUrl = config.listarRolesUrl;
const guardarUsuariosUrl = config.guardarUsuariosUrl;
const eliminarUsuariosUrl = config.eliminarUsuariosUrl;
const reiniciarPasswordUrl = config.reiniciarPasswordUrl;
const buscarUsuariosUrl = config.buscarUsuariosUrl;
let dataTable;
let tablaReinicio;
var filaSeleccionada;
let rolesMap = {};

// Cargar roles en el select
jQuery.ajax({
    url: listarRolesUrl,
    type: "GET",
    dataType: "json",
    contentType: "application/json; charset=utf-8",

    success: function (response) {
        $('#inputGroupSelectRol').empty()
            .append('<option value="" disabled selected>Seleccionar...</option>')
            .append('<option value="Todos">Todos</option>');
        $('#obtenerRol').empty().append('<option value="" disabled selected>Seleccione un rol</option>');
        $.each(response.data, function (index, rol) {
            $('#inputGroupSelectRol').append(`<option value="${rol.descripcion}">${rol.descripcion}</option>`);
            $('#obtenerRol').append(`<option value="${rol.id_rol}">${rol.descripcion}</option>`);
            rolesMap[rol.id_rol] = rol.descripcion;
        });
    },

    error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
});

// Filtro por rol del usuario
$("#inputGroupSelectRol").on("change", function () {
    const rolSelecionado = $(this).val();
    $("#datatable tbody").LoadingOverlay("show");

    if (rolSelecionado === "Todos") {
        dataTable.column(2).search('').draw();
    } else {
        dataTable.column(2).search(rolSelecionado).draw();
    }
    $("#datatable tbody").LoadingOverlay("hide");
});

// Filtro por estado del usuario
$('#inputGroupSelectEstado').on('change', function () {
    const estadoSelecionado = $(this).val();    
    $("#datatable tbody").LoadingOverlay("show");

    if (estadoSelecionado === "Todos") {
        dataTable.column(9).search('').draw();
    } else {
        dataTable.column(9).search(estadoSelecionado).draw();
    }
    $("#datatable tbody").LoadingOverlay("hide");
});

//Abrir modal
function abrirModal(json) {
    $("#idUsuario").val("0");
    $("#usuario").val("").prop("disabled", true);
    $("#correo").val("");
    $("#telefono").val("");    
    $("#priNombre").val("");
    $("#segNombre").val("");
    $("#priApellido").val("");
    $("#segApellido").val("");
    $("#obtenerRol").val("");
    $("#estado").prop("checked", true);

    if (json !== null) {
        $("#idUsuario").val(json.id_usuario);
        $("#usuario").val(json.usuario).prop("disabled", true);
        $("#correo").val(json.correo);
        $("#telefono").val(json.telefono);        
        $("#priNombre").val(json.pri_nombre);
        $("#segNombre").val(json.seg_nombre);
        $("#priApellido").val(json.pri_apellido);
        $("#segApellido").val(json.seg_apellido);
        if (json.fk_rol) {
            $("#obtenerRol").val(json.fk_rol);
        }
        $("#estado").prop("checked", json.estado === true);
    }
    $("#createUser").modal("show");
}

//Boton seleccionar usuario para editar
$("#datatable tbody").on("click", '.btn-editar', function () {
    filaSeleccionada = $(this).closest("tr");
    var data = dataTable.row(filaSeleccionada).data()
    abrirModal(data)
});

function Guardar() {

    var Usuario = {
        id_usuario: $("#idUsuario").val().trim(),
        pri_nombre: $("#priNombre").val().trim(),
        seg_nombre: $("#segNombre").val().trim(),
        pri_apellido: $("#priApellido").val().trim(),
        seg_apellido: $("#segApellido").val().trim(),
        usuario: $("#usuario").val().trim(),
        correo: $("#correo").val().trim(),
        telefono: $("#telefono").val().trim(),
        fk_rol: $("#obtenerRol").val().trim(),
        estado: $("#estado").prop("checked")
    };

    showLoadingAlert("Procesando", "Guardando datos del usuario...");

    jQuery.ajax({
        url: guardarUsuariosUrl,
        type: "POST",
        data: JSON.stringify({ usuario: Usuario }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",        
        success: function (data) {
            Swal.close();
            $("#createUser").modal("hide");

            // Usuario Nuevo
            if (Usuario.id_usuario == 0) {
                if (data.Resultado != 0) {
                    Usuario.id_usuario = data.Resultado;
                    Usuario.usuario = data.UsuarioGenerado;
                    dataTable.row.add(Usuario).draw();
                    dataTable.ajax.reload(null, false);
                    Swal.fire({ icon: "success", title: "¡Éxito!", html: `Usuario creado correctamente. Usuario generado: <b>${data.UsuarioGenerado}</b>`});
                } else { showAlert("Error", data.Mensaje || "No se pudo crear el usuario", "error") }
            }
            // Actualizar Usuario
            else {
                if (data.Resultado) {
                    dataTable.row(filaSeleccionada).data(Usuario);                    
                    filaSeleccionada = null;
                    showAlert("¡Éxito!", "Usuario actualizado correctamente", "success")
                } else { showAlert("¡Error!", data.Mensaje || "No se pudo actualizar el usuario", "error") }
            }
        },
        error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
    });
}

//Boton eliminar usuario
$("#datatable tbody").on("click", '.btn-eliminar', function () {
    const usuarioseleccionado = $(this).closest("tr");
    const data = dataTable.row(usuarioseleccionado).data();

    confirmarEliminacion().then((result) => {
        if (result.isConfirmed) {
            showLoadingAlert("Eliminando usuario", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: eliminarUsuariosUrl,
                type: "POST",
                data: JSON.stringify({ id_usuario: data.id_usuario }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        dataTable.row(usuarioseleccionado).remove().draw();
                        showAlert("¡Eliminado!", response.Mensaje || "Usuario eliminado correctamente", "success")
                    } else { showAlert("Error", response.Mensaje || "No se pudo eliminar el usuario", "error") }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
});

// Limpiar filtro
function limpiarFiltro(texto) {
    return texto
        .replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ0-9 ]/g, '')
        .replace(/\s+/g, ' ')
}

$("#btnBuscar").click(function () {
    const filtros = {
        usuario: limpiarFiltro($("#filtroUsuario").val().trim()),
        nombres: limpiarFiltro($("#filtroNombres").val().trim()),
        apellidos: limpiarFiltro($("#filtroApellidos").val().trim())
    };

    if (!filtros.usuario && !filtros.nombres && !filtros.apellidos) {
        showAlert("Advertencia", "Debe ingresar al menos un dato en algún filtro.", "warning", true);
        return;
    }

    tablaReinicio.clear().draw();

    $.ajax({
        url: config.buscarUsuariosUrl,
        type: "GET",
        dataType: "json",
        data: filtros,
        beforeSend: () => $("#tablaReinicio tbody").LoadingOverlay("show"),
        success: function (response) {
            if (response && Array.isArray(response.data) && response.data.length > 0) {
                tablaReinicio.rows.add(response.data).draw();
                $("#contadorRegistros").text(response.data.length + " registros encontrados");
            } else {
                showAlert("Advertencia", "No se encontraron resultados", "warning", true);
            }
        },
        complete: () => $("#tablaReinicio tbody").LoadingOverlay("hide"),
        error: () => showAlert("Error", "Error al conectar con el servidor", "error")
    });
});

$("#btnLimpiar").click(function () {
    const usuario = $("#filtroUsuario").val().trim();
    const nombres = $("#filtroNombres").val().trim();
    const apellidos = $("#filtroApellidos").val().trim();

    if (!usuario && !nombres && !apellidos) {
        showAlert("Información", "Los filtros ya están limpios.", "info", true);
        return;
    }

    $("#tablaReinicio tbody").LoadingOverlay("show");
    $("#filtroUsuario, #filtroNombres, #filtroApellidos").val("");
    tablaReinicio.clear().draw();
    $("#contadorRegistros").text("0 registros encontrados");

    setTimeout(function () {
        $("#tablaReinicio tbody").LoadingOverlay("hide");
    }, 1500);
});

const dataTableOptions = {
    ...dataTableConfig,    
    ajax: {
        url: listarUsuariosUrl,
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
        { data: "usuario" },
        {
            data: "fk_rol",
            render: function (data, type, row) {
                return rolesMap[data] || data;
            },
            title: "Rol"
        },
        {
            data: "pri_nombre",
            render: function (data, type, row) {
                return data + ' ' + row.seg_nombre;
            }
        },
        {
            data: "pri_apellido",
            render: function (data, type, row) {
                return data + ' ' + row.seg_apellido;
            }
        },
        { data: "correo" },
        { data: "telefono" },        
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
        },
        {
            data: "estado",
            visible: false,
        }
    ]
};

const tablaReinicioOptions = {
    ...dataTableConfig,
    columns: [
        {
            data: null,
            render: function (data, type, row, meta) {
                return meta.row + 1;
            },
            title: "#",
            width: "50px",
            orderable: false
        },
        { data: "usuario" },
        {
            data: "fk_rol",
            render: function (data) {
                return rolesMap[data] || data;
            }
        },
        {
            data: null,
            render: function (data) {
                return (data.pri_nombre || '') + ' ' + (data.seg_nombre || '');
            }
        },
        {
            data: null,
            render: function (data) {
                return (data.pri_apellido || '') + ' ' + (data.seg_apellido || '');
            }
        },
        { data: "correo" },
        { data: "telefono" },
        {
            data: "estado",
            render: function (valor) {
                return valor
                    ? "<div class='d-flex justify-content-center align-items-center'><span class='badge text-bg-success'>ACTIVO</span></div>"
                    : "<div class='d-flex justify-content-center align-items-center'><span class='badge text-bg-danger'>NO ACTIVO</span></div>";
            }
        },
        {
            data: "id_usuario",
            render: function (data) {
                return `<div class="d-flex justify-content-center">
                    <button type="button" class="btn btn-danger btn-sm btn-reinicar" title="Reiniciar contraseña">
                        <i class="fa fa-redo"></i>
                    </button>
                </div>`;
            },
            orderable: false,
            width: "100px"
        }
    ],
};

$(document).ready(function () {
    dataTable = $("#datatable").DataTable(dataTableOptions);
    tablaReinicio = $("#tablaReinicio").DataTable(tablaReinicioOptions);
});























//Boton reiniciar contraseña usuario
$("#tablaReinicio tbody").on("click", '.btn-reinicar', function () {
    const usuarioseleccionado = $(this).closest("tr");
    const data = tablaReinicio.row(usuarioseleccionado).data();
    console.log(data)
    confirmarEliminacion().then((result) => {
        if (result.isConfirmed) {
            showLoadingAlert("Reiniciando contraseña", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: config.restablecerContrasenaUrl,
                type: "POST",
                data: JSON.stringify({ idUsuario: data.id_usuario }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        showAlert("¡Reinicio!", response.Mensaje || "Usuario reiniciado correctamente", "success", false, true);
                        $("#filtroUsuario, #filtroNombres, #filtroApellidos").val("");
                        tablaReinicio.clear().draw();
                        $("#contadorRegistros").text("0 registros encontrados");
                    } else {
                        showAlert("Error", response.Mensaje || "No se pudo reiniciar la contraseña del usuario", "error");
                    }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
});
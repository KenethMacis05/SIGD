let dataTable;
var filaSeleccionada;
var modalidadesCache = [];

function inicializarSelect2Modalidad() {
    $('#inputGroupSelectModalidad').select2({
        placeholder: "Buscar ...",
        allowClear: true,
        dropdownParent: $('#Guardar'),
        language: {
            noResults: function () {
                return "No se encontraron resultados";
            }
        }
    });
}

function cargarModalidades(selectedId) {
    var modalidadActual = $("#fk_modalidad_activa").val();

    if (modalidadesCache.length > 0) {
        llenarSelectModalidades(modalidadesCache, selectedId || modalidadActual);
        return;
    }

    $.ajax({
        url: "/Catalogos/ListarModalidad",
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (response) {
            modalidadesCache = response && response.data ? response.data : [];
            llenarSelectModalidades(modalidadesCache, selectedId || modalidadActual);
        },
        error: function (xhr) {
            showAlert("Error", `No se pudieron cargar las modalidades: ${xhr.statusText}`, "error");
            llenarSelectModalidades([], selectedId || modalidadActual);
        }
    });
}

function llenarSelectModalidades(list, selectedId) {
    var $select = $("#inputGroupSelectModalidad");
    $select.empty();
    $select.append('<option value="">Seleccione una modalidad...</option>');
    list.forEach(function (m) {
        var option = $('<option>').val(m.id_modalidad).text(m.nombre);
        $select.append(option);
    });

    if (selectedId && selectedId !== '0' && selectedId !== '') {
        $select.val(selectedId).trigger('change');
    } else {
        $select.val('').trigger('change');
    }
}

// Buscar objeto Modalidad por id en la cache
function obtenerModalidadEnCache(id) {
    if (!id) return null;
    return modalidadesCache.find(function (m) {
        return parseInt(m.id_modalidad) === parseInt(id);
    }) || null;
}

// Abrir modal para crear/editar turno
function abrirModal(json) {
    $("#idTurno").val("0");
    $("#nombre").val("");
    $("#estado").prop("checked", true);
    $("#inputGroupSelectModalidad").val("").trigger('change');

    var preselectModalidad = null;
    if (json !== null) {
        $("#idTurno").val(json.id_turno);
        $("#nombre").val(json.nombre);
        $("#estado").prop("checked", json.estado === true);

        if (json.fk_modalidad && json.fk_modalidad > 0) preselectModalidad = json.fk_modalidad;
        else if (json.Modalidad && json.Modalidad.id_modalidad) preselectModalidad = json.Modalidad.id_modalidad;
    }

    cargarModalidades(preselectModalidad);

    $("#Guardar").modal("show");
}

// Seleccionar turno para editar
$("#datatable tbody").on("click", '.btn-editar', function () {
    filaSeleccionada = $(this).closest("tr");
    var data = dataTable.row(filaSeleccionada).data();
    abrirModal(data);
});

// Crear o editar Turno
function Guardar() {
    var turno = {
        id_turno: parseInt($("#idTurno").val().trim()) || 0,
        nombre: $("#nombre").val().trim(),
        fk_modalidad: parseInt($("#inputGroupSelectModalidad").val()) || 0,
        estado: $("#estado").prop("checked")
    };

    // Validaciones básicas
    if (!turno.nombre) {
        showAlert("Advertencia", "Ingrese el nombre del turno.", "warning");
        return;
    }
    if (!turno.fk_modalidad || turno.fk_modalidad === 0) {
        showAlert("Advertencia", "Seleccione una modalidad válida.", "warning");
        return;
    }

    showLoadingAlert("Procesando", "Guardando datos del turno...");

    jQuery.ajax({
        url: "/Catalogos/GuardarTurno",
        type: "POST",
        data: JSON.stringify({ turno: turno }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            Swal.close();
            $("#Guardar").modal("hide");

            // Obtener objeto modalidad desde cache para mostrar nombre en tabla
            var modalObj = obtenerModalidadEnCache(turno.fk_modalidad);
            turno.Modalidad = modalObj ? modalObj : { id_modalidad: turno.fk_modalidad, nombre: `Modalidad (${turno.fk_modalidad})` };

            // Turno Nuevo
            if (turno.id_turno === 0) {
                if (data.Resultado != 0) {
                    turno.id_turno = data.Resultado;
                    dataTable.row.add(turno).draw(false);
                    showAlert("¡Éxito!", "Turno creado correctamente", "success");
                } else {
                    showAlert("Error", data.Mensaje || "Error al crear el turno", "error");
                }
            }
            // Actualizar turno
            else {
                if (data.Resultado == 1 || data.Resultado === true) {
                    dataTable.row(filaSeleccionada).data(turno).draw(false);
                    filaSeleccionada = null;
                    showAlert("¡Éxito!", "Turno actualizado correctamente", "success");
                } else {
                    showAlert("Error", data.Mensaje || "Error al actualizar el turno", "error");
                }
            }
        },
        error: function (xhr) {
            showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
        }
    });
}

// Botón eliminar Turno
$("#datatable tbody").on("click", '.btn-eliminar', function () {
    const fila = $(this).closest("tr");
    const data = dataTable.row(fila).data();

    confirmarEliminacion().then(function (result) {
        if (result.isConfirmed) {
            showLoadingAlert("Eliminando turno", "Por favor espere...");

            $.ajax({
                url: "/Catalogos/EliminarTurno",
                type: "POST",
                data: JSON.stringify({ IdTurno: data.id_turno }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        dataTable.row(fila).remove().draw();
                        showAlert("¡Eliminado!", response.Mensaje || "Turno eliminado correctamente", "success");
                    } else {
                        showAlert("Error", response.Mensaje || "No se pudo eliminar el turno", "error");
                    }
                },
                error: function (xhr) {
                    showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
                }
            });
        }
    });
});

const dataTableOptions = {
    ...dataTableConfig,

    ajax: {
        url: "/Catalogos/ListarTurnos",
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
            orderable: false, width: "30"
        },
        { data: "nombre" },
        {
            data: null,
            render: function (row) {
                if (row.Modalidad && row.Modalidad.nombre) return row.Modalidad.nombre;
                if (row.fk_modalidad) {
                    var m = obtenerModalidadEnCache(row.fk_modalidad);
                    if (m) return m.nombre;
                    return `Modalidad (${row.fk_modalidad})`;
                }
                return "-";
            },
            width: "200"
        },
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

    initComplete: function () {
        if (modalidadesCache.length === 0) {
            cargarModalidades();
        }
    }
};

$(document).ready(function () {
    dataTable = $("#datatable").DataTable(dataTableOptions);
    inicializarSelect2Modalidad();
    cargarModalidades();
});
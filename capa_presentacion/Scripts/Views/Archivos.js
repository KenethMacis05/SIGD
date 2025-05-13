const guardarCarpetaUrl = config.guardarCarpetaUrl;
const eliminarCarpetaUrl = config.eliminarCarpetaUrl;
const compartirCarpetaUrl = config.compartirCarpetaUrl;
const subirArchivoUrl = config.subirArchivoUrl;
let breadcrumbStack = [];
let carpetaActualId = null;

// Agregar una nueva entrada al breadcrumbStack
function agregarBreadcrumb(nombreCarpeta, idCarpeta) {        
    breadcrumbStack.push({ nombre: nombreCarpeta, id: idCarpeta });
    actualizarBreadcrumbHTML();
}

// Actualizar el HTML del breadcrumb usando el contenido del breadcrumbStack
function actualizarBreadcrumbHTML() {
    let html = `
        <li class="breadcrumb-item">
            <a href="#" onclick="navegarAInicio()" class="text-primary fw-bold">
                <i class="fas fa-home me-2"></i>Inicio
            </a>
        </li>
    `;

    breadcrumbStack.forEach((carpeta, index) => {
        if (index === breadcrumbStack.length - 1) {
            html += `
            <li class="breadcrumb-item active">${carpeta.nombre}</li>`;
        } else {
            html += `
                <li class="breadcrumb-item fw-bold">
                    <a href="#" onclick="retroceder(${index})">${carpeta.nombre}</a>
                </li>
            `;
        }
    });
    document.getElementById("breadcrumb-paginador").innerHTML = html;
}

// Retroceder a una carpeta anterior
function retroceder(index) {
    breadcrumbStack = breadcrumbStack.slice(0, index + 1);

    const carpetaSeleccionada = breadcrumbStack[index];

    actualizarBreadcrumbHTML();
    cargarSubCarpetas(carpetaSeleccionada.id, "contenedor-carpetas-recientes");
    cargarSubCarpetas(carpetaSeleccionada.id, "contenedor-carpetas-todos");
}

// Navegar al inicio del paginador
function navegarAInicio() {   
    breadcrumbStack = [];

    document.getElementById("breadcrumb-paginador").innerHTML = `
    <li class="breadcrumb-item">
        <a href="#" onclick="navegarAInicio()" class="text-primary fw-bold">
            <i class="fas fa-home me-2"></i>Inicio
        </a>
    </li>
    `;

    cargarCarpetas(config.listarCarpetasRecientesUrl, "contenedor-carpetas-recientes");
    cargarCarpetas(config.listarCarpetasUrl, "contenedor-carpetas-todo");
}

// Navegar a las sub carpetas
$(document).on('click', '.file-manager-group-title', function (e) {
    e.preventDefault();

    const idCarpetaPadre = $(this).data('carpetapadre-id');
    const contenedorId = $(this).closest('.row').attr('id');
    const nombreCarpeta = $(this).text().trim();
   
    agregarBreadcrumb(nombreCarpeta, idCarpetaPadre);

    carpetaActualId = idCarpetaPadre;
    cargarSubCarpetas(idCarpetaPadre, contenedorId);
});

// Abrir el modal para crear o editar una carpeta
function abrirModalCarpeta(json) {
    $("#idCarpeta").val("0");
    $("#nombre").val("");
    $("#idCarpetaPadre").val(carpetaActualId || "0");

    if (json !== null) {
        $("#idCarpeta").val(json.id_carpeta);
        $("#nombre").val(json.nombre);
        $("#idCarpetaPadre").val(json.id_carpeta);
    }

    $("#createCarpeta").modal("show");
}

// Seleccionar los datos de la carpeta para editar
$(document).on('click', '.btn-editar', function (e) {
    e.preventDefault();
    const data = {
        id_carpeta: $(this).data('carpeta-id'),
        nombre: $(this).data('carpeta-nombre')
    };
    abrirModalCarpeta(data);
});

// Crear una sub carpeta
$(document).on('click', '.btn-crearSubCarpeta', function (e) {
    e.preventDefault();

    const idCarpetaPadre = $(this).data('carpetapadre-id');
    $('#idCarpetaPadre').val(idCarpetaPadre);
    $('#createCarpeta').modal('show');
});

// Abrir el modal para subir un archivo
function abrirModalSubirArchivo(json) {
    $("#idCarpeta2").val("0");
    $("#file").val("");

    if (json !== null) {
        $("#idCarpeta2").val(json.id_carpeta);        
    }
    $("#subirArchivo").modal("show");
}

// Seleccionar los datos de la carpeta para subir un archivo
$(document).on('click', '.btn-subirArchivo', function (e) {
    e.preventDefault();
    const data = {
        id_carpeta: $(this).data('carpeta-id'),        
    };
    abrirModalSubirArchivo(data);
});

// Guardar carpeta (crear o actualizar)
function GuardarCarpeta() {

    var Carpeta = {
        id_carpeta: $("#idCarpeta").val(),
        nombre: $("#nombre").val(),
        carpeta_padre: $("#idCarpetaPadre").val() || null
    };

    if (!Carpeta.nombre) {
        Swal.fire("Campo obligatorio", "El nombre de la carpeta no puede estar vacío", "warning");
        return;
    }

    // Validar que el nombre no contenga caracteres especiales
    const regex = /^[a-zA-Z0-9_ ]*$/;
    if (!regex.test(Carpeta.nombre)) {
        Swal.fire("Nombre inválido", "El nombre de la carpeta no puede contener caracteres especiales", "warning");
        return;
    }    

    showLoadingAlert("Procesando", "Guardando datos la carpeta...");

    jQuery.ajax({
        url: guardarCarpetaUrl,
        type: "POST",
        data: JSON.stringify(Carpeta),
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            Swal.close();
            $("#createCarpeta").modal("hide");

            if (data.Resultado || data.Respuesta) {
                const mensaje = data.Mensaje || (Carpeta.id_carpeta == 0 ? "Carpeta creada correctamente" : "Carpeta actualizada correctamente");
                showAlert("¡Éxito!", mensaje, "success", true);
                cargarTodo();
                $("#nombre").val("");

            }
            else {
                const mensaje = data.Mensaje || (Carpeta.id_carpeta == 0 ? "No se pudo crear la carpeta" : "No se pudo actualizar la carpeta");
                showAlert("Error", mensaje, "error", true);
            }
        },
        error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
    });
}

// Subir archivo
function SubirArchivo() {
    var ArchivoSelecionado = $("#file")[0].files[0];
    var Carpeta = {
        id_carpeta: $("#idCarpeta2").val() || null,
    };

    // Validar que se haya seleccionado un archivo
    if (!ArchivoSelecionado) {
        Swal.fire("Campo obligatorio", "No ingresó ningún archivo para subir", "warning");
        return;
    }

    // Validar tamaño del archivo (10 MB como máximo)
    if (ArchivoSelecionado.size > 10 * 1024 * 1024) {
        Swal.fire("Archivo demasiado grande", "El archivo no debe superar los 10 MB", "error");
        return;
    }

    // Validar tipo de archivo permitido
    const tiposPermitidos = ["image/jpeg", "image/png", "application/pdf"];
    if (!tiposPermitidos.includes(ArchivoSelecionado.type)) {
        Swal.fire("Tipo de archivo no permitido", "Solo se permiten imágenes y PDFs", "error");
        return;
    }

    // Preparar el objeto FormData
    var request = new FormData();
    request.append("CARPETAJSON", JSON.stringify(Carpeta));
    request.append("ARCHIVO", ArchivoSelecionado);

    showLoadingAlert("Procesando", "Subiendo archivo...");

    jQuery.ajax({
        url: config.subirArchivoUrl,
        type: "POST",
        data: request,
        processData: false,
        contentType: false,
        success: function (data) {
            Swal.close();
            $("#subirArchivo").modal("hide");

            if (data.Respuesta) {
                Swal.fire("Éxito", data.Mensaje, "success");                
                cargarTodo();
            } else {
                Swal.fire("Error", data.Mensaje, "error");
            }
        },
        error: (xhr) => {
            Swal.fire("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
        }
    });
}

// Eliminar carpeta
$(document).on('click', '.btn-eliminar', function (e) {
    e.preventDefault();
    const idCarpeta = $(this).data('carpeta-id');

    confirmarEliminacion().then((result) => {

        if (result.isConfirmed) {
            showLoadingAlert("Eliminando carpeta", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: eliminarCarpetaUrl,
                type: "POST",
                data: JSON.stringify({ id_carpeta: idCarpeta }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        showAlert("¡Eliminado!", response.Mensaje || "Carpeta eliminada correctamente", "success", true);                        
                        cargarTodo();                       
                    } else { showAlert("Error", response.Mensaje || "No se pudo eliminar la carpeta", "error"); }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
});

// Eliminar archivo
$(document).on('click', '.btn-eliminarArchivo', function (e) {
    e.preventDefault();
    const idArchivo = $(this).data('archivo-id');

    confirmarEliminacion().then((result) => {

        if (result.isConfirmed) {
            showLoadingAlert("Eliminando archivo", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: config.eliminarArchivoUrl,
                type: "POST",
                data: JSON.stringify({ id_archivo: idArchivo }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        showAlert("¡Eliminado!", response.Mensaje || "Archivo eliminado correctamente", "success", true);                        
                        cargarTodo();
                    } else { showAlert("Error", response.Mensaje || "No se pudo eliminar el archivo", "error"); }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
});

// Vaciar papelera
function vaciarPapelera() {
    confirmarEliminacion().then((result) => {

        if (result.isConfirmed) {
            showLoadingAlert("Vaciando papelera", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: config.vaciarPapeleraUrl,
                type: "POST",                
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        showAlert("¡Éxito!", response.Mensaje || "La papelera fue vaciada correctamente", "success", true);
                        cargarTodo();
                    } else { showAlert("Error", response.Mensaje || "No se pudo vaciar la papelera", "error"); }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
}

// Función para cargar carpetas o subcarpetas
function cargarCarpetasGenerico(url, contenedorId, idCarpeta = null) {
    $.ajax({
        url: url,
        type: idCarpeta ? 'POST' : 'GET',
        data: idCarpeta ? { idCarpeta: idCarpeta } : null,
        beforeSend: () => $(`#${contenedorId}`).LoadingOverlay("show"),
        success: function (response) {
            if (response.data && response.data.length > 0) {
                let html = '';

                // Generar el HTML para cada carpeta
                $.each(response.data, function (index, carpeta) {
                    html += generarHtmlCarpeta(carpeta, index);
                });

                $(`#${contenedorId}`).html(html);
            } else {
                $(`#${contenedorId}`).html(`
                    <div class="alert alert-light">
                        No hay carpetas disponibles
                            <img src="/Assets/img/carpeta_vacia.png" alt="No hay archivos" style="max-width: 150px; display: block; margin: 10px auto;" />
                    </div>
                `);
            }
        },
        error: function () {
            $(`#${contenedorId}`).html('<div class="alert alert-danger">Error al cargar las carpetas</div>');
        },
        complete: () => $(`#${contenedorId}`).LoadingOverlay("hide")
    });
}

// Función para cargar carpetas (nivel superior)
function cargarCarpetas(url, contenedorId) {
    cargarCarpetasGenerico(url, contenedorId);
}

// Función para cargar subcarpetas
function cargarSubCarpetas(idCarpeta, contenedorId) {
    cargarCarpetasGenerico(config.listarSubCarpetasUrl, contenedorId, idCarpeta);
}

function cargarArchivos(url, contenedorId) {
    $.ajax({
        url: url,
        type: 'GET',
        dataType: 'json',
        beforeSend: () => $(`#${contenedorId}`).LoadingOverlay("show"),
        success: function (response) {
            if (response.data && response.data.length > 0) {
                let html = '';
                $.each(response.data, function (index, archivo) {
                    const html = response.data.map(generarHtmlArchivo).join("");
                    $(`#${contenedorId}`).html(html);                
                });

            } else {                
                $(`#${contenedorId}`).html('<div class="alert alert-light">No hay archivos disponibles</div>');
            }
        },
        error: function () {
            $(`#${contenedorId}`).html('<div class="alert alert-danger">Error al cargar las archivos</div>');            
        },
        complete: () => $(`#${contenedorId}`).LoadingOverlay("hide")
    });
}

// Efectos hover para carpetas
$(document).on('mouseenter', '.file-manager-group', function () {
    $(this).find('.fa-folder').addClass('d-none');
    $(this).find('.fa-folder-open').removeClass('d-none');
}).on('mouseleave', '.file-manager-group', function () {
    $(this).find('.fa-folder-open').addClass('d-none');
    $(this).find('.fa-folder').removeClass('d-none');
});

// Efectos hover para archivos
$(document).on('mouseenter', '.file-manager-recent-item', function () {
    $(this).find('.fa-file').addClass('d-none');
    $(this).find('.fa-file-alt').removeClass('d-none');
}).on('mouseleave', '.file-manager-recent-item', function () {
    $(this).find('.fa-file-alt').addClass('d-none');
    $(this).find('.fa-file').removeClass('d-none');
});

function cargarTodo() {
    // Cargar carpetas
    cargarCarpetas(config.listarCarpetasRecientesUrl, "contenedor-carpetas-recientes");
    cargarCarpetas(config.listarCarpetasUrl, "contenedor-carpetas-todos");    
    
    // Cargar archivos
    cargarArchivos(config.listarArchivosRecientesUrl, "contenedor-archivos-recientes");
    cargarArchivos(config.listarArchivosUrl, "contenedor-archivos-todos");

    // Recargar tabla de archivos eliminados
    $('#datatableArchivoEliminados').DataTable().ajax.reload(null, false);    

    actualizarBreadcrumbHTML();

}

function handleTabClick(activeTabId) {
    if (activeTabId === "home") {
        // Cargar carpetas recientes
        cargarCarpetas(config.listarCarpetasRecientesUrl, "contenedor-carpetas-recientes");
        cargarArchivos(config.listarArchivosRecientesUrl, "contenedor-archivos-recientes");        
    } else if (activeTabId === "archivos") {
        // Cargar todas las carpetas
        cargarCarpetas(config.listarCarpetasUrl, "contenedor-carpetas-todos");
        cargarArchivos(config.listarArchivosUrl, "contenedor-archivos-todos");        
    }
}

let dataTable;

const dataTableOptions = {
    ...dataTableConfig,

    ajax: {
        url: config.listarPapeleraUrl,
        type: "GET",
        dataType: "json",
        dataSrc: function (json) {
            const archivos = json.data.archivos.map(item => ({ ...item, tipoRegistro: "Archivo" }));
            const carpetas = json.data.carpetas.map(item => ({ ...item, tipoRegistro: "Carpeta" }));

            // Combinar y ordenar por fecha de eliminación (timestamp)
            const combinados = archivos.concat(carpetas).sort((a, b) => {
                const getTimestamp = (dateStr) => {
                    const match = dateStr.match(/\/Date\((\d+)\)\//);
                    return match ? parseInt(match[1], 10) : 0;
                };
                const timestampA = getTimestamp(a.fecha_eliminacion);
                const timestampB = getTimestamp(b.fecha_eliminacion);
                return timestampB - timestampA;
            });

            return combinados;
        }
    },

    columns: [
        {
            data: "nombre", title: "Nombre",
            render: function (data, type, row) {
                if (row.tipoRegistro === "Carpeta") {
                    // Si es una carpeta, mostrar el ícono de carpeta
                    return `<i class="fa fa-folder fa-2x text-warning"></i> ${data}`;
                } else if (row.tipoRegistro === "Archivo") {
                    // Si es un archivo, obtener la extensión del nombre
                    const extension = `.${data.split('.').pop().toLowerCase()}`;
                    const { icono, color } = obtenerIconoYColor(extension);

                    return `<i class="fa ${icono} ${color} fa-2x"></i> ${data}`;
                } else {
                    return data;
                }
            }
        },
        {
            data: "tipoRegistro",
            title: "Tipo",
            visible: false
        },
        {
            data: "fecha_eliminacion",
            title: "Fecha de Eliminación",
            render: function (data) {
                return data ? formatASPNetDate(data) : "N/A";
            }
        },
        {
            defaultContent:
                '<button type="button" class="btn btn-primary btn-sm btn-restablecer"><i class="fa fa-upload"></i></button>' +
                '<button type="button" class="btn btn-danger btn-sm ms-2 btn-eliminarDifinitivamente"><i class="fa fa-trash"></i></button>',
            title: "Acciones",
            width: "120"
        }
    ],

    rowCallback: function (row, data) {
        if (data.tipo === "Carpeta") {
            $(row).addClass("table-warning");
        }
    }
};

// Filtro por Tipo
$("#inputGroupSelectTipo").on("change", function () {
    const tipoSelecionado = $(this).val();

    if (tipoSelecionado === "Todos") {        
        dataTable.column(1).search('').draw();
    } else {        
        dataTable.column(1).search(tipoSelecionado).draw();
    }
});

// Inicialización
$(document).ready(function () {
    cargarCarpetas(config.listarCarpetasRecientesUrl, "contenedor-carpetas-recientes");
    cargarArchivos(config.listarArchivosRecientesUrl, "contenedor-archivos-recientes");
    dataTable = $("#datatableArchivoEliminados").DataTable(dataTableOptions);
});

//Boton eliminar difinitivamente un archivo o carpeta
$("#datatableArchivoEliminados tbody").on("click", '.btn-eliminarDifinitivamente', function () {
    const archivoleccionado = $(this).closest("tr");
    const data = dataTable.row(archivoleccionado).data();        

    if (data.tipoRegistro === "Carpeta") {
        id_eliminar = data.id_carpeta;
    } else {
        id_eliminar = data.id_archivo;     
    }


    if (!data || (!data.id_archivo && !data.id_carpeta)) {
        showAlert("Error", "No se pudo determinar el archivo o carpeta a eliminar.", "error");
        return;
    }

    confirmarEliminacion().then((result) => {
        if (result.isConfirmed) {
            showLoadingAlert("Eliminando archivo o carpeta", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: config.eliminarDefinitivamenteUrl,
                type: "POST",
                data: JSON.stringify({
                    id_eliminar: id_eliminar,
                    tipo_registro: data.tipoRegistro
                }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        dataTable.row(archivoleccionado).remove().draw();
                        $('#datatableArchivoEliminados').DataTable().ajax.reload(null, false);
                        showAlert("¡Eliminado!", response.Mensaje || " eliminado correctamente", "success")
                    } else {
                        showAlert("Error", response.Mensaje || "No se pudo eliminar el registro", "error");
                    }
                },
                error: (xhr) => {
                    showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
                }
            });
        }
    });
});























// EN DESAROLLO
$('#miDataTable').on('click', '.btn-restablecer', function () {
    const data = $('#miDataTable').DataTable().row($(this).parents('tr')).data();
    if (data.tipo === "Archivo") {
        // Llamar a un método para restablecer archivos
        restablecerArchivo(data.id_archivo);
    } else if (data.tipo === "Carpeta") {
        // Llamar a un método para restablecer carpetas
        restablecerCarpeta(data.id_carpeta);
    }
});

function restablecerArchivo(idArchivo) {
    $.ajax({
        url: '/Archivo/RestablecerArchivo',
        type: 'POST',
        data: { id: idArchivo },
        success: function (response) {
            if (response.resultado === 1) {
                alert('Archivo restablecido correctamente.');
                $('#miDataTable').DataTable().ajax.reload();
            } else {
                alert(response.mensaje);
            }
        }
    });
}

function restablecerCarpeta(idCarpeta) {
    $.ajax({
        url: '/Carpeta/RestablecerCarpeta',
        type: 'POST',
        data: { id: idCarpeta },
        success: function (response) {
            if (response.resultado === 1) {
                alert('Carpeta restablecida correctamente.');
                $('#miDataTable').DataTable().ajax.reload();
            } else {
                alert(response.mensaje);
            }
        }
    });
}

function eliminarArchivo(idArchivo) {
    $.ajax({
        url: '/Archivo/EliminarArchivo',
        type: 'POST',
        data: { id: idArchivo },
        success: function (response) {
            if (response.resultado === 1) {
                alert('Archivo eliminado definitivamente.');
                $('#miDataTable').DataTable().ajax.reload();
            } else {
                alert(response.mensaje);
            }
        }
    });
}

function eliminarCarpeta(idCarpeta) {
    $.ajax({
        url: '/Carpeta/EliminarCarpeta',
        type: 'POST',
        data: { id: idCarpeta },
        success: function (response) {
            if (response.resultado === 1) {
                alert('Carpeta eliminada definitivamente.');
                $('#miDataTable').DataTable().ajax.reload();
            } else {
                alert(response.mensaje);
            }
        }
    });
}




























// Compartir carpeta
$(document).on('click', '.btn-compartir', function (e) {
    e.preventDefault();
    const idCarpeta = $(this).data('carpeta-id');
    console.log(idCarpeta);
    $('#modalCompartir').modal('show');
});
// Función para compartir carpeta
function compartirCarpeta() {
    const idCarpeta = $('#idCarpetaCompartir').val();
    const correo = $('#correoCompartir').val();
    const permisos = $('#permisosCompartir').val();

    Swal.fire({
        title: "Compartiendo",
        html: "Procesando solicitud...",
        allowOutsideClick: false,
        didOpen: () => Swal.showLoading()
    });

    $.ajax({
        url: config.compartirCarpetaUrl,
        type: "POST",
        data: JSON.stringify({
            id_carpeta: idCarpeta,
            correo: correo,
            permisos: permisos
        }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            Swal.close();
            if (data.Respuesta) {
                Swal.fire({
                    ...swalConfig,
                    title: "¡Éxito!",
                    text: data.Mensaje || "Carpeta compartida",
                    icon: "success"
                });
                $('#modalCompartir').modal('hide');
                $('#correoCompartir').val('');
            } else {
                Swal.fire({
                    ...swalConfig,
                    title: "Error",
                    text: data.Mensaje || "Error al compartir",
                    icon: "error"
                });
            }
        },
        error: function () {
            Swal.fire({
                ...swalConfig,
                title: "Error",
                text: "Error en el servidor",
                icon: "error"
            });
        }
    });
}

// Descargar carpeta
$(document).on('click', '.btn-descargar', function (e) {
    e.preventDefault();
    const idCarpeta = $(this).data('carpeta-id');
    console.log(idCarpeta);
    // Lógica para descargar (puedes hacer una redirección o AJAX)
    /*window.location.href = '@Url.Action("DescargarCarpeta", "Archivo")' + '?id=' + idCarpeta;*/
});


// Funciones para los modales
function compartirCarpeta() {
    const correo = $('#correoCompartir').val();
    const permisos = $('#permisosCompartir').val();

    // Aquí tu lógica AJAX para compartir
    console.log('Compartir con:', correo, 'Permisos:', permisos);
    $('#modalCompartir').modal('hide');
}
const guardarCarpetaUrl = config.guardarCarpetaUrl;
const eliminarCarpetaUrl = config.eliminarCarpetaUrl;
const compartirCarpetaUrl = config.compartirCarpetaUrl;
const subirArchivoUrl = config.subirArchivoUrl;

function abrirModalCarpeta(json) {
    $("#idCarpeta").val("0");
    $("#nombre").val("");
    $("#idCarpetaPadre").val("0");

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

$(document).on('click', '.btn-crearSubCarpeta', function (e) {
    e.preventDefault();

    const idCarpetaPadre = $(this).data('carpetapadre-id');
    $('#idCarpetaPadre').val(idCarpetaPadre);
    $('#createCarpeta').modal('show');
});


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
                showAlert("¡Éxito!", mensaje, "success");
                cargarCarpetas(config.listarCarpetasRecientesUrl, "contenedor-carpetas-recientes");
                cargarCarpetas(config.listarCarpetasUrl, "contenedor-carpetas-todos");
                $("#nombre").val("");

            }
            else {
                const mensaje = data.Mensaje || (Carpeta.id_carpeta == 0 ? "No se pudo crear la carpeta" : "No se pudo actualizar la carpeta");
                showAlert("Error", mensaje, "error");
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
                cargarArchivos()
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
                        cargarCarpetas(config.listarCarpetasRecientesUrl, "contenedor-carpetas-recientes");                    
                        cargarCarpetas(config.listarCarpetasUrl, "contenedor-carpetas-todos");
                    } else { showAlert("Error", response.Mensaje || "No se pudo eliminar la carpeta", "error"); }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
});

// Función para cargar las carpetas
function cargarCarpetas(url, contenedorId) {
    $.ajax({
        url: url,
        type: 'GET',
        dataType: 'json',
        beforeSend: () => $(`#${contenedorId}`).LoadingOverlay("show"),
        success: function (response) {
            if (response.data && response.data.length > 0) {
                let html = '';
                const colors = ['primary', 'warning', 'danger', 'success', 'info', 'secondary'];

                $.each(response.data, function (index, carpeta) {
                    const color = colors[index % colors.length];
                    html += `
                    <div class="col-sm-6 col-md-4 col-lg-3">
                        <div class="card file-manager-group h-100 shadow-sm">
                            <div class="card-body d-flex align-items-center">
                                <i class="fas fa-folder-open fa-2x text-${color} me-3 d-none"></i>
                                <i class="fas fa-folder fa-2x text-${color} me-3"></i>
                                <div class="file-manager-group-info flex-fill">
                                    <a href="#" class="file-manager-group-title h5 d-block text-decoration-none text-dark">${carpeta.nombre}</a>
                                    <span class="file-manager-group-about text-muted small">${formatASPNetDate(carpeta.fecha_registro)}</span>
                                </div>
                                <div class="ms-auto">
                                    <a href="#" class="dropdown-toggle file-manager-recent-file-actions" 
                                        data-bs-toggle="dropdown" data-carpeta-id="${carpeta.id_carpeta}">
                                        <i class="fas fa-ellipsis-v"></i>
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li>
                                            <a class="dropdown-item btn-crearSubCarpeta" href="#"
                                            data-carpetaPadre-id="${carpeta.id_carpeta}">
                                            <i class="fas fa-plus me-2"></i>Crear carpeta</a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item btn-subirArchivo" href="#"
                                            data-carpeta-id="${carpeta.id_carpeta}" 
                                            data-carpeta-nombre="${carpeta.nombre}">
                                            <i class="fas fa-file me-2"></i>Subir Archivo</a>
                                        </li>
                                        <li><a class="dropdown-item btn-compartir" href="#" 
                                            data-carpeta-id="${carpeta.id_carpeta}">
                                            <i class="fas fa-share me-2"></i>Compartir</a></li>
                                        <li><a class="dropdown-item btn-descargar" href="#" 
                                            data-carpeta-id="${carpeta.id_carpeta}">
                                            <i class="fas fa-download me-2"></i>Descargar</a></li>
                                        <li>
                                            <a class="dropdown-item btn-editar" href="#" 
                                            data-carpeta-id="${carpeta.id_carpeta}" 
                                            data-carpeta-nombre="${carpeta.nombre}">
                                            <i class="fas fa-edit me-2"></i>Renombrar</a>
                                        </li>
                                        <li><a class="dropdown-item btn-eliminar" href="#" 
                                            data-carpeta-id="${carpeta.id_carpeta}">
                                            <i class="fas fa-trash me-2"></i>Eliminar</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>`;
                });

                $(`#${contenedorId}`).html(html);
            } else {
                $(`#${contenedorId}`).html('<div class="alert alert-light">No hay carpetas disponibles</div>');
            }
        },
        error: function () {
            $(`#${contenedorId}`).html('<div class="alert alert-danger">Error al cargar las carpetas</div>');
        },
        complete: () => $(`#${contenedorId}`).LoadingOverlay("hide")
    });
}

function cargarArchivos(url, contenedorId) {
    $.ajax({
        url: url,
        type: 'GET',
        dataType: 'json',
        beforeSend: () => $(`#${contenedorId}`).LoadingOverlay("show"),
        success: function (response) {
            console.log(response.data)
            if (response.data && response.data.length > 0) {
                let html = '';
                $.each(response.data, function (index, archivo) {
                    const { icono, color } = obtenerIconoYColor(archivo.tipo);

                    html += `
                    <div class="col-sm-12 col-md-12 col-lg-6">
                        <div class="card file-manager-recent-item h-100 shadow-sm">
                            <div class="card-body">
                                <div class="d-flex align-items-center gap-3">
                                    <i class="fas ${icono} fa-lg ${color} fa-2x"></i>
                                    <div class="flex-fill">                                        
                                        <a href="#" class="file-manager-recent-item-title h5 text-decoration-none text-dark d-block">${archivo.nombre}</a>
                                        <small class="text-muted">${archivo.size}kb - ${formatASPNetDate(archivo.fecha_subida)}</small>
                                    </div>
                                    <div class="dropdown">
                                        <a href="#" class="dropdown-toggle file-manager-recent-file-actions text-dark" data-bs-toggle="dropdown">
                                            <i class="fas fa-ellipsis-v"></i>
                                        </a>
                                        <ul class="dropdown-menu dropdown-menu-end">
                                            <li><a class="dropdown-item" href="#"><i class="fas fa-share me-2"></i>Compartir</a></li>
                                            <li><a class="dropdown-item" href="#"><i class="fas fa-download me-2"></i>Descargar</a></li>
                                            <li><a class="dropdown-item" href="#"><i class="fas fa-folder me-2"></i>Mover</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>`;
                });

                $(`#${contenedorId}`).html(html);
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
    $(this).find('.fa-file-alt').removeClass('d-none'); // Cambia al ícono alternativo (hover)
}).on('mouseleave', '.file-manager-recent-item', function () {
    $(this).find('.fa-file-alt').addClass('d-none');
    $(this).find('.fa-file').removeClass('d-none'); // Vuelve al ícono original
});

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

// Inicialización
$(document).ready(function () {
    cargarCarpetas(config.listarCarpetasRecientesUrl, "contenedor-carpetas-recientes");
    cargarArchivos(config.listarArchivosRecientesUrl, "contenedor-archivos-recientes");
});

































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
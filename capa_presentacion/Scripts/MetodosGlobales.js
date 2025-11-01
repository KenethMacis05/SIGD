//Métodos Globales

// Regresar a la pagina anterior y recargar
function Recargar() {
    // Intentar regresar
    if (history.length > 1) {
        history.back();
        // Forzar recarga después de un breve tiempo
        setTimeout(() => {
            location.reload(true);
        }, 50);
    } else {
        // Si no hay historia, redirigir a una página por defecto
        window.location.href = '@Url.Action("Index", "Home")';
    }
}

// Limpiar filtro
function limpiarFiltro(texto) {
    return texto
        .replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ0-9 ]/g, '')
        .replace(/\s+/g, ' ')
}

//Configuración de las dataTable
const dataTableConfig = {
    lengthMenu: [5, 10, 15, 20, 100, 200, 500],
    pageLength: 5,
    destroy: true,
    language: {
        lengthMenu: "Mostrar _MENU_ registros por página",
        zeroRecords: "Ningún resgistro encontrado",
        info: "Mostrando de _START_ a _END_ de un total de _TOTAL_ registros",
        infoEmpty: "Ningún registro encontrado",
        infoFiltered: "(filtrados desde _MAX_ registros totales)",
        search: "Buscar:",
        loadingRecords: "Cargando...",
        paginate: {
            first: "Primero",
            last: "Último",
            next: "Siguiente",
            previous: "Anterior"
        }
    },
    responsive: true,
    ordering: false
};

// Función para formatear la fecha
function formatASPNetDate(jsonDate, showTime = true) {
    if (!jsonDate) return 'Fecha no disponible';

    let date;

    // Formato /Date(...)/
    if (typeof jsonDate === 'string' && jsonDate.startsWith('/Date(')) {
        const timestamp = parseInt(jsonDate.substr(6));
        date = new Date(timestamp);
    }
    // Si ya es una fecha válida
    else {
        try {
            date = new Date(jsonDate);
            if (isNaN(date.getTime())) {
                return 'Fecha no disponible';
            }
        } catch (e) {
            console.error("Error formateando fecha:", e);
            return 'Fecha no disponible';
        }
    }

    // Opciones de formato
    const options = {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric'
    };

    // Agregar hora si showTime es true
    if (showTime) {
        options.hour = '2-digit';
        options.minute = '2-digit';
    }

    return date.toLocaleDateString('es-ES', options);
}

// Configuración de SweetAlert2
const swalConfig = {
    confirmButtonColor: "#3085d6",
    customClass: {
        popup: 'custom-success-alerta',
        confirmButton: 'custom-confirmar-button',
    }
};

//Mostrar Alerta
function showAlert(title, message, icon, isToast = false, useHTML = false) {
    const config = {
        title,
        [useHTML ? 'html' : 'text']: message,
        icon,
        ...swalConfig,
        ...(isToast && {
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true
        })
    };

    return Swal.fire(config);
}

function confirmarEliminacion(titulo = "¿Estás seguro?", texto = "¡Esta acción no se puede deshacer!") {
    return Swal.fire({
        ...swalConfig,
        title: titulo,
        text: texto,
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Sí, eliminar",
        cancelButtonText: "Cancelar",
        reverseButtons: true
    });
}

function confirmarAccion(titulo = "¿Estás seguro?", texto = "¡Esta acción no se puede deshacer!") {
    return Swal.fire({
        ...swalConfig,
        title: titulo,
        text: texto,
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Sí, actualizar",
        cancelButtonText: "Cancelar",
        reverseButtons: true
    });
}

function showLoadingAlert(titulo = "Eliminando", mensaje = "Por favor espere...") {
    return Swal.fire({
        title: titulo,
        html: mensaje,
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });
}

//Mostrar Loading
const showLoading = (element) => {
    $(element).LoadingOverlay("show");
};

//Ocultar Loading
const hideLoading = (element) => {
    $(element).LoadingOverlay("hide");
};

// Función para determinar ícono y color según el tipo de archivo
function obtenerIconoYColor(tipoArchivo) {
    let icono = '';
    let color = '';

    switch (tipoArchivo.toLowerCase()) {
        // Archivos PDF (Adobe)
        case '.pdf':
            icono = 'fa-file-pdf';
            color = 'text-danger';
            break;

        // Archivos de Microsoft Word
        case '.doc':
        case '.docx':
            icono = 'fa-file-word';
            color = 'text-primary';
            break;

        // Archivos de Microsoft Excel
        case '.xls':
        case '.xlsx':
            icono = 'fa-file-excel';
            color = 'text-success';
            break;

        // Archivos de Microsoft PowerPoint
        case '.ppt':
        case '.pptx':
            icono = 'fa-file-powerpoint';
            color = 'text-warning';
            break;

        // Archivos de imágenes
        case '.png':
        case '.jpg':
        case '.jpeg':
        case '.gif':
        case '.bmp':
        case '.svg':
        case '.webp':
            icono = 'fa-file-image';
            color = 'text-warning';
            break;

        // Archivos comprimidos
        case '.zip':
        case '.rar':
        case '.tar':
        case '.gz':
        case '.7z':
            icono = 'fa-file-archive';
            color = 'text-secondary';
            break;

        // Archivos de texto
        case '.txt':
        case '.log':
        case '.md':
            icono = 'fa-file-alt';
            color = 'text-info';
            break;

        // Archivos de audio
        case '.mp3':
        case '.wav':
        case '.ogg':
        case '.flac':
        case '.aac':
            icono = 'fa-file-audio';
            color = 'text-success';
            break;

        // Archivos de video
        case '.mp4':
        case '.avi':
        case '.mkv':
        case '.mov':
        case '.wmv':
        case '.flv':
        case '.webm':
            icono = 'fa-file-video';
            color = 'text-danger';
            break;

        // Archivos de Adobe
        case '.psd':
        case '.ai':
        case '.indd':
        case '.xd':
        case '.aep':
        case '.prproj':
        case '.pdf':
        case '.ae':
        case '.svg':
            icono = 'fa-adobe';
            color = 'text-danger';
            break;

        // Otros tipos de archivos
        case '.json':
        case '.xml':
        case '.csv':
            icono = 'fa-file-code';
            color = 'text-info';
            break;

        case '.exe':
        case '.msi':
        case '.bat':
        case '.sh':
            icono = 'fa-file-code';
            color = 'text-dark';
            break;

        // Por defecto
        default:
            icono = 'fa-file';
            color = 'text-muted';
            break;
    }

    return { icono, color };
}

// Formatear tamaño del archivo
function formatFileSize(bytes) {
    if (bytes < 1024) return `${bytes} B`;
    let kb = bytes / 1024;
    if (kb < 1024) return `${kb.toFixed(2)} KB`;
    let mb = kb / 1024;
    if (mb < 1024) return `${mb.toFixed(2)} MB`;
    let gb = mb / 1024;
    if (gb < 1024) return `${gb.toFixed(2)} GB`;
    let tb = gb / 1024;
    return `${tb.toFixed(2)} TB`;
}

// Colores reutilizables
const COLORS = ['primary', 'warning', 'danger', 'success', 'info', 'secondary'];

// Función para generar el HTML de una carpeta
function generarHtmlCarpeta(carpeta, index, permisosHeredados = null) {
    const color = COLORS[index % COLORS.length];
    const propietarioHtml = carpeta.propietario ? `<span class="text-muted small">Propie: (${carpeta.propietario})</span>` : '';
    const fechaAMostrar = (carpeta.fecha_registro === "/Date(-62135575200000)/")
        ? formatASPNetDate(carpeta.fecha_compartido)
        : formatASPNetDate(carpeta.fecha_registro);

    // Permiso efectivo: explícito o heredado
    let permisoEfectivo = (carpeta.permisos !== undefined && carpeta.permisos !== null && carpeta.permisos !== "")
        ? carpeta.permisos
        : permisosHeredados;

    let mostrarMenu = true;
    if (permisoEfectivo === "lectura") {
        mostrarMenu = false;
    }

    // Menú de opciones (solo si mostrarMenu es true)
    let menuOpcionesHtml = "";
    if (mostrarMenu) {
        menuOpcionesHtml = `
        <div class="ms-auto">
            <a href="#" class="dropdown-toggle file-manager-recent-file-actions" 
                data-bs-toggle="dropdown" data-carpeta-id="${carpeta.id_carpeta}">
                <i class="fas fa-ellipsis-v"></i>
            </a>
            <ul class="dropdown-menu dropdown-menu-end shadow rounded py-1">
                <li>
                    <a class="dropdown-item btn-crearSubCarpeta px-3 py-2" href="#" data-carpetaPadre-id="${carpeta.id_carpeta}">
                        <i class="fas fa-plus me-2"></i>Crear carpeta
                    </a>
                </li>
                <li>
                    <a class="dropdown-item btn-subirArchivo px-3 py-2" href="#" data-carpeta-id="${carpeta.id_carpeta}" data-carpeta-nombre="${carpeta.nombre}">
                        <i class="fas fa-file me-2"></i>Subir Archivo
                    </a>
                </li>
                <li>
                    <a class="dropdown-item btn-compartir px-3 py-2" href="#" data-carpeta-id="${carpeta.id_carpeta}">
                        <i class="fas fa-share me-2"></i>Compartir
                    </a>
                </li>
                <li>
                    <a class="dropdown-item btn-descargar px-3 py-2" href="#" data-carpeta-id="${carpeta.id_carpeta}">
                        <i class="fas fa-download me-2"></i>Descargar
                    </a>
                </li>
                <li>
                    <a class="dropdown-item btn-editar px-3 py-2" href="#" data-carpeta-id="${carpeta.id_carpeta}" data-carpeta-nombre="${carpeta.nombre}">
                        <i class="fas fa-edit me-2"></i>Renombrar
                    </a>
                </li>
                <li>
                    <a class="dropdown-item btn-eliminar px-3 py-2" href="#" data-carpeta-id="${carpeta.id_carpeta}">
                        <i class="fas fa-trash me-2"></i>Eliminar
                    </a>
                </li>
            </ul>
        </div>
        `;
    }

    // data-permisos para heredar al navegar
    const dataPermisos = permisoEfectivo ? `data-permisos="${permisoEfectivo}"` : '';

    return `
    <div class="col-sm-6 col-md-4 col-lg-3" data-folder-card>
        <div class="card file-manager-group h-100 shadow-sm">
            <div class="card-body d-flex align-items-center">
                <i class="fas fa-folder-open fa-2x text-${color} me-3 d-none"></i>
                <i class="fas fa-folder fa-2x text-${color} me-3"></i>
                <div class="file-manager-group-info flex-fill">
                    <div class="file-manager-group-compartidos">
                        <a href="#" class="file-manager-group-title h5 text-decoration-none text-dark"
                            data-carpetaPadre-id="${carpeta.id_carpeta}"
                            ${dataPermisos}
                        >${carpeta.nombre}</a>
                        ${propietarioHtml}
                    </div>
                    <span class="file-manager-group-about text-muted small">${fechaAMostrar}</span>
                </div>
                ${menuOpcionesHtml}
            </div>
        </div>
    </div>`;
}

// Función para generar el HTML de un archivo
function generarHtmlArchivo(archivo, permisosHeredados = null) {
    const { icono, color } = obtenerIconoYColor(archivo.tipo);
    const propietarioHtml = archivo.propietario ? `<span class="text-muted small">${archivo.propietario}</span>` : '';
    const correoHtml = archivo.correo ? `<span class="text-muted small">(${archivo.correo})</span>` : '';
    const fechaAMostrar = (archivo.fecha_subida === "/Date(-62135575200000)/")
        ? formatASPNetDate(archivo.fecha_compartido)
        : formatASPNetDate(archivo.fecha_subida);

    // Permiso efectivo: explícito o heredado
    let permisoEfectivo = (archivo.permisos !== undefined && archivo.permisos !== null && archivo.permisos !== "")
        ? archivo.permisos
        : permisosHeredados;

    let mostrarMenu = true;
    if (permisoEfectivo === "lectura") {
        mostrarMenu = false;
    }

    // Menú de opciones (solo si mostrarMenu es true)
    let menuOpcionesHtml = "";
    if (mostrarMenu) {
        menuOpcionesHtml = `
        <div class="dropdown">
            <a href="#" class="dropdown-toggle file-manager-recent-file-actions text-dark" data-bs-toggle="dropdown">
                <i class="fas fa-ellipsis-v"></i>
            </a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li>
                    <a class="dropdown-item btn-compartirArchivo" href="#" data-archivo-id="${archivo.id_archivo}">
                        <i class="fas fa-share me-2"></i>Compartir
                    </a>
                </li>
                <li>
                    <a class="dropdown-item btn-descargarArchivo" href="#" data-archivo-id="${archivo.id_archivo}">
                        <i class="fas fa-download me-2"></i>Descargar
                    </a>
                </li>
                <li><a class="dropdown-item" href="#"><i class="fas fa-folder me-2"></i>Mover</a></li>
                <li>
                    <a class="dropdown-item btn-editarArchivo" href="#" data-archivo-id="${archivo.id_archivo}" data-carpetapadre-id="${archivo.id_carpeta}" data-archivo-nombre="${archivo.nombre}">
                        <i class="fas fa-edit me-2"></i>Renombrar
                    </a>
                </li>
                <li><a class="dropdown-item btn-eliminarArchivo" href="#" data-archivo-id="${archivo.id_archivo}"><i class="fas fa-trash me-2"></i>Eliminar</a></li>
            </ul>
        </div>
        `;
    }

    const dataPermisos = permisoEfectivo ? `data-permisos="${permisoEfectivo}"` : '';

    return `
    <div class="col-sm-12 col-md-12 col-lg-6">
        <div class="card file-manager-recent-item h-100 shadow-sm">
            <div class="card-body">
                <div class="d-flex align-items-center gap-3">
                    <i class="fas ${icono} fa-lg ${color} fa-2x"></i>
                    <div class="flex-fill">                                        
                        <div class="file-manager-group-compartidos">
                            <a href="#" class="file-manager-recent-item-title h5 text-decoration-none text-dark d-block"
                                    data-archivo-id="${archivo.id_archivo}" 
                                    data-archivo-nombre="${archivo.nombre}" 
                                    data-archivo-tipo="${archivo.tipo}"
                                    ${dataPermisos}
                                >${archivo.nombre}</a>
                            <div>
                                ${propietarioHtml} ${correoHtml}
                            </div>
                        </div>
                        <small class="text-muted">${formatFileSize(archivo.size)} - ${fechaAMostrar}</small>
                    </div>
                    ${menuOpcionesHtml}
                </div>
            </div>
        </div>
    </div>`;
}

// Visualizar imagenes y videos en LightGallery
let lightGalleryInstance = null;

function abrirEnLightGallery(items, indexToOpen = 0) {
    $('#lightgallery').empty();

    items.forEach(item => {
        if (item.type === 'imagen') {
            $('#lightgallery').append(`
                <a href="${item.src}" data-lg-size="1600-1067" data-sub-html="${item.subHtml || ''}">
                    <img class="img-fluid" src="${item.src}" alt="preview"/>
                </a>
            `);
        } else if (item.type === 'video') {
            $('#lightgallery').append(`
                <a 
                    data-lg-size="1280-720"
                    data-video='{"source": [{"src":"${item.src}","type":"${item.mime}"}], "attributes": {"preload": false, "controls": true}}'
                    data-sub-html="${item.subHtml || ''}"
                    href="">
                    <img class="img-fluid" src="${item.poster || 'https://dummyimage.com/320x180/000/fff&text=Video'}" alt="preview"/>
                </a>
            `);
        }
    });

    if (lightGalleryInstance) {
        lightGalleryInstance.destroy(true);
        lightGalleryInstance = null;
    }

    lightGalleryInstance = lightGallery(document.getElementById('lightgallery'), {
        plugins: [
            lgZoom,
            lgThumbnail,
            lgFullscreen,
            lgRotate,
            lgShare,
            lgPager,
            lgAutoplay,
            lgComment,
            lgHash,
            lgVideo
        ],
        speed: 400,
        download: true,
        actualSize: true,
        licenseKey: '0000-0000-000-0000'
    });

    lightGalleryInstance.openGallery(indexToOpen);
}

// Configuración de sommernote
const summernoteConfig = {
    height: 150,
    toolbar: [
        ['style', ['bold', 'italic', 'underline', 'clear']],
        ['insert', ['table']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['misc', ['fullscreen']]
    ],
    callbacks: {
        onChange: function (contents, $editable) {
            $(this).summernote('save');
            const contenidoLimpio = contents.replace(/<[^>]*>/g, '').trim();
            if (contenidoLimpio) {
                $(this).next('.note-editor').css('border', '');
            }
        },
        onBlur: function () {
            $(this).summernote('save');
        }
    }
};
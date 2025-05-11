//Métodos Globales


//Configuración de las dataTable
const dataTableConfig = {
    lengthMenu: [5, 10, 15, 20, 100, 200, 500],
    pageLength: 5,
    destroy: true,
    language: {
        lengthMenu: "Mostrar _MENU_ registros por página",
        zeroRecords: "Ningún resgistro encontrado",
        info: "Mostrando de _START_ a _END_ de un total de _TOTAL_ registros",
        infoEmpty: "Ningún rol encontrado",
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
function formatASPNetDate(jsonDate) {
    if (!jsonDate) return 'Fecha no disponible';

    // Formato /Date(...)/
    if (typeof jsonDate === 'string' && jsonDate.startsWith('/Date(')) {
        var timestamp = parseInt(jsonDate.substr(6));
        var date = new Date(timestamp);
        return date.toLocaleDateString('es-ES', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    }

    // Si ya es una fecha válida
    try {
        var date = new Date(jsonDate);
        if (!isNaN(date.getTime())) {
            return date.toLocaleDateString('es-ES', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
        }
    } catch (e) {
        console.error("Error formateando fecha:", e);
    }

    return 'Fecha no disponible';
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
function showAlert(title, text, icon, isToast = false) {
    const config = {
        title,
        text,
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
        case '.pdf':
            icono = 'fa-file-pdf';
            color = 'text-danger';
            break;
        case '.doc':
        case '.docx':
            icono = 'fa-file-word';
            color = 'text-primary';
            break;
        case '.xls':
        case '.xlsx':
            icono = 'fa-file-excel';
            color = 'text-success';
            break;
        case '.png':
        case '.jpg':
        case '.jpeg':
        case '.gif':
            icono = 'fa-file-image';
            color = 'text-warning';
            break;
        case '.zip':
        case '.rar':
            icono = 'fa-file-archive';
            color = 'text-secondary';
            break;
        case '.txt':
            icono = 'fa-file-alt';
            color = 'text-info';
            break;
        case '.mp3':
            icono = 'fa-file-audio';
            color = 'text-success';
            break;
        case '.mp4':
            icono = 'fa-file-video';
            color = 'text-danger';
            break;
        default:
            icono = 'fa-file';
            color = 'text-muted';
            break;
    }

    return { icono, color };
}

// Colores reutilizables
const COLORS = ['primary', 'warning', 'danger', 'success', 'info', 'secondary'];

// Función para generar el HTML de una carpeta
function generarHtmlCarpeta(carpeta, index) {
    const color = COLORS[index % COLORS.length];
    return `
    <div class="col-sm-6 col-md-4 col-lg-3">
        <div class="card file-manager-group h-100 shadow-sm">
            <div class="card-body d-flex align-items-center">
                <i class="fas fa-folder-open fa-2x text-${color} me-3 d-none"></i>
                <i class="fas fa-folder fa-2x text-${color} me-3"></i>
                <div class="file-manager-group-info flex-fill">
                    <a href="#" class="file-manager-group-title h5 d-block text-decoration-none text-dark" data-carpetaPadre-id="${carpeta.id_carpeta}">${carpeta.nombre}</a>
                    <span class="file-manager-group-about text-muted small">${formatASPNetDate(carpeta.fecha_registro)}</span>
                </div>
                <div class="ms-auto">
                    <a href="#" class="dropdown-toggle file-manager-recent-file-actions" 
                        data-bs-toggle="dropdown" data-carpeta-id="${carpeta.id_carpeta}">
                        <i class="fas fa-ellipsis-v"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li>
                            <a class="dropdown-item btn-crearSubCarpeta" href="#" data-carpetaPadre-id="${carpeta.id_carpeta}">
                                <i class="fas fa-plus me-2"></i>Crear carpeta
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item btn-subirArchivo" href="#" data-carpeta-id="${carpeta.id_carpeta}" data-carpeta-nombre="${carpeta.nombre}">
                                <i class="fas fa-file me-2"></i>Subir Archivo
                            </a>
                        </li>
                        <li><a class="dropdown-item btn-compartir" href="#" data-carpeta-id="${carpeta.id_carpeta}">
                            <i class="fas fa-share me-2"></i>Compartir
                        </a></li>
                        <li><a class="dropdown-item btn-descargar" href="#" data-carpeta-id="${carpeta.id_carpeta}">
                            <i class="fas fa-download me-2"></i>Descargar
                        </a></li>
                        <li>
                            <a class="dropdown-item btn-editar" href="#" data-carpeta-id="${carpeta.id_carpeta}" data-carpeta-nombre="${carpeta.nombre}">
                                <i class="fas fa-edit me-2"></i>Renombrar
                            </a>
                        </li>
                        <li><a class="dropdown-item btn-eliminar" href="#" data-carpeta-id="${carpeta.id_carpeta}">
                            <i class="fas fa-trash me-2"></i>Eliminar
                        </a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>`;
}

// Función para generar el HTML de un archivo
function generarHtmlArchivo(archivo) {
    const { icono, color } = obtenerIconoYColor(archivo.tipo);

    return `
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
                            <li><a class="dropdown-item btn-eliminarArchivo" href="#"
                            data-archivo-id="${archivo.id_archivo}">
                            <i class="fas fa-trash me-2"></i>Eliminar</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>`;
}
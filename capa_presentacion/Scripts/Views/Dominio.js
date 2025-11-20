// Variables globales
let dominiosAsignados = [];
let dominiosNoAsignados = [];

// Configuración de targets
const targets = {
    'asignados': {
        checkbox: '.asignadosCheckbox',
        container: '#listaDominiosAsignados',
        dataArray: dominiosAsignados
    },
    'noAsignados': {
        checkbox: '.noAsignadosCheckbox',
        container: '#listaDominiosNoAsignados',
        dataArray: dominiosNoAsignados
    }
};

// Función para mover elementos entre listas
function moverElementos(direccion) {
    let origen, destino, origenData, destinoData, origenCheckbox, destinoCheckbox;

    if (direccion === 'derecha') {
        // Mover de no asignados a asignados
        origen = 'noAsignados';
        destino = 'asignados';
        origenCheckbox = '.noAsignadosCheckbox';
        destinoCheckbox = '.asignadosCheckbox';
        origenData = dominiosNoAsignados;
        destinoData = dominiosAsignados;
    } else {
        // Mover de asignados a no asignados
        origen = 'asignados';
        destino = 'noAsignados';
        origenCheckbox = '.asignadosCheckbox';
        destinoCheckbox = '.noAsignadosCheckbox';
        origenData = dominiosAsignados;
        destinoData = dominiosNoAsignados;
    }

    // Obtener checkboxes seleccionados
    const $checkboxesSeleccionados = $(origenCheckbox + ':checked');

    if ($checkboxesSeleccionados.length === 0) {
        showAlert("¡Atención!", `Debe seleccionar al menos un dominio para mover a ${destino === 'asignados' ? 'asignados' : 'disponibles'}.`, "warning", true);
        return;
    }

    // Mostrar loading
    $(targets[origen].container).LoadingOverlay("show");
    $(targets[destino].container).LoadingOverlay("show");

    setTimeout(() => {
        // Mover elementos seleccionados
        $checkboxesSeleccionados.each(function () {
            const dominioId = $(this).val();
            const dominioData = obtenerDatosDominioPorId(dominioId, origenData);

            if (dominioData) {
                // Remover del origen
                const indexOrigen = origenData.findIndex(d =>
                    d.Dominio ? d.Dominio.id_dominio == dominioId : d.id_dominio == dominioId
                );
                if (indexOrigen !== -1) {
                    origenData.splice(indexOrigen, 1);
                }

                // Agregar al destino
                if (destino === 'asignados') {
                    // Para asignados, necesitamos la estructura con Dominio
                    destinoData.push({
                        Dominio: dominioData
                    });
                } else {
                    // Para no asignados, solo el objeto dominio
                    destinoData.push(dominioData);
                }
            }
        });

        // Re-renderizar ambas listas
        renderizarDominiosAsignados();
        renderizarDominiosNoAsignados();

        // Ocultar loading
        $(targets[origen].container).LoadingOverlay("hide");
        $(targets[destino].container).LoadingOverlay("hide");

        // Habilitar botón de guardar
        $('#btnGuardarDominios').prop('disabled', false);

        // Mostrar mensaje de éxito
        showAlert("Éxito",
            `${$checkboxesSeleccionados.length} dominio(s) movido(s) correctamente a ${destino === 'asignados' ? 'asignados' : 'disponibles'}.`,
            "success", true);

    }, 300);
}

// Función auxiliar para obtener datos del dominio por ID
function obtenerDatosDominioPorId(dominioId, arrayData) {
    for (let item of arrayData) {
        if (item.Dominio) {
            // Estructura de asignados
            if (item.Dominio.id_dominio == dominioId) {
                return item.Dominio;
            }
        } else {
            // Estructura de no asignados
            if (item.id_dominio == dominioId) {
                return item;
            }
        }
    }
    return null;
}

// Event handlers para los botones de flecha
$('#btnDerecha').on('click', function () {
    // Flecha derecha - mover a asignados
    moverElementos('derecha');
});

$('#btnIzquierda').on('click', function () {
    // Flecha izquierda - mover a no asignados
    moverElementos('izquierda');
});

// Función única para manejar checkboxes (seleccionar/deseleccionar todo)
function toggleCheckboxes(action, targetKey) {
    const { checkbox, container } = targets[targetKey];
    const $checkboxes = $(checkbox);
    const checkedCount = $checkboxes.filter(':checked').length;
    const totalCount = $checkboxes.length;

    if ((action === 'select' && checkedCount === totalCount) ||
        (action === 'deselect' && checkedCount === 0)) {
        showAlert("¡Atención!",
            `Todos los elementos ya están ${action === 'select' ? 'seleccionados' : 'desmarcados'}.`,
            "info", true);
        return;
    }

    $(container).LoadingOverlay("show");
    setTimeout(() => {
        $checkboxes.prop('checked', action === 'select');
        $(container).LoadingOverlay("hide");
    }, 300);
}

// Event handlers para seleccionar/deseleccionar todo
$('.select-all-btn, .deselect-all-btn').on('click', function () {
    const action = $(this).hasClass('select-all-btn') ? 'select' : 'deselect';
    const target = $(this).data('target');
    toggleCheckboxes(action, target);
});

// Función cargarDominios
function cargarDominios(IdRol, IdDominio) {
    const miElemento = document.getElementById('contenedorListasDominios');

    let dominiosAsignadosLoaded = false;
    let dominiosNoAsignadosLoaded = false;
    let dominiosAsignadosData = [];
    let dominiosNoAsignadosData = [];

    // Función para verificar si ambas peticiones han terminado
    function verificarCargaCompleta() {
        if (dominiosAsignadosLoaded && dominiosNoAsignadosLoaded) {
            dominiosAsignados = dominiosAsignadosData;
            dominiosNoAsignados = dominiosNoAsignadosData;

            renderizarDominiosAsignados();
            renderizarDominiosNoAsignados();

            miElemento.classList.remove('hidden');
            $('#btnGuardarDominios').prop('disabled', false);
        }
    }

    // Petición para dominios asignados
    $.ajax({
        url: '/Dominio/ObtenerDominiosPorRol',
        type: 'GET',
        dataType: 'json',
        data: {
            IdRol: IdRol,
            IdDominio: IdDominio
        },
        success: function (response) {
            dominiosAsignadosData = response.data || [];
            dominiosAsignadosLoaded = true;
            verificarCargaCompleta();
        },
        error: function (xhr, status, error) {
            showAlert("Error", `Error al conectar con el servidor: ${error}`, "error")
            dominiosAsignadosLoaded = true;
            verificarCargaCompleta();
        }
    });

    // Petición para dominios no asignados
    $.ajax({
        url: '/Dominio/ObtenerDominioNoAsignados',
        type: 'GET',
        dataType: 'json',
        data: {
            IdRol: IdRol,
            IdDominio: IdDominio
        },
        success: function (response) {
            dominiosNoAsignadosData = response.data || [];
            dominiosNoAsignadosLoaded = true;
            verificarCargaCompleta();
        },
        error: function (xhr, status, error) {
            showAlert("Error", `Error al conectar con el servidor: ${error}`, "error")
            dominiosNoAsignadosLoaded = true;
            verificarCargaCompleta();
        }
    });
}

// Renderizar dominios asignados
function renderizarDominiosAsignados() {
    const container = $('#listaDominiosAsignados');

    if (dominiosAsignados.length === 0) {
        container.html(`
            <div class="text-center text-muted py-4">
                <i class="fas fa-info-circle fa-2x mb-2"></i>
                <p>No hay dominios asignados</p>
            </div>
        `);
        return;
    }

    let html = '';
    dominiosAsignados.forEach(function (dominio) {
        html += `
            <div class="form-check mb-2 dominio-item">
                <input class="form-check-input asignadosCheckbox"
                       type="checkbox" 
                       value="${dominio.Dominio.id_dominio}" 
                       id="dominioAsignado_${dominio.Dominio.id_dominio}" 
                       data-dominio="${dominio.Dominio.id_dominio}">
                <label class="form-check-label w-100" for="dominioAsignado_${dominio.Dominio.id_dominio}">
                    <span>${dominio.Dominio.descripcion_dominio || 'Sin nombre'}</span>
                </label>
            </div>
        `;
    });

    container.html(html);
}


// Renderizar dominios no asignados
function renderizarDominiosNoAsignados() {
    const container = $('#listaDominiosNoAsignados');

    if (dominiosNoAsignados.length === 0) {
        container.html(`
            <div class="text-center text-muted py-4">
                <i class="fas fa-info-circle fa-2x mb-2"></i>
                <p>No hay dominios disponibles</p>
            </div>
        `);
        return;
    }

    let html = '';
    dominiosNoAsignados.forEach(function (dominio) {
        html += `
            <div class="form-check mb-2 dominio-item">
                <input class="form-check-input noAsignadosCheckbox"
                       type="checkbox" 
                       value="${dominio.id_dominio}" 
                       id="${dominio.id_dominio}"
                       data-dominio='${JSON.stringify(dominio.id_dominio)}'>
                <label class="form-check-label w-100" for="dominioNoAsignado_${dominio.id_dominio}">
                    <span>${dominio.descripcion_dominio || 'Sin nombre'}</span>
                </label>
            </div>
        `;
    });
    container.html(html);
}

$('#btnGuardarDominios').click(function () {
    // Obtener valores
    var IdRol = $('#obtenerRol').val();
    var IdTipoDominio = $('#inputGroupSelectTipoDominio').val();
    var dominiosSeleccionados = [];

    // Obtener dominios seleccionados
    $('.asignadosCheckbox').each(function () {
        var dominioId = $(this).val();
        if (dominioId && dominioId !== '') {
            dominiosSeleccionados.push(parseInt(dominioId));
        }
    });

    $.ajax({
        url: '/Dominio/GuardarDominiosRol',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
            IdRol: IdRol,
            Dominios: dominiosSeleccionados,
            IdTipoDominio: IdTipoDominio,
        }),
        success: function (response) {

            if (response.success) {
                showAlert("Éxito", response.message, "success");
                $('#btnGuardarDominios').prop('disabled', true);

                // Recargar las listas para reflejar los cambios
                setTimeout(function () {
                    cargarDominios(parseInt(IdRol), parseInt(IdTipoDominio));
                }, 1000);
            } else {
                showAlert("Error", response.message, "error");
                $('#btnGuardarDominios').prop('disabled', false);
            }
        },
        error: function (xhr, status, error) {
            var errorMessage = "Error al guardar los dominios: ";

            if (xhr.responseJSON && xhr.responseJSON.message) {
                errorMessage += xhr.responseJSON.message;
            } else {
                errorMessage += error;
            }

            showAlert("Error", errorMessage, "error");
            $('#btnGuardarDominios').prop('disabled', false);
        }
    }); 
});
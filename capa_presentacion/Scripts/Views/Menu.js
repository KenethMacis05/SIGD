// Cargar roles en el selec
jQuery.ajax({
    url: listarRolesUrl,
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

var idRol = null;
var menusSeleccionados = [];

// Mostrar permisos del Rol
$("#btnBuscarMenu").off("click").on("click", function () {
    idRol = $('#obtenerRolMenu').val();
    if (!idRol) {
        showAlert("¡Atención!", "Primero debe seleccionar un rol", "warning");
        return false;
    }
    
    cargarMenusPorRol(idRol)
});

function renderizarDuallistbox(menus) {
    const menuList = $('#menuList');
    menuList.empty();
    menus.forEach(menu => {
        const isChecked = menu.is_checked ? "checked" : "";
        const menuHTML = `
            <li class="list-group-item d-flex justify-content-between align-items-center esp-link menu-item" data-id="${menu.id_menu}">
                <div class='sb-nav-link-icon'>
                    <input type="checkbox" class="form-check-input me-2 menu-checkbox" data-id="${menu.id_menu}" ${isChecked}>
                    <i class="${menu.icono}"></i>                        
                    <span>${menu.nombre}</span>
                </div>
                <span class="badge bg-primary">${menu.orden}</span>
            </li>
        `;

        menuList.append(menuHTML);
    });
}

// Cargar menús del rol
function cargarMenusPorRol(idRol, lis) {
    $.ajax({
        url: config.listarMenusPorRolUrl,
        type: 'GET',
        data: { idRol: idRol },
        beforeSend: () => $(".dual-listbox-container").LoadingOverlay("show"),
        success: function (response) {
            if (response.success) {
                renderizarDuallistbox(response.data);
            } else {                
                showAlert("Error", response.message, "error")
            }
        },
        complete: () => $(".dual-listbox-container").LoadingOverlay("hide"),
        error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
    });
}

// Seleccionar Todo
$('#selectAll').on('click', function () {
    const totalCheckboxes = $('.menu-checkbox').length;
    const checkedCheckboxes = $('.menu-checkbox:checked').length;

    if (checkedCheckboxes === totalCheckboxes) {
        showAlert("¡Atención!", "Todos los elementos ya están seleccionados.", "info");
        return;
    }

    $(".dual-listbox-container").LoadingOverlay("show");

    setTimeout(() => {
        $('.menu-checkbox').prop('checked', true);
        $(".dual-listbox-container").LoadingOverlay("hide");

    }, 300);
});

// Deseleccionar Todo
$('#deselectAll').on('click', function () {
    const totalCheckboxes = $('.menu-checkbox').length;
    const checkedCheckboxes = $('.menu-checkbox:checked').length;

    if (checkedCheckboxes === 0) {
        showAlert("¡Atención!", "Todos los elementos ya están desmarcados.", "info");
        return;
    }

    $(".dual-listbox-container").LoadingOverlay("show");

    setTimeout(() => {
        $('.menu-checkbox').prop('checked', false);

        $(".dual-listbox-container").LoadingOverlay("hide");

    }, 300);
});

// Limpiar (Restablecer a estado original)
$('#limpiar').on('click', function () {
    $('.menu-checkbox').prop('checked', false);
    cargarMenusPorRol(idRol);
    console.log("Dual Listbox restablecido a su estado original.");
});

// Añadir funcionalidad de hover y clic
$(document).on('mouseenter', '.menu-item', function () {
    $(this).addClass('hovered');
});

$(document).on('mouseleave', '.menu-item', function () {
    $(this).removeClass('hovered');
});

$(document).on('click', '.menu-item', function (e) {
    if ($(e.target).is('.menu-checkbox')) {
        return;
    }

    const checkbox = $(this).find('.menu-checkbox');
    const isChecked = checkbox.prop('checked');
    checkbox.prop('checked', !isChecked);
});


// EN DESAROLLO
// Recopilar menús seleccionados
function obtenerMenusSeleccionados() {
    const seleccionados = [];
    $('.menu-checkbox:checked').each(function () {
        seleccionados.push({ id_menu: $(this).data('id') });
    });
    return seleccionados;
}

// Guardar menús en el backend
function guardarMenus(idRol, menusSeleccionados) {
    $.ajax({
        url: config.guardarMenusPorRolUrl,
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ idRol: idRol, Menus: menusSeleccionados }),
        beforeSend: () => $(".dual-listbox-container").LoadingOverlay("show"),
        success: function (response) {
            if (response.success) {
                showAlert("¡Éxito!", "Los menús han sido actualizados correctamente.", "success");
            } else {
                showAlert("Error", `No se pudieron guardar los menús: ${response.message}`, "error");
            }
        },
        complete: () => $(".dual-listbox-container").LoadingOverlay("hide"),
        error: function (xhr) {
            showAlert("Error", `Error al guardar los menús: ${xhr.statusText}`, "error");
        }
    });
}

// Botón para guardar los menús
$('#guardarMenus').on('click', function () {
    if (!idRol) {
        showAlert("¡Atención!", "Primero debe seleccionar un rol.", "warning");
        return;
    }

    // Obtener los menús seleccionados
    menusSeleccionados = obtenerMenusSeleccionados();

    if (menusSeleccionados.length === 0) {
        showAlert("¡Atención!", "Debe seleccionar al menos un menú para guardar.", "warning");
        return;
    }

    // Llamar a la función para guardar
    guardarMenus(idRol, menusSeleccionados);
});
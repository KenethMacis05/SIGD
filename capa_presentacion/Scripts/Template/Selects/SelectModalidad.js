$(document).ready(function () {
    cargarModalidades();
});

function inicializarSelect2Modalidad(dropdownParent = null) {
    var config = {
        placeholder: "Buscar ...",
        allowClear: true,
        language: {
            noResults: function () {
                return "No se encontraron resultados";
            }
        }
    };

    // Si se proporciona un dropdownParent, lo agregamos a la configuración
    if (dropdownParent) {
        config.dropdownParent = dropdownParent;
    }

    $('#inputGroupSelectModalidad').select2(config);
}

function cargarModalidades(dropdownParent = null) {
    var modalidadActual = $("#fk_modalidad_activa").val();

    jQuery.ajax({
        url: "/Catalogos/ListarModalidad",
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {
            $('#inputGroupSelectModalidad').empty()
                .append('<option value="">Seleccione una modalidad...</option>');

            $.each(response.data, function (index, modalidad) {
                var isSelected = (modalidad.id_modalidad == modalidadActual);
                $('#inputGroupSelectModalidad').append(
                    $('<option>', {
                        value: modalidad.id_modalidad,
                        text: modalidad.nombre,
                        selected: isSelected
                    })
                );
            });

            // Reinicializar Select2 con el dropdownParent si se proporciona
            if (dropdownParent) {
                $('#inputGroupSelectModalidad').select2('destroy');
                inicializarSelect2Modalidad(dropdownParent);
            }

            // Si hay una modalidad actual, seleccionarla
            if (modalidadActual && modalidadActual !== '0') {
                $('#inputGroupSelectModalidad').val(modalidadActual).trigger('change');
            }

            $('#inputGroupSelectModalidad').trigger('change.select2');
        },

        error: (xhr) => {
            showAlert("Error", `Error al conectar con el servidor (Modalidades): ${xhr.statusText}`, "error");
        }
    });
}
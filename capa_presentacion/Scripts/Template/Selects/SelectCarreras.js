$(document).ready(function () {
    cargarCarreras();
});

function inicializarSelect2Carrera(dropdownParent = null) {
    var config = {
        placeholder: "Buscar carrera...",
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

    $('#inputGroupSelectCarrera').select2(config);
}

function cargarCarreras(dropdownParent = null) {
    var carreraActual = $("#fk_carrera_activa").val();

    jQuery.ajax({
        url: "/Catalogos/GetCarrera",
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {
            $('#inputGroupSelectCarrera').empty()
                .append('<option value="">Seleccione una carrera...</option>');

            $.each(response.data, function (index, carrera) {
                var isSelected = (carrera.id_carrera == carreraActual);
                $('#inputGroupSelectCarrera').append(
                    $('<option>', {
                        value: carrera.id_carrera,
                        text: carrera.nombre,
                        selected: isSelected
                    })
                );
            });

            // Reinicializar Select2 con el dropdownParent si se proporciona
            if (dropdownParent) {
                $('#inputGroupSelectCarrera').select2('destroy');
                inicializarSelect2Carrera(dropdownParent);
            }

            // Si hay una carrera actual, seleccionarla
            if (carreraActual && carreraActual !== '0') {
                $('#inputGroupSelectCarrera').val(carreraActual).trigger('change');
            }

            $('#inputGroupSelectCarrera').trigger('change.select2');
        },

        error: (xhr) => {
            showAlert("Error", `Error al conectar con el servidor (Carreras): ${xhr.statusText}`, "error");
        }
    });
}
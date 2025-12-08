$(document).ready(function () {
    cargarAreas();
});

function inicializarSelect2Area(dropdownParent = null) {
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

    $('#inputGroupSelectArea').select2(config);
}

function cargarAreas(dropdownParent = null) {
    var areaActual = $("#fk_area_activa").val();

    jQuery.ajax({
        url: "/Catalogos/GetAreaConocimiento",
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {
            $('#inputGroupSelectArea').empty()
                .append('<option value="">Seleccione un área...</option>');

            $.each(response.data, function (index, area) {
                var isSelected = (area.id_area == areaActual);
                $('#inputGroupSelectArea').append(
                    $('<option>', {
                        value: area.id_area,
                        text: area.nombre,
                        selected: isSelected
                    })
                );
            });

            // Si hay una area actual, seleccionarla
            if (areaActual && areaActual !== '0') {
                $('#inputGroupSelectArea').val(areaActual).trigger('change');
            }

            // Reinicializar Select2 con el dropdownParent si se proporciona
            if (dropdownParent) {
                $('#inputGroupSelectArea').select2('destroy');
                inicializarSelect2Area(dropdownParent);
            }

            $('#inputGroupSelectArea').trigger('change.select2');
        },

        error: (xhr) => {
            showAlert("Error", `Error al conectar con el servidor (GetAreas): ${xhr.statusText}`, "error");
        }
    });
}
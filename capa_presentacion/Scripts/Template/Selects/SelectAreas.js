$(document).ready(function () {
    inicializarSelect2Area();
    cargarAreas();
});

function inicializarSelect2Area() {
    $('#inputGroupSelectArea').select2({
        placeholder: "Buscar ...",
        allowClear: true,
        language: {
            noResults: function () {
                return "No se encontraron resultados";
            }
        }
    });
}

function cargarAreas() {
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

            $('#inputGroupSelectArea').trigger('change.select2');
        },

        error: (xhr) => {
            showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
        }
    });
}
$(document).ready(function () {
    inicializarSelect2Carrera();
    cargarCarreras();
});

function inicializarSelect2Carrera() {
    $('#inputGroupSelectCarrera').select2({
        placeholder: "Buscar carrera...",
        allowClear: true,
        language: {
            noResults: function () {
                return "No se encontraron resultados";
            }
        }
    });
}

function cargarCarreras() {
    var carreraActual = $("#fk_carrera_activa").val();

    jQuery.ajax({
        url: "/Catalogos/ListarCarreras",
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

            // Si hay una carrera actual, seleccionarla
            if (carreraActual && carreraActual !== '0') {
                $('#inputGroupSelectCarrera').val(carreraActual).trigger('change');
            }

            $('#inputGroupSelectCarrera').trigger('change.select2');
        },

        error: (xhr) => {
            showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
        }
    });
}
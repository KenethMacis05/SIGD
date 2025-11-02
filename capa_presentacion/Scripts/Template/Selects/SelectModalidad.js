$(document).ready(function () {
    inicializarSelect2Modalidad();
    cargarModalidades();
});

function inicializarSelect2Modalidad() {
    $('#inputGroupSelectModalidad').select2({
        placeholder: "Buscar ...",
        allowClear: true,
        language: {
            noResults: function () {
                return "No se encontraron resultados";
            }
        }
    });
}

function cargarModalidades() {
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

            // Si hay una modalidad actual, seleccionarla
            if (modalidadActual && modalidadActual !== '0') {
                $('#inputGroupSelectModalidad').val(modalidadActual).trigger('change');
            }

            $('#inputGroupSelectModalidad').trigger('change.select2');
        },

        error: (xhr) => {
            showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
        }
    });
}
$(document).ready(function () {
    inicializarSelect2Asignatura();
    cargarAsignaturas();
});

function inicializarSelect2Asignatura() {
    $('#inputGroupSelectAsignatura').select2({
        placeholder: "Buscar asignatura...",
        allowClear: true,
        language: {
            noResults: function () {
                return "No se encontraron resultados";
            }
        }
    });
}

function cargarAsignaturas() {
    var asignaturaActual = $("#fk_asignatura_activa").val();

    jQuery.ajax({
        url: "/Catalogos/ListarAsignaturas",
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {
            $('#inputGroupSelectAsignatura').empty()
                .append('<option value="">Seleccione una asignatura...</option>');

            $.each(response.data, function (index, asignatura) {
                var isSelected = (asignatura.id_asignatura == asignaturaActual);
                $('#inputGroupSelectAsignatura').append(
                    $('<option>', {
                        value: asignatura.id_asignatura,
                        text: asignatura.nombre,
                        selected: isSelected
                    })
                );
            });

            // Si hay una asignatura actual, seleccionarla
            if (asignaturaActual && asignaturaActual !== '0') {
                $('#inputGroupSelectAsignatura').val(asignaturaActual).trigger('change');
            }

            $('#inputGroupSelectAsignatura').trigger('change.select2');
        },

        error: (xhr) => {
            showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
        }
    });
}
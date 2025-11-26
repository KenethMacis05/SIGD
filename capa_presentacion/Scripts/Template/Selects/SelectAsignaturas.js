$(document).ready(function () {
    inicializarSelect2Asignatura();
    cargarAsignaturas(true);
});

// Inicializa select2
function inicializarSelect2Asignatura(dropdownParent = null) {
    var config = {
        placeholder: "Buscar asignatura...",
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

    $('#inputGroupSelectAsignatura').select2(config);
}

function cargarAsignaturas(soloIntegradoras, dropdownParent = null) {
    var asignaturaActual = $("#fk_asignatura_activa").val();
    var url = "/Catalogos/ListarAsignaturas";
    if (soloIntegradoras) {
        url += "?soloIntegradoras=true";
    }

    jQuery.ajax({
        url: url,
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

            // Reinicializar Select2 con el dropdownParent si se proporciona
            if (dropdownParent) {
                $('#inputGroupSelectAsignatura').select2('destroy');
                inicializarSelect2Asignatura(dropdownParent);
            }

            if (asignaturaActual && asignaturaActual !== '0') {
                $('#inputGroupSelectAsignatura').val(asignaturaActual).trigger('change');
            }

            $('#inputGroupSelectAsignatura').trigger('change.select2');
        },

        error: (xhr) => {
            showAlert("Error", `Error al conectar con el servidor (Asignaturas): ${xhr.statusText}`, "error");
        }
    });
}
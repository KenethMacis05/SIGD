$(document).ready(function () {
    cargarPeriodos();
});

function inicializarSelect2Periodo(dropdownParent = null) {
    var config = {
        placeholder: "Buscar periodo...",
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

    $('#inputGroupSelectPeriodo').select2(config);
}

function cargarPeriodos(dropdownParent = null) {
    var periodoActual = $("#fk_periodo_activo").val();

    jQuery.ajax({
        url: "/Catalogos/GetPeriodo",
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {
            $('#inputGroupSelectPeriodo').empty()
                .append('<option value="">Seleccione un periodo...</option>');

            $.each(response.data, function (index, periodo) {
                var isSelected = (periodo.id_periodo == periodoActual);
                $('#inputGroupSelectPeriodo').append(
                    $('<option>', {
                        value: periodo.id_periodo,
                        text: periodo.periodo,
                        selected: isSelected
                    })
                );
            });

            // Reinicializar Select2 con el dropdownParent si se proporciona
            if (dropdownParent) {
                $('#inputGroupSelectPeriodo').select2('destroy');
                inicializarSelect2Periodo(dropdownParent);
            }

            // Si hay un periodo actual, seleccionarlo
            if (periodoActual && periodoActual !== '0') {
                $('#inputGroupSelectPeriodo').val(periodoActual).trigger('change');
            }

            $('#inputGroupSelectPeriodo').trigger('change.select2');
        },

        error: (xhr) => {
            showAlert("Error", `Error al conectar con el servidor (Periodos): ${xhr.statusText}`, "error");
        }
    });
}
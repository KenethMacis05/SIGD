$(document).ready(function () {
    inicializarSelect2Periodo();
    cargarPeriodos();
});

function inicializarSelect2Periodo() {
    $('#inputGroupSelectPeriodo').select2({
        placeholder: "Buscar periodo...",
        allowClear: true,
        language: {
            noResults: function () {
                return "No se encontraron resultados";
            }
        }
    });
}

function cargarPeriodos() {
    var periodoActual = $("#fk_periodo_activo").val();

    jQuery.ajax({
        url: "/Catalogos/ListarPeriodos",
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
                        text: periodo.anio + " || " + periodo.semestre,
                        selected: isSelected
                    })
                );
            });

            // Si hay una periodo actual, seleccionarla
            if (periodoActual && periodoActual !== '0') {
                $('#inputGroupSelectPeriodo').val(periodoActual).trigger('change');
            }

            $('#inputGroupSelectPeriodo').trigger('change.select2');
        },

        error: (xhr) => {
            showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
        }
    });
}
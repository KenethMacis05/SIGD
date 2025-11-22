$(document).ready(function () {
    inicializarSelect2Temas();
    cargarTemas();
});

function inicializarSelect2Temas() {
    $('#inputGroupSelectTemas').select2({
        placeholder: "Buscar ...",
        allowClear: true,
        language: {
            noResults: function () {
                return "No se encontraron resultados";
            }
        }
    });
}

function cargarTemas() {
    var temaActual = $("#fk_tema_activo").val();
    var idEncriptado = $("#idEncriptadoPlanSemestral").val();

    jQuery.ajax({
        url: "/Planificacion/ListarTemasPlanSemestral",
        data: { idEncriptado : idEncriptado},
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {
            $('#inputGroupSelectTemas').empty()
                .append('<option value="">Seleccione un tema...</option>');

            $.each(response.data, function (index, tema) {
                var isSelected = (tema.id_tema == temaActual);
                $('#inputGroupSelectTemas').append(
                    $('<option>', {
                        value: tema.id_tema,
                        text: tema.tema,
                        selected: isSelected
                    })
                );
            });

            // Si hay una tema actual, seleccionarlo
            if (temaActual && temaActual !== '0') {
                $('#inputGroupSelectTemas').val(temaActual).trigger('change');
            }

            $('#inputGroupSelectTemas').trigger('change.select2');
        },

        error: (xhr) => {
            showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
        }
    });
}
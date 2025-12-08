$(document).ready(function () {
    inicializarSelect2ContenidosSemana();
    cargarContenidosSemana();
});

function inicializarSelect2ContenidosSemana() {
    $('#inputGroupSelectContenido').select2({
        placeholder: "Debe seleccionar la semana de los contenido(s) a trabajar...",
        allowClear: true,
        language: {
            noResults: function () {
                return "No se encontraron resultados";
            }
        }
    });
}

function cargarContenidosSemana() {
    var contenidoActual = $("#fk_plan_individual_activo").val();
    var idEncriptado = $("#idEncriptadoPlanSemestral").val();

    jQuery.ajax({
        url: "/Planificacion/ListarPlanificacionIndividual",
        data: { idEncriptado: idEncriptado },
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {
            $('#inputGroupSelectContenido').empty()
                .append('<option value="">Seleccione una semana...</option>');

            $.each(response.data, function (index, contenido) {
                var isSelected = (contenido.id_planificacion == contenidoActual);
                $('#inputGroupSelectContenido').append(
                    $('<option>', {
                        value: contenido.id_planificacion,
                        text: "Contenido(s) de la: " + contenido.SEMANA.descripcion,
                        selected: isSelected
                    })
                );
            });

            // Si hay un contenido actual, seleccionarlo
            if (contenidoActual && contenidoActual !== '0') {
                $('#inputGroupSelectContenido').val(contenidoActual).trigger('change');
            }

            $('#inputGroupSelectContenido').trigger('change.select2');
        },

        error: (xhr) => {
            showAlert("Error", `Error al conectar con el servidor (ContenidosSemanas): ${xhr.statusText}`, "error");
        }
    });
}
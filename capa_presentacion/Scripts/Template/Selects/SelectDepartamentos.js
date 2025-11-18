$(document).ready(function () {
    inicializarSelect2Departamento();
    cargarDepartamentos();
});

function inicializarSelect2Departamento() {
    $('#inputGroupSelectDepartamento').select2({
        placeholder: "Buscar departamento...",
        allowClear: true,
        language: {
            noResults: function () {
                return "No se encontraron resultados";
            }
        }
    });
}

function cargarDepartamentos() {
    var departamentoActual = $("#fk_departamento_activo").val();

    jQuery.ajax({
        url: "/Catalogos/GetDepartamento",
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {
            $('#inputGroupSelectDepartamento').empty()
                .append('<option value="">Seleccione un departamento...</option>');

            $.each(response.data, function (index, departamento) {
                var isSelected = (departamento.id_departamento == departamentoActual);
                $('#inputGroupSelectDepartamento').append(
                    $('<option>', {
                        value: departamento.id_departamento,
                        text: departamento.nombre,
                        selected: isSelected
                    })
                );
            });

            // Si hay una departamento actual, seleccionarla
            if (departamentoActual && departamentoActual !== '0') {
                $('#inputGroupSelectDepartamento').val(departamentoActual).trigger('change');
            }

            $('#inputGroupSelectDepartamento').trigger('change.select2');
        },

        error: (xhr) => {
            showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
        }
    });
}
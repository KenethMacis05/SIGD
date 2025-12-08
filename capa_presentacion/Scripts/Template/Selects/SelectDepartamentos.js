$(document).ready(function () {
    cargarDepartamentos();
});

function inicializarSelect2Departamento(dropdownParent = null) {
    var config = {
        placeholder: "Buscar departamento...",
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

    $('#inputGroupSelectDepartamento').select2(config);
}

function cargarDepartamentos(dropdownParent = null) {
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

            // Reinicializar Select2 con el dropdownParent si se proporciona
            if (dropdownParent) {
                $('#inputGroupSelectDepartamento').select2('destroy');
                inicializarSelect2Departamento(dropdownParent);
            }

            // Si hay un departamento actual, seleccionarlo
            if (departamentoActual && departamentoActual !== '0') {
                $('#inputGroupSelectDepartamento').val(departamentoActual).trigger('change');
            }

            $('#inputGroupSelectDepartamento').trigger('change.select2');
        },

        error: (xhr) => {
            showAlert("Error", `Error al conectar con el servidor (Deparamentos): ${xhr.statusText}`, "error");
        }
    });
}
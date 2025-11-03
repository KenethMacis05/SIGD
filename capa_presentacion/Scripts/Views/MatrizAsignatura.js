function cargarAsignaturasMatriz(idMatriz) {
    $.ajax({
        url: '/Planificacion/ListarMatrizAsignaturaPorId',
        type: 'GET',
        data: { idEncriptado: idMatriz },
        dataType: 'json',
        beforeSend: () => $('#matrizAsignatura').LoadingOverlay("show"),
        success: function (response) {
            if (response.success && response.data && response.data.length > 0) {
                const html = response.data.map(generarHtmlMatrizAsignatura).join("");
                $('#matrizAsignatura').html(html);
            } else {
                $('#matrizAsignatura').html('<div class="alert alert-light text-center">No hay asignaturas asignadas a esta matriz</div>');
            }
        },
        error: function () {
            $('#matrizAsignatura').html('<div class="alert alert-danger text-center">Error al cargar las asignaturas</div>');
        },
        complete: () => $('#matrizAsignatura').LoadingOverlay("hide")
    });
}

function generarHtmlMatrizAsignatura(matrizAsignatura) {
    var color = '';
    var icono = '';

    if (matrizAsignatura.estado === 'Pendiente') {
        color = 'secondary';
        icono = 'fa-play-circle';
    } else if (matrizAsignatura.estado === 'En proceso') {
        color = 'primary';
        icono = 'fa-spinner';
    } else {
        color = 'success';
        icono = 'fa-check-circle';
    }

    // Calcular progreso
    var porcentajeProgreso = matrizAsignatura.total_contenidos > 0
        ? Math.round((matrizAsignatura.contenidos_finalizados / matrizAsignatura.total_contenidos) * 100)
        : 0;

    return `
    <div class="col-sm-12 col-md-6 col-lg-4 mb-3">
        <div class="card h-100 shadow-sm border-1 groud-asignatura estado-${color}">
            <div class="card-header bg-light d-flex justify-content-between align-items-center">
                <span class="badge bg-${color}">${matrizAsignatura.codigo_asignatura}</span>
                <div class="dropdown">
                    <button class="btn btn-sm btn-outline-${color} dropdown-toggle" type="button"
                            data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-ellipsis-v"></i>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li>
                            <a class="dropdown-item btn-editar-asignatura" href="#"
                               data-id="${matrizAsignatura.id_matriz_asignatura}"
                               data-asignatura-fk="${matrizAsignatura.fk_asignatura}"
                               data-profesor-fk="${matrizAsignatura.fk_profesor_asignado}">
                                <i class="fas fa-edit me-2"></i>Editar
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item btn-eliminar-asignatura" href="#"
                               data-id="${matrizAsignatura.id_matriz_asignatura}">
                                <i class="fas fa-trash me-2"></i>Eliminar
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <div class="flex-grow-1 me-3">
                        <h5 class="card-title text-dark mb-2 btn-titulo-asignatura estado-${color}"
                            style="cursor: pointer;"
                            data-id="${matrizAsignatura.id_matriz_asignatura_encriptado}">
                            ${matrizAsignatura.nombre_asignatura}
                        </h5>
                        <div class="d-flex align-items-center">
                            <i class="fas fa-user-graduate text-muted me-2"></i>
                            <small class="text-muted">${matrizAsignatura.nombre_profesor}</small>
                        </div>
                    </div>
                    <div class="text-center">
                        <i class="fas ${icono} fa-lg fa-2x text-${color}" title="${matrizAsignatura.estado}"></i>
                        <div class="small text-${color} fw-bold mt-1">${matrizAsignatura.estado}</div>
                    </div>
                </div>
                
                <!-- Progreso de semanas -->
                <div class="mb-3">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <small class="text-muted">Progreso de semanas</small>
                    </div>
                    <div class="progress" style="height: 8px;">
                        <div class="progress-bar bg-${color}" 
                             role="progressbar" 
                             style="width: ${porcentajeProgreso}%;" 
                             aria-valuenow="${porcentajeProgreso}" 
                             aria-valuemin="0" 
                             aria-valuemax="100">
                        </div>
                    </div>
                    <small class="text-muted fw-bold"> Contenidos finalizados: ${matrizAsignatura.contenidos_finalizados}/ Total de contenidos:${matrizAsignatura.total_contenidos} (${porcentajeProgreso}%)</small>
                </div>
                
                <hr>
                <div class="d-flex align-items-center">
                    <i class="fas fa-envelope text-muted me-2"></i>
                    <small class="text-muted">${matrizAsignatura.correo_profesor || 'Sin correo'}</small>
                </div>
            </div>
        </div>
    </div>`;
}

// Ir a la pantalla de los contenidos de la asignatura:
$(document).on('click', '.btn-titulo-asignatura', function (e) {
    e.preventDefault();
    const idEncriptado = $(this).data('id');
    window.location.href = '/Planificacion/Contenidos?idEncriptado=' + idEncriptado;
});

// Listar usuarios a asignar en el select2
$.ajax({
    url: '/Usuario/ListarUsuarios',
    type: "GET",
    dataType: "json",
    contentType: "application/json; charset=utf-8",
    success: function (response) {

        // Limpiar y poblar el select para el modal de Asignar
        $('#profesores').empty();
        $('#profesores').append('<option value="">Selecciona un docente</option>');
        $.each(response.data, function (index, usuario) {
            $('#profesores').append(
                `<option value="${usuario.id_usuario}">
                    ${usuario.pri_nombre} ${usuario.pri_apellido} (${usuario.correo})
                </option>`);
        });

        // Inicializar Select2 para el modal de Asignar
        $('#profesores').select2({
            placeholder: 'Selecciona un docente',
            width: '100%',
            theme: "classic",
            minimumResultsForSearch: 5,
            dropdownParent: $('#asignarAsignatura'),
            language: {
                noResults: function () {
                    return "No se encontraron resultados";
                },
                searching: function () {
                    return "Buscando...";
                }
            },
            minimumInputLength: 0,
        });
    },
    error: (xhr) => {
        showAlert("Error", `Error al conectar con el servidor Listar Usuarios: ${xhr.statusText}`, "error");
    }
});

// Listar asignaturas a asignar en el select2
$.ajax({
    url: '/Catalogos/ListarAsignaturas',
    type: "GET",
    dataType: "json",
    contentType: "application/json; charset=utf-8",
    success: function (response) {

        // Limpiar y poblar el select para el modal de Asignar
        $('#asignaturas').empty();
        $('#asignaturas').append('<option value="">Selecciona una asignatura</option>');
        $.each(response.data, function (index, asignatura) {
            $('#asignaturas').append(
                `<option value="${asignatura.id_asignatura}">
                    ${asignatura.nombre}
                </option>`);
        });

        // Inicializar Select2 para el modal de Asignar
        $('#asignaturas').select2({
            placeholder: 'Selecciona una asignatura',
            width: '100%',
            theme: "classic",
            minimumResultsForSearch: 5,
            dropdownParent: $('#asignarAsignatura'),
            language: {
                noResults: function () {
                    return "No se encontraron resultados";
                },
                searching: function () {
                    return "Buscando...";
                }
            },
            minimumInputLength: 0,
        });
    },
    error: (xhr) => {
        showAlert("Error", `Error al conectar con el servidor Listar Asignaturas: ${xhr.statusText}`, "error");
    }
});

//Abrir modal
function abrirModal(json) {
    $("#idMatrisAsignatura").val("0");

    // Limpiar los select2
    $('#asignaturas').val(null).trigger('change');
    $('#profesores').val(null).trigger('change');

    if (json !== null) {
        $("#idMatrisAsignatura").val(json.id_matriz_asignatura);

        // Usar los métodos de Select2 para establecer los valores
        if (json.fk_asignatura) {
            $('#asignaturas').val(json.fk_asignatura).trigger('change');
        }
        if (json.fk_profesor_asignado) {
            $('#profesores').val(json.fk_profesor_asignado).trigger('change');
        }
    }
    $("#asignarAsignatura").modal("show");
}

// Seleccionar los datos para editar
$(document).on('click', '.btn-editar-asignatura', function (e) {
    e.preventDefault();
    const data = {
        id_matriz_asignatura: $(this).data('id'),
        fk_asignatura: $(this).data('asignatura-fk'),
        fk_profesor_asignado: $(this).data('profesor-fk'),
    };
    abrirModal(data);
});

function asignarAsignatura() {

    var Matriz = {
        id_matriz_asignatura: $("#idMatrisAsignatura").val().trim(),
        fk_matriz_integracion: $("#fkMatrisIntegracion").val().trim(),
        fk_matriz_integracion_encriptado: $("#fkMatrisIntegracionEncriptada").val().trim(),
        fk_asignatura: $("#asignaturas").val().trim(),
        fk_profesor_asignado: $("#profesores").val().trim(),
    };

    showLoadingAlert("Procesando", "Guardando asignaturas a la matriz...");

    jQuery.ajax({
        url: '/Planificacion/GuardarAsignaturasMatriz',
        type: "POST",
        data: JSON.stringify({ matriz: Matriz }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            Swal.close();
            $("#asignarAsignatura").modal("hide");


            if (data.Resultado || data.Respuesta) {
                const mensaje = data.Mensaje || (Matriz.id_matriz_asignatura == 0 ? "Asignatura asignada correctamente" : "Asignatura actualizada correctamente");
                showAlert("¡Éxito!", mensaje, "success");

                cargarAsignaturasMatriz(Matriz.fk_matriz_integracion_encriptado);

                // Limpiar formulario
                $("#idMatrisAsignatura").val("0");
                $("#asignaturas").val(null).trigger('change');
                $("#profesores").val(null).trigger('change');
            }
            else {
                const mensaje = data.Mensaje || (Matriz.id_matriz_asignatura == 0 ? "No se pudo crear la carpeta" : "No se pudo actualizar la carpeta");
                showAlert("Error", mensaje, "error");
            }

        },
        error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
    });
}

// Eliminar carpeta
$(document).on('click', '.btn-eliminar-asignatura', function (e) {
    e.preventDefault();
    const idMatriz = $(this).data('id');
    console.log("ID Matriz Asignatura a eliminar:", idMatriz);
    confirmarEliminacion().then((result) => {

        if (result.isConfirmed) {
            showLoadingAlert("Eliminando asignatura", "Por favor espere...")

            // Enviar petición AJAX
            $.ajax({
                url: '/Planificacion/EliminarMatrizAsignatura',
                type: "POST",
                data: JSON.stringify({ id_matriz: idMatriz }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        showAlert("¡Eliminado!", response.Mensaje || "Asignatura eliminada correctamente", "success", true);
                        
                        cargarAsignaturasMatriz($("#fkMatrisIntegracionEncriptada").val().trim());
                        
                    } else { showAlert("Error", response.Mensaje || "No se pudo eliminar la asignatura", "error"); }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor Eliminar Asignatura: ${xhr.statusText}`, "error"); }
            });
        }
    });
});
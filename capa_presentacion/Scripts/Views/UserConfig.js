// JS: Vista de configuaración de usuarios
let originalAvatarUrl = document.getElementById('avatarImg').src;

// Función para comprimir imagen
function compressImage(file, callback) {
    const reader = new FileReader();
    reader.onload = function (event) {
        const img = new Image();
        img.src = event.target.result;
        img.onload = function () {
            const canvas = document.createElement('canvas');
            const ctx = canvas.getContext('2d');

            // Tamaño máximo para redimensionar
            const MAX_WIDTH = 800;
            const MAX_HEIGHT = 800;
            let width = img.width;
            let height = img.height;

            // Redimensionar manteniendo aspect ratio
            if (width > height) {
                if (width > MAX_WIDTH) {
                    height *= MAX_WIDTH / width;
                    width = MAX_WIDTH;
                }
            } else {
                if (height > MAX_HEIGHT) {
                    width *= MAX_HEIGHT / height;
                    height = MAX_HEIGHT;
                }
            }

            canvas.width = width;
            canvas.height = height;

            // Dibujar imagen redimensionada
            ctx.drawImage(img, 0, 0, width, height);

            // Convertir a JPEG con calidad del 70% (ajustable)
            callback(canvas.toDataURL('image/jpeg', 0.7));
        };

        // Manejar errores de carga de imagen
        img.onerror = function () {
            console.error("Error al cargar la imagen");
            callback(event.target.result);
        };
    };
    reader.readAsDataURL(file);
}

function previewFoto(event) {
    const input = event.target;
    const saveBtn = document.getElementById('saveFotoBtn');

    if (input.files && input.files[0]) {
        compressImage(input.files[0], function (compressedImage) {
            document.getElementById('avatarImg').src = compressedImage;
            saveBtn.disabled = false;
        });
    }
}

function clearFoto() {
    document.getElementById('avatarImg').src = originalAvatarUrl;
    document.getElementById('fotoPerfil').value = "";
    document.getElementById('saveFotoBtn').disabled = true;
}

function saveFoto() {
    const avatarImg = document.getElementById('avatarImg');
    const imgSrc = avatarImg.src;

    // Verificar si hay cambios válidos para guardar
    if (imgSrc === originalAvatarUrl || imgSrc.startsWith('http')) {
        showAlert("Aviso", "No hay cambios en la imagen para guardar", "info");
        return;
    }

    showLoadingAlert("Procesando", "Subiendo imagen...");
    document.getElementById('saveFotoBtn').disabled = true;

    // Extraer solo el Base64 (sin el prefijo data:image...)
    const base64Data = imgSrc.split(',')[1] || imgSrc;

    jQuery.ajax({
        url: config.actualizarFotoPerfilUrl,
        type: "POST",
        data: JSON.stringify({
            imagenBase64: base64Data,
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            if (data.Respuesta) {
                originalAvatarUrl = imgSrc;
                Swal.fire({
                    title: "Éxito",
                    text: data.Mensaje,
                    icon: "success",
                    timer: 1500,
                    timerProgressBar: true,
                    willClose: () => {
                        window.location.reload();
                    }
                });
            } else {
                avatarImg.src = originalAvatarUrl;
                showAlert("Error", data.Mensaje, "error");
            }
        },
        error: (xhr) => {
            avatarImg.src = originalAvatarUrl;
            showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error");
        }
    });
}

$('#nuevaClave').on('input', function () {
    const password = $(this).val();
    const strengthBar = $('.password-strength');

    strengthBar.removeClass('strength-weak strength-medium strength-strong');

    if (password.length === 0) {
        strengthBar.css('width', '0');
        return;
    }

    let strength = 0;
    if (password.length >= 8) strength++;
    if (/[A-Z]/.test(password)) strength++;
    if (/[0-9]/.test(password)) strength++;
    if (/[^A-Za-z0-9]/.test(password)) strength++;

    if (strength < 2) {
        strengthBar.addClass('strength-weak').css('width', '25%');
    } else if (strength < 4) {
        strengthBar.addClass('strength-medium').css('width', '50%');
    } else {
        strengthBar.addClass('strength-strong').css('width', '100%');
    }
});

document.getElementById('btnActualizarContrasena').onclick = function (e) {
    let form = document.getElementById('resetPasswordForm');
    let isValid = true;

    let requiredInputs = form.querySelectorAll('input[required]');

    requiredInputs.forEach(function (input) {
        input.classList.remove('is-invalid');
        if (input.value.trim() === "") {
            input.classList.add('is-invalid');
            isValid = false;
        }
    });

    let newPassword = form.querySelector('#nuevaClave');
    let confirmPassword = form.querySelector('#claveConfir');
    if (newPassword.value && confirmPassword.value && newPassword.value !== confirmPassword.value) {
        confirmPassword.classList.add('is-invalid');
        confirmPassword.nextElementSibling.textContent = "Las contraseñas no coinciden.";
        isValid = false;
    } else if (confirmPassword.value) {
        confirmPassword.nextElementSibling.textContent = "Por favor, confirma tu nueva contraseña.";
    }

    if (isValid) {
        ActualizarPassword();
    }
};

document.querySelectorAll('#resetPasswordForm input[required]').forEach(function (input) {
    input.addEventListener('input', function () {
        if (this.value.trim() !== "") this.classList.remove('is-invalid');
    });
});

function ActualizarPassword() {
    var claveActual = $("#claveActual").val().trim();
    var nuevaClave = $("#nuevaClave").val().trim();
    var claveConfir = $("#claveConfir").val().trim();

    confirmarAccion().then((result) => {
        if (result.isConfirmed) {
            showLoadingAlert("Procesando", "Actualizando contraseña...");

            $.ajax({
                url: config.actualizarContrasenaUrl,
                type: "POST",
                data: JSON.stringify({
                    claveActual: claveActual,
                    nuevaClave: nuevaClave,
                    claveConfir: claveConfir
                }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",

                success: function (response) {
                    Swal.close();
                    if (response.Respuesta) {
                        showAlert("¡Éxito!", response.Mensaje || "Contraseña actualizada exitosamente", "success", false, true);
                        $("#resetPasswordForm input").val("").removeClass("is-invalid");
                    } else { showAlert("Error", response.Mensaje || "No se pudo actualizar la contraseña", "error") }
                },
                error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
            });
        }
    });
}

function ActualizarDatos(event) {
    event.preventDefault();

    if (!hayCambios()) {
        showAlert("¡Sin cambios!", "No has modificado ningún dato", "info");
        return;
    }

    showLoadingAlert("Procesando", "Guardando datos del usuario...");

    var Usuario = {
        pri_nombre: $("#priNombre").val().trim(),
        seg_nombre: $("#segNombre").val().trim(),
        pri_apellido: $("#priApellido").val().trim(),
        seg_apellido: $("#segApellido").val().trim(),
        usuario: $("#usuario").val().trim(),
        correo: $("#correo").val().trim(),
        telefono: $("#telefono").val().trim(),
        fk_rol: $("#obtenerRol").val().trim(),
    };

    // 5. Enviar datos
    jQuery.ajax({
        url: config.actualizarDatosUsuarioAutUrl,
        type: "POST",
        data: JSON.stringify({ usuario: Usuario }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            if (data.Resultado) {
                actualizarValoresOriginales();
                Swal.fire({
                    title: "¡Éxito!",
                    text: "Datos actualizados correctamente",
                    icon: "success",
                    timer: 1500,
                    timerProgressBar: true,
                    showConfirmButton: false,
                    willClose: () => {
                        window.location.reload();
                    }
                });
            } else { showAlert("¡Error!", data.Mensaje || "No se pudo actualizar los datos", "error"); }
        },
        error: (xhr) => { showAlert("Error", `Error al conectar con el servidor: ${xhr.statusText}`, "error"); }
    });
}

function hayCambios() {
    const campos = ['priNombre', 'segNombre', 'priApellido', 'segApellido', 'correo', 'telefono', 'obtenerRol'];

    return campos.some(campo => {
        const valorActual = $(`#${campo}`).val().trim();
        const valorOriginal = $(`#${campo}`).data('original');
        return valorActual !== valorOriginal;
    });
}

function inicializarValoresOriginales() {
    const campos = ['priNombre', 'segNombre', 'priApellido', 'segApellido', 'correo', 'telefono', 'obtenerRol'];

    campos.forEach(campo => {
        $(`#${campo}`).data('original', $(`#${campo}`).val().trim());
    });
}

function actualizarValoresOriginales() {
    const campos = ['priNombre', 'segNombre', 'priApellido', 'segApellido', 'correo', 'telefono', 'obtenerRol'];

    campos.forEach(campo => {
        $(`#${campo}`).data('original', $(`#${campo}`).val().trim());
    });
}

$(document).ready(function () {
    inicializarValoresOriginales();
    document.getElementById('configUserForm').addEventListener('submit', ActualizarDatos);
});

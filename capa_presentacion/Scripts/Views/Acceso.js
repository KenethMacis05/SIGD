const togglePasswordText = document.getElementById('togglePasswordText');
const passwordInput = document.getElementById('password');
const togglePasswordIcon = document.getElementById('togglePassword');

togglePasswordText.addEventListener('click', function () {
    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
    passwordInput.setAttribute('type', type);

    // Cambiar el texto y el ícono
    if (type === 'password') {
        togglePasswordText.textContent = 'Ver contraseña';
        togglePasswordIcon.innerHTML = '<i class="fas fa-key fs-5"></i>';
    } else {
        togglePasswordText.textContent = 'Ocultar contraseña';
        togglePasswordIcon.innerHTML = '<i class="fas fa-eye-slash fs-5"></i>';
    }
});

// Cambiar el ícono al hacer focus en el input de contraseña
passwordInput.addEventListener('focus', function () {
    togglePasswordIcon.innerHTML = '<i class="fas fa-eye fs-5"></i>';
});

// Cambiar el ícono al perder el focus si la contraseña está oculta
passwordInput.addEventListener('blur', function () {
    if (passwordInput.getAttribute('type') === 'password') {
        togglePasswordIcon.innerHTML = '<i class="fas fa-key fs-5"></i>';
    }
});

$(document).ready(function () {
    // Validación del formulario antes de enviar
    $('#loginForm').submit(function (e) {
        let isValid = true;

        // Validar usuario
        if ($('#usuario').val().trim() === '') {
            isValid = false;
            $('#usuario').addClass('is-invalid');
        } else {
            $('#usuario').removeClass('is-invalid');
        }

        // Validar contraseña
        if ($('#password').val().trim() === '') {
            isValid = false;
            $('#password').addClass('is-invalid');
        } else {
            $('#password').removeClass('is-invalid');
        }

        // Si no pasa las validaciones, no enviar el formulario
        if (!isValid) {
            e.preventDefault();
            return;
        }

        // Diseño del botón de envío al momento de hacer la solicitud
        const $btn = $('#enviarSolicitud');
        const $spinner = $('#spinner');

        // Mostrar spinner y deshabilitar botón
        $btn.prop('disabled', true);
        $spinner.removeClass('d-none');
        $btn.html('<span class="spinner-border spinner-border-sm" role="status"></span> Procesando...');
    });

    function resetButton() {
        const $btn = $('#enviarSolicitud');
        const $spinner = $('#spinner');
        $btn.prop('disabled', false);
        $spinner.addClass('d-none');
        $btn.html('Iniciar Sesión');
    }
})
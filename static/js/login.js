$(document).ready(function() {
    $('#loginForm').on('submit', function(e) {
        e.preventDefault();
        
        const email = $('#email').val();
        const password = $('#password').val();
        
        const btnLogin = $('#btnLogin');
        btnLogin.prop('disabled', true).text('Iniciando sesión...');
        
        $.ajax({
            url: '/personal/loginPersonal',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                email: email,
                password: password
            }),
            success: function(response) {
                mostrarMensaje('Inicio de sesión exitoso. Redirigiendo...', 'exito');
                
                if (response.token) {
                    localStorage.setItem('token', response.token);
                }
                
                setTimeout(function() {
                    window.location.href = response.redirect || '/dashboard';
                }, 1000);
            },
            error: function(xhr) {
                let mensaje = 'Error al iniciar sesión unu';
                
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    mensaje = xhr.responseJSON.message;
                } else if (xhr.status === 401) {
                    mensaje = 'Correo o contraseña incorrectos';
                } else if (xhr.status === 0) {
                    mensaje = 'No se pudo conectar con el servidor';
                }
                
                mostrarMensaje(mensaje, 'error');
                
                btnLogin.prop('disabled', false).text('Iniciar Sesión');
            }
        });
    });
    
    function mostrarMensaje(texto, tipo) {
        const mensaje = $('#mensaje');
        mensaje.removeClass('exito error')
               .addClass(tipo)
               .text(texto)
               .slideDown(300);
        
        if (tipo === 'exito') {
            setTimeout(function() {
                mensaje.slideUp(300);
            }, 5000);
        }
    }
    
    $('#email, #password').on('input', function() {
        $('#mensaje').slideUp(300);
    });
});

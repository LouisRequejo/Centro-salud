// Perfil Management

// Tab Navigation
document.querySelectorAll('.tab-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        const tabName = this.dataset.tab;
        
        // Remove active class from all tabs and contents
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
        
        // Add active class to clicked tab and corresponding content
        this.classList.add('active');
        document.getElementById(`${tabName}-tab`).classList.add('active');
    });
});

// Toggle Password Visibility
document.querySelectorAll('.btn-toggle-password').forEach(btn => {
    btn.addEventListener('click', function() {
        const input = this.previousElementSibling;
        const icon = this.querySelector('i');
        
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    });
});

// Change Password
document.getElementById('changePasswordBtn')?.addEventListener('click', function() {
    const currentPassword = document.getElementById('currentPassword').value;
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    
    // Validation
    if (!currentPassword || !newPassword || !confirmPassword) {
        alert('Por favor complete todos los campos');
        return;
    }
    
    if (newPassword.length < 8) {
        alert('La nueva contraseña debe tener al menos 8 caracteres');
        return;
    }
    
    if (newPassword !== confirmPassword) {
        alert('Las contraseñas no coinciden');
        return;
    }
    
    // Show loading
    this.disabled = true;
    this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Cambiando...';
    
    // Simulate API call
    setTimeout(() => {
        this.disabled = false;
        this.innerHTML = '<i class="fas fa-key"></i> Cambiar Contraseña';
        
        // Clear fields
        document.getElementById('currentPassword').value = '';
        document.getElementById('newPassword').value = '';
        document.getElementById('confirmPassword').value = '';
        
        alert('Contraseña cambiada exitosamente');
        
        // TODO: Make actual API call
    }, 1500);
});

// Save Changes
document.getElementById('saveChangesBtn')?.addEventListener('click', function() {
    const displayName = document.querySelector('.info-section input[type="text"]').value;
    const language = document.querySelector('select[id*="idioma"], .preferences-grid select').value;
    const timezone = document.querySelectorAll('.preferences-grid select')[1].value;
    const theme = document.querySelector('input[name="theme"]:checked').value;
    
    console.log('Saving changes:', { displayName, language, timezone, theme });
    
    // Show loading
    this.disabled = true;
    this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Guardando...';
    
    // Simulate API call
    setTimeout(() => {
        this.disabled = false;
        this.innerHTML = '<i class="fas fa-save"></i> Guardar Cambios';
        
        alert('Cambios guardados exitosamente');
        
        // TODO: Make actual API call
    }, 1500);
});

// Discard Changes
document.getElementById('discardChangesBtn')?.addEventListener('click', function() {
    if (confirm('¿Está seguro de descartar los cambios?')) {
        // Reset form to original values
        location.reload();
    }
});

// Save Notification Preferences
document.getElementById('saveNotificationPrefsBtn')?.addEventListener('click', function() {
    const preferences = {};
    
    document.querySelectorAll('.notification-item').forEach((item, index) => {
        const title = item.querySelector('h4').textContent;
        const checked = item.querySelector('input[type="checkbox"]').checked;
        preferences[title] = checked;
    });
    
    console.log('Saving notification preferences:', preferences);
    
    // Show loading
    this.disabled = true;
    this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Guardando...';
    
    // Simulate API call
    setTimeout(() => {
        this.disabled = false;
        this.innerHTML = '<i class="fas fa-save"></i> Guardar Preferencias';
        
        alert('Preferencias de notificaciones guardadas');
        
        // TODO: Make actual API call
    }, 1500);
});

// Change Avatar
document.querySelector('.avatar-section .btn')?.addEventListener('click', function() {
    // Create file input
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = 'image/*';
    
    input.addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            // Preview image
            const reader = new FileReader();
            reader.onload = function(e) {
                document.querySelector('.avatar-large img').src = e.target.result;
            };
            reader.readAsDataURL(file);
            
            // TODO: Upload to server
            console.log('Uploading avatar:', file.name);
        }
    });
    
    input.click();
});

// Change Email Button
document.querySelector('.btn-link')?.addEventListener('click', function() {
    const newEmail = prompt('Ingrese su nuevo correo electrónico:');
    
    if (newEmail) {
        // Validate email format
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(newEmail)) {
            alert('Por favor ingrese un correo electrónico válido');
            return;
        }
        
        // TODO: Send verification email and update
        console.log('Changing email to:', newEmail);
        alert('Se ha enviado un correo de verificación a ' + newEmail);
    }
});

// Theme Change
document.querySelectorAll('input[name="theme"]').forEach(radio => {
    radio.addEventListener('change', function() {
        const theme = this.value;
        console.log('Theme changed to:', theme);
        
        // TODO: Apply theme immediately (optional)
        if (theme === 'dark') {
            // document.body.classList.add('dark-theme');
        } else if (theme === 'light') {
            // document.body.classList.remove('dark-theme');
        }
    });
});

console.log('Perfil page loaded');

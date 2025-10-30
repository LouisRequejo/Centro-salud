// Sedes Management

// Search functionality
document.getElementById('searchInput')?.addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    const rows = document.querySelectorAll('.sede-row');
    
    rows.forEach(row => {
        const nombre = row.querySelector('td:nth-child(1)').textContent.toLowerCase();
        const direccion = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
        const ciudad = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
        
        if (nombre.includes(searchTerm) || direccion.includes(searchTerm) || ciudad.includes(searchTerm)) {
            row.classList.remove('hidden');
        } else {
            row.classList.add('hidden');
        }
    });
});

// Create new sede
document.getElementById('createSedeBtn')?.addEventListener('click', function() {
    // TODO: Open modal with form to create new sede
    alert('Abrir formulario para crear nueva sede');
});

// View sede in map
document.querySelectorAll('.btn-view').forEach(btn => {
    btn.addEventListener('click', function(e) {
        e.stopPropagation();
        
        const row = this.closest('.sede-row');
        showSedeOnMap(row);
    });
});

// Edit sede
document.querySelectorAll('.btn-edit').forEach(btn => {
    btn.addEventListener('click', function(e) {
        e.stopPropagation();
        
        const row = this.closest('.sede-row');
        const nombre = row.querySelector('td:nth-child(1) strong').textContent;
        
        // TODO: Open modal with form to edit sede
        alert(`Editar sede: ${nombre}`);
    });
});

// Delete sede
document.querySelectorAll('.btn-danger').forEach(btn => {
    btn.addEventListener('click', function(e) {
        e.stopPropagation();
        
        const row = this.closest('.sede-row');
        const nombre = row.querySelector('td:nth-child(1) strong').textContent;
        
        if (confirm(`¿Está seguro de eliminar la sede "${nombre}"?`)) {
            // Animate out
            row.style.opacity = '0';
            row.style.transform = 'translateX(-100%)';
            
            setTimeout(() => {
                row.remove();
                updateStats();
                alert(`Sede "${nombre}" eliminada`);
            }, 300);
        }
    });
});

// Click on row to select
document.querySelectorAll('.sede-row').forEach(row => {
    row.addEventListener('click', function() {
        // Remove selected class from all rows
        document.querySelectorAll('.sede-row').forEach(r => {
            r.classList.remove('selected');
        });
        
        // Add selected class to clicked row
        this.classList.add('selected');
        
        // Show sede on map
        showSedeOnMap(this);
    });
});

// Show sede on map
function showSedeOnMap(row) {
    const nombre = row.querySelector('td:nth-child(1) strong').textContent;
    const direccion = row.querySelector('td:nth-child(2)').textContent;
    const ciudad = row.querySelector('td:nth-child(3)').textContent;
    const estado = row.querySelector('.status-badge').textContent;
    const lat = row.dataset.lat;
    const lng = row.dataset.lng;
    
    // Update map details
    document.getElementById('selectedSedeName').textContent = nombre;
    document.getElementById('selectedSedeAddress').textContent = direccion;
    document.getElementById('selectedSedeCity').textContent = ciudad;
    document.getElementById('selectedSedeStatus').textContent = estado;
    
    // Update map iframe
    const mapFrame = document.getElementById('mapFrame');
    mapFrame.src = `https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3976.5!2d${lng}!3d${lat}!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zM8KwNDInMzguNCJOIDc0wrAwNCczMi4wIlc!5e0!3m2!1sen!2s!4v1234567890`;
    
    // Show map content and hide placeholder
    document.querySelector('.map-placeholder').classList.add('hidden');
    document.getElementById('mapContent').classList.remove('hidden');
    
    console.log('Showing sede on map:', { nombre, lat, lng });
}

// Close map
document.getElementById('closeMapBtn')?.addEventListener('click', function() {
    document.querySelector('.map-placeholder').classList.remove('hidden');
    document.getElementById('mapContent').classList.add('hidden');
    
    // Remove selected from all rows
    document.querySelectorAll('.sede-row').forEach(r => {
        r.classList.remove('selected');
    });
});

// View all sedes on map
document.getElementById('viewAllSedesBtn')?.addEventListener('click', function() {
    // TODO: Show all sedes on a map with markers
    alert('Mostrar todas las sedes en el mapa');
    
    // For demo, show the first sede
    const firstRow = document.querySelector('.sede-row');
    if (firstRow) {
        showSedeOnMap(firstRow);
    }
});

// Get directions
document.getElementById('getDirectionsBtn')?.addEventListener('click', function() {
    const row = document.querySelector('.sede-row.selected');
    
    if (!row) {
        alert('Por favor seleccione una sede');
        return;
    }
    
    const lat = row.dataset.lat;
    const lng = row.dataset.lng;
    const nombre = row.querySelector('td:nth-child(1) strong').textContent;
    
    // Open Google Maps in new tab
    const url = `https://www.google.com/maps/dir/?api=1&destination=${lat},${lng}`;
    window.open(url, '_blank');
    
    console.log('Getting directions to:', nombre);
});

// Update statistics
function updateStats() {
    const total = document.querySelectorAll('.sede-row').length;
    const activas = document.querySelectorAll('.status-activa').length;
    const mantenimiento = document.querySelectorAll('.status-mantenimiento').length;
    const inactivas = document.querySelectorAll('.status-inactiva').length;
    
    const statItems = document.querySelectorAll('.stat-item');
    statItems[0].querySelector('.stat-value').textContent = total;
    statItems[1].querySelector('.stat-value').textContent = activas;
    statItems[2].querySelector('.stat-value').textContent = mantenimiento;
    statItems[3].querySelector('.stat-value').textContent = inactivas;
}

console.log('Sedes page loaded');

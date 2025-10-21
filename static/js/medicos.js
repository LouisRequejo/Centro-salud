// Menu Toggle for Mobile
document.getElementById('menuToggle').addEventListener('click', function() {
    document.querySelector('.sidebar').classList.toggle('active');
});

// Search Functionality
document.getElementById('searchInput').addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    const doctorCards = document.querySelectorAll('.doctor-card');
    
    doctorCards.forEach(card => {
        const doctorName = card.querySelector('.doctor-name').textContent.toLowerCase();
        const doctorSpecialty = card.querySelector('.doctor-specialty').textContent.toLowerCase();
        const doctorEmail = card.querySelector('.info-item:nth-child(1) span').textContent.toLowerCase();
        
        if (doctorName.includes(searchTerm) || 
            doctorSpecialty.includes(searchTerm) || 
            doctorEmail.includes(searchTerm)) {
            card.classList.remove('hidden');
        } else {
            card.classList.add('hidden');
        }
    });
    
    updateResultsCount();
});

// Specialty Filter
document.querySelectorAll('.filter-tag').forEach(tag => {
    tag.addEventListener('click', function() {
        // Remove active class from all tags
        document.querySelectorAll('.filter-tag').forEach(t => t.classList.remove('active'));
        
        // Add active class to clicked tag
        this.classList.add('active');
        
        const specialty = this.dataset.specialty;
        const doctorCards = document.querySelectorAll('.doctor-card');
        
        doctorCards.forEach(card => {
            if (specialty === 'all' || card.dataset.specialty === specialty) {
                card.classList.remove('hidden');
            } else {
                card.classList.add('hidden');
            }
        });
        
        updateResultsCount();
    });
});

// Status Filter
document.getElementById('statusFilter').addEventListener('change', function(e) {
    const status = e.target.value;
    const doctorCards = document.querySelectorAll('.doctor-card');
    
    doctorCards.forEach(card => {
        if (status === 'all' || card.dataset.status === status) {
            card.classList.remove('hidden');
        } else {
            card.classList.add('hidden');
        }
    });
    
    updateResultsCount();
});

// Update results count (optional)
function updateResultsCount() {
    const visibleCards = document.querySelectorAll('.doctor-card:not(.hidden)').length;
    console.log(`Mostrando ${visibleCards} médicos`);
}

// Doctor Card Actions
document.querySelectorAll('.btn-details').forEach(btn => {
    btn.addEventListener('click', function(e) {
        e.preventDefault();
        const card = this.closest('.doctor-card');
        const doctorName = card.querySelector('.doctor-name').textContent;
        
        // TODO: Implement modal or redirect to details page
        alert(`Ver detalles de: ${doctorName}`);
        // window.location.href = '/medicos/detalle/1';
    });
});

document.querySelectorAll('.btn-credentials').forEach(btn => {
    btn.addEventListener('click', function(e) {
        e.preventDefault();
        const card = this.closest('.doctor-card');
        const doctorName = card.querySelector('.doctor-name').textContent;
        
        // TODO: Implement modal or redirect to credentials page
        alert(`Ver credenciales de: ${doctorName}`);
        // window.location.href = '/medicos/credenciales/1';
    });
});

document.querySelectorAll('.btn-validate').forEach(btn => {
    btn.addEventListener('click', function(e) {
        e.preventDefault();
        const card = this.closest('.doctor-card');
        const doctorName = card.querySelector('.doctor-name').textContent;
        
        // TODO: Implement validation confirmation dialog
        if (confirm(`¿Desea validar las credenciales de ${doctorName}?`)) {
            // Make API call to validate doctor
            console.log('Validando médico...');
            
            // Update status badge
            const statusBadge = card.querySelector('.status-badge');
            statusBadge.className = 'status-badge status-validado';
            statusBadge.innerHTML = '<i class="fas fa-check-circle"></i> Validado';
            
            // Update card dataset
            card.dataset.status = 'validado';
            
            // Replace validate button with credentials button
            this.className = 'btn btn-outline btn-credentials';
            this.innerHTML = '<i class="fas fa-certificate"></i> Ver Credenciales';
            
            // Show success message
            alert(`${doctorName} ha sido validado correctamente`);
        }
    });
});

// Add Doctor Button
document.getElementById('addDoctorBtn').addEventListener('click', function() {
    // TODO: Open modal or redirect to add doctor form
    alert('Abrir formulario para agregar nuevo médico');
    // window.location.href = '/medicos/nuevo';
});

// Pagination
document.querySelectorAll('.pagination-number').forEach(btn => {
    btn.addEventListener('click', function() {
        // Remove active class from all numbers
        document.querySelectorAll('.pagination-number').forEach(n => n.classList.remove('active'));
        
        // Add active class to clicked number
        this.classList.add('active');
        
        // TODO: Load corresponding page data
        const pageNumber = this.textContent;
        console.log(`Cargando página ${pageNumber}`);
        
        // Scroll to top
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
});

// Close sidebar when clicking outside on mobile
document.addEventListener('click', function(e) {
    const sidebar = document.querySelector('.sidebar');
    const menuToggle = document.getElementById('menuToggle');
    
    if (window.innerWidth <= 768 && 
        sidebar.classList.contains('active') && 
        !sidebar.contains(e.target) && 
        e.target !== menuToggle) {
        sidebar.classList.remove('active');
    }
});

// Handle window resize
window.addEventListener('resize', function() {
    if (window.innerWidth > 768) {
        document.querySelector('.sidebar').classList.remove('active');
    }
});

// Initialize page
document.addEventListener('DOMContentLoaded', function() {
    console.log('Página de Gestión de Médicos cargada');
    updateResultsCount();
});

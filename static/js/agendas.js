// Agendas Management

// Calendar Navigation
let currentDate = new Date(2025, 9, 20); // October 20, 2025

document.getElementById('prevMonth')?.addEventListener('click', function() {
    currentDate.setMonth(currentDate.getMonth() - 1);
    updateCalendar();
});

document.getElementById('nextMonth')?.addEventListener('click', function() {
    currentDate.setMonth(currentDate.getMonth() + 1);
    updateCalendar();
});

function updateCalendar() {
    const monthNames = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
                        'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    
    const monthTitle = document.getElementById('currentMonth');
    if (monthTitle) {
        monthTitle.textContent = `${monthNames[currentDate.getMonth()]} ${currentDate.getFullYear()}`;
    }
    
    // TODO: Regenerate calendar days based on currentDate
    console.log('Calendar updated:', currentDate);
}

// Calendar Day Click
document.querySelectorAll('.calendar-day:not(.other-month)').forEach(day => {
    day.addEventListener('click', function() {
        // Remove active class from all days
        document.querySelectorAll('.calendar-day').forEach(d => d.classList.remove('active'));
        
        // Add active class to clicked day (unless it's today)
        if (!this.classList.contains('today')) {
            this.classList.add('active');
        }
        
        const dayNumber = this.textContent.trim();
        console.log(`Selected day: ${dayNumber}`);
        
        // TODO: Filter appointments by selected date
    });
});

// Filters
document.getElementById('doctorFilter')?.addEventListener('change', function(e) {
    const doctor = e.target.value;
    console.log('Filter by doctor:', doctor);
    // TODO: Filter appointments table
});

document.getElementById('especialidadFilter')?.addEventListener('change', function(e) {
    const especialidad = e.target.value;
    console.log('Filter by especialidad:', especialidad);
    // TODO: Filter appointments table
});

document.getElementById('estadoFilter')?.addEventListener('change', function(e) {
    const estado = e.target.value;
    console.log('Filter by estado:', estado);
    // TODO: Filter appointments table
});

document.getElementById('fechaFilter')?.addEventListener('change', function(e) {
    const fecha = e.target.value;
    console.log('Filter by fecha:', fecha);
    // TODO: Filter appointments table and update calendar
});

// Nueva Cita Button
document.getElementById('nuevaCitaBtn')?.addEventListener('click', function() {
    // TODO: Open modal to create new appointment
    alert('Abrir formulario para crear nueva cita');
});

// Action Buttons
document.querySelectorAll('.btn-icon').forEach(btn => {
    btn.addEventListener('click', function(e) {
        e.stopPropagation();
        const row = this.closest('tr');
        const citaId = row.querySelector('td strong').textContent;
        
        if (this.querySelector('.fa-eye')) {
            console.log('Ver detalles de cita:', citaId);
            // TODO: Show appointment details modal
            alert(`Ver detalles de cita ${citaId}`);
        } else if (this.querySelector('.fa-edit')) {
            console.log('Editar cita:', citaId);
            // TODO: Open edit appointment modal
            alert(`Editar cita ${citaId}`);
        } else if (this.querySelector('.fa-times')) {
            console.log('Cancelar cita:', citaId);
            // TODO: Confirm and cancel appointment
            if (confirm(`¿Está seguro de cancelar la cita ${citaId}?`)) {
                alert(`Cita ${citaId} cancelada`);
                // Update status badge
                const badge = row.querySelector('.status-badge');
                badge.className = 'status-badge status-cancelado';
                badge.textContent = 'Cancelado';
            }
        }
    });
});

// Table Row Click
document.querySelectorAll('.appointments-table tbody tr').forEach(row => {
    row.addEventListener('click', function() {
        // Remove active class from all rows
        document.querySelectorAll('.appointments-table tbody tr').forEach(r => {
            r.style.backgroundColor = '';
        });
        
        // Highlight selected row
        this.style.backgroundColor = '#e3f2fd';
        
        const citaId = this.querySelector('td strong').textContent;
        console.log('Selected appointment:', citaId);
    });
});

console.log('Agendas page loaded');

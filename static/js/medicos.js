document.addEventListener('DOMContentLoaded', function() {
    let allDoctors = [];
    let filteredDoctors = [];
    
    const doctorsGrid = document.getElementById('doctorsGrid');
    const loadingIndicator = document.getElementById('loading-indicator');
    const errorMessage = document.getElementById('error-message');
    const errorText = document.getElementById('error-text');
    const retryBtn = document.getElementById('retryBtn');
    const searchInput = document.getElementById('searchInput');
    const statusFilter = document.getElementById('statusFilter');
    const addDoctorBtn = document.getElementById('addDoctorBtn');
    
    const specialtyIcons = {
        'Cardiología': 'fa-heart',
        'Pediatría': 'fa-baby',
        'Medicina General': 'fa-stethoscope',
        'Traumatología': 'fa-bone',
        'Dermatología': 'fa-user-md',
        'Ginecología': 'fa-female',
        'Oftalmología': 'fa-eye',
        'Neurología': 'fa-brain',
        'default': 'fa-user-md'
    };
    
    const stateMap = {
        'A': { text: 'Activo', class: 'status-activo', icon: 'fa-check-circle' },
        'P': { text: 'Pendiente', class: 'status-pendiente', icon: 'fa-clock' },
        'V': { text: 'Validado', class: 'status-validado', icon: 'fa-check-circle' }
    };
    
    function generateDoctorCard(doctor) {
        const fullName = `${doctor.nombres} ${doctor.ape_paterno} ${doctor.ape_materno || ''}`.trim();
        const specialty = doctor.especialidad || 'Sin Especialidad';
        const specialtyIcon = specialtyIcons[specialty] || specialtyIcons['default'];
        const state = stateMap[doctor.estado] || { text: 'Desconocido', class: 'status-pendiente', icon: 'fa-question' };
        const avatarUrl = `https://ui-avatars.com/api/?name=${encodeURIComponent(fullName)}&background=1976d2&color=fff`;
        
        return `
            <div class="doctor-card" data-id="${doctor.id}" data-specialty="${specialty.toLowerCase().replace(/ /g, '-')}" data-status="${state.class.replace('status-', '')}">
                <div class="card-header">
                    <div class="doctor-avatar">
                        <img src="${avatarUrl}" alt="${fullName}">
                    </div>
                    <span class="status-badge ${state.class}">
                        <i class="fas ${state.icon}"></i>
                        ${state.text}
                    </span>
                </div>
                <div class="card-body">
                    <h3 class="doctor-name">Dr(a). ${fullName}</h3>
                    <p class="doctor-specialty">
                        <i class="fas ${specialtyIcon}"></i>
                        ${specialty}
                    </p>
                    <div class="doctor-info">
                        <div class="info-item">
                            <i class="fas fa-envelope"></i>
                            <span>${doctor.email || 'No registrado'}</span>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-phone"></i>
                            <span>${doctor.telefono || 'No registrado'}</span>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-id-card"></i>
                            <span>DNI: ${doctor.DNI || 'No registrado'}</span>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <button class="btn btn-secondary btn-details" data-id="${doctor.id}">
                        <i class="fas fa-eye"></i>
                        Ver Detalles
                    </button>
                    ${doctor.estado === 'V' ? `
                        <button class="btn btn-outline btn-credentials" data-id="${doctor.id}">
                            <i class="fas fa-certificate"></i>
                            Ver Credenciales
                        </button>
                    ` : `
                        <button class="btn btn-primary btn-validate" data-id="${doctor.id}">
                            <i class="fas fa-check"></i>
                            Validar
                        </button>
                    `}
                </div>
            </div>
        `;
    }
    
    function renderDoctors(doctors) {
        if (doctors.length === 0) {
            doctorsGrid.innerHTML = '<div class="error-message" style="grid-column: 1 / -1;"><i class="fas fa-user-md-slash"></i><p>No se encontraron médicos</p></div>';
            return;
        }
        doctorsGrid.innerHTML = doctors.map(doctor => generateDoctorCard(doctor)).join('');
        updateResultsCount();
    }
    
    function updateResultsCount() {
        const resultsCount = document.getElementById('resultsCount');
        if (resultsCount) {
            resultsCount.textContent = `${filteredDoctors.length} médico(s) encontrado(s)`;
        }
    }
    
    async function loadDoctors() {
        try {
            loadingIndicator.style.display = 'flex';
            errorMessage.style.display = 'none';
            doctorsGrid.style.display = 'none';
            
            const response = await fetch('/medico/listar');
            const data = await response.json();
            
            if (!response.ok || !data.status) {
                throw new Error(data.message || 'Error al cargar los médicos');
            }
            
            allDoctors = data.data || [];
            filteredDoctors = [...allDoctors];
            
            loadingIndicator.style.display = 'none';
            doctorsGrid.style.display = 'grid';
            renderDoctors(filteredDoctors);
            
        } catch (error) {
            console.error('Error:', error);
            loadingIndicator.style.display = 'none';
            errorMessage.style.display = 'block';
            errorText.textContent = error.message || 'Error al cargar los médicos';
        }
    }
    
    function applyFilters() {
        const searchTerm = searchInput ? searchInput.value.toLowerCase() : '';
        const statusValue = statusFilter ? statusFilter.value : 'all';
        
        filteredDoctors = allDoctors.filter(doctor => {
            const fullName = `${doctor.nombres} ${doctor.ape_paterno} ${doctor.ape_materno || ''}`.toLowerCase();
            const specialty = (doctor.especialidad || '').toLowerCase();
            const email = (doctor.email || '').toLowerCase();
            const matchesSearch = !searchTerm || fullName.includes(searchTerm) || specialty.includes(searchTerm) || email.includes(searchTerm);
            
            let matchesStatus = true;
            if (statusValue !== 'all') {
                const stateClass = stateMap[doctor.estado]?.class.replace('status-', '') || '';
                matchesStatus = stateClass === statusValue;
            }
            
            return matchesSearch && matchesStatus;
        });
        
        renderDoctors(filteredDoctors);
    }
    
    if (doctorsGrid) {
        doctorsGrid.addEventListener('click', function(e) {
            const button = e.target.closest('button');
            if (!button) return;
            const doctorId = button.dataset.id;
            if (button.classList.contains('btn-details')) {
                console.log('Ver detalles:', doctorId);
            } else if (button.classList.contains('btn-credentials')) {
                console.log('Ver credenciales:', doctorId);
            } else if (button.classList.contains('btn-validate')) {
                console.log('Validar:', doctorId);
            }
        });
    }
    
    if (searchInput) searchInput.addEventListener('input', applyFilters);
    if (statusFilter) statusFilter.addEventListener('change', applyFilters);
    if (retryBtn) retryBtn.addEventListener('click', loadDoctors);
    if (addDoctorBtn) addDoctorBtn.addEventListener('click', () => console.log('Agregar médico'));
    
    document.querySelectorAll('.filter-tag').forEach(tag => {
        tag.addEventListener('click', function() {
            this.classList.toggle('active');
            const activeTags = Array.from(document.querySelectorAll('.filter-tag.active'));
            
            if (activeTags.length === 0) {
                filteredDoctors = [...allDoctors];
            } else {
                const activeSpecialties = activeTags.map(t => t.dataset.specialty);
                filteredDoctors = allDoctors.filter(doctor => {
                    const specialtySlug = (doctor.especialidad || '').toLowerCase().replace(/ /g, '-');
                    return activeSpecialties.includes(specialtySlug);
                });
            }
            applyFilters();
        });
    });
    
    const mobileMenuBtn = document.querySelector('.mobile-menu-btn');
    const sidebar = document.querySelector('.sidebar');
    if (mobileMenuBtn && sidebar) {
        mobileMenuBtn.addEventListener('click', () => sidebar.classList.toggle('active'));
        document.addEventListener('click', function(e) {
            if (!sidebar.contains(e.target) && !mobileMenuBtn.contains(e.target)) {
                sidebar.classList.remove('active');
            }
        });
    }
    
    console.log('Cargando página de médicos...');
    loadDoctors();
});


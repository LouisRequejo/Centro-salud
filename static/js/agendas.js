// Variables globales
let currentDate = new Date();
let selectedDate = new Date(2025, 9, 20); // 20 de octubre 2025

// Función para verificar si un año es bisiesto
function isLeapYear(year) {
    return (year % 4 === 0 && year % 100 !== 0) || (year % 400 === 0);
}

// Función para obtener el número de días en un mes
function getDaysInMonth(month, year) {
    const daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    
    if (month === 1 && isLeapYear(year)) { // Febrero en año bisiesto
        return 29;
    }
    
    return daysInMonth[month];
}

// Función para obtener el nombre del mes
function getMonthName(month) {
    const months = [
        'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
        'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month];
}

// Función para formatear fecha como YYYY-MM-DD
function formatDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

// Función para formatear fecha en español
function formatDateSpanish(date) {
    const day = date.getDate();
    const month = getMonthName(date.getMonth());
    const year = date.getFullYear();
    return `${day} de ${month} de ${year}`;
}

// Función para renderizar el calendario
function renderCalendar() {
    const year = currentDate.getFullYear();
    const month = currentDate.getMonth();
    
    // Actualizar el título del mes
    document.getElementById('currentMonth').textContent = `${getMonthName(month)} ${year}`;
    
    // Obtener el primer día del mes (0 = Domingo, 1 = Lunes, etc.)
    const firstDay = new Date(year, month, 1).getDay();
    
    // Obtener el número de días del mes actual
    const daysInMonth = getDaysInMonth(month, year);
    
    // Obtener el número de días del mes anterior
    const prevMonth = month === 0 ? 11 : month - 1;
    const prevYear = month === 0 ? year - 1 : year;
    const daysInPrevMonth = getDaysInMonth(prevMonth, prevYear);
    
    // Limpiar el grid (mantener solo los días de la semana)
    const calendarGrid = document.querySelector('.calendar-grid');
    const weekdays = calendarGrid.querySelectorAll('.calendar-weekday');
    calendarGrid.innerHTML = '';
    weekdays.forEach(day => calendarGrid.appendChild(day));
    
    // Agregar días del mes anterior
    for (let i = firstDay - 1; i >= 0; i--) {
        const day = daysInPrevMonth - i;
        const dayElement = createDayElement(day, 'other-month', prevMonth, prevYear);
        calendarGrid.appendChild(dayElement);
    }
    
    // Agregar días del mes actual
    for (let day = 1; day <= daysInMonth; day++) {
        const isToday = day === selectedDate.getDate() && 
                       month === selectedDate.getMonth() && 
                       year === selectedDate.getFullYear();
        
        const dayElement = createDayElement(day, isToday ? 'today' : '', month, year);
        
        // Agregar indicador de citas (puedes personalizar esto según tus datos)
        if (hasAppointments(day, month, year)) {
            dayElement.classList.add('has-appointments');
            const dot = document.createElement('span');
            dot.className = 'appointment-dot';
            dayElement.appendChild(dot);
        }
        
        calendarGrid.appendChild(dayElement);
    }
    
    // Agregar días del siguiente mes para completar la grilla
    const totalCells = calendarGrid.children.length - 7; // Restar los días de la semana
    const remainingCells = 42 - totalCells - 7; // 6 semanas * 7 días - días ya agregados - weekdays
    
    for (let day = 1; day <= remainingCells; day++) {
        const nextMonth = month === 11 ? 0 : month + 1;
        const nextYear = month === 11 ? year + 1 : year;
        const dayElement = createDayElement(day, 'other-month', nextMonth, nextYear);
        calendarGrid.appendChild(dayElement);
    }
}

// Función para crear un elemento de día
function createDayElement(day, className, month, year) {
    const dayElement = document.createElement('div');
    dayElement.className = `calendar-day ${className}`;
    dayElement.textContent = day;
    
    // Agregar evento click solo si no es de otro mes
    if (!className.includes('other-month')) {
        dayElement.addEventListener('click', function() {
            selectDate(day, month, year);
        });
        dayElement.style.cursor = 'pointer';
    }
    
    return dayElement;
}

// Función para verificar si un día tiene citas (placeholder)
function hasAppointments(day, month, year) {
    // Aquí puedes agregar tu lógica para verificar si hay citas
    // Por ahora, marca algunos días de ejemplo
    const appointmentDays = [11, 14, 15, 22, 25];
    const currentMonth = currentDate.getMonth();
    const currentYear = currentDate.getFullYear();
    
    return month === currentMonth && 
           year === currentYear && 
           appointmentDays.includes(day);
}

// Función para seleccionar una fecha
function selectDate(day, month, year) {
    selectedDate = new Date(year, month, day);
    
    // Actualizar el input de fecha en los filtros
    document.getElementById('fechaFilter').value = formatDate(selectedDate);
    
    // Actualizar el texto de fecha seleccionada
    document.getElementById('selectedDateText').textContent = formatDateSpanish(selectedDate);
    
    // Volver a renderizar el calendario para actualizar la clase 'today'
    renderCalendar();
    
    console.log('Fecha seleccionada:', formatDate(selectedDate));
}

// Función para cambiar de mes
function changeMonth(delta) {
    currentDate.setMonth(currentDate.getMonth() + delta);
    renderCalendar();
}

// Event Listeners
document.addEventListener('DOMContentLoaded', function() {
    // Inicializar el calendario
    renderCalendar();
    
    // Botones de navegación del mes
    document.getElementById('prevMonth').addEventListener('click', () => changeMonth(-1));
    document.getElementById('nextMonth').addEventListener('click', () => changeMonth(1));
    
    // Filtros
    document.getElementById('aplicarFiltrosBtn').addEventListener('click', aplicarFiltros);
    document.getElementById('restablecerBtn').addEventListener('click', restablecerFiltros);
    
    // Actualizar texto de fecha inicial
    document.getElementById('selectedDateText').textContent = formatDateSpanish(selectedDate);
});

// Función para aplicar filtros
function aplicarFiltros() {
    const doctorId = document.getElementById('doctorFilter').value;
    const especialidadId = document.getElementById('especialidadFilter').value;
    const estado = document.getElementById('estadoFilter').value;
    const fecha = document.getElementById('fechaFilter').value;
    
    console.log('Aplicando filtros:', { doctorId, especialidadId, estado, fecha });
    
    // Aquí puedes agregar la lógica para filtrar las citas
    // Por ejemplo, hacer una petición AJAX al servidor
}

// Función para restablecer filtros
function restablecerFiltros() {
    document.getElementById('doctorFilter').value = 'all';
    document.getElementById('especialidadFilter').value = 'all';
    document.getElementById('estadoFilter').value = 'all';
    document.getElementById('fechaFilter').value = '2025-10-20';
    
    selectedDate = new Date(2025, 9, 20);
    currentDate = new Date(2025, 9, 20);
    
    renderCalendar();
    document.getElementById('selectedDateText').textContent = formatDateSpanish(selectedDate);
    
    console.log('Filtros restablecidos');
}
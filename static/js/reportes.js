// Reportes Management

// Animate metric values
function animateValue(element, start, end, duration) {
    const range = end - start;
    const increment = range / (duration / 16);
    let current = start;
    
    const timer = setInterval(() => {
        current += increment;
        if ((increment > 0 && current >= end) || (increment < 0 && current <= end)) {
            element.textContent = Math.round(end);
            clearInterval(timer);
        } else {
            element.textContent = Math.round(current);
        }
    }, 16);
}

// Animate all metric values on load
document.addEventListener('DOMContentLoaded', function() {
    // Animate metrics with data-target attribute
    document.querySelectorAll('.metric-value[data-target]').forEach(element => {
        const target = parseInt(element.dataset.target);
        animateValue(element, 0, target, 1000);
    });
});

// Chart: Citas por Médico (Bar Chart)
const citasPorMedicoCtx = document.getElementById('citasPorMedicoChart');
if (citasPorMedicoCtx) {
    new Chart(citasPorMedicoCtx, {
        type: 'bar',
        data: {
            labels: ['Dr. Gómez', 'Dra. García', 'Dr. Martínez', 'Dr. Rodríguez', 'Dra. López', 'Dra. Hernández'],
            datasets: [{
                label: 'Citas Atendidas',
                data: [145, 132, 128, 98, 87, 75],
                backgroundColor: '#1976d2',
                borderRadius: 8
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: {
                        display: true,
                        color: '#f3f4f6'
                    }
                },
                x: {
                    grid: {
                        display: false
                    }
                }
            }
        }
    });
}

// Chart: Distribución de Servicios (Doughnut Chart)
const distribucionServiciosCtx = document.getElementById('distribucionServiciosChart');
if (distribucionServiciosCtx) {
    new Chart(distribucionServiciosCtx, {
        type: 'doughnut',
        data: {
            labels: ['Cardiología', 'Pediatría', 'Medicina General', 'Traumatología', 'Otros'],
            datasets: [{
                data: [280, 220, 180, 140, 80],
                backgroundColor: [
                    '#1976d2',
                    '#4caf50',
                    '#ff9800',
                    '#f44336',
                    '#9c27b0'
                ],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 15,
                        usePointStyle: true
                    }
                }
            }
        }
    });
}

// Report Type Filter
document.getElementById('reportType')?.addEventListener('change', function(e) {
    const reportType = e.target.value;
    console.log('Report type changed:', reportType);
    // TODO: Update charts and table based on report type
});

// Report Period Filter
document.getElementById('reportPeriod')?.addEventListener('change', function(e) {
    const period = e.target.value;
    console.log('Report period changed:', period);
    
    if (period === 'custom') {
        // TODO: Show date range picker
        alert('Mostrar selector de rango de fechas');
    }
    
    // TODO: Update data based on period
});

// Report Department Filter
document.getElementById('reportDepartment')?.addEventListener('change', function(e) {
    const department = e.target.value;
    console.log('Report department changed:', department);
    // TODO: Filter data by department
});

// Generate Report Button
document.getElementById('generateReportBtn')?.addEventListener('click', function() {
    console.log('Generating report...');
    
    // Show loading state
    this.disabled = true;
    this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generando...';
    
    // Simulate API call
    setTimeout(() => {
        this.disabled = false;
        this.innerHTML = '<i class="fas fa-chart-bar"></i> Generar Reporte';
        
        // TODO: Fetch new data and update charts/table
        alert('Reporte generado exitosamente');
    }, 1500);
});

// Export PDF Button
document.getElementById('exportPdfBtn')?.addEventListener('click', function() {
    console.log('Exporting to PDF...');
    // TODO: Generate and download PDF report
    alert('Exportando reporte a PDF...');
});

// Export CSV Button
document.getElementById('exportCsvBtn')?.addEventListener('click', function() {
    console.log('Exporting to CSV...');
    
    // Get table data
    const table = document.querySelector('.report-table');
    const rows = Array.from(table.querySelectorAll('tr'));
    
    // Convert to CSV
    const csv = rows.map(row => {
        const cells = Array.from(row.querySelectorAll('th, td'));
        return cells.map(cell => {
            const text = cell.textContent.trim();
            // Escape quotes and wrap in quotes if contains comma
            return text.includes(',') ? `"${text.replace(/"/g, '""')}"` : text;
        }).join(',');
    }).join('\n');
    
    // Download CSV
    const blob = new Blob([csv], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `reporte_${new Date().toISOString().split('T')[0]}.csv`;
    a.click();
    window.URL.revokeObjectURL(url);
});

// Table Row Click
document.querySelectorAll('.report-table tbody tr').forEach(row => {
    row.addEventListener('click', function() {
        // Remove highlight from all rows
        document.querySelectorAll('.report-table tbody tr').forEach(r => {
            r.style.backgroundColor = '';
        });
        
        // Highlight selected row
        this.style.backgroundColor = '#e3f2fd';
        
        const fecha = this.cells[0].textContent;
        const medico = this.cells[1].textContent;
        console.log('Selected appointment:', { fecha, medico });
    });
});

console.log('Reportes page loaded');

// Notificaciones Management

// Mark all as read
document.getElementById('markAllReadBtn')?.addEventListener('click', function() {
    const unreadNotifications = document.querySelectorAll('.notification-item.unread');
    
    if (unreadNotifications.length === 0) {
        alert('No hay notificaciones sin leer');
        return;
    }
    
    if (confirm(`¿Marcar ${unreadNotifications.length} notificaciones como leídas?`)) {
        unreadNotifications.forEach(notification => {
            notification.classList.remove('unread');
        });
        
        // Update counts
        updateNotificationCounts();
        
        // Update header
        document.querySelector('.header-content h2').textContent = 'No tienes notificaciones pendientes';
    }
});

// Filter notifications
document.querySelectorAll('.filter-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        // Remove active class from all buttons
        document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        
        // Add active class to clicked button
        this.classList.add('active');
        
        const filter = this.dataset.filter;
        const notifications = document.querySelectorAll('.notification-item');
        
        notifications.forEach(notification => {
            if (filter === 'all') {
                notification.classList.remove('hidden');
            } else if (filter === 'unread') {
                if (notification.classList.contains('unread')) {
                    notification.classList.remove('hidden');
                } else {
                    notification.classList.add('hidden');
                }
            } else {
                if (notification.dataset.type === filter) {
                    notification.classList.remove('hidden');
                } else {
                    notification.classList.add('hidden');
                }
            }
        });
    });
});

// Mark single notification as read
document.querySelectorAll('.notification-item .btn-action .fa-check').forEach(btn => {
    btn.parentElement.addEventListener('click', function(e) {
        e.stopPropagation();
        
        const notification = this.closest('.notification-item');
        
        if (notification.classList.contains('unread')) {
            notification.classList.remove('unread');
            
            // Remove the button
            this.remove();
            
            // Update counts
            updateNotificationCounts();
            
            // Update header if no more unread
            const remainingUnread = document.querySelectorAll('.notification-item.unread').length;
            if (remainingUnread === 0) {
                document.querySelector('.header-content h2').textContent = 'No tienes notificaciones pendientes';
            } else {
                document.querySelector('.header-content h2').textContent = `Tienes ${remainingUnread} ${remainingUnread === 1 ? 'notificación pendiente' : 'notificaciones pendientes'}`;
            }
        }
    });
});

// View notification details
document.querySelectorAll('.notification-item .btn-action .fa-eye').forEach(btn => {
    btn.parentElement.addEventListener('click', function(e) {
        e.stopPropagation();
        
        const notification = this.closest('.notification-item');
        const title = notification.querySelector('h4').textContent;
        const content = notification.querySelector('p').textContent;
        
        // TODO: Show modal with full notification details
        alert(`${title}\n\n${content}`);
    });
});

// Delete notification
document.querySelectorAll('.notification-item .btn-action.btn-danger').forEach(btn => {
    btn.addEventListener('click', function(e) {
        e.stopPropagation();
        
        const notification = this.closest('.notification-item');
        const title = notification.querySelector('h4').textContent;
        
        if (confirm(`¿Eliminar la notificación "${title}"?`)) {
            // Animate out
            notification.style.opacity = '0';
            notification.style.transform = 'translateX(100%)';
            
            setTimeout(() => {
                notification.remove();
                updateNotificationCounts();
                
                // Update header
                const remainingUnread = document.querySelectorAll('.notification-item.unread').length;
                if (remainingUnread === 0) {
                    document.querySelector('.header-content h2').textContent = 'No tienes notificaciones pendientes';
                } else {
                    document.querySelector('.header-content h2').textContent = `Tienes ${remainingUnread} ${remainingUnread === 1 ? 'notificación pendiente' : 'notificaciones pendientes'}`;
                }
                
                // Check if list is empty
                if (document.querySelectorAll('.notification-item').length === 0) {
                    document.querySelector('.notifications-list').innerHTML = `
                        <div style="text-align: center; padding: 60px 20px; color: #9ca3af;">
                            <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 16px;"></i>
                            <p>No hay notificaciones</p>
                        </div>
                    `;
                }
            }, 300);
        }
    });
});

// Click on notification
document.querySelectorAll('.notification-item').forEach(notification => {
    notification.addEventListener('click', function() {
        // Mark as read if unread
        if (this.classList.contains('unread')) {
            this.classList.remove('unread');
            
            // Remove check button
            const checkBtn = this.querySelector('.btn-action .fa-check');
            if (checkBtn) {
                checkBtn.parentElement.remove();
            }
            
            updateNotificationCounts();
        }
        
        // Show details
        const title = this.querySelector('h4').textContent;
        const content = this.querySelector('p').textContent;
        console.log('Notification clicked:', { title, content });
    });
});

// Load more notifications
document.getElementById('loadMoreBtn')?.addEventListener('click', function() {
    this.disabled = true;
    this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Cargando...';
    
    // Simulate API call
    setTimeout(() => {
        this.disabled = false;
        this.innerHTML = '<i class="fas fa-sync-alt"></i> Cargar más notificaciones';
        
        // TODO: Load more notifications from API
        alert('No hay más notificaciones disponibles');
    }, 1000);
});

// Update notification counts
function updateNotificationCounts() {
    const all = document.querySelectorAll('.notification-item').length;
    const unread = document.querySelectorAll('.notification-item.unread').length;
    const system = document.querySelectorAll('.notification-item[data-type="system"]').length;
    const appointments = document.querySelectorAll('.notification-item[data-type="appointments"]').length;
    const doctors = document.querySelectorAll('.notification-item[data-type="doctors"]').length;
    
    document.querySelector('[data-filter="all"] .filter-count').textContent = all;
    document.querySelector('[data-filter="unread"] .filter-count').textContent = unread;
    document.querySelector('[data-filter="system"] .filter-count').textContent = system;
    document.querySelector('[data-filter="appointments"] .filter-count').textContent = appointments;
    document.querySelector('[data-filter="doctors"] .filter-count').textContent = doctors;
}

console.log('Notificaciones page loaded');

$(document).ready(function() {
    $('.container').addClass('fade-in');
    $('[data-bs-toggle="tooltip"]').tooltip();
    $('[data-bs-toggle="popover"]').popover();

    $('.needs-validation').submit(function(event) {
        if (!this.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
            $(this).find(':invalid').first().focus().effect('shake', { times: 2, distance: 5 }, 500);
        }
        $(this).addClass('was-validated');
    });

    $('.format-date').each(function() {
        const dateStr = $(this).text();
        if (dateStr) {
            const date = new Date(dateStr);
            $(this).text(date.toLocaleDateString('uk-UA'));
        }
    });

    $('input[type="date"][id="order_deadline"]').each(function() {
        const today = new Date().toISOString().split('T')[0];
        if (!$(this).attr('min')) {
            $(this).attr('min', today);
        }
    });

    $('.toggle-status').click(function() {
        const orderId = $(this).data('order-id');
        const status = $(this).data('status');
        
        if (confirm('Ви впевнені, що хочете змінити статус наказу?')) {
            const form = $('<form>', {
                method: 'POST',
                action: `/orders/${orderId}`
            });
            
            const statusField = $('<input>', {
                type: 'hidden',
                name: 'order_status',
                value: status === 'active' ? 'completed' : 'active'
            });
            
            if (status === 'active') {
                const completedDateField = $('<input>', {
                    type: 'hidden',
                    name: 'order_date_completed',
                    value: new Date().toISOString().split('T')[0]
                });
                form.append(completedDateField);
            }
            
            form.append(statusField);
            $('body').append(form);
            form.submit();
        }
    });

    $('#table-search').on('input', function() {
        const searchTerm = $(this).val().toLowerCase();
        
        $('table tbody tr').each(function() {
            const text = $(this).text().toLowerCase();
            
            if (text.includes(searchTerm)) {
                $(this).slideDown(200);
            } else {
                $(this).slideUp(200);
            }
        });
    });

    $('.priority-indicator').each(function() {
        const priority = $(this).data('priority');
        let bgClass = 'bg-info';
        
        if (priority === 'high') {
            bgClass = 'bg-danger';
        } else if (priority === 'medium') {
            bgClass = 'bg-warning';
        }
        
        $(this).addClass(bgClass)
            .hover(
                function() { $(this).css('opacity', '0.8'); }, 
                function() { $(this).css('opacity', '1'); }
            );
    });

    $('.deadline-countdown').each(function() {
        const deadline = new Date($(this).data('deadline'));
        const today = new Date();
        const daysLeft = Math.ceil((deadline - today) / (1000 * 60 * 60 * 24));
        
        if (daysLeft < 0) {
            $(this).text(`Прострочено на ${Math.abs(daysLeft)} днів`)
                .addClass('text-danger fw-bold')
                .effect('pulsate', { times: 1 }, 1000);
        } else if (daysLeft === 0) {
            $(this).text('Сьогодні')
                .addClass('text-warning fw-bold')
                .effect('pulsate', { times: 1 }, 1000);
        } else if (daysLeft === 1) {
            $(this).text('Завтра')
                .addClass('text-warning');
        } else if (daysLeft <= 3) {
            $(this).text(`${daysLeft} дні`)
                .addClass('text-warning');
        } else {
            $(this).text(`${daysLeft} днів`);
        }
    });
    
    $('.card').hover(
        function() { $(this).addClass('shadow-lg'); },
        function() { $(this).removeClass('shadow-lg'); }
    );
    
    $('a[href^="#"]').on('click', function(event) {
        const target = $(this.getAttribute('href'));
        if(target.length) {
            event.preventDefault();
            $('html, body').animate({
                scrollTop: target.offset().top - 70
            }, 500);
        }
    });
    
    const currentLocation = window.location.pathname;
    $('.navbar-nav .nav-link').each(function() {
        const linkPath = $(this).attr('href');
        if (currentLocation === linkPath || 
            (linkPath !== '/' && currentLocation.startsWith(linkPath))) {
            $(this).addClass('active').css('font-weight', 'bold');
        }
    });

    $('table tbody tr').hover(
        function() { $(this).addClass('shadow-sm'); },
        function() { $(this).removeClass('shadow-sm'); }
    );
    
    $('button[data-bs-toggle="tab"]').on('shown.bs.tab', function(e) {
        localStorage.setItem('activeTab', $(e.target).attr('id'));
    });
    
    const activeTab = localStorage.getItem('activeTab');
    if (activeTab) {
        $('#' + activeTab).tab('show');
    }
    
    window.filterByDepartment = function(departmentId) {
        const executorSelect = $('#executor_id');
        if (executorSelect.length === 0) return;
        
        const executors = JSON.parse(executorSelect.data('executors') || '[]');
        executorSelect.empty().append('<option value="">Виберіть виконавця</option>');
        
        const filteredExecutors = executors.filter(executor => 
            !departmentId || executor.department_id == departmentId
        );
        
        $.each(filteredExecutors, function(i, executor) {
            $('<option>')
                .val(executor.executor_id)
                .text(executor.executor_name)
                .appendTo(executorSelect)
                .hide()
                .fadeIn(200 + i * 50);
        });
    };
    
    window.confirmDelete = function(event, itemName) {
        event.preventDefault();
        
        if ($('#deleteConfirmModal').length === 0) {
            const modal = $('<div>', {
                id: 'deleteConfirmModal',
                class: 'modal fade',
                tabindex: '-1',
                'aria-hidden': 'true'
            }).appendTo('body');
            
            const modalDialog = $('<div>', {
                class: 'modal-dialog modal-dialog-centered'
            }).appendTo(modal);
            
            const modalContent = $('<div>', {
                class: 'modal-content'
            }).appendTo(modalDialog);
            
            $('<div>', {
                class: 'modal-header bg-danger text-white',
                html: '<h5 class="modal-title">Підтвердження видалення</h5>'
            }).appendTo(modalContent);
            
            $('<div>', {
                class: 'modal-body',
                id: 'deleteConfirmBody'
            }).appendTo(modalContent);
            
            $('<div>', {
                class: 'modal-footer',
                html: `
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Скасувати</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Видалити</button>
                `
            }).appendTo(modalContent);
        }
        
        $('#deleteConfirmBody').html(`<p>Ви впевнені, що хочете видалити "${itemName}"?</p>`);
        
        const modal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
        modal.show();
        
        $('#confirmDeleteBtn').off('click').on('click', function() {
            modal.hide();
            window.location.href = $(event.target).attr('href');
        });
    };

    window.initCharts = function() {
        if (typeof Chart === 'undefined' || !$('#ordersChart').length) return;
        
        const ordersCtx = $('#ordersChart')[0].getContext('2d');
        const chart = new Chart(ordersCtx, {
            type: 'doughnut',
            data: {
                labels: ['Активні', 'Виконані', 'Прострочені'],
                datasets: [{
                    data: [
                        $('#ordersChart').data('active') || 0,
                        $('#ordersChart').data('completed') || 0,
                        $('#ordersChart').data('overdue') || 0
                    ],
                    backgroundColor: [
                        'var(--warning)',
                        'var(--success)',
                        'var(--danger)'
                    ]
                }]
            },
            options: {
                responsive: true,
                animation: {
                    animateScale: true,
                    animateRotate: true,
                    duration: 2000,
                    easing: 'easeOutQuart'
                },
                plugins: {
                    legend: {
                        position: 'bottom',
                    }
                }
            }
        });
    };

    if ($('#ordersChart').length) {
        $.getScript('https://cdn.jsdelivr.net/npm/chart.js', function() {
            initCharts();
        });
    }
    
    if ($('.deadline-countdown').length) {
        $.getScript('https://code.jquery.com/ui/1.13.2/jquery-ui.min.js');
    }
});
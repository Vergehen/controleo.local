{extends file="../layout.tpl"}

{block name="content"}
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Накази</h1>
            <a href="/orders/create" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> Додати новий наказ
            </a>
        </div>

        <div class="card mb-4">
            <div class="card-body p-0">
                <div class="p-3 bg-light border-bottom">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <input type="text" id="table-search" class="form-control" placeholder="Швидкий пошук...">
                        </div>
                        <div class="col-md-6">
                            <div class="d-flex justify-content-end gap-2">
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-outline-secondary filter-btn"
                                        data-filter="all">Всі</button>
                                    <button type="button" class="btn btn-outline-warning filter-btn"
                                        data-filter="active">Активні</button>
                                    <button type="button" class="btn btn-outline-success filter-btn"
                                        data-filter="completed">Виконані</button>
                                    <button type="button" class="btn btn-outline-danger filter-btn"
                                        data-filter="overdue">Прострочені</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-content" id="ordersTabContent">
                    <div class="tab-pane fade show active p-3" id="all" role="tabpanel" aria-labelledby="all-tab">
                        {if $orders|@count > 0}
                            <div class="table-responsive">
                                <table class="table table-hover table-striped">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Назва</th>
                                            <th>Виконавець</th>
                                            <th>Видавець</th>
                                            <th>Дата видачі</th>
                                            <th>Дедлайн</th>
                                            <th>Статус</th>
                                            <th>Пріоритет</th>
                                            <th class="text-center">Дії</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach $orders as $order}
                                            <tr class="order-row" data-status="{$order.order_status}"
                                                data-priority="{$order.order_priority}" data-deadline="{$order.order_deadline}">
                                                <td>{$order.order_id}</td>
                                                <td>
                                                    <a href="/orders/{$order.order_id}"
                                                        class="text-decoration-none fw-medium">{$order.order_name}</a>
                                                </td>
                                                <td>{$order.executor_name}</td>
                                                <td>{$order.issuer_name}</td>
                                                <td class="format-date">{$order.order_date_issued}</td>
                                                <td>
                                                    <span class="deadline-countdown" data-deadline="{$order.order_deadline}">
                                                        {$order.order_deadline}
                                                    </span>
                                                </td>
                                                <td>
                                                    {if $order.order_status == 'active'}
                                                        <span class="badge bg-primary">Активний</span>
                                                    {elseif $order.order_status == 'completed'}
                                                        <span class="badge bg-success">Виконано</span>
                                                    {elseif $order.order_status == 'overdue'}
                                                        <span class="badge bg-danger">Прострочено</span>
                                                    {/if}
                                                </td>
                                                <td>
                                                    <span class="priority-indicator" data-priority="{$order.order_priority}">
                                                        {if $order.order_priority == 'high'}
                                                            <span class="badge bg-danger">Високий</span>
                                                        {elseif $order.order_priority == 'medium'}
                                                            <span class="badge bg-warning">Середній</span>
                                                        {elseif $order.order_priority == 'low'}
                                                            <span class="badge bg-info">Низький</span>
                                                        {/if}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="btn-group">
                                                        <a href="/orders/{$order.order_id}" class="btn btn-sm btn-info"
                                                            data-bs-toggle="tooltip" title="Перегляд">
                                                            <i class="bi bi-eye"></i>
                                                        </a>
                                                        <a href="/orders/{$order.order_id}/edit" class="btn btn-sm btn-warning"
                                                            data-bs-toggle="tooltip" title="Редагувати">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                        <a href="/orders/{$order.order_id}/delete" class="btn btn-sm btn-danger"
                                                            onclick="confirmDelete(event, '{$order.order_name}')"
                                                            data-bs-toggle="tooltip" title="Видалити">
                                                            <i class="bi bi-trash"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        {/foreach}
                                    </tbody>
                                </table>
                            </div>
                        {else}
                            <div class="alert alert-info mt-3">Наказів поки немає. <a href="/orders/create">Додати перший
                                    наказ</a></div>
                        {/if}
                    </div>
                </div>
            </div>
        </div>

        {if $orders|@count > 0}
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Статистика наказів</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-8">
                            <canvas id="ordersChart" height="200" data-active="{$activeOrders|@count}"
                                data-completed="{$completedOrders|@count}" data-overdue="{$overdueOrders|@count}">
                            </canvas>
                        </div>
                        <div class="col-md-4">
                            <div class="list-group">
                                <div class="list-group-item d-flex justify-content-between align-items-center">
                                    Всього наказів
                                    <span class="badge bg-primary rounded-pill">{$orders|@count}</span>
                                </div>
                                <div class="list-group-item d-flex justify-content-between align-items-center">
                                    Активні
                                    <span class="badge bg-warning rounded-pill">{$activeOrders|@count}</span>
                                </div>
                                <div class="list-group-item d-flex justify-content-between align-items-center">
                                    Виконані
                                    <span class="badge bg-success rounded-pill">{$completedOrders|@count}</span>
                                </div>
                                <div class="list-group-item d-flex justify-content-between align-items-center">
                                    Прострочені
                                    <span class="badge bg-danger rounded-pill">{$overdueOrders|@count}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        {/if}
    </div>
{/block}

{block name="scripts"}
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        $(document).ready(function() {
            const today = new Date();

            const ordersChartElement = document.getElementById('ordersChart');
            if (ordersChartElement) {
                const ctx = ordersChartElement.getContext('2d');
                const activeCount = parseInt($(ordersChartElement).data('active')) || 0;
                const completedCount = parseInt($(ordersChartElement).data('completed')) || 0;
                const overdueCount = parseInt($(ordersChartElement).data('overdue')) || 0;

                new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: ['Активні', 'Виконані', 'Прострочені'],
                        datasets: [{
                            data: [activeCount, completedCount, overdueCount],
                            backgroundColor: [
                                '#ffc107',
                                '#198754',
                                '#dc3545'
                            ]
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {
                                position: 'bottom'
                            }
                        }
                    }
                });
            }

            let initialFilter = 'all';

            if (window.location.pathname === '/orders/active') {
                initialFilter = 'active';
            } else if (window.location.pathname === '/orders/overdue') {
                initialFilter = 'overdue';
            }

            $('.deadline-countdown').each(function() {
                const deadline = new Date($(this).data('deadline'));
                const daysLeft = Math.ceil((deadline - today) / (1000 * 60 * 60 * 24));

                if (daysLeft < 0) {
                    const daysOverdue = Math.abs(Math.floor(daysLeft));
                    $(this).text("Прострочено на " + daysOverdue + " днів")
                        .addClass('text-danger fw-bold');

                    const row = $(this).closest('tr');
                    if (row.data('status') !== 'completed') {
                        row.attr('data-status', 'overdue');
                    }
                }
            });

            function filterOrders(filter) {
                $('.filter-btn').removeClass('active');
                $('.filter-btn[data-filter="' + filter + '"]').addClass('active');

                if (filter === 'all') {
                    $('.order-row').slideDown(200);
                } else if (filter === 'active') {
                    $('.order-row').hide();
                    $('.order-row[data-status="active"]').slideDown(200);
                } else if (filter === 'completed') {
                    $('.order-row').hide();
                    $('.order-row[data-status="completed"]').slideDown(200);
                } else if (filter === 'overdue') {
                    $('.order-row').hide();
                    $('.order-row:not([data-status="completed"])').each(function() {
                        const deadline = $(this).data('deadline');
                        if ($(this).data('status') === 'overdue' || new Date(deadline) < today) {
                            $(this).slideDown(200);
                        }
                    });
                }
            }

            filterOrders(initialFilter);

            $('.filter-btn').on('click', function() {
                const filter = $(this).data('filter');
                filterOrders(filter);
            });

            $('tbody tr').hover(
                function() {
                    $(this).addClass('shadow-sm bg-light');
                },
                function() {
                    $(this).removeClass('shadow-sm bg-light');
                }
            );
        });
    </script>
{/block}
{extends file="../layout.tpl"}

{block name="content"}
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6">{$executor.executor_name}</h1>
        <div class="d-flex gap-2">
            <a href="/executors/{$executor.executor_id}/edit" class="btn btn-secondary">
                <i class="bi bi-pencil"></i> Редагувати
            </a>
            <a href="/executors" class="btn btn-outline-primary">
                <i class="bi bi-arrow-left"></i> До списку
            </a>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-md-8">
            <div class="card mb-4 shadow-sm">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Інформація про виконавця</h5>
                    <span class="badge bg-primary">ID: {$executor.executor_id}</span>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <p class="fw-bold mb-1">ПІБ:</p>
                            <p>{$executor.executor_name}</p>
                        </div>
                        <div class="col-md-6">
                            <p class="fw-bold mb-1">Контактні дані:</p>
                            <p>{$executor.executor_contact|default:'Не вказано'}</p>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <p class="fw-bold mb-1">Відділ:</p>
                            <p>{$executor.department_name|default:'Не вказано'}</p>
                        </div>
                        <div class="col-md-6">
                            <p class="fw-bold mb-1">Посада:</p>
                            <p>{$executor.position_name|default:'Не вказано'}</p>
                        </div>
                    </div>

                    {if $executor.executor_notes}
                        <div class="mt-4">
                            <h6 class="fw-bold mb-2">Додаткова інформація:</h6>
                            <div class="p-3 bg-light rounded">
                                <p class="mb-0">{$executor.executor_notes|nl2br}</p>
                            </div>
                        </div>
                    {/if}
                </div>
            </div>

            {if $activeOrders|@count > 0}
                <div class="card mb-4">
                    <div class="card-header bg-warning text-white">
                        <h5 class="mb-0">Активні накази</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Назва</th>
                                        <th>Видавець</th>
                                        <th>Дата видачі</th>
                                        <th>Дедлайн</th>
                                        <th>Пріоритет</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach $activeOrders as $order}
                                        <tr>
                                            <td><a href="/orders/{$order.order_id}">{$order.order_name}</a></td>
                                            <td>{$order.issuer_name}</td>
                                            <td class="format-date">{$order.order_date_issued}</td>
                                            <td>
                                                <span class="deadline-countdown" data-deadline="{$order.order_deadline}">
                                                    {$order.order_deadline}
                                                </span>
                                            </td>
                                            <td>
                                                {if $order.order_priority == 'high'}
                                                    <span class="badge bg-danger">Високий</span>
                                                {elseif $order.order_priority == 'medium'}
                                                    <span class="badge bg-warning">Середній</span>
                                                {else}
                                                    <span class="badge bg-info">Низький</span>
                                                {/if}
                                            </td>
                                        </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            {/if}

            {if $completedOrders|@count > 0}
                <div class="card mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Виконані накази</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Назва</th>
                                        <th>Видавець</th>
                                        <th>Дата видачі</th>
                                        <th>Дата виконання</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach $completedOrders as $order}
                                        <tr>
                                            <td><a href="/orders/{$order.order_id}">{$order.order_name}</a></td>
                                            <td>{$order.issuer_name}</td>
                                            <td class="format-date">{$order.order_date_issued}</td>
                                            <td class="format-date">{$order.order_date_completed}</td>
                                        </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            {/if}
        </div>

        <div class="col-md-4">
            <div class="card mb-4">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0"><i class="bi bi-graph-up me-2"></i>Статистика</h5>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="stats-box rounded p-3 text-center bg-light">
                                <h2 class="mb-1">{$activeOrders|@count}</h2>
                                <p class="mb-0 text-muted">Активних наказів</p>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stats-box rounded p-3 text-center bg-light">
                                <h2 class="mb-1">{$completedOrders|@count}</h2>
                                <p class="mb-0 text-muted">Виконаних наказів</p>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stats-box rounded p-3 text-center bg-light">
                                <h2 class="mb-1">{$overdueOrders|@count}</h2>
                                <p class="mb-0 text-muted">Прострочено</p>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stats-box rounded p-3 text-center bg-light">
                                <h2 class="mb-1">{$allOrders|@count}</h2>
                                <p class="mb-0 text-muted">Всього наказів</p>
                            </div>
                        </div>
                    </div>

                    {if $allOrders|@count > 0}
                        <div class="mt-4">
                            <canvas id="ordersChart" height="200" data-active="{$activeOrders|@count}"
                                data-completed="{$completedOrders|@count}" data-overdue="{$overdueOrders|@count}">
                            </canvas>
                        </div>
                    {/if}
                </div>
                {if $allOrders|@count > 0}
                    <div class="card-footer">
                        <a href="/orders?executor_id={$executor.executor_id}" class="btn btn-sm btn-outline-info w-100">
                            <i class="bi bi-search me-1"></i> Всі накази виконавця
                        </a>
                    </div>
                {/if}
            </div>

            <div class="card mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="bi bi-building me-2"></i>Відділ</h5>
                </div>
                <div class="card-body">
                    {if $executor.department_id}
                        <div class="d-flex align-items-center mb-3">
                            <div class="flex-grow-1">
                                <h5 class="mb-1">{$executor.department_name}</h5>
                                {if $executor.position_name}
                                    <p class="mb-0 text-muted">{$executor.position_name}</p>
                                {/if}
                            </div>
                        </div>
                        <hr>
                        <a href="/departments/{$executor.department_id}" class="btn btn-sm btn-outline-primary w-100">
                            <i class="bi bi-info-circle me-1"></i> Перейти до відділу
                        </a>
                    {else}
                        <p class="text-muted mb-0">Виконавець не закріплений за жодним відділом</p>
                    {/if}
                </div>
            </div>

            <div class="card mb-4 border-danger">
                <div class="card-body">
                    <h5 class="text-danger mb-3">
                        <i class="bi bi-exclamation-triangle me-2"></i>Видалення
                    </h5>
                    <p class="small text-muted mb-3">Увага! Видалення виконавця призведе до видалення всіх пов'язаних
                    записів.</p>
                <form action="/executors/{$executor.executor_id}/delete" method="POST" class="delete-form">
                    <button type="submit" class="btn btn-danger w-100">
                        <i class="bi bi-trash me-1"></i> Видалити виконавця
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
{/block}

{block name="scripts"}
<script>
    $(document).ready(function() {
        $('.delete-form').on('submit', function(e) {
            e.preventDefault();

            if (confirm('Ви впевнені, що хочете видалити цього виконавця? Ця дія незворотна!')) {
                $(this).off('submit').submit();
                }
            });
        });
    </script>
{/block}
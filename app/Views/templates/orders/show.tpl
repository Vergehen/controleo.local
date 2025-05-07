{extends file="layout.tpl"}

{block name="content"}
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6">{$order.order_name}</h1>
        <div class="d-flex gap-2">
            <a href="/orders/{$order.order_id}/edit" class="btn btn-secondary">
                <i class="bi bi-pencil"></i> Редагувати
            </a>
            <a href="/orders" class="btn btn-outline-primary">
                <i class="bi bi-arrow-left"></i> До списку
            </a>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-md-8">
            <div class="card mb-4 shadow-sm">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Зміст наказу</h5>
                    <span class="badge bg-primary">ID: {$order.order_id}</span>
                </div>
                <div class="card-body">
                    <div class="p-3 bg-light rounded mb-3">
                        <p class="lead mb-0">{$order.order_content|nl2br}</p>
                    </div>
                    
                    <div class="mb-3">
                        <h6 class="fw-bold mb-2">Терміни виконання:</h6>
                        <div class="d-flex flex-wrap gap-3">
                            <div class="p-2 bg-light rounded">
                                <small class="text-muted d-block">Дата видачі</small>
                                <span class="format-date fw-medium">{$order.order_date_issued}</span>
                            </div>
                            <div class="p-2 rounded {if $order.order_status != 'completed' && strtotime($order.order_deadline) < $smarty.now}bg-danger-subtle{else}bg-light{/if}">
                                <small class="text-muted d-block">Дедлайн</small>
                                <span class="fw-medium {if $order.order_status != 'completed' && strtotime($order.order_deadline) < $smarty.now}text-danger{/if}">{$order.order_deadline}</span>
                            </div>
                            {if $order.order_status == 'completed' && $order.order_date_completed}
                            <div class="p-2 bg-success-subtle rounded">
                                <small class="text-muted d-block">Дата виконання</small>
                                <span class="format-date fw-medium">{$order.order_date_completed}</span>
                            </div>
                            {/if}
                        </div>
                    </div>
                    
                    <div class="progress mb-3" style="height: 5px;">
                        <div class="progress-bar bg-info" style="width: 100%"></div>
                    </div>
                    
                    <div class="d-flex justify-content-between">
                        <div>
                            <span class="d-block mb-1 text-muted">Статус:</span>
                            <span class="badge {if $order.order_status == 'completed'}bg-success{else}bg-warning{/if} p-2">
                                {if $order.order_status == 'completed'}
                                    <i class="bi bi-check-circle-fill me-1"></i> Виконано
                                {else}
                                    <i class="bi bi-hourglass-split me-1"></i> Активний
                                {/if}
                            </span>
                        </div>
                        <div>
                            <span class="d-block mb-1 text-muted">Пріоритет:</span>
                            <span class="badge {if $order.order_priority == 'high'}bg-danger{elseif $order.order_priority == 'medium'}bg-warning{else}bg-info{/if} p-2">
                                {if $order.order_priority == 'high'}
                                    <i class="bi bi-exclamation-triangle-fill me-1"></i> Високий
                                {elseif $order.order_priority == 'medium'}
                                    <i class="bi bi-bookmark-fill me-1"></i> Середній
                                {else}
                                    <i class="bi bi-arrow-down-circle-fill me-1"></i> Низький
                                {/if}
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card mb-4 shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="bi bi-person-fill me-2"></i>Виконавець</h5>
                </div>
                <div class="card-body">
                    <div class="d-flex align-items-center mb-3">
                        <div class="avatar-placeholder bg-light rounded-circle text-center me-3" style="width: 50px; height: 50px; line-height: 50px; font-size: 1.5rem;">
                            {$order.executor_name|substr:0:1}
                        </div>
                        <div class="flex-grow-1">
                            <h5 class="mb-1">{$order.executor_name}</h5>
                            <p class="mb-0 text-muted">{$order.executor_department}</p>
                        </div>
                    </div>
                    <hr>
                    <a href="/executors/{$order.executor_id}" class="btn btn-sm btn-outline-primary w-100">
                        <i class="bi bi-info-circle me-1"></i> Детальніше
                    </a>
                </div>
            </div>

            <div class="card mb-4 shadow-sm">
                <div class="card-header bg-secondary text-white">
                    <h5 class="mb-0"><i class="bi bi-person-badge-fill me-2"></i>Видавець наказу</h5>
                </div>
                <div class="card-body">
                    <div class="d-flex align-items-center mb-3">
                        <div class="avatar-placeholder bg-light rounded-circle text-center me-3" style="width: 50px; height: 50px; line-height: 50px; font-size: 1.5rem;">
                            {$order.issuer_name|substr:0:1}
                        </div>
                        <div class="flex-grow-1">
                            <h5 class="mb-1">{$order.issuer_name}</h5>
                        </div>
                    </div>
                    <hr>
                    <a href="/issuers/{$order.issuer_id}" class="btn btn-sm btn-outline-secondary w-100">
                        <i class="bi bi-info-circle me-1"></i> Детальніше
                    </a>
                </div>
            </div>

            {if $order.order_status != 'completed'}
                <div class="card mb-4 border-success">
                    <div class="card-body">
                        <h5 class="text-success mb-3">
                            <i class="bi bi-check-circle me-2"></i>Змінити статус
                        </h5>
                        <form action="/orders/{$order.order_id}" method="POST" class="confirm-form">
                            <input type="hidden" name="order_status" value="completed">
                            <input type="hidden" name="order_date_completed" value="{$smarty.now|date_format:"%Y-%m-%d"}">
                            <button type="submit" class="btn btn-success w-100">
                                <i class="bi bi-check-lg me-1"></i> Позначити як виконаний
                            </button>
                        </form>
                    </div>
                </div>
            {/if}

            <div class="card mb-4 border-danger">
                <div class="card-body">
                    <h5 class="text-danger mb-3">
                        <i class="bi bi-exclamation-triangle me-2"></i>Видалення
                    </h5>
                    <form action="/orders/{$order.order_id}/delete" method="POST" class="delete-form">
                        <button type="submit" class="btn btn-danger w-100">
                            <i class="bi bi-trash me-1"></i> Видалити наказ
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
    $('.confirm-form').on('submit', function(e) {
        e.preventDefault();
        
        if (confirm('Ви впевнені, що хочете позначити цей наказ як виконаний?')) {
            $(this).off('submit').submit();
        }
    });
    
    $('.delete-form').on('submit', function(e) {
        e.preventDefault();
        
        if (confirm('Ви впевнені, що хочете видалити цей наказ? Ця дія незворотна!')) {
            $(this).off('submit').submit();
        }
    });
});
</script>
{/block}
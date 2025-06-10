{extends file="../layout.tpl"}

{block name="content"}
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6">{$issuer.issuer_name}</h1>
        <div class="d-flex gap-2">
            <a href="/issuers/{$issuer.issuer_id}/edit" class="btn btn-secondary">
                <i class="bi bi-pencil"></i> Редагувати
            </a>
            <a href="/issuers" class="btn btn-outline-primary">
                <i class="bi bi-arrow-left"></i> До списку
            </a>
        </div>
    </div>
    
    <!-- Аналітичні показники видавця -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card bg-primary text-white">
                <div class="card-body text-center">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-0">{$issuerStats.total_orders}</h4>
                            <small>Всього видано</small>
                        </div>
                        <i class="bi bi-file-earmark-plus-fill fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-success text-white">
                <div class="card-body text-center">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-0">{$issuerStats.completed_orders}</h4>
                            <small>Виконано</small>
                        </div>
                        <i class="bi bi-check-circle-fill fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-info text-white">
                <div class="card-body text-center">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-0">{$issuerStats.active_orders}</h4>
                            <small>Активні</small>
                        </div>
                        <i class="bi bi-clock-history fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-warning text-white">
                <div class="card-body text-center">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-0">{$issuerStats.avg_completion_days|round:1}</h4>
                            <small>Середня тривалість (днів)</small>
                        </div>
                        <i class="bi bi-clock-fill fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="row g-4">
        <div class="col-md-8">
            <div class="card mb-4 shadow-sm">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Інформація про видавця</h5>
                    <span class="badge bg-primary">ID: {$issuer.issuer_id}</span>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <p class="fw-bold mb-1">ПІБ:</p>
                            <p>{$issuer.issuer_name}</p>
                        </div>
                        <div class="col-md-6">
                            <p class="fw-bold mb-1">Контактні дані:</p>
                            <p>{$issuer.issuer_contact|default:'Не вказано'}</p>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <p class="fw-bold mb-1">Відділ:</p>
                            <p>{$issuer.department_name|default:'Не вказано'}</p>
                        </div>
                        <div class="col-md-6">
                            <p class="fw-bold mb-1">Посада:</p>
                            <p>{$issuer.position_name|default:'Не вказано'}</p>
                        </div>
                    </div>
                    
                    {if $issuer.issuer_notes}
                    <div class="mt-4">
                        <h6 class="fw-bold mb-2">Додаткова інформація:</h6>
                        <div class="p-3 bg-light rounded">
                            <p class="mb-0">{$issuer.issuer_notes|nl2br}</p>
                        </div>
                    </div>
                    {/if}
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card mb-4 shadow-sm">
                <div class="card-header bg-secondary text-white">
                    <h5 class="mb-0"><i class="bi bi-file-earmark-text me-2"></i>Видані накази</h5>
                </div>
                <div class="card-body">
                    {if $issuerOrders|@count > 0}
                        <div class="list-group">
                            {foreach $issuerOrders as $order}
                                <a href="/orders/{$order.order_id}" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="fw-medium">{$order.order_name}</div>
                                        <small class="text-muted">Дедлайн: {$order.order_deadline}</small>
                                    </div>
                                    {if $order.order_status == 'completed'}
                                        <span class="badge bg-success">Виконано</span>
                                    {elseif $order.order_status == 'overdue'}
                                        <span class="badge bg-danger">Прострочено</span>
                                    {else}
                                        <span class="badge bg-warning">Активний</span>
                                    {/if}
                                </a>
                            {/foreach}
                        </div>
                    {else}
                        <p class="text-muted mb-0">Цей видавець ще не видавав накази</p>
                    {/if}
                </div>
                {if $issuerOrders|@count > 0}
                <div class="card-footer">
                    <a href="/orders?issuer_id={$issuer.issuer_id}" class="btn btn-sm btn-outline-secondary w-100">
                        <i class="bi bi-search me-1"></i> Всі накази видавця
                    </a>
                </div>
                {/if}
            </div>
            
            <div class="card mb-4 border-danger">
                <div class="card-body">
                    <h5 class="text-danger mb-3">
                        <i class="bi bi-exclamation-triangle me-2"></i>Видалення
                    </h5>
                    <form action="/issuers/{$issuer.issuer_id}/delete" method="POST" class="delete-form">
                        <button type="submit" class="btn btn-danger w-100">
                            <i class="bi bi-trash me-1"></i> Видалити видавця
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
        
        if (confirm('Ви впевнені, що хочете видалити цього видавця? Ця дія незворотна!')) {
            $(this).off('submit').submit();
        }
    });
});
</script>
{/block}
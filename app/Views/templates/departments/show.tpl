{extends file="../layout.tpl"}

{block name="content"}
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6">{$department.department_name}</h1>
        <div class="d-flex gap-2">
            <a href="/departments/{$department.department_id}/edit" class="btn btn-secondary">
                <i class="bi bi-pencil"></i> Редагувати
            </a>
            <a href="/departments" class="btn btn-outline-primary">
                <i class="bi bi-arrow-left"></i> До списку
            </a>
        </div>
    </div>
    
    <!-- Аналітичні показники відділу -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card bg-success text-white">
                <div class="card-body text-center">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-0">{$departmentStats.completion_rate}%</h4>
                            <small>Ефективність відділу</small>
                        </div>
                        <i class="bi bi-graph-up fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-primary text-white">
                <div class="card-body text-center">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-0">{$departmentStats.total_orders}</h4>
                            <small>Всього наказів</small>
                        </div>
                        <i class="bi bi-file-text-fill fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-info text-white">
                <div class="card-body text-center">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-0">{$departmentStats.active_orders}</h4>
                            <small>Активні накази</small>
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
                            <h4 class="mb-0">{$departmentStats.avg_completion_days|round:1}</h4>
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
                    <h5 class="mb-0">Інформація про відділ</h5>
                    <span class="badge bg-primary">ID: {$department.department_id}</span>
                </div>
                <div class="card-body">
                    <div class="mb-4">
                        <h6 class="fw-bold mb-2">Назва відділу:</h6>
                        <p>{$department.department_name}</p>
                    </div>
                    
                    {if $department.department_description}
                    <div class="mt-4">
                        <h6 class="fw-bold mb-2">Опис відділу:</h6>
                        <div class="p-3 bg-light rounded">
                            <p class="mb-0">{$department.department_description|nl2br}</p>
                        </div>
                    </div>
                    {/if}
                </div>
            </div>
            
            {if $executors|@count > 0}
            <div class="card mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Виконавці у відділі</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>ПІБ</th>
                                    <th>Посада</th>
                                    <th>Контакт</th>
                                    <th>Дії</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $executors as $executor}
                                    <tr>
                                        <td>{$executor.executor_name}</td>
                                        <td>{$executor.position_name|default:'-'}</td>
                                        <td>{$executor.executor_contact|default:'-'}</td>
                                        <td>
                                            <a href="/executors/{$executor.executor_id}" class="btn btn-sm btn-outline-primary">Деталі</a>
                                        </td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            {/if}
            
            {if $issuers|@count > 0}
            <div class="card mb-4">
                <div class="card-header bg-secondary text-white">
                    <h5 class="mb-0">Видавці у відділі</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>ПІБ</th>
                                    <th>Посада</th>
                                    <th>Контакт</th>
                                    <th>Дії</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $issuers as $issuer}
                                    <tr>
                                        <td>{$issuer.issuer_name}</td>
                                        <td>{$issuer.position_name|default:'-'}</td>
                                        <td>{$issuer.issuer_contact|default:'-'}</td>
                                        <td>
                                            <a href="/issuers/{$issuer.issuer_id}" class="btn btn-sm btn-outline-primary">Деталі</a>
                                        </td>
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
                                <h2 class="mb-1">{$executors|@count}</h2>
                                <p class="mb-0 text-muted">Виконавців</p>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stats-box rounded p-3 text-center bg-light">
                                <h2 class="mb-1">{$issuers|@count}</h2>
                                <p class="mb-0 text-muted">Видавців</p>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="stats-box rounded p-3 text-center bg-light">
                                <h2 class="mb-1">{$departmentOrders|@count}</h2>
                                <p class="mb-0 text-muted">Наказів</p>
                            </div>
                        </div>
                    </div>
                    
                    {if $departmentOrders|@count > 0}
                    <div class="mt-4">
                        <div class="mb-2 d-flex justify-content-between align-items-center">
                            <span>Активні накази:</span>
                            <span class="badge bg-warning">{$activeOrders|@count}</span>
                        </div>
                        <div class="mb-2 d-flex justify-content-between align-items-center">
                            <span>Виконані накази:</span>
                            <span class="badge bg-success">{$completedOrders|@count}</span>
                        </div>
                        <div class="mb-2 d-flex justify-content-between align-items-center">
                            <span>Прострочені накази:</span>
                            <span class="badge bg-danger">{$overdueOrders|@count}</span>
                        </div>
                    </div>
                    {/if}
                </div>
                {if $departmentOrders|@count > 0}
                <div class="card-footer">
                    <a href="/orders?department_id={$department.department_id}" class="btn btn-sm btn-outline-info w-100">
                        <i class="bi bi-search me-1"></i> Всі накази відділу
                    </a>
                </div>
                {/if}
            </div>
            
            <div class="card mb-4 border-danger">
                <div class="card-body">
                    <h5 class="text-danger mb-3">
                        <i class="bi bi-exclamation-triangle me-2"></i>Видалення
                    </h5>
                    <p class="small text-muted mb-3">Увага! Видалення відділу призведе до втрати зв'язку з виконавцями та видавцями наказів.</p>
                    <form action="/departments/{$department.department_id}/delete" method="POST" class="delete-form">
                        <button type="submit" class="btn btn-danger w-100">
                            <i class="bi bi-trash me-1"></i> Видалити відділ
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
        
        if (confirm('Ви впевнені, що хочете видалити цей відділ? Ця дія незворотна!')) {
            $(this).off('submit').submit();
        }
    });
});
</script>
{/block}
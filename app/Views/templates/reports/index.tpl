{extends file="../layout.tpl"}

{block name="content"}
    <div class="container">
        <h1 class="mb-4">Генерація звітів</h1>
        
        <!-- Аналітичний дашборд -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-primary text-white">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0">{$analytics.completion_rate}%</h4>
                                <small>Загальна ефективність</small>
                            </div>
                            <i class="bi bi-graph-up fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0">{$analytics.completed_orders}</h4>
                                <small>Виконано наказів</small>
                            </div>
                            <i class="bi bi-check-circle-fill fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-warning text-white">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0">{$analytics.active_orders}</h4>
                                <small>Активні накази</small>
                            </div>
                            <i class="bi bi-clock-history fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-danger text-white">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0">{$analytics.overdue_orders}</h4>
                                <small>Прострочені</small>
                            </div>
                            <i class="bi bi-exclamation-triangle-fill fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Детальна аналітика -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="bi bi-bar-chart"></i> Розподіл за пріоритетом</h5>
                    </div>
                    <div class="card-body">
                        {if $priorityDistribution|@count > 0}
                            {foreach $priorityDistribution as $priority}
                                <div class="mb-2">
                                    <div class="d-flex justify-content-between">
                                        <span class="badge {if $priority.priority == 'High'}bg-danger{elseif $priority.priority == 'Medium'}bg-warning{else}bg-secondary{/if}">
                                            {$priority.priority}
                                        </span>
                                        <span>{$priority.count}</span>
                                    </div>
                                    <div class="progress mt-1" style="height: 8px;">
                                        <div class="progress-bar {if $priority.priority == 'High'}bg-danger{elseif $priority.priority == 'Medium'}bg-warning{else}bg-secondary{/if}" 
                                             style="width: {($priority.count / $analytics.total_orders * 100)|round:1}%"></div>
                                    </div>
                                </div>
                            {/foreach}
                        {/if}
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="bi bi-pie-chart"></i> Розподіл за статусом</h5>
                    </div>
                    <div class="card-body">
                        {if $statusDistribution|@count > 0}
                            {foreach $statusDistribution as $status}
                                <div class="mb-2">
                                    <div class="d-flex justify-content-between">
                                        <span class="badge {if $status.status == 'completed'}bg-success{elseif $status.status == 'active'}bg-primary{elseif $status.status == 'overdue'}bg-danger{else}bg-secondary{/if}">
                                            {if $status.status == 'completed'}Виконано{elseif $status.status == 'active'}Активний{elseif $status.status == 'overdue'}Прострочений{else}{$status.status}{/if}
                                        </span>
                                        <span>{$status.count}</span>
                                    </div>
                                    <div class="progress mt-1" style="height: 8px;">
                                        <div class="progress-bar {if $status.status == 'completed'}bg-success{elseif $status.status == 'active'}bg-primary{elseif $status.status == 'overdue'}bg-danger{else}bg-secondary{/if}" 
                                             style="width: {($status.count / $analytics.total_orders * 100)|round:1}%"></div>
                                    </div>
                                </div>
                            {/foreach}
                        {/if}
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="bi bi-graph-down"></i> Тенденції по місяцях</h5>
                    </div>
                    <div class="card-body">
                        {if $monthlyTrends|@count > 0}
                            <div class="table-responsive">
                                <table class="table table-sm">
                                    <thead>
                                        <tr>
                                            <th>Місяць</th>
                                            <th>Кількість</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach $monthlyTrends as $trend}
                                            <tr>
                                                <td>{$trend.month}</td>
                                                <td>{$trend.count}</td>
                                            </tr>
                                        {/foreach}
                                    </tbody>
                                </table>
                            </div>
                        {else}
                            <p class="text-muted text-center">Немає даних</p>
                        {/if}
                    </div>
                </div>
            </div>
        </div>

        <!-- Топ виконавці та видавці -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="bi bi-trophy"></i> Топ-10 виконавців</h5>
                    </div>
                    <div class="card-body">
                        {if $topExecutors|@count > 0}
                            <div class="table-responsive">
                                <table class="table table-sm">
                                    <thead>
                                        <tr>
                                            <th>Виконавець</th>
                                            <th>Виконано</th>
                                            <th>Ефективність</th>
                                            <th>Оцінка</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach $topExecutors as $executor}
                                            <tr>
                                                <td>{$executor.executor_name}</td>
                                                <td>{$executor.completed_orders}/{$executor.total_orders}</td>
                                                <td>
                                                    <span class="badge {if $executor.completion_rate >= 80}bg-success{elseif $executor.completion_rate >= 60}bg-warning{else}bg-danger{/if}">
                                                        {$executor.completion_rate}%
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge bg-primary">
                                                        {$executor.performance_score}
                                                    </span>
                                                </td>
                                            </tr>
                                        {/foreach}
                                    </tbody>
                                </table>
                            </div>
                        {/if}
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="bi bi-award"></i> Топ-10 видавців</h5>
                    </div>
                    <div class="card-body">
                        {if $topIssuers|@count > 0}
                            <div class="table-responsive">
                                <table class="table table-sm">
                                    <thead>
                                        <tr>
                                            <th>Видавець</th>
                                            <th>Видано</th>
                                            <th>Виконано</th>
                                            <th>Активні</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach $topIssuers as $issuer}
                                            <tr>
                                                <td>{$issuer.issuer_name}</td>
                                                <td>{$issuer.total_orders}</td>
                                                <td>{$issuer.completed_orders}</td>
                                                <td>{$issuer.active_orders}</td>
                                            </tr>
                                        {/foreach}
                                    </tbody>
                                </table>
                            </div>
                        {/if}
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Доступні звіти</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-4">
                                <div class="card h-100">
                                    <div class="card-header bg-warning text-white">
                                        <h5 class="card-title mb-0 d-flex justify-content-between">
                                            <span>Активні накази</span>
                                            <span class="badge bg-light text-dark">{$activeOrdersCount}</span>
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <p class="card-text">
                                            Звіт містить інформацію про всі активні накази в системі, які ще не виконані.
                                        </p>
                                    </div>
                                    <div class="card-footer">
                                        <div class="d-flex justify-content-between">
                                            <a href="/reports/active-orders" class="btn btn-outline-primary">
                                                <i class="bi bi-eye"></i> Переглянути
                                            </a>
                                            <div class="btn-group">
                                                <a href="/reports/export/pdf/active-orders" class="btn btn-danger">
                                                    <i class="bi bi-file-pdf"></i> PDF
                                                </a>
                                                <a href="/reports/export/word/active-orders" class="btn btn-primary">
                                                    <i class="bi bi-file-word"></i> Word
                                                </a>
                                                <a href="/reports/export/excel/active-orders" class="btn btn-success">
                                                    <i class="bi bi-file-excel"></i> Excel
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6 mb-4">
                                <div class="card h-100">
                                    <div class="card-header bg-danger text-white">
                                        <h5 class="card-title mb-0 d-flex justify-content-between">
                                            <span>Прострочені накази</span>
                                            <span class="badge bg-light text-dark">{$overdueOrdersCount}</span>
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <p class="card-text">
                                            Звіт містить інформацію про всі прострочені накази, термін виконання яких минув.
                                        </p>
                                    </div>
                                    <div class="card-footer">
                                        <div class="d-flex justify-content-between">
                                            <a href="/reports/overdue-orders" class="btn btn-outline-primary">
                                                <i class="bi bi-eye"></i> Переглянути
                                            </a>
                                            <div class="btn-group">
                                                <a href="/reports/export/pdf/overdue-orders" class="btn btn-danger">
                                                    <i class="bi bi-file-pdf"></i> PDF
                                                </a>
                                                <a href="/reports/export/word/overdue-orders" class="btn btn-primary">
                                                    <i class="bi bi-file-word"></i> Word
                                                </a>
                                                <a href="/reports/export/excel/overdue-orders" class="btn btn-success">
                                                    <i class="bi bi-file-excel"></i> Excel
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <hr>
                        <h4 class="mb-3">Звіти по відділах</h4>
                        
                        <div class="row">
                            {foreach $departments as $dept}
                                <div class="col-md-4 mb-3">
                                    <div class="card h-100">
                                        <div class="card-body">
                                            <h5 class="card-title">{$dept.department_name}</h5>
                                            <p class="card-text small">
                                                Виконавців: {$dept.executor_count} | 
                                                Видавців: {$dept.issuer_count} |
                                                Наказів: {$dept.order_count}
                                            </p>
                                        </div>
                                        <div class="card-footer">
                                            <div class="d-flex justify-content-between">
                                                <a href="/reports/department/{$dept.department_id}" class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-eye"></i> Переглянути
                                                </a>
                                                <div class="btn-group">
                                                    <a href="/reports/export/pdf/department/{$dept.department_id}" class="btn btn-sm btn-danger">
                                                        <i class="bi bi-file-pdf"></i> PDF
                                                    </a>
                                                    <a href="/reports/export/word/department/{$dept.department_id}" class="btn btn-sm btn-primary">
                                                        <i class="bi bi-file-word"></i> Word
                                                    </a>
                                                    <a href="/reports/export/excel/department/{$dept.department_id}" class="btn btn-sm btn-success">
                                                        <i class="bi bi-file-excel"></i> Excel
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            {/foreach}
                        </div>
                        
                        <hr>
                        <h4 class="mb-3">Звіти по виконавцях</h4>
                        
                        <div class="row">
                            <div class="col-md-12">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>ПІБ</th>
                                                <th>Відділ</th>
                                                <th>Посада</th>
                                                <th>Дії</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {foreach $executors as $exec}
                                                <tr>
                                                    <td>{$exec.executor_name}</td>
                                                    <td>{$exec.department_name|default:'Не вказано'}</td>
                                                    <td>{$exec.position_name|default:'Не вказано'}</td>
                                                    <td>
                                                        <div class="btn-group">
                                                            <a href="/reports/executor/{$exec.executor_id}" class="btn btn-sm btn-outline-primary">
                                                                <i class="bi bi-eye"></i> Звіт
                                                            </a>
                                                            <a href="/reports/export/pdf/executor/{$exec.executor_id}" class="btn btn-sm btn-danger">
                                                                <i class="bi bi-file-pdf"></i> PDF
                                                            </a>
                                                            <a href="/reports/export/word/executor/{$exec.executor_id}" class="btn btn-sm btn-primary">
                                                                <i class="bi bi-file-word"></i> Word
                                                            </a>
                                                            <a href="/reports/export/excel/executor/{$exec.executor_id}" class="btn btn-sm btn-success">
                                                                <i class="bi bi-file-excel"></i> Excel
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            {/foreach}
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
{/block}

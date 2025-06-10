{extends file="../layout.tpl"}

{block name="content"}
    <div class="container mt-4">
        <h1 class="mb-4">Відділи компанії</h1>
        
        <!-- Аналітичні показники -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-primary text-white">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0">{$departments|@count}</h4>
                                <small>Всього відділів</small>
                            </div>
                            <i class="bi bi-building fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0">{$generalStats.completion_rate}%</h4>
                                <small>Загальна ефективність</small>
                            </div>
                            <i class="bi bi-graph-up fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-info text-white">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0">{$generalStats.active_orders}</h4>
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
                                <h4 class="mb-0">{$generalStats.overdue_orders}</h4>
                                <small>Прострочені</small>
                            </div>
                            <i class="bi bi-exclamation-triangle fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Розподіл за пріоритетом -->
        <div class="row mb-4">
            <div class="col-md-6">
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
                                        <span>{$priority.count} наказів</span>
                                    </div>
                                    <div class="progress mt-1" style="height: 8px;">
                                        <div class="progress-bar {if $priority.priority == 'High'}bg-danger{elseif $priority.priority == 'Medium'}bg-warning{else}bg-secondary{/if}" 
                                             style="width: {($priority.count / $generalStats.total_orders * 100)|round:1}%"></div>
                                    </div>
                                </div>
                            {/foreach}
                        {else}
                            <p class="text-muted">Немає даних для відображення.</p>
                        {/if}
                    </div>
                </div>
            </div>
            <div class="col-md-6">
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
                                        <span>{$status.count} наказів</span>
                                    </div>
                                    <div class="progress mt-1" style="height: 8px;">
                                        <div class="progress-bar {if $status.status == 'completed'}bg-success{elseif $status.status == 'active'}bg-primary{elseif $status.status == 'overdue'}bg-danger{else}bg-secondary{/if}" 
                                             style="width: {($status.count / $generalStats.total_orders * 100)|round:1}%"></div>
                                    </div>
                                </div>
                            {/foreach}
                        {else}
                            <p class="text-muted">Немає даних для відображення.</p>
                        {/if}
                    </div>
                </div>
            </div>
        </div>
        
        <div class="mb-3 d-flex justify-content-between">
            <a href="/departments/create" class="btn btn-primary">Додати новий відділ</a>
            
            <form action="/departments/search" method="GET" class="d-flex" role="search">
                <input class="form-control me-2" type="search" name="query" placeholder="Пошук відділів" aria-label="Search">
                <button class="btn btn-outline-success" type="submit">Пошук</button>
            </form>
        </div>
        
        {if $departments|@count > 0}
            <div class="row row-cols-1 row-cols-md-2 g-4">
                {foreach $departments as $department}
                    <div class="col">
                        <div class="card h-100">
                            <div class="card-header bg-info text-white">
                                <h5 class="card-title mb-0">{$department.department_name}</h5>
                            </div>
                            <div class="card-body">
                                <div class="department-stats">
                                    <div class="row text-center">
                                        <div class="col-6">
                                            <div class="stats-box p-3 border rounded">
                                                <h4>{$department.executor_count|default:0}</h4>
                                                <p class="mb-0">Виконавців</p>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="stats-box p-3 border rounded">
                                                <h4>{$department.issuer_count|default:0}</h4>
                                                <p class="mb-0">Видавців</p>
                                            </div>
                                        </div>
                                        <div class="col-12 mt-3">
                                            <div class="stats-box p-3 border rounded bg-light">
                                                <h4>{$department.order_count|default:0}</h4>
                                                <p class="mb-0">Всього наказів</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer">
                                <div class="btn-group w-100">
                                    <a href="/departments/{$department.department_id}" class="btn btn-sm btn-info">Перегляд</a>
                                    <a href="/departments/{$department.department_id}/edit" class="btn btn-sm btn-warning">Редагувати</a>
                                    <a href="/departments/{$department.department_id}/delete" class="btn btn-sm btn-danger" onclick="return confirm('Ви впевнені, що хочете видалити цей відділ?')">Видалити</a>
                                </div>
                            </div>
                        </div>
                    </div>
                {/foreach}
            </div>
        {else}
            <div class="alert alert-info">Відділів поки немає. <a href="/departments/create">Додати перший відділ</a></div>
        {/if}
    </div>
{/block}
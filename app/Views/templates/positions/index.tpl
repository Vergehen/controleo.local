{extends file="layout.tpl"}

{block name="content"}
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Посади</h1>
            <a href="/positions/create" class="btn btn-primary">
                <i class="bi bi-plus-circle me-1"></i> Додати посаду
            </a>
        </div>

        <!-- Аналітичні показники -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-primary text-white">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0">{$positions|@count}</h4>
                                <small>Всього посад</small>
                            </div>
                            <i class="bi bi-briefcase-fill fs-1 opacity-75"></i>
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
                                <h4 class="mb-0">{$generalStats.total_orders}</h4>
                                <small>Всього наказів</small>
                            </div>
                            <i class="bi bi-file-text-fill fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Топ виконавці та видавці -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="bi bi-trophy"></i> Топ-5 виконавців</h5>
                    </div>
                    <div class="card-body">
                        {if $topExecutors|@count > 0}
                            <div class="list-group list-group-flush">
                                {foreach $topExecutors as $key => $executor}
                                    <div class="list-group-item d-flex justify-content-between align-items-center border-0 px-0">
                                        <div>
                                            <strong>{$executor.executor_name}</strong><br>
                                            <small class="text-muted">{$executor.completed_orders}/{$executor.total_orders} наказів</small>
                                        </div>
                                        <span class="badge {if $executor.completion_rate >= 80}bg-success{elseif $executor.completion_rate >= 60}bg-warning{else}bg-danger{/if} rounded-pill">
                                            {$executor.completion_rate}%
                                        </span>
                                    </div>
                                {/foreach}
                            </div>
                        {else}
                            <p class="text-muted">Немає даних для відображення.</p>
                        {/if}
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="bi bi-award"></i> Топ-5 видавців</h5>
                    </div>
                    <div class="card-body">
                        {if $topIssuers|@count > 0}
                            <div class="list-group list-group-flush">
                                {foreach $topIssuers as $key => $issuer}
                                    <div class="list-group-item d-flex justify-content-between align-items-center border-0 px-0">
                                        <div>
                                            <strong>{$issuer.issuer_name}</strong><br>
                                            <small class="text-muted">{$issuer.total_orders} наказів видано</small>
                                        </div>
                                        <span class="badge bg-primary rounded-pill">
                                            {$issuer.orders_per_month|round:1}/міс
                                        </span>
                                    </div>
                                {/foreach}
                            </div>
                        {else}
                            <p class="text-muted">Немає даних для відображення.</p>
                        {/if}
                    </div>
                </div>
            </div>
        </div>

        <div class="card mb-4">
            <div class="card-header bg-light">
                <form action="/positions/search" method="GET" class="d-flex">
                    <input type="text" name="query" class="form-control me-2" placeholder="Пошук посад...">
                    <button type="submit" class="btn btn-outline-primary">
                        <i class="bi bi-search"></i>
                    </button>
                </form>
            </div>
            <div class="card-body">
                {if $positions|@count > 0}
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>
                                        <a href="/positions?sort=position_id&order={if $currentSort == 'position_id' && $currentOrder == 'ASC'}DESC{else}ASC{/if}" class="d-flex align-items-center text-decoration-none text-dark">
                                            ID
                                            {if $currentSort == 'position_id'}
                                                <i class="bi bi-arrow-{if $currentOrder == 'ASC'}down{else}up{/if} ms-1"></i>
                                            {/if}
                                        </a>
                                    </th>
                                    <th>
                                        <a href="/positions?sort=position_name&order={if $currentSort == 'position_name' && $currentOrder == 'ASC'}DESC{else}ASC{/if}" class="d-flex align-items-center text-decoration-none text-dark">
                                            Назва посади
                                            {if $currentSort == 'position_name'}
                                                <i class="bi bi-arrow-{if $currentOrder == 'ASC'}down{else}up{/if} ms-1"></i>
                                            {/if}
                                        </a>
                                    </th>
                                    <th>
                                        <a href="/positions?sort=executors_count&order={if $currentSort == 'executors_count' && $currentOrder == 'ASC'}DESC{else}ASC{/if}" class="d-flex align-items-center text-decoration-none text-dark">
                                            Виконавців
                                            {if $currentSort == 'executors_count'}
                                                <i class="bi bi-arrow-{if $currentOrder == 'ASC'}down{else}up{/if} ms-1"></i>
                                            {/if}
                                        </a>
                                    </th>
                                    <th>
                                        <a href="/positions?sort=issuers_count&order={if $currentSort == 'issuers_count' && $currentOrder == 'ASC'}DESC{else}ASC{/if}" class="d-flex align-items-center text-decoration-none text-dark">
                                            Видавців
                                            {if $currentSort == 'issuers_count'}
                                                <i class="bi bi-arrow-{if $currentOrder == 'ASC'}down{else}up{/if} ms-1"></i>
                                            {/if}
                                        </a>
                                    </th>
                                    <th>
                                        <a href="/positions?sort=total_count&order={if $currentSort == 'total_count' && $currentOrder == 'ASC'}DESC{else}ASC{/if}" class="d-flex align-items-center text-decoration-none text-dark">
                                            Всього співробітників
                                            {if $currentSort == 'total_count'}
                                                <i class="bi bi-arrow-{if $currentOrder == 'ASC'}down{else}up{/if} ms-1"></i>
                                            {/if}
                                        </a>
                                    </th>
                                    <th>Дії</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $positions as $position}
                                    <tr>
                                        <td>{$position.position_id}</td>
                                        <td>
                                            <a href="/positions/{$position.position_id}">{$position.position_name}</a>
                                        </td>
                                        <td>{$position.executors_count}</td>
                                        <td>{$position.issuers_count}</td>
                                        <td>{$position.total_count}</td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="/positions/{$position.position_id}" class="btn btn-sm btn-info">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <a href="/positions/{$position.position_id}/edit" class="btn btn-sm btn-warning">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <form action="/positions/{$position.position_id}/delete" method="POST" class="d-inline delete-form">
                                                    <button type="submit" class="btn btn-sm btn-danger">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                {else}
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle me-2"></i> Посади не знайдено
                    </div>
                {/if}
            </div>
        </div>
    </div>
{/block}

{block name="scripts"}
<script>
$(document).ready(function() {
    $('.delete-form').on('submit', function(e) {
        e.preventDefault();
        
        if (confirm('Ви впевнені, що хочете видалити цю посаду? Ця дія незворотна!')) {
            $(this).off('submit').submit();
        }
    });
});
</script>
{/block}
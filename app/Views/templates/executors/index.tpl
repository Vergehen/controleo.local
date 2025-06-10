{extends file="../layout.tpl"}

{block name="content"}
    <div class="container mt-4">
        <h1 class="mb-4">Виконавці наказів</h1>
        
        <!-- Аналітичні показники -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0">{$generalStats.completion_rate}%</h4>
                                <small>Загальна ефективність</small>
                            </div>
                            <i class="bi bi-person-check-fill fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-primary text-white">
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
            <div class="col-md-3">
                <div class="card bg-info text-white">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0">{$generalStats.avg_completion_days|round:1}</h4>
                                <small>Середня тривалість (днів)</small>
                            </div>
                            <i class="bi bi-clock-fill fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-warning text-white">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h4 class="mb-0">{$executors|@count}</h4>
                                <small>Всього виконавців</small>
                            </div>
                            <i class="bi bi-people-fill fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Топ виконавці -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="bi bi-trophy"></i> Топ-10 виконавців за ефективністю</h5>
                    </div>
                    <div class="card-body">
                        {if $topExecutors|@count > 0}
                            <div class="table-responsive">
                                <table class="table table-sm">
                                    <thead>
                                        <tr>
                                            <th>Рейтинг</th>
                                            <th>Виконавець</th>
                                            <th>Виконано</th>
                                            <th>Всього</th>
                                            <th>Ефективність</th>
                                            <th>Оцінка</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach $topExecutors as $key => $executor}
                                            <tr>
                                                <td>
                                                    {if $key == 0}
                                                        <i class="bi bi-trophy-fill text-warning"></i>
                                                    {elseif $key == 1}
                                                        <i class="bi bi-award-fill text-secondary"></i>
                                                    {elseif $key == 2}
                                                        <i class="bi bi-award-fill text-danger"></i>
                                                    {else}
                                                        {$key + 1}
                                                    {/if}
                                                </td>
                                                <td>
                                                    <a href="/executors/show/{$executor.executor_id}" class="text-decoration-none">
                                                        {$executor.executor_name}
                                                    </a>
                                                </td>
                                                <td>{$executor.completed_orders}</td>
                                                <td>{$executor.total_orders}</td>
                                                <td>
                                                    <div class="progress" style="height: 20px;">
                                                        <div class="progress-bar {if $executor.completion_rate >= 80}bg-success{elseif $executor.completion_rate >= 60}bg-warning{else}bg-danger{/if}" 
                                                             role="progressbar" 
                                                             style="width: {$executor.completion_rate}%">
                                                            {$executor.completion_rate}%
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="badge {if $executor.performance_score >= 80}bg-success{elseif $executor.performance_score >= 60}bg-warning{else}bg-danger{/if}">
                                                        {$executor.performance_score}
                                                    </span>
                                                </td>
                                            </tr>
                                        {/foreach}
                                    </tbody>
                                </table>
                            </div>
                        {else}
                            <p class="text-muted">Немає даних для відображення.</p>
                        {/if}
                    </div>
                </div>
            </div>
        </div>
        
        <div class="mb-3 d-flex justify-content-between">
            <a href="/executors/create" class="btn btn-primary">Додати нового виконавця</a>
            
            <form action="/executors/search" method="GET" class="d-flex" role="search">
                <input class="form-control me-2" type="search" name="query" placeholder="Пошук виконавців" aria-label="Search">
                <button class="btn btn-outline-success" type="submit">Пошук</button>
            </form>
        </div>
        
        {if $executors|@count > 0}
            <div class="row row-cols-1 row-cols-md-3 g-4">
                {foreach $executors as $executor}
                    <div class="col">
                        <div class="card h-100">
                            <div class="card-header bg-primary text-white">
                                <h5 class="card-title mb-0">{$executor.executor_name}</h5>
                            </div>
                            <div class="card-body">
                                <p class="card-text">
                                    <strong>Контакт:</strong> {$executor.executor_contact|default:"Не вказано"}
                                </p>
                                <p class="card-text">
                                    <strong>Відділ:</strong> {$executor.department_name|default:"Не вказано"}
                                </p>
                                <p class="card-text">
                                    <strong>Посада:</strong> {$executor.position_name|default:"Не вказано"}
                                </p>
                            </div>
                            <div class="card-footer">
                                <div class="btn-group w-100">
                                    <a href="/executors/{$executor.executor_id}" class="btn btn-sm btn-info">Перегляд</a>
                                    <a href="/executors/{$executor.executor_id}/edit" class="btn btn-sm btn-warning">Редагувати</a>
                                    <a href="/executors/{$executor.executor_id}/delete" class="btn btn-sm btn-danger" onclick="return confirm('Ви впевнені, що хочете видалити цього виконавця?')">Видалити</a>
                                </div>
                            </div>
                        </div>
                    </div>
                {/foreach}
            </div>
        {else}
            <div class="alert alert-info">Виконавців поки немає. <a href="/executors/create">Додати першого виконавця</a></div>
        {/if}
    </div>
{/block}
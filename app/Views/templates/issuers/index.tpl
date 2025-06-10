{extends file="../layout.tpl"}

{block name="content"}
    <div class="container mt-4">
        <h1 class="mb-4">Видавці наказів</h1>
        
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
                            <i class="bi bi-person-plus-fill fs-1 opacity-75"></i>
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
                            <i class="bi bi-file-earmark-plus-fill fs-1 opacity-75"></i>
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
                                <h4 class="mb-0">{$issuers|@count}</h4>
                                <small>Всього видавців</small>
                            </div>
                            <i class="bi bi-people-fill fs-1 opacity-75"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Топ видавці -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="bi bi-award"></i> Топ-10 видавців за активністю</h5>
                    </div>
                    <div class="card-body">
                        {if $topIssuers|@count > 0}
                            <div class="table-responsive">
                                <table class="table table-sm">
                                    <thead>
                                        <tr>
                                            <th>Рейтинг</th>
                                            <th>Видавець</th>
                                            <th>Видано наказів</th>
                                            <th>Виконано</th>
                                            <th>Активні</th>
                                            <th>Середня тривалість</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach $topIssuers as $key => $issuer}
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
                                                    <a href="/issuers/show/{$issuer.issuer_id}" class="text-decoration-none">
                                                        {$issuer.issuer_name}
                                                    </a>
                                                </td>
                                                <td>{$issuer.total_orders}</td>
                                                <td>{$issuer.completed_orders}</td>
                                                <td>{$issuer.active_orders}</td>
                                                <td>{$issuer.avg_completion_days|round:1} днів</td>
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
            <a href="/issuers/create" class="btn btn-primary">Додати нового видавця</a>
            
            <form action="/issuers/search" method="GET" class="d-flex" role="search">
                <input class="form-control me-2" type="search" name="query" placeholder="Пошук видавців" aria-label="Search">
                <button class="btn btn-outline-success" type="submit">Пошук</button>
            </form>
        </div>
        
        {if $issuers|@count > 0}
            <div class="row row-cols-1 row-cols-md-3 g-4">
                {foreach $issuers as $issuer}
                    <div class="col">
                        <div class="card h-100">
                            <div class="card-header bg-success text-white">
                                <h5 class="card-title mb-0">{$issuer.issuer_name}</h5>
                            </div>
                            <div class="card-body">
                                <p class="card-text">
                                    <strong>Контакт:</strong> {$issuer.issuer_contact|default:"Не вказано"}
                                </p>
                                <p class="card-text">
                                    <strong>Відділ:</strong> {$issuer.department_name|default:"Не вказано"}
                                </p>
                                <p class="card-text">
                                    <strong>Посада:</strong> {$issuer.position_name|default:"Не вказано"}
                                </p>
                            </div>
                            <div class="card-footer">
                                <div class="btn-group w-100">
                                    <a href="/issuers/{$issuer.issuer_id}" class="btn btn-sm btn-info">Перегляд</a>
                                    <a href="/issuers/{$issuer.issuer_id}/edit" class="btn btn-sm btn-warning">Редагувати</a>
                                    <a href="/issuers/{$issuer.issuer_id}/delete" class="btn btn-sm btn-danger" onclick="return confirm('Ви впевнені, що хочете видалити цього видавця?')">Видалити</a>
                                </div>
                            </div>
                        </div>
                    </div>
                {/foreach}
            </div>
        {else}
            <div class="alert alert-info">Видавців поки немає. <a href="/issuers/create">Додати першого видавця</a></div>
        {/if}
    </div>
{/block}
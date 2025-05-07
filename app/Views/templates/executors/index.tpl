{extends file="../layout.tpl"}

{block name="content"}
    <div class="container mt-4">
        <h1 class="mb-4">Виконавці наказів</h1>
        
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
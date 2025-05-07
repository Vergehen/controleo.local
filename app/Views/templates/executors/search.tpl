{extends file="layout.tpl"}

{block name="content"}
    <div class="mb-4">
        <h1>Результати пошуку виконавців: "{$query}"</h1>
        <p>Знайдено результатів: {$executors|@count}</p>
        <a href="/executors" class="btn btn-outline-secondary">Повернутися до списку виконавців</a>
    </div>

    {if $executors}
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Виконавці</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>ПІБ виконавця</th>
                                <th>Контакт</th>
                                <th>Дії</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $executors as $executor}
                                <tr>
                                    <td>{$executor.executor_id}</td>
                                    <td>{$executor.executor_name}</td>
                                    <td>{$executor.executor_contact}</td>
                                    <td>
                                        <a href="/executors/{$executor.executor_id}" class="btn btn-sm btn-outline-primary">Детальніше</a>
                                        <a href="/executors/{$executor.executor_id}/edit" class="btn btn-sm btn-outline-secondary">Редагувати</a>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    {else}
        <div class="alert alert-info">
            <h4>Нічого не знайдено</h4>
            <p>На жаль, за вашим запитом не знайдено виконавців. Спробуйте змінити пошуковий запит.</p>
        </div>
    {/if}
{/block}
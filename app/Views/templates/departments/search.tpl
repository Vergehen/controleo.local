{extends file="layout.tpl"}

{block name="content"}
    <div class="mb-4">
        <h1>Результати пошуку відділів: "{$query}"</h1>
        <p>Знайдено результатів: {$departments|@count}</p>
        <a href="/departments" class="btn btn-outline-secondary">Повернутися до списку відділів</a>
    </div>

    {if $departments}
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Відділи</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Назва відділу</th>
                                <th>Дії</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $departments as $department}
                                <tr>
                                    <td>{$department.department_id}</td>
                                    <td>{$department.department_name}</td>
                                    <td>
                                        <a href="/departments/{$department.department_id}" class="btn btn-sm btn-outline-primary">Детальніше</a>
                                        <a href="/departments/{$department.department_id}/edit" class="btn btn-sm btn-outline-secondary">Редагувати</a>
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
            <p>На жаль, за вашим запитом не знайдено відділів. Спробуйте змінити пошуковий запит.</p>
        </div>
    {/if}
{/block}
{extends file="layout.tpl"}

{block name="content"}
    <div class="mb-4">
        <h1>Результати пошуку видавців: "{$query}"</h1>
        <p>Знайдено результатів: {$issuers|@count}</p>
        <a href="/issuers" class="btn btn-outline-secondary">Повернутися до списку видавців</a>
    </div>

    {if $issuers}
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Видавці наказів</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>ПІБ видавця</th>
                                <th>Контакт</th>
                                <th>Дії</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $issuers as $issuer}
                                <tr>
                                    <td>{$issuer.issuer_id}</td>
                                    <td>{$issuer.issuer_name}</td>
                                    <td>{$issuer.issuer_contact}</td>
                                    <td>
                                        <a href="/issuers/{$issuer.issuer_id}" class="btn btn-sm btn-outline-primary">Детальніше</a>
                                        <a href="/issuers/{$issuer.issuer_id}/edit" class="btn btn-sm btn-outline-secondary">Редагувати</a>
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
            <p>На жаль, за вашим запитом не знайдено видавців. Спробуйте змінити пошуковий запит.</p>
        </div>
    {/if}
{/block}
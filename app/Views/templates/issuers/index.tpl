{extends file="../layout.tpl"}

{block name="content"}
    <div class="container mt-4">
        <h1 class="mb-4">Видавці наказів</h1>
        
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
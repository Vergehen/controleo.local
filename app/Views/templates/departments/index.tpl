{extends file="../layout.tpl"}

{block name="content"}
    <div class="container mt-4">
        <h1 class="mb-4">Відділи компанії</h1>
        
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
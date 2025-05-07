{extends file="../layout.tpl"}

{block name="content"}
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>{$title}</h1>
            <div>
                <a href="/reports" class="btn btn-outline-secondary me-2">
                    <i class="bi bi-arrow-left"></i> Назад до звітів
                </a>
                <div class="btn-group">
                    <a href="/reports/export/pdf/department/{$department.department_id}" class="btn btn-danger">
                        <i class="bi bi-file-pdf"></i> PDF
                    </a>
                    <a href="/reports/export/word/department/{$department.department_id}" class="btn btn-primary">
                        <i class="bi bi-file-word"></i> Word
                    </a>
                    <a href="/reports/export/excel/department/{$department.department_id}" class="btn btn-success">
                        <i class="bi bi-file-excel"></i> Excel
                    </a>
                </div>
            </div>
        </div>
        
        <div class="card mb-4">
            <div class="card-header bg-light">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Інформація про відділ</h5>
                    <span>Звіт сформовано: {$generated_date|date_format:"%d.%m.%Y %H:%M"}</span>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>ID відділу:</strong> {$department.department_id}</p>
                        <p><strong>Назва відділу:</strong> {$department.department_name}</p>
                    </div>
                    <div class="col-md-6">
                        <div class="row">
                            <div class="col-6">
                                <div class="card bg-light p-3 text-center">
                                    <h4>{$executors|@count}</h4>
                                    <p class="mb-0">Виконавців</p>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="card bg-light p-3 text-center">
                                    <h4>{$issuers|@count}</h4>
                                    <p class="mb-0">Видавців</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        {if $executors|@count > 0}
            <div class="card mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Виконавці у відділі</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th scope="col">ID</th>
                                    <th scope="col">ПІБ</th>
                                    <th scope="col">Посада</th>
                                    <th scope="col">Контакт</th>
                                    <th scope="col">Дії</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $executors as $executor}
                                    <tr>
                                        <td>{$executor.executor_id}</td>
                                        <td>{$executor.executor_name}</td>
                                        <td>{$executor.position_name|default:'Не вказано'}</td>
                                        <td>{$executor.executor_contact|default:'Не вказано'}</td>
                                        <td>
                                            <a href="/executors/{$executor.executor_id}" class="btn btn-sm btn-info">Деталі</a>
                                            <a href="/reports/executor/{$executor.executor_id}" class="btn btn-sm btn-outline-primary">Звіт</a>
                                        </td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        {/if}
        
        {if $issuers|@count > 0}
            <div class="card mb-4">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">Видавці у відділі</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th scope="col">ID</th>
                                    <th scope="col">ПІБ</th>
                                    <th scope="col">Посада</th>
                                    <th scope="col">Контакт</th>
                                    <th scope="col">Дії</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $issuers as $issuer}
                                    <tr>
                                        <td>{$issuer.issuer_id}</td>
                                        <td>{$issuer.issuer_name}</td>
                                        <td>{$issuer.position_name|default:'Не вказано'}</td>
                                        <td>{$issuer.issuer_contact|default:'Не вказано'}</td>
                                        <td>
                                            <a href="/issuers/{$issuer.issuer_id}" class="btn btn-sm btn-info">Деталі</a>
                                        </td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        {/if}
        
        {if $orders|@count > 0}
            <div class="card mb-4">
                <div class="card-header bg-warning text-dark">
                    <h5 class="mb-0">Накази відділу</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th scope="col">ID</th>
                                    <th scope="col">Назва наказу</th>
                                    <th scope="col">Виконавець</th>
                                    <th scope="col">Видавець</th>
                                    <th scope="col">Дедлайн</th>
                                    <th scope="col">Статус</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $orders as $order}
                                    <tr>
                                        <td>{$order.order_id}</td>
                                        <td>
                                            <a href="/orders/{$order.order_id}">{$order.order_name}</a>
                                        </td>
                                        <td>{$order.executor_name}</td>
                                        <td>{$order.issuer_name}</td>
                                        <td class="format-date">{$order.order_deadline}</td>
                                        <td>
                                            {if $order.order_status == 'completed'}
                                                <span class="badge bg-success">виконано</span>
                                            {elseif $order.order_status == 'overdue'}
                                                <span class="badge bg-danger">прострочено</span>
                                            {else}
                                                <span class="badge bg-warning">активний</span>
                                            {/if}
                                        </td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        {/if}
    </div>
{/block}
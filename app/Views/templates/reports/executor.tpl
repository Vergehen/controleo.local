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
                    <a href="/reports/export/pdf/executor/{$executor.executor_id}" class="btn btn-danger">
                        <i class="bi bi-file-pdf"></i> PDF
                    </a>
                    <a href="/reports/export/word/executor/{$executor.executor_id}" class="btn btn-primary">
                        <i class="bi bi-file-word"></i> Word
                    </a>
                    <a href="/reports/export/excel/executor/{$executor.executor_id}" class="btn btn-success">
                        <i class="bi bi-file-excel"></i> Excel
                    </a>
                </div>
            </div>
        </div>
        
        <div class="card mb-4">
            <div class="card-header bg-light">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Інформація про виконавця</h5>
                    <span>Звіт сформовано: {$generated_date|date_format:"%d.%m.%Y %H:%M"}</span>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>ID виконавця:</strong> {$executor.executor_id}</p>
                        <p><strong>ПІБ:</strong> {$executor.executor_name}</p>
                        <p><strong>Контакт:</strong> {$executor.executor_contact|default:'Не вказано'}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Відділ:</strong> {$executor.department_name}</p>
                        <p><strong>Посада:</strong> {$executor.position_name}</p>
                    </div>
                </div>
            </div>
        </div>
        
        {if $orders|@count > 0}
            <div class="card mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Накази виконавця</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th scope="col">ID</th>
                                    <th scope="col">Назва наказу</th>
                                    <th scope="col">Видавець</th>
                                    <th scope="col">Дата видачі</th>
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
                                        <td>{$order.issuer_name}</td>
                                        <td class="format-date">{$order.order_date_issued}</td>
                                        <td class="format-date">{$order.order_deadline}</td>
                                        <td>
                                            {if $order.order_status == 'completed'}
                                                <span class="badge bg-success">виконано</span>
                                            {elseif $order.order_status == 'overdue' || ($order.order_deadline < $smarty.now|date_format:"%Y-%m-%d" && !$order.order_date_completed)}
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
            
            <div class="card mb-4">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0">Статистика по наказах</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        {assign var="active_count" value=0}
                        {assign var="completed_count" value=0}
                        {assign var="overdue_count" value=0}
                        
                        {foreach $orders as $order}
                            {if $order.order_status == 'completed'}
                                {assign var="completed_count" value=$completed_count+1}
                            {elseif $order.order_status == 'overdue' || ($order.order_deadline < $smarty.now|date_format:"%Y-%m-%d" && !$order.order_date_completed)}
                                {assign var="overdue_count" value=$overdue_count+1}
                            {else}
                                {assign var="active_count" value=$active_count+1}
                            {/if}
                        {/foreach}
                        
                        <div class="col-md-4">
                            <div class="card bg-warning text-white p-3 text-center">
                                <h4>{$active_count}</h4>
                                <p class="mb-0">Активних наказів</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card bg-success text-white p-3 text-center">
                                <h4>{$completed_count}</h4>
                                <p class="mb-0">Виконаних наказів</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card bg-danger text-white p-3 text-center">
                                <h4>{$overdue_count}</h4>
                                <p class="mb-0">Прострочених наказів</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        {else}
            <div class="alert alert-info">
                <i class="bi bi-info-circle me-2"></i> У цього виконавця немає наказів.
            </div>
        {/if}
    </div>
{/block}

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
                    <a href="/reports/export/pdf/overdue-orders" class="btn btn-danger">
                        <i class="bi bi-file-pdf"></i> PDF
                    </a>
                    <a href="/reports/export/word/overdue-orders" class="btn btn-primary">
                        <i class="bi bi-file-word"></i> Word
                    </a>
                    <a href="/reports/export/excel/overdue-orders" class="btn btn-success">
                        <i class="bi bi-file-excel"></i> Excel
                    </a>
                </div>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header bg-light">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Прострочені накази станом на {$generated_date|date_format:"%d.%m.%Y %H:%M"}</h5>
                    <span class="badge bg-danger">{$orders|@count} записів</span>
                </div>
            </div>
            <div class="card-body">
                {if $orders|@count > 0}
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th scope="col">#</th>
                                    <th scope="col">Назва наказу</th>
                                    <th scope="col">Виконавець</th>
                                    <th scope="col">Видавець</th>
                                    <th scope="col">Дедлайн</th>
                                    <th scope="col">Прострочено (днів)</th>
                                </tr>
                            </thead>                            <tbody>
                                {foreach $orders as $order}
                                    {assign var="deadline_timestamp" value=$order.order_deadline|strtotime}
                                    {assign var="current_timestamp" value=$smarty.now}
                                    {assign var="diff_seconds" value=$current_timestamp - $deadline_timestamp}
                                    {assign var="days_overdue" value=($diff_seconds / 86400)|floor}
                                    <tr>
                                        <td>{$order.order_id}</td>
                                        <td>
                                            <a href="/orders/{$order.order_id}">{$order.order_name}</a>
                                        </td>
                                        <td>{$order.executor_name}</td>
                                        <td>{$order.issuer_name}</td>
                                        <td class="format-date">{$order.order_deadline}</td>
                                        <td>
                                            <span class="text-danger fw-bold">{$days_overdue}</span>
                                        </td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                {else}
                    <div class="alert alert-info mb-0">
                        <i class="bi bi-info-circle me-2"></i> Прострочених наказів не знайдено.
                    </div>
                {/if}
            </div>
        </div>
    </div>
{/block}

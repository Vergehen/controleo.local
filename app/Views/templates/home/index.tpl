{extends file="layout.tpl"}

{block name="content"}
    <div class="jumbotron bg-light p-5 rounded">
        <h1 class="display-4">Система контролю за виконанням наказів</h1>
        <p class="lead">Комплексна система управління та контролю наказів з аналітикою продуктивності.</p>
        <hr class="my-4">
        <p>Ця система дозволяє додавати накази, слідкувати за виконавцями та дедлайнами, аналізувати продуктивність та генерувати звіти.</p>
        <div class="d-flex gap-2">
            <a class="btn btn-primary" href="/orders/create" role="button">Новий наказ</a>
            <a class="btn btn-outline-primary" href="/orders" role="button">Всі накази</a>
        </div>
    </div>

    <!-- Аналітичний дашборд -->
    <div class="row mt-4 mb-4">
        <div class="col-md-3">
            <div class="card bg-primary text-white">
                <div class="card-body text-center">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-0">{$analytics.completion_rate}%</h4>
                            <small>Загальна ефективність</small>
                        </div>
                        <i class="bi bi-graph-up fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-success text-white">
                <div class="card-body text-center">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-0">{$analytics.completed_orders}</h4>
                            <small>Виконано наказів</small>
                        </div>
                        <i class="bi bi-check-circle-fill fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-warning text-white">
                <div class="card-body text-center">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-0">{$analytics.active_orders}</h4>
                            <small>Активні накази</small>
                        </div>
                        <i class="bi bi-clock-history fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-danger text-white">
                <div class="card-body text-center">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-0">{$analytics.overdue_orders}</h4>
                            <small>Прострочені</small>
                        </div>
                        <i class="bi bi-exclamation-triangle-fill fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Топ виконавці та видавці -->
    <div class="row mb-4">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-trophy"></i> Топ-5 виконавців</h5>
                </div>
                <div class="card-body">
                    {if $topExecutors|@count > 0}
                        <div class="list-group list-group-flush">
                            {foreach $topExecutors as $key => $executor}
                                <div class="list-group-item d-flex justify-content-between align-items-center border-0 px-0">
                                    <div>
                                        <strong>
                                            {if $key == 0}
                                                <i class="bi bi-trophy-fill text-warning"></i>
                                            {elseif $key == 1}
                                                <i class="bi bi-award-fill text-secondary"></i>
                                            {elseif $key == 2}
                                                <i class="bi bi-award-fill text-danger"></i>
                                            {/if}
                                            {$executor.executor_name}
                                        </strong><br>
                                        <small class="text-muted">{$executor.completed_orders}/{$executor.total_orders} наказів</small>
                                    </div>
                                    <span class="badge {if $executor.completion_rate >= 80}bg-success{elseif $executor.completion_rate >= 60}bg-warning{else}bg-danger{/if} rounded-pill">
                                        {$executor.completion_rate}%
                                    </span>
                                </div>
                            {/foreach}
                        </div>
                    {else}
                        <p class="text-muted">Немає даних для відображення.</p>
                    {/if}
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-award"></i> Топ-5 видавців</h5>
                </div>
                <div class="card-body">
                    {if $topIssuers|@count > 0}
                        <div class="list-group list-group-flush">
                            {foreach $topIssuers as $key => $issuer}
                                <div class="list-group-item d-flex justify-content-between align-items-center border-0 px-0">
                                    <div>
                                        <strong>
                                            {if $key == 0}
                                                <i class="bi bi-trophy-fill text-warning"></i>
                                            {elseif $key == 1}
                                                <i class="bi bi-award-fill text-secondary"></i>
                                            {elseif $key == 2}
                                                <i class="bi bi-award-fill text-danger"></i>
                                            {/if}
                                            {$issuer.issuer_name}
                                        </strong><br>
                                        <small class="text-muted">{$issuer.total_orders} наказів видано</small>
                                    </div>
                                    <span class="badge bg-primary rounded-pill">
                                        {$issuer.orders_per_month|round:1}/міс
                                    </span>
                                </div>
                            {/foreach}
                        </div>
                    {else}
                        <p class="text-muted">Немає даних для відображення.</p>
                    {/if}
                </div>
            </div>
        </div>
    </div>

    <div class="row mt-5">
        <div class="col-md-6 mb-4">
            <div class="card h-100">
                <div class="card-header bg-warning text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Активні накази</h5>
                    <span class="badge bg-light text-dark">{$activeOrders|@count}</span>
                </div>
                <div class="card-body">
                    {if $activeOrders}
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Назва</th>
                                        <th>Виконавець</th>
                                        <th>Дедлайн</th>
                                        <th>Пріоритет</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach $activeOrders as $order}
                                        <tr>
                                            <td><a href="/orders/{$order.order_id}">{$order.order_name}</a></td>
                                            <td>{$order.executor_name}</td>
                                            <td>{$order.order_deadline}</td>
                                            <td>
                                                {if $order.order_priority == 'high'}
                                                    <span class="badge bg-danger">високий</span>
                                                {elseif $order.order_priority == 'medium'}
                                                    <span class="badge bg-warning">середній</span>
                                                {else}
                                                    <span class="badge bg-info">низький</span>
                                                {/if}
                                            </td>
                                        </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                        <a href="/orders/active" class="btn btn-outline-warning mt-2">Показати всі активні накази</a>
                    {else}
                        <p class="text-muted">Немає активних наказів</p>
                    {/if}
                </div>
            </div>
        </div>

        <div class="col-md-6 mb-4">
            <div class="card h-100">
                <div class="card-header bg-danger text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Прострочені накази</h5>
                    <span class="badge bg-light text-dark">{$overdueOrders|@count}</span>
                </div>
                <div class="card-body">
                    {if $overdueOrders}
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Назва</th>
                                        <th>Виконавець</th>
                                        <th>Дедлайн</th>
                                        <th>Прострочено днів</th>
                                    </tr>
                                </thead>
                                <tbody>                                    {foreach $overdueOrders as $order}
                                        {assign var="deadline_timestamp" value=$order.order_deadline|strtotime}
                                        {assign var="current_timestamp" value=$smarty.now}
                                        {assign var="diff_seconds" value=$current_timestamp - $deadline_timestamp}
                                        {assign var="days_overdue" value=($diff_seconds / 86400)|floor}
                                        <tr>
                                            <td><a href="/orders/{$order.order_id}">{$order.order_name}</a></td>
                                            <td>{$order.executor_name}</td>
                                            <td>{$order.order_deadline}</td>
                                            <td><span class="text-danger">{$days_overdue} днів</span></td>
                                        </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                        <a href="/orders/overdue" class="btn btn-outline-danger mt-2">Показати всі прострочені</a>
                    {else}
                        <p class="text-muted">Немає прострочених наказів</p>
                    {/if}
                </div>
            </div>
        </div>
    </div>

    <div class="row mt-4">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Відділи</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        {foreach $departments as $dept}
                            <div class="col-md-4 col-sm-6 mb-3">
                                <div class="card h-100">
                                    <div class="card-body">
                                        <h5 class="card-title">{$dept.department_name}</h5>
                                        <p class="card-text">
                                            <a href="/departments/{$dept.department_id}" class="btn btn-sm btn-outline-primary">Детальніше</a>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        {foreachelse}
                            <div class="col-12">
                                <p class="text-muted">Немає відділів в базі даних</p>
                            </div>
                        {/foreach}
                    </div>
                </div>
            </div>
        </div>
    </div>
{/block}

{block name="scripts"}
<script>
    $(document).ready(function() {
        // Fix the overdue days display (convert to integer)
        $('.text-danger').each(function() {
            const text = $(this).text();
            if (text.includes('днів')) {
                const daysText = text.split(' ')[0];
                const days = parseFloat(daysText);
                if (!isNaN(days)) {
                    const roundedDays = Math.floor(days);
                    $(this).text(roundedDays + ' днів');
                }
            }
        });
        
        // Initialize deadline countdown display
        $('.deadline-countdown').each(function() {
            const deadline = new Date($(this).data('deadline'));
            const today = new Date();
            const daysLeft = Math.ceil((deadline - today) / (1000 * 60 * 60 * 24));
            
            if (daysLeft < 0) {
                const daysOverdue = Math.abs(Math.floor(daysLeft));
                $(this).text("Прострочено на " + daysOverdue + " днів")
                      .addClass('text-danger fw-bold');
            }
        });
    });
</script>
{/block}
{extends file="layout.tpl"}

{block name="content"}
    <div class="mb-4">
        <h1>Результати пошуку наказів: "{$query}"</h1>
        <p>Знайдено результатів: {$orders|@count}</p>
        <a href="/orders" class="btn btn-outline-secondary">Повернутися до списку наказів</a>
    </div>

    {if $orders}
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Накази</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Назва</th>
                                <th>Видавець</th>
                                <th>Виконавець</th>
                                <th>Дедлайн</th>
                                <th>Статус</th>
                                <th>Пріоритет</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $orders as $order}
                                <tr>
                                    <td><a href="/orders/{$order.order_id}">{$order.order_name}</a></td>
                                    <td>{$order.issuer_name}</td>
                                    <td>{$order.executor_name}</td>
                                    <td>{$order.order_deadline}</td>
                                    <td>
                                        {if $order.order_status == 'completed'}
                                            <span class="badge bg-success">Виконано</span>
                                        {elseif $order.order_status == 'overdue' || ($order.order_status != 'completed' && $order.order_deadline < $smarty.now|date_format:"%Y-%m-%d" && empty($order.order_date_completed))}
                                            <span class="badge bg-danger">Прострочено</span>
                                        {else}
                                            <span class="badge bg-warning">Активний</span>
                                        {/if}
                                    </td>
                                    <td>
                                        {if $order.order_priority == 'high'}
                                            <span class="badge bg-danger">Високий</span>
                                        {elseif $order.order_priority == 'medium'}
                                            <span class="badge bg-warning">Середній</span>
                                        {else}
                                            <span class="badge bg-info">Низький</span>
                                        {/if}
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
            <p>На жаль, за вашим запитом не знайдено наказів. Спробуйте змінити пошуковий запит.</p>
        </div>
    {/if}
{/block}
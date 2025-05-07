{extends file="layout.tpl"}

{block name="content"}
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Редагування наказу</h1>
        <div>
            <a href="/orders/{$order.order_id}" class="btn btn-outline-secondary">Скасувати</a>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <form action="/orders/{$order.order_id}" method="POST">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="order_name" class="form-label">Назва наказу <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="order_name" name="order_name"
                            value="{$order.order_name}" required>
                    </div>
                    <div class="col-md-6">
                        <label for="order_priority" class="form-label">Пріоритет <span class="text-danger">*</span></label>
                        <select class="form-select" id="order_priority" name="order_priority" required>
                            <option value="low" {if $order.order_priority == 'low'}selected{/if}>Низький</option>
                            <option value="medium" {if $order.order_priority == 'medium'}selected{/if}>Середній</option>
                            <option value="high" {if $order.order_priority == 'high'}selected{/if}>Високий</option>
                        </select>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="executor_id" class="form-label">Виконавець <span class="text-danger">*</span></label>
                        <select class="form-select" id="executor_id" name="executor_id" required>
                            <option value="">Виберіть виконавця</option>
                            {foreach $executors as $executor}
                                <option value="{$executor.executor_id}"
                                    {if $executor.executor_id == $order.executor_id}selected{/if}>
                                    {$executor.executor_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label for="issuer_id" class="form-label">Видавець наказу <span class="text-danger">*</span></label>
                        <select class="form-select" id="issuer_id" name="issuer_id" required>
                            <option value="">Виберіть видавця</option>
                            {foreach $issuers as $issuer}
                                <option value="{$issuer.issuer_id}" {if $issuer.issuer_id == $order.issuer_id}selected{/if}>
                                    {$issuer.issuer_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label for="order_date_issued" class="form-label">Дата видачі <span
                                class="text-danger">*</span></label>
                        <input type="date" class="form-control" id="order_date_issued" name="order_date_issued"
                            value="{$order.order_date_issued}" required>
                    </div>
                    <div class="col-md-4">
                        <label for="order_deadline" class="form-label">Дедлайн <span class="text-danger">*</span></label>
                        <input type="date" class="form-control" id="order_deadline" name="order_deadline"
                            value="{$order.order_deadline}" required>
                    </div>
                    <div class="col-md-4">
                        <label for="order_status" class="form-label">Статус <span class="text-danger">*</span></label>
                        <select class="form-select" id="order_status" name="order_status" required>
                            <option value="active"
                                {if $order.order_status == 'active' || $order.order_status == ''}selected{/if}>Активний
                            </option>
                            <option value="completed" {if $order.order_status == 'completed'}selected{/if}>Виконано</option>
                        </select>
                    </div>
                </div>

                {if $order.order_status == 'completed' && $order.order_date_completed}
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="order_date_completed" class="form-label">Дата виконання</label>
                            <input type="date" class="form-control" id="order_date_completed" name="order_date_completed"
                                value="{$order.order_date_completed}">
                        </div>
                    </div>
                {/if}

                <div class="mb-3">
                    <label for="order_content" class="form-label">Зміст наказу <span class="text-danger">*</span></label>
                    <textarea class="form-control" id="order_content" name="order_content" rows="6"
                        required>{$order.order_content}</textarea>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">Зберегти зміни</button>
                </div>
            </form>
        </div>
    </div>
{/block}
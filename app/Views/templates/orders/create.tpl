{extends file="layout.tpl"}

{block name="content"}
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Створення нового наказу</h1>
        <a href="/orders" class="btn btn-outline-secondary">Скасувати</a>
    </div>

    <div class="card">
        <div class="card-body">
            <form action="/orders" method="POST">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="order_name" class="form-label">Назва наказу <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="order_name" name="order_name" required>
                    </div>
                    <div class="col-md-6">
                        <label for="order_priority" class="form-label">Пріоритет <span class="text-danger">*</span></label>
                        <select class="form-select" id="order_priority" name="order_priority" required>
                            <option value="low">Низький</option>
                            <option value="medium" selected>Середній</option>
                            <option value="high">Високий</option>
                        </select>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="executor_id" class="form-label">Виконавець <span class="text-danger">*</span></label>
                        <select class="form-select" id="executor_id" name="executor_id" required>
                            <option value="">Виберіть виконавця</option>
                            {foreach $executors as $executor}
                                <option value="{$executor.executor_id}">{$executor.executor_name}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label for="issuer_id" class="form-label">Видавець наказу <span class="text-danger">*</span></label>
                        <select class="form-select" id="issuer_id" name="issuer_id" required>
                            <option value="">Виберіть видавця</option>
                            {foreach $issuers as $issuer}
                                <option value="{$issuer.issuer_id}">{$issuer.issuer_name}</option>
                            {/foreach}
                        </select>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="order_date_issued" class="form-label">Дата видачі <span class="text-danger">*</span></label>
                        <input type="date" class="form-control" id="order_date_issued" name="order_date_issued" value="{$smarty.now|date_format:"%Y-%m-%d"}" required>
                    </div>
                    <div class="col-md-6">
                        <label for="order_deadline" class="form-label">Дедлайн <span class="text-danger">*</span></label>
                        <input type="date" class="form-control" id="order_deadline" name="order_deadline" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="order_content" class="form-label">Зміст наказу <span class="text-danger">*</span></label>
                    <textarea class="form-control" id="order_content" name="order_content" rows="6" required></textarea>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">Створити наказ</button>
                </div>
            </form>
        </div>
    </div>
{/block}
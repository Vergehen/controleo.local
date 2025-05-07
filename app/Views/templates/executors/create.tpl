{extends file="../layout.tpl"}

{block name="content"}
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Створення нового виконавця</h1>
        <a href="/executors" class="btn btn-outline-secondary">Скасувати</a>
    </div>

    <div class="card">
        <div class="card-body">
            <form action="/executors" method="POST" class="needs-validation" novalidate>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="executor_name" class="form-label">ПІБ виконавця <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="executor_name" name="executor_name" required>
                        <div class="invalid-feedback">
                            Будь ласка, введіть ПІБ виконавця
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label for="executor_contact" class="form-label">Контактні дані</label>
                        <input type="text" class="form-control" id="executor_contact" name="executor_contact">
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="department_id" class="form-label">Відділ</label>
                        <select class="form-select" id="department_id" name="department_id">
                            <option value="">Виберіть відділ</option>
                            {foreach $departments as $department}
                                <option value="{$department.department_id}">{$department.department_name}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label for="position_id" class="form-label">Посада</label>
                        <select class="form-select" id="position_id" name="position_id">
                            <option value="">Виберіть посаду</option>
                            {foreach $positions as $position}
                                <option value="{$position.position_id}">{$position.position_name}</option>
                            {/foreach}
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="executor_notes" class="form-label">Додаткова інформація</label>
                    <textarea class="form-control" id="executor_notes" name="executor_notes" rows="3"></textarea>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">Створити виконавця</button>
                </div>
            </form>
        </div>
    </div>
{/block}

{block name="scripts"}
<script>
$(document).ready(function() {
    $('.needs-validation').submit(function(event) {
        if (!this.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
        }
        $(this).addClass('was-validated');
    });
});
</script>
{/block}
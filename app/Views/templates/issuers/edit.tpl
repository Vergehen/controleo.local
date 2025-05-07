{extends file="../layout.tpl"}

{block name="content"}
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Редагування видавця</h1>
        <a href="/issuers/{$issuer.issuer_id}" class="btn btn-outline-secondary">Скасувати</a>
    </div>

    <div class="card">
        <div class="card-body">
            <form action="/issuers/{$issuer.issuer_id}" method="POST" class="needs-validation" novalidate>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="issuer_name" class="form-label">ПІБ видавця <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="issuer_name" name="issuer_name" value="{$issuer.issuer_name}" required>
                        <div class="invalid-feedback">
                            Будь ласка, введіть ПІБ видавця
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label for="issuer_contact" class="form-label">Контактні дані</label>
                        <input type="text" class="form-control" id="issuer_contact" name="issuer_contact" value="{$issuer.issuer_contact}">
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="department_id" class="form-label">Відділ</label>
                        <select class="form-select" id="department_id" name="department_id">
                            <option value="">Виберіть відділ</option>
                            {foreach $departments as $department}
                                <option value="{$department.department_id}" {if $issuer.department_id == $department.department_id}selected{/if}>{$department.department_name}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label for="position_id" class="form-label">Посада</label>
                        <select class="form-select" id="position_id" name="position_id">
                            <option value="">Виберіть посаду</option>
                            {foreach $positions as $position}
                                <option value="{$position.position_id}" {if $issuer.position_id == $position.position_id}selected{/if}>{$position.position_name}</option>
                            {/foreach}
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="issuer_notes" class="form-label">Додаткова інформація</label>
                    <textarea class="form-control" id="issuer_notes" name="issuer_notes" rows="3">{$issuer.issuer_notes}</textarea>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">Зберегти зміни</button>
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
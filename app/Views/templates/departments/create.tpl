{extends file="../layout.tpl"}

{block name="content"}
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Створення нового відділу</h1>
        <a href="/departments" class="btn btn-outline-secondary">Скасувати</a>
    </div>

    <div class="card">
        <div class="card-body">
            <form action="/departments" method="POST" class="needs-validation" novalidate>
                <div class="mb-3">
                    <label for="department_name" class="form-label">Назва відділу <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="department_name" name="department_name" required>
                    <div class="invalid-feedback">
                        Будь ласка, введіть назву відділу
                    </div>
                </div>

                <div class="mb-3">
                    <label for="department_description" class="form-label">Опис відділу</label>
                    <textarea class="form-control" id="department_description" name="department_description"
                        rows="3"></textarea>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">Створити відділ</button>
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
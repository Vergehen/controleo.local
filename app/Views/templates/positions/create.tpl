{extends file="layout.tpl"}

{block name="content"}
    <div class="container">
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="/positions">Посади</a></li>
                <li class="breadcrumb-item active" aria-current="page">Створення посади</li>
            </ol>
        </nav>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Створення нової посади</h5>
                    </div>
                    <div class="card-body">
                        <form action="/positions" method="POST">
                            <div class="mb-3">
                                <label for="position_name" class="form-label">Назва посади *</label>
                                <input type="text" class="form-control" id="position_name" name="position_name" required>
                                <div class="form-text">Введіть назву посади</div>
                            </div>
                            <div class="d-flex justify-content-between">
                                <a href="/positions" class="btn btn-secondary">Скасувати</a>
                                <button type="submit" class="btn btn-primary">Створити</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
{/block}
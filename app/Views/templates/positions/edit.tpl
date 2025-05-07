{extends file="layout.tpl"}

{block name="content"}
    <div class="container">
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="/positions">Посади</a></li>
                <li class="breadcrumb-item"><a href="/positions/{$position.position_id}">{$position.position_name}</a></li>
                <li class="breadcrumb-item active" aria-current="page">Редагування</li>
            </ol>
        </nav>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-warning">
                        <h5 class="mb-0">Редагування посади</h5>
                    </div>
                    <div class="card-body">
                        <form action="/positions/{$position.position_id}" method="POST">
                            <div class="mb-3">
                                <label for="position_name" class="form-label">Назва посади *</label>
                                <input type="text" class="form-control" id="position_name" name="position_name" value="{$position.position_name}" required>
                            </div>
                            <div class="d-flex justify-content-between">
                                <a href="/positions/{$position.position_id}" class="btn btn-secondary">Скасувати</a>
                                <button type="submit" class="btn btn-warning">Зберегти зміни</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
{/block}
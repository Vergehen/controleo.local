{extends file="layout.tpl"}

{block name="content"}
    <div class="container">
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="/positions">Посади</a></li>
                <li class="breadcrumb-item active" aria-current="page">{$position.position_name}</li>
            </ol>
        </nav>

        <div class="row">
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Інформація про посаду</h5>
                    </div>
                    <div class="card-body">
                        <h3 class="card-title">{$position.position_name}</h3>
                    </div>
                </div>

                {if $executors|@count > 0}
                <div class="card mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Виконавці з цією посадою</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ПІБ</th>
                                        <th>Відділ</th>
                                        <th>Контакти</th>
                                        <th>Дії</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach $executors as $executor}
                                    <tr>
                                        <td><a href="/executors/{$executor.executor_id}">{$executor.executor_name}</a></td>
                                        <td>{$executor.department_name}</td>
                                        <td>{$executor.executor_contact}</td>
                                        <td>
                                            <a href="/executors/{$executor.executor_id}" class="btn btn-sm btn-info">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                {/if}

                {if $issuers|@count > 0}
                <div class="card mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Видавці наказів з цією посадою</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ПІБ</th>
                                        <th>Відділ</th>
                                        <th>Контакти</th>
                                        <th>Дії</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach $issuers as $issuer}
                                    <tr>
                                        <td><a href="/issuers/{$issuer.issuer_id}">{$issuer.issuer_name}</a></td>
                                        <td>{$issuer.department_name}</td>
                                        <td>{$issuer.issuer_contact}</td>
                                        <td>
                                            <a href="/issuers/{$issuer.issuer_id}" class="btn btn-sm btn-info">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                {/if}
            </div>
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header bg-secondary text-white">
                        <h5 class="mb-0">Дії</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="/positions/{$position.position_id}/edit" class="btn btn-warning">
                                <i class="bi bi-pencil me-2"></i>Редагувати
                            </a>
                            <form action="/positions/{$position.position_id}/delete" method="POST" class="delete-form">
                                <button type="submit" class="btn btn-danger w-100">
                                    <i class="bi bi-trash me-2"></i>Видалити
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="bi bi-graph-up me-2"></i>Статистика</h5>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-6">
                                <div class="p-3 border bg-light rounded text-center">
                                    <h5 class="mb-0">{$position.executors_count}</h5>
                                    <small class="text-muted">Виконавців</small>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-3 border bg-light rounded text-center">
                                    <h5 class="mb-0">{$position.issuers_count}</h5>
                                    <small class="text-muted">Видавців</small>
                                </div>
                            </div>
                            <div class="col-12 mt-3">
                                <div class="p-3 border bg-light rounded text-center">
                                    <h5 class="mb-0">{$position.executors_count + $position.issuers_count}</h5>
                                    <small class="text-muted">Всього співробітників</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
{/block}

{block name="scripts"}
<script>
$(document).ready(function() {
    $('.delete-form').on('submit', function(e) {
        e.preventDefault();
        
        if (confirm('Ви впевнені, що хочете видалити цю посаду? Ця дія незворотна!')) {
            $(this).off('submit').submit();
        }
    });
});
</script>
{/block}
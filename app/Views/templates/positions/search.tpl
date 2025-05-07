{extends file="layout.tpl"}

{block name="content"}
    <div class="container">
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="/positions">Посади</a></li>
                <li class="breadcrumb-item active" aria-current="page">Результати пошуку</li>
            </ol>
        </nav>

        <div class="card mb-4">
            <div class="card-header bg-light">
                <h5 class="mb-0">Результати пошуку за запитом: "{$query}"</h5>
            </div>
            <div class="card-body">
                {if $positions|@count > 0}
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Назва посади</th>
                                    <th>Дії</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $positions as $position}
                                    <tr>
                                        <td>{$position.position_id}</td>
                                        <td>
                                            <a href="/positions/{$position.position_id}">{$position.position_name}</a>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="/positions/{$position.position_id}" class="btn btn-sm btn-info">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <a href="/positions/{$position.position_id}/edit" class="btn btn-sm btn-warning">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <form action="/positions/{$position.position_id}/delete" method="POST"
                                                    class="d-inline delete-form">
                                                    <button type="submit" class="btn btn-sm btn-danger">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                {else}
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle me-2"></i> За запитом "{$query}" нічого не знайдено
                    </div>
                {/if}

                <div class="mt-3">
                    <a href="/positions" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Повернутись до списку посад
                    </a>
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
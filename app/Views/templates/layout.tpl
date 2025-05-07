<!DOCTYPE html>
<html lang="uk">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{$title|default:'Система контролю за виконанням наказів'}</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <!-- Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- CSS -->
    <link rel="stylesheet" href="/css/style.css">
</head>

<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
        <div class="container">
            <a class="navbar-brand" href="/">ControlEO</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/">Головна</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/orders">Накази</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/executors">Виконавці</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/issuers">Видавці</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/departments">Відділи</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/positions">Посади</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/reports">
                            <i class="bi bi-file-earmark-pdf me-1"></i>Звіти
                        </a>
                    </li>
                </ul>
                <form class="d-flex" action="/search" method="GET">
                    <input class="form-control me-2" type="search" name="query" placeholder="Пошук по системі"
                        aria-label="Search">
                    <button class="btn btn-light" type="submit">Пошук</button>
                </form>
            </div>
        </div>
    </nav>

    <div class="container mb-4">
        {if isset($error)}
            <div class="alert alert-danger" role="alert">
                {$error}
            </div>
        {/if}

        {if isset($success)}
            <div class="alert alert-success" role="alert">
                {$success}
            </div>
        {/if}

        {block name="content"}{/block}
    </div>

    <footer class="bg-light py-4 mt-auto">
        <div class="container text-center">
            <p>Система контролю за виконанням наказів &copy; {$smarty.now|date_format:"%Y"}</p>
        </div>
    </footer>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom -->
    <script src="/js/main.js"></script>
    
    {block name="scripts"}{/block}
</body>

</html>
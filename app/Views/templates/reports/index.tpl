{extends file="../layout.tpl"}

{block name="content"}
    <div class="container">
        <h1 class="mb-4">Генерація звітів</h1>
        
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Доступні звіти</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-4">
                                <div class="card h-100">
                                    <div class="card-header bg-warning text-white">
                                        <h5 class="card-title mb-0 d-flex justify-content-between">
                                            <span>Активні накази</span>
                                            <span class="badge bg-light text-dark">{$activeOrdersCount}</span>
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <p class="card-text">
                                            Звіт містить інформацію про всі активні накази в системі, які ще не виконані.
                                        </p>
                                    </div>
                                    <div class="card-footer">
                                        <div class="d-flex justify-content-between">
                                            <a href="/reports/active-orders" class="btn btn-outline-primary">
                                                <i class="bi bi-eye"></i> Переглянути
                                            </a>
                                            <div class="btn-group">
                                                <a href="/reports/export/pdf/active-orders" class="btn btn-danger">
                                                    <i class="bi bi-file-pdf"></i> PDF
                                                </a>
                                                <a href="/reports/export/word/active-orders" class="btn btn-primary">
                                                    <i class="bi bi-file-word"></i> Word
                                                </a>
                                                <a href="/reports/export/excel/active-orders" class="btn btn-success">
                                                    <i class="bi bi-file-excel"></i> Excel
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6 mb-4">
                                <div class="card h-100">
                                    <div class="card-header bg-danger text-white">
                                        <h5 class="card-title mb-0 d-flex justify-content-between">
                                            <span>Прострочені накази</span>
                                            <span class="badge bg-light text-dark">{$overdueOrdersCount}</span>
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <p class="card-text">
                                            Звіт містить інформацію про всі прострочені накази, термін виконання яких минув.
                                        </p>
                                    </div>
                                    <div class="card-footer">
                                        <div class="d-flex justify-content-between">
                                            <a href="/reports/overdue-orders" class="btn btn-outline-primary">
                                                <i class="bi bi-eye"></i> Переглянути
                                            </a>
                                            <div class="btn-group">
                                                <a href="/reports/export/pdf/overdue-orders" class="btn btn-danger">
                                                    <i class="bi bi-file-pdf"></i> PDF
                                                </a>
                                                <a href="/reports/export/word/overdue-orders" class="btn btn-primary">
                                                    <i class="bi bi-file-word"></i> Word
                                                </a>
                                                <a href="/reports/export/excel/overdue-orders" class="btn btn-success">
                                                    <i class="bi bi-file-excel"></i> Excel
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <hr>
                        <h4 class="mb-3">Звіти по відділах</h4>
                        
                        <div class="row">
                            {foreach $departments as $dept}
                                <div class="col-md-4 mb-3">
                                    <div class="card h-100">
                                        <div class="card-body">
                                            <h5 class="card-title">{$dept.department_name}</h5>
                                            <p class="card-text small">
                                                Виконавців: {$dept.executor_count} | 
                                                Видавців: {$dept.issuer_count} |
                                                Наказів: {$dept.order_count}
                                            </p>
                                        </div>
                                        <div class="card-footer">
                                            <div class="d-flex justify-content-between">
                                                <a href="/reports/department/{$dept.department_id}" class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-eye"></i> Переглянути
                                                </a>
                                                <div class="btn-group">
                                                    <a href="/reports/export/pdf/department/{$dept.department_id}" class="btn btn-sm btn-danger">
                                                        <i class="bi bi-file-pdf"></i> PDF
                                                    </a>
                                                    <a href="/reports/export/word/department/{$dept.department_id}" class="btn btn-sm btn-primary">
                                                        <i class="bi bi-file-word"></i> Word
                                                    </a>
                                                    <a href="/reports/export/excel/department/{$dept.department_id}" class="btn btn-sm btn-success">
                                                        <i class="bi bi-file-excel"></i> Excel
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            {/foreach}
                        </div>
                        
                        <hr>
                        <h4 class="mb-3">Звіти по виконавцях</h4>
                        
                        <div class="row">
                            <div class="col-md-12">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>ПІБ</th>
                                                <th>Відділ</th>
                                                <th>Посада</th>
                                                <th>Дії</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {foreach $executors as $exec}
                                                <tr>
                                                    <td>{$exec.executor_name}</td>
                                                    <td>{$exec.department_name|default:'Не вказано'}</td>
                                                    <td>{$exec.position_name|default:'Не вказано'}</td>
                                                    <td>
                                                        <div class="btn-group">
                                                            <a href="/reports/executor/{$exec.executor_id}" class="btn btn-sm btn-outline-primary">
                                                                <i class="bi bi-eye"></i> Звіт
                                                            </a>
                                                            <a href="/reports/export/pdf/executor/{$exec.executor_id}" class="btn btn-sm btn-danger">
                                                                <i class="bi bi-file-pdf"></i> PDF
                                                            </a>
                                                            <a href="/reports/export/word/executor/{$exec.executor_id}" class="btn btn-sm btn-primary">
                                                                <i class="bi bi-file-word"></i> Word
                                                            </a>
                                                            <a href="/reports/export/excel/executor/{$exec.executor_id}" class="btn btn-sm btn-success">
                                                                <i class="bi bi-file-excel"></i> Excel
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            {/foreach}
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
{/block}

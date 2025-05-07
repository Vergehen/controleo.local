<?php

use App\Controllers\DepartmentController;
use App\Controllers\ExecutorController;
use App\Controllers\HomeController;
use App\Controllers\IssuerController;
use App\Controllers\OrderController;
use App\Controllers\PositionController;
use App\Controllers\ReportController;
use App\Routes\Router;

$router = new Router();

// Головна сторінка
$router->addRoute('GET', '/', HomeController::class, 'index');
$router->addRoute('GET', '/search', HomeController::class, 'search');

// Відділи (Departments)
$router->addRoute('GET', '/departments', DepartmentController::class, 'index');
$router->addRoute('GET', '/departments/create', DepartmentController::class, 'create');
$router->addRoute('POST', '/departments', DepartmentController::class, 'store');
$router->addRoute('GET', '/departments/{id}', DepartmentController::class, 'show');
$router->addRoute('GET', '/departments/{id}/edit', DepartmentController::class, 'edit');
$router->addRoute('POST', '/departments/{id}', DepartmentController::class, 'update');
$router->addRoute('POST', '/departments/{id}/delete', DepartmentController::class, 'delete');
$router->addRoute('GET', '/departments/search', DepartmentController::class, 'search');

// Виконавці (Executors)
$router->addRoute('GET', '/executors', ExecutorController::class, 'index');
$router->addRoute('GET', '/executors/create', ExecutorController::class, 'create');
$router->addRoute('POST', '/executors', ExecutorController::class, 'store');
$router->addRoute('GET', '/executors/{id}', ExecutorController::class, 'show');
$router->addRoute('GET', '/executors/{id}/edit', ExecutorController::class, 'edit');
$router->addRoute('POST', '/executors/{id}', ExecutorController::class, 'update');
$router->addRoute('POST', '/executors/{id}/delete', ExecutorController::class, 'delete');
$router->addRoute('GET', '/executors/search', ExecutorController::class, 'search');

// Видавці наказів (Issuers)
$router->addRoute('GET', '/issuers', IssuerController::class, 'index');
$router->addRoute('GET', '/issuers/create', IssuerController::class, 'create');
$router->addRoute('POST', '/issuers', IssuerController::class, 'store');
$router->addRoute('GET', '/issuers/{id}', IssuerController::class, 'show');
$router->addRoute('GET', '/issuers/{id}/edit', IssuerController::class, 'edit');
$router->addRoute('POST', '/issuers/{id}', IssuerController::class, 'update');
$router->addRoute('POST', '/issuers/{id}/delete', IssuerController::class, 'delete');
$router->addRoute('GET', '/issuers/search', IssuerController::class, 'search');

// Посади (Positions)
$router->addRoute('GET', '/positions', PositionController::class, 'index');
$router->addRoute('GET', '/positions/create', PositionController::class, 'create');
$router->addRoute('POST', '/positions', PositionController::class, 'store');
$router->addRoute('GET', '/positions/{id}', PositionController::class, 'show');
$router->addRoute('GET', '/positions/{id}/edit', PositionController::class, 'edit');
$router->addRoute('POST', '/positions/{id}', PositionController::class, 'update');
$router->addRoute('POST', '/positions/{id}/delete', PositionController::class, 'delete');
$router->addRoute('GET', '/positions/search', PositionController::class, 'search');

// Накази (Orders)
$router->addRoute('GET', '/orders', OrderController::class, 'index');
$router->addRoute('GET', '/orders/create', OrderController::class, 'create');
$router->addRoute('POST', '/orders', OrderController::class, 'store');
$router->addRoute('GET', '/orders/{id}', OrderController::class, 'show');
$router->addRoute('GET', '/orders/{id}/edit', OrderController::class, 'edit');
$router->addRoute('POST', '/orders/{id}', OrderController::class, 'update');
$router->addRoute('POST', '/orders/{id}/delete', OrderController::class, 'delete');
$router->addRoute('GET', '/orders/search', OrderController::class, 'search');
$router->addRoute('GET', '/orders/active', OrderController::class, 'active');
$router->addRoute('GET', '/orders/overdue', OrderController::class, 'overdue');

// Звіти (Reports)
$router->addRoute('GET', '/reports', ReportController::class, 'index');
$router->addRoute('GET', '/reports/active-orders', ReportController::class, 'activeOrders');
$router->addRoute('GET', '/reports/overdue-orders', ReportController::class, 'overdueOrders');
$router->addRoute('GET', '/reports/department/{id}', ReportController::class, 'departmentReport');
$router->addRoute('GET', '/reports/executor/{id}', ReportController::class, 'executorReport');

// Експорт (Export)
$router->addRoute('GET', '/reports/export/{format}/{type}', ReportController::class, 'exportReport');
$router->addRoute('GET', '/reports/export/{format}/{type}/{id}', ReportController::class, 'exportReport');

// Обробляємо маршрути
$router->dispatch();
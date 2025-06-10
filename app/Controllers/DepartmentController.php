<?php

namespace App\Controllers;

use App\Models\Department;
use App\Models\Executor;
use App\Models\Issuer;
use App\Models\Order;
use App\Services\AnalyticsService;

class DepartmentController extends Controller
{
    private $department;
    private $executor;
    private $issuer;
    private $order;
    private $analytics;

    public function __construct()
    {
        parent::__construct();
        $this->department = new Department();
        $this->executor = new Executor();
        $this->issuer = new Issuer();
        $this->order = new Order();
        $this->analytics = new AnalyticsService();
    }    public function index()
    {
        $departments = Department::getAllWithStats();
        
        // Отримуємо аналітичні дані по відділах
        $generalStats = $this->analytics->getGeneralStatistics();
        $monthlyTrends = $this->analytics->getMonthlyTrends();
        $priorityDistribution = $this->analytics->getPriorityDistribution();
        $statusDistribution = $this->analytics->getStatusDistribution();
        
        return $this->render('departments/index', [
            'departments' => $departments,
            'generalStats' => $generalStats,
            'monthlyTrends' => $monthlyTrends,
            'priorityDistribution' => $priorityDistribution,
            'statusDistribution' => $statusDistribution,
            'title' => 'Відділи'
        ]);
    }

    public function show($id)
    {
        $department = $this->department->find($id);

        if (!$department) {
            return $this->redirect('/departments');
        }        $executors = $this->executor->getByDepartment($id) ?: [];
        $issuers = $this->issuer->getByDepartment($id) ?: [];
        
        // Автоматично оновлюємо статуси прострочених наказів
        Order::updateOverdueStatuses();
        
        $departmentOrders = $this->order->getByDepartment($id) ?: [];
        $activeOrders = [];
        $completedOrders = [];
        $overdueOrders = [];
        
        foreach ($departmentOrders as $order) {
            if ($order['order_status'] === 'completed') {
                $completedOrders[] = $order;
            } elseif ($order['order_status'] === 'overdue') {
                $overdueOrders[] = $order;
            } elseif ($order['order_status'] === 'active') {
                $activeOrders[] = $order;
            }
        }        if (!isset($department['department_description'])) {
            $department['department_description'] = '';
        }

        // Отримуємо аналітичні дані для конкретного відділу
        $departmentStats = $this->analytics->getDepartmentStatistics($id);

        return $this->render('departments/show', [
            'department' => $department,
            'executors' => $executors,
            'issuers' => $issuers,
            'departmentOrders' => $departmentOrders,
            'activeOrders' => $activeOrders,
            'completedOrders' => $completedOrders,
            'overdueOrders' => $overdueOrders,
            'departmentStats' => $departmentStats,
            'title' => 'Відділ: ' . $department['department_name']
        ]);
    }

    public function create()
    {
        return $this->render('departments/create', [
            'title' => 'Створення відділу'
        ]);
    }

    public function store()
    {
        $departmentName = $_POST['department_name'] ?? '';

        if (empty($departmentName)) {
            return $this->render('departments/create', [
                'error' => 'Назва відділу обов\'язкова',
                'title' => 'Створення відділу'
            ]);
        }

        $this->department->create([
            'department_name' => $departmentName
        ]);

        return $this->redirect('/departments');
    }

    public function edit($id)
    {
        $department = $this->department->find($id);

        if (!$department) {
            return $this->redirect('/departments');
        }

        if (!isset($department['department_description'])) {
            $department['department_description'] = '';
        }

        return $this->render('departments/edit', [
            'department' => $department,
            'title' => 'Редагування відділу'
        ]);
    }

    public function update($id)
    {
        $departmentName = $_POST['department_name'] ?? '';

        if (empty($departmentName)) {
            return $this->render('departments/edit', [
                'department' => $this->department->find($id),
                'error' => 'Назва відділу обов\'язкова',
                'title' => 'Редагування відділу'
            ]);
        }

        $this->department->update($id, [
            'department_name' => $departmentName
        ]);

        return $this->redirect('/departments');
    }

    public function delete($id)
    {
        $this->department->delete($id);
        return $this->redirect('/departments');
    }

    public function search()
    {
        $query = $_GET['query'] ?? '';

        if (empty($query)) {
            return $this->redirect('/departments');
        }

        $results = $this->department->search('department_name', $query);

        return $this->render('departments/search', [
            'departments' => $results,
            'query' => $query,
            'title' => 'Результати пошуку'
        ]);
    }
}
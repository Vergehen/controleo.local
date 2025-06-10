<?php

namespace App\Controllers;

use App\Models\Department;
use App\Models\Order;
use App\Services\AnalyticsService;

class HomeController extends Controller
{
    private $department;
    private $order;
    private $analytics;

    public function __construct()
    {
        parent::__construct();

        $this->department = new Department();
        $this->order = new Order();
        $this->analytics = new AnalyticsService();
    }    public function index()
    {
        // Автоматично оновлюємо статуси прострочених наказів
        Order::updateOverdueStatuses();
        
        $activeOrders = Order::getActiveOrders();
        $overdueOrders = Order::getOverdueOrders();
        $departments = $this->department->all();

        // Отримуємо аналітичні дані для дашборду
        $analytics = $this->analytics->getGeneralStatistics();
        $priorityDistribution = $this->analytics->getPriorityDistribution();
        $statusDistribution = $this->analytics->getStatusDistribution();
        $monthlyTrends = $this->analytics->getMonthlyTrends();
        $topExecutors = $this->analytics->getTopExecutors(5);
        $topIssuers = $this->analytics->getTopIssuers(5);

        return $this->render('home/index', [
            'activeOrders' => $activeOrders,
            'overdueOrders' => $overdueOrders,
            'departments' => $departments,
            'analytics' => $analytics,
            'priorityDistribution' => $priorityDistribution,
            'statusDistribution' => $statusDistribution,
            'monthlyTrends' => $monthlyTrends,
            'topExecutors' => $topExecutors,
            'topIssuers' => $topIssuers,
            'title' => 'Головна сторінка - Система контролю за виконанням наказів'
        ]);
    }

    public function search()
    {
        $query = $_GET['query'] ?? '';

        if (empty($query)) {
            return $this->redirect('/');
        }

        $ordersResults = Order::searchByMultipleFields($query);

        return $this->render('home/search', [
            'query' => $query,
            'orders' => $ordersResults,
            'title' => "Результати пошуку: {$query} - Система контролю"
        ]);
    }
}
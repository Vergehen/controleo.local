<?php

namespace App\Controllers;

use App\Models\Executor;
use App\Models\Issuer;
use App\Models\Order;
use App\Services\AnalyticsService;

class OrderController extends Controller
{    private $order;
    private $executor;
    private $issuer;
    private $analytics;

    public function __construct()
    {
        parent::__construct();
        $this->order = new Order();
        $this->executor = new Executor();
        $this->issuer = new Issuer();
        $this->analytics = new AnalyticsService();
    }public function index()
    {
        // Автоматично оновлюємо статуси прострочених наказів
        Order::updateOverdueStatuses();
        
        $sort = $_GET['sort'] ?? 'order_id';
        $order = $_GET['order'] ?? 'ASC';

        $executorId = $_GET['executor_id'] ?? null;
        $issuerId = $_GET['issuer_id'] ?? null;
        $departmentId = $_GET['department_id'] ?? null;

        if ($executorId) {
            $orders = $this->order->getByExecutor($executorId, $sort, $order);
        } elseif ($issuerId) {
            $orders = $this->order->getByIssuer($issuerId, $sort, $order);
        } elseif ($departmentId) {
            $orders = $this->order->getByDepartment($departmentId, $sort, $order);
        } else {
            $orders = Order::getAllWithNames($sort, $order);
        }
        $activeOrders = [];
        $overdueOrders = [];
        $completedOrders = [];
        $currentTime = time();        foreach ($orders as $order_item) {
            // Розподіляємо накази по статусах
            if ($order_item['order_status'] === 'completed') {
                $completedOrders[] = $order_item;
            } elseif ($order_item['order_status'] === 'overdue') {
                $overdueOrders[] = $order_item;
            } elseif ($order_item['order_status'] === 'active') {
                // Активними залишаються тільки ті, що мають статус 'active' і дедлайн ще не минув
                $activeOrders[] = $order_item;            }
            // Інші статуси ('cancelled', 'failed') не додаємо в жодну категорію для статистики
        }

        // Отримуємо аналітичні дані
        $analytics = $this->analytics->getGeneralStatistics();
        $priorityDistribution = $this->analytics->getPriorityDistribution();
        $statusDistribution = $this->analytics->getStatusDistribution();
        $monthlyTrends = $this->analytics->getMonthlyTrends();

        return $this->render('orders/index', [
            'orders' => $orders,
            'activeOrders' => $activeOrders,
            'overdueOrders' => $overdueOrders,
            'completedOrders' => $completedOrders,
            'analytics' => $analytics,
            'priorityDistribution' => $priorityDistribution,
            'statusDistribution' => $statusDistribution,
            'monthlyTrends' => $monthlyTrends,
            'title' => 'Накази',
            'currentSort' => $sort,
            'currentOrder' => $order,
            'executorId' => $executorId,
            'issuerId' => $issuerId,
            'departmentId' => $departmentId
        ]);
    }

    public function show($id)
    {
        $order = $this->order->find($id);

        if (!$order) {
            return $this->redirect('/orders');
        }

        $orderModel = new Order();
        $orderDetails = $orderModel->getOrderDetails($id);

        return $this->render('orders/show', [
            'order' => $orderDetails,
            'title' => "Наказ: {$order['order_name']}"
        ]);
    }

    public function create()
    {
        $executors = $this->executor->all();
        $issuers = $this->issuer->all();

        return $this->render('orders/create', [
            'executors' => $executors,
            'issuers' => $issuers,
            'title' => 'Створення наказу'
        ]);
    }

    public function store()
    {
        $orderName = $_POST['order_name'] ?? '';
        $orderContent = $_POST['order_content'] ?? '';
        $orderDateIssued = $_POST['order_date_issued'] ?? date('Y-m-d');
        $orderDeadline = $_POST['order_deadline'] ?? '';
        $executorId = $_POST['executor_id'] ?? '';
        $issuerId = $_POST['issuer_id'] ?? '';
        $orderPriority = $_POST['order_priority'] ?? 'medium';

        if (empty($orderName) || empty($orderDeadline) || empty($executorId) || empty($issuerId)) {
            $executors = $this->executor->all();
            $issuers = $this->issuer->all();

            return $this->render('orders/create', [
                'executors' => $executors,
                'issuers' => $issuers,
                'error' => 'Всі поля є обов\'язковими',
                'title' => 'Створення наказу'
            ]);
        }

        $this->order->create([
            'order_name' => $orderName,
            'order_content' => $orderContent,
            'order_date_issued' => $orderDateIssued,
            'order_deadline' => $orderDeadline,
            'executor_id' => $executorId,
            'issuer_id' => $issuerId,
            'order_priority' => $orderPriority
        ]);

        return $this->redirect('/orders');
    }

    public function edit($id)
    {
        $order = $this->order->find($id);

        if (!$order) {
            return $this->redirect('/orders');
        }

        $executors = $this->executor->all();
        $issuers = $this->issuer->all();

        return $this->render('orders/edit', [
            'order' => $order,
            'executors' => $executors,
            'issuers' => $issuers,
            'title' => 'Редагування наказу'
        ]);
    }

    public function update($id)
    {
        $orderName = $_POST['order_name'] ?? '';
        $orderContent = $_POST['order_content'] ?? '';
        $orderDateIssued = $_POST['order_date_issued'] ?? '';
        $orderDeadline = $_POST['order_deadline'] ?? '';
        $executorId = $_POST['executor_id'] ?? '';
        $issuerId = $_POST['issuer_id'] ?? '';
        $orderPriority = $_POST['order_priority'] ?? '';
        $orderStatus = $_POST['order_status'] ?? '';

        if (empty($orderName) || empty($orderDeadline) || empty($executorId) || empty($issuerId)) {
            $order = $this->order->find($id);
            $executors = $this->executor->all();
            $issuers = $this->issuer->all();

            return $this->render('orders/edit', [
                'order' => $order,
                'executors' => $executors,
                'issuers' => $issuers,
                'error' => 'Всі поля є обов\'язковими',
                'title' => 'Редагування наказу'
            ]);
        }

        $updateData = [
            'order_name' => $orderName,
            'order_content' => $orderContent,
            'order_date_issued' => $orderDateIssued,
            'order_deadline' => $orderDeadline,
            'executor_id' => $executorId,
            'issuer_id' => $issuerId,
            'order_priority' => $orderPriority
        ];

        if ($orderStatus == 'completed' && empty($_POST['order_date_completed'])) {
            $updateData['order_date_completed'] = date('Y-m-d');
        } else if ($orderStatus == 'active') {
            $updateData['order_date_completed'] = null;
        }

        $updateData['order_status'] = $orderStatus;
        $this->order->update($id, $updateData);

        return $this->redirect('/orders');
    }

    public function delete($id)
    {
        $this->order->delete($id);
        return $this->redirect('/orders');
    }    public function active()
    {
        // Автоматично оновлюємо статуси перед отриманням активних наказів
        Order::updateOverdueStatuses();
        
        $sort = $_GET['sort'] ?? 'order_id';
        $order = $_GET['order'] ?? 'ASC';

        $activeOrders = Order::getActiveOrders();

        return $this->render('orders/active', [
            'orders' => $activeOrders,
            'title' => 'Активні накази',
            'currentSort' => $sort,
            'currentOrder' => $order
        ]);
    }    public function overdue()
    {
        // Автоматично оновлюємо статуси перед отриманням прострочених наказів
        Order::updateOverdueStatuses();
        
        $sort = $_GET['sort'] ?? 'order_id';
        $order = $_GET['order'] ?? 'ASC';

        $overdueOrders = Order::getOverdueOrders();

        return $this->render('orders/overdue', [
            'orders' => $overdueOrders,
            'title' => 'Прострочені накази',
            'currentSort' => $sort,
            'currentOrder' => $order
        ]);
    }

    public function search()
    {
        $query = $_GET['query'] ?? '';
        $sort = $_GET['sort'] ?? 'order_id';
        $order = $_GET['order'] ?? 'ASC';

        if (empty($query)) {
            return $this->redirect('/orders');
        }

        $results = Order::searchByMultipleFields($query);

        return $this->render('orders/search', [
            'orders' => $results,
            'query' => $query,
            'title' => "Результати пошуку наказів за запитом: {$query}",
            'currentSort' => $sort,
            'currentOrder' => $order
        ]);
    }
}
<?php

namespace App\Controllers;

use App\Models\Department;
use App\Models\Order;

class HomeController extends Controller
{
    private $department;
    private $order;

    public function __construct()
    {
        parent::__construct();

        $this->department = new Department();
        $this->order = new Order();
    }

    public function index()
    {
        $activeOrders = Order::getActiveOrders();
        $overdueOrders = Order::getOverdueOrders();
        $departments = $this->department->all();

        return $this->render('home/index', [
            'activeOrders' => $activeOrders,
            'overdueOrders' => $overdueOrders,
            'departments' => $departments,
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
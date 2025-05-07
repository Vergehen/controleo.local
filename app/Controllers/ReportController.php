<?php

namespace App\Controllers;

use App\Models\Department;
use App\Models\Executor;
use App\Models\Issuer;
use App\Models\Order;
use App\Models\Position;
use App\Services\ExcelExport;
use App\Services\PDFExport;
use App\Services\WordExport;

class ReportController extends Controller
{
    private $order;
    private $executor;
    private $issuer;
    private $department;
    private $position;

    public function __construct()
    {
        parent::__construct();
        $this->order = new Order();
        $this->executor = new Executor();
        $this->issuer = new Issuer();
        $this->department = new Department();
        $this->position = new Position();
    }

    public function index()
    {
        $activeOrdersCount = count(Order::getActiveOrders());
        $overdueOrdersCount = count(Order::getOverdueOrders());
        $departments = Department::getAllWithStats();
        $executors = $this->executor->getAll();

        return $this->render('reports/index', [
            'title' => 'Генерація звітів',
            'activeOrdersCount' => $activeOrdersCount,
            'overdueOrdersCount' => $overdueOrdersCount,
            'departments' => $departments,
            'executors' => $executors
        ]);
    }

    public function activeOrders()
    {
        $activeOrders = Order::getActiveOrders();

        return $this->render('reports/active_orders', [
            'title' => 'Звіт: Активні накази',
            'orders' => $activeOrders,
            'generated_date' => date('Y-m-d H:i:s')
        ]);
    }

    public function overdueOrders()
    {
        $overdueOrders = Order::getOverdueOrders();

        return $this->render('reports/overdue_orders', [
            'title' => 'Звіт: Прострочені накази',
            'orders' => $overdueOrders,
            'generated_date' => date('Y-m-d H:i:s')
        ]);
    }

    public function departmentReport($id)
    {
        $department = $this->department->find($id);
        if (!$department) {
            return $this->redirect('/reports');
        }

        $executors = $this->executor->getByDepartment($id) ?: [];
        $issuers = $this->issuer->getByDepartment($id) ?: [];
        $departmentOrders = $this->order->getByDepartment($id) ?: [];

        return $this->render('reports/department', [
            'title' => "Звіт по відділу: {$department['department_name']}",
            'department' => $department,
            'executors' => $executors,
            'issuers' => $issuers,
            'orders' => $departmentOrders,
            'generated_date' => date('Y-m-d H:i:s')
        ]);
    }

    public function executorReport($id)
    {
        $executor = $this->executor->find($id);
        if (!$executor) {
            return $this->redirect('/reports');
        }

        $department = $this->department->find($executor['department_id']);
        $position = $this->position->find($executor['position_id']);
        $executorOrders = $this->order->getByExecutor($id) ?: [];

        $executor['department_name'] = $department ? $department['department_name'] : 'Не вказано';
        $executor['position_name'] = $position ? $position['position_name'] : 'Не вказано';

        return $this->render('reports/executor', [
            'title' => "Звіт по виконавцю: {$executor['executor_name']}",
            'executor' => $executor,
            'orders' => $executorOrders,
            'generated_date' => date('Y-m-d H:i:s')
        ]);
    }

    public function exportReport($format, $reportType, $id = null)
    {
        switch ($format) {
            case 'pdf':
                $exporter = new PDFExport();
                break;
            case 'excel':
                $exporter = new ExcelExport();
                break;
            case 'word':
                $exporter = new WordExport();
                break;
            default:
                return $this->redirect('/reports');
        }

        switch ($reportType) {
            case 'active-orders':
                $data = Order::getActiveOrders();
                $exporter->exportActiveOrders($data);
                break;

            case 'overdue-orders':
                $data = Order::getOverdueOrders();
                $exporter->exportOverdueOrders($data);
                break;

            case 'department':
                if (!$id)
                    return $this->redirect('/reports');

                $department = $this->department->find($id);
                $executors = $this->executor->getByDepartment($id) ?: [];
                $issuers = $this->issuer->getByDepartment($id) ?: [];
                $orders = $this->order->getByDepartment($id) ?: [];

                $exporter->exportDepartmentReport($department, $executors, $issuers, $orders);
                break;

            case 'executor':
                if (!$id)
                    return $this->redirect('/reports');

                $executor = $this->executor->find($id);
                $department = $this->department->find($executor['department_id']);
                $position = $this->position->find($executor['position_id']);
                $orders = $this->order->getByExecutor($id) ?: [];

                $executor['department_name'] = $department ? $department['department_name'] : 'Не вказано';
                $executor['position_name'] = $position ? $position['position_name'] : 'Не вказано';

                $exporter->exportExecutorReport($executor, $orders);
                break;

            default:
                return $this->redirect('/reports');
        }

        exit;
    }

    // Для зворотної сумісності - залишаємо метод exportPdf
    public function exportPdf($reportType, $id = null)
    {
        return $this->exportReport('pdf', $reportType, $id);
    }
}

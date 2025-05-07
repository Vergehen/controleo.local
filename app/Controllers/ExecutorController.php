<?php

namespace App\Controllers;

use App\Models\Department;
use App\Models\Executor;
use App\Models\Order;
use App\Models\Position;

class ExecutorController extends Controller
{
    private $executor;
    private $department;
    private $position;
    private $order;

    public function __construct()
    {
        parent::__construct();
        $this->executor = new Executor();
        $this->department = new Department();
        $this->position = new Position();
        $this->order = new Order();
    }

    public function index()
    {
        $executors = $this->executor->getAllWithRelations();
        return $this->render('executors/index', [
            'executors' => $executors,
            'title' => 'Виконавці'
        ]);
    }

    public function show($id)
    {
        $executor = $this->executor->find($id);

        if (!$executor) {
            return $this->redirect('/executors');
        }

        $department = $this->department->find($executor['department_id']);
        $position = $this->position->find($executor['position_id']);
        $activeOrders = $this->order->getByExecutorAndStatus($id, 'active') ?: [];
        $completedOrders = $this->order->getByExecutorAndStatus($id, 'completed') ?: [];
        $overdueOrders = $this->order->getByExecutorAndStatus($id, 'overdue') ?: [];
        $allOrders = array_merge($activeOrders, $completedOrders, $overdueOrders);

        if (!isset($executor['executor_notes'])) {
            $executor['executor_notes'] = '';
        }

        $executor['department_name'] = $department ? $department['department_name'] : 'Не вказано';
        $executor['position_name'] = $position ? $position['position_name'] : 'Не вказано';

        return $this->render('executors/show', [
            'executor' => $executor,
            'department' => $department,
            'position' => $position,
            'activeOrders' => $activeOrders,
            'completedOrders' => $completedOrders,
            'overdueOrders' => $overdueOrders,
            'allOrders' => $allOrders,
            'title' => 'Виконавець: ' . $executor['executor_name']
        ]);
    }

    public function create()
    {
        $departments = $this->department->all();
        $positions = $this->position->all();

        return $this->render('executors/create', [
            'departments' => $departments,
            'positions' => $positions,
            'title' => 'Додавання виконавця'
        ]);
    }

    public function store()
    {
        $executorName = $_POST['executor_name'] ?? '';
        $executorContact = $_POST['executor_contact'] ?? '';
        $departmentId = $_POST['department_id'] ?? '';
        $positionId = $_POST['position_id'] ?? '';

        if (empty($executorName) || empty($departmentId) || empty($positionId)) {
            $departments = $this->department->all();
            $positions = $this->position->all();

            return $this->render('executors/create', [
                'departments' => $departments,
                'positions' => $positions,
                'error' => 'Необхідно заповнити всі обов\'язкові поля',
                'title' => 'Додавання виконавця'
            ]);
        }

        $this->executor->create([
            'executor_name' => $executorName,
            'executor_contact' => $executorContact,
            'department_id' => $departmentId,
            'position_id' => $positionId
        ]);

        return $this->redirect('/executors');
    }

    public function edit($id)
    {
        $executor = $this->executor->find($id);

        if (!$executor) {
            return $this->redirect('/executors');
        }

        $departments = $this->department->all();
        $positions = $this->position->all();

        return $this->render('executors/edit', [
            'executor' => $executor,
            'departments' => $departments,
            'positions' => $positions,
            'title' => 'Редагування виконавця'
        ]);
    }

    public function update($id)
    {
        $executorName = $_POST['executor_name'] ?? '';
        $executorContact = $_POST['executor_contact'] ?? '';
        $departmentId = $_POST['department_id'] ?? '';
        $positionId = $_POST['position_id'] ?? '';

        if (empty($executorName) || empty($departmentId) || empty($positionId)) {
            $executor = $this->executor->find($id);
            $departments = $this->department->all();
            $positions = $this->position->all();

            return $this->render('executors/edit', [
                'executor' => $executor,
                'departments' => $departments,
                'positions' => $positions,
                'error' => 'Необхідно заповнити всі обов\'язкові поля',
                'title' => 'Редагування виконавця'
            ]);
        }

        $this->executor->update($id, [
            'executor_name' => $executorName,
            'executor_contact' => $executorContact,
            'department_id' => $departmentId,
            'position_id' => $positionId
        ]);

        return $this->redirect('/executors');
    }

    public function delete($id)
    {
        $this->executor->delete($id);
        return $this->redirect('/executors');
    }

    public function search()
    {
        $query = $_GET['query'] ?? '';

        if (empty($query)) {
            return $this->redirect('/executors');
        }

        $results = $this->executor->search('executor_name', $query);

        return $this->render('executors/search', [
            'executors' => $results,
            'query' => $query,
            'title' => 'Результати пошуку виконавців'
        ]);
    }
}
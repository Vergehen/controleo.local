<?php

namespace App\Controllers;

use App\Models\Department;
use App\Models\Issuer;
use App\Models\Order;
use App\Models\Position;
use App\Services\AnalyticsService;

class IssuerController extends Controller
{
    private $issuer;
    private $department;
    private $position;
    private $order;
    private $analytics;

    public function __construct()
    {
        parent::__construct();
        $this->issuer = new Issuer();
        $this->department = new Department();
        $this->position = new Position();
        $this->order = new Order();
        $this->analytics = new AnalyticsService();
    }    public function index()
    {
        $issuers = $this->issuer->getAllWithRelations();
        
        // Отримуємо аналітичні дані по видавцях
        $generalStats = $this->analytics->getGeneralStatistics();
        $topIssuers = $this->analytics->getTopIssuers(10);
        $monthlyTrends = $this->analytics->getMonthlyTrends();
        
        return $this->render('issuers/index', [
            'issuers' => $issuers,
            'generalStats' => $generalStats,
            'topIssuers' => $topIssuers,
            'monthlyTrends' => $monthlyTrends,
            'title' => 'Видавці наказів'
        ]);
    }

    public function show($id)
    {
        $issuer = $this->issuer->find($id);

        if (!$issuer) {
            return $this->redirect('/issuers');
        }

        $department = $this->department->find($issuer['department_id']);
        $position = $this->position->find($issuer['position_id']);
        $issuerOrders = $this->order->getByIssuer($id) ?: [];

        if (!isset($issuer['issuer_notes'])) {
            $issuer['issuer_notes'] = '';
        }        $issuer['department_name'] = $department ? $department['department_name'] : 'Не вказано';
        $issuer['position_name'] = $position ? $position['position_name'] : 'Не вказано';

        // Отримуємо аналітичні дані для конкретного видавця
        $issuerStats = $this->analytics->getIssuerStatistics($id);

        return $this->render('issuers/show', [
            'issuer' => $issuer,
            'department' => $department,
            'position' => $position,
            'issuerOrders' => $issuerOrders,
            'issuerStats' => $issuerStats,
            'title' => 'Видавець наказів: ' . $issuer['issuer_name']
        ]);
    }

    public function create()
    {
        $departments = $this->department->all();
        $positions = $this->position->all();

        return $this->render('issuers/create', [
            'departments' => $departments,
            'positions' => $positions,
            'title' => 'Додавання видавця наказів'
        ]);
    }

    public function store()
    {
        $issuerName = $_POST['issuer_name'] ?? '';
        $issuerContact = $_POST['issuer_contact'] ?? '';
        $departmentId = $_POST['department_id'] ?? '';
        $positionId = $_POST['position_id'] ?? '';

        if (empty($issuerName) || empty($departmentId) || empty($positionId)) {
            $departments = $this->department->all();
            $positions = $this->position->all();

            return $this->render('issuers/create', [
                'departments' => $departments,
                'positions' => $positions,
                'error' => 'Необхідно заповнити всі обов\'язкові поля',
                'title' => 'Додавання видавця наказів'
            ]);
        }

        $this->issuer->create([
            'issuer_name' => $issuerName,
            'issuer_contact' => $issuerContact,
            'department_id' => $departmentId,
            'position_id' => $positionId
        ]);

        return $this->redirect('/issuers');
    }

    public function edit($id)
    {
        $issuer = $this->issuer->find($id);

        if (!$issuer) {
            return $this->redirect('/issuers');
        }

        $departments = $this->department->all();
        $positions = $this->position->all();

        if (!isset($issuer['issuer_notes'])) {
            $issuer['issuer_notes'] = '';
        }

        return $this->render('issuers/edit', [
            'issuer' => $issuer,
            'departments' => $departments,
            'positions' => $positions,
            'title' => 'Редагування видавця наказів'
        ]);
    }

    public function update($id)
    {
        $issuerName = $_POST['issuer_name'] ?? '';
        $issuerContact = $_POST['issuer_contact'] ?? '';
        $departmentId = $_POST['department_id'] ?? '';
        $positionId = $_POST['position_id'] ?? '';

        if (empty($issuerName) || empty($departmentId) || empty($positionId)) {
            $issuer = $this->issuer->find($id);
            $departments = $this->department->all();
            $positions = $this->position->all();

            return $this->render('issuers/edit', [
                'issuer' => $issuer,
                'departments' => $departments,
                'positions' => $positions,
                'error' => 'Необхідно заповнити всі обов\'язкові поля',
                'title' => 'Редагування видавця наказів'
            ]);
        }

        $this->issuer->update($id, [
            'issuer_name' => $issuerName,
            'issuer_contact' => $issuerContact,
            'department_id' => $departmentId,
            'position_id' => $positionId
        ]);

        return $this->redirect('/issuers');
    }

    public function delete($id)
    {
        $this->issuer->delete($id);
        return $this->redirect('/issuers');
    }

    public function search()
    {
        $query = $_GET['query'] ?? '';

        if (empty($query)) {
            return $this->redirect('/issuers');
        }

        $results = $this->issuer->search('issuer_name', $query);

        return $this->render('issuers/search', [
            'issuers' => $results,
            'query' => $query,
            'title' => 'Результати пошуку видавців'
        ]);
    }
}
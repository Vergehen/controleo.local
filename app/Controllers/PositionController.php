<?php

namespace App\Controllers;

use App\Models\Position;
use App\Services\AnalyticsService;

class PositionController extends Controller
{
    private $position;
    private $analytics;

    public function __construct()
    {
        parent::__construct();
        $this->position = new Position();
        $this->analytics = new AnalyticsService();
    }    public function index()
    {
        $sort = $_GET['sort'] ?? 'position_id';
        $order = $_GET['order'] ?? 'ASC';
        
        $positions = $this->position->getAllWithStats($sort, $order);
        
        // Отримуємо аналітичні дані по посадах
        $generalStats = $this->analytics->getGeneralStatistics();
        $topExecutors = $this->analytics->getTopExecutors(5);
        $topIssuers = $this->analytics->getTopIssuers(5);
        
        return $this->render('positions/index', [
            'positions' => $positions,
            'generalStats' => $generalStats,
            'topExecutors' => $topExecutors,
            'topIssuers' => $topIssuers,
            'title' => 'Посади',
            'currentSort' => $sort,
            'currentOrder' => $order
        ]);
    }

    public function show($id)
    {
        $position = $this->position->getPositionWithStats($id);

        if (!$position) {
            return $this->redirect('/positions');
        }

        $executors = $this->position->getExecutorsWithPosition($id);
        $issuers = $this->position->getIssuersWithPosition($id);

        return $this->render('positions/show', [
            'position' => $position,
            'executors' => $executors,
            'issuers' => $issuers,
            'title' => 'Посада: ' . $position['position_name']
        ]);
    }

    public function create()
    {
        return $this->render('positions/create', [
            'title' => 'Створення посади'
        ]);
    }

    public function store()
    {
        $positionName = $_POST['position_name'] ?? '';

        if (empty($positionName)) {
            return $this->render('positions/create', [
                'error' => 'Назва посади обов\'язкова',
                'title' => 'Створення посади'
            ]);
        }

        $this->position->create([
            'position_name' => $positionName
        ]);

        return $this->redirect('/positions');
    }

    public function edit($id)
    {
        $position = $this->position->find($id);

        if (!$position) {
            return $this->redirect('/positions');
        }

        return $this->render('positions/edit', [
            'position' => $position,
            'title' => 'Редагування посади'
        ]);
    }

    public function update($id)
    {
        $positionName = $_POST['position_name'] ?? '';

        if (empty($positionName)) {
            $position = $this->position->find($id);
            return $this->render('positions/edit', [
                'position' => $position,
                'error' => 'Назва посади обов\'язкова',
                'title' => 'Редагування посади'
            ]);
        }

        $this->position->update($id, [
            'position_name' => $positionName
        ]);

        return $this->redirect('/positions');
    }

    public function delete($id)
    {
        $this->position->delete($id);
        return $this->redirect('/positions');
    }

    public function search()
    {
        $query = $_GET['query'] ?? '';
        $sort = $_GET['sort'] ?? 'position_id';
        $order = $_GET['order'] ?? 'ASC';

        if (empty($query)) {
            return $this->redirect('/positions');
        }

        $results = $this->position->search('position_name', $query);

        return $this->render('positions/search', [
            'positions' => $results,
            'query' => $query,
            'title' => 'Результати пошуку посад',
            'currentSort' => $sort,
            'currentOrder' => $order
        ]);
    }
}
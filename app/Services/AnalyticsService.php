<?php

namespace App\Services;

use App\Models\Order;

class AnalyticsService
{
    private $order;

    public function __construct()
    {
        $this->order = new Order();
    }

    /**
     * Загальна статистика по всіх наказах
     */
    public function getGeneralStatistics(): array
    {
        $stats = $this->order->getGeneralStatistics();

        return [
            'total_orders' => $stats['total_orders'] ?? 0,
            'completed_orders' => $stats['completed_orders'] ?? 0,
            'active_orders' => $stats['active_orders'] ?? 0,
            'overdue_orders' => $stats['overdue_orders'] ?? 0,
            'completion_rate' => $stats['total_orders'] > 0 ?
                round(($stats['completed_orders'] / $stats['total_orders']) * 100, 2) : 0,
            'overdue_rate' => $stats['total_orders'] > 0 ?
                round(($stats['overdue_orders'] / $stats['total_orders']) * 100, 2) : 0,
            'avg_completion_days' => $stats['avg_completion_days'] ?? 0
        ];
    }

    /**
     * Розподіл наказів за пріоритетом
     */
    public function getPriorityDistribution(): array
    {
        return $this->order->getPriorityDistribution();
    }

    /**
     * Розподіл наказів за статусом
     */
    public function getStatusDistribution(): array
    {
        return $this->order->getStatusDistribution();
    }

    /**
     * Статистика по виконавцю
     */
    public function getExecutorStatistics($executorId): array
    {
        $stats = $this->order->getExecutorStatistics($executorId);

        return [
            'total_orders' => $stats['total_orders'] ?? 0,
            'completed_orders' => $stats['completed_orders'] ?? 0,
            'active_orders' => $stats['active_orders'] ?? 0,
            'overdue_orders' => $stats['overdue_orders'] ?? 0,
            'completion_rate' => $stats['total_orders'] > 0 ?
                round(($stats['completed_orders'] / $stats['total_orders']) * 100, 2) : 0,
            'avg_completion_days' => $stats['avg_completion_days'] ?? 0,
            'performance_score' => $this->calculatePerformanceScore($stats)
        ];
    }

    /**
     * Статистика по видавцю
     */
    public function getIssuerStatistics($issuerId): array
    {
        $stats = $this->order->getIssuerStatistics($issuerId);

        return [
            'total_orders' => $stats['total_orders'] ?? 0,
            'completed_orders' => $stats['completed_orders'] ?? 0,
            'active_orders' => $stats['active_orders'] ?? 0,
            'overdue_orders' => $stats['overdue_orders'] ?? 0,
            'avg_completion_days' => $stats['avg_completion_days'] ?? 0,
            'orders_per_month' => $stats['orders_per_month'] ?? 0
        ];
    }

    /**
     * Статистика по відділу
     */
    public function getDepartmentStatistics($departmentId): array
    {
        $stats = $this->order->getDepartmentStatistics($departmentId);

        return [
            'total_orders' => $stats['total_orders'] ?? 0,
            'completed_orders' => $stats['completed_orders'] ?? 0,
            'active_orders' => $stats['active_orders'] ?? 0,
            'overdue_orders' => $stats['overdue_orders'] ?? 0,
            'completion_rate' => $stats['total_orders'] > 0 ?
                round(($stats['completed_orders'] / $stats['total_orders']) * 100, 2) : 0,
            'avg_completion_days' => $stats['avg_completion_days'] ?? 0,
            'executors_count' => $stats['executors_count'] ?? 0,
            'issuers_count' => $stats['issuers_count'] ?? 0
        ];
    }

    /**
     * Тенденції по місяцях (останні 6 місяців)
     */
    public function getMonthlyTrends(): array
    {
        return $this->order->getMonthlyTrends();
    }

    /**
     * Топ виконавців
     */
    public function getTopExecutors($limit = 5): array
    {
        return $this->order->getTopExecutors($limit);
    }

    /**
     * Топ видавців
     */
    public function getTopIssuers($limit = 5): array
    {
        return $this->order->getTopIssuers($limit);
    }

    /**
     * Розрахунок оцінки продуктивності
     */
    private function calculatePerformanceScore($stats): float
    {
        if (($stats['total_orders'] ?? 0) == 0) {
            return 0;
        }

        $completionRate = ($stats['completed_orders'] / $stats['total_orders']) * 100;
        $overdueRate = ($stats['overdue_orders'] / $stats['total_orders']) * 100;

        // Формула: completion_rate - (overdue_rate * 2) + bonus за швидкість
        $score = $completionRate - ($overdueRate * 2);

        // Бонус за швидкість виконання (чим менше днів, тим краще)
        if (($stats['avg_completion_days'] ?? 0) > 0) {
            $speedBonus = max(0, 30 - $stats['avg_completion_days']); // максимум 30 днів
            $score += $speedBonus * 0.5;
        }

        return round(max(0, min(100, $score)), 2);
    }
}

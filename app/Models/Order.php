<?php

namespace App\Models;

class Order extends Model
{
    protected $table = 'Orders';
    protected $primaryKey = 'order_id';
    protected $issuer_id;

    public function getIssuer(): mixed
    {
        $stmt = $this->db->prepare("
            SELECT * 
            FROM Issuers 
            WHERE issuer_id = :issuer_id
        ");

        $stmt->execute(['issuer_id' => $this->issuer_id]);
        return $stmt->fetch();
    }

    public function getOrderDetails($id): mixed
    {
        $stmt = $this->db->prepare("
            SELECT 
                o.*,
                e.executor_name,
                i.issuer_name,
                d.department_name AS executor_department
            FROM 
                Orders o
                JOIN Executors e ON o.executor_id = e.executor_id
                JOIN Issuers i ON o.issuer_id = i.issuer_id
                JOIN Departments d ON e.department_id = d.department_id
            WHERE 
                o.order_id = :id
        ");

        $stmt->execute(['id' => $id]);
        return $stmt->fetch();
    }

    public static function getActiveOrders(): array
    {
        $model = new self();
        $stmt = $model->db->query("
            SELECT 
                o.order_id,
                o.order_name,
                o.order_deadline,
                e.executor_name,
                i.issuer_name,
                o.order_priority
            FROM 
                Orders o
                JOIN Executors e ON o.executor_id = e.executor_id
                JOIN Issuers i ON o.issuer_id = i.issuer_id
            WHERE 
                o.order_status = 'active'
            ORDER BY o.order_id ASC
        ");

        return $stmt->fetchAll();
    }

    public static function getOverdueOrders(): array
    {
        $model = new self();
        $stmt = $model->db->query("
            SELECT 
                o.*,
                e.executor_name,
                i.issuer_name
            FROM 
                Orders o
                JOIN Executors e ON o.executor_id = e.executor_id
                JOIN Issuers i ON o.issuer_id = i.issuer_id
            WHERE 
                (o.order_deadline < CURDATE() AND o.order_date_completed IS NULL AND o.order_status NOT IN ('completed', 'cancelled', 'failed'))
                OR o.order_status = 'overdue'
            ORDER BY o.order_deadline ASC
        ");

        return $stmt->fetchAll();
    }

    public static function searchByMultipleFields($search): array
    {
        $model = new self();
        $stmt = $model->db->prepare("
            SELECT 
                o.*,
                e.executor_name,
                i.issuer_name
            FROM 
                Orders o
                JOIN Executors e ON o.executor_id = e.executor_id
                JOIN Issuers i ON o.issuer_id = i.issuer_id
            WHERE 
                o.order_name LIKE :search OR
                o.order_content LIKE :search OR
                e.executor_name LIKE :search OR
                i.issuer_name LIKE :search OR
                o.order_status LIKE :search OR
                o.order_priority LIKE :search
            ORDER BY o.order_id ASC
        ");

        $stmt->execute(['search' => "%$search%"]);
        return $stmt->fetchAll();
    }

    public static function getAllWithNames($sort = 'order_id', $order = 'ASC'): array
    {
        $allowedSortColumns = ['order_id', 'order_name', 'order_deadline', 'order_priority', 'order_status', 'executor_name', 'issuer_name'];
        $allowedOrders = ['ASC', 'DESC'];

        if (!in_array($sort, $allowedSortColumns)) {
            $sort = 'order_id';
        }

        if (!in_array(strtoupper($order), $allowedOrders)) {
            $order = 'ASC';
        }

        $model = new self();
        $sortPrefix = '';

        if ($sort === 'executor_name') {
            $sortPrefix = 'e.';
        } elseif ($sort === 'issuer_name') {
            $sortPrefix = 'i.';
        } else {
            $sortPrefix = 'o.';
        }

        $stmt = $model->db->query("
            SELECT 
                o.*,
                e.executor_name,
                i.issuer_name
            FROM 
                Orders o
                JOIN Executors e ON o.executor_id = e.executor_id
                JOIN Issuers i ON o.issuer_id = i.issuer_id
            ORDER BY {$sortPrefix}{$sort} {$order}
        ");

        return $stmt->fetchAll();
    }

    public function getByExecutorAndStatus($executorId, $status = null): array
    {
        $sql = "
            SELECT 
                o.*,
                e.executor_name,
                i.issuer_name
            FROM 
                Orders o
                JOIN Executors e ON o.executor_id = e.executor_id
                JOIN Issuers i ON o.issuer_id = i.issuer_id
            WHERE 
                o.executor_id = :executor_id
        ";

        $params = ['executor_id' => $executorId];

        if ($status !== null) {
            if ($status === 'overdue') {
                $sql .= " AND ((o.order_deadline < CURDATE() AND o.order_date_completed IS NULL AND o.order_status NOT IN ('completed', 'cancelled', 'failed')) OR o.order_status = 'overdue')";
            } else {
                $sql .= " AND o.order_status = :status";
                $params['status'] = $status;
            }
        }

        $sql .= " ORDER BY o.order_deadline ASC";

        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll();
    }

    public function getByExecutor($executorId, $sort = 'order_id', $order = 'ASC'): array
    {
        $allowedSortColumns = ['order_id', 'order_name', 'order_deadline', 'order_priority', 'order_status', 'issuer_name'];
        $allowedOrders = ['ASC', 'DESC'];

        if (!in_array($sort, $allowedSortColumns)) {
            $sort = 'order_id';
        }

        if (!in_array(strtoupper($order), $allowedOrders)) {
            $order = 'ASC';
        }

        $sortPrefix = '';
        $sortPrefix = ($sort === 'issuer_name') ? 'i.' : 'o.';

        $stmt = $this->db->prepare("
            SELECT 
                o.*,
                e.executor_name,
                i.issuer_name
            FROM 
                Orders o
                JOIN Executors e ON o.executor_id = e.executor_id
                JOIN Issuers i ON o.issuer_id = i.issuer_id
            WHERE 
                o.executor_id = :executor_id
            ORDER BY {$sortPrefix}{$sort} {$order}
        ");

        $stmt->execute(['executor_id' => $executorId]);
        return $stmt->fetchAll();
    }

    public function getByIssuer($issuerId, $sort = 'order_id', $order = 'ASC'): array
    {
        $allowedSortColumns = ['order_id', 'order_name', 'order_deadline', 'order_priority', 'order_status', 'executor_name'];
        $allowedOrders = ['ASC', 'DESC'];

        if (!in_array($sort, $allowedSortColumns)) {
            $sort = 'order_id';
        }

        if (!in_array(strtoupper($order), $allowedOrders)) {
            $order = 'ASC';
        }

        $sortPrefix = '';
        $sortPrefix = ($sort === 'executor_name') ? 'e.' : 'o.';

        $stmt = $this->db->prepare("
            SELECT 
                o.*,
                e.executor_name,
                i.issuer_name
            FROM 
                Orders o
                JOIN Executors e ON o.executor_id = e.executor_id
                JOIN Issuers i ON o.issuer_id = i.issuer_id
            WHERE 
                o.issuer_id = :issuer_id
            ORDER BY {$sortPrefix}{$sort} {$order}
        ");

        $stmt->execute(['issuer_id' => $issuerId]);
        return $stmt->fetchAll();
    }

    public function getByDepartment($departmentId, $sort = 'order_id', $order = 'ASC'): array
    {
        $allowedSortColumns = ['order_id', 'order_name', 'order_deadline', 'order_priority', 'order_status', 'executor_name', 'issuer_name'];
        $allowedOrders = ['ASC', 'DESC'];

        if (!in_array($sort, $allowedSortColumns)) {
            $sort = 'order_id';
        }

        if (!in_array(strtoupper($order), $allowedOrders)) {
            $order = 'ASC';
        }

        $sortPrefix = '';

        if ($sort === 'executor_name') {
            $sortPrefix = 'e.';
        } elseif ($sort === 'issuer_name') {
            $sortPrefix = 'i.';
        } else {
            $sortPrefix = 'o.';
        }

        $stmt = $this->db->prepare("
            SELECT 
                o.*,
                e.executor_name,
                i.issuer_name
            FROM 
                Orders o
                JOIN Executors e ON o.executor_id = e.executor_id
                JOIN Issuers i ON o.issuer_id = i.issuer_id
            WHERE 
                e.department_id = :department_id OR i.department_id = :department_id
            ORDER BY {$sortPrefix}{$sort} {$order}
        ");

        $stmt->execute(['department_id' => $departmentId]);
        return $stmt->fetchAll();
    }

    public static function updateOverdueStatuses(): int
    {
        $model = new self();
        $stmt = $model->db->prepare("
            UPDATE Orders 
            SET order_status = 'overdue'
            WHERE 
                order_deadline < CURDATE() 
                AND order_status = 'active' 
                AND order_date_completed IS NULL
        ");
        $stmt->execute();
        return $stmt->rowCount();
    }

    /**
     * Загальна статистика по всіх наказах
     */
    public function getGeneralStatistics(): array
    {
        $stmt = $this->db->query("
            SELECT 
                COUNT(*) as total_orders,
                SUM(CASE WHEN order_status = 'completed' THEN 1 ELSE 0 END) as completed_orders,
                SUM(CASE WHEN order_status = 'active' THEN 1 ELSE 0 END) as active_orders,
                SUM(CASE WHEN order_status = 'overdue' THEN 1 ELSE 0 END) as overdue_orders,
                AVG(CASE 
                    WHEN order_status = 'completed' AND order_date_completed IS NOT NULL 
                    THEN DATEDIFF(order_date_completed, order_date_issued) 
                    ELSE NULL 
                END) as avg_completion_days
            FROM Orders
        ");
        
        return $stmt->fetch() ?: [];
    }    /**
     * Розподіл наказів за пріоритетом
     */
    public function getPriorityDistribution(): array
    {
        $stmt = $this->db->query("
            SELECT 
                order_priority as priority,
                COUNT(*) as count,
                ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Orders)), 2) as percentage
            FROM Orders 
            GROUP BY order_priority
            ORDER BY 
                CASE order_priority 
                    WHEN 'High' THEN 1 
                    WHEN 'Medium' THEN 2 
                    WHEN 'Low' THEN 3 
                END
        ");
        
        return $stmt->fetchAll();
    }    /**
     * Розподіл наказів за статусом
     */
    public function getStatusDistribution(): array
    {
        $stmt = $this->db->query("
            SELECT 
                order_status as status,
                COUNT(*) as count,
                ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Orders)), 2) as percentage
            FROM Orders 
            GROUP BY order_status
            ORDER BY count DESC
        ");
        
        return $stmt->fetchAll();
    }

    /**
     * Статистика по виконавцю
     */
    public function getExecutorStatistics($executorId): array
    {
        $stmt = $this->db->prepare("
            SELECT 
                COUNT(*) as total_orders,
                SUM(CASE WHEN order_status = 'completed' THEN 1 ELSE 0 END) as completed_orders,
                SUM(CASE WHEN order_status = 'active' THEN 1 ELSE 0 END) as active_orders,
                SUM(CASE WHEN order_status = 'overdue' THEN 1 ELSE 0 END) as overdue_orders,
                AVG(CASE 
                    WHEN order_status = 'completed' AND order_date_completed IS NOT NULL 
                    THEN DATEDIFF(order_date_completed, order_date_issued) 
                    ELSE NULL 
                END) as avg_completion_days
            FROM Orders 
            WHERE executor_id = :executor_id
        ");
        
        $stmt->execute(['executor_id' => $executorId]);
        return $stmt->fetch() ?: [];
    }

    /**
     * Статистика по видавцю
     */
    public function getIssuerStatistics($issuerId): array
    {
        $stmt = $this->db->prepare("
            SELECT 
                COUNT(*) as total_orders,
                SUM(CASE WHEN order_status = 'completed' THEN 1 ELSE 0 END) as completed_orders,
                SUM(CASE WHEN order_status = 'active' THEN 1 ELSE 0 END) as active_orders,
                SUM(CASE WHEN order_status = 'overdue' THEN 1 ELSE 0 END) as overdue_orders,
                AVG(CASE 
                    WHEN order_status = 'completed' AND order_date_completed IS NOT NULL 
                    THEN DATEDIFF(order_date_completed, order_date_issued) 
                    ELSE NULL 
                END) as avg_completion_days,
                ROUND(COUNT(*) / 12.0, 2) as orders_per_month
            FROM Orders 
            WHERE issuer_id = :issuer_id
        ");
        
        $stmt->execute(['issuer_id' => $issuerId]);
        return $stmt->fetch() ?: [];
    }

    /**
     * Статистика по відділу
     */
    public function getDepartmentStatistics($departmentId): array
    {
        $stmt = $this->db->prepare("
            SELECT 
                COUNT(DISTINCT o.order_id) as total_orders,
                SUM(CASE WHEN o.order_status = 'completed' THEN 1 ELSE 0 END) as completed_orders,
                SUM(CASE WHEN o.order_status = 'active' THEN 1 ELSE 0 END) as active_orders,
                SUM(CASE WHEN o.order_status = 'overdue' THEN 1 ELSE 0 END) as overdue_orders,
                AVG(CASE 
                    WHEN o.order_status = 'completed' AND o.order_date_completed IS NOT NULL 
                    THEN DATEDIFF(o.order_date_completed, o.order_date_issued) 
                    ELSE NULL 
                END) as avg_completion_days,
                COUNT(DISTINCT e.executor_id) as executors_count,
                COUNT(DISTINCT i.issuer_id) as issuers_count
            FROM Orders o
            JOIN Executors e ON o.executor_id = e.executor_id
            JOIN Issuers i ON o.issuer_id = i.issuer_id
            WHERE e.department_id = :department_id OR i.department_id = :department_id
        ");
        
        $stmt->execute(['department_id' => $departmentId]);
        return $stmt->fetch() ?: [];
    }    /**
     * Тенденції по місяцях (останні 6 місяців)
     */
    public function getMonthlyTrends(): array
    {
        $stmt = $this->db->query("
            SELECT 
                DATE_FORMAT(order_date_issued, '%Y-%m') as month,
                COUNT(*) as count,
                SUM(CASE WHEN order_status = 'completed' THEN 1 ELSE 0 END) as completed_orders,
                SUM(CASE WHEN order_status = 'overdue' THEN 1 ELSE 0 END) as overdue_orders
            FROM Orders 
            WHERE order_date_issued >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
            GROUP BY DATE_FORMAT(order_date_issued, '%Y-%m')
            ORDER BY month ASC
        ");
        
        return $stmt->fetchAll();
    }

    /**
     * Топ виконавців за кількістю виконаних наказів
     */    public function getTopExecutors($limit = 5): array
    {
        // Convert limit to integer to prevent SQL injection
        $limit = (int)$limit;
          $stmt = $this->db->prepare("
            SELECT 
                e.executor_id,
                e.executor_name,
                COUNT(*) as total_orders,
                SUM(CASE WHEN o.order_status = 'completed' THEN 1 ELSE 0 END) as completed_orders,
                SUM(CASE WHEN o.order_status = 'overdue' THEN 1 ELSE 0 END) as overdue_orders,
                ROUND((SUM(CASE WHEN o.order_status = 'completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) as completion_rate,
                AVG(CASE 
                    WHEN o.order_status = 'completed' AND o.order_date_completed IS NOT NULL 
                    THEN DATEDIFF(o.order_date_completed, o.order_date_issued) 
                    ELSE NULL 
                END) as avg_completion_days,
                -- Calculate performance score in SQL
                ROUND(GREATEST(0, LEAST(100, 
                    (SUM(CASE WHEN o.order_status = 'completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) - 
                    ((SUM(CASE WHEN o.order_status = 'overdue' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) * 2) +
                    GREATEST(0, 30 - COALESCE(AVG(CASE 
                        WHEN o.order_status = 'completed' AND o.order_date_completed IS NOT NULL 
                        THEN DATEDIFF(o.order_date_completed, o.order_date_issued) 
                        ELSE NULL 
                    END), 0)) * 0.5
                )), 2) as performance_score
            FROM Executors e
            JOIN Orders o ON e.executor_id = o.executor_id
            GROUP BY e.executor_id, e.executor_name
            HAVING total_orders > 0
            ORDER BY performance_score DESC, completed_orders DESC
            LIMIT {$limit}
        ");
        
        $stmt->execute();
        return $stmt->fetchAll();
    }

    /**
     * Топ видавців за кількістю наказів
     */    public function getTopIssuers($limit = 5): array
    {
        // Convert limit to integer to prevent SQL injection
        $limit = (int)$limit;
        
        $stmt = $this->db->prepare("
            SELECT 
                i.issuer_id,
                i.issuer_name,
                COUNT(*) as total_orders,
                SUM(CASE WHEN o.order_status = 'completed' THEN 1 ELSE 0 END) as completed_orders,
                SUM(CASE WHEN o.order_status = 'active' THEN 1 ELSE 0 END) as active_orders,
                AVG(CASE 
                    WHEN o.order_status = 'completed' AND o.order_date_completed IS NOT NULL 
                    THEN DATEDIFF(o.order_date_completed, o.order_date_issued) 
                    ELSE NULL 
                END) as avg_completion_days,
                ROUND(COUNT(*) / (DATEDIFF(NOW(), MIN(o.order_date_issued)) / 30.44), 2) as orders_per_month
            FROM Issuers i
            JOIN Orders o ON i.issuer_id = o.issuer_id
            GROUP BY i.issuer_id, i.issuer_name
            HAVING total_orders > 0
            ORDER BY total_orders DESC
            LIMIT {$limit}
        ");
        
        $stmt->execute();
        return $stmt->fetchAll();
    }
}
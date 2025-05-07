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
}
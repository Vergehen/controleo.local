<?php

namespace App\Models;

class Position extends Model
{
    protected $table = 'Positions';
    protected $primaryKey = 'position_id';

    public static function getPositionName($positionId): string
    {
        $model = new self();
        $stmt = $model->db->prepare("SELECT position_name FROM Positions WHERE position_id = :id");
        $stmt->execute(['id' => $positionId]);
        $result = $stmt->fetch();

        return $result ? $result['position_name'] : 'Невідома посада';
    }

    public function getExecutorsWithPosition($positionId): array
    {
        $stmt = $this->db->prepare("
            SELECT 
                e.*,
                d.department_name
            FROM 
                Executors e
                LEFT JOIN Departments d ON e.department_id = d.department_id
            WHERE 
                e.position_id = :position_id
        ");

        $stmt->execute(['position_id' => $positionId]);
        return $stmt->fetchAll();
    }

    public function getIssuersWithPosition($positionId): array
    {
        $stmt = $this->db->prepare("
            SELECT 
                i.*,
                d.department_name
            FROM 
                Issuers i
                LEFT JOIN Departments d ON i.department_id = d.department_id
            WHERE 
                i.position_id = :position_id
        ");

        $stmt->execute(['position_id' => $positionId]);
        return $stmt->fetchAll();
    }

    public function getPositionWithStats($positionId): array
    {
        $position = $this->find($positionId);

        if (!$position) {
            return [];
        }

        $executorsCount = $this->db->prepare("
            SELECT COUNT(*) as count 
            FROM Executors 
            WHERE position_id = :position_id
        ");
        $executorsCount->execute(['position_id' => $positionId]);
        $executorsResult = $executorsCount->fetch();

        $issuersCount = $this->db->prepare("
            SELECT COUNT(*) as count 
            FROM Issuers 
            WHERE position_id = :position_id
        ");
        $issuersCount->execute(['position_id' => $positionId]);
        $issuersResult = $issuersCount->fetch();

        $position['executors_count'] = $executorsResult ? $executorsResult['count'] : 0;
        $position['issuers_count'] = $issuersResult ? $issuersResult['count'] : 0;

        return $position;
    }

    public function getAllWithStats($sort = 'position_id', $order = 'ASC'): array
    {
        $allowedSortColumns = ['position_id', 'position_name', 'executors_count', 'issuers_count', 'total_count'];
        $allowedOrders = ['ASC', 'DESC'];

        if (!in_array($sort, $allowedSortColumns)) {
            $sort = 'position_id';
        }

        if (!in_array(strtoupper($order), $allowedOrders)) {
            $order = 'ASC';
        }

        $sql = "
            SELECT 
                p.position_id, 
                p.position_name,
                COUNT(DISTINCT e.executor_id) as executors_count,
                COUNT(DISTINCT i.issuer_id) as issuers_count,
                (COUNT(DISTINCT e.executor_id) + COUNT(DISTINCT i.issuer_id)) as total_count
            FROM 
                Positions p
                LEFT JOIN Executors e ON p.position_id = e.position_id
                LEFT JOIN Issuers i ON p.position_id = i.position_id
            GROUP BY 
                p.position_id, p.position_name
        ";

        if ($sort === 'position_id' || $sort === 'position_name') {
            $sql .= " ORDER BY p.{$sort} {$order}";
        } else {
            $sql .= " ORDER BY {$sort} {$order}";
        }

        $stmt = $this->db->query($sql);
        return $stmt->fetchAll();
    }
}
<?php

namespace App\Models;

class Executor extends Model
{
    protected $table = 'Executors';
    protected $primaryKey = 'executor_id';
    protected $executor_id;

    public function getAllWithRelations(): array
    {
        $stmt = $this->db->query("
            SELECT 
                e.*,
                d.department_name,
                p.position_name
            FROM 
                Executors e
                LEFT JOIN Departments d ON e.department_id = d.department_id
                LEFT JOIN Positions p ON e.position_id = p.position_id
        ");

        return $stmt->fetchAll();
    }

    public function getByDepartment($departmentId): array
    {
        $stmt = $this->db->prepare("
            SELECT 
                e.*,
                d.department_name,
                p.position_name
            FROM 
                Executors e
                LEFT JOIN Departments d ON e.department_id = d.department_id
                LEFT JOIN Positions p ON e.position_id = p.position_id
            WHERE 
                e.department_id = :department_id
        ");

        $stmt->execute(['department_id' => $departmentId]);
        return $stmt->fetchAll();
    }

    // Added missing getAll() method
    public function getAll(): array
    {
        return $this->getAllWithRelations();
    }
}
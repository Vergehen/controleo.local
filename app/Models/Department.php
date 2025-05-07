<?php

namespace App\Models;

class Department extends Model
{
    protected $table = 'Departments';
    protected $primaryKey = 'department_id';
    protected $department_id;

    public static function getDepartmentsWithCounts(): array
    {
        $model = new self();
        $query = "
            SELECT 
                d.department_id,
                d.department_name,
                COUNT(DISTINCT e.executor_id) AS executor_count,
                COUNT(DISTINCT i.issuer_id) AS issuer_count
            FROM 
                Departments d
                LEFT JOIN Executors e ON d.department_id = e.department_id
                LEFT JOIN Issuers i ON d.department_id = i.department_id
            GROUP BY 
                d.department_id, d.department_name
        ";

        $stmt = $model->db->query($query);
        return $stmt->fetchAll();
    }

    public static function getAllWithStats(): array
    {
        $model = new self();
        $query = "
            SELECT 
                d.department_id,
                d.department_name,
                COUNT(DISTINCT e.executor_id) AS executor_count,
                COUNT(DISTINCT i.issuer_id) AS issuer_count,
                COUNT(DISTINCT o.order_id) AS order_count
            FROM 
                Departments d
                LEFT JOIN Executors e ON d.department_id = e.department_id
                LEFT JOIN Issuers i ON d.department_id = i.department_id
                LEFT JOIN Orders o ON e.executor_id = o.executor_id OR i.issuer_id = o.issuer_id
            GROUP BY 
                d.department_id, d.department_name
        ";

        $stmt = $model->db->query($query);
        return $stmt->fetchAll();
    }
}
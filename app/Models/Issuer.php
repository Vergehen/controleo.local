<?php

namespace App\Models;

class Issuer extends Model
{
    protected $table = 'Issuers';
    protected $primaryKey = 'issuer_id';

    public function getAllWithRelations(): array
    {
        $stmt = $this->db->query("
            SELECT 
                i.*,
                d.department_name,
                p.position_name
            FROM 
                Issuers i
                LEFT JOIN Departments d ON i.department_id = d.department_id
                LEFT JOIN Positions p ON i.position_id = p.position_id
        ");

        return $stmt->fetchAll();
    }

    public function getByDepartment($departmentId): array
    {
        $stmt = $this->db->prepare("
            SELECT 
                i.*,
                d.department_name,
                p.position_name
            FROM 
                Issuers i
                LEFT JOIN Departments d ON i.department_id = d.department_id
                LEFT JOIN Positions p ON i.position_id = p.position_id
            WHERE 
                i.department_id = :department_id
        ");

        $stmt->execute(['department_id' => $departmentId]);
        return $stmt->fetchAll();
    }
}
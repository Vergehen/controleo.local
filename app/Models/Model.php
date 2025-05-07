<?php

namespace App\Models;

abstract class Model
{
    protected $db;
    protected $table;
    protected $primaryKey = 'id';

    public function __construct()
    {
        // Викликаємо метод підключення до бази даних
        $this->connectToDatabase();
    }

    // Метод для підключення до бази даних
    protected function connectToDatabase(): void
    {
        $config = parse_ini_file(dirname(dirname(__DIR__)) . '/config/config.ini', true);
        $dbConfig = $config['database'];

        try {
            $this->db = new \PDO(
                "mysql:host={$dbConfig['host']};dbname={$dbConfig['dbname']}",
                $dbConfig['username'],
                $dbConfig['password'],
            );
            $this->db->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);
            $this->db->setAttribute(\PDO::ATTR_DEFAULT_FETCH_MODE, \PDO::FETCH_ASSOC);
        }
        catch (\PDOException $e) {
            die("Не вдалося підключитися до бази даних: " . $e->getMessage());
        }
    }

    // Функція для отримання всіх записів з таблиці
    public function all(): array
    {
        $stmt = $this->db->query("SELECT * FROM {$this->table}");
        return $stmt->fetchAll();
    }

    // Функція для пошуку запису за ID
    public function find($id): mixed
    {
        $stmt = $this->db->prepare("SELECT * FROM {$this->table} WHERE {$this->primaryKey} = :id");
        $stmt->execute(['id' => $id]);

        return $stmt->fetch();
    }

    // Функція для пошуку записів за певним критерієм
    public function search($column, $value): array
    {
        $stmt = $this->db->prepare("SELECT * FROM {$this->table} WHERE $column LIKE :value");
        $stmt->execute(['value' => "%$value%"]);

        return $stmt->fetchAll();
    }

    // Функція для створення нового запису
    public function create($data): bool
    {
        $columns = implode(', ', array_keys($data));
        $placeholders = ':' . implode(', :', array_keys($data));

        $sql = "INSERT INTO {$this->table} ($columns) VALUES ($placeholders)";
        $stmt = $this->db->prepare($sql);

        return $stmt->execute($data);
    }

    // Функція для оновлення даних запису
    public function update($id, $data): bool
    {
        $setClause = '';
        foreach ($data as $key => $value) {
            $setClause .= "$key = :$key, ";
        }
        $setClause = rtrim($setClause, ', ');

        $sql = "UPDATE {$this->table} SET $setClause WHERE {$this->primaryKey} = :id";
        $data['id'] = $id;

        $stmt = $this->db->prepare($sql);
        return $stmt->execute($data);
    }

    // Функція для видалення запису
    public function delete($id): bool
    {
        $stmt = $this->db->prepare("DELETE FROM {$this->table} WHERE {$this->primaryKey} = :id");
        return $stmt->execute(['id' => $id]);
    }
}
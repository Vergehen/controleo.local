<?php
// Функція для автоматичного завантаження класів
require_once __DIR__ . '/../vendor/autoload.php';

// Запускаємо сесію
session_start();

// Виставляємо налаштування помилок (для розробки)
error_reporting(E_ALL);
ini_set('display_errors', 1);

require_once __DIR__ . '/../routes/routes.php';
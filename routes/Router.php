<?php

namespace App\Routes;

class Router
{
    private $routes = [];

    // Функція для додавання маршруту
    public function addRoute($method, $path, $controller, $action): void
    {
        $this->routes[] = [
            'method' => $method,         // метод HTTP запиту (GET, POST і т.д.)
            'path' => $path,             // шлях URL (наприклад, '/orders')
            'controller' => $controller, // клас контролера
            'action' => $action          // метод контролера
        ];
    }

    // Функція для обробки запиту 
    public function dispatch(): bool
    {
        $requestMethod = $_SERVER['REQUEST_METHOD'];
        $requestUri = $_SERVER['REQUEST_URI'];
        $queryString = '';

        if (strpos($requestUri, '?') !== false) {
            $parts = explode('?', $requestUri, 2);
            $requestUri = $parts[0];
            $queryString = $parts[1];
        }

        $basePath = dirname($_SERVER['SCRIPT_NAME']);
        if ($basePath !== '/' && strpos($requestUri, $basePath) === 0) {
            $requestUri = substr($requestUri, strlen($basePath));
        }

        if (empty($requestUri) || $requestUri[0] !== '/') {
            $requestUri = "/{$requestUri}";
        }

        // Видаляємо останні слеші з URL
        $requestUri = rtrim($requestUri, '/');
        if (empty($requestUri)) {
            $requestUri = '/';
        }

        // Шукаємо маршрут, який відповідає запиту
        foreach ($this->routes as $route) {
            // Конвертуємо шаблон у регулярний вираз
            $pattern = $this->convertPatternToRegex($route['path']);

            // Перевіряємо чи збігається метод і шлях
            if ($requestMethod === $route['method'] && preg_match($pattern, $requestUri, $matches)) {
                // Видаляємо першу відповідність (це весь URL)
                array_shift($matches);

                // Створюємо екземпляр контролера
                $controllerName = $route['controller'];
                $controller = new $controllerName();
                $action = $route['action'];

                call_user_func_array([$controller, $action], $matches);
                return true;
            }
        }

        header("HTTP/1.0 404 Not Found");
        echo '<h1>404 Сторінку не знайдено</h1>';
        echo "<p>Запитаний URL не знайдено на сервері. URL: {$requestUri}</p>";
        return false;
    }

    // Функція для перетворення шаблону маршруту в регулярний вираз
    private function convertPatternToRegex($pattern): string
    {
        // Замінюємо параметри {id} на групи захоплення в регулярному виразі
        $pattern = preg_replace('/\{([a-zA-Z0-9_]+)\}/', '([^/]+)', $pattern);
        // Додаємо початок та кінець для точного збігу
        return "@^{$pattern}$@D";
    }
}
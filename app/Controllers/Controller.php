<?php

namespace App\Controllers;

abstract class Controller
{
    protected $smarty;

    public function __construct()
    {
        $this->initializeSmarty();
    }

    protected function initializeSmarty(): void
    {
        $config = parse_ini_file(dirname(dirname(__DIR__)) . '/config/config.ini', true);
        $smartyConfig = $config['smarty'];

        $this->smarty = new \Smarty();

        $baseDir = dirname(dirname(__DIR__));

        // Де шукати шаблони
        $this->smarty->setTemplateDir($baseDir . '/' . $smartyConfig['template_dir']);

        // Де зберігати скомпільовані шаблони
        $this->smarty->setCompileDir($baseDir . '/' . $smartyConfig['compile_dir']);

        // Де зберігати кеш шаблонів
        $this->smarty->setCacheDir($baseDir . '/' . $smartyConfig['cache_dir']);

        // Де шукати файли конфігурації
        $this->smarty->setConfigDir($baseDir . '/' . $smartyConfig['config_dir']);

        // Додаткові параметри Smarty
        $this->smarty->force_compile = $smartyConfig['force_compile'];
        $this->smarty->debugging = $smartyConfig['debugging'];
        $this->smarty->caching = $smartyConfig['caching'];

        // Реєструємо PHP функції як модифікатори Smarty
        $this->smarty->registerPlugin('modifier', 'strtotime', 'strtotime');
        $this->smarty->registerPlugin('modifier', 'ceil', 'ceil');
        $this->smarty->registerPlugin('modifier', 'floor', 'floor');
        $this->smarty->registerPlugin('modifier', 'round', 'round');
        
        // Додамо власний модифікатор для днів простроченості
        $this->smarty->registerPlugin('modifier', 'formatOverdueDays', function($value) {
            return intval($value);
        });
    }

    protected function render($template, $data = [])
    {
        foreach ($data as $key => $value) {
            $this->smarty->assign($key, $value);
        }

        return $this->smarty->display("{$template}.tpl");
    }

    protected function redirect($url): never
    {
        header("Location: {$url}");
        exit();
    }
}
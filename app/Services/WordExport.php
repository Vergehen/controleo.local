<?php

namespace App\Services;

use PhpOffice\PhpWord\Element\Table;
use PhpOffice\PhpWord\IOFactory;
use PhpOffice\PhpWord\PhpWord;
use PhpOffice\PhpWord\SimpleType\TblWidth;
use PhpOffice\PhpWord\Style\Font;

class WordExport
{
    private $phpWord;

    public function __construct()
    {
        $this->phpWord = new PhpWord();

        $this->phpWord->setDefaultFontName('Times New Roman');
        $this->phpWord->setDefaultFontSize(12);

        $this->phpWord->addTitleStyle(1, ['size' => 16, 'bold' => true], ['alignment' => 'center', 'spaceAfter' => 120]);
        $this->phpWord->addTitleStyle(2, ['size' => 14, 'bold' => true], ['alignment' => 'left', 'spaceAfter' => 100]);

        $this->phpWord->addTableStyle(
            'TableStyle',
            [
                'borderSize' => 1,
                'borderColor' => '000000',
                'width' => 100 * 50,
                'unit' => 'pct',
                'alignment' => 'center',
                'cellMargin' => 80
            ]
        );

        $this->phpWord->addFontStyle(
            'TableHeader',
            [
                'bold' => true,
                'size' => 12
            ]
        );
    }

    public function exportActiveOrders(array $orders)
    {
        $section = $this->phpWord->addSection();

        $section->addTitle('Звіт: Активні накази', 1);

        $section->addText('Дата генерації: ' . date('d.m.Y H:i:s'), ['italic' => true], ['alignment' => 'right']);
        $section->addTextBreak();

        $table = $section->addTable('TableStyle');

        $table->addRow();
        $table->addCell(1000)->addText('ID', 'TableHeader', ['alignment' => 'center']);
        $table->addCell(5000)->addText('Назва наказу', 'TableHeader', ['alignment' => 'center']);
        $table->addCell(3000)->addText('Виконавець', 'TableHeader', ['alignment' => 'center']);
        $table->addCell(3000)->addText('Видавець', 'TableHeader', ['alignment' => 'center']);
        $table->addCell(2000)->addText('Дедлайн', 'TableHeader', ['alignment' => 'center']);

        foreach ($orders as $order) {
            $table->addRow();
            $table->addCell(1000)->addText($order['order_id'], null, ['alignment' => 'center']);
            $table->addCell(5000)->addText($order['order_name'], null, ['alignment' => 'left']);
            $table->addCell(3000)->addText($order['executor_name'], null, ['alignment' => 'left']);
            $table->addCell(3000)->addText($order['issuer_name'], null, ['alignment' => 'left']);

            $deadline = date('d.m.Y', strtotime($order['order_deadline']));
            $table->addCell(2000)->addText($deadline, null, ['alignment' => 'center']);
        }

        $this->downloadWord('Активні_накази');
    }

    public function exportOverdueOrders(array $orders)
    {
        $section = $this->phpWord->addSection();

        $section->addTitle('Звіт: Прострочені накази', 1);

        $section->addText('Дата генерації: ' . date('d.m.Y H:i:s'), ['italic' => true], ['alignment' => 'right']);
        $section->addTextBreak();

        $table = $section->addTable('TableStyle');

        $table->addRow();
        $table->addCell(800)->addText('ID', 'TableHeader', ['alignment' => 'center']);
        $table->addCell(4000)->addText('Назва наказу', 'TableHeader', ['alignment' => 'center']);
        $table->addCell(2500)->addText('Виконавець', 'TableHeader', ['alignment' => 'center']);
        $table->addCell(2500)->addText('Видавець', 'TableHeader', ['alignment' => 'center']);
        $table->addCell(1500)->addText('Дедлайн', 'TableHeader', ['alignment' => 'center']);
        $table->addCell(1500)->addText('Днів', 'TableHeader', ['alignment' => 'center']);

        foreach ($orders as $order) {
            $table->addRow();
            $table->addCell(800)->addText($order['order_id'], null, ['alignment' => 'center']);
            $table->addCell(4000)->addText($order['order_name'], null, ['alignment' => 'left']);
            $table->addCell(2500)->addText($order['executor_name'], null, ['alignment' => 'left']);
            $table->addCell(2500)->addText($order['issuer_name'], null, ['alignment' => 'left']);

            $deadline = date('d.m.Y', strtotime($order['order_deadline']));
            $table->addCell(1500)->addText($deadline, null, ['alignment' => 'center']);

            $days_overdue = ceil((time() - strtotime($order['order_deadline'])) / 86400);
            $table->addCell(1500)->addText($days_overdue, ['color' => 'FF0000'], ['alignment' => 'center']);
        }

        $this->downloadWord('Прострочені_накази');
    }

    public function exportDepartmentReport(array $department, array $executors, array $issuers, array $orders)
    {
        $section = $this->phpWord->addSection();

        $section->addTitle("Звіт по відділу: {$department['department_name']}", 1);

        $section->addText('Дата генерації: ' . date('d.m.Y H:i:s'), ['italic' => true], ['alignment' => 'right']);
        $section->addTextBreak();

        $section->addTitle('Інформація про відділ', 2);
        $section->addText("ID відділу: {$department['department_id']}");
        $section->addText("Назва відділу: {$department['department_name']}");
        $section->addTextBreak();

        $section->addTitle('Виконавці у відділі', 2);

        if (count($executors) > 0) {
            $table = $section->addTable('TableStyle');

            $table->addRow();
            $table->addCell(1000)->addText('ID', 'TableHeader', ['alignment' => 'center']);
            $table->addCell(4000)->addText('ПІБ', 'TableHeader', ['alignment' => 'center']);
            $table->addCell(3000)->addText('Посада', 'TableHeader', ['alignment' => 'center']);
            $table->addCell(3000)->addText('Контакт', 'TableHeader', ['alignment' => 'center']);

            foreach ($executors as $executor) {
                $table->addRow();
                $table->addCell(1000)->addText($executor['executor_id'], null, ['alignment' => 'center']);
                $table->addCell(4000)->addText($executor['executor_name'], null, ['alignment' => 'left']);
                $table->addCell(3000)->addText($executor['position_name'] ?? 'Не вказано', null, ['alignment' => 'left']);
                $table->addCell(3000)->addText($executor['executor_contact'] ?? 'Не вказано', null, ['alignment' => 'left']);
            }
        } else {
            $section->addText('Виконавців у відділі не знайдено', ['italic' => true]);
        }

        $section->addTextBreak();

        $section->addTitle('Видавці у відділі', 2);

        if (count($issuers) > 0) {
            $table = $section->addTable('TableStyle');

            $table->addRow();
            $table->addCell(1000)->addText('ID', 'TableHeader', ['alignment' => 'center']);
            $table->addCell(4000)->addText('ПІБ', 'TableHeader', ['alignment' => 'center']);
            $table->addCell(3000)->addText('Посада', 'TableHeader', ['alignment' => 'center']);
            $table->addCell(3000)->addText('Контакт', 'TableHeader', ['alignment' => 'center']);

            foreach ($issuers as $issuer) {
                $table->addRow();
                $table->addCell(1000)->addText($issuer['issuer_id'], null, ['alignment' => 'center']);
                $table->addCell(4000)->addText($issuer['issuer_name'], null, ['alignment' => 'left']);
                $table->addCell(3000)->addText($issuer['position_name'] ?? 'Не вказано', null, ['alignment' => 'left']);
                $table->addCell(3000)->addText($issuer['issuer_contact'] ?? 'Не вказано', null, ['alignment' => 'left']);
            }
        } else {
            $section->addText('Видавців у відділі не знайдено', ['italic' => true]);
        }

        $section->addTextBreak();

        $section->addTitle('Накази відділу', 2);

        if (count($orders) > 0) {
            $table = $section->addTable('TableStyle');

            $table->addRow();
            $table->addCell(800)->addText('ID', 'TableHeader', ['alignment' => 'center']);
            $table->addCell(5000)->addText('Назва наказу', 'TableHeader', ['alignment' => 'center']);
            $table->addCell(2000)->addText('Статус', 'TableHeader', ['alignment' => 'center']);
            $table->addCell(2000)->addText('Дедлайн', 'TableHeader', ['alignment' => 'center']);

            foreach ($orders as $order) {
                $table->addRow();
                $table->addCell(800)->addText($order['order_id'], null, ['alignment' => 'center']);
                $table->addCell(5000)->addText($order['order_name'], null, ['alignment' => 'left']);

                $status = 'Невідомо';
                $statusStyle = [];
                switch ($order['order_status'] ?? '') {
                    case 'active':
                        $status = 'Активний';
                        $statusStyle = ['color' => '996600'];
                        break;
                    case 'completed':
                        $status = 'Виконано';
                        $statusStyle = ['color' => '008800'];
                        break;
                    default:
                        $status = 'Невідомо';
                }
                $table->addCell(2000)->addText($status, $statusStyle, ['alignment' => 'center']);

                $deadline = date('d.m.Y', strtotime($order['order_deadline']));
                $table->addCell(2000)->addText($deadline, null, ['alignment' => 'center']);
            }
        } else {
            $section->addText('Наказів відділу не знайдено', ['italic' => true]);
        }

        $this->downloadWord("Звіт_відділ_{$department['department_id']}");
    }

    public function exportExecutorReport(array $executor, array $orders)
    {
        $section = $this->phpWord->addSection();

        $section->addTitle("Звіт по виконавцю: {$executor['executor_name']}", 1);

        $section->addText('Дата генерації: ' . date('d.m.Y H:i:s'), ['italic' => true], ['alignment' => 'right']);
        $section->addTextBreak();

        $section->addTitle('Інформація про виконавця', 2);
        $section->addText("ID виконавця: {$executor['executor_id']}");
        $section->addText("ПІБ: {$executor['executor_name']}");
        $section->addText("Контакт: " . ($executor['executor_contact'] ?? 'Не вказано'));
        $section->addText("Відділ: {$executor['department_name']}");
        $section->addText("Посада: {$executor['position_name']}");
        $section->addTextBreak();

        $section->addTitle('Накази виконавця', 2);

        if (count($orders) > 0) {
            $table = $section->addTable('TableStyle');

            $table->addRow();
            $table->addCell(800)->addText('ID', 'TableHeader', ['alignment' => 'center']);
            $table->addCell(5000)->addText('Назва наказу', 'TableHeader', ['alignment' => 'center']);
            $table->addCell(2500)->addText('Видавець', 'TableHeader', ['alignment' => 'center']);
            $table->addCell(1500)->addText('Статус', 'TableHeader', ['alignment' => 'center']);
            $table->addCell(2000)->addText('Дедлайн', 'TableHeader', ['alignment' => 'center']);

            foreach ($orders as $order) {
                $table->addRow();
                $table->addCell(800)->addText($order['order_id'], null, ['alignment' => 'center']);
                $table->addCell(5000)->addText($order['order_name'], null, ['alignment' => 'left']);
                $table->addCell(2500)->addText($order['issuer_name'], null, ['alignment' => 'left']);

                $status = 'Невідомо';
                $statusStyle = [];
                switch ($order['order_status'] ?? '') {
                    case 'active':
                        $status = 'Активний';
                        $statusStyle = ['color' => '996600'];
                        break;
                    case 'completed':
                        $status = 'Виконано';
                        $statusStyle = ['color' => '008800'];
                        break;
                    default:
                        $status = 'Невідомо';
                }
                $table->addCell(1500)->addText($status, $statusStyle, ['alignment' => 'center']);

                $deadline = date('d.m.Y', strtotime($order['order_deadline']));
                $table->addCell(2000)->addText($deadline, null, ['alignment' => 'center']);
            }

            $section->addTextBreak();
            $section->addTitle('Статистика', 2);

            $active_count = 0;
            $completed_count = 0;
            $overdue_count = 0;

            foreach ($orders as $order) {
                if ($order['order_status'] == 'completed') {
                    $completed_count++;
                } elseif (strtotime($order['order_deadline']) < time()) {
                    $overdue_count++;
                } else {
                    $active_count++;
                }
            }

            $section->addText("Активних наказів: {$active_count}", ['color' => '996600']);
            $section->addText("Виконаних наказів: {$completed_count}", ['color' => '008800']);
            $section->addText("Прострочених наказів: {$overdue_count}", ['color' => 'FF0000']);

        } else {
            $section->addText('Наказів виконавця не знайдено', ['italic' => true]);
        }

        $this->downloadWord("Звіт_виконавець_{$executor['executor_id']}");
    }

    private function downloadWord($filename)
    {
        header('Content-Type: application/vnd.openxmlformats-officedocument.wordprocessingml.document');
        header("Content-Disposition: attachment;filename=\"{$filename}.docx\"");
        header('Cache-Control: max-age=0');

        $writer = IOFactory::createWriter($this->phpWord, 'Word2007');

        $writer->save('php://output');
        exit;
    }
}

<?php

namespace App\Services;

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

class ExcelExport
{
    private $spreadsheet;
    private $sheet;

    public function __construct()
    {
        $this->spreadsheet = new Spreadsheet();
        $this->sheet = $this->spreadsheet->getActiveSheet();
    }

    public function exportActiveOrders(array $orders)
    {
        $this->sheet->setCellValue('A1', 'Звіт: Активні накази');
        $this->sheet->mergeCells('A1:E1');
        $this->formatTitle('A1:E1');

        $this->sheet->setCellValue('A2', 'Дата генерації: ' . date('d.m.Y H:i:s'));
        $this->sheet->mergeCells('A2:E2');
        $this->formatSubtitle('A2:E2');

        $this->sheet->setCellValue('A4', 'ID');
        $this->sheet->setCellValue('B4', 'Назва наказу');
        $this->sheet->setCellValue('C4', 'Виконавець');
        $this->sheet->setCellValue('D4', 'Видавець');
        $this->sheet->setCellValue('E4', 'Дедлайн');
        $this->formatHeader('A4:E4');

        $row = 5;
        foreach ($orders as $order) {
            $this->sheet->setCellValue("A{$row}", $order['order_id']);
            $this->sheet->setCellValue("B{$row}", $order['order_name']);
            $this->sheet->setCellValue("C{$row}", $order['executor_name']);
            $this->sheet->setCellValue("D{$row}", $order['issuer_name']);
            $this->sheet->setCellValue("E{$row}", date('d.m.Y', strtotime($order['order_deadline'])));

            $this->formatRow("A{$row}:E{$row}");
            $row++;
        }

        $this->sheet->getColumnDimension('A')->setAutoSize(true);
        $this->sheet->getColumnDimension('B')->setAutoSize(true);
        $this->sheet->getColumnDimension('C')->setAutoSize(true);
        $this->sheet->getColumnDimension('D')->setAutoSize(true);
        $this->sheet->getColumnDimension('E')->setAutoSize(true);

        $this->downloadExcel('Активні_накази');
    }

    public function exportOverdueOrders(array $orders)
    {
        $this->sheet->setCellValue('A1', 'Звіт: Прострочені накази');
        $this->sheet->mergeCells('A1:F1');
        $this->formatTitle('A1:F1');

        $this->sheet->setCellValue('A2', 'Дата генерації: ' . date('d.m.Y H:i:s'));
        $this->sheet->mergeCells('A2:F2');
        $this->formatSubtitle('A2:F2');

        $this->sheet->setCellValue('A4', 'ID');
        $this->sheet->setCellValue('B4', 'Назва наказу');
        $this->sheet->setCellValue('C4', 'Виконавець');
        $this->sheet->setCellValue('D4', 'Видавець');
        $this->sheet->setCellValue('E4', 'Дедлайн');
        $this->sheet->setCellValue('F4', 'Днів прострочено');
        $this->formatHeader('A4:F4');

        $row = 5;
        foreach ($orders as $order) {
            $deadline = strtotime($order['order_deadline']);
            $this->sheet->setCellValue("A{$row}", $order['order_id']);
            $this->sheet->setCellValue("B{$row}", $order['order_name']);
            $this->sheet->setCellValue("C{$row}", $order['executor_name']);
            $this->sheet->setCellValue("D{$row}", $order['issuer_name']);
            $this->sheet->setCellValue("E{$row}", date('d.m.Y', $deadline));

            $daysOverdue = ceil((time() - $deadline) / (60 * 60 * 24));
            $this->sheet->setCellValue("F{$row}", $daysOverdue);

            $this->formatRow("A{$row}:F{$row}");
            $row++;
        }

        foreach (range('A', 'F') as $col) {
            $this->sheet->getColumnDimension($col)->setAutoSize(true);
        }

        $this->downloadExcel('Прострочені_накази');
    }

    public function exportDepartmentReport(array $department, array $executors, array $issuers, array $orders)
    {
        $this->sheet->setCellValue('A1', "Звіт по відділу: {$department['department_name']}");
        $this->sheet->mergeCells('A1:F1');
        $this->formatTitle('A1:F1');

        $this->sheet->setCellValue('A2', 'Дата генерації: ' . date('d.m.Y H:i:s'));
        $this->sheet->mergeCells('A2:F2');
        $this->formatSubtitle('A2:F2');

        $this->sheet->setCellValue('A4', 'ID відділу:');
        $this->sheet->setCellValue('B4', $department['department_id']);
        $this->sheet->setCellValue('A5', 'Назва відділу:');
        $this->sheet->setCellValue('B5', $department['department_name']);

        $this->sheet->setCellValue('A7', 'Виконавці у відділі:');
        $this->sheet->mergeCells('A7:F7');
        $this->formatSectionHeader('A7:F7');

        $this->sheet->setCellValue('A8', 'ID');
        $this->sheet->setCellValue('B8', 'ПІБ');
        $this->sheet->setCellValue('C8', 'Посада');
        $this->sheet->setCellValue('D8', 'Контакт');
        $this->formatHeader('A8:D8');

        $row = 9;
        foreach ($executors as $executor) {
            $this->sheet->setCellValue("A{$row}", $executor['executor_id']);
            $this->sheet->setCellValue("B{$row}", $executor['executor_name']);
            $this->sheet->setCellValue("C{$row}", $executor['position_name'] ?? 'Не вказано');
            $this->sheet->setCellValue("D{$row}", $executor['executor_contact'] ?? 'Не вказано');
            $this->formatRow("A{$row}:D{$row}");
            $row++;
        }

        $row += 2;
        $this->sheet->setCellValue("A{$row}", 'Видавці у відділі:');
        $this->sheet->mergeCells("A{$row}:F{$row}");
        $this->formatSectionHeader("A{$row}:F{$row}");
        $row++;

        $this->sheet->setCellValue("A{$row}", 'ID');
        $this->sheet->setCellValue("B{$row}", 'ПІБ');
        $this->sheet->setCellValue("C{$row}", 'Посада');
        $this->sheet->setCellValue("D{$row}", 'Контакт');
        $this->formatHeader("A{$row}:D{$row}");
        $row++;

        foreach ($issuers as $issuer) {
            $this->sheet->setCellValue("A{$row}", $issuer['issuer_id']);
            $this->sheet->setCellValue("B{$row}", $issuer['issuer_name']);
            $this->sheet->setCellValue("C{$row}", $issuer['position_name'] ?? 'Не вказано');
            $this->sheet->setCellValue("D{$row}", $issuer['issuer_contact'] ?? 'Не вказано');
            $this->formatRow("A{$row}:D{$row}");
            $row++;
        }

        $row += 2;
        $this->sheet->setCellValue("A{$row}", 'Накази відділу:');
        $this->sheet->mergeCells("A{$row}:F{$row}");
        $this->formatSectionHeader("A{$row}:F{$row}");
        $row++;

        $this->sheet->setCellValue("A{$row}", 'ID');
        $this->sheet->setCellValue("B{$row}", 'Назва наказу');
        $this->sheet->setCellValue("C{$row}", 'Виконавець');
        $this->sheet->setCellValue("D{$row}", 'Видавець');
        $this->sheet->setCellValue("E{$row}", 'Дедлайн');
        $this->sheet->setCellValue("F{$row}", 'Статус');
        $this->formatHeader("A{$row}:F{$row}");
        $row++;

        foreach ($orders as $order) {
            $this->sheet->setCellValue("A{$row}", $order['order_id']);
            $this->sheet->setCellValue("B{$row}", $order['order_name']);
            $this->sheet->setCellValue("C{$row}", $order['executor_name']);
            $this->sheet->setCellValue("D{$row}", $order['issuer_name']);
            $this->sheet->setCellValue("E{$row}", date('d.m.Y', strtotime($order['order_deadline'])));

            $status = '';
            switch ($order['order_status']) {
                case 'completed':
                    $status = 'Виконано';
                    break;
                case 'active':
                    $status = 'Активний';
                    break;
                case 'overdue':
                    $status = 'Прострочено';
                    break;
                default:
                    $status = $order['order_status'];
            }

            $this->sheet->setCellValue("F{$row}", $status);
            $this->formatRow("A{$row}:F{$row}");
            $row++;
        }

        foreach (range('A', 'F') as $col) {
            $this->sheet->getColumnDimension($col)->setAutoSize(true);
        }

        $this->downloadExcel("Звіт_відділ_{$department['department_id']}");
    }

    public function exportExecutorReport(array $executor, array $orders)
    {
        $this->sheet->setCellValue('A1', "Звіт по виконавцю: {$executor['executor_name']}");
        $this->sheet->mergeCells('A1:F1');
        $this->formatTitle('A1:F1');

        $this->sheet->setCellValue('A2', 'Дата генерації: ' . date('d.m.Y H:i:s'));
        $this->sheet->mergeCells('A2:F2');
        $this->formatSubtitle('A2:F2');

        $this->sheet->setCellValue('A4', 'ID виконавця:');
        $this->sheet->setCellValue('B4', $executor['executor_id']);

        $this->sheet->setCellValue('A5', 'ПІБ:');
        $this->sheet->setCellValue('B5', $executor['executor_name']);

        $this->sheet->setCellValue('A6', 'Контакт:');
        $this->sheet->setCellValue('B6', $executor['executor_contact'] ?? 'Не вказано');

        $this->sheet->setCellValue('A7', 'Відділ:');
        $this->sheet->setCellValue('B7', $executor['department_name']);

        $this->sheet->setCellValue('A8', 'Посада:');
        $this->sheet->setCellValue('B8', $executor['position_name']);

        $this->sheet->setCellValue('A10', 'Накази виконавця:');
        $this->sheet->mergeCells('A10:F10');
        $this->formatSectionHeader('A10:F10');

        $this->sheet->setCellValue('A11', 'ID');
        $this->sheet->setCellValue('B11', 'Назва наказу');
        $this->sheet->setCellValue('C11', 'Видавець');
        $this->sheet->setCellValue('D11', 'Дата видачі');
        $this->sheet->setCellValue('E11', 'Дедлайн');
        $this->sheet->setCellValue('F11', 'Статус');
        $this->formatHeader('A11:F11');

        $row = 12;
        foreach ($orders as $order) {
            $this->sheet->setCellValue("A{$row}", $order['order_id']);
            $this->sheet->setCellValue("B{$row}", $order['order_name']);
            $this->sheet->setCellValue("C{$row}", $order['issuer_name']);
            $this->sheet->setCellValue("D{$row}", date('d.m.Y', strtotime($order['order_date_issued'])));
            $this->sheet->setCellValue("E{$row}", date('d.m.Y', strtotime($order['order_deadline'])));

            $status = '';
            switch ($order['order_status']) {
                case 'completed':
                    $status = 'Виконано';
                    break;
                case 'active':
                    $status = 'Активний';
                    break;
                case 'overdue':
                    $status = 'Прострочено';
                    break;
                default:
                    $status = $order['order_status'];
            }

            $this->sheet->setCellValue("F{$row}", $status);
            $this->formatRow("A{$row}:F{$row}");
            $row++;
        }

        foreach (range('A', 'F') as $col) {
            $this->sheet->getColumnDimension($col)->setAutoSize(true);
        }

        $this->downloadExcel("Звіт_виконавець_{$executor['executor_id']}");
    }

    private function formatTitle($range)
    {
        $this->sheet->getStyle($range)->applyFromArray([
            'font' => [
                'bold' => true,
                'size' => 16,
                'color' => [
                    'rgb' => 'FFFFFF',
                ],
            ],
            'alignment' => [
                'horizontal' => Alignment::HORIZONTAL_CENTER,
                'vertical' => Alignment::VERTICAL_CENTER,
            ],
            'fill' => [
                'fillType' => Fill::FILL_SOLID,
                'startColor' => [
                    'rgb' => '3F51B5',
                ],
            ],
        ]);
    }

    private function formatSubtitle($range)
    {
        $this->sheet->getStyle($range)->applyFromArray([
            'font' => [
                'italic' => true,
            ],
            'alignment' => [
                'horizontal' => Alignment::HORIZONTAL_RIGHT,
            ],
        ]);
    }

    private function formatSectionHeader($range)
    {
        $this->sheet->getStyle($range)->applyFromArray([
            'font' => [
                'bold' => true,
                'size' => 12,
            ],
            'fill' => [
                'fillType' => Fill::FILL_SOLID,
                'startColor' => [
                    'rgb' => 'B2EBF2',
                ],
            ],
            'borders' => [
                'outline' => [
                    'borderStyle' => Border::BORDER_THIN,
                ],
            ],
        ]);
    }

    private function formatHeader($range)
    {
        $this->sheet->getStyle($range)->applyFromArray([
            'font' => [
                'bold' => true,
            ],
            'alignment' => [
                'horizontal' => Alignment::HORIZONTAL_CENTER,
            ],
            'fill' => [
                'fillType' => Fill::FILL_SOLID,
                'startColor' => [
                    'rgb' => 'E3F2FD',
                ],
            ],
            'borders' => [
                'allBorders' => [
                    'borderStyle' => Border::BORDER_THIN,
                ],
            ],
        ]);
    }

    private function formatRow($range)
    {
        $this->sheet->getStyle($range)->applyFromArray([
            'borders' => [
                'allBorders' => [
                    'borderStyle' => Border::BORDER_THIN,
                ],
            ],
            'alignment' => [
                'vertical' => Alignment::VERTICAL_CENTER,
            ],
        ]);
    }

    private function downloadExcel($filename)
    {
        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        header("Content-Disposition: attachment;filename=\"{$filename}.xlsx\"");
        header('Cache-Control: max-age=0');

        $writer = new Xlsx($this->spreadsheet);
        $writer->save('php://output');
    }
}

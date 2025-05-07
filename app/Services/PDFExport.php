<?php

namespace App\Services;

class CustomPDF extends \TCPDF
{
    public function Footer()
    {
        $this->SetY(-15);
        $this->SetFont('dejavusans', 'I', 8);
        $this->Cell(0, 10, "Сторінка {$this->getAliasNumPage()} з {$this->getAliasNbPages()}", 0, false, 'C');
    }
}

class PDFExport
{
    private $pdf;

    public function __construct()
    {
        if (!class_exists('\TCPDF')) {
            throw new \Exception('TCPDF library not found. Please install it using Composer.');
        }

        $this->pdf = new CustomPDF('P', 'mm', 'A4', true, 'UTF-8');

        $this->pdf->SetCreator('ControlEO');
        $this->pdf->SetAuthor('ControlEO System');
        $this->pdf->SetTitle('Звіт');

        $this->pdf->SetPrintHeader(false);
        $this->pdf->SetPrintFooter(true);

        $this->pdf->SetMargins(15, 15, 15);

        $this->pdf->SetAutoPageBreak(true, 25);

        $this->pdf->SetFont('dejavusans', '', 10);
    }

    public function exportActiveOrders(array $orders)
    {
        $this->pdf->AddPage();

        $this->pdf->SetFont('dejavusans', 'B', 16);
        $this->pdf->Cell(0, 10, 'Звіт: Активні накази', 0, 1, 'C');

        $this->pdf->SetFont('dejavusans', 'I', 10);
        $this->pdf->Cell(0, 10, "Дата генерації: " . date('d.m.Y H:i:s'), 0, 1, 'R');

        $this->pdf->SetFont('dejavusans', '', 10);
        $this->pdf->Ln(5);

        $this->pdf->SetFillColor(230, 230, 230);
        $this->pdf->SetFont('dejavusans', 'B', 10);

        $w = [15, 75, 40, 40, 25];

        $this->pdf->Cell($w[0], 7, 'ID', 1, 0, 'C', true);
        $this->pdf->Cell($w[1], 7, 'Назва наказу', 1, 0, 'C', true);
        $this->pdf->Cell($w[2], 7, 'Виконавець', 1, 0, 'C', true);
        $this->pdf->Cell($w[3], 7, 'Видавець', 1, 0, 'C', true);
        $this->pdf->Cell($w[4], 7, 'Дедлайн', 1, 1, 'C', true);

        $this->pdf->SetFont('dejavusans', '', 9);
        $this->pdf->SetFillColor(255, 255, 255);

        foreach ($orders as $order) {
            if ($this->pdf->GetY() > 250) {
                $this->pdf->AddPage();

                $this->pdf->SetFillColor(230, 230, 230);
                $this->pdf->SetFont('dejavusans', 'B', 10);
                $this->pdf->Cell($w[0], 7, 'ID', 1, 0, 'C', true);
                $this->pdf->Cell($w[1], 7, 'Назва наказу', 1, 0, 'C', true);
                $this->pdf->Cell($w[2], 7, 'Виконавець', 1, 0, 'C', true);
                $this->pdf->Cell($w[3], 7, 'Видавець', 1, 0, 'C', true);
                $this->pdf->Cell($w[4], 7, 'Дедлайн', 1, 1, 'C', true);
                $this->pdf->SetFont('dejavusans', '', 9);
                $this->pdf->SetFillColor(255, 255, 255);
            }

            $this->pdf->Cell($w[0], 6, $order['order_id'], 1, 0, 'C');
            $this->pdf->Cell($w[1], 6, $this->truncateText($order['order_name'], 40), 1, 0, 'L');
            $this->pdf->Cell($w[2], 6, $this->truncateText($order['executor_name'], 20), 1, 0, 'L');
            $this->pdf->Cell($w[3], 6, $this->truncateText($order['issuer_name'], 20), 1, 0, 'L');

            $deadline = date('d.m.Y', strtotime($order['order_deadline']));
            $this->pdf->Cell($w[4], 6, $deadline, 1, 1, 'C');
        }

        $this->downloadPdf('Активні_накази');
    }

    public function exportOverdueOrders(array $orders)
    {
        $this->pdf->AddPage();

        $this->pdf->SetFont('dejavusans', 'B', 16);
        $this->pdf->Cell(0, 10, 'Звіт: Прострочені накази', 0, 1, 'C');

        $this->pdf->SetFont('dejavusans', 'I', 10);
        $this->pdf->Cell(0, 10, "Дата генерації: " . date('d.m.Y H:i:s'), 0, 1, 'R');

        $this->pdf->SetFont('dejavusans', '', 10);
        $this->pdf->Ln(5);

        $this->pdf->SetFillColor(230, 230, 230);
        $this->pdf->SetFont('dejavusans', 'B', 10);

        $w = [12, 65, 35, 35, 25, 18];

        $this->pdf->Cell($w[0], 7, 'ID', 1, 0, 'C', true);
        $this->pdf->Cell($w[1], 7, 'Назва наказу', 1, 0, 'C', true);
        $this->pdf->Cell($w[2], 7, 'Виконавець', 1, 0, 'C', true);
        $this->pdf->Cell($w[3], 7, 'Видавець', 1, 0, 'C', true);
        $this->pdf->Cell($w[4], 7, 'Дедлайн', 1, 0, 'C', true);
        $this->pdf->Cell($w[5], 7, 'Днів', 1, 1, 'C', true);

        $this->pdf->SetFont('dejavusans', '', 9);
        $this->pdf->SetFillColor(255, 255, 255);

        foreach ($orders as $order) {
            if ($this->pdf->GetY() > 250) {
                $this->pdf->AddPage();

                $this->pdf->SetFillColor(230, 230, 230);
                $this->pdf->SetFont('dejavusans', 'B', 10);
                $this->pdf->Cell($w[0], 7, 'ID', 1, 0, 'C', true);
                $this->pdf->Cell($w[1], 7, 'Назва наказу', 1, 0, 'C', true);
                $this->pdf->Cell($w[2], 7, 'Виконавець', 1, 0, 'C', true);
                $this->pdf->Cell($w[3], 7, 'Видавець', 1, 0, 'C', true);
                $this->pdf->Cell($w[4], 7, 'Дедлайн', 1, 0, 'C', true);
                $this->pdf->Cell($w[5], 7, 'Днів', 1, 1, 'C', true);
                $this->pdf->SetFont('dejavusans', '', 9);
                $this->pdf->SetFillColor(255, 255, 255);
            }

            $days_overdue = ceil((time() - strtotime($order['order_deadline'])) / 86400);

            $this->pdf->Cell($w[0], 6, $order['order_id'], 1, 0, 'C');
            $this->pdf->Cell($w[1], 6, $this->truncateText($order['order_name'], 35), 1, 0, 'L');
            $this->pdf->Cell($w[2], 6, $this->truncateText($order['executor_name'], 18), 1, 0, 'L');
            $this->pdf->Cell($w[3], 6, $this->truncateText($order['issuer_name'], 18), 1, 0, 'L');

            $deadline = date('d.m.Y', strtotime($order['order_deadline']));
            $this->pdf->Cell($w[4], 6, $deadline, 1, 0, 'C');

            $this->pdf->SetTextColor(255, 0, 0);
            $this->pdf->Cell($w[5], 6, $days_overdue, 1, 1, 'C');
            $this->pdf->SetTextColor(0, 0, 0);
        }

        $this->downloadPdf('Прострочені_накази');
    }

    public function exportDepartmentReport(array $department, array $executors, array $issuers, array $orders)
    {
        $this->pdf->AddPage();

        $this->pdf->SetFont('dejavusans', 'B', 16);
        $this->pdf->Cell(0, 10, "Звіт по відділу: {$department['department_name']}", 0, 1, 'C');

        $this->pdf->SetFont('dejavusans', 'I', 10);
        $this->pdf->Cell(0, 10, "Дата генерації: " . date('d.m.Y H:i:s'), 0, 1, 'R');

        $this->pdf->SetFont('dejavusans', 'B', 12);
        $this->pdf->Cell(0, 10, 'Інформація про відділ', 0, 1, 'L');

        $this->pdf->SetFont('dejavusans', '', 10);
        $this->pdf->Cell(40, 6, 'ID відділу:', 0, 0);
        $this->pdf->Cell(0, 6, $department['department_id'], 0, 1);
        $this->pdf->Cell(40, 6, 'Назва відділу:', 0, 0);
        $this->pdf->Cell(0, 6, $department['department_name'], 0, 1);

        $this->pdf->Ln(5);

        $this->pdf->SetFont('dejavusans', 'B', 12);
        $this->pdf->Cell(0, 10, 'Виконавці у відділі', 0, 1, 'L');

        if (count($executors) > 0) {
            $this->pdf->SetFillColor(230, 230, 230);
            $this->pdf->SetFont('dejavusans', 'B', 10);

            $w = [15, 80, 50, 45];

            $this->pdf->Cell($w[0], 7, 'ID', 1, 0, 'C', true);
            $this->pdf->Cell($w[1], 7, 'ПІБ', 1, 0, 'C', true);
            $this->pdf->Cell($w[2], 7, 'Посада', 1, 0, 'C', true);
            $this->pdf->Cell($w[3], 7, 'Контакт', 1, 1, 'C', true);

            $this->pdf->SetFont('dejavusans', '', 9);
            $this->pdf->SetFillColor(255, 255, 255);

            foreach ($executors as $executor) {
                $this->pdf->Cell($w[0], 6, $executor['executor_id'], 1, 0, 'C');
                $this->pdf->Cell($w[1], 6, $executor['executor_name'], 1, 0, 'L');
                $this->pdf->Cell($w[2], 6, $executor['position_name'] ?? 'Не вказано', 1, 0, 'L');
                $this->pdf->Cell($w[3], 6, $executor['executor_contact'] ?? 'Не вказано', 1, 1, 'L');
            }
        } else {
            $this->pdf->SetFont('dejavusans', 'I', 10);
            $this->pdf->Cell(0, 10, 'Виконавців у відділі не знайдено', 0, 1, 'L');
        }

        $this->pdf->Ln(5);

        if ($this->pdf->GetY() > 200) {
            $this->pdf->AddPage();
        }

        $this->pdf->SetFont('dejavusans', 'B', 12);
        $this->pdf->Cell(0, 10, 'Видавці у відділі', 0, 1, 'L');

        if (count($issuers) > 0) {
            $this->pdf->SetFillColor(230, 230, 230);
            $this->pdf->SetFont('dejavusans', 'B', 10);

            $w = [15, 80, 50, 45];

            $this->pdf->Cell($w[0], 7, 'ID', 1, 0, 'C', true);
            $this->pdf->Cell($w[1], 7, 'ПІБ', 1, 0, 'C', true);
            $this->pdf->Cell($w[2], 7, 'Посада', 1, 0, 'C', true);
            $this->pdf->Cell($w[3], 7, 'Контакт', 1, 1, 'C', true);

            $this->pdf->SetFont('dejavusans', '', 9);
            $this->pdf->SetFillColor(255, 255, 255);

            foreach ($issuers as $issuer) {
                $this->pdf->Cell($w[0], 6, $issuer['issuer_id'], 1, 0, 'C');
                $this->pdf->Cell($w[1], 6, $issuer['issuer_name'], 1, 0, 'L');
                $this->pdf->Cell($w[2], 6, $issuer['position_name'] ?? 'Не вказано', 1, 0, 'L');
                $this->pdf->Cell($w[3], 6, $issuer['issuer_contact'] ?? 'Не вказано', 1, 1, 'L');
            }
        } else {
            $this->pdf->SetFont('dejavusans', 'I', 10);
            $this->pdf->Cell(0, 10, 'Видавців у відділі не знайдено', 0, 1, 'L');
        }

        $this->pdf->Ln(5);

        if ($this->pdf->GetY() > 180) {
            $this->pdf->AddPage();
        }

        $this->pdf->SetFont('dejavusans', 'B', 12);
        $this->pdf->Cell(0, 10, 'Накази відділу', 0, 1, 'L');

        if (count($orders) > 0) {
            $this->pdf->SetFillColor(230, 230, 230);
            $this->pdf->SetFont('dejavusans', 'B', 10);

            $w = [10, 95, 40, 45];

            $this->pdf->Cell($w[0], 7, 'ID', 1, 0, 'C', true);
            $this->pdf->Cell($w[1], 7, 'Назва наказу', 1, 0, 'C', true);
            $this->pdf->Cell($w[2], 7, 'Статус', 1, 0, 'C', true);
            $this->pdf->Cell($w[3], 7, 'Дедлайн', 1, 1, 'C', true);

            $this->pdf->SetFont('dejavusans', '', 9);
            $this->pdf->SetFillColor(255, 255, 255);

            foreach ($orders as $order) {
                $this->pdf->Cell($w[0], 6, $order['order_id'], 1, 0, 'C');
                $this->pdf->Cell($w[1], 6, $this->truncateText($order['order_name'], 45), 1, 0, 'L');

                $status = 'Невідомо';
                switch ($order['order_status'] ?? '') {
                    case 'active':
                        $status = 'Активний';
                        break;
                    case 'completed':
                        $status = 'Виконано';
                        break;
                    default:
                        $status = 'Невідомо';
                }
                $this->pdf->Cell($w[2], 6, $status, 1, 0, 'C');

                $deadline = date('d.m.Y', strtotime($order['order_deadline']));
                $this->pdf->Cell($w[3], 6, $deadline, 1, 1, 'C');
            }
        } else {
            $this->pdf->SetFont('dejavusans', 'I', 10);
            $this->pdf->Cell(0, 10, 'Наказів відділу не знайдено', 0, 1, 'L');
        }

        $this->downloadPdf("Звіт_відділ_{$department['department_id']}");
    }

    public function exportExecutorReport(array $executor, array $orders)
    {
        $this->pdf->AddPage();

        $this->pdf->SetFont('dejavusans', 'B', 16);
        $this->pdf->Cell(0, 10, "Звіт по виконавцю: {$executor['executor_name']}", 0, 1, 'C');

        $this->pdf->SetFont('dejavusans', 'I', 10);
        $this->pdf->Cell(0, 10, "Дата генерації: " . date('d.m.Y H:i:s'), 0, 1, 'R');

        $this->pdf->SetFont('dejavusans', 'B', 12);
        $this->pdf->Cell(0, 10, 'Інформація про виконавця', 0, 1, 'L');

        $this->pdf->SetFont('dejavusans', '', 10);
        $this->pdf->Cell(40, 6, 'ID виконавця:', 0, 0);
        $this->pdf->Cell(0, 6, $executor['executor_id'], 0, 1);

        $this->pdf->Cell(40, 6, 'ПІБ:', 0, 0);
        $this->pdf->Cell(0, 6, $executor['executor_name'], 0, 1);

        $this->pdf->Cell(40, 6, 'Контакт:', 0, 0);
        $this->pdf->Cell(0, 6, $executor['executor_contact'] ?? 'Не вказано', 0, 1);

        $this->pdf->Cell(40, 6, 'Відділ:', 0, 0);
        $this->pdf->Cell(0, 6, $executor['department_name'], 0, 1);

        $this->pdf->Cell(40, 6, 'Посада:', 0, 0);
        $this->pdf->Cell(0, 6, $executor['position_name'], 0, 1);

        $this->pdf->Ln(5);

        $this->pdf->SetFont('dejavusans', 'B', 12);
        $this->pdf->Cell(0, 10, 'Накази виконавця', 0, 1, 'L');

        if (count($orders) > 0) {
            $this->pdf->SetFillColor(230, 230, 230);
            $this->pdf->SetFont('dejavusans', 'B', 10);

            $w = [10, 85, 35, 30, 30];

            $this->pdf->Cell($w[0], 7, 'ID', 1, 0, 'C', true);
            $this->pdf->Cell($w[1], 7, 'Назва наказу', 1, 0, 'C', true);
            $this->pdf->Cell($w[2], 7, 'Видавець', 1, 0, 'C', true);
            $this->pdf->Cell($w[3], 7, 'Статус', 1, 0, 'C', true);
            $this->pdf->Cell($w[4], 7, 'Дедлайн', 1, 1, 'C', true);

            $this->pdf->SetFont('dejavusans', '', 9);
            $this->pdf->SetFillColor(255, 255, 255);

            foreach ($orders as $order) {
                if ($this->pdf->GetY() > 250) {
                    $this->pdf->AddPage();

                    $this->pdf->SetFillColor(230, 230, 230);
                    $this->pdf->SetFont('dejavusans', 'B', 10);
                    $this->pdf->Cell($w[0], 7, 'ID', 1, 0, 'C', true);
                    $this->pdf->Cell($w[1], 7, 'Назва наказу', 1, 0, 'C', true);
                    $this->pdf->Cell($w[2], 7, 'Видавець', 1, 0, 'C', true);
                    $this->pdf->Cell($w[3], 7, 'Статус', 1, 0, 'C', true);
                    $this->pdf->Cell($w[4], 7, 'Дедлайн', 1, 1, 'C', true);
                    $this->pdf->SetFont('dejavusans', '', 9);
                    $this->pdf->SetFillColor(255, 255, 255);
                }

                $this->pdf->Cell($w[0], 6, $order['order_id'], 1, 0, 'C');
                $this->pdf->Cell($w[1], 6, $this->truncateText($order['order_name'], 40), 1, 0, 'L');
                $this->pdf->Cell($w[2], 6, $this->truncateText($order['issuer_name'], 18), 1, 0, 'L');

                $status = 'Невідомо';
                switch ($order['order_status'] ?? '') {
                    case 'active':
                        $status = 'Активний';
                        break;
                    case 'completed':
                        $status = 'Виконано';
                        break;
                    default:
                        $status = 'Невідомо';
                }
                $this->pdf->Cell($w[3], 6, $status, 1, 0, 'C');

                $deadline = date('d.m.Y', strtotime($order['order_deadline']));
                $this->pdf->Cell($w[4], 6, $deadline, 1, 1, 'C');
            }
        } else {
            $this->pdf->SetFont('dejavusans', 'I', 10);
            $this->pdf->Cell(0, 10, 'Наказів виконавця не знайдено', 0, 1, 'L');
        }

        $this->downloadPdf("Звіт_виконавець_{$executor['executor_id']}");
    }

    private function truncateText($text, $maxLength)
    {
        if (mb_strlen($text) > $maxLength) {
            return mb_substr($text, 0, $maxLength) . '...';
        }
        return $text;
    }

    private function downloadPdf($filename)
    {
        $this->pdf->setFooterMargin(15);
        $this->pdf->setFooterFont(['dejavusans', 'I', 8]);

        $this->pdf->Output("{$filename}.pdf", 'D');
    }
}

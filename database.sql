CREATE DATABASE IF NOT EXISTS `ControlEO`;

CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON ControlEO.* TO 'root'@'localhost';
FLUSH PRIVILEGES;

USE `ControlEO`;

CREATE TABLE IF NOT EXISTS Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL UNIQUE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Positions (
    position_id INT AUTO_INCREMENT PRIMARY KEY,
    position_name VARCHAR(255) NOT NULL UNIQUE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Executors (
    executor_id INT AUTO_INCREMENT PRIMARY KEY,
    executor_name VARCHAR(255) NOT NULL,
    executor_contact VARCHAR(255),
    department_id INT,
    position_id INT,
    executor_notes TEXT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (position_id) REFERENCES Positions(position_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Issuers (
    issuer_id INT AUTO_INCREMENT PRIMARY KEY,
    issuer_name VARCHAR(255) NOT NULL,
    issuer_contact VARCHAR(255),
    department_id INT,
    position_id INT,
    issuer_notes TEXT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (position_id) REFERENCES Positions(position_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_name VARCHAR(255) NOT NULL,
    order_content TEXT,
    order_date_issued DATE NOT NULL,
    order_deadline DATE NOT NULL,
    order_date_completed DATE DEFAULT NULL,
    executor_id INT NOT NULL,
    issuer_id INT NOT NULL,
    order_status ENUM('active', 'completed', 'overdue', 'cancelled', 'failed') DEFAULT 'active',
    order_priority ENUM('high', 'medium', 'low') DEFAULT 'medium',
    order_creation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (executor_id) REFERENCES Executors (executor_id),
    FOREIGN KEY (issuer_id) REFERENCES Issuers (issuer_id)
) ENGINE = InnoDB;

CREATE INDEX idx_orders_executor_id ON Orders (executor_id);
CREATE INDEX idx_orders_issuer_id ON Orders (issuer_id);
CREATE INDEX idx_orders_date_issued ON Orders (order_date_issued);
CREATE INDEX idx_orders_deadline ON Orders (order_deadline);

DROP TRIGGER IF EXISTS trg_auto_update_status;
DELIMITER $$
CREATE TRIGGER trg_auto_update_status
BEFORE UPDATE ON Orders
FOR EACH ROW
BEGIN
    IF NEW.order_date_completed IS NULL AND NEW.order_status NOT IN ('cancelled', 'failed') AND NEW.order_deadline < CURDATE() THEN
        SET NEW.order_status = 'overdue';
    ELSEIF NEW.order_date_completed IS NOT NULL AND NEW.order_status != 'completed' AND NEW.order_status != 'failed' AND NEW.order_status != 'cancelled' THEN
        SET NEW.order_status = 'completed';
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE GetOrdersByDate(IN target_date DATE)
BEGIN
    SELECT * FROM Orders
    WHERE order_date_issued = target_date;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE PrintDailyOrders()
BEGIN
    SELECT * FROM Orders
    WHERE order_deadline = CURDATE();
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE GetOrdersByPeriod(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT * FROM Orders
    WHERE order_date_issued BETWEEN start_date AND end_date;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE GetOverdueOrders()
BEGIN
    SELECT o.*, e.executor_name, i.issuer_name 
    FROM Orders o
    JOIN Executors e ON o.executor_id = e.executor_id
    JOIN Issuers i ON o.issuer_id = i.issuer_id
    WHERE o.order_deadline < CURDATE() AND o.order_date_completed IS NULL AND o.order_status NOT IN ('cancelled', 'failed');
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE GetOrdersByExecutor(IN exec_id INT)
BEGIN
    SELECT o.*, i.issuer_name
    FROM Orders o
    JOIN Issuers i ON o.issuer_id = i.issuer_id
    WHERE o.executor_id = exec_id;
END$$
DELIMITER ;
CREATE INDEX idx_orders_status ON Orders (order_status);
CREATE INDEX idx_orders_date_completed ON Orders (order_date_completed);
CREATE INDEX idx_orders_priority ON Orders (order_priority);
CREATE INDEX idx_executors_department ON Executors (department_id);
CREATE INDEX idx_executors_position ON Executors (position_id);
CREATE INDEX idx_issuers_department ON Issuers (department_id);
CREATE INDEX idx_issuers_position ON Issuers (position_id);
CREATE INDEX idx_departments_name ON Departments (department_name);
CREATE INDEX idx_positions_name ON Positions (position_name);
CREATE INDEX idx_executors_name ON Executors (executor_name);
CREATE INDEX idx_issuers_name ON Issuers (issuer_name);
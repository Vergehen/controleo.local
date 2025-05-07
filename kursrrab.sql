USE `ControlEO`;

INSERT INTO
    Departments (department_name)
VALUES
    ('IT Department'),
    ('Human Resources'),
    ('Marketing'),
    ('Finance'),
    ('Operations'),
    ('Customer Support'),
    ('Research & Development'),
    ('Sales'),
    ('Legal'),
    ('Quality Assurance'),
    ('Product Management'),
    ('Administration');

INSERT INTO
    Positions (position_name)
VALUES
    ('Manager'),
    ('Specialist'),
    ('Director'),
    ('Coordinator'),
    ('Supervisor'),
    ('Assistant'),
    ('Analyst'),
    ('Team Lead'),
    ('Executive'),
    ('Junior Specialist'),
    ('Senior Specialist'),
    ('Consultant');

INSERT INTO
    Executors (
        executor_name,
        executor_contact,
        department_id,
        position_id
    )
VALUES
    ('John Doe', 'john.doe@company.com', 1, 1),
    ('Jane Smith', 'jane.smith@company.com', 2, 2),
    (
        'Michael Brown',
        'michael.brown@company.com',
        3,
        3
    ),
    ('Emma Wilson', 'emma.wilson@company.com', 4, 4),
    ('David Lee', 'david.lee@company.com', 5, 5),
    ('Sarah Chen', 'sarah.chen@company.com', 6, 6),
    (
        'Thomas Wright',
        'thomas.wright@company.com',
        7,
        7
    ),
    ('Lisa Garcia', 'lisa.garcia@company.com', 8, 8),
    (
        'Kevin Robinson',
        'kevin.robinson@company.com',
        9,
        9
    ),
    (
        'Amanda Taylor',
        'amanda.taylor@company.com',
        10,
        10
    ),
    (
        'Richard Martin',
        'richard.martin@company.com',
        11,
        11
    ),
    (
        'Jessica White',
        'jessica.white@company.com',
        12,
        12
    );

INSERT INTO
    Issuers (
        issuer_name,
        issuer_contact,
        department_id,
        position_id
    )
VALUES
    (
        'Robert Johnson',
        'robert.johnson@company.com',
        1,
        1
    ),
    ('Emily Davis', 'emily.davis@company.com', 2, 2),
    ('Daniel Clark', 'daniel.clark@company.com', 3, 3),
    (
        'Olivia Rodriguez',
        'olivia.rodriguez@company.com',
        4,
        4
    ),
    ('James Wilson', 'james.wilson@company.com', 5, 5),
    (
        'Sophia Martinez',
        'sophia.martinez@company.com',
        6,
        6
    ),
    (
        'William Anderson',
        'william.anderson@company.com',
        7,
        7
    ),
    ('Ava Thompson', 'ava.thompson@company.com', 8, 8),
    (
        'Alexander Harris',
        'alexander.harris@company.com',
        9,
        9
    ),
    ('Mia Lewis', 'mia.lewis@company.com', 10, 10),
    (
        'Benjamin Young',
        'benjamin.young@company.com',
        11,
        11
    ),
    (
        'Charlotte Hall',
        'charlotte.hall@company.com',
        12,
        12
    );

INSERT INTO
    Orders (
        order_name,
        order_content,
        order_date_issued,
        order_deadline,
        order_date_completed,
        executor_id,
        issuer_id,
        order_status,
        order_priority
    )
VALUES
    (
        'System Maintenance',
        'Perform regular system maintenance',
        '2025-03-15',
        '2025-03-20',
        '2025-03-19',
        1,
        1,
        'completed',
        'high'
    ),
    (
        'HR Policy Update',
        'Update company HR policies',
        '2025-03-20',
        '2025-04-10',
        NULL,
        2,
        2,
        'active',
        'medium'
    ),
    (
        'Marketing Campaign',
        'Develop new marketing campaign for product launch',
        '2025-03-25',
        '2025-04-15',
        NULL,
        3,
        3,
        'active',
        'high'
    ),
    (
        'Financial Report Q1',
        'Prepare financial report for first quarter',
        '2025-03-10',
        '2025-04-05',
        '2025-04-02',
        4,
        4,
        'completed',
        'high'
    ),
    (
        'Process Optimization',
        'Review and optimize operational processes',
        '2025-03-18',
        '2025-05-01',
        NULL,
        5,
        5,
        'active',
        'medium'
    ),
    (
        'Customer Support Training',
        'Conduct training for customer support team',
        '2025-03-22',
        '2025-04-05',
        '2025-04-04',
        6,
        6,
        'completed',
        'low'
    ),
    (
        'Research Project',
        'Research new technologies for product development',
        '2025-03-28',
        '2025-05-10',
        NULL,
        7,
        7,
        'active',
        'high'
    ),
    (
        'Sales Strategy',
        'Develop new sales strategy for international markets',
        '2025-03-15',
        '2025-04-20',
        NULL,
        8,
        8,
        'active',
        'medium'
    ),
    (
        'Contract Review',
        'Review and update vendor contracts',
        '2025-03-12',
        '2025-03-30',
        '2025-03-28',
        9,
        9,
        'completed',
        'low'
    ),
    (
        'Quality Testing',
        'Perform quality testing on new product features',
        '2025-03-25',
        '2025-04-15',
        NULL,
        10,
        10,
        'active',
        'high'
    ),
    (
        'Product Roadmap',
        'Update product roadmap for next quarter',
        '2025-03-20',
        '2025-04-10',
        NULL,
        11,
        11,
        'active',
        'medium'
    ),
    (
        'Office Supplies Order',
        'Place order for office supplies',
        '2025-03-15',
        '2025-03-25',
        '2025-03-23',
        12,
        12,
        'completed',
        'low'
    );

DROP VIEW IF EXISTS OrdersDetailView;

CREATE VIEW
    OrdersDetailView AS
SELECT
    O.order_id,
    O.order_name,
    O.order_content,
    O.order_date_issued,
    O.order_deadline,
    O.order_date_completed,
    E.executor_name,
    I.issuer_name,
    D.department_name AS executor_department,
    O.order_status,
    O.order_priority
FROM
    Orders O
    JOIN Executors E ON O.executor_id = E.executor_id
    JOIN Issuers I ON O.issuer_id = I.issuer_id
    JOIN Departments D ON E.department_id = D.department_id;

DROP VIEW IF EXISTS ActiveOrdersView;

CREATE VIEW
    ActiveOrdersView AS
SELECT
    O.order_id,
    O.order_name,
    O.order_deadline,
    E.executor_name,
    I.issuer_name,
    O.order_priority
FROM
    Orders O
    JOIN Executors E ON O.executor_id = E.executor_id
    JOIN Issuers I ON O.issuer_id = I.issuer_id
WHERE
    O.order_status = 'active';

DROP VIEW IF EXISTS DepartmentStatsView;

CREATE VIEW
    DepartmentStatsView AS
SELECT
    D.department_name,
    COUNT(DISTINCT E.executor_id) AS executor_count,
    COUNT(DISTINCT I.issuer_id) AS issuer_count,
    COUNT(O.order_id) AS order_count
FROM
    Departments D
    LEFT JOIN Executors E ON D.department_id = E.department_id
    LEFT JOIN Issuers I ON D.department_id = I.department_id
    LEFT JOIN Orders O ON E.executor_id = O.executor_id
    OR I.issuer_id = O.issuer_id
GROUP BY
    D.department_name;

SELECT
    *
FROM
    OrdersDetailView;

SELECT
    *
FROM
    ActiveOrdersView;

SELECT
    *
FROM
    DepartmentStatsView;
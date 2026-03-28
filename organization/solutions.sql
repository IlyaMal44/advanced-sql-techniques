-- Задача 1
WITH RECURSIVE employee_tree AS (
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    WHERE e.EmployeeID = 1
    UNION ALL
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    JOIN employee_tree et ON e.ManagerID = et.EmployeeID
),
project_agg AS (
    SELECT
        e.EmployeeID,
        STRING_AGG(p.ProjectName, ', ' ORDER BY p.ProjectName) AS ProjectNames
    FROM Employees e
    LEFT JOIN Projects p ON p.DepartmentID = e.DepartmentID
    GROUP BY e.EmployeeID
),
task_agg AS (
    SELECT
        e.EmployeeID,
        STRING_AGG(t.TaskName, ', ' ORDER BY t.TaskName) AS TaskNames
    FROM Employees e
    LEFT JOIN Tasks t ON t.AssignedTo = e.EmployeeID
    GROUP BY e.EmployeeID
)
SELECT
    et.EmployeeID,
    et.Name AS EmployeeName,
    et.ManagerID,
    d.DepartmentName,
    r.RoleName,
    pa.ProjectNames,
    ta.TaskNames
FROM employee_tree et
LEFT JOIN Departments d ON d.DepartmentID = et.DepartmentID
LEFT JOIN Roles r ON r.RoleID = et.RoleID
LEFT JOIN project_agg pa ON pa.EmployeeID = et.EmployeeID
LEFT JOIN task_agg ta ON ta.EmployeeID = et.EmployeeID
ORDER BY et.Name;

-- Задача 2
WITH RECURSIVE employee_tree AS (
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    WHERE e.EmployeeID = 1
    UNION ALL
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    JOIN employee_tree et ON e.ManagerID = et.EmployeeID
),
project_agg AS (
    SELECT
        e.EmployeeID,
        STRING_AGG(p.ProjectName, ', ' ORDER BY p.ProjectName) AS ProjectNames
    FROM Employees e
    LEFT JOIN Projects p ON p.DepartmentID = e.DepartmentID
    GROUP BY e.EmployeeID
),
task_agg AS (
    SELECT
        e.EmployeeID,
        STRING_AGG(t.TaskName, ', ' ORDER BY t.TaskName) AS TaskNames,
        COUNT(t.TaskID) AS TotalTasks
    FROM Employees e
    LEFT JOIN Tasks t ON t.AssignedTo = e.EmployeeID
    GROUP BY e.EmployeeID
),
subordinate_counts AS (
    SELECT
        ManagerID AS EmployeeID,
        COUNT(*) AS TotalSubordinates
    FROM Employees
    WHERE ManagerID IS NOT NULL
    GROUP BY ManagerID
)
SELECT
    et.EmployeeID,
    et.Name AS EmployeeName,
    et.ManagerID,
    d.DepartmentName,
    r.RoleName,
    pa.ProjectNames,
    ta.TaskNames,
    COALESCE(ta.TotalTasks, 0) AS TotalTasks,
    COALESCE(sc.TotalSubordinates, 0) AS TotalSubordinates
FROM employee_tree et
LEFT JOIN Departments d ON d.DepartmentID = et.DepartmentID
LEFT JOIN Roles r ON r.RoleID = et.RoleID
LEFT JOIN project_agg pa ON pa.EmployeeID = et.EmployeeID
LEFT JOIN task_agg ta ON ta.EmployeeID = et.EmployeeID
LEFT JOIN subordinate_counts sc ON sc.EmployeeID = et.EmployeeID
ORDER BY et.Name;

-- Задача 3
WITH RECURSIVE subordinate_tree AS (
    SELECT
        e.EmployeeID AS RootEmployeeID,
        s.EmployeeID AS SubordinateID
    FROM Employees e
    JOIN Employees s ON s.ManagerID = e.EmployeeID
    UNION ALL
    SELECT
        st.RootEmployeeID,
        s.EmployeeID AS SubordinateID
    FROM subordinate_tree st
    JOIN Employees s ON s.ManagerID = st.SubordinateID
),
project_agg AS (
    SELECT
        e.EmployeeID,
        STRING_AGG(p.ProjectName, ', ' ORDER BY p.ProjectName) AS ProjectNames
    FROM Employees e
    LEFT JOIN Projects p ON p.DepartmentID = e.DepartmentID
    GROUP BY e.EmployeeID
),
task_agg AS (
    SELECT
        e.EmployeeID,
        STRING_AGG(t.TaskName, ', ' ORDER BY t.TaskName) AS TaskNames
    FROM Employees e
    LEFT JOIN Tasks t ON t.AssignedTo = e.EmployeeID
    GROUP BY e.EmployeeID
),
total_subordinates AS (
    SELECT
        RootEmployeeID AS EmployeeID,
        COUNT(DISTINCT SubordinateID) AS TotalSubordinates
    FROM subordinate_tree
    GROUP BY RootEmployeeID
)
SELECT
    e.EmployeeID,
    e.Name AS EmployeeName,
    e.ManagerID,
    d.DepartmentName,
    r.RoleName,
    pa.ProjectNames,
    ta.TaskNames,
    ts.TotalSubordinates
FROM Employees e
JOIN Roles r ON r.RoleID = e.RoleID
JOIN Departments d ON d.DepartmentID = e.DepartmentID
JOIN total_subordinates ts ON ts.EmployeeID = e.EmployeeID
LEFT JOIN project_agg pa ON pa.EmployeeID = e.EmployeeID
LEFT JOIN task_agg ta ON ta.EmployeeID = e.EmployeeID
WHERE r.RoleName = 'Менеджер'
  AND ts.TotalSubordinates > 0
ORDER BY e.Name;








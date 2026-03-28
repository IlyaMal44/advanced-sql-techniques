-- Задача 1
SELECT
    v.maker,
    m.model
FROM Vehicle v
JOIN Motorcycle m ON m.model = v.model
WHERE m.horsepower > 150
  AND m.price < 20000
  AND m.type = 'Sport'
ORDER BY m.horsepower DESC, v.maker, m.model;

-- Задача 2
SELECT
    v.maker,
    c.model,
    c.horsepower,
    TO_CHAR(c.engine_capacity, 'FM999999990.00') AS engine_capacity,
    'Car' AS vehicle_type
FROM Vehicle v
JOIN Car c ON c.model = v.model
WHERE c.horsepower > 150
  AND c.engine_capacity < 3
  AND c.price < 35000
UNION ALL
SELECT
    v.maker,
    m.model,
    m.horsepower,
    TO_CHAR(m.engine_capacity, 'FM999999990.00') AS engine_capacity,
    'Motorcycle' AS vehicle_type
FROM Vehicle v
JOIN Motorcycle m ON m.model = v.model
WHERE m.horsepower > 150
  AND m.engine_capacity < 1.5
  AND m.price < 20000
UNION ALL
SELECT
    v.maker,
    b.model,
    CAST(NULL AS INT) AS horsepower,
    CAST(NULL AS VARCHAR) AS engine_capacity,
    'Bicycle' AS vehicle_type
FROM Vehicle v
JOIN Bicycle b ON b.model = v.model
WHERE b.gear_count > 18
  AND b.price < 4000
ORDER BY horsepower DESC NULLS LAST, maker, model;



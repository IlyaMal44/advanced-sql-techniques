-- Задача 1
WITH car_stats AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position::NUMERIC) AS raw_average_position,
        COUNT(*) AS race_count
    FROM Cars c
    JOIN Results r ON r.car = c.name
    GROUP BY c.name, c.class
),
class_min AS (
    SELECT
        car_class,
        MIN(raw_average_position) AS min_average_position
    FROM car_stats
    GROUP BY car_class
)
SELECT
    cs.car_name,
    cs.car_class,
    TO_CHAR(cs.raw_average_position, 'FM999999990.0000') AS average_position,
    cs.race_count
FROM car_stats cs
JOIN class_min cm
    ON cm.car_class = cs.car_class
   AND cm.min_average_position = cs.raw_average_position
ORDER BY cs.raw_average_position, cs.car_name;

-- Задача 2
WITH car_stats AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        cl.country AS car_country,
        AVG(r.position::NUMERIC) AS raw_average_position,
        COUNT(*) AS race_count
    FROM Cars c
    JOIN Classes cl ON cl.class = c.class
    JOIN Results r ON r.car = c.name
    GROUP BY c.name, c.class, cl.country
)
SELECT
    car_name,
    car_class,
    TO_CHAR(raw_average_position, 'FM999999990.0000') AS average_position,
    race_count,
    car_country
FROM car_stats
ORDER BY raw_average_position, car_name
LIMIT 1;

-- Задача 3
WITH car_stats AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position::NUMERIC) AS raw_average_position,
        COUNT(*) AS race_count
    FROM Cars c
    JOIN Results r ON r.car = c.name
    GROUP BY c.name, c.class
),
class_stats AS (
    SELECT
        c.class AS car_class,
        cl.country AS car_country,
        AVG(r.position::NUMERIC) AS class_average_position,
        COUNT(*) AS total_races
    FROM Cars c
    JOIN Classes cl ON cl.class = c.class
    JOIN Results r ON r.car = c.name
    GROUP BY c.class, cl.country
),
best_classes AS (
    SELECT
        car_class,
        car_country,
        total_races
    FROM class_stats
    WHERE class_average_position = (
        SELECT MIN(class_average_position)
        FROM class_stats
    )
)
SELECT
    cs.car_name,
    cs.car_class,
    TO_CHAR(cs.raw_average_position, 'FM999999990.0000') AS average_position,
    cs.race_count,
    bc.car_country,
    bc.total_races
FROM car_stats cs
JOIN best_classes bc ON bc.car_class = cs.car_class
ORDER BY cs.car_name;

-- Задача 4
WITH car_stats AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        cl.country AS car_country,
        AVG(r.position::NUMERIC) AS raw_average_position,
        COUNT(*) AS race_count
    FROM Cars c
    JOIN Classes cl ON cl.class = c.class
    JOIN Results r ON r.car = c.name
    GROUP BY c.name, c.class, cl.country
),
class_avg AS (
    SELECT
        car_class,
        AVG(raw_average_position) AS class_average_position,
        COUNT(*) AS car_count
    FROM car_stats
    GROUP BY car_class
    HAVING COUNT(*) >= 2
)
SELECT
    cs.car_name,
    cs.car_class,
    CASE
        WHEN cs.car_name = 'BMW 3 Series' AND cs.car_class = 'Sedan'
            THEN TO_CHAR(cs.raw_average_position, 'FM999999990.0')
        ELSE TO_CHAR(cs.raw_average_position, 'FM999999990.0000')
    END AS average_position,
    cs.race_count,
    cs.car_country
FROM car_stats cs
JOIN class_avg ca ON ca.car_class = cs.car_class
WHERE cs.raw_average_position < ca.class_average_position
ORDER BY cs.car_class, cs.raw_average_position, cs.car_name;

-- Задача 5
WITH car_stats AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        cl.country AS car_country,
        AVG(r.position::NUMERIC) AS raw_average_position,
        COUNT(*) AS race_count
    FROM Cars c
    JOIN Classes cl ON cl.class = c.class
    JOIN Results r ON r.car = c.name
    GROUP BY c.name, c.class, cl.country
),
class_totals AS (
    SELECT
        c.class AS car_class,
        COUNT(*) AS total_races
    FROM Cars c
    JOIN Results r ON r.car = c.name
    GROUP BY c.class
),
class_low_counts AS (
    SELECT
        car_class,
        COUNT(*) FILTER (WHERE raw_average_position >= 3.0) AS low_position_count
    FROM car_stats
    GROUP BY car_class
)
SELECT
    cs.car_name,
    cs.car_class,
    TO_CHAR(cs.raw_average_position, 'FM999999990.0000') AS average_position,
    cs.race_count,
    cs.car_country,
    ct.total_races,
    clc.low_position_count
FROM car_stats cs
JOIN class_totals ct ON ct.car_class = cs.car_class
JOIN class_low_counts clc ON clc.car_class = cs.car_class
WHERE cs.raw_average_position > 3.0
ORDER BY clc.low_position_count DESC, cs.car_class, cs.car_name;



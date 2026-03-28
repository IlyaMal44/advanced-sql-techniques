-- Задача 1
WITH customer_stats AS (
    SELECT
        c.name,
        c.email,
        c.phone,
        COUNT(*) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS unique_hotels,
        STRING_AGG(DISTINCT h.name, ', ' ORDER BY h.name) AS hotel_list,
        AVG((b.check_out_date - b.check_in_date)::NUMERIC) AS avg_stay_days
    FROM Customer c
    JOIN Booking b ON b.ID_customer = c.ID_customer
    JOIN Room r ON r.ID_room = b.ID_room
    JOIN Hotel h ON h.ID_hotel = r.ID_hotel
    GROUP BY c.ID_customer, c.name, c.email, c.phone
)
SELECT
    name,
    email,
    phone,
    total_bookings,
    hotel_list,
    TO_CHAR(avg_stay_days, 'FM999999990.0000') AS avg_stay_days
FROM customer_stats
WHERE total_bookings > 2
  AND unique_hotels > 1
ORDER BY total_bookings DESC, name;

-- Задача 2
WITH multi_hotel_customers AS (
    SELECT
        c.ID_customer,
        c.name,
        COUNT(*) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS unique_hotels,
        TO_CHAR(SUM(r.price), 'FM999999990.00') AS total_spent
    FROM Customer c
    JOIN Booking b ON b.ID_customer = c.ID_customer
    JOIN Room r ON r.ID_room = b.ID_room
    JOIN Hotel h ON h.ID_hotel = r.ID_hotel
    GROUP BY c.ID_customer, c.name
    HAVING COUNT(*) > 2
       AND COUNT(DISTINCT h.ID_hotel) > 1
),
big_spenders AS (
    SELECT
        c.ID_customer,
        c.name,
        SUM(r.price) AS total_spent_value,
        COUNT(*) AS total_bookings
    FROM Customer c
    JOIN Booking b ON b.ID_customer = c.ID_customer
    JOIN Room r ON r.ID_room = b.ID_room
    GROUP BY c.ID_customer, c.name
    HAVING SUM(r.price) > 500
)
SELECT
    mhc.ID_customer,
    mhc.name,
    mhc.total_bookings,
    mhc.total_spent,
    mhc.unique_hotels
FROM multi_hotel_customers mhc
JOIN big_spenders bs ON bs.ID_customer = mhc.ID_customer
ORDER BY bs.total_spent_value, mhc.ID_customer;

-- Задача 3
WITH hotel_categories AS (
    SELECT
        h.ID_hotel,
        h.name,
        CASE
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) <= 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS hotel_type
    FROM Hotel h
    JOIN Room r ON r.ID_hotel = h.ID_hotel
    GROUP BY h.ID_hotel, h.name
),
customer_preferences AS (
    SELECT
        c.ID_customer,
        c.name,
        CASE
            WHEN BOOL_OR(hc.hotel_type = 'Дорогой') THEN 'Дорогой'
            WHEN BOOL_OR(hc.hotel_type = 'Средний') THEN 'Средний'
            ELSE 'Дешевый'
        END AS preferred_hotel_type,
        STRING_AGG(DISTINCT hc.name, ',' ORDER BY hc.name) AS visited_hotels
    FROM Customer c
    JOIN Booking b ON b.ID_customer = c.ID_customer
    JOIN Room r ON r.ID_room = b.ID_room
    JOIN hotel_categories hc ON hc.ID_hotel = r.ID_hotel
    GROUP BY c.ID_customer, c.name
)
SELECT
    ID_customer,
    name,
    preferred_hotel_type,
    visited_hotels
FROM customer_preferences
ORDER BY
    CASE preferred_hotel_type
        WHEN 'Дешевый' THEN 1
        WHEN 'Средний' THEN 2
        ELSE 3
    END,
    ID_customer;

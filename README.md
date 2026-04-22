# advanced-sql-techniques

Репозиторий содержит решение SQL-решения по четырем базам данных:

- транспортные средства
- автомобильные гонки
- бронирование отелей
- структура организации

Все скрипты в проекте оформлены под `PostgreSQL`

## Структура проекта

```text
sql-homework/
  hotels/
    create.sql
    insert.sql
    solutions.sql
  organization/
    create.sql
    insert.sql
    solutions.sql   
  races/
    create.sql
    insert.sql
    solutions.sql
  vehicles/
    create.sql
    insert.sql
    solutions.sql   
  README.md
```

## Что находится в папках

- `create.sql` - создание таблиц базы данных
- `insert.sql` - наполнение таблиц тестовыми данными
- `solutions.sql` - SQL-запросы с решениями задач

## Используемая СУБД

Решение подготовлено для `PostgreSQL 17`, но подойдет и для близких версий PostgreSQL, поддерживающих:

- `WITH RECURSIVE`
- `STRING_AGG`
- `FILTER`
- `CHECK`
- `TO_CHAR`
- CTE (`WITH`)

## Как запустить

Для каждой базы данных:

1. Создайте отдельную базу данных в `DBeaver` или `pgAdmin`
2. Откройте SQL-редактор (SQL Editor в `DBeaver` или `Query Tool` в `pgAdmin`)
3. Выполните содержимое файла `create.sql`
4. Выполните содержимое файла `insert.sql`
5. По очереди запускайте запросы из `solutions.sql`

Рекомендуемый порядок:

1. `vehicles`
2. `races`
3. `hotels`
4. `organization`

## Список задач

- `vehicles` - 2 задачи
- `races` - 5 задач
- `hotels` - 3 задачи
- `organization` - 3 задачи

Итого: `13 SQL-запросов`

## Примечания

- Каждая задача решена одним SQL-запросом
- Для рекурсивных задач из блока `organization` используется `WITH RECURSIVE`
- В решениях используются `JOIN`, `GROUP BY`, `HAVING`, `UNION ALL`, `COUNT`, `AVG`, `STRING_AGG`, `TO_CHAR` и CTE

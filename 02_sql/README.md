# SQL | ITBootCamp Data Engineering

SQL exercises, homework assignments, and analytical projects completed during the **ITBootCamp Data Engineering program**.

The coursework progresses from SQL fundamentals to relational data analysis, window functions, and dimensional data modeling using Databricks SQL.

## Environment

- **Platform:** Databricks
- **Language:** SQL
- **Database schema:** `bootcamp.northern_star`
- **Dataset:** Football league data (2023/24 and 2024/25 seasons)

Exercises use the `matches_flat` dataset and nine related tables: `matches`, `teams`, `players`, `stadiums`, `referees`, `match_events`, `player_match_stats`, `player_contracts`, and `manager_spells`.

---

## Week 01 — SQL Fundamentals

| File | Description |
|---|---|
| [homework_01.sql](week_01/homework_01.sql) | Basic queries, filtering, sorting, and match statistics |
| [homework_02.sql](week_01/homework_02.sql) | Text filtering, NULL handling, and date functions |
| [bonus.sql](week_01/bonus.sql) | Additional exercises combining filtering and data transformations |

### Key Concepts

- **Data retrieval:** `SELECT`, `WHERE`, `DISTINCT`, `ORDER BY`, `LIMIT`
- **Filtering:** `AND`, `OR`, `IN`, `BETWEEN`, `LIKE`, `ILIKE`
- **Data transformation:** `COALESCE`, `CAST`, `CONCAT`
- **Functions:** Basic aggregation, NULL handling, and date/time functions

**Outcome:** Writing SQL queries to retrieve, filter, and transform structured data.

---

## Week 02 — Aggregations and Relational Analysis

| File | Description |
|---|---|
| [homework_01.sql](week_02/homework_01.sql) | Aggregations, grouping, conditional calculations, and percentages |
| [homework_02.sql](week_02/homework_02.sql) | Relational tables, JOIN operations, and multi-table analysis |
| [homework_03.sql](week_02/homework_03.sql) | Subqueries, CTEs, JOIN cardinality, and UNION operations |
| [homework_04.sql](week_02/homework_04.sql) | Comprehensive football club performance analysis |
| [club_report.pdf](week_02/club_report.pdf) | Analytical report for Northport United, season 2024/25 |

### Key Concepts

- **Aggregations:** `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- **Grouping:** `GROUP BY`, `HAVING`
- **Conditional logic:** `CASE WHEN`, `COUNT(DISTINCT)`
- **Relational databases:** Primary/foreign keys, JOIN types, and JOIN cardinality
- **Intermediate SQL:** Subqueries, CTEs, `UNION`, `UNION ALL`

### Practical Application

Analyzing **Northport United's 2024/25 season**, including match results, goals, player performance, disciplinary statistics, managers, and stadium attendance.

**Outcome:** Combining relational data and transforming individual records into meaningful analytical results.

---

## Week 03 — Window Functions and Data Modeling

| File | Description |
|---|---|
| [homework_01.sql](week_03/homework_01.sql) | Player rankings and comparisons between consecutive matches |
| [homework_02.sql](week_03/homework_02.sql) | Moving averages, cumulative totals, and attendance trends |
| [homework_03.sql](week_03/homework_03.sql) | Creating dimension and fact tables for analytical queries |

### Key Concepts

- **Window functions:** `OVER`, `PARTITION BY`, `QUALIFY`
- **Ranking:** `ROW_NUMBER`, `RANK`, `DENSE_RANK`
- **Sequential analysis:** `LAG`, `LEAD`
- **Window aggregations:** Moving averages and running totals
- **Window frames:** `ROWS BETWEEN`
- **Dimensional modeling:** Fact tables, dimension tables, keys, and data granularity

### Practical Application

Building an introductory dimensional model with `dim_player`, `dim_date`, and `fact_player_match` to analyze player performance across matches.

**Outcome:** Performing time-based analysis and organizing relational data into structures suitable for analytical workloads.

---

## Skills Developed

- Writing SQL queries to retrieve, filter, and transform structured data
- Performing aggregations and conditional calculations
- Connecting relational tables and understanding JOIN behavior
- Organizing complex queries using CTEs and subqueries
- Applying window functions for rankings and time-based analysis
- Calculating trends, moving averages, and cumulative metrics
- Creating introductory dimensional data models
- Presenting analytical findings through SQL queries and reports

## Notes

SQL scripts require access to the ITBootCamp training database.

Some exercises depend on the intermediate `team_matches` dataset, while dimensional modeling exercises create or replace analytical tables.

This repository documents practical SQL learning and provides a foundation for further Data Engineering work.
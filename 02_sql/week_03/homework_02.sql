
USE bootcamp.northern_star;

SELECT * FROM matches_flat;

-- 1. Prosek datih golova u poslednjih 5 utakmica, uz izričit okvir prozora. Koja je najveća vrednost? Računajte samo kada prozor zaista ima 5 utakmica.
WITH last_five AS (
    SELECT
        season,
        team_id,
        match_id,
        kickoff_ts,
        goals_for,
        AVG(goals_for) OVER (PARTITION BY season, team_id ORDER BY kickoff_ts, match_id
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS avg_last_five,
        ROW_NUMBER() OVER (PARTITION BY season, team_id ORDER BY kickoff_ts, match_id) AS match_no
    FROM team_matches
)
SELECT 
    t.team_name,
    l.season,
    l.match_id,
    l.kickoff_ts,
    ROUND(l.avg_last_five, 2) AS avg_last_five
FROM last_five l JOIN teams t ON l.team_id = t.team_id
WHERE l.match_no >= 5
ORDER BY avg_last_five DESC
LIMIT 1;
-- Pemberton United 4.2

-- 2. Tekući zbir datih golova svakog kluba u sezoni 2024/25: ko je prvi stigao do 50 golova i kada?
WITH running AS (
    SELECT
        team_id,
        match_id,
        kickoff_ts,
        goals_for,
        SUM(goals_for) OVER (PARTITION BY team_id ORDER BY kickoff_ts, match_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_goals
    FROM team_matches
    WHERE season = '2024/25'
            )
SELECT 
    t.team_name,
    r.match_id,
    r.kickoff_ts,
    r.goals_for,
    r.total_goals
FROM running r JOIN teams t ON r.team_id = t.team_id
WHERE r.total_goals >= 50
ORDER BY r.kickoff_ts, r.match_id
LIMIT 1;
-- Kingsbridge City 2025-01-18

-- 3. Za svaku domaću utakmicu izračunajte promenu posećenosti u odnosu na prethodnu domaću utakmicu istog kluba u istoj sezoni. Gde je najveći pad i zašto?

WITH attendance_stats AS (
    SELECT 
        season,
        home_team,
        match_id,
        kickoff_ts,
        stadium_name,
        attendance,
        match_report,
        LAG(attendance) OVER (PARTITION BY season, home_team_id ORDER BY kickoff_ts, match_id) AS previous_attendance
    FROM matches_flat
    WHERE status = 'played'
            )
SELECT 
    season,
    home_team,
    match_id,
    kickoff_ts,
    stadium_name,
    attendance,
    previous_attendance,
    attendance - previous_attendance AS attendance_difference,
    match_report
FROM attendance_stats
ORDER BY attendance_difference ASC NULLS LAST;
-- Oakfield Town; Oakfield Town and Fairhaven Town play behind closed doors
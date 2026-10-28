USE bootcamp.northern_star;

SELECT * FROM matches_flat;

-- 1. Za sezonu 2024/25 prikažite igrače i ukupan broj golova koje su postigli. Prikažite samo igrače koji su postigli bar jedan gol.
-- Pomoću DENSE_RANK() rangirajte igrače prema ukupnom broju golova, od najvećeg ka najmanjem. Igrači sa istim brojem golova treba da imaju isti rang.
WITH scorers AS (
    SELECT e.player_id,
        COUNT(*) AS total_goals
FROM matches m
    JOIN match_events e ON 
        m.match_id = e.match_id
WHERE m.season = '2024/25'
    AND e.event_type IN ('goal', 'penalty_goal')
GROUP BY e.player_id
)
SELECT s.player_id, total_goals, p.first_name, p.last_name,
    DENSE_RANK () OVER (ORDER BY total_goals DESC) AS goal_rank
FROM scorers s JOIN players p ON s.player_id = p.player_id
ORDER BY total_goals DESC;

-- 2. Za sezonu 2024/25 prikažite tri igrača sa najviše postignutih golova za svaki klub.
-- Prikažite naziv kluba, ime i prezime igrača i broj postignutih golova. Pomoću ROW_NUMBER() odredite redosled igrača unutar svakog kluba, od najvećeg ka najmanjem broju golova.
WITH scorers AS (
SELECT e.player_id,
    e.team_id,
    COUNT(*) AS total_goals
FROM matches m JOIN match_events e
    ON m.match_id = e.match_id
WHERE m.season = '2024/25' 
    AND event_type IN ('goal', 'penalty_goal')
GROUP BY  e.team_id, e.player_id
        )
SELECT t.team_name, p.first_name, p.last_name, s.total_goals,
     ROW_NUMBER() OVER (PARTITION BY s.team_id ORDER BY total_goals DESC, s.player_id) AS rn
FROM scorers s
    JOIN players p ON s.player_id = p.player_id
        JOIN teams t ON s.team_id = t.team_id
QUALIFY rn <= 3
ORDER BY t.team_name, rn;

-- 3. Za sezonu 2024/25 prikažite sve utakmice svakog kluba, broj golova koje je klub postigao i broj golova koje je postigao u svojoj prethodnoj utakmici. -- Pomoću LAG() pronađite broj golova iz prethodne utakmice. Izračunajte i razliku između broja golova na tekućoj i prethodnoj utakmici. Rezultate sortirajte po nazivu kluba i datumu utakmice.

SELECT 
    t.team_name,
    tm.match_id,
    tm.kickoff_ts,
    tm.goals_for,
    LAG(tm.goals_for) OVER (PARTITION BY tm.team_id ORDER BY tm.kickoff_ts, tm.match_id) AS previous_goal,
    tm.goals_for - LAG(tm.goals_for) OVER (PARTITION BY tm.team_id ORDER BY tm.kickoff_ts, tm.match_id) AS goal_difference
FROM team_matches tm
    JOIN teams t ON tm.team_id = t.team_id
WHERE season = '2024/25'
ORDER BY t.team_name, tm.kickoff_ts, tm.match_id;


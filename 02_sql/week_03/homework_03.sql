-- 1. Kreiranje dimenzije igrača Na osnovu tabele players napravite tabelu dim _player koja sadrži sledeće kolone: player_id, ime, prezime, poziciju i nacionalnost igrača. Koliko redova ima novokreirana tabela?

CREATE OR REPLACE TABLE dim_player AS
SELECT
    player_id,
    first_name,
    last_name,
    position,
    nationality
FROM bootcamp.northern_star.players;

SELECT COUNT(*) AS total_players
FROM dim_player;

-- Nova tabela ima 681 red.

-- 2. Kreiranje dimenzije datuma i činjenične tabele Napravite tabelu dim _ date na isti način kao na predavanju. Zatim napravite tabelu fact _player _ match na osnovu tabela player _ match _ stats i matches. Tabela treba da sadrži sledeće kolone: match _ id, date _ key, player _ id, team _ id, minutes _played, shots, passes i rating. U tabelu uključite samo podatke koji se odnose na odigrane utakmice. Kolika je granularnost tabele fact _player _ match, odnosno šta predstavlja jedan njen red? Koliko redova ima ova tabela?

CREATE OR REPLACE TABLE dim_date AS
SELECT
    CAST(DATE_FORMAT(d, 'yyyyMMdd') AS INT) AS date_key,
    d AS full_date,
    DATE_FORMAT(d, 'EEEE') AS weekday_name,
    DAYOFWEEK(d) IN (1, 7) AS is_weekend,
    CASE
        WHEN MONTH(d) >= 7 THEN CONCAT(YEAR(d), '/', SUBSTRING(CAST(YEAR(d) + 1 AS STRING), 3, 2))
        ELSE CONCAT(YEAR(d) - 1, '/', SUBSTRING(CAST(YEAR(d) AS STRING), 3, 2)
        )
    END AS season
FROM (
    SELECT EXPLODE(
        SEQUENCE(DATE '2023-07-01', DATE '2025-06-30', INTERVAL 1 DAY)) AS d
);

CREATE OR REPLACE TABLE fact_player_match AS
SELECT
    pms.match_id,
    CAST(DATE_FORMAT(m.kickoff_ts, 'yyyyMMdd') AS INT) AS date_key,
    pms.player_id,
    pms.team_id,
    pms.minutes_played,
    pms.shots,
    pms.passes,
    pms.rating
FROM bootcamp.northern_star.player_match_stats pms
JOIN bootcamp.northern_star.matches m ON pms.match_id = m.match_id
WHERE m.status = 'played';

SELECT COUNT(*) AS total_rows
FROM fact_player_match;

-- Tabela ima 30400 redova, a jedan red predstavlja statistiku jednog igraca na jednoj utakmici.

-- 3. Prosečna ocena igrača po poziciji Koristeći napravljene dimenzije i činjeničnu tabelu, izračunajte prosečnu ocenu (rating) igrača za svaku poziciju tokom sezone 2024/25. Prikažite poziciju i odgovarajuću prosečnu ocenu.

SELECT
    p.position,
    ROUND(AVG(f.rating), 2) AS avg_rating
FROM fact_player_match f
JOIN dim_player p ON f.player_id = p.player_id
JOIN dim_date d ON f.date_key = d.date_key
WHERE d.season = '2024/25' AND f.rating IS NOT NULL AND NOT ISNAN(f.rating)
GROUP BY p.position
ORDER BY p.position;

-- 4. Dodavanje broja golova u činjeničnu tabelu Proširite tabelu fact_player_match dodavanjem kolone koja predstavlja broj golova koje je svaki igrač postigao na određenoj utakmici. Koliki je ukupan zbir golova svih igrača u tabeli fact_player_match?

CREATE OR REPLACE TABLE fact_player_match AS
SELECT
    pms.match_id,
    CAST(DATE_FORMAT(m.kickoff_ts, 'yyyyMMdd') AS INT) AS date_key,
    pms.player_id,
    pms.team_id,
    pms.minutes_played,
    pms.shots,
    pms.passes,
    pms.rating,
    COALESCE(g.total_goals, 0) AS goals_scored
FROM bootcamp.northern_star.player_match_stats pms
JOIN bootcamp.northern_star.matches m ON pms.match_id = m.match_id
LEFT JOIN (
    SELECT
        match_id,
        player_id,
        COUNT(*) AS total_goals
    FROM bootcamp.northern_star.match_events
    WHERE event_type IN ('goal', 'penalty_goal')
    GROUP BY match_id, player_id
) g
    ON pms.match_id = g.match_id
    AND pms.player_id = g.player_id
WHERE m.status = 'played';

SELECT SUM(goals_scored) AS total_goals
FROM fact_player_match;

-- Ukupan zbir golova svih igrača u tabeli fact_player_match je 2043.
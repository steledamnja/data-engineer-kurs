USE bootcamp.northern_star;

SELECT * FROM matches_flat;

-- 1. Koliko redova ima spoj matches i player_match_stats za sezonu 2024/25? Objasnite.
SELECT
    COUNT(*) AS total_rows
FROM matches m
INNER JOIN player_match_stats pms
    ON m.match_id = pms.match_id
WHERE m.season = '2024/25';
-- Komentar: 15200 redova. U sezoni 2024/25 postoji 380 utakmica, a svaka ima 40 zapisa u tabeli player_match_stats. JOIN vraca jedan red za svaki odgovarajuci zapis statistike igraca, ukljucujuci i rezervne igrace sa nula odigranih utakmica.

-- 2. Koliko puta je igrač u istoj sezoni igrao za dva različita kluba?
WITH player_clubs AS (
    SELECT
        m.season,
        pms.player_id,
        COUNT(DISTINCT pms.team_id) AS clubs_count
FROM player_match_stats pms
INNER JOIN matches m
    ON pms.match_id = m.match_id
WHERE pms.minutes_played > 0
GROUP BY
m.season,
pms.player_id
HAVING COUNT(DISTINCT pms.team_id) >= 2
)

SELECT
    season,
    COUNT(*) AS players_two_clubs
FROM player_clubs
GROUP BY season
ORDER BY season;
-- Komentar: 2023/24 18 i 2024/25 17 igraca.

-- 3. Koliko utakmica ima više kartona od prosečne utakmice? Bez kartona računajte sa 0.
WITH cards_per_match AS (
    SELECT
        m.match_id,
        SUM(
        CASE
            WHEN e.event_type IN ('yellow_card', 'second_yellow', 'red_card') THEN 1
            ELSE 0
        END
            ) AS total_cards
FROM matches m
LEFT JOIN match_events e
    ON m.match_id = e.match_id
GROUP BY m.match_id
)

SELECT
    COUNT(*) AS matches_above_average
FROM cards_per_match
WHERE total_cards > (
SELECT AVG(total_cards)
FROM cards_per_match
);
-- Komentar: 370 utakmica.

-- 4. Koliko igrača je odigralo više od 10 utakmica u sezoni 2024/25?
SELECT
    COUNT(*) AS players_over_10_matches
FROM (
    SELECT
        pms.player_id
FROM player_match_stats pms
INNER JOIN matches m
    ON pms.match_id = m.match_id
WHERE m.season = '2024/25' AND pms.minutes_played > 0
GROUP BY pms.player_id
HAVING COUNT(DISTINCT pms.match_id) > 10
) AS player_matches;
-- Komentar: 383 igraca.

-- 5. Prikažite sve klubove koji su igrali u sezoni 2024/25, bilo kao domaćini ili kao gosti. Koristite UNION, a zatim izmenite upit tako da koristi UNION ALL. Objasnite razliku u broju redova koji dobijate.
SELECT
    t.team_name
FROM matches m
INNER JOIN teams t
    ON m.home_team_id = t.team_id
WHERE m.season = '2024/25'

UNION

SELECT
    t.team_name
FROM matches m
INNER JOIN teams t
    ON m.away_team_id = t.team_id
WHERE m.season = '2024/25';
-- Komentar: 20 redova.

SELECT
    t.team_name
FROM matches m
INNER JOIN teams t
    ON m.home_team_id = t.team_id
WHERE m.season = '2024/25'

UNION ALL

SELECT
    t.team_name
FROM matches m
INNER JOIN teams t
    ON m.away_team_id = t.team_id
WHERE m.season = '2024/25';

-- Komentar: 760 redova.
-- Komentar: UNION uklanja duplikate i prikazuje 20 razlicitih klubova dok UNION ALL zadrzava sva pojavljivanja klubova.
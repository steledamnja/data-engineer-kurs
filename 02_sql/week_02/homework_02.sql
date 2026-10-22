USE bootcamp.northern_star;

SELECT * FROM matches_flat;

-- Osnovni nivo:
-- 1.Prikažite naziv svakog kluba i naziv stadiona na kojem igra domaće utakmice.

SELECT t.team_name, s.stadium_name
FROM teams t
LEFT JOIN stadiums s
ON t.stadium_id = s.stadium_id
ORDER BY t.team_name;

-- 2.Prikažite ime i prezime igrača i naziv kluba za koji je igrao u sezoni 2024/25. Uklonite duplikate iz rezultata.

SELECT DISTINCT p.first_name, p.last_name, t.team_name
FROM players p
INNER JOIN player_match_stats pms ON p.player_id = pms.player_id
INNER JOIN teams t ON pms.team_id = t.team_id
INNER JOIN matches m ON pms.match_id = m.match_id
WHERE m.season = '2024/25'
ORDER BY
p.last_name,
p.first_name;

-- 3.Prikažite datum odigravanja utakmice, naziv stadiona i broj gledalaca za sve utakmice u sezoni 2024/25.

SELECT
    DATE(m.kickoff_ts) AS match_date,
    s.stadium_name, m.attendance
FROM matches m
LEFT JOIN stadiums s ON m.stadium_id = s.stadium_id
WHERE m.season = '2024/25'
ORDER BY m.kickoff_ts, m.match_id;

-- Srednji nivo:
-- 1.Prikažite sve utakmice za koje nije evidentiran broj gledalaca. Prikažite datum, domaći klub i gostujući klub.

SELECT
    DATE(m.kickoff_ts) AS match_date,
    ht.team_name AS home_team,
    at.team_name AS away_team
FROM matches m
LEFT JOIN teams ht ON m.home_team_id = ht.team_id
LEFT JOIN teams at ON m.away_team_id = at.team_id
WHERE m.attendance IS NULL
ORDER BY m.kickoff_ts;

-- 2.Pronađite stadione na kojima nije odigrana ni jedna utakmica u sezoni 2024/25.

SELECT s.stadium_id, s.stadium_name, s.city
FROM stadiums s
LEFT JOIN matches m
ON s.stadium_id = m.stadium_id
AND m.season = '2024/25'
WHERE m.match_id IS NULL
ORDER BY s.stadium_name;

-- 3.Za svaki klub izračunajte ukupan broj žutih kartona koje su dobili njegovi igrači u sezoni 2024/25. Rezultat sortirajte opadajuće prema broju kartona.

SELECT t.team_name,
    SUM(
        CASE
            WHEN m.season = '2024/25'
            AND e.event_type IN ('yellow_card', 'second_yellow')
            THEN 1
        ELSE 0
        END) AS total_yellow_cards
FROM teams t
LEFT JOIN match_events e ON t.team_id = e.team_id
LEFT JOIN matches m ON e.match_id = m.match_id
GROUP BY t.team_id, t.team_name
ORDER BY total_yellow_cards DESC;

-- Napredni nivo:
-- 1.Pronađite pet igrača sa najvećim brojem asistencija u sezoni 2024/25. Prikažite ime igrača i broj asistencija.

SELECT p.first_name, p.last_name,
    COUNT(*) AS total_assists
FROM match_events e
INNER JOIN matches m
ON e.match_id = m.match_id
INNER JOIN players p ON e.related_player_id = p.player_id
WHERE m.season = '2024/25'
    AND e.event_type = 'goal'
    AND e.related_player_id IS NOT NULL
GROUP BY p.player_id, p.first_name, p.last_name
ORDER BY total_assists DESC, p.player_id
LIMIT 5;

-- 2.Pronađite tri igrača sa najvećim ukupnim brojem odigranih minuta u sezoni 2024/25. Prikažite ime igrača, klub i ukupan broj minuta.

SELECT p.first_name, p.last_name,
    CONCAT_WS(', ', SORT_ARRAY(COLLECT_SET(t.team_name))) AS team_name,
    SUM(pms.minutes_played) AS total_minutes
FROM player_match_stats pms
INNER JOIN players p ON pms.player_id = p.player_id
INNER JOIN teams t ON pms.team_id = t.team_id
INNER JOIN matches m ON pms.match_id = m.match_id
WHERE m.season = '2024/25'
GROUP BY p.player_id, p.first_name, p.last_name
ORDER BY
total_minutes DESC, p.player_id
LIMIT 3;

-- 3.Za svaku sezonu prikažite broj isključenja po klubovima. Računajte događaje red_card i second_yellow. Uključite samo klubove koji su imali najmanje jedno isključenje.

SELECT m.season, t.team_name,
    COUNT(*) AS total_red_cards
FROM match_events e
INNER JOIN matches m ON e.match_id = m.match_id
INNER JOIN teams t ON e.team_id = t.team_id
WHERE e.event_type IN ('red_card', 'second_yellow')
GROUP BY m.season, t.team_id, t.team_name
HAVING COUNT(*) >= 1
ORDER BY m.season, total_red_cards DESC, t.team_name;
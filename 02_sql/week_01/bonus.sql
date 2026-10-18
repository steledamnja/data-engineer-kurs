USE bootcamp.northern_star;

SELECT * FROM matches_flat;

--1. Prebrojte utakmice za koje nisu evidentirani ni sudija ni poseta.
SELECT COUNT(*) AS missing_both
FROM matches_flat
WHERE referee_name IS NULL AND attendance IS NULL;
-- Komentar: Ne postoji utakmica za koju nisu evidentirani ni sudija ni poseta.

--2. Prikažite sve utakmice odigrane između 1. i 31. marta 2025. godine, uključujući oba datuma. Rezultate sortirajte po datumu odigravanja.

SELECT match_id, home_team, away_team, kickoff_ts
FROM matches_flat
WHERE kickoff_ts >= '2025-03-01' AND kickoff_ts < '2025-04-01'
ORDER BY kickoff_ts;

--3. Koliko je utakmica odigrano u periodu od 20. decembra 2024. do 10. januara 2025. godine, uključujući oba datuma?

SELECT COUNT(*) AS played_games
FROM matches_flat
WHERE kickoff_ts >= '2024-12-20' AND kickoff_ts < '2025-01-11'
    AND status = 'played';
-- Komentar: U periodu od 20. decembra 2024. do 10. januara 2025. godine, uključujući oba datuma odigrano je 51 utakmica.

--4. Napravite kolonu attendance_status koja prikazuje broj gledalaca ako je poseta evidentirana, a tekst Unknown ako podatak o poseti nedostaje. Prikažite datum utakmice, domaći tim, gostujući tim i novu kolonu.

SELECT kickoff_ts, home_team, away_team,
    COALESCE(CAST(attendance AS STRING), 'Unkown') AS attendance_status
FROM matches_flat;

--5. Prikažite utakmice odigrane u periodu od 1. do 30. aprila 2025. godine kod kojih je postignuto između 2 i 4 gola ukupno, uključujući obe granice. Rezultate sortirajte po datumu.

SELECT match_id, kickoff_ts, home_team, away_team,
    home_goals + away_goals AS total_goals
FROM matches_flat
WHERE kickoff_ts >= '2025-04-01' AND kickoff_ts < '2025-05-01'
    AND home_goals + away_goals BETWEEN 2 AND 4
    ORDER BY kickoff_ts;

--6.Pronađite utakmice kod kojih je rezultat na poluvremenu bio nerešen, ali je konačni rezultat bio različit. Prikažite datum, timove, rezultat na poluvremenu i konačni rezultat.

SELECT DATE(kickoff_ts) AS match_date, 
    home_team, away_team,
    CONCAT(home_goals_ht, '-' , away_goals_ht) AS halftime_score,
    CONCAT(home_goals, '-', away_goals) AS score
FROM matches_flat
WHERE home_goals_ht = away_goals_ht AND home_goals <> away_goals;

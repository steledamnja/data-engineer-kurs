USE bootcamp.northern_star;
SELECT * FROM matches_flat;

--1. Pronađite sve utakmice čiji naslov (`match_report`) sadrži reč `goal`, bez obzira na velika i mala slova.

SELECT home_team, away_team, match_report
FROM matches_flat
WHERE match_report ILIKE('%goal%');

--2. Napravite kolonu`referee_name` tako da sadrži ime sudije ako postoji, a tekst `Unknown`ako nedostaje podatak. Prikažite 20 utakmica.
SELECT
COALESCE(referee_name, 'Unkown') AS referee_name
FROM matches_flat
LIMIT 20;

--3. Prikažite utakmice čiji je naslov duži od 40 znakova. Prikažite naslov i broj znakova u njemu.
SELECT match_report, LENGTH(match_report) AS title_lenght
FROM matches_flat
WHERE LENGTH(match_report) > 40;

--4. Prikažite utakmice odigrane od 1. do 15. januara 2025, uključujući oba datuma.
SELECT match_id, kickoff_ts, home_team, away_team
FROM matches_flat
WHERE kickoff_ts >=('2025-01-01') AND kickoff_ts <('2025-01-16');

--5. Prebrojte utakmice odigrane petkom. Prikažite datum i dan u nedelji za svaku od njih.
SELECT COUNT(*) AS friday_matches
FROM matches_flat
WHERE DAYOFWEEK(kickoff_ts) = 6;

SELECT 
    DATE(kickoff_ts) AS match_date,
    DATE_FORMAT(kickoff_ts, 'EEEE') AS weekday_name
FROM matches_flat
WHERE DAYOFWEEK(kickoff_ts) = 6;

--6. Koliko utakmica sezone `2024/25` je imalo između 20.000 i 35.000 gledalaca, uključujući obe granice?

SELECT COUNT(*) AS total_matches
FROM matches_flat
WHERE season = '2024/25' AND
attendance BETWEEN 20000 AND 35000;
-- Komentar: 188 utakmica sezone `2024/25` je imalo između 20.000 i 35.000 gledalaca, uključujući obe granice.

--7. Pronađite strelce prvog gola čije ime počinje slovom `A` ili sadrži crticu. Prikažite samo različita imena.
SELECT DISTINCT first_goal_scorer
FROM matches_flat
WHERE first_goal_scorer LIKE('A%') OR first_goal_scorer LIKE('%-%');

--8. Prikažite utakmice sezone `2024/25` koje su počele između 18:00 i 21:00, uključujući obe granice. Prikažite vreme početka i nazive timova.
SELECT season, 
DATE_FORMAT(kickoff_ts, 'HH:mm:ss') AS kickoff_time, 
home_team, away_team
FROM matches_flat
WHERE season = '2024/25' 
    AND DATE_FORMAT(kickoff_ts, 'HH:mm:ss') BETWEEN '18:00:00' AND '21:00:00';

--9. Prebrojte utakmice odigrane u martu, aprilu ili maju 2025. godine čiji naslov sadrži reč `win` , bez obzira na veličinu slova.

SELECT COUNT(*) AS total_matches
FROM matches_flat
WHERE kickoff_ts >= '2025-03-01' AND kickoff_ts < '2025-06-01' AND
match_report ILIKE '%win%';
-- Komentar: Postoji 5 utakmica odigranih u martu, aprilu ili maju 2025. godine čiji naslov sadrži reč `win` , bez obzira na veličinu slova.

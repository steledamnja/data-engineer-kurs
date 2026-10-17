-- Domaći zadatak 2.1 Datum: 15.10.2026. SQL - Fudbalske utakmice

-- Zadatak 1. Dodajte kolonu empty_seats (kapacitet stadiona minus poseta) i prikažite 5 utakmica sa najviše praznih mesta. Šta je zajedničko prvim trima?

SELECT 
home_team, away_team,
stadium_capacity - attendance AS empty_seats, 
stadium_capacity, attendance
FROM bootcamp.northern_star.matches_flat
ORDER BY empty_seats DESC
LIMIT 5;
-- Komentar: Zajednicko primjenjivanje je da je stadium_capacity 80 000.

-- Zadatak 2. Koliko različitih sudija je sudilo domaće utakmice kluba Riverton Athletic?

SELECT DISTINCT referee_id, referee_name
FROM bootcamp.northern_star.matches_flat
WHERE home_team = 'Riverton Athletic';
-- Komentar: 15 različitih sudija je sudilo domaće utakmice kluba Riverton Athletic.

-- Zadatak 3. U koliko utakmica je gost vodio na poluvremenu, a domaćin na kraju pobedio?

SELECT home_goals_ht, away_goals_ht, home_goals, away_goals
FROM bootcamp.northern_star.matches_flat
WHERE home_goals_ht < away_goals_ht AND home_goals > away_goals;
-- Komentar: U 15 utakmica je gost vodio na poluvremenu, a domaćin na kraju pobedio.

-- Zadatak 4. U kojoj utakmici je palo najviše golova u drugom poluvremenu? Ko je igrao, rezultat na poluvremenu i rezultat na kraju?

SELECT 
 home_team, away_team, home_goals_ht, away_goals_ht, home_goals, away_goals,
 (home_goals - home_goals_ht) + (away_goals - away_goals_ht) AS total_goals_II
FROM bootcamp.northern_star.matches_flat
ORDER BY total_goals_II DESC
LIMIT 1;
-- Komentar: Northport United protiv Newbury Forest je palo najviše golova u drugom poluvremenu, 8. Rezultat na poluvremenu je bio 1:0 i rezultat na kraju 6:3.

-- Zadatak 5. Koliko utakmica sezone 2023/24 je odigrano po snegu ili magli?

SELECT season, weather 
FROM bootcamp.northern_star.matches_flat
WHERE season = '2023/24' 
AND weather IN ('snow', 'fog');
-- Komentar: 25 utakmica sezone 2023/24 je odigrano po snegu ili magli

-- Zadatak 6. Prikažite sve utakmice gradskog derbija između Northport United i Northport City, bez obzira na to ko je domaćin, sortirane po datumu. Ko je pobedio u kom meču?

SELECT match_id, season, kickoff_ts, home_team, away_team, home_goals, away_goals
FROM bootcamp.northern_star.matches_flat
WHERE home_team = 'Northport United' AND away_team = 'Northport City' OR
 home_team = 'Northport City' AND away_team = 'Northport United' 
 ORDER BY kickoff_ts;
 -- Komentar: Northport United, nereseno, Northport City, Northport United 

 -- Zadatak 7. Prikažite prve 3 utakmice sezone 2024/25 po vremenu početka. Da li možete biti sigurni koja je druga, a koja treća? Kako biste to obezbedili?

SELECT match_id, season, kickoff_ts, home_team, away_team
FROM bootcamp.northern_star.matches_flat
WHERE season = '2024/25' 
ORDER BY kickoff_ts, match_id LIMIT 3;
-- Komentar: Dodajemo match id kao drugi kriterijum sortiranja da bismo obezbedili jasan redosled

-- Zadatak 8. Prikažite sve utakmice u kojima je prvi gol dao Sean O'Neill. Koliko ih je?

SELECT match_id, first_goal_scorer, home_team, away_team
FROM bootcamp.northern_star.matches_flat
WHERE first_goal_scorer = "Sean O'Neill";
-- Komentar: U dve utakmice je prvi gol dao Sean O'Neill.
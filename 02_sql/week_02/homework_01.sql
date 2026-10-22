USE bootcamp.northern_star;

SELECT * FROM matches_flat;

-- 1. Za svaku sezonu prikažite ukupan broj utakmica, ukupan broj postignutih golova i prosečan broj golova po utakmici.

SELECT season, 
    COUNT(*) AS total_matches, 
    SUM(home_goals + away_goals) AS total_goals, 
    ROUND(AVG(home_goals + away_goals), 2) AS avg_goals
FROM matches_flat
GROUP BY season
ORDER BY season;

-- 2. Za svaki stadion prikažite najmanju, najveću i prosečnu zabeleženu posetu, kao i broj utakmica za koje je poseta poznata.

SELECT stadium_name,
    MIN(attendance) AS min_attendance,
    MAX(attendance) AS max_attendance,
    ROUND(AVG(attendance), 2) AS avg_attendance,
    COUNT(attendance) AS reported_matches
FROM matches_flat
GROUP BY stadium_name
ORDER BY stadium_name;

-- 3. Prikažite sudije koje su sudile najmanje 10 utakmica i koje su ukupno pokazale najmanje 20 žutih kartona. Prikažite ime sudije, broj utakmica i ukupan broj žutih kartona.

SELECT referee_name,
    COUNT(*) AS total_matches,
    SUM(
        COALESCE(home_yellow_cards, 0) +
        COALESCE(away_yellow_cards, 0)) AS total_yellow_cards
FROM matches_flat
WHERE status = 'played'
AND referee_name IS NOT NULL
GROUP BY referee_name
HAVING COUNT(*) >= 10 AND total_yellow_cards >= 20
ORDER BY total_yellow_cards DESC;

-- 4. Podelite utakmice prema ukupnom broju golova na kategorije Bez golova (0), Malo golova (1 ili 2) i Mnogo golova (3 ili više). Prikažite broj utakmica u svakoj kategoriji i najveći broj golova na utakmici u toj kategoriji.

SELECT
    CASE
        WHEN home_goals + away_goals = 0 THEN 'Bez golova'
        WHEN home_goals + away_goals BETWEEN 1 AND 2 THEN 'Malo golova'
        ELSE 'Mnogo golova'
    END AS goal_category,
COUNT(*) AS total_matches,
MAX(home_goals + away_goals) AS max_goals
FROM matches_flat
WHERE home_goals IS NOT NULL
AND away_goals IS NOT NULL
GROUP BY goal_category
ORDER BY max_goals;

-- 5. Za svaki klub prikažite broj utakmica koje je odigrao kao domaćin, broj pobeda kod kuće i broj poraza kod kuće. U rezultat uključite samo klubove koji su kod kuće odigrali najmanje 10 utakmica.

SELECT home_team,
    COUNT(*) AS home_matches,
    SUM(
        CASE
            WHEN home_goals > away_goals THEN 1
            ELSE 0
        END) AS home_wins,
    SUM(
        CASE
            WHEN home_goals < away_goals THEN 1
            ELSE 0
        END) AS home_losses
FROM matches_flat
WHERE status = 'played'
GROUP BY home_team
HAVING COUNT(*) >= 10
ORDER BY home_wins DESC;

-- 6. Za svakog sudiju prikažite ukupan broj utakmica, broj utakmica u kojima je pokazao bar jedan crveni karton i procenat takvih utakmica u odnosu na sve utakmice koje je sudio.

SELECT referee_name,
    COUNT(*) AS total_matches,
    SUM(
        CASE
            WHEN COALESCE(home_red_cards, 0) + COALESCE(away_red_cards, 0) >= 1 THEN 1
            ELSE 0
        END) AS matches_with_red_card,
    ROUND(100.0 * SUM(
        CASE
            WHEN COALESCE(home_red_cards, 0) + COALESCE(away_red_cards, 0) >= 1 THEN 1
            ELSE 0
         END) / COUNT(*),2) AS red_card_percentage
FROM matches_flat
WHERE status = 'played'
AND referee_name IS NOT NULL
GROUP BY referee_name
ORDER BY red_card_percentage DESC;

-- 7. Za svaku sezonu prikažite broj pobeda domaćina, broj nerešenih utakmica i broj pobeda gostiju. Takođe prikažite procenat utakmica koje su završene nerešenim rezultatom.

SELECT season,
    SUM(
        CASE
            WHEN home_goals > away_goals THEN 1
            ELSE 0
        END) AS home_wins,
    SUM(
        CASE
            WHEN home_goals = away_goals THEN 1
            ELSE 0
        END) AS draws,
    SUM(
        CASE
            WHEN home_goals < away_goals THEN 1
            ELSE 0
        END) AS away_wins,
ROUND(100.0 * SUM(
    CASE
        WHEN home_goals = away_goals THEN 1
        ELSE 0
    END) / COUNT(*),2) AS draw_percentage
FROM matches_flat
WHERE status = 'played'
GROUP BY season
ORDER BY season;

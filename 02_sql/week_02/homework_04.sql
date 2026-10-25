-- Вежба 2 — досије клуба
-- Изаберите један клуб и анализирајте његову сезону 2024/25. Сваки упит почните истим кораком, тако да
-- за други клуб мењате само име:
-- WITH club AS (
-- SELECT team_id FROM teams WHERE team_name = 'име вашег клуба'
-- )
-- SELECT ...
-- 1. Сезона у бројевима: утакмице, победе, нерешене, порази, дати и примљени голови, бодови.

WITH club AS (
    SELECT team_id
    FROM teams
    WHERE team_name = 'Northport United'
    ),

club_matches AS (
    SELECT
        m.match_id,

    CASE
        WHEN m.home_team_id = c.team_id THEN m.home_goals
        ELSE m.away_goals
    END AS goals_for,

    CASE
        WHEN m.home_team_id = c.team_id THEN m.away_goals
        ELSE m.home_goals
        END AS goals_against

    FROM matches m
    INNER JOIN club c
        ON m.home_team_id = c.team_id
        OR m.away_team_id = c.team_id

WHERE m.season = '2024/25'
    AND m.status = 'played'
)

SELECT
    COUNT(*) AS total_matches,

    SUM(CASE
        WHEN goals_for > goals_against THEN 1
        ELSE 0
    END) AS wins,

    SUM(CASE
        WHEN goals_for = goals_against THEN 1
        ELSE 0
    END) AS draws,

    SUM(CASE
        WHEN goals_for < goals_against THEN 1
        ELSE 0
    END) AS losses,

SUM(goals_for) AS goals_scored,

SUM(goals_against) AS goals_conceded,

SUM(CASE
        WHEN goals_for > goals_against THEN 3
        WHEN goals_for = goals_against THEN 1
    ELSE 0
    END) AS total_points

FROM club_matches;

-- 2. Код куће и у гостима: исти бројеви, одвојено за домаће и гостујуће утакмице.

WITH club AS (
    SELECT team_id
    FROM teams
    WHERE team_name = 'Northport United'
),

club_matches AS (
    SELECT
    'Home' AS venue,
    m.home_goals AS goals_for,
    m.away_goals AS goals_against

    FROM matches m
    INNER JOIN club c
        ON m.home_team_id = c.team_id

    WHERE m.season = '2024/25'
        AND m.status = 'played'

    UNION ALL

    SELECT
        'Away' AS venue,
        m.away_goals AS goals_for,
        m.home_goals AS goals_against

    FROM matches m
    INNER JOIN club c
        ON m.away_team_id = c.team_id

    WHERE m.season = '2024/25'
        AND m.status = 'played'
    )

SELECT
    venue,
    COUNT(*) AS total_matches,

    SUM(CASE
        WHEN goals_for > goals_against THEN 1
        ELSE 0
    END) AS wins,

    SUM(CASE
        WHEN goals_for = goals_against THEN 1
        ELSE 0
    END) AS draws,

    SUM(CASE
        WHEN goals_for < goals_against THEN 1
        ELSE 0
    END) AS losses,

    SUM(goals_for) AS goals_scored,

    SUM(goals_against) AS goals_conceded,

    SUM(CASE
        WHEN goals_for > goals_against THEN 3
        WHEN goals_for = goals_against THEN 1
        ELSE 0
    END) AS total_points

FROM club_matches

GROUP BY venue
ORDER BY venue;

-- 3. Стрелци: три најбоља стрелца клуба и најбољи асистент.

-- tri najbolja strelca kluba

WITH club AS (
    SELECT team_id
    FROM teams
    WHERE team_name = 'Northport United'
),

club_goals AS (
    SELECT
        e.player_id,
        COUNT(*) AS total_goals

    FROM match_events e

    INNER JOIN matches m
        ON e.match_id = m.match_id

    INNER JOIN club c
        ON e.team_id = c.team_id

    WHERE m.season = '2024/25'
        AND e.event_type IN ('goal', 'penalty_goal')

    GROUP BY e.player_id
        )

SELECT
    p.first_name,
    p.last_name,
    cg.total_goals

FROM club_goals cg

INNER JOIN players p
    ON cg.player_id = p.player_id

ORDER BY
cg.total_goals DESC,
p.player_id
LIMIT 3;

-- Najbolji asistent kluba

WITH club AS (
    SELECT team_id
    FROM teams
    WHERE team_name = 'Northport United'
    ),

club_assists AS (
    SELECT
        e.related_player_id AS player_id,
        COUNT(*) AS total_assists

    FROM match_events e

    INNER JOIN matches m
        ON e.match_id = m.match_id

    INNER JOIN club c
        ON e.team_id = c.team_id

    WHERE m.season = '2024/25'
        AND e.event_type = 'goal'
        AND e.related_player_id IS NOT NULL

    GROUP BY e.related_player_id
        )

SELECT
    p.first_name,
    p.last_name,
    ca.total_assists

FROM club_assists ca

INNER JOIN players p
    ON ca.player_id = p.player_id

ORDER BY
    ca.total_assists DESC,
    p.player_id

LIMIT 1;
-- 4. Дисциплина: картони клуба по утакмици у поређењу са просеком лиге по тиму по утакмици.

WITH club AS (
    SELECT team_id
    FROM teams
    WHERE team_name = 'Northport United'
),

season_matches AS (
    SELECT
        match_id,
        home_team_id,
        away_team_id

    FROM matches
    WHERE season = '2024/25'
        AND status = 'played'
    ),

cards AS (
    SELECT
        e.match_id,
        e.team_id

    FROM match_events e

    INNER JOIN season_matches m
        ON e.match_id = m.match_id

    WHERE e.event_type IN (
        'yellow_card',
        'second_yellow',
        'red_card'
    )
        ),

club_stats AS (
    SELECT
        c.team_id,
        COUNT(*) AS total_matches

    FROM club c

    INNER JOIN season_matches m
        ON c.team_id = m.home_team_id
        OR c.team_id = m.away_team_id

    GROUP BY c.team_id
        ),

    club_cards AS (
    SELECT
        c.team_id,
        COUNT(e.match_id) AS total_cards

    FROM club c

    LEFT JOIN cards e
        ON c.team_id = e.team_id

    GROUP BY c.team_id
        ),

league_stats AS (
    SELECT
        (
            SELECT COUNT(*)
            FROM cards
        ) AS league_cards,

        (
            SELECT COUNT(*)
            FROM season_matches
        ) AS league_matches
        )

SELECT
    cc.total_cards AS club_total_cards,

    cs.total_matches AS club_total_matches,

    ROUND(
    TRY_DIVIDE(
        cc.total_cards,
        cs.total_matches), 2
    ) AS club_cards_per_match,

    ROUND(
    TRY_DIVIDE(
        ls.league_cards,
        ls.league_matches * 2), 2
    ) AS league_cards_per_team_match

FROM club_cards cc

INNER JOIN club_stats cs
    ON cc.team_id = cs.team_id

CROSS JOIN league_stats ls;

-- 5. Тренери: ко је водио клуб у сезони и са колико бодова по утакмици.

WITH club AS (
    SELECT team_id
    FROM teams
    WHERE team_name = 'Northport United'
),

manager_matches AS (
    SELECT
        ms.spell_id,
        ms.manager_name,
        m.match_id,

        CASE
            WHEN (m.home_team_id = c.team_id
                AND m.home_goals > m.away_goals
            )
            OR (
                m.away_team_id = c.team_id
                AND m.away_goals > m.home_goals
                )
            THEN 3

            WHEN m.home_goals = m.away_goals
            THEN 1

            ELSE 0
        END AS points

    FROM club c

    INNER JOIN manager_spells ms
        ON c.team_id = ms.team_id

    INNER JOIN matches m
        ON (
            m.home_team_id = c.team_id
            OR m.away_team_id = c.team_id
            )

        AND DATE(m.kickoff_ts) >= ms.start_date

        AND (
            ms.end_date IS NULL
            OR DATE(m.kickoff_ts) <= ms.end_date
            )

    WHERE m.season = '2024/25'
    AND m.status = 'played'
        )

SELECT
    manager_name,

    COUNT(*) AS total_matches,

    SUM(points) AS total_points,

    ROUND(
        AVG(points),
        2
    ) AS points_per_match

FROM manager_matches

GROUP BY
spell_id,
manager_name

ORDER BY points_per_match DESC;

-- 6. Највећа победа и најтежи пораз.

WITH club AS (
    SELECT team_id
    FROM teams
    WHERE team_name = 'Northport United'
),

club_matches AS (
    SELECT
        m.match_id,
        m.kickoff_ts,

        CASE
            WHEN m.home_team_id = c.team_id
            THEN m.away_team_id
            ELSE m.home_team_id
        END AS opponent_id,

        CASE
            WHEN m.home_team_id = c.team_id
            THEN m.home_goals
            ELSE m.away_goals
        END AS goals_for,

        CASE
            WHEN m.home_team_id = c.team_id
            THEN m.away_goals
            ELSE m.home_goals
        END AS goals_against

    FROM matches m

    INNER JOIN club c
        ON m.home_team_id = c.team_id
        OR m.away_team_id = c.team_id

    WHERE m.season = '2024/25'
        AND m.status = 'played'
            ),

goal_differences AS (
    SELECT
        *,
        goals_for - goals_against AS goal_difference
    FROM club_matches
        ),

extremes AS (
    SELECT
        MAX(
            CASE
                WHEN goal_difference > 0
                THEN goal_difference
            END
            ) AS biggest_win,

        MIN(
            CASE
                WHEN goal_difference < 0
                THEN goal_difference
            END
            ) AS heaviest_loss

    FROM goal_differences
        )

SELECT
    CASE
        WHEN gd.goal_difference = e.biggest_win
        THEN 'Biggest win'
        ELSE 'Heaviest loss'
    END AS result_category,

    DATE(gd.kickoff_ts) AS match_date,

    t.team_name AS opponent,

    gd.goals_for,
    gd.goals_against,
    gd.goal_difference

FROM goal_differences gd

CROSS JOIN extremes e

INNER JOIN teams t
    ON gd.opponent_id = t.team_id

WHERE gd.goal_difference = e.biggest_win
    OR gd.goal_difference = e.heaviest_loss

ORDER BY gd.goal_difference DESC;

-- 7. Публика: просечна посета и попуњеност на домаћим утакмицама, и колико утакмица нема податак о посети.

WITH club AS (
    SELECT team_id
    FROM teams
    WHERE team_name = 'Northport United'
),

home_matches AS (
    SELECT
        m.match_id,
        m.attendance,
        s.capacity

    FROM matches m

    INNER JOIN club c
        ON m.home_team_id = c.team_id

    LEFT JOIN stadiums s
        ON m.stadium_id = s.stadium_id

    WHERE m.season = '2024/25'
        AND m.status = 'played'
        )

SELECT
    COUNT(*) AS total_home_matches,

    ROUND(
        AVG(attendance),
        2
    ) AS avg_attendance,

    ROUND(
        AVG(
        100.0 * TRY_DIVIDE(
            attendance,
            capacity
            )
        ),
        2
        ) AS avg_occupancy_percentage,

    SUM(
        CASE
        WHEN attendance IS NULL
        THEN 1
        ELSE 0
    END
    ) AS missing_attendance

FROM home_matches;
import pandas as pd

R = "/Volumes/bootcamp/northern_star/raw_2025_26/"
m = pd.read_parquet(R + "matches_2025_26.parquet")

# 1. Analiza rezultata utakmica

# 1.Pronaći sve utakmice u kojima su oba tima postigla bar po
# jedan gol.

m.loc[(m["home_goals"] >= 1) & (m["away_goals"] >= 1)]

# 2.Pronaći sve utakmice u kojima je domaćin pobedio sa tačno
# jednim golom razlike.

m.loc[m["home_goals"] - m["away_goals"] == 1]

# 3.Koliko utakmica je završeno rezultatom 0:0?

len(m.loc[(m["home_goals"] == 0) & (m["away_goals"] == 0)])

# 4.Prikazati 10 utakmica sa najviše ukupno postignutih golova.

m["total_goals"] = m["home_goals"] + m["away_goals"]

m.nlargest(10, "total_goals")[
    ["match_id", "home_team", "away_team",
     "home_goals", "away_goals", "total_goals"]
]

# 2. Analiza jednog tima
# Za tim po izboru:
# 1.Prikazati sve utakmice u kojima je učestvovao.

team = "NPM"

team_matches = m.loc[
    (m["home_team"] == team) |
    (m["away_team"] == team)
].copy()

print(team_matches)

# 2.Koliko je puta pobedio, izgubio i odigrao nerešeno?

home_win = (
    (team_matches["home_team"] == team) &
    (team_matches["home_goals"] > team_matches["away_goals"])
)

away_win = (
    (team_matches["away_team"] == team) &
    (team_matches["away_goals"] > team_matches["home_goals"])
)

draw = (
    team_matches["home_goals"] == team_matches["away_goals"]
)

team_matches["result"] = "L"
team_matches.loc[home_win | away_win, "result"] = "W"
team_matches.loc[draw, "result"] = "D"

print(team_matches["result"].value_counts())

# 3.Koliko je golova postigao kao domaćin, a koliko kao gost?

home_goals = team_matches.loc[
    team_matches["home_team"] == team,
    "home_goals"
].sum()

away_goals = team_matches.loc[
    team_matches["away_team"] == team,
    "away_goals"
].sum()

print("Goals scored at home:", home_goals)
print("Goals scored away:", away_goals)

# 4.Pronaći utakmicu u kojoj je postigao najviše golova.

team_matches["team_goals"] = team_matches["home_goals"]

team_matches.loc[
    team_matches["away_team"] == team,
    "team_goals"
] = team_matches["away_goals"]

print(
    team_matches.nlargest(1, "team_goals")
)

# 3. Analiza stadiona

# 1.Prikazati sve različite stadione na kojima su odigrane utakmice.

m["stadium"].unique()

# 2.Pronaći stadion na kojem je odigrano najviše utakmica.

m["stadium"].value_counts().nlargest(1)

# 3.Za svaki stadion izračunati prosečnu posećenost.

m.groupby("stadium")["attendance"].mean()

# 4.Prikazati pet stadiona sa najvećom prosečnom posećenošću.

m.groupby("stadium")["attendance"].mean().nlargest(5)

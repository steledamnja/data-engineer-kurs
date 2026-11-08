# 1. Написати функцију get_header(path: str) -> list која враћа заглавље CSV фајла Користити csv.reader и next()
# Input: 'data/raw/teams.csv'
# Output: ['team', 'city', 'points']

import csv

def get_header(path: str):
    with open(path, "r", encoding="utf-8", newline="") as f:
        reader = csv.reader(f)

        return next(reader)


print(get_header("/Volumes/workspace/default/python_files/data/raw/teams.csv"))

# 2. Написати функцију read_rows(path: str) -> list која враћа све редове CSV фајла беззаглавља, као листу листи
# Користити csv.reader
# Input: 'data/raw/teams.csv'
# Output: [['FK Jedinstvo', 'Bela Palanka', '34'], ['FK Radnički', 'Niš', '41'],['FK Rakovica', 'Beograd, Rakovica', '28'], ['FK Sloga', 'Kraljevo', '19']]

import csv

def read_rows(path: str):
    rows = []

    with open(path, "r", encoding="utf-8", newline="") as f:
        reader = csv.reader(f)
        next(reader)
        for row in reader:
            rows.append(row)

    return rows


print(read_rows("/Volumes/workspace/default/python_files/data/raw/teams.csv"))

# 3. Написати функцију total_points(path: str) -> int која враћа збир бодова свих тимова Користити csv.DictReader
# Input: 'data/raw/teams.csv' Output: 122

import csv

def total_points(path: str):
    total = 0

    with open(path, "r", encoding="utf-8", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            total += int(row["points"])

    return total


print(total_points("/Volumes/workspace/default/python_files/data/raw/teams.csv"))

# 4. Написати функцију write_rows(path: str, rows: list) -> None која листу листи уписује у CSVфајл
# Input: 'data/processed/people.csv' , [['name', 'age'], ['Ana', 20], ['Marko', 22]]
# Садржај фајла након позива: name,ageAna,20 Marko,22

import csv

def write_rows(path: str, rows: list):
    with open(path, "w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f)
        writer.writerows(rows)

rows = [
    ["name", "age"],
    ["Ana", 20],
    ["Marko", 22]
]

write_rows("/Volumes/workspace/default/python_files/data/processed/people.csv", rows)

# 5. Написати функцију write_dicts(path: str, rows: list) -> None која листу речника уписује уCSV фајл
# Користити csv.DictWriter ; заглавља су кључеви првог речника
# Input: 'data/processed/people.csv', [{'name': 'Ana', 'age': 20}, {'name':'Marko', 'age': 22}]
# Садржај фајла након позива: 
# name,age
# Ana,20
# Marko,22

import csv

def write_dicts(path: str, rows: list):
    with open(path, "w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)

rows = [
    {"name": "Ana", "age": 20},
    {"name": "Marko", "age": 22}
]

write_dicts("/Volumes/workspace/default/python_files/data/processed/people.csv", rows)

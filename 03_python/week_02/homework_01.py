# 1. Napisati funkciju safe_divide(a: float, b: float) -> float | None koja vraća rezultat deljenja dva broja.
# Ako je deljenje moguće, funkcija vraća rezultat. Ako pokušamo da delimo nulom, funkcija vraća None.
# Koristiti try i except.
# Primer:
# safe_divide(10, 2) # 5.0
# safe_divide(10, 0) # None

def safe_divide(a: float, b: float) -> float | None:
    try:
        return a/b
    except ZeroDivisionError:
        return None
    
print(safe_divide(10, 2))
print(safe_divide(10, 0))

# 2. Napisati funkciju safe_int(value: str) -> int | None koja
# pokušava da prosleđeni string pretvori u ceo broj.
# Ako string predstavlja ispravan ceo broj, funkcija vraća taj broj.
# Ako konverzija nije moguća, funkcija vraća None.
# Primer:
# safe_int('25') # 25
# safe_int('-10') # -10
# safe_int('abc') # None

def safe_int(value: str) -> int | None:
    try:
        return int(value)
    except ValueError:
        return None

print(safe_int('25'))
print(safe_int('-10'))
print(safe_int('abc'))

# 3. Napisati funkciju get_grade(grades: dict, student: str) -> int | None koja vraća ocenu studenta iz rečnika.
# Ako student postoji u rečniku, funkcija vraća njegovu ocenu.
# Ako student ne postoji, funkcija vraća None.
# Koristiti try i except.
# Primer:
# get_grade({'Ana': 5,'Marko': 4,'Jovana': 5},'Marko') # 4
# get_grade({'Ana': 5,'Marko': 4,'Jovana': 5},'Petar') # None

def get_grade(grades: dict, student: str) -> int | None:
    try:
        return grades[student] 
    except KeyError:
        return None

print(get_grade({'Ana': 5,'Marko': 4,'Jovana': 5},'Marko'))
print(get_grade({'Ana': 5,'Marko': 4,'Jovana': 5},'Petar'))

# 4. Napisati funkciju read_file(path: str) -> str koja čita i vraća kompletan sadržaj tekstualnog fajla.
# Ako fajl ne postoji, funkcija vraća poruku 'File not found.'.
# Koristiti try i except.
# Za otvaranje fajla koristiti with open().

import csv

def read_file(path: str) -> str:
    try:
        with open(path, 'r') as f:
            return f.read()

    except FileNotFoundError:
        return 'File not found.'

print(read_file('/Volumes/workspace/default/python_files/data/raw/teams.csv'))
print(read_file('/Volumes/workspace/default/python_files/data/raw/nema.csv'))
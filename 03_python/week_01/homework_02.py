# 1. Napisati funkciju get_even_positions(data: tuple) -> tuple koja vraća elemente torke koji se nalaze na parnim indeksima (0, 2, 4...).
# Input: (10, 20, 30, 40, 50, 60)
# Output: (10, 30, 50)

def get_even_positions(data: tuple):
    return data[::2]

numbers = (10, 20, 30, 40, 50, 60)

print(get_even_positions(numbers))

# 2. Napisati funkciju find_exclusive_students(group1: set, group2:set) -> set koja vraća studente koji se nalaze u prvoj grupi, ali ne i u drugoj.
# Input: 
# {'Ana',Marko','Jovan','Milica'},
# {'Marko','Milica','Petar'}
# Output: {'Ana','Jovan'}

def find_exclusive_students(group1: set, group2: set):
    return group1 - group2

group1 = {"Ana", "Marko", "Jovan", "Milica"}
group2 = {"Marko", "Milica", "Petar"}

print(find_exclusive_students(group1, group2))

# 3. Napisati funkciju clean_tags(text: str) -> str koja obrađuje tekst sa tagovima.
# Potrebno je:
# Razdvojiti tagove koji su odvojeni karakterom |
# Ukloniti početne i krajnje razmake svakog taga
# Sva slova pretvoriti u mala slova
# Spojiti tagove karakterom -
# Input:
# ' Python | DATA | SQL ' 
# Output:
# 'python-data-sql'

def clean_tags(text: str):
    tags = text.split("|")
    cleaned_tags = []

    for tag in tags:
        cleaned_tags.append(tag.strip().lower())

    return "-".join(cleaned_tags)

text = " Python | DATA | SQL "

print(clean_tags(text))


# 4. Napisati funkciju count_products(csv_lines: list) -> dict koja analizira porudžbine iz CSV podataka i vraća ukupan broj naručenih proizvoda. Svaki red sadrži ime kupca, naziv proizvoda i količinu, razdvojene zarezom. Prvi red predstavlja zaglavlje i treba ga zanemariti. Ako se isti proizvod pojavljuje u više redova, sabrati njegove količine.
# Input: 'customer,product,quantity','Alice,laptop,2','Bob,mouse,3','Alice,laptop,1','Charlie,keyboard,2','Bob,mouse,1']
# Output: {'laptop': 3,'mouse': 4,'keyboard': 2}

def count_products(csv_lines: list):
    products = {}

    for line in csv_lines[1:]:
        cols = line.split(",")
        product = cols[1]
        quantity = int(cols[2])
        products[product] = products.get(product, 0) + quantity

    return products


csv_lines = [
    "customer,product,quantity",
    "Alice,laptop,2",
    "Bob,mouse,3",
    "Alice,laptop,1",
    "Charlie,keyboard,2",
    "Bob,mouse,1"
]

print(count_products(csv_lines))
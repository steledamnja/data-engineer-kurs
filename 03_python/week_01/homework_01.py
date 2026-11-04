# 1. Napisati program kojim se prevodi temperatura iz Celzijusove skale u Farenhajtovu skalu, ako je odgovarajuca formula oblika T [◦F] = T [◦C]· 1.80 + 32. Na ulazu se unosi vrednost temperature u stepenima Celzijusa (realan broj) a ispisuje se vrednost temperature u stepenima Farenhajta.

def celsius_to_fahrenheit(temperature):
    return temperature * 1.8 + 32

print(celsius_to_fahrenheit(32.5))

# 2. Napisati program koji za uneti redni broj dana u nedelji (od 1 do 7) ispisuje naziv tog dana (ponedeljak - nedelja). Ukoliko je unet broj koji nije izmedju 1 i 7, ispisati Pogresan unos.

days = ('Ponedeljak', 'Utorak', 'Sreda', 'Cetvrtak', 'Petak', 'Subota', 'Nedelja')

def day_of_the_week(day):
    if day not in range(1, 8):
        return 'Pogresan unos.'
    return days[day - 1]
    
print(day_of_the_week(7))

# 3. Napisati program koji racuna najveci negativni element u listi.

numbers = [-1, -3, -7, 5, 8, 10]
negative_numbers = []
for number in numbers:
    if number < 0:
        negative_numbers.append(number)
if not negative_numbers:
    print('Nema negativnih brojeva')
else:
    print(max(negative_numbers))


# 4. Napisati program koji racuna broj parnih elemenata date liste.

count = 0
numbers = [1, 3, 5, 7, 8, 10]

for number in numbers:
    if number % 2 == 0:
        count += 1

print(count)

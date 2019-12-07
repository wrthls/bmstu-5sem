import random
# SHno SHname SHcity SHrating


def main():
    qty = 1000

    file = open("SH_table.txt", "w")

    cities = open("city_list.txt", 'r')
    cities_array = cities.readlines()
    cities.close()

    names = open("words.txt", 'r')
    names_array = names.readlines()
    names.close()

    for i in range (1, qty + 1):
        name_number = random.randint(0, len(names_array) - 1)
        city_number = random.randint(0, len(cities_array) - 1)
        rating = random.randint(1, 10)
        file.write(str(i) +
                   ',' +
                   names_array[name_number][:-1] +
                   ',' +
                   cities_array[city_number][:-1] +
                   ',' +
                   str(rating) +
                   ';'
                   )

    file.close()


if __name__ == '__main__':
    main()
import random

def get_symbol_string(i, name_array_len):
    # A = 65, Z = 90
    i = i // name_array_len

    first = i // 26
    second = i % 26

    s = chr(65 + first) + chr (65 + second)

    return s


def main():
    qty = 1000

    name_array = ["Records",
                  "Music",
                  "Vinyl",
                  "Rock",
                  "Universal",
                  "Chord",
                  "Note",
                  "Player",
                  "Instrumental",
                  "Voice"]

    file = open("S_table.txt", "w")
    file_city = open("city_list.txt", "r")
    city_lines = file_city.readlines()
    file_city.close()

    for i in range(1, qty + 1):
        city_num = random.randint(0, len(city_lines) - 1)

        file.write(str(i) +
                   ',' +
                   get_symbol_string(i, len(name_array)) +
                   name_array[i % len(name_array)] +
                   ',' +
                   city_lines[city_num][:-1]+
                   ';')
    file.close()


if __name__ == '__main__':
    main()
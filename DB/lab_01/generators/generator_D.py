import random
# Dno Dname Dmusician Dgenre Dweight


def main():
    qty = 1000

    file = open("D_table.txt", "w")

    genres = ["Rock",
              "Pop",
              "Hip-Hop",
              "Rap",
              "Electronic",
              "House",
              "Techno",
              "Classical",
              "Jazz",
              "Blues",
              "Metal",
              "Punk",
              "Ambient",
              "Country"]

    musicians = open ("names.txt", 'r')
    musicians_array = musicians.readlines()
    musicians.close()

    names = open("words.txt", 'r')
    names_array = names.readlines()
    names.close()

    for i in range (1, qty + 1):
        name_number = random.randint(0, len(names_array) - 1)
        musician_number = random.randint(0, len(musicians_array) - 1)
        genre_number = random.randint(0, len(genres) - 1)
        weight = random.randint(200, 400)
        file.write(str(i) +
                   ',' +
                   names_array[name_number][:-1] +
                   ',' +
                   musicians_array[musician_number][:-1] +
                   ',' +
                   genres[genre_number] +
                   ',' +
                   str(weight) +
                   ';'
                   )

    file.close()


if __name__ == '__main__':
    main()
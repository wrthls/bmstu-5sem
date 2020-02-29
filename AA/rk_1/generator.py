import random


def main():
    file = open("table.txt", 'w')
    lines = 1000
    for i in range(1, lines + 1):

        phrase_id = i
        user_id = random.randint(1, 100)
        paragraph_id = random.randint(1, 100)
        file.write(str(phrase_id) + ' ' + str(user_id) + ' ' + str(paragraph_id) + '\n')
    file.close()


if __name__ == "__main__":
    main()

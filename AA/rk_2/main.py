import re


def get_symb_type(char):
    if len(char) == 0:
        return -1
    if char == '.':
        return 'dot'
    elif char == ' ':
        return 'space'
    elif ord('А') <= ord(char) <= ord('Я') or char == 'Ё':
        return 'capital'
    elif ord('а') <= ord(char) <= ord('я') or char == 'ё':
        return 'char'
    elif char == '\n':
        return 'n'
    else:
        return 'other'


def main():
    print("Конечный автомат:")
    file = open("data_1.txt", 'r')
    char = 1
    cnt = 0
    pos = 'begin'
    while char:
        char = file.read(1)
        cnt += 1

        type = get_symb_type(char)

        if pos == 'begin':
            if type == 'capital':
                pos = 'first_capital'
                first_symb = cnt

        elif pos == 'first_capital':
            if type == 'dot':
                pos = '1_dot_after_capital'
            elif type == 'char':
                pos = '2_char_after_capital'
            else:
                pos = 'begin'

        elif pos == '1_dot_after_capital':
            if type == 'space':
                continue
            elif type == 'capital':
                pos = '1_surname_capital'
            else:
                pos = 'begin'

        elif pos == '1_surname_capital':
            if type == 'char':
                pos = '1_char_after_surname_capital'
            elif type == 'dot':
                pos = '1_dot_after_capital'
            else:
                pos = 'begin'

        elif pos == '1_char_after_surname_capital':
            if type == 'char':
                continue
            else:
                pos = 'end'
                last_symb = cnt

        # '2_char_after_capital': 5,
        elif pos == '2_char_after_capital':
            if type == 'space':
                pos = '2_space_found'
            elif type == 'char':
                continue
            else:
                pos = 'begin'

        # '2_space_found': 6,
        elif pos == '2_space_found':
            if type == 'capital':
                pos = '2_capiatl_found_1'
            else:
                pos = 'begin'

        # '2_capiatl_found_1': 6,
        elif pos == '2_capiatl_found_1':
            if type == 'dot':
                pos = '2_dot_found_1'
            else:
                pos = 'begin'

        # '2_dot_found_1': 8,
        elif pos == '2_dot_found_1':
            if type == 'space':
                continue
            elif type == 'capital':
                pos = '2_capiatl_found_2'
            else:
                pos = 'begin'

        # '2_capiatl_found_2': 9,
        elif pos == '2_capiatl_found_2':
            if type == 'dot':
                pos = '2_dot_found_2'
            else:
                pos = 'begin'

        # '2_dot_found_2': 10,
        elif pos == '2_dot_found_2':
            pos = 'end'
            last_symb = cnt

        # 'end': 11
        elif pos == 'end':
            print("символы с", first_symb, "по", last_symb,": ", end='')

            with open("data_1.txt", "r") as f:
                print(f.read()[first_symb - 1:last_symb -1])

            pos = 'begin'

    file.close()

    print()
    print("Регулярные выражения:")
    with open("data_1.txt", "r") as f:
        s = f.read()

    sm = 0
    while True:
        result = re.search(r'(([А-Я]\.\s?[А-Я]\.\s?[А-Я][а-я]{1,20})|([А-Я][а-я]{1,20}\s[А-Я]\.\s?[А-Я]\.))', s)

        if result is None:
            break
        print("Символы с %d до %d: "%(result.start()+1+sm, result.end()+1+sm) + s[result.start():result.end()])
        s = s[result.end():]
        sm += result.end()


if __name__ == '__main__':
    main()
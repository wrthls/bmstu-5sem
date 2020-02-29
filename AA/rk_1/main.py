def main():

    file = open("table.txt", 'r')
    table = [line.split() for line in file]
    for i in range(len(table)):
        table[i] = [int(x) for x in table[i]]

    # 0: phrase; 1: user; 2: paragraph;
    table = sorted(table, key=lambda line: line[2])

    cnt = 0
    prev_paragraph = 1
    for i in range(len(table)):
        paragraph = table[i][2]
        if paragraph == prev_paragraph:
            cnt += 1
        else:
            if 1 < cnt < 5:
                if cnt == 2:
                    print("Двойка ", end='')
                elif cnt == 3:
                    print("Тройка ", end='')
                elif cnt == 4:
                    print("Четверка ", end='')
                print("пользователей (", end='')

                for j in range(cnt):
                    print(table[i - cnt + j][1], end='')
                    if j != cnt - 1:
                        print(',', end='')
                print(') размечала параграф номер', table[i][2])

            cnt = 0
        prev_paragraph = paragraph


if __name__ == "__main__":
    main()

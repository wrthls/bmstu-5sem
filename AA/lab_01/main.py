# AA lab_01 Levenstein
# Yana Makovskaya


def get_regime():
    print()
    while True:
        print(" Выберите режим работы! ")
        print(" [U] Пользовательский ")
        print(" [E] Экспериментальный ")
        print(" Введите букву: ", end='')

        answer = input().lower()

        if answer != 'u' and answer != 'e':
            print(" Некорректный ввод, повторите попытку \n")
            continue

        print()
        return answer


def get_algorithm():
    while True:
        print(" Выберите алгоритм!  ")
        print(" [1] Вычислить расстояние Левенштейна (матрица)")
        print(" [2] Вычислить расстояние Дамерау-Левенштейна (матрица)")
        print(" [3] Вычислить расстояние Дамерау-Левенштейна (рекурсия)")
        print(" Введите цифру: ", end='')
        answer = input()

        if not answer.isdigit():
            print(" Некорректный ввод, повторите попытку \n")
            continue

        answer = int(answer)

        if answer < 1 or answer > 3:
            print(" Некорректный ввод, повторите попытку \n")
            continue

        print()
        return answer


def execute(regime, algorithm):
    print("\n Введите первую строку: \n ", end='')
    s1 = input()
    print(" Введите вторую строку: \n ", end='')
    s2 = input()

    levenstein(s1, s2)


def print_matrix(matrix):
    for j in range(len(matrix)):
        for k in range(len(matrix[j])):
            print(matrix[j][k], ' ', end='')
        print()
    print()


def levenstein(s1, s2):
    len_1 = len(s1)
    len_2 = len(s2)

    matrix = []
    for i in range(len_1 + 1):
        matrix.append([0 for _ in range(len_2 + 1)])

    for i in range(len_2 + 1):
        matrix[0][i] = i

    for i in range(1, len_1 + 1):
        matrix[i][0] = i
        for j in range(1, len_2 + 1):
            if s1[i - 1] == s2[j - 1]:
                matrix[i][j] = matrix[i-1][j-1]
            else:
                matrix[i][j] = min(matrix[i - 1][j], matrix[i][j - 1], matrix[i - 1][j - 1]) + 1

    print_matrix(matrix)


def main():
    while True:
        regime = get_regime()
        algorithm = get_algorithm()
        execute(regime, algorithm)

        print(" Выйти? [y/n]", end='\n ')
        answer = input().lower()
        if answer == 'y':
            break


if __name__ == '__main__':
    main()

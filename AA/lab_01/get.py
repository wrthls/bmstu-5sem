from levenstein import levenstein
from damerau_levenstein_matrix import damerau_levenstein_matrix
from damerau_levenstein_recursion import damerau_levenstein_recursion


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

        if answer == 1:
            algorithm = levenstein
        elif answer == 2:
            algorithm = damerau_levenstein_matrix
        elif answer == 3:
            algorithm = damerau_levenstein_recursion

        return algorithm



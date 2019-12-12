# Lab_02 AA Makovskaya Yana
from print import *
from standard_multiplication import *
from winograd_multiplication import *
from optimized_winograd_multiplication import *
from test import test
from os import path


def choose_regime():
    while 1:
        print("Выберите режим:")
        print("[1] Пользовательский")
        print("[2] Тестирование")
        choice = input()
        if not choice.isdigit():
            print("Некорректный ввод, повторите попытку \n")
            continue
        choice = int(choice)

        if choice < 1 or choice > 2:
            print("Некорректный ввод, повторите попытку \n")
            continue

        if choice == 1:
            return 1
        elif choice == 2:
            return 2


def read_matrix(file):
    mtr = []
    for line in file:
        mtr.append(list(map(int, line.split('\t'))))
    return mtr


def get_matrix(num):
    while 1:
        print("Из какого файла читать матрицу", str(num), "?")
        file_path = input()
        if not path.exists(file_path):
            print("Некорректный ввод, повторите попытку \n")
            continue

        break

    file = open(file_path, 'r')
    mtr = read_matrix(file)

    file.close()

    return mtr


def choose_algorithm():
    while 1:
        print("Выберите алгоритм: ")
        print("[1] Стандартный")
        print("[2] Винограда")
        print("[3] Оптимизированный Винограда")
        print("[4] Все алгоритмы")
        choice = input()
        print()
        if not choice.isdigit():
            print("Некорректный ввод, повторите попытку \n")
            continue

        choice = int(choice)

        if choice < 1 or choice > 4:
            print("Некорректный ввод, повторите попытку \n")
            continue

        if choice == 1:
            algorithm = multiply_standard
        elif choice == 2:
            algorithm = multiply_winograd
        elif choice == 3:
            algorithm = multiply_winograd_optim
        else:
            return 0

        return algorithm


def main():
    regime = choose_regime()
    if regime == 2:
        test()
    else:
        alg = choose_algorithm()
        mtr_1 = get_matrix(1)
        mtr_2 = get_matrix(2)

        if not alg:
            res_1 = multiply_standard(mtr_1, mtr_2)
            res_2 = multiply_winograd(mtr_1, mtr_2)
            res_3 = multiply_winograd_optim(mtr_1, mtr_2)
            print("Стандартный:")
            print_matrix(res_1)
            print("Винограда:")
            print_matrix(res_2)
            print("Оптимизированный Винограда:")
            print_matrix(res_3)
        else:
            res = alg(mtr_1, mtr_2)
            print("Результат:")
            print_matrix(res)


if __name__ == '__main__':
    main()

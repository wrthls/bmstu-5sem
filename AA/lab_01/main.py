# AA lab_01 Levenstein
# Yana Makovskaya
import time
from get import *


def execute(regime, algorithm):
    print(" Введите первую строку: \n ", end='')
    s1 = input()
    print(" Введите вторую строку: \n ", end='')
    s2 = input()
    print()

    if regime == 'e':
        start = time.perf_counter()

    result = algorithm(s1, s2)

    if regime == 'e':
        end = time.perf_counter()

    print(" Расстояние: ", result)
    print()

    if regime == 'e':
        period = end - start
        print(" Время выполнения: ", period)
        print()


def main():
    regime = get_regime()
    while True:
        algorithm = get_algorithm()
        execute(regime, algorithm)

        print(" Выйти? [y/n]", end='\n ')
        answer = input().lower()
        if answer == 'y':
            break


if __name__ == '__main__':
    main()

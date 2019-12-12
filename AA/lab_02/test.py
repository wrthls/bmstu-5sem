from time import perf_counter
from random import randint
from standard_multiplication import *
from winograd_multiplication import *
from optimized_winograd_multiplication import *


def create_matrix(m):
    matrix = []
    for i in range(m):
        matrix.append([])
        for j in range(m):
            matrix[i].append(randint(-100, 100))
    return matrix


def time_test(flag, alg):
    start = 100 + flag
    end = 1000 + flag
    file = open(alg.__name__ + str(flag), 'w')
    print("Тестируем алгоритм", alg.__name__)
    for i in range(start, end + 1, 50):
        mtr_1 = create_matrix(i)
        mtr_2 = create_matrix(i)
        start_time = perf_counter()
        alg(mtr_1, mtr_2)
        end_time = perf_counter()
        time = end_time - start_time
        file.write(str(i) + ' ' f"{time:.6f}" '\n')
        print(str(i) + ' ' f"{time:.6f}" '\n')
    file.close()


def test():
    # countable
    flag = 0
    #time_test(flag, multiply_standard)
    #time_test(flag, multiply_winograd)
    time_test(flag, multiply_winograd_optim)
    # uncountable
    flag = 1
    time_test(flag, multiply_standard)
    time_test(flag, multiply_winograd)
    time_test(flag, multiply_winograd_optim)


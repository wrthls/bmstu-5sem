from time import perf_counter
from random import randint
from levenstein import levenstein_not_verbose
from damerau_levenstein_matrix import damerau_levenstein_matrix_not_verbose
from damerau_levenstein_recursion import damerau_levenstein_recursion


def create_string(length):
    string = ""

    for i in range(length):
        char = chr(randint(0, 255))
        string += char
    return string


def time_test(algorithm, end, step, n, test):
    print("\n TESTING", algorithm.__name__, "ALGORITHM")

    if test == 1:
        file = open(algorithm.__name__ + "1", 'w')
    elif test == 2:
        file = open(algorithm.__name__ + "2", 'w')
    else:
        return -1

    for i in range(0, end + 1, step):

        s1 = create_string(i)
        s2 = create_string(i)

        sum_time = 0

        for _ in range(n):
            start_time = perf_counter()
            algorithm(s1, s2)
            end_time = perf_counter()
            measured_time = end_time - start_time
            sum_time += measured_time

        average_time = sum_time/n

        print(f" For {i} elements time value: {average_time:.6f}")
        file.write(str(i) + ' ' f"{average_time:.6f}" '\n')


def test_1():
    print(" == TEST 1 == ")
    time_test(levenstein_not_verbose, 1000, 50, 20, 1)
    time_test(damerau_levenstein_matrix_not_verbose, 1000, 50, 20, 1)


def test_2():
    print(" == TEST 2 == ")
    time_test(damerau_levenstein_matrix_not_verbose, 10, 1, 20, 2)
    time_test(damerau_levenstein_recursion, 10, 1, 3, 2)


def main():
    print(" == TESTING MODE ON == ")
    test_1()
    test_2()


if __name__ == "__main__":
    main()

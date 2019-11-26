from print_matrix import print_matrix


def damerau_levenstein_matrix(s1, s2, print_flag=1):
    len_1 = len(s1)
    len_2 = len(s2)

    matrix = []
    for i in range(len_1 + 1):
        matrix.append([0 for _ in range(len_2 + 1)])

    for i in range(0, len_1 + 1):
        for j in range(0, len_2 + 1):
            if min(i, j) == 0:
                matrix[i][j] = max(i, j)
            else:
                delete = matrix[i-1][j] + 1
                insert = matrix[i][j-1] + 1
                match = matrix[i-1][j-1]
                if s1[i-1] != s2[j-1]:
                    match += 1
                if i > 1 and j > 1 and s1[i-1] == s2[j-2] and s1[i - 2] == s2[j-1]:
                    transpose = matrix[i - 2][j - 2] + 1
                    matrix[i][j] = min(delete, insert, match, transpose)
                else:
                    matrix[i][j] = min(delete, insert, match)

    if print_flag:
        print(" Матрица: ")
        print_matrix(matrix)

    return matrix[len_1][len_2]


def damerau_levenstein_matrix_not_verbose(s1, s2):
    return damerau_levenstein_matrix(s1, s2, 0)

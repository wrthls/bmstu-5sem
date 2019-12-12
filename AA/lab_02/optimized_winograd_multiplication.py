# умножаем две квадратные матрицы M x M * M x M = M x M
def multiply_winograd_optim(matrix_1, matrix_2):
    M = len(matrix_1)
    if len(matrix_2) != M | len(matrix_1[0]) != M:
        print("Невозможно перемножить")
        return -1

    d = M // 2

    row_factor = []
    col_factor = []

    for i in range(M):
        row_factor.append(0)
        col_factor.append(0)
        for j in range(d):
            j2 = 2 * j
            j21 = j2 + 1
            row_factor[i] += matrix_1[i][j2] * matrix_1[i][j21]
            col_factor[i] += matrix_2[j2][i] * matrix_2[j21][i]

    matrix_res = []
    flag = M % 2
    if flag:
        m1 = M - 1
    for i in range(M):
        matrix_res.append([])
        for j in range(M):
            matrix_res[i].append(0)
            summ = - row_factor[i] - col_factor[j]
            if flag:
                summ += matrix_1[i][m1] * matrix_2[m1][j]
            for k in range(d):
                k2 = 2 * k
                k21 = k2 + 1
                summ += (matrix_1[i][k2] + matrix_2[k21][j]) * \
                                    (matrix_1[i][k21] + matrix_2[k2][j])
            matrix_res[i][j] = summ

    return matrix_res

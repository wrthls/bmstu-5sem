# умножаем две матрицы размера L x M * M x N = L x N
def multiply_winograd(matrix_1, matrix_2):
    L = len(matrix_1)
    M = len(matrix_1[0])
    if len(matrix_2) != M:
        print("Невозможно перемножить")
        return -1
    N = len(matrix_2[0])

    d = M // 2

    row_factor = [0 for _ in range(L)]
    col_factor = [0 for _ in range(N)]

    for i in range(L):
        for j in range(d):
            row_factor[i] = row_factor[i] + matrix_1[i][2 * j] * matrix_1[i][2 * j + 1]

    for i in range(N):
        for j in range(d):
            col_factor[i] = col_factor[i] + matrix_2[2 * j][i] * matrix_2[2 * j + 1][i]

    matrix_res = [[0 for _ in range(N)] for _ in range(L)]
    for i in range(L):
        for j in range(N):
            matrix_res[i][j] = - row_factor[i] - col_factor[j]
            for k in range(d):
                matrix_res[i][j] = matrix_res[i][j] + \
                                   (matrix_1[i][2 * k] + matrix_2[2 * k + 1][j]) * \
                                   (matrix_1[i][2 * k + 1] + matrix_2[2 * k][j])

    if M % 2:
        for i in range(L):
            for j in range(N):
                matrix_res[i][j] = matrix_res[i][j] + matrix_1[i][M - 1] * matrix_2[M - 1][j]

    return matrix_res

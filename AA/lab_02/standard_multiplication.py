# умножаем две матрицы размера L x M * M x N = L x N
def multiply_standard(matrix_1, matrix_2):
    L = len(matrix_1)
    M = len(matrix_1[0])
    if len(matrix_2) != M:
        print("Невозможно перемножить")
        return -1
    N = len(matrix_2[0])

    matrix_res = []
    for i in range(L):
        matrix_res.append([])
        for j in range(N):
            matrix_res[i].append(0)

    for i in range(L):
        for j in range(N):
            for k in range(M):
                matrix_res[i][j] = matrix_res[i][j] + matrix_1[i][k] * matrix_2[k][j]

    return matrix_res

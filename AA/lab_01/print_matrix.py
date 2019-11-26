
def print_matrix(matrix):
    for j in range(len(matrix)):
        print(" ", end='')
        for k in range(len(matrix[j])):
            print(matrix[j][k], ' ', end='')
        print()
    print()

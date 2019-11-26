def damerau_levenstein_recursion(s1, s2):
    i = len(s1)
    j = len(s2)

    if min(i, j) == 0:
        return max(i, j)

    delete = damerau_levenstein_recursion(s1[:i-1], s2) + 1
    insert = damerau_levenstein_recursion(s1, s2[:j-1]) + 1
    match = damerau_levenstein_recursion(s1[:i-1], s2[:j-1])

    if s1[i - 1] != s2[j - 1]:
        match += 1

    if i > 1 and j > 1 and s1[i - 1] == s2[j - 2] and s1[i - 2] == s2[j - 1]:
        transpose = damerau_levenstein_recursion(s1[:i-2], s2[:j-2]) + 1
        return min(delete, insert, match, transpose)
    else:
        return min(delete, insert, match)

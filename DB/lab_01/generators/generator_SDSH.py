import random


# SDSHno Sno Dno SHno Qty
def main():
    qty = 1000
    file = open("SDSH_table.txt", 'w')
    for i in range(1, qty + 1):

        Sno = random.randint(1, 1000)
        Dno = random.randint(1, 1000)
        SHno = random.randint(1, 1000)
        number = random.randint(1, 5000)

        file.write(str(i) +
                   ',' +
                   str(Sno) +
                   ',' +
                   str(Dno)
                   +
                   ',' +
                   str(SHno) +
                   ',' +
                   str(number) +
                   ';')
    file.close()


if __name__ == '__main__':
    main()
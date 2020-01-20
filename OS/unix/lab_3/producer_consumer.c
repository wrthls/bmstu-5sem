#include <sys/shm.h>
#include <sys/sem.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>

#define SE 0
#define SF 1
#define SB 2

const int slots = 10;							// кол-во ячеек буфера
const int perms = S_IRWXU | S_IRWXG | S_IRWXO;	// права доступа
const int consumers = 3;						// кол-во потребителей
const int producers = 3;						// кол-во производителей

struct sembuf sembuf_produce_start[2] = {
	{SB, -1, 0},	// захват ресурсов
	{SE, -1, 0}		// декриментр пустых ячеек
};

struct sembuf sembuf_produce_stop[2] = {
	{SF, 1, 0},		// инкримент заполненных ячеек
	{SB, 1, 0}		// освобождение ресурсов
};

struct sembuf sembuf_consume_start[2] = {
	{SB, -1, 0},	// захват ресурсов
	{SF, -1, 0}		// декремент заполненных ячеек
};

struct sembuf sembuf_consume_stop[2] = {
	{SE, 1, 0},		// инкримент пустых ячеек
	{SB, 1, 0}		// освобождение ресурсов
};

int **p_cons_pos;
int **p_prod_pos;
int *sh_buffer;

pid_t *pid_array;

void kill_producers() 
{
    for (int i = 0; i < producers; i++) {
        if (pid_array[i] == getpid()) {
            continue;
        }
        kill(pid_array[i], SIGTERM);
    }
    exit(0);
}

void kill_consumers() 
{
    for (int i = producers; i < producers + consumers; i++) {
        if (pid_array[i] == getpid()) {
            continue;
        }
        kill(pid_array[i], SIGTERM);
    }
    kill(getpid(), SIGKILL);
}

int * get_sh_mm()
{
	int sh_mm_fd;
	int *sh_mm_addr;

	if ((sh_mm_fd = shmget(100, sizeof(int) * (slots + 1) + (producers + consumers) * sizeof(pid_t) + sizeof(int*) * 2, IPC_CREAT|perms)) == -1)
	{
		perror("shmget");
		exit(1);
	}

	sh_mm_addr = (int*) shmat(sh_mm_fd, NULL, 0);
	if (sh_mm_addr == (int*) -1)
	{
		perror("shmat");
		exit(1);
	}

	return sh_mm_addr;
}

int get_sem_fd()
{
	int sem_fd = semget(101, 3, IPC_CREAT | perms);
    if (sem_fd == -1)
    {
        perror("semget");
        exit(1);
    }
    return sem_fd;
}

int produce(int sem_fd, int number)
{   
    if (semop(sem_fd, sembuf_produce_start, 2) == -1)
    {
        perror("semop");
        exit(1);
    }
    int **p_prod_pos = sh_buffer - 3;
    int *prod_pos = *p_prod_pos;

    if (*(prod_pos - 1) >= slots) 
    {
        if (semop(sem_fd, sembuf_produce_stop, 2) == -1) 
        {
            perror("semop");
            exit(1);
        }
        kill_producers();
    }
    sleep(rand() % 8);
    *prod_pos = *(prod_pos - 1) + 1;
    printf("Производитель %d, pid=%d создал значение %d\n", number, getpid(), *prod_pos);
    prod_pos++;
    *p_prod_pos = prod_pos;

    if (semop(sem_fd, sembuf_produce_stop, 2) == -1) 
    {
        perror("semop");
        exit(1);
    }

    return 0;
}

int consume(int sem_fd) 
{
    if (semop(sem_fd, sembuf_consume_start, 2) == -1)
    {   
        perror("semop");
        exit(1);
    }
    int **p_cons_pos = sh_buffer - 5;
    int *cons_pos = *p_cons_pos;
    if (cons_pos - sh_buffer >= slots)
    {
        if (semop(sem_fd, sembuf_consume_stop, 2) == -1)
        {
            perror("semop");
            exit(1);
        }
        kill_consumers();
    }
    sleep(rand() % 8);
    int val = *cons_pos;
    cons_pos++;
    *p_cons_pos = cons_pos;

    if (semop(sem_fd, sembuf_consume_stop, 2) == -1)
    {
        perror("semop");
        exit(1);
    }

    return val;
}

void get_producer(int number, int sem_fd) {
    pid_t pid;

    sleep(rand() % 3);
    if ((pid = fork()) == -1) 
    {
        printf("fork");
        exit(1);
    }

    if(pid == 0) 
    {
        printf("Создан производитель %d, pid: %d\n", number, getpid());
        while(1)
        {
            srand(getpid());
            produce(sem_fd, number);
        }
    }
    else
    {
        pid_array[number] = pid;
    }
}

void get_consumer(int number, const int sem_fd) {
    pid_t pid;

    if ((pid = fork()) == -1) 
    {
        printf("fork");
        exit(1);
    }

    if(pid == 0) 
    {
        printf("Создан потребитель %d, pid: %d\n", number, getpid());
        while(1) 
        {
            int val = consume(sem_fd);
            printf("Потребитель %d, pid=%d прочитал значение: %d\n", number, getpid(), val);
        }
    } 
    else
    {
        pid_array[number] = pid;
    }
}

int main()
{
	srand(0);

	// получает адрес разделенного сегмента
	int *sh_mm_addr = get_sh_mm();

	p_cons_pos = sh_mm_addr;
	p_prod_pos = sh_mm_addr + 2;
    *(sh_mm_addr + 4) = 0;
	sh_buffer = sh_mm_addr + 5;
    pid_array = sh_mm_addr + 5 + slots;

	*p_cons_pos = sh_buffer;
	*p_prod_pos = sh_buffer;

//     printf("sizeof(int) = %d; sizeof(int*) = %d; sizeof(int**) = %d; sizeof(pid_t) = %d\n\n",
//     sizeof(int), sizeof(int*), sizeof(int**), sizeof(pid_t));
//     printf("p_cons_pos = %d \np_prod_pos = %d\n\
// *p_prod_pos = %d\n*p_cons_pos = %d\n\
// sh_mm_addr = %d\nsh_buffer = %d\n\
// pid_array = %d\n", p_cons_pos, \
//     p_prod_pos, *p_prod_pos, *p_cons_pos, sh_mm_addr, sh_buffer, pid_array);
    
	int sem_fd = get_sem_fd();

	// присваивание начальных значений семафорам
	if (semctl(sem_fd, SE, SETVAL, slots) == -1 ||
		semctl(sem_fd, SF, SETVAL, 0) == -1 ||
		semctl(sem_fd, SB, SETVAL, 1) == -1)
	{
		perror("semctl");
		exit(1);
	}

    // создание производителей
    int i = 0;
    while(i < producers)
    {
        get_producer(i, sem_fd);
        i++;
    }

	// создание потребителей
	int j = producers;
	while(j < producers + consumers)
	{
		get_consumer(j, sem_fd);
		j++;
	}
	
	// ожидание завершения всех потомков
	for (int i = 0; i < consumers + producers; i++)
	{
        int *status;
        wait(status);
    }

	// отключение разделенного сегмента от адрессного пространства
	if (shmdt(sh_mm_addr) == -1)
		perror("shmdt");

	return 0;

}

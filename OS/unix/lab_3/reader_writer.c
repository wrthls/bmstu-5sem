#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/shm.h>
#include <sys/sem.h>
#include <sys/wait.h>
#include <signal.h>
#include <fcntl.h>

#define READERS 10
#define WRITERS 4

#define S_READERS_WAITING 0		// семафор ждущих читателей
#define S_WRITERS_WAITING 1		// бинарный семафор ждущих писателей
#define S_ACTIVE_READERS 2		// семафор активных читателей
#define S_ACTIVE_WRITERS 3		// бинарный семафор, = 1, если идёт запись

const int buf_size = 30;
int *buffer;
int *wrt_pos;

struct sembuf start_read[5] = {
	{S_READERS_WAITING , 1, 0},
	{S_WRITERS_WAITING, 0, 0},
	{S_ACTIVE_WRITERS, 0, 0},
	{S_READERS_WAITING, -1, 0},
	{S_ACTIVE_READERS, 1, 0}	
};

struct sembuf stop_read[1] = {
	{S_ACTIVE_READERS, -1, 0}
};

struct sembuf start_write[5] = {
	{S_WRITERS_WAITING, 1, 0},
	{S_ACTIVE_WRITERS, 0, 0},
	{S_ACTIVE_READERS, 0, 0},
	{S_ACTIVE_WRITERS, -1, 0},
	{S_WRITERS_WAITING, -1, 0}
};

struct sembuf stop_write[1] = {
	{S_ACTIVE_WRITERS, 1, 0}
};

void error_m(const char *msg)
{
	perror(msg);
	exit(1);
}

void writer(int *data, int sem_id, int num)
{
	sleep(rand() % 10);
	if (semop(sem_id, start_write, 5) == -1)
		error_m("semop");
	(*data)++;
	printf(" + Писатель %d написал %d\n", num, *data);
	if (semop(sem_id, stop_write, 1) == -1)
		error_m("semop");
}

void reader(int *data, int sem_id, int num)
{
	sleep(rand() % 10);
	if (semop(sem_id, start_read, 5) == -1)
		error_m("semop");
	printf("Читатель %d прочитал %d\n", num, *data);
	if (semop(sem_id, stop_read, 1) == -1)
		error_m("semop");
}

int main()
{
	int perms = S_IRWXU | S_IRWXG | S_IRWXO;
	int ctl1, ctl2, ctl3, ctl4;
	int status;

	// массив семафоров
	int fd_s = semget(IPC_PRIVATE, 4, IPC_CREAT | perms);
	if (fd_s == -1)
		error_m("semget");
	
	// присваивание семафорам начальных значений
	ctl1 = semctl(fd_s, S_WRITERS_WAITING, SETVAL, 0);
	ctl2 = semctl(fd_s, S_ACTIVE_WRITERS, SETVAL, 1);
	ctl3 = semctl(fd_s, S_ACTIVE_READERS, SETVAL, 0);
	ctl4 = semctl(fd_s, S_WRITERS_WAITING, SETVAL, 0);
	if (ctl1 == -1 || ctl2 == -1 || ctl3 == -1)
		error_m("semctl");
	
	// получение разделяемой памяти
	int fd_m = shmget(IPC_PRIVATE, sizeof(int), IPC_CREAT | perms);
	if (fd_m == -1)
		error_m("shmget");
	
	int *mem_ptr = (int *)shmat(fd_m, 0, 0);
	if ((*mem_ptr) == -1)
		error_m("shmat");
	(*mem_ptr) = 0;
	
	// создание писателей
	pid_t writers[WRITERS];
	for (int i = 0; i < WRITERS; i++)
	{
		writers[i] = fork();
		if (writers[i] == -1)
		{
			error_m("couldn't fork.");
		}
		else if (!writers[i])
		{
			srand(getpid());
			while (1)
				writer(mem_ptr, fd_s, i);
			return 0;
		}
	}
	
	// создание читателей
	pid_t readers[READERS];
	for (int i = 0; i < READERS; i++)
	{
		readers[i] = fork();
		if (readers[i] == -1)
		{
			error_m("couldn't fork.");
		}
		else if (!readers[i])
		{
			srand(getpid());
			while (1)
				reader(mem_ptr, fd_s, i);
			return 0;
		}
	}
	
	// ожидание завершения потомков
	for (int i = 0; i < READERS + WRITERS; i++)
	{
        int *status;
        wait(status);
    }

    // отключение разделенного сегмента от адрессного пространства
    if (shmdt(mem_ptr) == -1)
		error_m("shmdt");
	
	return 0;
}
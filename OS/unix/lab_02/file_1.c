#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main()
{
	pid_t childpid_1, childpid_2;

	if ((childpid_1 = fork()) == -1)
	{
		perror("Can't fork");
		exit(1);
	}
	else if (childpid_1 == 0)
	{
		printf("Child_1: pid=%d, ppid=%d, idgz = %d \n", getpid(), getppid(), getgid());
		sleep(3);
		printf("Child_1: pid=%d, ppid=%d, idgz = %d \n", getpid(), getppid(), getgid());
		exit(0);
	}

	if ((childpid_2 = fork()) == -1)
	{
		perror("Can't fork");
		exit(1);
	}
	else if (childpid_2 == 0)
	{
		printf("Child_2: pid=%d, ppid=%d, idgz = %d \n", getpid(), getppid(), getgid());
		sleep(3);
		printf("Child_2: pid=%d, ppid=%d, idgz = %d \n", getpid(), getppid(), getgid());
		exit(0);
	}

	printf("Parent: pid=%d, childpid_1=%d, childpid_2=%d, idgz = %d \n", getpid(), childpid_1, childpid_2, getgid());

	return 0;
}
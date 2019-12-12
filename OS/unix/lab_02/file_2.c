#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main()
{
	pid_t childpid_1, childpid_2;
	int status, val;

	if ((childpid_1 = fork()) == -1)
	{
		perror("Can't fork");
		exit(1);
	}
	else if (childpid_1 == 0)
	{
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
		exit(0);
	}

	val = wait(&status);
	printf("Parent: pid=%d, childpid_1=%d, childpid_2=%d, idgz = %d \n", getpid(), childpid_1, childpid_2, getgid());

	if ( WIFEXITED(status) )
		printf("Parent: child %d finished with %d code.\n", val, WEXITSTATUS(status) );
	else if ( WIFSIGNALED(status) )
		printf( "Parent: child %d finished from signal with %d code.\n", val, WTERMSIG(status));
	else if ( WIFSTOPPED(status) )
		printf("Parent: child %d stopped with %d code.\n", val, WSTOPSIG(status));

	return 0;
}
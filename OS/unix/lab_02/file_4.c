#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

int main()
{
	char msg_1[] = "one";
	char msg_2[] = "two";
	int fd[2]; // file descriptor: [0] - выход для чтения, [1] - вход для записи
	int status, val;
	pid_t childpid_1, childpid_2;

	if (pipe(fd) == -1)
	{
		perror("pipe");
		exit(1);
	}

	// пишет child_1
	if ((childpid_1 = fork()) == -1)
	{
		perror("fork()");
		exit(1);
	}
	else if (childpid_1 == 0)
	{
		close(fd[0]);
		write(fd[1], msg_1, sizeof msg_1 - 1);

		printf("child_1 writes \"%s\"\n", msg_1);

		exit(0);
	}

	// пишет child_2
	if ((childpid_2 = fork()) == -1)
	{
		perror("fork()");
		exit(1);
	}
	else if (childpid_2 == 0)
	{
		close(fd[0]);
		write(fd[1], msg_2, sizeof msg_2 - 1);

		printf("child_2 writes \"%s\"\n", msg_2);

		exit(0);
	}

	// читает родитель
	if (childpid_1 != 0 && childpid_2 != 0)
	{
		val = wait(&status);

		close(fd[1]);

		char msg[64];

		read(fd[0], msg, sizeof msg);

		printf("parent reads \"%s\"\n", msg);

		val = wait(&status);
		printf("Parent: pid=%d, childpid_1=%d, childpid_2=%d, idgz = %d \n", getpid(), childpid_1, childpid_2, getgid());

		if ( WIFEXITED(status) )
			printf("Parent: child %d finished with %d code.\n", val, WEXITSTATUS(status) );
		else if ( WIFSIGNALED(status) )
			printf( "Parent: child %d finished from signal with %d code.\n", val, WTERMSIG(status));
		else if ( WIFSTOPPED(status) )
			printf("Parent: child %d stopped with %d code.\n", val, WSTOPSIG(status));
	}

	return 0;
}
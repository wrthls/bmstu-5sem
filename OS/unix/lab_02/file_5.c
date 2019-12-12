#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>

int flag = 0;

void catch_sig_c(int signum)
{
	printf("\n!Signal Ctrl + C caught! \n");
	flag = 1;
}

void catch_sig_z(int signum)
{
	printf("\n!Signal Ctrl + Z caught! \n");
	flag = 0;
}

int main()
{
	char msg_1[] = "one";
	char msg_2[] = "two";
	int fd[2]; // file descriptor: [0] - выход для чтения, [1] - вход для записи
	int val, status;
	pid_t childpid_1, childpid_2;

	if (pipe(fd) == -1)
	{
		perror("pipe");
		exit(1);
	}

	printf("Press Ctrl + C to write.\n");
	signal(SIGINT, catch_sig_c);		// ctrl + 'c'
	sleep(5);

	if (!flag)
		exit(0);

	// пишет child_1
	if ((childpid_1 = fork()) == -1)
	{
		perror("fork()");
		exit(1);
	}
	else if (childpid_1 == 0)
	{
		close(fd[0]);
		write(fd[1], msg_1, sizeof(msg_1));

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
		write(fd[1], msg_2, sizeof(msg_2));

		printf("child_2 writes \"%s\"\n", msg_2);

		exit(0);
	}

	// читает родитель
	if (childpid_1 != 0 && childpid_2 != 0)
	{
		val = wait(&status);

		printf("Press Ctrl + Z to read.\n");
		signal(SIGTSTP, catch_sig_z); // ctrl + 'z'
		sleep(5);

		if (flag)
			exit(0);

		close(fd[1]);

		char msg_01[sizeof(msg_1)];
		char msg_02[sizeof(msg_2)];

		read(fd[0], msg_01, sizeof(msg_1));
		read(fd[0], msg_02, sizeof(msg_2));

		printf("parent reads \"%s\", \"%s\"\n", msg_1, msg_2);

		if ( WIFEXITED(status) )
			printf("Parent: child %d finished with %d code.\n", val, WEXITSTATUS(status) );
		else if ( WIFSIGNALED(status) )
			printf( "Parent: child %d finished from signal with %d code.\n", val, WTERMSIG(status));
		else if ( WIFSTOPPED(status) )
			printf("Parent: child %d stopped with %d code.\n", val, WSTOPSIG(status));
	}

	return 0;
}
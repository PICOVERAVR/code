#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#define PORTNO 6060

/*
    Socket test code.
    Don't know what everything does exactly, as I copied this off of the internet in a different form and 
    modified it to strip out a lot of error reporting that was, in all likelihood, a really good idea to have,
    but as a beginner I wanted as little to understand as possible.
 
    Used this program to connect to a RasPi 2B. How to replicate:
    1. run "nc -l 6060" on server side (random port)
    2. run this program on client side.
*/

int main(int argc, char *argv[])
{
    int sockfd, portno;
    long n;
    struct sockaddr_in serv_addr;
    struct hostent *server;
    
    char buffer[256]; //buffer to hold incoming connections
    
    portno = PORTNO;
    sockfd = socket(AF_INET, SOCK_STREAM, 0); //IPv4, stream socket, '0' lets system choose default protocol for current settings
    
    char name_buf[256];
    gethostname(name_buf, sizeof(name_buf));
    printf("Client hostname: %s\n", name_buf);
    
    server = gethostbyname("Kyles-MBP"); //name of raspi, needs to be passed as a command-line arg to be portable.  converts name in quotes to byte format suitable for usage.
    
    if (server == NULL) { //keep this!
        fprintf(stderr, "Host does not exist\n");
        exit(0);
    }
    
    memset((char *) &serv_addr, 0, sizeof(serv_addr)); //set struct serv_addr to zero
    serv_addr.sin_family = AF_INET; //IPv4
    
    memcpy((char *)&serv_addr.sin_addr.s_addr,(char *)server->h_addr, server->h_length); //cannot replace with '=' due to inability to assign to casts
    
    serv_addr.sin_port = htons(portno); //host to network short conversion
    
    if (connect(sockfd,(struct sockaddr *) &serv_addr,sizeof(serv_addr)) < 0) {
        fprintf(stderr, "ERROR connecting\n");
        exit(0);
    }
    
    printf("> ");
    memset(buffer, 0, 256);
    fgets(buffer,255,stdin);
    n = write(sockfd,buffer,strlen(buffer));
    if (n < 0)
        fprintf(stderr, "ERROR writing to socket\n");
    memset(buffer, 0, sizeof(buffer));
    n = read(sockfd,buffer,255);
    if (n < 0)
        fprintf(stderr, "ERROR reading from socket\n");
    printf("%s\n",buffer);
    
    close(sockfd);
    return 0;
}

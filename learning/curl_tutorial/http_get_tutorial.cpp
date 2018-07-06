#include <iostream>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>

int main(int argc, char** argv)
{
    if(argc != 2)
    {
        std::cout << "Error: must have 2 arguments\n";
    }
    char address[60];
    strcpy(address, argv[1]);
    std::cout << address << "\n";

    int client_socket = socket(AF_INET, SOCK_STREAM, 0);

    if(client_socket == -1)
    {
        std::cout << "Client socket error\n";
        return 0;
    }

    std::cout << "xx\n";

    struct sockaddr_in remote_address;
    remote_address.sin_family = AF_INET;
    remote_address.sin_port = htons(80);
    inet_pton(AF_INET, address, &(remote_address.sin_addr.s_addr));
    //inet_aton(address, &remote_address.sin_addr);//.s_addr);

    connect(client_socket, (struct sockaddr*) &remote_address, sizeof(remote_address));
    char request[] = "GET / HTTP/1.1\r\n\r\n";
    char response[4096];

    send(client_socket, request, sizeof(request), 0);
    recv(client_socket, &response, sizeof(response), 0);

    std::cout << "response = " << response << "\n";
    close(client_socket);
    return 0;
}

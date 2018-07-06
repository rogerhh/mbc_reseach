#include <iostream>
#include <cstdlib>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>

int main(int argc, char** argv)
{
    char server_msg[256] = "You have connected to the server\n";

    int network_socket = socket(AF_INET, SOCK_STREAM, 0);

    struct sockaddr_in server_address;
    server_address.sin_family = AF_INET;
    server_address.sin_port = htons(9002);
    server_address.sin_addr.s_addr = INADDR_ANY;

    // bind socket to specified IP and port
    bind(network_socket, (struct sockaddr*) &server_address, sizeof(server_address));

    // listen for connections
    listen(network_socket, 3);

    int client_socket = accept(network_socket, NULL, NULL);

    send(client_socket, server_msg, sizeof(server_msg), 0);
    close(network_socket);
    return 0;
}

#include <iostream>
#include <cstdlib>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>

int main(int argc, char** argv)
{
    // create socket
    int network_socket;
    network_socket = socket(AF_INET, SOCK_STREAM, 0);
    
    // specify an address for the socket
    struct sockaddr_in server_address;
    server_address.sin_family = AF_INET;
    server_address.sin_port = htons(9002);
    server_address.sin_addr.s_addr = INADDR_ANY;

    int connection_status = connect(network_socket, (struct sockaddr*) &server_address, sizeof(server_address));

    if(connection_status == -1)
    {
        std::cout << "Connection error\n";
        return 0;
    }

    // receive data form the server
    char server_response[256];
    recv(network_socket, &server_response, sizeof(server_response), 0);

    // print data
    std::cout << server_response << "\n";

    close(network_socket);
    return 0;
}

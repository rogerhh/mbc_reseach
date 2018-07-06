#include <iostream>
#include <fstream>
#include <string>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>

int main()
{
    std::ifstream fin("/home/rogerhh/mbc_research/learning/curl_tutorial/index.html");

    if(!fin.is_open())
    {
        std::cout << "Error opening file\n";
        return 0;
    }

    char response_data[1024];
    fin.getline(response_data, 1024);

    char http_header[2048] = "HTTP/1.1 200 OK\r\n\n";

    strcat(http_header, response_data);

    int server_socket = socket(AF_INET, SOCK_STREAM, 0);

    struct sockaddr_in server_address;
    server_address.sin_family = AF_INET;
    server_address.sin_port = htons(8000);
    server_address.sin_addr.s_addr = INADDR_ANY;

    bind(server_socket, (struct sockaddr*) &server_address, sizeof(server_address));

    listen(server_socket, 3);

    int client_socket;
    while(1)
    {
        client_socket = accept(server_socket, NULL, NULL);
        send(client_socket, http_header, sizeof(http_header), 0);
        close(client_socket);
    }

    return 0;
}

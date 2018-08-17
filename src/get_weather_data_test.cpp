#include <cstdlib>
#include <stdlib.h>
#include <string>
#include <cstring>
#include <iostream>
#include <curl/curl.h>

namespace
{

struct memory_t
{
    char* contents;
    size_t size;
    memory_t()
    {
        contents = (char*) malloc(1);
        size = 0;
    }

    ~memory_t()
    {
        free(contents);
    }
};

size_t write_callback(void* retrieved_data, size_t size, size_t nmemb, memory_t* userptr)
{
    size_t real_size = size * nmemb;
    userptr->contents = (char*) realloc(userptr->contents, userptr->size + real_size + 1);
    if(!userptr->contents)
    {
        std::cout << "Not enough memory.\n";
        return 0;
    }

    memcpy(userptr->contents + userptr->size, retrieved_data, real_size);
    userptr->size += real_size;
    userptr->contents[userptr->size] = '\0';
    return real_size;
}

} // namespace

int main(int argc, char** argv)
{
    
}

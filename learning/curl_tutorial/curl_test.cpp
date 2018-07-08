#include <cstdlib>
#include <stdlib.h>
#include <string>
#include <cstring>
#include <iostream>
#include <curl/curl.h>

struct memory_t
{
    char* contents;
    size_t size;
    memory_t()
    {
        contents = (char*) malloc(1);
        size = 0;
    }
};

static size_t write_callback(void* retrieved_data, size_t size, size_t nmemb, memory_t* userptr)
{
    size_t real_size = size * nmemb;
    userptr->contents = (char*) realloc(userptr->contents, userptr->size + real_size + 1);
    if(!userptr->contents)
    {
        std::cout << "Not enough memory.";
        return 0;
    }

    memcpy(userptr->contents + userptr->size, retrieved_data, real_size);
    userptr->size += real_size;
    userptr->contents[userptr->size] = '\0';
    return real_size;
}

int main(int argc, char** argv)
{
    CURL *curl;
    CURLcode res;

    struct memory_t data;

/*    if(argc != 4)
    {
        std::cout << "Error: should have 4 arguments\n";
        return 0;
    }
    double lat = std::atof(argv[3]), lng = std::atof(argv[2]);

    std::string date = std::string(argv[1]);

    std::cout << "date = " << date << "lng = " << lng << "&& lat = " << lat << "\n";
*/
    //data.contents = malloc(1);

    curl_global_init(CURL_GLOBAL_DEFAULT);

    curl = curl_easy_init();

    if(curl)
    {
        std::string url = "https://api.weatherbit.io/v2.0/history/hourly?city=Ann_Arbor,MI&start_date=2018-06-20&end_date=2018-06-21&key=8fabd87c7c1a42d484e91cd8c603dd04";
        //std::string url = "https://api.sunrise-sunset.org/json?lat=" + std::string(argv[3]) + "&lng=" + std::string(argv[2]) + "&date=" + date; //"https://api.sunrise-sunset.org/";
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        
        curl_easy_setopt(curl, CURLOPT_HTTPGET, 1L);

        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);

        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &data);

        res = curl_easy_perform(curl);
        if(res != CURLE_OK)
            std::cout << "Error: " << curl_easy_strerror(res) << "\n";

        std::cout << "Successful. data.contents = " << data.contents << "\n";
    }

    free(data.contents);

    curl_global_cleanup();

    return 0;

    std::string url = "'https://api.sunrise-sunset.org/json?lat=38.7201600&lng=-6.4203400&formatted=0'";
    std::system(("curl -o test.out " + url).c_str()); 
    return 0;
}

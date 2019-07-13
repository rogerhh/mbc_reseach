#include <iostream>
#include <sstream>
#include <string.h>
#include <cstring>
#include <locale>
#include <stdexcept>
#include <algorithm>

#include "MBCFunctions.hpp"

using namespace MBC;
using namespace std;

int main(int argc, char** argv)
{
    if(argc != 5)
    {
        throw std::runtime_error("Usage: getSunData('start_time', 'end_time', lat, lon)\n" \
                                 "Dates should be in the form mm/dd/yy\n");
    }
    std::tm start_tm, end_tm;
    start_tm = read_tm_format(std::string(argv[1]) + "-00:00:00", 0);
    end_tm = read_tm_format(std::string(argv[2]) + "-00:00:00", 0);
    long double latitude = stold(string(argv[3])), longitude = stold(string(argv[4]));
    vector<SunriseSunsetData> v;
    while(start_tm <= end_tm)
    {
        SunriseSunsetData temp = get_sunrise_sunset_time(tm_to_string(start_tm).substr(0, 8),
                                                         latitude,
                                                         longitude);
        v.emplace_back(temp);
        start_tm.tm_mday++;
    }

    cout << v.size() << "\n";
    for(unsigned int i = 0; i < v.size(); i++)
    {
        cout << v[i].date.tm_year << " " << v[i].date.tm_mon << " " 
             << v[i].date.tm_mday << " " << v[i].sunrise_time << " "
             << v[i].sunset_time << "\n";
    }
    return 0;
}

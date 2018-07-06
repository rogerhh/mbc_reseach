#include <iostream>
#include <ctime>
#include <cstdlib>
#include <iomanip>

int main()
{
    std::tm t;
    t.tm_year = 118;
    t.tm_mon = 5;
    t.tm_mday = 19;
    t.tm_hour = 17;
    t.tm_min = 18;
    t.tm_sec = 30;
    t.tm_isdst = -1;
    time_t sec = mktime(&t);
    std::cout << sec << " " << std::put_time(std::gmtime(&sec), "%c") << " " << std::put_time(std::localtime(&sec), "%c") << "\n";
}

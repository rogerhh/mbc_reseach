#include <ctime>
#include <iostream>
#include <cstdlib>

using namespace std;

int main()
{
    std::tm tm;
    tm.tm_year = 100;
    tm.tm_mon = 3;
    tm.tm_mday = 12;
    tm.tm_hour = tm.tm_min = tm.tm_sec = 0;
    time_t t = timegm(&tm);
    cout << "stuff;" << endl;
}

#include <iostream>
#include <ctime>

using namespace std;

int main()
{
    tm tm;
    tm.tm_year = 118;
    tm.tm_mon = 5;
    tm.tm_mday = 39;
    tm.tm_hour = 3;
    tm.tm_min = 40;
    tm.tm_sec = 1;
    mktime(&tm);
    char str[64];
    strftime(str, sizeof(str), "%Y-%m-%d", &tm);
    cout << str << "\n";
    return 0;
}

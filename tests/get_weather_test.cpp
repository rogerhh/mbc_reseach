#include <iostream>
#include <sstream>
#include <string.h>
#include <cstring>
#include <locale>
#include <stdexcept>
#include <algorithm>

#include "../src/MBCFunctions.hpp"

using namespace MBC;
using namespace std;

int main(int argc, char** argv)
{
    std::vector<WeatherData> v;
    get_weather_data(v, 30, -65, "04/06/18-00:00:00", "04/07/18-00:00:00");
    return 0;
}

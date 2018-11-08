#include <iostream>

#include "unit_test_framework.h"
#include "../src/MBCFunctions.hpp"

using namespace std;
using namespace MBC;

TEST(url)
{
    std::vector<WeatherData> v;
    get_weather_data(v, 59.0, -83.27, "04/21/18-00:00:00", "04/22/18-00:00:00");
}

TEST(print_data)
{
    // std::ve
}

TEST_MAIN();

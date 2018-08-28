#include <iostream>

#include "unit_test_framework.h"
#include "../src/MBCFunctions.hpp"

using namespace std;
using namespace MBC;

TEST(url)
{
    std::vector<WeatherData> v;
    get_weather_data(v, 48.5, -83.27, "07/01/18-00:00:00", "08/07/18-00:00:00");
}

TEST_MAIN();

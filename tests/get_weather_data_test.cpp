#include <iostream>

#include "unit_test_framework.h"
#include "../src/MBCFunctions.hpp"

using namespace std;
using namespace MBC;

TEST(url)
{
    std::vector<WeatherData> v;
    get_weather_data(v, 48.0, -83.27, "04/06/18-00:00:00", "07/07/18-00:00:00");
}

TEST_MAIN();

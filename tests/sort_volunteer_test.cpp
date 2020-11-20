#include <iostream>

#include "unit_test_framework.h"
#include "../src/MBCFunctions.hpp"

using namespace std;
using namespace MBC;

TEST(sort_volunteer)
{
    sort_volunteer_data("08/01/20-00:00:00", "11/30/20-00:00:00");
}

TEST_MAIN();

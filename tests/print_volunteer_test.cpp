#include <iostream>

#include "unit_test_framework.h"
#include "../src/MBCFunctions.hpp"

using namespace std;
using namespace MBC;

TEST(sort_volunteer)
{
    print_volunteer_data("09/01/19-00:00:00", "10/04/19-00:00:00");
}

TEST_MAIN();

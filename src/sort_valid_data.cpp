#include <iostream>
#include <fstream>
#include <stdexcept>
#include <cstring>
#include <string.h>

#include "MBCFunctions.hpp"

using namespace MBC;
using namespace std;

int main (int argc, char** argv)
{
    int res =  sort_datapoints("01/01/18-00:00:00", "01/01/19-00:00:00");
    cout << "There are " << res << " valid days in the database.\n";
    return 0;
}


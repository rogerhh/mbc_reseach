#include <iostream>
#include <fstream>
#include <stdexcept>
#include <cstring>
#include <string.h>

#include "MBCFunctions.hpp"

using namespace MBC;
using namespace std;

int main(int argc, char** argv)
{
    vector<DataPoint> v;
    int serial_num = 20369361;
    string start_time_str = "06/25/18-11:50:10";
    string end_time_str = "06/25/18-11:53:50";
    get_datapoints_in_range(v, serial_num, 
        start_time_str, end_time_str);
    for(auto& i : v)
    {
        cout << i << "\n";
    }
    return 0;
}

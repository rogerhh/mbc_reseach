#include <iostream>

#include "../src/DataPoint.hpp"
#include "../src/MBCFunctions.hpp"

using namespace std;
using namespace MBC;

int main()
{
    vector<vector<DataPoint>> v;
    vector<int> serial_v;
    int res = select_datapoints(v, serial_v, "SN = 20369359 OR SN = 20369364");
    cout << res << " " << serial_v.size();
    return 0;
}

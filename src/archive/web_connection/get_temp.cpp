#include <iostream>
#include <stdexcept>

#include "../MBCFunctions.hpp"

using namespace MBC;
using namespace std;

int main()
{
    try
    {
        read_from_database();

        std::cout << datapoints.size() << " " << datapoints.begin()->first << " " << datapoints[datapoints.begin()->first].size() << " " << datapoints[20369359].size() << "\n";
    }
    catch(runtime_error& e)
    {
        cout << "runtime_error when reading from database.\n" << e.what() << "\n";
    }
    time_t t = read_time_format("06/19/18-23:00:00", -4);
    time_t start = read_time_format("06/20/18-00:00:00", 0);
    time_t end = read_time_format("06/21/18-00:00:00", 0);
    cout << start << " " << end << "\n";
    for(time_t i = start; i <= end; i += 10)
    {
        DataPoint* datapoint_ptr = datapoints[20369359][i];
        double d  = (*datapoint_ptr)[DataPoint::TEMPERATURE];
        cout << i << " " << (*datapoint_ptr)[DataPoint::TEMPERATURE] << "\n";
    }
    return 0;
}

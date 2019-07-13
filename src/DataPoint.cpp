#include "DataPoint.hpp"

#include <stdexcept>
#include <string>
#include <sstream>

namespace MBC
{

DataPoint::DataPoint() 
{
    serial_num = 0;
    time = 0;
    data = std::vector<double>(SIZE_OF_DATA_FIELDS, -1000);
}

DataPoint::DataPoint(const int serial_num_in, std::time_t time_in)
: serial_num(serial_num_in), time(time_in) 
{
    data = std::vector<double>(SIZE_OF_DATA_FIELDS, -1000);
}

/*
double& DataPoint::operator[](int index)
{
    if(!(index < SIZE_OF_DATA_FIELDS))
    {
        std::stringstream ss;
        ss << "Index out of range at time " << time 
           << ", serial number: " << serial_num << "\n";
        std::string msg = ss.str();
        throw std::runtime_error(msg);
    }
    return data[index];
}
*/

std::ostream& operator<<(std::ostream& os, DataPoint& datapoint)
{
    os << datapoint.serial_num << "," << datapoint.time;
    for(int i = 0; i < DataPoint::SIZE_OF_DATA_FIELDS; i++)
    {
        os << ",";
        double data_val = datapoint.data[i];
        if(data_val != -1000)
        {
            os << data_val;
        }
    }
    return os;
}

const char* DataPoint::FIELD_NAMES[] = {"serial_num",
                                        "time",
                                        "light_intensity",
                                        "temperature",
                                        "pressure",
                                        "latitude",
                                        "longitude"};

} // namespace MBC

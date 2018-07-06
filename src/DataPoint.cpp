#include "DataPoint.hpp"

// Define empty DataPoint
#ifndef EMPTY_DATAPOINT_HPP
#define EMPTY_DATAPOINT_HPP

#include <stdexcept>
#include <string>
#include <sstream>

namespace MBC
{

//const DataPoint EMPTY_DATAPOINT = DataPoint();

//DataPoint::DataPoint() {}

DataPoint::DataPoint(const int serial_num_in, std::time_t time_in)
: serial_num(serial_num_in), time(time_in) 
{
    formatted_time = std::gmtime(&time);
}

DataPoint::DataPoint(const int serial_num_in, std::tm* formatted_time_ptr)
: serial_num(serial_num_in)
{
    *formatted_time = *formatted_time_ptr;
}

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
    /*if(data[index] == -1000)
    {
        std::stringstream ss;
        ss << "Error retrieving data at time " << time << "; data index: " << index
           << "from serial number: " << serial_num << "\n";
        std::string msg = ss.str();
        throw std::runtime_error(msg);
    }*/
    return data[index];
}

std::ostream& operator<<(std::ostream& os, DataPoint& datapoint)
{
    os << datapoint.time << ",";
    for(int i = 0; i < DataPoint::SIZE_OF_DATA_FIELDS; i++)
    {
        double data_val = datapoint[i];
        if(data_val != -1000)
        {
            os << data_val;
        }
        os << ",";
    }
}

} // namespace MBC

#endif

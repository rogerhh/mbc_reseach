#ifndef DATAPOINT_HPP
#define DATAPOINT_HPP

#include <iostream>
#include <cstdint>
#include <vector>
#include <ctime>

namespace MBC
{

class DataPoint
{
public:
    int serial_num;

    // seconds since epoch
    std::time_t time; // seconds since an arbitrary start point

    DataPoint();

    DataPoint(const int serial_num_in, std::time_t time_in);

    // double& operator[](int index);

    // static constant expressions for data fields
    static constexpr int SIZE_OF_DATA_FIELDS = 5;

    static constexpr int LIGHT_INTENSITY = 0;
    static constexpr int TEMPERATURE     = 1;
    static constexpr int PRESSURE        = 2;
    static constexpr int LATITUDE        = 3;
    static constexpr int LONGITUDE       = 4;

    // string vector containing the name of all fields including serial number and time
    static const int SIZE_OF_FIELD_NAMES = 7;
    static const char* FIELD_NAMES[];

    // initiallizes data to -1000 to indicate that data is unavailable
    std::vector<double> data;

    struct less
    {
        bool operator()(const DataPoint& lhs, const DataPoint& rhs) const
        {
            return lhs.time < rhs.time;
        }
    };
};

std::ostream& operator<<(std::ostream& os, DataPoint& datapoint);

} // namespace MBC

#endif

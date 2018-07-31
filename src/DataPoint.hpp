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

    // pointer to formatted time structure expressed in Universal Coordinated Time
    std::tm* formatted_time;

    //DataPoint();

    DataPoint(const int serial_num_in, std::time_t time_in);

    DataPoint(const int serial_num_in, std::tm* formatted_time_ptr);

    double& operator[](int index);

    // static constant expressions for data fields
    static constexpr int SIZE_OF_DATA_FIELDS = 6;

    static constexpr int LIGHT_INTENSITY = 0;
    static constexpr int TEMPERATURE     = 1;
    static constexpr int PRESSURE        = 2;
    static constexpr int LATITUDE        = 3;
    static constexpr int LONGITUDE       = 4;
    static constexpr int WEATHER         = 5;

    static const std::vector<std::string> FIELD_STRINGS;

private:
    // initiallizes data to -1000 to indicate that data is unavailable
    std::vector<double> data = std::vector<double>(SIZE_OF_DATA_FIELDS, -1000);
};

/*struct DataPoint
{
    int serial_num;

    // seconds since epoch
    std::time_t time;

    // formatted time
    std::tm formatted_time;
    

    double light_intensity;
    double temperature;
    double pressure;
    double longitude;
    double latitude;
};*/

std::ostream& operator<<(std::ostream& os, DataPoint& datapoint);

} // namespace MBC

#endif

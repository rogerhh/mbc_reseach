#include "WeatherData.hpp"

#include <stdexcept>
#include <string>
#include <sstream>

namespace MBC
{

WeatherData::WeatherData()
{
    time = 0;
    data = std::vector<double>(SIZE_OF_DATA_FIELDS, -1000);
}

WeatherData::WeatherData(const std::time_t time_in, const double latitude, const double longitude)
: time(time_in)
{
    data = std::vector<double>(SIZE_OF_DATA_FIELDS, -1000);
    data[LATITUDE] = latitude;
    data[LONGITUDE] = longitude;
}

const char* WeatherData::FIELD_NAMES[] = {"time",
                             "latitude",
                             "longitude",
                             "pressure",
                             "sea_level_pressure",
                             "wind_speed",
                             "wind_direction",
                             "temperature",
                             "relative_humidity",
                             "dew_point",
                             "cloud_coverage",
                             "part_of_the_day",
                             "weather_code",
                             "visibility",
                             "precipitation",
                             "snowfall",
                             "dhi",
                             "dni",
                             "ghi",
                             "uv_index",
                             "solar_elevation_angle",
                             "solar_azimuth_angle",
                             "solar_hour_angle"};

std::ostream& operator<<(std::ostream& os, WeatherData& weatherdata)
{
    os << weatherdata.time;
    for(int i = 0; i < WeatherData::SIZE_OF_DATA_FIELDS; i++)
    {
        os << ",";
        double data_val = weatherdata.data[i];
        if(data_val != -1000)
        {
            os << data_val;
        }
    }
    return os;
}

} // namespace MBC

#include "SunriseSunsetData.hpp"

#include "MBCFunctions.hpp"

namespace MBC
{

SunriseSunsetData::SunriseSunsetData()
: latitude(0), longitude(0)
{
    date.tm_year = 0;
    date.tm_mon = 0;
    date.tm_mday = 0;
    sunrise_time = 0;
    sunset_time = 0;
}

SunriseSunsetData::SunriseSunsetData(const std::string& date_in,
                                     const long double latitude_in,
                                     const long double longitude_in,
                                     const std::time_t sunrise_in,
                                     const std::time_t sunset_in)
: latitude(latitude_in), longitude(longitude_in), sunrise_time(sunrise_in), sunset_time(sunset_in)
{
    std::tm tm;
    tm = read_tm_format(date_in + "-00:00:00", 0);
    date.tm_year = tm.tm_year;
    date.tm_mon = tm.tm_mon;
    date.tm_mday = tm.tm_mday;
    sunrise_time = 0;
    sunset_time = 0;
}

} // namespace MBC

#ifndef SUNRISE_SUNSET_DATA_HPP
#define SUNRISE_SUNSET_DATA_HPP

#include <ctime>
#include <string>

namespace MBC
{
bool operator<(const std::tm& lhs, const std::tm& rhs);

class SunriseSunsetData
{
public:
    // uses only the tm_year, tm_mon, tm_mday data fields
    std::tm date;

    std::time_t sunrise_time;
    std::time_t sunset_time;

    long double latitude;
    long double longitude;

    static const int SIZE_OF_FIELD_NAMES = 2;
    static const char* FIELD_NAMES[];

    SunriseSunsetData();

    // date_in must be of the form mm/dd/yy
    SunriseSunsetData(const std::string& date_in, 
                      const long double latitude_in,
                      const long double longitude_in,
                      const std::time_t sunrise_in,
                      const std::time_t sunset_in);

    struct less
    {
        bool operator()(const SunriseSunsetData& lhs, const SunriseSunsetData& rhs)
        {
            return lhs.date < rhs.date;
        }
    };
};

} // namespace MBC

#endif

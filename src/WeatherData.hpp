#ifndef WEATHER_DATA_HPP
#define WEATHER_DATA_HPP

#include <iostream>
#include <cstdint>
#include <vector>
#include <ctime>

namespace MBC
{

// data structure to store hourly accurate weather data
class WeatherData
{
public:
    std::time_t time;
    
    WeatherData();

    WeatherData(std::time_t time_in);

    // startic constant expressions for data fields
    static constexpr int SIZE_OF_DATA_FIELDS = 100;

    // basic package
    static constexpr int PRECIPITATION              = 0;
    static constexpr int PRECIPITATION_PROBABILITY  = 1;
    static constexpr int PRECIPITATION_HOURS        = 2;
    static constexpr int CONVECTIVE_PRECIPITATION   = 3;
    static constexpr int SNOW_FRACTION              = 4;
    static constexpr int TEMPERATURE                = 5;
    static constexpr int FELT_TEMPERATURE           = 6;
    static constexpr int PICTOCODE                  = 7;
    static constexpr int WIND_SPEED                 = 8;
    static constexpr int WIND_DIRECTION             = 9;
    static constexpr int RELATIVE_HUMIDITY          = 10;
    static constexpr int RH_OVER_90_PERCENT         = 11;
    static constexpr int SEA_LEVEL_PRESSURE         = 12;
    static constexpr int RAINSPOT                   = 13;
    static constexpr int PREDICTABILITY             = 14;
    static constexpr int PREDICTABILITY_CLASS       = 15;
    static constexpr int UV_INDEX                   = 16;
    static constexpr int IS_DAYLIGHT                = 17;

    // clouds
    static constexpr int LOW_CLOUDS                 = 18;
    static constexpr int MEDIUM_CLOUDS              = 19;
    static constexpr int HIGH_CLOUDS                = 20;
    static constexpr int TOTAL_CLOUD_COVER          = 21;
    static constexpr int VISIBILITY                 = 22;
    static constexpr int SUNSHINE_TIME              = 23;

    // solar
    static constexpr int GHI                        = 24;
    static constexpr int DIF                        = 25;
    static constexpr int DNI                        = 26;
    static constexpr int GNI                        = 27;
    static constexpr int EXTRATERRESTRIAL_SOLAR_RADIATION = 28;

    // data is initiallized to -1000 to indicate that data is unavailable
    std::vector<double> data;

    struct less
    {
        bool operator()(const WeatherData& lhs, const WeatherData& rhs)
        {
            return lhs.time < rhs.time;
        }
    };
};

std::ostream& operator<<(std::ostream& os, WeatherData& weatherdata);

} // namespace MBC

#endif

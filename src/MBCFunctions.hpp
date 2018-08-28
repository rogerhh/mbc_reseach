#ifndef MBC_FUNCTIONS_HPP
#define MBC_FUNCTIONS_HPP

#include <string>
#include <map>
#include <ctime>
#include <stdarg.h>

#include "mbc_config.hpp"
#include "DataPoint.hpp"
#include "WeatherData.hpp"
#include "SunriseSunsetData.hpp"

namespace MBC
{
bool operator<(const std::tm& lhs, const std::tm& rhs);
bool operator==(const std::tm& lhs, const std::tm& rhs);

// file path to database.db
static const std::string DATABASE_DB = std::string(mbc_source_dir) + "/data/mbc_database.db";

std::time_t read_time_format(const std::string& time_string, const double GMT_time);

// read string in mm/dd/yy-hh/mm/ss format
std::tm read_tm_format(const std::string& time_string, const double GMT_time);

// read AM and PM
std::tm read_tm_string(const std::string& time_string, const double GMT_time);

// modifies str to the string from lastpos to delim. Updates lastpos to the character after delim
void get_string(std::string& str, const std::string& source, 
                const std::string& delim, int& lastpos);

// wrapper function to get insert query string
void get_insertion_string(std::string& ret_str, 
                          const std::string& table_name,
                          int n, ...);

// add .hobo file to sqlite database
int add_file_to_sqlite(const std::string& path,
                       const double latitude,
                       const double longitude,
                       const std::string& start_time_str,
                       const std::string& end_time_str,
                       const std::string& database_path = DATABASE_DB);

int del_file_from_sqlite(const std::string& path,
                         const std::string& start_time_str,
                         const std::string& end_time_str,
                         const std::string& database_path = DATABASE_DB);

// modify the input two-deminsional vector matrix to all the datapoints
// that satisfy the constraints, each row containing datapoints from the 
// same logger, also modify the input vector serial_num_v to a list of
// seiral numbers of the datapoints read from the database, in the order
// of the rows of the matrix output
int select_datapoints(std::vector<std::vector<DataPoint>>& matrix,
                      std::vector<int>& serial_num_v,
                      const std::string& constraint_str,
                      const std::string& database_path = DATABASE_DB);

// gets weather parameters in a given time period denoted by 
// start_time_str <= time < end_time_str
// If the data is not already in the database, download data
// with API call to meteoblue
// start_time_str and end_time_str must be in the form mm/dd/yy-hh:mm:ss.
// Modifies the vector v into weather data retrieved
int get_weather_data(std::vector<WeatherData>& v,
                     const long double latitude,
                     const long double longitude,
                     const std::string& start_time_str,
                     const std::string& end_time_str,
                     const std::string& database_path = DATABASE_DB);

// gets sunrise-sunset times of a day at a particular location
// date must be in the form mm/dd/yy
// Returns a SunriseSunsetData object
SunriseSunsetData get_sunrise_sunset_time(const std::string& date,
                                          const long double latitude,
                                          const long double longitude,
                                          const std::string& database_path = DATABASE_DB);

} // namespace MBC

#endif


#ifndef MBC_FUNCTIONS_HPP
#define MBC_FUNCTIONS_HPP

#include <string>
#include <map>
#include <ctime>

#include "DataPoint.hpp"

namespace MBC
{

// version number of system
static const double VERSION = 1.1;

// file path to database
static const std::string DATABASE_FILE = "/home/rogerhh/mbc_research/data/database_file.csv"; 

// data structure containing all the data points
// access a DataPoint pointer with datapoints[SN][time_t]
extern std::map<int, std::map<std::time_t, DataPoint*>> datapoints;

// construct datapoints from raw .csv file
// throws runtime_error
// start_ and end_time_str must be in "mm/dd/yy-hh:mm:ss" 24-hour format
void add_file(const std::string& path, 
              const std::string& start_time_str, 
              const std::string& end_time_str,
              const double longtitude,
              const double latitude);

// delete all data of specified file in the database
void del_file(const std::string& path);

// write datapoints to  the database
void write_to_database(const std::string dest_file = DATABASE_FILE);

// construct datapoints from the database
void read_from_database(const std::string& source_file = DATABASE_FILE);

std::time_t read_time_format(const std::string& time_string, const double GMT_time);

void clean_database();

// this function should be called before program exits to clean up the heap
void delete_datapoints();

} // namespace MBC

#endif

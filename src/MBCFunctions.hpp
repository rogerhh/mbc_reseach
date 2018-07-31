#ifndef MBC_FUNCTIONS_HPP
#define MBC_FUNCTIONS_HPP

#include <string>
#include <map>
#include <ctime>
#include <stdarg.h>

#include "DataPoint.hpp"

namespace MBC
{

// version number of system
static const double VERSION = 1.1;

// file path to database
static const std::string DATABASE_FILE = "/home/rogerhh/mbc_research/data/database_file.csv"; 

// file path to database.db
static const std::string DATABASE_DB = "/home/rogerhh/mbc_research/data/mbc_database.db";

// data structure containing all the data points
// access a DataPoint pointer with datapoints[SN][time_t]
extern std::map<int, std::map<std::time_t, DataPoint*>> datapoints;

// construct datapoints from raw .csv file
// throws runtime_error
// start_ and end_time_str must be in "mm/dd/yy-hh:mm:ss" 24-hour format
// returns number of data points read
int add_file(const std::string& path, 
             const double longitude,
             const double latitude,
             const std::string& start_time_str, 
             const std::string& end_time_str);

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

// modifies str to the string from lastpos to delim. Updates lastpos to the character after delim
void get_string(std::string& str, const std::string& source, 
                const std::string& delim, int& lastpos);

// transfer data from the .csv file to the sqlite database
// returns number of datapoints transferred
int dump_to_database(const std::string& path = DATABASE_DB);

// wrapper function to get insert query string
void get_insertion_string(std::string& ret_str, 
                          const std::string& table_name,
                          int n, ...);

// Similar to add_file(...) but adds data directly to sqlite database
int add_file_to_sqlite(const std::string& path,
                       const double longitude,
                       const double latitude,
                       const std::string& start_time_str,
                       const std::string& end_time_str,
                       const std::string& database_path = DATABASE_DB);

} // namespace MBC

#endif

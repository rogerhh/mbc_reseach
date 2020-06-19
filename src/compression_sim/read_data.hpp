#ifndef READ_DATA_HPP
#define READ_DATA_HPP

#include <ctime>
#include <map>
#include <string>

std::map<std::time_t, double> read_file(const std::string& filename);

uint64_t get_data(const std::map<std::time_t, double>& data_map, time_t q);

double get_raw_data(const std::map<std::time_t, double>& data_map, time_t q);

#endif

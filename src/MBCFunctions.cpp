#include "MBCFunctions.hpp"

#include <iostream>
#include <fstream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <cmath>
#include <iomanip>

namespace MBC
{

void add_file(const std::string& path, 
              const std::string& start_time, 
              const std::string& end_time,
              const double longtitude,
              const double latitude)
{
    std::ifstream fin;
    fin.open(path);
    if(!fin.is_open())
    {
        std::stringstream ss;
        ss << "Error opening source file: " << path << "\n";
        std::string msg = ss.str();
        throw std::runtime_error(msg);
    }

    // check if data_file is in correct format
    fin.ignore(10, '"');
    std::string ignorable;
    fin >> ignorable;
    if(ignorable != "Plot")
    {
        std::stringstream ss;
        //std::cout << ignorable << "\"Plot" << "\n";
        ss << "File corrupted: " << path << "\n";
        std::string msg = ss.str();
        throw std::runtime_error(msg);
    }
    fin >> ignorable;

    // read sensor SN
    int SN;
    fin >> SN;
    fin.ignore(10, '\n');

    // read GMT_time
    double GMT_time;
    int GMT_hour, GMT_minute;
    char GMT_sign;
    fin.ignore(10, ',');
    fin.ignore(10, ',');
    fin.ignore(4, '\n');
    fin >> GMT_sign >> GMT_hour;
    fin.ignore(10, ':');
    fin >> GMT_minute;
    //std::cout << GMT_minute << " ";
    if(GMT_sign == '+') { GMT_time = GMT_hour + GMT_minute / 60.0; }
    else { GMT_time = -GMT_hour - GMT_minute / 60.0; }
    //std::cout << GMT_time << "\n"; 
        
    // read data type
    char str[20];
    std::string data_type;
    fin.ignore(10, ',');
    fin.ignore(10, '"');
    fin.get(str, 20, ',');
    data_type = std::string(str);
    //std::cout << data_type << "\n";
    int data_index;
    if(data_type == "Intensity")
    {
        data_index = 0;
    }
    else
    {
        std::stringstream ss;
        ss << "Unsupported data type in file: " << path << "\n";
        std::string msg = ss.str();
        throw std::runtime_error(msg);
    }
    //std::cout << data_index << "\n";

    // start reading data
    fin.ignore(60, '\n');

    // convert start_time and end_time to time_t objects
    while(fin.getline(str, 10, ','))
    {
        // read date
        std::tm tm;
        fin.getline(str, 5, '/');
        tm.tm_mon = std::stoi(std::string(str));
        fin.getline(str, 5, '/');
        tm.tm_mday = std::stoi(std::string(str));
        fin.getline(str, 5, ' ');
        tm.tm_year = std::stoi(std::string(str));
        tm.tm_year = tm.tm_year + 2000 - 1900;  // years since the Epoch

        // read time
        std::string sign;
        fin.getline(str, 5, ':');
        tm.tm_hour = std::stoi(std::string(str));
        fin.getline(str, 5, ':');
        tm.tm_min = std::stoi(std::string(str));
        fin.getline(str, 5, ' ');
        tm.tm_sec = std::stoi(std::string(str));
        fin.getline(str, 5, ',');
        sign = std::string(str);
        if(tm.tm_hour == 12 && sign == "AM") { tm.tm_hour = 0; }
        else if(tm.tm_hour != 12 && sign == "PM") { tm.tm_hour += 12; }

        time_t tm_seconds_since_epoch = mktime(&tm);

        /*std::cout << read_time_format(start_time, GMT_time) << " "
                  << tm_seconds_since_epoch << " "
                  << read_time_format(end_time, GMT_time) << "\n";*/

        // read data
        double data_value;
        fin >> data_value;
        fin.ignore(20, '\n');
        //std::cout << data_value << "\n";

        if(read_time_format(start_time, GMT_time) <= mktime(&tm) &&
           mktime(&tm) < read_time_format(end_time, GMT_time))
        {
            datapoints[SN][tm_seconds_since_epoch] = new DataPoint(SN, tm_seconds_since_epoch);
            DataPoint* datapoint_ptr = datapoints[SN][tm_seconds_since_epoch];
            (*datapoint_ptr)[data_index] = data_value;
            (*datapoint_ptr)[DataPoint::LONTITUDE] = longtitude;
            (*datapoint_ptr)[DataPoint::LATITUDE] = latitude;
        }
    }   
    fin.close();
    return;
}

void write_to_database(const std::string dest_file)
{
    std::ofstream fout;
    fout.open(dest_file);
    if(!fout.is_open())
    {
        std::stringstream ss;
        ss << "Error opening database file for writing: " << dest_file << "\n";
        std::string msg = ss.str();
        throw std::runtime_error(msg);
    }

    // print version number
    fout.flags(std::ios::fixed);
    fout.precision(1);
    fout << "VERSION " << VERSION << "\n";
    fout.unsetf(std::ios::fixed);
    fout.precision(6);

    // print current date time
    std::time_t curtime = std::time(0);
    fout << std::put_time(std::localtime(&curtime), "%c %Z") << "\n";

    for(auto i = datapoints.begin(); i != datapoints.end(); i++)
    {
        fout << "data_logger " << i->first << "\n";
        for(auto j = i->second.begin(); j != i->second.end(); j++)
        {
            fout << *(j->second) << "\n";
            fout.flush();
        }
        fout << "end_logger" << "\n";
    }
    fout << "end_database" << "\n";

    fout.close();
    return;
}

void read_from_database(const std::string& source_file)
{
    std::ifstream fin;
    fin.open(source_file);
    if(!fin.is_open())
    {
        std::stringstream ss;
        ss << "Error opening database file for reading: " << source_file << "\n";
        std::string msg = ss.str();
        throw std::runtime_error(msg);
    }

    char ignorable[60];
    fin >> ignorable;
    if(ignorable != "VERSION")
    {
        std::stringstream ss;
        ss << "Database file corrupted or unreadable: " << source_file << "\n";
        std::string msg = ss.str();
        throw std::runtime_error(msg);
    }

    double version_num;
    fin >> version_num;

    // read file according to version
    if(version_num == 1.0)
    {
        // ignore date
        fin.getline(ignorable, 60);
        fin.getline(ignorable, 10, ' ');
    }

    return;
}

std::time_t read_time_format(const std::string& time_string, const double GMT_time)
{
    int hr_shift = floor(GMT_time);
    int min_shift = (hr_shift == GMT_time)? 0 : 30;
    std::tm time;
    time.tm_mon = stoi(time_string.substr(0, 2));
    time.tm_mday = stoi(time_string.substr(3, 2));
    time.tm_year = stoi(time_string.substr(6, 2)) + 2000 - 1900;
    time.tm_hour = stoi(time_string.substr(9, 2));
    time.tm_min = stoi(time_string.substr(12, 2));
    time.tm_sec = stoi(time_string.substr(15, 2));
    time.tm_isdst = 0;
    return mktime(&time);
}

void delete_datapoints()
{
    for(auto i = datapoints.begin(); i != datapoints.end(); i++)
    {
        for(auto j = i->second.begin(); j != i->second.end(); j++)
        {
            delete j->second;
        }
    }
    return;
}

} // namespace MBC

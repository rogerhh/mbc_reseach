#include "MBCFunctions.hpp"

#include <cstdlib>
#include <iostream>
#include <fstream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <cstring>
#include <cmath>
#include <iomanip>
#include <time.h>
#include <sqlite3.h>

namespace MBC
{

std::map<int, std::map<std::time_t, DataPoint*>> datapoints;

int add_file(const std::string& path, 
             const double longitude,
             const double latitude,
             const std::string& start_time_str, 
             const std::string& end_time_str)
{
    // open .csv file
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
    char title_cstr[256];
    fin.getline(title_cstr, 60);
    std::string title_str = std::string(title_cstr);
    //std::cout << title_str << "\n";
    if(title_str.find("Plot Title:") == std::string::npos)
    {
        fin.close();
        std::stringstream ss;
        //std::cout << ignorable << "\"Plot" << "\n";
        ss << "File corrupted: " << path;
        std::string msg = ss.str();
        throw std::runtime_error(msg);
    }

    // read sensor SN
    int sn_pos = title_str.find(":") + 2;
    //std::cout << title_str << "\n" << title_str.substr(sn_pos, 8) << "\n";
    int SN = std::stoi(title_str.substr(sn_pos, 8));
    //std::cout << "read sn\n";

    // read GMT_time
    fin.getline(title_cstr, 256);
    title_str = std::string(title_cstr);
    size_t GMT_pos = title_str.find("GMT");
    double GMT_time;
    int GMT_hour = std::stoi(title_str.substr(GMT_pos + 4, 2));
    int GMT_minute = std::stoi(title_str.substr(GMT_pos + 7, 2));
    char GMT_sign = title_str[GMT_pos + 3];

    //std::cout << GMT_minute << " ";
    if(GMT_sign == '+') { GMT_time = GMT_hour + GMT_minute / 60.0; }
    else { GMT_time = -GMT_hour - GMT_minute / 60.0; }
    //std::cout << "GMT time = " << GMT_time << "\n"; 
        
    // read data type
    int fields_num = 0;
    int data_index1, data_index2;
    if(title_str.find("Temp") != std::string::npos)
    {
        fields_num++;
        data_index1 = DataPoint::TEMPERATURE;
        if(title_str.find("Intensity") != std::string::npos)
        {
            fields_num++;
            data_index2 = DataPoint::LIGHT_INTENSITY;
        }
    }
    else
    {
        fields_num++;
        data_index1 = DataPoint::LIGHT_INTENSITY;
    }
    
    //std::cout << "read data types\n";

    // convert start_time_str and end_time_str to time_t objects
    int data_count = 0;
    char cstr[256];
    while(fin.getline(cstr, 256))
    {
        std::string line = std::string(cstr), str;
        int lastpos = 0;

        // read date
        std::tm tm;
        tm.tm_isdst = -1;
        get_string(str, line, ",", lastpos);
        get_string(str, line, "/", lastpos);
        tm.tm_mon = std::stoi(str) - 1;         // month index starts from 0
        get_string(str, line, "/", lastpos);
        tm.tm_mday = std::stoi(str);
        get_string(str, line, " ", lastpos);
        tm.tm_year = std::stoi(str);
        tm.tm_year = tm.tm_year + 2000 - 1900;  // years since the Epoch

        // read time
        std::string sign;
        get_string(str, line, ":", lastpos);
        tm.tm_hour = std::stoi(str);
        get_string(str, line, ":", lastpos);
        tm.tm_min = std::stoi(str);
        get_string(str, line, " ", lastpos);
        tm.tm_sec = std::stoi(str);
        get_string(sign, line, ",", lastpos);
        if(tm.tm_hour == 12 && sign == "AM") { tm.tm_hour = 0; }
        else if(tm.tm_hour != 12 && sign == "PM") { tm.tm_hour += 12; }
        tm.tm_hour -= GMT_time;

        //std::cout << tm.tm_mon << " " << tm.tm_mday << " " << tm.tm_year << " " << tm.tm_hour << " " << tm.tm_min << " " << tm.tm_sec << " " << sign << "\n";

        time_t tm_seconds_since_epoch = timegm(&tm);
        
        bool in_range_flag = false;
        if(start_time_str == "NULL" && end_time_str == "NULL")
        {
            in_range_flag = true;
        }
        else
        {
            time_t start_time = read_time_format(start_time_str, GMT_time);
            time_t end_time = read_time_format(end_time_str, GMT_time);
            //std::cout << start_time << " " << tm_seconds_since_epoch << " " << end_time << "\n";
            in_range_flag = start_time <= tm_seconds_since_epoch &&
                            tm_seconds_since_epoch < end_time;
        }
        
        //std::cout << std::put_time(std::gmtime(&start_time), "%c") << " " << std::flush;
        //std::cout << std::put_time(std::gmtime(&tm_seconds_since_epoch), "%c");
        //std::cout << " " << std::flush;
        //std::cout << std::put_time(std::gmtime(&end_time), "%c") << "\n" << std::flush;

        //std::cout << start_time << " " << tm_seconds_since_epoch << " " << end_time << "\n" << std::flush;

        // read data
        double data_value1 = -1000, data_value2 = -1000;
        data_value1 = std::stof(line.substr(lastpos));
        if(fields_num == 2)
        {
            get_string(str, line, ",", lastpos);
            data_value2 = std::stof(line.substr(lastpos));
        }
        //std::cout << data_value << "\n";

        if(in_range_flag)
        {
            DataPoint* datapoint_ptr = new DataPoint(SN, tm_seconds_since_epoch);
            datapoints[SN][tm_seconds_since_epoch] = datapoint_ptr;
            (*datapoint_ptr)[data_index1] = data_value1;
            (*datapoint_ptr)[DataPoint::LONGITUDE] = longitude;
            (*datapoint_ptr)[DataPoint::LATITUDE] = latitude;
            if(fields_num == 2)
            {
                (*datapoint_ptr)[data_index2] = data_value2;
            }
            data_count++;
        }
    }   
    fin.close();
    std::cout << "Successfully added file: " << path << " with " << data_count << " data points.\n";
    return data_count;
}


void del_file(const std::string& path)
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

    // convert start_time_str and end_time_str to time_t objects
    while(fin.getline(str, 10, ','))
    {
        // read date
        std::tm tm;
        fin.getline(str, 5, '/');
        tm.tm_mon = std::atoi(str);
        fin.getline(str, 5, '/');
        tm.tm_mday = std::atoi(str);
        fin.getline(str, 5, ' ');
        tm.tm_year = std::atoi(str);
        tm.tm_year = tm.tm_year + 2000 - 1900;  // years since the Epoch

        // read time
        std::string sign;
        fin.getline(str, 5, ':');
        tm.tm_hour = std::atoi(str);
        fin.getline(str, 5, ':');
        tm.tm_min = std::atoi(str);
        fin.getline(str, 5, ' ');
        tm.tm_sec = std::atoi(str);
        fin.getline(str, 5, ',');
        sign = std::string(str);
        if(tm.tm_hour == 12 && sign == "AM") { tm.tm_hour = 0; }
        else if(tm.tm_hour != 12 && sign == "PM") { tm.tm_hour += 12; }

        time_t tm_seconds_since_epoch = timegm(&tm);

        // read data
        double data_value;
        fin >> data_value;
        fin.ignore(20, '\n');
        //std::cout << data_value << "\n";

        if(datapoints.find(SN) != datapoints.end() &&
           datapoints[SN].find(tm_seconds_since_epoch) != datapoints[SN].end())
        {
            DataPoint* datapoint_ptr = datapoints[SN][tm_seconds_since_epoch];
            (*datapoint_ptr)[data_index] = -1000;
        }
    }   
    fin.close();
    std::cout << "Successfully deleted file.\n";
    return;
}

void replace_string(std::string& str, const std::string& from, const std::string& to)
{
    size_t start_pos = str.find(from);
    if(start_pos != std::string::npos)
    {
        str.replace(start_pos, from.length(), to);
    }
    return;
}

void write_to_database(const std::string dest_file)
{
/*    // save old database to dataarchive/
    std::cout << "Moving old database to archive.\n";
    std::ifstream fin;
    fin.open(DATABASE_FILE);
    if(fin.is_open())
    {
        char time_str[60];
        fin.getline(time_str, 60);
        fin.getline(time_str, 60);
        
        std::string old_database_dest = DATABASE_FILE;
        replace_string(old_database_dest, ".csv", std::string(time_str) + ".csv");
        replace_string(old_database_dest, "/data/", "/data/data_archive/");
        std::system((std::string("cp ") + DATABASE_FILE + std::string(" ") + 
                     old_database_dest).c_str());
        std::cout << "Successfully moved old database to archive.\n";
    }
    else
    {
    std::cout << "Error saving old database file: " << DATABASE_FILE
              << "File cannot be opened.\n";
    }
*/

    // open dest file
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
    fout << std::put_time(std::localtime(&curtime), "%Y%m%d-%H%M%S%z") << "\n";

    for(auto i = datapoints.begin(); i != datapoints.end(); i++)
    {
        fout << "data_logger " << i->first << "\n";
        for(auto j = i->second.begin(); j != i->second.end(); j++)
        {
            fout << *(j->second) << "\n";
            fout.flush();
        }
        fout << "end_logger\n";
    }
    fout << "end_file\n";

    fout.close();
    std::cout << "Successfully wrote to database.\n";
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
    fin.getline(ignorable, 60, ' ');
    if(std::strcmp(ignorable, "VERSION") != 0)
    {
        std::stringstream ss;
        //std::cout << ignorable << "\n";
        ss << "Database file corrupted or unreadable: " << source_file << "\n";
        std::string msg = ss.str();
        throw std::runtime_error(msg);
    }

    char version_str[20];
    double version_num;
    fin.getline(version_str, 20);
    version_num = std::atof(version_str);

    long data_num = 0;

    // read file according to version
    // need to archive old code
    if(version_num == 1.1)
    {
        // ignore date
        fin.getline(ignorable, 60);

        char str[60];

        while(fin.getline(str, 60))
        {
            // if end_file is read, exit loop
            if(strcmp(str, "end_file") == 0)
            {
                break;
            }
            char* sn_str = strtok(str, " ");
            if(strcmp(sn_str, "data_logger") != 0)
            {
                throw std::runtime_error("cannot read serial number\n");
            }
            else
            {
                sn_str = strtok(NULL, " ");
                int serial_num = std::atoi(sn_str);
                if(serial_num == 0)
                {
                    throw std::runtime_error("what");
                }
                
                char num_str[60];
                while(fin.getline(num_str, 60))
                {
                    if(strcmp(num_str, "end_logger") == 0)
                    {
                        break;
                    }
                    size_t startpos = 0, endpos;
                    std::string num_cstr = std::string(num_str);
                    endpos = num_cstr.find(",");
                    int counter = -1;
                    std::time_t seconds_after_epoch = 0;
                    DataPoint* datapoint_ptr = nullptr;

                    data_num++;

                    while(counter < DataPoint::SIZE_OF_DATA_FIELDS && endpos != std::string::npos)
                    {
                        if(counter == -1)
                        {
                            //std::cout << num_cstr.substr(startpos, endpos - startpos);
                            //std::cout << startpos << " " << endpos << "\n";
                            // create object on heap
                            seconds_after_epoch = 
                                (time_t) std::stoll(num_cstr.substr(startpos, endpos - startpos));
                            if(seconds_after_epoch == 0) { throw std::runtime_error("what"); }
                            datapoint_ptr = new DataPoint(serial_num, seconds_after_epoch);
                            datapoints[serial_num][seconds_after_epoch] = datapoint_ptr;
                            //std::cout << serial_num << " " << seconds_after_epoch << "\n";
                        }
                        else
                        {
                            if(startpos == endpos)
                            {
                                (*datapoint_ptr)[counter] = -1000;
                            }
                            else
                            {
                                (*datapoint_ptr)[counter]
                                    = std::stof(num_cstr.substr(startpos, endpos - startpos));
                            }
                        }
                        startpos = endpos + 1;
                        endpos = num_cstr.find(",", startpos);
                        counter++;
                    }
                }
            }
        }

    }
    else
    {
        std::stringstream ss;
        ss << "Version number unsupported: " << version_num << "\n";
        std::string msg = ss.str();
        throw std::runtime_error(msg);
    }

    std::cout << "Successfully read from database. Read " << data_num << " datapoints\n";
    std::cout << datapoints.size() << " " << datapoints[20369359].size() << "\n";
    return;
}

std::time_t read_time_format(const std::string& time_string, const double GMT_time)
{
    int hr_shift = floor(GMT_time);
    int min_shift = (hr_shift == GMT_time)? 0 : 30;
    std::tm time;
    time.tm_mon = stoi(time_string.substr(0, 2)) - 1;
    time.tm_mday = stoi(time_string.substr(3, 2));
    time.tm_year = stoi(time_string.substr(6, 2)) + 2000 - 1900;
    time.tm_hour = stoi(time_string.substr(9, 2)) - hr_shift;
    time.tm_min = stoi(time_string.substr(12, 2)) - min_shift;
    time.tm_sec = stoi(time_string.substr(15, 2));
    time.tm_isdst = -1;
    return timegm(&time);
}



void clean_database()
{
    auto i = datapoints.begin();
    bool kill_i = false;
    while(i != datapoints.end())
    {
        auto j = i->second.begin();
        bool kill_j = false;
        while(j != i->second.end())
        {
            DataPoint* datapoint_ptr = j->second;
            double sum = 0;
            for(int count = 0; count < DataPoint::SIZE_OF_DATA_FIELDS; count++)
            {
                if(count == DataPoint::LONGITUDE || count == DataPoint::LATITUDE)
                { continue; }
                sum += (*datapoint_ptr)[count];
            }
            if(sum == -1000 * (DataPoint::SIZE_OF_DATA_FIELDS - 2)) { kill_j = true; }
            else { kill_j = false; }
            auto prev_j = j;
            j++;
            if(kill_j) { i->second.erase(prev_j); }
        }
        if(i->second.size() == 0) { kill_i = true; }
        else { kill_i = false; }

        auto prev_i = i;
        i++;
        if(kill_i) { datapoints.erase(prev_i); }
    }

    std::cout << "Successfully cleaned up database.\n";
    return;
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

void get_string(std::string& str, const std::string& source, 
                const std::string& delim, int& lastpos)
{
    int pos = source.find(delim, lastpos);
    if(pos == std::string::npos) { return; }
    str = source.substr(lastpos, pos - lastpos);
    lastpos = pos + 1;
    return;
}

int dump_to_database(const std::string& path)
{
    sqlite3* db;
    int rc = sqlite3_open(path.c_str(), &db);
    if(rc != SQLITE_OK)
    {
        std::stringstream ss;
        ss << "Error connecting to database: " << path << "\n";
        std::string msg = ss.str();
        throw std::runtime_error(msg);
    }
    std::string table_name = "SENSOR_DATA";
    std::string sql = "CREATE TABLE IF NOT EXISTS " + table_name + " (" \
                      "SN INT NOT NULL," \
                      "SECONDS_AFTER_EPOCH INT NOT NULL," \
                      "LATITUDE REAL NOT NULL," \
                      "LONGITUDE REAL NOT NULL," \
                      "LIGHT_INTENSITY REAL," \
                      "TEMPERATURE REAL," \
                      "PRIMARY KEY (SN, SECONDS_AFTER_EPOCH));";

    char* err_msg = nullptr;
    rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);

    if(rc != SQLITE_OK)
    {
        std::cout << "Error creating table.\n";
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        throw e;
    }
    else
    {
        std::cout << "Successfully created table " + table_name + ".\n";
    }

    int data_count = 0;
    auto it1 = datapoints.begin();
    while(it1 != datapoints.end())
    {
        auto it2 = it1->second.begin();
        while(it2 != it1->second.end())
        {
            DataPoint* datapoint_ptr = it2->second;
            sql = "INSERT INTO " + table_name + " VALUES (";
            // SN
            sql = sql + std::to_string(datapoint_ptr->serial_num) + ",";
            std::time_t seconds_after_epoch = datapoint_ptr->time;
            // SECONDS_AFTER_EPOCH
            sql = sql + std::to_string(seconds_after_epoch) + ",";
            // LATITUDE
            sql = sql + std::to_string((*datapoint_ptr)[DataPoint::LATITUDE]) + ",";
            // LONGITUDE
            sql = sql + std::to_string((*datapoint_ptr)[DataPoint::LONGITUDE]) + ",";
            // LIGHT_INTENSITY
            sql = sql + std::to_string((*datapoint_ptr)[DataPoint::LIGHT_INTENSITY]) + ",";
            // TEMPERATURE
            sql = sql + std::to_string((*datapoint_ptr)[DataPoint::TEMPERATURE]) + ");";

            std::cout << sql << "\n";

            rc = sqlite3_exec(db, sql.c_str(), nullptr, 0, &err_msg);
            if(rc != SQLITE_OK)
            {
                std::cout << sql << "\n";
                std::runtime_error e(err_msg);
                sqlite3_free(err_msg);
                throw e;
            }

            auto temp_it = it2;
            it2++;
            it1->second.erase(temp_it);
            data_count++;
        }
        auto temp_it = it1;
        it1++;
        datapoints.erase(temp_it);
    }
    std::cout << "Successfully dumped " << data_count << " datapoints into the database.\n";
    std::cout << datapoints.size() << "\n";
}

void get_insertion_string(std::string& ret_str,
                          const std::string& table_name, 
                          int n, ...)
{
    ret_str = "INSERT OR IGNORE INTO " + table_name + " VALUES (";
    va_list vl;
    va_start(vl, n);
    for(int i = 0; i < n; i++)
    {
        if(i != 0) { ret_str = ret_str + ","; }
        ret_str = ret_str + va_arg(vl, std::string);
    }
    ret_str = ret_str + ");";
    va_end(vl);
    //std::cout << ret_str << "\n";
    return;
}

int add_file_to_sqlite(const std::string& path, 
                       const double longitude,
                       const double latitude,
                       const std::string& start_time_str, 
                       const std::string& end_time_str,
                       const std::string& database_path)
{
    std::cout << "Reading from file: " << path << "\n";
    // open .csv file
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
    char title_cstr[256];
    fin.getline(title_cstr, 60);
    std::string title_str = std::string(title_cstr);
    if(title_str.find("Plot Title:") == std::string::npos)
    {
        fin.close();
        std::stringstream ss;
        ss << "File corrupted: " << path;
        std::string msg = ss.str();
        throw std::runtime_error(msg);
    }

    // connect with sqlite db
    sqlite3* db;
    int rc = sqlite3_open(database_path.c_str(), &db);
    if(rc != SQLITE_OK)
    {
        fin.close();
        std::stringstream ss;
        ss << "Error connecting to sqlite database: " << database_path;
        std::string msg = ss.str();
        throw std::runtime_error(msg);
    }

    std::string table_name = "SENSOR_DATA";
    // start by begining transaction
    std::string sql = "BEGIN TRANSACTION;" \
                      "CREATE TABLE IF NOT EXISTS " + table_name + " (" \
                      "SN INT NOT NULL,"    \
                      "SECONDS_AFTER_EPOCH INT NOT NULL,"    \
                      "LATITUDE REAL NOT NULL,"    \
                      "LONGITUDE REAL NOT NULL,"    \
                      "LIGHT_INTENSITY REAL," \
                      "TEMPERATURE REAL," \
                      "PRIMARY KEY (SN, SECONDS_AFTER_EPOCH));";

    char* err_msg = nullptr;
    rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);

    if(rc != SQLITE_OK)
    {
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        throw e;
    }
    else
    {
        // std::cout << "Successfullly created table\n";
    }

    // read sensor SN
    int sn_pos = title_str.find(":") + 2;
    std::string SN = title_str.substr(sn_pos, 8);

    // read GMT_time
    fin.getline(title_cstr, 256);
    title_str = std::string(title_cstr);
    size_t GMT_pos = title_str.find("GMT");
    double GMT_time;
    int GMT_hour = std::stoi(title_str.substr(GMT_pos + 4, 2));
    int GMT_minute = std::stoi(title_str.substr(GMT_pos + 7, 2));
    char GMT_sign = title_str[GMT_pos + 3];

    //std::cout << GMT_minute << " ";
    if(GMT_sign == '+') { GMT_time = GMT_hour + GMT_minute / 60.0; }
    else { GMT_time = -GMT_hour - GMT_minute / 60.0; }
    //std::cout << "GMT time = " << GMT_time << "\n"; 
        
    // read data type
    bool has_light = false, has_temp = false;
    int fields_num = 0;
    if(title_str.find("Temp") != std::string::npos)
    {
        has_temp = true;
        fields_num++;
        if(title_str.find("Intensity") != std::string::npos)
        {
            has_light = true;
            fields_num++;
        }
    }
    else
    {
        has_temp = true;
        fields_num++;
    }
    
    // convert start_time_str and end_time_str to time_t objects
    int data_count = 0;
    char cstr[256];
    while(fin.getline(cstr, 256))
    {
        std::string line = std::string(cstr), str;

        // change last character in line to ','
        line[line.length() - 1] = ',';
        int lastpos = 0;

        // read date
        std::tm tm;
        tm.tm_isdst = -1;
        get_string(str, line, ",", lastpos);
        get_string(str, line, "/", lastpos);
        tm.tm_mon = std::stoi(str) - 1;         // month index starts from 0
        get_string(str, line, "/", lastpos);
        tm.tm_mday = std::stoi(str);
        get_string(str, line, " ", lastpos);
        tm.tm_year = std::stoi(str);
        tm.tm_year = tm.tm_year + 2000 - 1900;  // years since the Epoch

        // read time
        std::string sign;
        get_string(str, line, ":", lastpos);
        tm.tm_hour = std::stoi(str);
        get_string(str, line, ":", lastpos);
        tm.tm_min = std::stoi(str);
        get_string(str, line, " ", lastpos);
        tm.tm_sec = std::stoi(str);
        get_string(sign, line, ",", lastpos);
        if(tm.tm_hour == 12 && sign == "AM") { tm.tm_hour = 0; }
        else if(tm.tm_hour != 12 && sign == "PM") { tm.tm_hour += 12; }
        tm.tm_hour -= GMT_time;

        time_t tm_seconds_since_epoch = timegm(&tm);
        
        bool in_range_flag = false;
        if(start_time_str == "NULL" && end_time_str == "NULL")
        {
            in_range_flag = true;
        }
        else
        {
            time_t start_time = read_time_format(start_time_str, GMT_time);
            time_t end_time = read_time_format(end_time_str, GMT_time);
            //std::cout << start_time << " " << tm_seconds_since_epoch << " " << end_time << "\n";
            in_range_flag = start_time <= tm_seconds_since_epoch &&
                            tm_seconds_since_epoch < end_time;
        }
        
        // read data
        std::string data_value1 = "NULL", data_value2 = "NULL";
        std::string temp_data = "NULL", light_data = "NULL";
        get_string(data_value1, line, ",", lastpos);
        if(fields_num == 2)
        {
            get_string(data_value2, line, ",", lastpos);
        }
        //std::cout << data_value << "\n";

        if(in_range_flag)
        {
            if(!has_temp)
            {
                light_data = data_value1;
            }
            else 
            {
                temp_data = data_value1;
                light_data = data_value2;
            }
            std::string sql;
            get_insertion_string(sql, "SENSOR_DATA", 6, 
                                 SN,
                                 std::to_string(tm_seconds_since_epoch),
                                 std::to_string(latitude),
                                 std::to_string(longitude),
                                 light_data,
                                 temp_data);

            //std::cout << sql << "\n" << std::flush;
            rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);

            if(rc != SQLITE_OK)
            {
                std::string err_str = std::string(err_msg);
                std::runtime_error e(err_msg);
                sqlite3_free(err_msg);
                throw e;
            }

            std::cout << "\r" << SN << " " << std::to_string(tm_seconds_since_epoch);

            data_count++;
        }
    }   

    std::cout << "\r";

    // commit transaction
    sql = "COMMIT TRANSACTION;";
    rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);

    if(rc != SQLITE_OK)
    {
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        throw e;
    }

    fin.close();
    std::cout << "Successfully added file: " << path << " with " << data_count << " data points.\n";
    return data_count;
}


int callback(void* v, int col_num, char** row_val, char** col_name)
{
    std::vector<DataPoint>* v_ptr = (std::vector<DataPoint>*) v;

    // Note: the order the values are stored must match the order of the columns in the database
    int serial_num = std::atoi(row_val[0]);
    std::time_t time = (std::time_t) std::atoll(row_val[1]);
    DataPoint data(serial_num, time);
    data[DataPoint::LATITUDE] = std::atof(row_val[2]);
    data[DataPoint::LONGITUDE] = std::atof(row_val[3]);
    data[DataPoint::LIGHT_INTENSITY] = (row_val[4] != nullptr)? std::atof(row_val[4]) : -1000;
    data[DataPoint::TEMPERATURE] = (row_val[5] != nullptr)? std::atof(row_val[5]) : -1000;
    v_ptr->emplace_back(data);
    return 0;
}

int get_datapoints_in_range(std::vector<DataPoint>& v,
                            const int serial_num,
                            const std::string& start_time_str,
                            const std::string& end_time_str,
                            const std::string& database_path)
{
    // clear all DataPoint's in vector
    v.clear();
    v.shrink_to_fit();

    // connect with sqlite db
    sqlite3* db;
    int rc = sqlite3_open(database_path.c_str(), &db);
    if(rc != SQLITE_OK)
    {
        std::stringstream ss;
        ss << "Error connecting to sqlite database: " << database_path;
        std::string msg = ss.str();
        throw std::runtime_error(msg);
    }

    std::time_t start_time = read_time_format(start_time_str, 0);
    std::time_t end_time = read_time_format(end_time_str, 0);

    std::string sql = "SELECT * FROM SENSOR_DATA WHERE SN = " + 
                      std::to_string(serial_num) +
                      " AND SECONDS_AFTER_EPOCH >= " + 
                      std::to_string(start_time) + 
                      " AND SECONDS_AFTER_EPOCH < " + 
                      std::to_string(end_time) + ";";
    char* err_msg;
    rc = sqlite3_exec(db, sql.c_str(), callback, &v, &err_msg);
    if(rc != SQLITE_OK)
    {
        std::string err_str = std::string(err_msg);
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        throw e;
    }

    return v.size();
}

} // namespace MBC

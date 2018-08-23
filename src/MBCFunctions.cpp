#include "MBCFunctions.hpp"

#include <cstdlib>
#include <iostream>
#include <fstream>
#include <sstream>
#include <stdexcept>
#include <cstring>
#include <cmath>
#include <iomanip>
#include <time.h>
#include <sqlite3.h>
#include <curl/curl.h>

namespace MBC
{

void replace_string(std::string& str,
                    const std::string& from,
                    const std::string& to)
{
    size_t start_pos = str.find(from);
    if(start_pos != std::string::npos)
    {
        str.replace(start_pos, from.length(), to);
    }
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

std::tm read_tm_format(const std::string& time_string, const double GMT_time)
{
    if(time_string.length() != 17)
    {
        std::cout << time_string << "\n";
        throw std::runtime_error("wrong time string length\n");
    }
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
    return time;
}

std::tm read_tm_string(const std::string& time_string, const double GMT_time)
{
    // read date
    std::tm tm;
    std::string str;
    int lastpos = 0;
    tm.tm_isdst = -1;
    get_string(str, time_string, "/", lastpos);
    tm.tm_mon = std::stoi(str) - 1;         // month index starts from 0
    get_string(str, time_string, "/", lastpos);
    tm.tm_mday = std::stoi(str);
    get_string(str, time_string, "-", lastpos);
    tm.tm_year = std::stoi(str);
    tm.tm_year = tm.tm_year + 2000 - 1900;  // years since the Epoch

    // read time
    std::string sign;
    get_string(str, time_string, ":", lastpos);
    tm.tm_hour = std::stoi(str);
    get_string(str, time_string, ":", lastpos);
    tm.tm_min = std::stoi(str);
    get_string(str, time_string, " ", lastpos);
    tm.tm_sec = std::stoi(str);
    get_string(sign, time_string, ",", lastpos);
    if(tm.tm_hour == 12 && sign == "AM") { tm.tm_hour = 0; }
    else if(tm.tm_hour != 12 && sign == "PM") { tm.tm_hour += 12; }
    tm.tm_hour -= GMT_time;
    return tm;
}

void get_string(std::string& str, const std::string& source, 
                const std::string& delim, int& lastpos)
{
    int pos = source.find(delim, lastpos);
    if(pos == std::string::npos) { return; }
    str = source.substr(lastpos, pos - lastpos);
    lastpos = pos + delim.length();
    return;
}

void get_insertion_string(std::string& ret_str,
                          const std::string& table_name, 
                          int n, ...)
{
    ret_str = "INSERT OR REPLACE INTO " + table_name + " VALUES (";
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

// TODO: rewrite sqlite3_exec function

int add_file_to_sqlite(const std::string& path, 
                       const double latitude,
                       const double longitude,
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

    std::string sql = "CREATE TABLE IF NOT EXISTS " + table_name + " (" \
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

    // begin transaction
    sql = "BEGIN TRANSACTION;";
    rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);

    if(rc != SQLITE_OK)
    {
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        throw e;
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
        fields_num = 1;
        if(title_str.find("Intensity") != std::string::npos)
        {
            has_light = true;
            fields_num = 2;
        }
    }
    else
    {
        has_temp = false;
        has_light = true;
        fields_num = 1;
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
            get_insertion_string(sql, table_name, 6, 
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

int del_file_from_sqlite(const std::string& path,
                         const std::string& start_time_str,
                         const std::string& end_time_str,
                         const std::string& database_path)
{
    return 0;
}

/*
int callback(void* handler_ptr, int col_num, char** row_val, char** col_name)
{
    std::vector<std::vector<DataPoint>>& matrix 
        = *(((Handler*) handler_ptr)->datapoint_m);
    std::vector<int>& serial_v = *(((Handler*) handler_ptr)->serial_v);

    bool is_in_list = false;
    int sn_index = 0;
    int serial_num = std::atoi(row_val[0]);
    std::time_t time = (std::time_t) std::atoll(row_val[1]);

    // check if serial_number is in list
    for(int i = 0; i < serial_v.size(); i++)
    {
        if(serial_num == serial_v[i])
        {
            is_in_list = true;
            sn_index = i;
            break;
        }
    }

    // if getting a datapoint from a new sensor
    // create a new row in the return matrix
    if(!is_in_list)
    {
        serial_v.push_back(serial_num);
        matrix.push_back(std::vector<DataPoint>());
        sn_index = serial_v.size() - 1;
    }

    // Note: the order the values are stored must match the order of the columns in the database
    DataPoint datapoint(serial_num, time);
    datapoint.data[DataPoint::LATITUDE] = std::atof(row_val[2]);
    datapoint.data[DataPoint::LONGITUDE] = std::atof(row_val[3]);
    datapoint.data[DataPoint::LIGHT_INTENSITY] = (row_val[4] != nullptr)? std::atof(row_val[4]) : -1000;
    datapoint.data[DataPoint::TEMPERATURE] = (row_val[5] != nullptr)? std::atof(row_val[5]) : -1000;
    matrix[sn_index].emplace_back(datapoint);
    ((Handler*) handler_ptr)->m_size++;
    return 0;
}
*/

int select_datapoints(std::vector<std::vector<DataPoint>>& matrix,
                      std::vector<int>& serial_num_v,
                      const std::string& constraint_str,
                      const std::string& database_path)
{
    // clear all DataPoint's in return matrix
    matrix.clear();
    matrix.shrink_to_fit();
    
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

    // construct query string
    std::string sql = "SELECT * FROM SENSOR_DATA";
    
    if(constraint_str != "NULL")
    {
        sql = sql + " WHERE " + constraint_str;
    }

    sql = sql + ";";

    char* err_msg;
    int size;

    struct Handler
    {
        std::vector<std::vector<DataPoint>>* datapoint_m;
        std::vector<int>* serial_v;
        int m_size;

        static int callback(void* handler_ptr, int col_num, char** row_val, char** col_name)
        {
            std::vector<std::vector<DataPoint>>& matrix 
                = *(((Handler*) handler_ptr)->datapoint_m);
            std::vector<int>& serial_v = *(((Handler*) handler_ptr)->serial_v);

            bool is_in_list = false;
            int sn_index = 0;
            int serial_num = std::atoi(row_val[0]);
            std::time_t time = (std::time_t) std::atoll(row_val[1]);

            // check if serial_number is in list
            for(int i = 0; i < serial_v.size(); i++)
            {
                if(serial_num == serial_v[i])
                {
                    is_in_list = true;
                    sn_index = i;
                    break;
                }
            }

            // if getting a datapoint from a new sensor
            // create a new row in the return matrix
            if(!is_in_list)
            {
                serial_v.push_back(serial_num);
                matrix.push_back(std::vector<DataPoint>());
                sn_index = serial_v.size() - 1;
            }

            // Note: the order the values are stored must match the order of the columns in the database
            DataPoint datapoint(serial_num, time);
            datapoint.data[DataPoint::LATITUDE] = std::stold(std::string(row_val[2]));
            datapoint.data[DataPoint::LONGITUDE] = std::stold(std::string(row_val[3]));
            datapoint.data[DataPoint::LIGHT_INTENSITY] 
                = (row_val[4] != nullptr)? std::stold(std::string(row_val[4])) : -1000;
            datapoint.data[DataPoint::TEMPERATURE] 
                = (row_val[5] != nullptr)? std::stold(std::string(row_val[5])) : -1000;
            matrix[sn_index].emplace_back(datapoint);
            ((Handler*) handler_ptr)->m_size++;
            return 0;
        }
    };

    // create handler object
    Handler handler;
    handler.datapoint_m = &matrix;
    handler.serial_v = &serial_num_v;
    handler.m_size = 0;

    rc = sqlite3_exec(db, sql.c_str(), Handler::callback, &handler, &err_msg);
    std::cout << matrix.size() << "\n";

    // TODO: replace this with sqlite3 prepare and stuff
/*
    sqlite3_stmt* stmt;
    const char* pztail = nullptr;
    do
    {
        rc = sqlite3_prepare_v2(db, sql.c_str(), 
                sql.length(), &stmt, &pztail);
        if(rc != SQLITE_OK)
        {
            std::string err_str = std::string(err_msg);
            std::runtime_error e(err_msg);
            sqlite3_free(err_msg);
            throw e;
        }
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            bool is_in_list = false;
            int sn_index = 0;
            int serial_num = sqlite3_column_int(stmt, 0);
            std::time_t time = sqlite3_column_int64(stmt, 1);

            // check if serial number is in list
            for(int i = 0; i < serial_num_v.size(); i++)
            {
                if(serial_num == serial_num_v[i])
                {
                    is_in_list = true;
                    sn_index = i;
                    break;
                }
            }

            // if getting a datapoint from a new sensor
            // create a new row in the return matrix
            if(!is_in_list)
            {
                serial_num_v.push_back(serial_num);
                matrix.push_back(std::vector<DataPoint>());
                sn_index = serial_num_v.size() - 1;
            }

            // Note: the order the values are stored must match 
            // the order of the columns in the database
            DataPoint datapoint(serial_num, time);
            datapoint.data[DataPoint::LATITUDE] = sqlite3_column_double(stmt, 2);
            datapoint.data[DataPoint::LONGITUDE] = sqlite3_column_double(stmt, 3);
            datapoint.data[DataPoint::LIGHT_INTENSITY] 
                = (sqlite3_column_bytes(stmt, 4) != 0)? sqlite3_column_double(stmt, 4) : -1000;
            datapoint.data[DataPoint::TEMPERATURE] 
                = (sqlite3_column_bytes(stmt, 5) != 0)? sqlite3_column_bytes(stmt, 5) : -1000;
            matrix[sn_index].emplace_back(datapoint);
            size++;
        }
        sqlite3_finalize(stmt);
    } while(!pztail);
*/

    if(rc != SQLITE_OK)
    {
        std::string err_str = std::string(err_msg);
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        throw e;
    }
    return handler.m_size;
}


int get_weather_data(std::vector<WeatherData>& v,
                     const double latitude,
                     const double longitude,
                     const std::string& start_time_str,
                     const std::string& end_time_str,
                     const std::string& database_path)
{
    std::time_t start_time = read_time_format(start_time_str, 0);
    std::time_t end_time = read_time_format(end_time_str, 0);

    //  TODO: resize vector to exactly the number of hours between start_time and end_time
    // clear return vector
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

    // TODO: queries database for time period and location. For all
    // time points at that location that are not in the database,
    // add that time point into a vector that would later be used to download data
    // from weather station. For all time points when there is data in the database,
    // add to return vector

    struct Handler
    {
        char* contents;
        size_t size;

        Handler()
        {
            contents = (char*) malloc(1);
            size = 0;
        }

        static int write_callback(void* retrieved_data,
                                  size_t retrieved_size,
                                  size_t nmemb,
                                  Handler* userptr)
        {
            size_t real_size = retrieved_size * nmemb;
            void* ptr = (char*) realloc(userptr->contents, userptr->size + real_size + 1);
            
            if(!ptr)
            {
                std::cout << "Not enough memory.\n";
                return 0;
            }
            memcpy(userptr->contents + userptr->size, retrieved_data, real_size);
            userptr->size = real_size;
            userptr->contents[userptr->size] = '\0';
            return real_size;
        }

        ~Handler()
        {
            free(contents);
        }
    };

    // TODO: api call to meteoblue to get data and store to database

    return 0;
}

// TODO: change everything to long double

SunriseSunsetData get_sunrise_sunset_time(const std::string& date,
                                          const long double latitude,
                                          const long double longitude,
                                          const std::string& database_path)
{
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

    // create table if not exist
    std::string table_name = "SUNRISE_SUNSET_DATA";
    std::string sql = "CREATE TABLE IF NOT EXISTS " + table_name + " (" \
                      "DATE TEXT NOT NULL," \
                      "LATITUDE REAL NOT NULL," \
                      "LONGITUDE REAL NOT NULL," \
                      "SUNRISE_TIME INT NOT NULL," \
                      "SUNSET_TIME INT NOT NULL," \
                      "PRIMARY KEY (DATE, LATITUDE, LONGITUDE))";

    char* err_msg = nullptr;
    rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);

    if(rc != SQLITE_OK)
    {
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        throw e;
    }

    // read from database. If date and location is in database, return that data value
    sql = "SELECT * FROM SUNRISE_SUNSET_DATA WHERE DATE = \"" + date  + "\" AND " \
          "LATITUDE = " + std::to_string(latitude) + " AND " \
          "LONGITUDE = " + std::to_string(longitude) + ";";
    
    struct Handler
    {
        SunriseSunsetData data;

        bool got_data_flag;

        static int callback(void* handler_ptr, int col_num, char** row_val, char** col_name)
        {
            Handler* ptr = (Handler*) handler_ptr;
            ptr->got_data_flag = true;
            std::string date_in = std::string(row_val[0]);
            long double lat = std::stold(std::string(row_val[1]));
            long double lng = std::stold(std::string(row_val[2]));
            std::time_t sunrise_time = std::atoll(row_val[3]);
            std::time_t sunset_time = std::atoll(row_val[4]);
            ptr->data = SunriseSunsetData(date_in, lat, lng, sunrise_time, sunset_time);
            return 0;
        }
    };

    Handler handler;
    handler.got_data_flag = false;
    rc = sqlite3_exec(db, sql.c_str(), Handler::callback, &handler, &err_msg);

    if(rc != SQLITE_OK)
    {
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        throw e;
    }

    if(handler.got_data_flag)
    {
        std::cout << "debug: read from database.\n";
        return handler.data;
    }

    struct memory_t
    {
        char* contents;
        size_t size;
        memory_t()
        {
            contents = (char*) malloc(1);
            size = 0;
        }
        ~memory_t()
        {
            free(contents);
        }

        static size_t write_callback(char* data, size_t size, size_t nmemb, memory_t* userptr)
        {
            size_t real_size = size * nmemb;
            userptr->contents = (char*) realloc(userptr->contents, userptr->size + real_size + 1);
            if(!userptr->contents)
            {
                std::cout << "Not enough memory.\n";
                return 0;
            }

            memcpy(userptr->contents + userptr->size, data, real_size);
            userptr->size += real_size;
            userptr->contents[userptr->size] = '\0';
            return real_size;
        }
    };
    
    CURL* curl;
    CURLcode res;
    curl_global_init(CURL_GLOBAL_DEFAULT);
    curl = curl_easy_init();

    memory_t data;
    if(curl)
    {
        // if date and location is not in database, call api to retrieve data value from the web
        std::tm date_tm = read_tm_format(date + "-00:00:00", 0);
        std::string date_str = std::to_string(date_tm.tm_year + 1900) + "-" +
                               std::to_string(date_tm.tm_mon + 1) + "-" +
                               std::to_string(date_tm.tm_mday);
        std::string url = "https://api.sunrise-sunset.org/json?" \
                          "&lat=" + std::to_string(latitude) +
                          "&lng=" + std::to_string(longitude) +
                          "&date=" + date_str;

        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_HTTPGET, 1L);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, memory_t::write_callback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &data);

        res = curl_easy_perform(curl);
        if(res != CURLE_OK)
        {
            std::cout << "Error: " << curl_easy_strerror(res) << "\n";
        }
    }

    curl_global_cleanup();

    std::cout << "debug: read from web\n";
    std::cout << data.contents << "\n";

    std::string result = std::string(data.contents);
    if(result.find("\"status\":\"OK\"") == std::string::npos)
    {
        throw std::runtime_error("Load sunrise-sunset api error\n");
    }

    std::string str;
    int lastpos = 0;
    get_string(str, result, "\"sunrise\":\"", lastpos);
    get_string(str, result, "\"", lastpos);
    str = date + "-" + str;
    std::cout << "debug: str = " << str << "\n";
    std::tm sunrise_tm = read_tm_string(str, 0);
    std::time_t sunrise_time = timegm(&sunrise_tm);

    get_string(str, result, "\"sunset\":\"", lastpos);
    get_string(str, result, "\"", lastpos);
    str = date + "-" + str;
    std::cout << "debug: str = " << str << "\n";
    std::tm sunset_tm = read_tm_string(str, 0);
    std::time_t sunset_time = timegm(&sunset_tm);

    if(sunrise_time >= sunset_time)
    {
        sunset_tm.tm_mday++;
        sunset_time = timegm(&sunset_tm);
    }

    std::cout << "debug: sunrise = " << sunrise_time << " sunset = " << sunset_time << "\n";

    get_insertion_string(sql, table_name, 5,
                         "\"" + date + "\"",
                         std::to_string(latitude),
                         std::to_string(longitude),
                         std::to_string(sunrise_time),
                         std::to_string(sunset_time));

    std::cout << "debug: sql = " << sql << "\n";

    rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);

    if(rc != SQLITE_OK)
    {
        std::string err_str = std::string(err_msg);
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        throw e;
    }

    return SunriseSunsetData(date, latitude, longitude, sunrise_time, sunset_time);
}

} // namespace MBC

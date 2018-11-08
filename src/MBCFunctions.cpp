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
#include <utility>
#include <cassert>

namespace MBC
{
bool operator<(std::tm& lhs, std::tm& rhs)
{
    std::time_t lhs_time = timegm(&lhs);
    std::time_t rhs_time = timegm(&rhs);
    return lhs_time < rhs_time;
}

bool operator==(std::tm& lhs, std::tm& rhs)
{
    std::time_t lhs_time = timegm(&lhs);
    std::time_t rhs_time = timegm(&rhs);
    return lhs_time == rhs_time;
}

bool operator<=(std::tm& lhs, std::tm& rhs)
{
    return (lhs < rhs) || (lhs == rhs);
}

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

// reset std::tm object to in-range values
// return 1 on success and 0 otherwise
bool reset_tm(std::tm* tm)
{
    return std::mktime(tm) != -1;
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
    std::cout << "debug: sign = " << sign << "\n";
    if(tm.tm_hour == 12 && sign == "AM") { tm.tm_hour = 0; }
    else if(tm.tm_hour != 12 && sign == "PM") { tm.tm_hour += 12; }
/*
    else
    {
        assert("AM PM not specified\n" && 0);
    }
*/
    tm.tm_hour -= GMT_time;
    return tm;
}

// TODO: deprecate this
// get string in the form mm/dd/yy-hh:mm:ss
std::string tm_to_string(std::tm tm)
{
    char temp[64];
    std::strftime(temp, sizeof(temp), "", &tm);
    std::string yr, mon, day, hr, min, sec;
    yr = std::to_string(tm.tm_year + 1900 - 2000);
    mon = std::to_string(tm.tm_mon + 1);
    mon = (mon.length() < 2)? "0" + mon : mon;
    day = std::to_string(tm.tm_mday);
    day = (day.length() < 2)? "0" + day : day;
    hr = std::to_string(tm.tm_hour);
    hr = (hr.length() < 2)? "0" + hr : hr;
    min = std::to_string(tm.tm_min);
    min = (min.length() < 2)? "0" + min : min;
    sec = std::to_string(tm.tm_sec);
    sec = (sec.length() < 2)? "0" + sec : sec;
    return mon + "/" + day + "/" + yr + "-" + hr + ":" + min + ":" + sec;
}

// TODO: deprecate this. Use strftime instead
// get string in the form yyyy-mm-dd
/*
std::string tm_to_full_string(std::tm tm)
{
    char temp[64];
    std::strftime(temp, sizeof(temp), "%Y-m", &tm);
    std::string yr, mon, day, hr, min, sec;
    yr = std::to_string(tm.tm_year + 1900);
    mon = std::to_string(tm.tm_mon + 1);
    mon = (mon.length() < 2)? "0" + mon : mon;
    // day = std::to_string(tm.tm_mday);
    day = (day.length() < 2)? "0" + day : day;
    hr = std::to_string(tm.tm_hour);
    hr = (hr.length() < 2)? "0" + hr : hr;
    min = std::to_string(tm.tm_min);
    min = (min.length() < 2)? "0" + min : min;
    sec = std::to_string(tm.tm_sec);
    sec = (sec.length() < 2)? "0" + sec : sec;
    return yr + "-" + mon + "-" + day;
}
*/

int get_string(std::string& str, const std::string& source, 
               const std::string& delim, int& lastpos)
{
    int pos = source.find(delim, lastpos);
    if(pos == std::string::npos) 
    { 
        str = "";
        return 0; 
    }
    str = source.substr(lastpos, pos - lastpos);
    lastpos = pos + delim.length();
    return 1;
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
        ret_str = ret_str + std::string(va_arg(vl, char*));
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
        sqlite3_close(db);
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
        sqlite3_close(db);
        throw e;
    }

    // begin transaction
    sql = "BEGIN TRANSACTION;";
    rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);

    if(rc != SQLITE_OK)
    {
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        sqlite3_close(db);
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
                                 SN.c_str(),
                                 std::to_string(tm_seconds_since_epoch).c_str(),
                                 std::to_string(latitude).c_str(),
                                 std::to_string(longitude).c_str(),
                                 light_data.c_str(),
                                 temp_data.c_str());

            //std::cout << sql << "\n" << std::flush;
            rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);

            if(rc != SQLITE_OK)
            {
                std::string err_str = std::string(err_msg);
                std::runtime_error e(err_msg);
                sqlite3_free(err_msg);
                sqlite3_close(db);
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
        sqlite3_close(db);
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
        sqlite3_close(db);
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

    if(rc != SQLITE_OK)
    {
        std::string err_str = std::string(err_msg);
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        sqlite3_close(db);
        throw e;
    }

    sqlite3_close(db);
    return handler.m_size;
}

int get_week_of_year(std::tm* tm)
{
    reset_tm(tm);
    return tm->tm_yday / 7;
}


int get_weather_data(std::vector<WeatherData>& v,
                     const long double latitude,
                     const long double longitude,
                     const std::string& start_time_str,
                     const std::string& end_time_str,
                     const std::string& database_path)
{
    std::time_t start_time = read_time_format(start_time_str, 0);
    std::time_t end_time = read_time_format(end_time_str, 0);

    std::cout << latitude << " " << longitude << "\n";
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
        sqlite3_close(db);
        throw std::runtime_error(msg);
    }

    std::string dates_table_name = "WEATHER_DATA_DATES";
    std::string sql = "CREATE TABLE IF NOT EXISTS " + dates_table_name + " (" \
                      "YEAR INT NOT NULL," \
                      "WEEK INT NOT NULL," \
                      "LATITUDE REAL NOT NULL," \
                      "LONGITUDE REAL NOT NULL," \
                      "PRIMARY KEY (YEAR, WEEK, LATITUDE, LONGITUDE));";

    char* err_msg = nullptr;

    rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);

    if(rc != SQLITE_OK)
    {
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        sqlite3_close(db);
        throw e;
    }

    std::tm start_time_tm = read_tm_format(start_time_str, 0);
    start_time_tm.tm_hour = 0;
    start_time_tm.tm_min = 0;
    start_time_tm.tm_sec = 0;

    reset_tm(&start_time_tm);
    start_time_tm.tm_mday -= start_time_tm.tm_yday % 7;

    std::tm end_time_tm = read_tm_format(end_time_str, 0);
    end_time_tm.tm_hour = 0;
    end_time_tm.tm_min = 0;
    end_time_tm.tm_sec = 0;

    // start of new weeks
    std::vector<std::tm> new_weeks;

    // TODO: change this into a year-week key to minimize overlap
    // gets all the dates that are not in the database into new_dates
    // directly comparing seconds after epoch for safety reasons
    while(start_time_tm < end_time_tm)
    {
        int week = get_week_of_year(&start_time_tm);
        sql = "SELECT * FROM " + dates_table_name + 
              " WHERE YEAR = " + std::to_string(start_time_tm.tm_year) +
              " AND WEEK = " + std::to_string(week) + 
              " AND LATITUDE = " + std::to_string(latitude) +
              " AND LONGITUDE = " + std::to_string(longitude) + ";";
        std::cout << "debug: sql = " << sql << "\n";

        struct Handler
        {
            bool flag;
            
            Handler()
            {
                flag = false;
            }

            static int callback(void* handler_ptr, int col_num, char** row_val, char** col_name)
            {
                for(int i = 0; i < col_num; i++)
                {
                    std::cout << row_val[i] << " ";
                }
                std::cout << "\n";
                Handler* ptr = (Handler*) handler_ptr;
                ptr->flag = true;
                return 0;
            }
        };

        Handler handler;

        rc = sqlite3_exec(db, sql.c_str(), Handler::callback, &handler, &err_msg);
        
        if(rc != SQLITE_OK)
        {
            std::string err_str = std::string(err_msg);
            std::runtime_error e(err_msg);
            sqlite3_free(err_msg);
            sqlite3_close(db);
            throw e;
        }

        // if callback function is not called, then the date is not found in the database,
        // add date to new_dates
        if(!handler.flag)
        {
            new_weeks.push_back(start_time_tm);
        }

        start_time_tm.tm_mday += 7;
        reset_tm(&start_time_tm);
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

        static int write_callback(void* retrieved_data,
                                  size_t retrieved_size,
                                  size_t nmemb,
                                  memory_t* userptr)
        {
            size_t real_size = retrieved_size * nmemb;
            userptr->contents = (char*) realloc(userptr->contents, userptr->size + real_size + 1);
            
            if(!userptr->contents)
            {
                std::cout << "Not enough memory.\n";
                return 0;
            }
            memcpy(userptr->contents + userptr->size, retrieved_data, real_size);
            userptr->size += real_size;
            userptr->contents[userptr->size] = '\0';
            return real_size;
        }
    };

    // store new weather data into database
    std::string weather_table_name = "WEATHER_DATA";
    sql = "CREATE TABLE IF NOT EXISTS " + weather_table_name + " (" \
          "SECONDS_AFTER_EPOCH INT NOT NULL,"   \
          "LATITUDE REAL NOT NULL,"     \
          "LONGITUDE REAL NOT NULL,"    \
          "PRESSURE REAL,"  \
          "SEA_LEVEL_PRESSURE REAL,"    \
          "WIND_SPEED REAL,"    \
          "WIND_DIRECTION REAL,"    \
          "TEMPERATURE REAL,"   \
          "RELATIVE_HUMIDITY REAL,"     \
          "DEW_POINT REAL," \
          "CLOUD_COVERAGE REAL,"    \
          "PART_OF_THE_DAY BOOL,"    \
          "WEATHER_CODE INT,"   \
          "VISIBILITY REAL,"    \
          "PRECIPITATION REAL," \
          "SNOWFALL REAL,"  \
          "DHI REAL,"   \
          "DNI REAL,"   \
          "GHI REAL,"   \
          "UV_INDEX REAL,"  \
          "SOLAR_ELEVATION_ANGLE REAL," \
          "SOLAR_AZIMUTH_ANGLE REAL,"   \
          "SOLAR_HOUR_ANGLE REAL,"  \
          "PRIMARY KEY (SECONDS_AFTER_EPOCH, LATITUDE, LONGITUDE));";

    rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);

    if(rc != SQLITE_OK)
    {
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        sqlite3_close(db);
        throw e;
    }

    CURL* curl;
    CURLcode res;
    // curl_global_init(CURL_GLOBAL_DEFAULT);
    curl = curl_easy_init();

    if(curl)
    {
        std::tm last_end_date_tm;
        std::tm new_start_date_tm;
        if(!new_weeks.empty())
        {
            last_end_date_tm = new_weeks[0];
            new_start_date_tm = new_weeks[0];
        }
        for(auto& new_start_date_tm : new_weeks)
        {
            // get seven days of data from web, saved in data.contents
            memory_t data;
            if(new_start_date_tm < last_end_date_tm)
            {
                continue;
            }
            last_end_date_tm = new_start_date_tm;
            last_end_date_tm.tm_mday += 7;
            // last_end_date_tm.tm_mday += 2;
            reset_tm(&last_end_date_tm);

            char new_start_date_str[64], last_end_date_str[64];
            std::strftime(new_start_date_str, 64, "%Y-%m-%d", &new_start_date_tm);
            std::strftime(last_end_date_str, 64, "%Y-%m-%d", &last_end_date_tm); 
            // tm_to_full_string(new_start_date_tm);
            std::string url = "http://api.weatherbit.io/v2.0/history/hourly" \
                              "?lat=" + std::to_string(latitude) +
                              "&lon=" + std::to_string(longitude) +
                              "&start_date=" + std::string(new_start_date_str) +
                              "&end_date=" + std::string(last_end_date_str) +
                              "&tz=utc" +
                              "&key=" + std::string(weatherbit_api_key);
            // std::cout << "url = " << url << "\n";
            curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
            curl_easy_setopt(curl, CURLOPT_HTTPGET, 1L);
            curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, memory_t::write_callback);
            curl_easy_setopt(curl, CURLOPT_WRITEDATA, &data);

            res = curl_easy_perform(curl);
            if(res != CURLE_OK)
            {
                std::cout << "Error: " << curl_easy_strerror(res) << "\n";
            }
            std::cout << "debug: contents = " << data.contents << std::flush << "\n" << data.size << "\n" << std::flush;

            // parse response
            std::vector<WeatherData> weather_v;
            int lastpos = 0;
            std::string str, source = std::string(data.contents);
            get_string(str, source, "\"data\":[", lastpos);

            while(get_string(str, source, "{", lastpos))
            {
                WeatherData weatherdata;
                if(get_string(str, source, "\"rh\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::RELATIVE_HUMIDITY]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"wind_spd\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::WIND_SPEED]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"slp\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::SEA_LEVEL_PRESSURE]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"vis\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::VISIBILITY]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"pod\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::PART_OF_THE_DAY]
                        = (str == "\"d\"")? 1 : 0;
                }

                if(get_string(str, source, "\"pres\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::PRESSURE]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"h_angle\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::SOLAR_HOUR_ANGLE]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"dewpt\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::DEW_POINT]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"snow\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::SNOWFALL]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"uv\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::UV_INDEX]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"elev_angle\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::SOLAR_ELEVATION_ANGLE]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"wind_dir\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::WIND_DIRECTION]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"code\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::WEATHER_CODE]
                        = (str != "null")? std::stoi(str) : -1000;
                }

                if(get_string(str, source, "\"ghi\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::GHI]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"dhi\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::DHI]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"dni\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::DNI]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"azimuth\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::SOLAR_AZIMUTH_ANGLE]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"temp\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::TEMPERATURE]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"precip\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::PRECIPITATION]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"clouds\":", lastpos))
                {
                    get_string(str, source, ",", lastpos);
                    weatherdata.data[WeatherData::CLOUD_COVERAGE]
                        = (str != "null")? std::stod(str) : -1000;
                }

                if(get_string(str, source, "\"ts\":", lastpos))
                {
                    get_string(str, source, "}", lastpos);
                    weatherdata.time
                        = (str != "null")? std::stold(str) : -1000;
                }

                weatherdata.data[WeatherData::LATITUDE] = latitude;
                weatherdata.data[WeatherData::LONGITUDE] = longitude;

                weather_v.emplace_back(weatherdata);
            }

            // begin storing data
            sql = "BEGIN TRANSACTION;";
            rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);
            
            for(auto&i : weather_v)
            {
                get_insertion_string(sql, weather_table_name, 23,
                                     std::to_string(i.time).c_str(),
                                     std::to_string(i.data[WeatherData::LATITUDE]).c_str(),
                                     std::to_string(i.data[WeatherData::LONGITUDE]).c_str(),
                                     std::to_string(i.data[WeatherData::PRESSURE]).c_str(),
                                     std::to_string(i.data[WeatherData::SEA_LEVEL_PRESSURE]).c_str(),
                                     std::to_string(i.data[WeatherData::WIND_SPEED]).c_str(),
                                     std::to_string(i.data[WeatherData::WIND_DIRECTION]).c_str(),
                                     std::to_string(i.data[WeatherData::TEMPERATURE]).c_str(),
                                     std::to_string(i.data[WeatherData::RELATIVE_HUMIDITY]).c_str(),
                                     std::to_string(i.data[WeatherData::DEW_POINT]).c_str(),
                                     std::to_string(i.data[WeatherData::CLOUD_COVERAGE]).c_str(),
                                     std::to_string(i.data[WeatherData::PART_OF_THE_DAY]).c_str(),
                                     std::to_string(i.data[WeatherData::WEATHER_CODE]).c_str(),
                                     std::to_string(i.data[WeatherData::VISIBILITY]).c_str(),
                                     std::to_string(i.data[WeatherData::PRECIPITATION]).c_str(),
                                     std::to_string(i.data[WeatherData::SNOWFALL]).c_str(),
                                     std::to_string(i.data[WeatherData::DHI]).c_str(),
                                     std::to_string(i.data[WeatherData::DNI]).c_str(),
                                     std::to_string(i.data[WeatherData::GHI]).c_str(),
                                     std::to_string(i.data[WeatherData::UV_INDEX]).c_str(),
                                     std::to_string(i.data[WeatherData::SOLAR_ELEVATION_ANGLE]).c_str(),
                                     std::to_string(i.data[WeatherData::SOLAR_AZIMUTH_ANGLE]).c_str(),
                                     std::to_string(i.data[WeatherData::SOLAR_HOUR_ANGLE]).c_str());
                // std::cout << sql << "\n";
                rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);
            }

            sql = "COMMIT TRANSACTION;";
            rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);

            if(rc != SQLITE_OK)
            {
                std::runtime_error e(err_msg);
                sqlite3_free(err_msg);
                sqlite3_close(db);
                curl_easy_cleanup(curl);
                throw e;
            }

            int week = get_week_of_year(&new_start_date_tm);
            
            get_insertion_string(sql, dates_table_name, 4,
                                 std::to_string(new_start_date_tm.tm_year).c_str(),
                                 std::to_string(week).c_str(),
                                 std::to_string(latitude).c_str(),
                                 std::to_string(longitude).c_str());
            std::cout << "sql = " << sql << "\n";

            rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);

            if(rc != SQLITE_OK)
            {
                std::runtime_error e(err_msg);
                sqlite3_free(err_msg);
                sqlite3_close(db);
                curl_easy_cleanup(curl);
                throw e;
            }
        }
    }

    curl_easy_cleanup(curl);

    struct Handler_1
    {
        std::vector<WeatherData>* weatherdata_v;

        static int callback(void* handler_ptr, int col_num, char** row_val, char** col_name)
        {
            std::vector<WeatherData>& v = *(((Handler_1*) handler_ptr)->weatherdata_v);
            WeatherData weatherdata;
            weatherdata.time = (std::time_t) std::atoll(row_val[0]);
            for(int i = 0; i < WeatherData::SIZE_OF_DATA_FIELDS; i++)
            {
                weatherdata.data[i] 
                    = (row_val[i + 1] != nullptr)? std::stold(std::string(row_val[i + 1])) 
                                                    : -1000;
            }
            v.emplace_back(weatherdata);
            return 0;
        }
    };

    Handler_1 handler_1;
    handler_1.weatherdata_v = &v;

    sql = "SELECT * FROM " + weather_table_name + 
          " WHERE SECONDS_AFTER_EPOCH >= " + std::to_string(start_time) +
          " AND SECONDS_AFTER_EPOCH < " + std::to_string(end_time) + 
          " AND LATITUDE = " + std::to_string(latitude) +
          " AND LONGITUDE = " + std::to_string(longitude) + ";";
    // std::cout << sql << "\n";

    rc = sqlite3_exec(db, sql.c_str(), Handler_1::callback, &handler_1, &err_msg);
    // std::cout << v.size() << "\n";

    if(rc != SQLITE_OK)
    {
        std::string err_str = std::string(err_msg);
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        sqlite3_close(db);
        throw e;
    }

    sqlite3_close(db);

    return v.size();
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
        sqlite3_close(db);
        throw std::runtime_error(msg);
    }

    // create table if not exist
    std::string table_name = "SUNRISE_SUNSET_DATA";
    std::string sql = "CREATE TABLE IF NOT EXISTS " + table_name + " (" \
                      "DATE STRING NOT NULL," \
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
        sqlite3_close(db);
        throw e;
    }

    if(handler.got_data_flag)
    {
        std::cout << "debug: read from database.\n";
        sqlite3_close(db);
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
    curl = curl_easy_init();

    memory_t data;
    if(curl)
    {
        // if date and location is not in database, call api to retrieve data value from the web
        std::tm date_tm = read_tm_format(date + "-00:00:00", 0);
        std::string date_str = std::to_string(date_tm.tm_year + 1900) + "-" +
                               std::to_string(date_tm.tm_mon + 1) + "-" +
                               std::to_string(date_tm.tm_mday);
        std::string url = "http://api.sunrise-sunset.org/json?" \
                          "&lat=" + std::to_string(latitude) +
                          "&lng=" + std::to_string(longitude) +
                          "&date=" + date_str;

        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_HTTPGET, 1L);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, memory_t::write_callback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &data);

        std::cout << url << "\n";

        res = curl_easy_perform(curl);
        if(res != CURLE_OK)
        {
            std::cout << "Error: " << curl_easy_strerror(res) << "\n";
        }
    }

    curl_easy_cleanup(curl);

    std::cout << "debug: read from web\n";
    // std::cout << data.contents << "\n";

    std::string result = std::string(data.contents);
    if(result.find("\"status\":\"OK\"") == std::string::npos)
    {
        sqlite3_close(db);
        throw std::runtime_error("Load sunrise-sunset api error\n");
    }

    std::string str;
    int lastpos = 0;
    get_string(str, result, "\"sunrise\":\"", lastpos);
    get_string(str, result, "\"", lastpos);
    str = date + "-" + str + ",";
    std::cout << "debug: str = " << str << "\n";
    std::tm sunrise_tm = read_tm_string(str, 0);
    std::time_t sunrise_time = timegm(&sunrise_tm);

    get_string(str, result, "\"sunset\":\"", lastpos);
    get_string(str, result, "\"", lastpos);
    str = date + "-" + str + ",";
    // std::cout << "debug: str = " << str << "\n";
    std::tm sunset_tm = read_tm_string(str, 0);
    std::time_t sunset_time = timegm(&sunset_tm);

    if(sunrise_time >= sunset_time)
    {
        sunset_tm.tm_mday++;
        sunset_time = timegm(&sunset_tm);
    }

    // std::cout << "debug: sunrise = " << sunrise_time << " sunset = " << sunset_time << "\n";

    get_insertion_string(sql, table_name, 5,
                         ("\"" + date + "\"").c_str(),
                         std::to_string(latitude).c_str(),
                         std::to_string(longitude).c_str(),
                         std::to_string(sunrise_time).c_str(),
                         std::to_string(sunset_time).c_str());

    // std::cout << "debug: sql = " << sql << "\n";

    rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);

    if(rc != SQLITE_OK)
    {
        std::string err_str = std::string(err_msg);
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        sqlite3_close(db);
        throw e;
    }

    sqlite3_close(db);

    return SunriseSunsetData(); //(date, latitude, longitude, sunrise_time, sunset_time);
}

void sort_volunteer_data(const std::string& start_time_str,
                         const std::string& end_time_str,
                         const std::string& volunteer_table,
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
        sqlite3_close(db);
        throw std::runtime_error(msg);
    }

    std::string info_table_name = "VOLUNTEER_SENSOR_INFO";

    std::string sql = "CREATE TABLE IF NOT EXISTS " + info_table_name + " (" \
                      "SN INT NOT NULL," \
                      "YEAR INT NOT NULL," \
                      "WEEK INT NOT NULL," \
                      "RECEIVED BOOL," \
                      "UPLOADED BOOL," \
                      "LOST BOOL," \
                      "PRIMARY KEY (SN, YEAR, WEEK))";

    char* err_msg = nullptr;
    rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);

    if(rc != SQLITE_OK)
    {
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        sqlite3_close(db);
        throw e;
    }

    std::tm start_time_tm = read_tm_format(start_time_str, 0);
    start_time_tm.tm_hour = 0;
    start_time_tm.tm_min = 0;
    start_time_tm.tm_sec = 0;

    reset_tm(&start_time_tm);
    start_time_tm.tm_mday -= start_time_tm.tm_yday % 7;

    std::tm end_time_tm = read_tm_format(end_time_str, 0);
    end_time_tm.tm_hour = 0;
    end_time_tm.tm_min = 0;
    end_time_tm.tm_sec = 0;

    std::ifstream fin(volunteer_table);
    if(!fin.is_open())
    {
        std::stringstream ss;
        ss << "Error opening volunteer table: " << volunteer_table << "\n";
        std::string msg = ss.str();
        sqlite3_close(db);
        throw std::runtime_error(msg);
    }

    struct Handler
    {
        bool flag = false;
        static int callback(void* handler_ptr, int col_num, char** row_val, char** col_name)
        {
            Handler* handler = (Handler*) handler_ptr;
            handler->flag = false;
            if(atoi(row_val[0]) > 0)
            {
                handler->flag = true;
            }
            return 0;
        }
    };

    int sn;
    Handler handler;

    std::string store_sql = "BEGIN TRANSACTION;";

    while(fin >> sn)
    {
        std::tm temp_start = start_time_tm;
        while(temp_start < end_time_tm)
        {
            std::tm temp_end = temp_start;
            temp_end.tm_mday += 7;
            temp_end.tm_sec -= 1;
            reset_tm(&temp_end);
            sql = "SELECT COUNT(*) FROM SENSOR_DATA WHERE" \
                   " SN = " + std::to_string(sn) +
                   " AND SECONDS_AFTER_EPOCH >= " + std::to_string(std::mktime(&temp_start)) + 
                   " AND SECONDS_AFTER_EPOCH < " + std::to_string(std::mktime(&temp_end)) + ";";
            // std::cout << "debug: " << sql << "\n";

            rc = sqlite3_exec(db, sql.c_str(), Handler::callback, &handler, &err_msg);

            if(rc != SQLITE_OK)
            {
                std::string err_str = std::string(err_msg);
                std::runtime_error e(err_msg);
                sqlite3_free(err_msg);
                sqlite3_close(db);
                throw e;
            }

            int week = get_week_of_year(&temp_start);
            store_sql = store_sql + "INSERT OR IGNORE INTO " +
                        info_table_name + " VALUES (" + 
                        std::to_string(sn) + "," +
                        std::to_string(temp_start.tm_year) + "," +
                        std::to_string(week) +
                        ",0,0,0);";

            if(handler.flag)
            {
                store_sql = store_sql + "UPDATE " +
                            info_table_name +
                            " SET UPLOADED = 1" \
                            " WHERE SN = " + std::to_string(sn) +
                            " AND YEAR = " + std::to_string(temp_start.tm_year) +
                            " AND WEEK = " + std::to_string(week) + ";";
            }

            temp_start = temp_end;
            temp_start.tm_sec += 1;
        }
    }

    store_sql = store_sql + "COMMIT TRANSACTION;";
    rc = sqlite3_exec(db, store_sql.c_str(), Handler::callback, &handler, &err_msg);
    // std::cout << "debug: store_sql = " << store_sql << "\n";

    if(rc != SQLITE_OK)
    {
        std::string err_str = std::string(err_msg);
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        sqlite3_close(db);
        throw e;
    }

    sqlite3_close(db);
}

void print_volunteer_data(const std::string& start_time_str,
                          const std::string& end_time_str,
                          const std::string& volunteer_table,
                          const std::string& sensor_info_table,
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
        sqlite3_close(db);
        throw std::runtime_error(msg);
    }

    std::string info_table_name = "VOLUNTEER_SENSOR_INFO";

    std::tm start_time_tm = read_tm_format(start_time_str, 0);
    start_time_tm.tm_hour = 0;
    start_time_tm.tm_min = 0;
    start_time_tm.tm_sec = 0;

    reset_tm(&start_time_tm);
    start_time_tm.tm_mday -= start_time_tm.tm_yday % 7;

    std::tm end_time_tm = read_tm_format(end_time_str, 0);
    end_time_tm.tm_hour = 0;
    end_time_tm.tm_min = 0;
    end_time_tm.tm_sec = 0;

    struct Handler
    {
        bool received = false, uploaded = false, lost = false;
        static int callback(void* handler_ptr, int col_num, char** row_val, char** col_name)
        {
            Handler* ptr = (Handler*) handler_ptr;
            ptr->received = ptr->uploaded = ptr->lost = false;
            if(!strcmp(row_val[0], "1"))
            {
                ptr->received = true;
            }
            if(!strcmp(row_val[1], "1"))
            {
                ptr->uploaded = true;
            }
            if(!strcmp(row_val[2], "1"))
            {
                ptr->lost = true;
            }
            return 0;
        }
    };

    int sn;
    Handler handler;

    std::ifstream fin(volunteer_table);
    std::ofstream fout(sensor_info_table);
    if(!fin.is_open())
    {
        std::stringstream ss;
        ss << "Error opening volunteer table: " << volunteer_table << "\n";
        std::string msg = ss.str();
        sqlite3_close(db);
        throw std::runtime_error(msg);
    }

    if(!fout.is_open())
    {
        std::stringstream ss;
        ss << "Error opening sensor info table: " << sensor_info_table << "\n";
        std::string msg = ss.str();
        sqlite3_close(db);
        throw std::runtime_error(msg);
    }

    std::string sql;
    char* err_msg;

    fout << "serial_num,";
    std::tm temp_start = start_time_tm;
    while(temp_start < end_time_tm)
    {
        int week = get_week_of_year(&temp_start);
        fout << std::to_string(temp_start.tm_year + 1900) << "-" << week << ",";
        temp_start.tm_mday += 7;
    }
    fout << "\n";
    
    while(fin >> sn)
    {
        std::tm temp_start = start_time_tm;
        fout << sn << ",";
        while(temp_start < end_time_tm)
        {
            int week = get_week_of_year(&temp_start);
            sql = "SELECT RECEIVED, UPLOADED, LOST FROM " + info_table_name + " WHERE" \
                   " SN = " + std::to_string(sn) +
                   " AND YEAR = " + std::to_string(temp_start.tm_year) +
                   " AND WEEK = " + std::to_string(week) + ";";
            // std::cout << "debug: " << sql << "\n";

            rc = sqlite3_exec(db, sql.c_str(), Handler::callback, &handler, &err_msg);

            if(handler.received)
            {
                fout << "O";
            }
            if(handler.uploaded)
            {
                fout << "V";
            }
            if(handler.lost)
            {
                fout << "X";
            }
            fout << ",";

            if(rc != SQLITE_OK)
            {
                std::string err_str = std::string(err_msg);
                std::runtime_error e(err_msg);
                sqlite3_free(err_msg);
                sqlite3_close(db);
                throw e;
            }

            temp_start.tm_mday += 7;
        }
        fout << "\n";
    }
    sqlite3_close(db);
}

} // namespace MBC

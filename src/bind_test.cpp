#include <iostream>

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

using namespace MBC;

int main()
{
    std::vector<std::vector<DataPoint>> matrix;
    std::string database_path = MBC::DATABASE_DB;
    std::string constraint_str = "SECONDS_AFTER_EPOCH >= ?1 AND SECONDS_AFTER_EPOCH < ?2 AND SN = ?3";
    // std::string constraint_str = "SECONDS_AFTER_EPOCH >= 1530014400 AND SECONDS_AFTER_EPOCH < 1530014460 AND SN = 20369361";
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
        std::cout << constraint_str << "\n";
    }
    else
    {
        return 0;
    }

    sql = sql + ";";

    char* err_msg;
    int size = 0;

    sqlite3_stmt* stmt;
    const char* pztail = nullptr;
    rc = sqlite3_prepare_v2(db, sql.c_str(), 
            sql.length(), &stmt, &pztail);
    if(rc != SQLITE_OK)
    {
        std::string err_str = std::string(err_msg);
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        throw e;
    }
    rc = sqlite3_bind_int64(stmt, 1, 1530014400);
    rc = sqlite3_bind_int64(stmt, 2, 1530014460);
    rc = sqlite3_bind_int64(stmt, 3, 20369361);
    if(rc != SQLITE_OK)
    {
        std::string err_str = std::string(err_msg);
        std::runtime_error e(err_msg);
        sqlite3_free(err_msg);
        throw e;
    }
    while(sqlite3_step(stmt) == SQLITE_ROW)
    {
/*
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
        // std::cout << datapoint.data[DataPoint::TEMPERATURE] << "\n";
        matrix[sn_index].emplace_back(datapoint);
*/
        size++;
    }
    std::cout << size << "\n";
    sqlite3_finalize(stmt);

    return 0;
}

#include <iostream>
#include <sqlite3.h>
#include <string.h>
#include <cstring>

using namespace std;

int main()
{
    char db_name[60] = "/home/rogerhh/mbc_research/data/testdb.db";
    sqlite3* db;
    int rc = sqlite3_open(db_name, &db);
    if(rc != SQLITE_OK)
    {
        cout << "Error connecting to database: " << db_name << "\n";
        return 0;
    }

    char sql[1024] = "CREATE TABLE IF NOT EXISTS SENSOR_DATA(" \
                     "SN    INT     NOT NULL,"    \
                     "SECONDS_AFTER_EPOCH  INT     NOT NULL,"    \
                     "LATITUDE  REAL NOT NULL,"    \
                     "LONGITUDE REAL NOT NULL,"    \
                     "LIGHT_INTENSITY REAL," \
                     "TEMPERATURE     REAL," \
                     "PRIMARY KEY (SN, SECONDS_AFTER_EPOCH))";

    char* err_msg = nullptr;
    rc = sqlite3_exec(db, sql, nullptr, 0, &err_msg);

    if(rc != SQLITE_OK)
    {
        cout << err_msg << "\n";
        sqlite3_free(err_msg);
        return 0;
    }
    else
    {
        cout << "Successfullly created table\n";
    }

    string cmd = "INSERT INTO SENSOR_DATA (SN, SECONDS_AFTER_EPOCH, LATITUDE, LONGITUDE, LIGHT_INTENSITY)" \
                  "VALUES (20369569, 1531293460, 43.297, -83.179, 365012.2);" \
                  "INSERT INTO SENSOR_DATA (SN, SECONDS_AFTER_EPOCH, LATITUDE, LONGITUDE, TEMPERATURE)" \
                  "VALUES (20369569, 1531293460, 43.297, -83.179, 365012.5);";

    rc = sqlite3_exec(db, cmd.c_str(), nullptr, 0, &err_msg);

    if(rc != SQLITE_OK)
    {
        cout << err_msg << "\n";
        sqlite3_free(err_msg);
        return 0;
    }
    else
    {
        cout << "Successfully added values\n";
    }

    sqlite3_close(db);

    return 0;
}

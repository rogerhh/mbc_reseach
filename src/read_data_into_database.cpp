#include <iostream>
#include <fstream>
#include <stdexcept>
#include <cstring>
#include <string.h>

#include "MBCFunctions.hpp"

using namespace MBC;
using namespace std;

int main (int argc, char** argv)
{
    if(argc != 2)
    {
        cout << "Usage: [path to new files list]\n";
        return 0;
    }

    string list_file = string(argv[1]);
    ifstream fin(list_file);
    if(!fin.is_open())
    {
        cout << "Error opening list file: " << list_file << "\n";
        return 0;
    }

    char line_cstr[256];
    int data_count  = 0;

    while(fin.getline(line_cstr, 256))
    {
        if(strlen(line_cstr) < 10)
        {
            continue;
        }
        string line = string(line_cstr);
        string str, path, start_time_str, end_time_str, lat_dir, lng_dir;
        double latitude, longitude;
        int lastpos = 0;

        // get path to file
        get_string(path, line, ",", lastpos);
        // path = "/home/rogerhh/Dropbox/UMICH/EE\ Research/data/csv_files/" + path;
        // path = "/home/rogerhh/Dropbox/UMICH/EE\ Research/data/csv_files_2/" + path;
        // path = "/home/rogerhh/Dropbox/UMICH/EE\ Research/data/csv_files_3/" + path;
        // path = "/home/rogerhh/Dropbox/UMICH/EE\ Research/data/csv_files_4/" + path;
        // path = "/home/rogerhh/Dropbox/UMICH/EE\ Research/data/csv_files_5/" + path;
        // path = "/home/rogerhh/Dropbox/UMICH/EE\ Research/data/csv_files_6/" + path;
        // path = "/home/rogerhh/Dropbox/UMICH/EE\ Research/data/csv_files_8/" + path;
        // path = "/home/rogerhh/Dropbox/UMICH/EE\ Research/data/csv_files_9/" + path;
        // path = "/home/rogerhh/Dropbox/UMICH/EE\ Research/data/csv_files_10/" + path;
        // path = "/home/rogerhh/Dropbox/UMICH/EE\ Research/data/csv_files_11/" + path;
        // path = "/home/rogerhh/Dropbox/UMICH/EE\ Research/data/csv_files_12/" + path;
        // path = "/home/rogerhh/Dropbox/UMICH/EE\ Research/data/csv_files_13/" + path;
        path = "/home/rogerhh/Dropbox/UMICH/EE\ Research/data/csv_files_14/" + path;
        
        // get latitude
        get_string(str, line, "o", lastpos);
        latitude = stof(str);
        get_string(str, line, "'", lastpos);
        latitude += stof(str) / 60.0;
        get_string(str, line, "\"", lastpos);
        latitude += stof(str) / 3600.0;
        lat_dir = line.substr(lastpos, 1);
        if(lat_dir == "S")
        {
            latitude *= -1;
        }
        else if(lat_dir != "N")
        {
            cout << "Latitude sign unrecognizable for file: " << path << "\n";
            continue;
        }

        // update lastpos to after next comma
        get_string(str, line, ",", lastpos);

        // get longitude
        get_string(str, line, "o", lastpos);
        longitude = stof(str);
        get_string(str, line, "'", lastpos);
        longitude += stof(str) / 60.0;
        get_string(str, line, "\"", lastpos);
        longitude += stof(str) / 3600.0;
        lng_dir = line.substr(lastpos, 1);
        if(lng_dir == "W")
        {
            longitude *= -1;
        }
        else if(lng_dir != "E")
        {
            cout << "Longitude sign unrecognizable for file: " << path << "\n";
            continue;
        }

        // update lastpos to after next comma
        get_string(str, line, ",", lastpos);


        // check if there is time input
        if(lastpos < line.length() - 10)
        {
            get_string(start_time_str, line, ",", lastpos);
            get_string(end_time_str, line, ",", lastpos);
        }
        else
        {
            start_time_str = end_time_str = "NULL";
        }

        if(lastpos < line.length() - 10)
        {
            cout << "Error with lastpos for file: " << path << "\n";
            continue;
        }

        try
        {
            int count = add_file_to_sqlite(path, latitude, longitude, start_time_str, end_time_str);
            data_count += count;
        }
        catch(runtime_error& e)
        {
            cout << "runtime_error when reading file " << list_file << "\n" << e.what() << "\n";
        }
    }

    cout << "Successfully read files with " << data_count << " data points\n";

    return 0;
}


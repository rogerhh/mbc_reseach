#include <iostream>
#include <fstream>
#include <stdexcept>
#include <cstring>
#include <string.h>
#include <vector>
#include <unordered_set>
#include <utility>
#include <cmath>

#include "MBCFunctions.hpp"

using namespace MBC;
using namespace std;

int main (int argc, char** argv)
{
    vector<string> index_table_paths;

    index_table_paths.push_back("/home/rogerhh/Dropbox/UMICH/EE\ Research/data/info_table.txt");
    index_table_paths.push_back("/home/rogerhh/Dropbox/UMICH/EE\ Research/data/info_table_2.txt");
    index_table_paths.push_back("/home/rogerhh/Dropbox/UMICH/EE\ Research/data/info_table_3.txt");
    index_table_paths.push_back("/home/rogerhh/Dropbox/UMICH/EE\ Research/data/info_table_4.txt");
    index_table_paths.push_back("/home/rogerhh/Dropbox/UMICH/EE\ Research/data/info_table_5.txt");
    index_table_paths.push_back("/home/rogerhh/Dropbox/UMICH/EE\ Research/data/info_table_6.txt");
    index_table_paths.push_back("/home/rogerhh/Dropbox/UMICH/EE\ Research/data/info_table_7.txt");

    string dest_path = "/home/rogerhh/mbc_research/data/locations_list.csv";
    ofstream fout(dest_path);

    if(!fout.is_open())
    {
        cout << "Error opening dest file: " << dest_path << "\n";
        return 0;
    }

    fout << "Latitude, Longitude\n";

    struct Hash
    {
        size_t operator()(const pair<double, double> p) const
        {
            return std::hash<double>()(p.first * 100 + p.second);
        }
    };

    int locations_count = 0;
    unordered_set<pair<double, double>, Hash> location_set;

    for(string path : index_table_paths)
    {
        ifstream fin(path);
        if(!fin.is_open())
        {
            cout << "Error opening list file: " << path << "\n";
            continue;
        }

        char line_cstr[256];

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

            get_string(path, line, ",", lastpos);

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

            latitude = round(latitude * 10) / 10;
            longitude = round(longitude * 10) / 10;

            if(location_set.find({latitude, longitude}) == location_set.end())
            {
                location_set.insert({latitude, longitude});
                locations_count++;
                fout << latitude << "," << longitude << "\n";
            }

        }

        fin.close();
    }

    cout << "There are " << locations_count << " distinct locations in the database.\n";

    return 0;
}


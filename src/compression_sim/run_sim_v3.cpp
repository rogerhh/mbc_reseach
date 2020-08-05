#include "read_data.hpp"
#include "Sim_v3.hpp"
#include "../json11.hpp"

#include <string>
#include <iostream>
#include <cstdlib>
#include <stdlib.h>
#include <fstream>
#include <regex>
#include <set>

using namespace json11;
using namespace std;

// DEPRECATED. Moved functions to Sims.hpp

int main(int argc, char** argv) {
    string ppath = getenv("PROJECT_DIR");
    ppath += "/data/src/compression_sim/";
    ifstream csv_list_fin(ppath + "csv_files_list_v3.txt");

    set<string> names;
    string name;
    while(getline(csv_list_fin, name)) {
        names.insert(name);
    }
    csv_list_fin.close();

    string filename = string(argv[1]);
    // if(names.find(filename) != names.end()) {
    //     // filename already processed
    //     return 0;
    // }

    // cout << filename << endl;
    Sim sim(filename, true);
    // sim.start_sim(78600, 10000, 22, 96, 29340, 60657, 1577670600, "sample_times.csv");

    time_t start_time = sim.light_measurement_map.begin()->first, end_time = sim.light_measurement_map.rbegin()->first;

    // cout << start_time << " " << end_time << " " << sim.parse_day_time(sim.start_day_time) << endl;

    // get location
    string path = getenv("PROJECT_DIR");
    // cout << path << endl;
    string cmd = "sqlite3 " + path + "/data/mbc_database.db \"select * from SENSOR_DATA where SN = " + to_string(sim.SN) + " and seconds_after_epoch = " + to_string(start_time) + "\" 1> /tmp/run_sim_location.tmp";
    // cout << cmd << endl;
    system(cmd.c_str());

    ifstream loc_fin("/tmp/run_sim_location.tmp");
    string data;
    if(!getline(loc_fin, data)) {
        cout << "Data not found in database for file: " << filename << endl;
        return 1;
    }

    regex e("(.+)\\|(.+)\\|(.+)\\|(.+)\\|(.+)\\|(.+)");
    smatch m;
    regex_search(data, m, e);

    double lat = stod(m.str(3)), lon = stod(m.str(4));

    sim.configure_sim(lat, lon);

    cmd = "curl \"https://api.sunrise-sunset.org/json?lat=" + to_string(lat) + "&lng=" + to_string(lon) + "&date=" + to_string(sim.start_tm.tm_year + 1900) 
            + "-" + to_string(sim.start_tm.tm_mon + 1) + "-" + to_string(sim.start_tm.tm_mday) + "\" 1> /tmp/run_sim_sunrise_sunset.tmp 2> /dev/null";
    // cout << cmd << endl;
    system(cmd.c_str());

    ifstream sun_fin("/tmp/run_sim_sunrise_sunset.tmp");
    if(!getline(sun_fin, data)) {
        cout << "Sunrise sunset api error" << endl;
        return 1;
    }

    string err;
    Json json = Json::parse(data, err);

    uint32_t sunrise = sim.day_time_2_sec(json["results"]["sunrise"].string_value()), sunset = sim.day_time_2_sec(json["results"]["sunset"].string_value());

    uint32_t duration = (end_time - start_time) / 3600 - 1;
    // cout << start_time << " " << end_time << endl;
    // cout << "duration = " << duration << endl;
    sim.start_sim(sim.start_day_time, 0, sim.start_hour_plus_one, duration, sunrise, sunset, start_time, ppath + "sample_times_v3.csv");

    // sim.start_sim(57000, 10000, 16, 24*31, 26504, 71122, 1537127400, "sample_times_1_month.csv");

    // map<time_t, double> data_map = read_file(filename);
    // cout << get_data(data_map, 1576103505) << " " << get_data(data_map, 1576103510) << " " << get_data(data_map, 1576103515) << " " << get_data(data_map, 1576103520) << endl;

    ofstream csv_list_fout(ppath + "csv_files_list_v3.txt", ios::out | ios::app);
    csv_list_fout << filename << endl;

}

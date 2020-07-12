#include "read_data.hpp"
#include "Sim.hpp"
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

int main(int argc, char** argv) {
    string ppath = getenv("PROJECT_DIR");
    ppath += "/data/src/compression_sim/";

    string filename = string(argv[1]);

    Sim sim(filename);

    time_t start_time = sim.measurement_map.begin()->first, end_time = sim.measurement_map.rbegin()->first;

    // get location
    string path = getenv("PROJECT_DIR");
    string cmd = "sqlite3 " + path + "/data/mbc_database.db \"select * from SENSOR_DATA where SN = " + to_string(sim.SN) + " and seconds_after_epoch = " + to_string(start_time) + "\" 1> /tmp/run_sim_location.tmp";
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

    cmd = "curl \"https://api.sunrise-sunset.org/json?lat=" + to_string(lat) + "&lng=" + to_string(lon) + "&date=" + to_string(sim.start_tm.tm_year + 1900) 
            + "-" + to_string(sim.start_tm.tm_mon + 1) + "-" + to_string(sim.start_tm.tm_mday) + "\" 1> /tmp/run_sim_sunrise_sunset.tmp 2> /dev/null";
    system(cmd.c_str());

    ifstream sun_fin("/tmp/run_sim_sunrise_sunset.tmp");
    if(!getline(sun_fin, data)) {
        cout << "Sunrise sunset api error" << endl;
        return 1;
    }

    string err;
    Json json = Json::parse(data, err);

    uint32_t sunrise = sim.day_time_2_sec(json["results"]["sunrise"].string_value()), sunset = sim.day_time_2_sec(json["results"]["sunset"].string_value());

    uint32_t duration = (end_time - start_time) / 3600;
    sim.start_compression_sim(sim.start_day_time, 0, sim.start_hour_plus_one, duration, sunrise, sunset, start_time);
}

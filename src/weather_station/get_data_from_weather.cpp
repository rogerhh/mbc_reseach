#include "../json11.hpp"
#include <string>
#include <iostream>
#include <fstream>

using namespace json11;
using namespace std;

int main(int argc, char** argv) {
    string station_id = "725374-94889";
    string start_date = "2020-05-20";
    string end_date = "2020-05-27";
    double lat = 42.292;
    double lon = -83.716;
    // string cmd = "curl \"api.weatherbit.io/v2.0/history/hourly?station=" + station_id + "&start_date=" + start_date + "&end_date=" + end_date + "&tz=utc&key=8942e41ad9544b3fb9e4f061b01aa5e7\" > /tmp/ws_data.json"; 
    string cmd = "curl \"api.weatherbit.io/v2.0/history/hourly?lat=" + to_string(lat) + "&lon=" + to_string(lon) + "&start_date=" + start_date + "&end_date=" + end_date + "&tz=utc&key=8942e41ad9544b3fb9e4f061b01aa5e7\" > /tmp/ws_data.json"; 
    cout << "cmd = " << cmd << endl;

    system(cmd.c_str());

    ifstream fin("/tmp/ws_data.json");
    ofstream fout("/home/rogerhh/mbc_research/src/weather_station/ws_data.csv");

    if(!fout.is_open()) {
        cout << "not open" << endl;
        return 1;
    }

    string data, err;
    if(!getline(fin, data)) {
        cout << "api error" << endl;
        return 1;
    }

    Json json = Json::parse(data, err);

    for(auto a : json["data"].array_items()) {
        time_t ts = a["ts"].int_value();
        double pres = a["pres"].number_value();

        fout << ts << "," << pres << endl;
    }

}

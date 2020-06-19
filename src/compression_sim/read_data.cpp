#include "read_data.hpp"

#include <iostream>
#include <fstream>
#include <iomanip>
#include <ctime>
#include <map>
#include <cassert>
#include <regex>
#include <sstream>

using namespace std;

map<time_t, double> read_file(const string& filename) {
    ifstream fin(filename);
    if(!fin.is_open()) {
        cout << "Error opening file: " << filename << endl;
        assert(0);
    }

    // read SN
    string line;
    getline(fin, line);

    // read time zone
    getline(fin, line);
    regex e("GMT([+-])([0-9]{2}):([0-9]{2})");
    smatch m;
    regex_search(line, m, e);

    string tz_sign = m.str(1);
    int tz_hr = stoi(m.str(2)), tz_min = stoi(m.str(3));

    map<time_t, double> res;

    while(getline(fin, line)) {
        regex e(",(.+M),");
        smatch m;
        regex_search(line, m, e);
        string date_time = m.str(1);

        istringstream iss(date_time);
        tm res_tm;
        string format("%m/%d/%y %H:%M:%S");
        iss >> get_time(&res_tm, format.c_str());

        // fix year bug in get_time
        res_tm.tm_year += 100;

        // fix AM/PM
        if(date_time.find("AM") != string::npos && res_tm.tm_hour == 12) {
            res_tm.tm_hour = 0;
        }
        else if(date_time.find("PM") != string::npos && res_tm.tm_hour != 12) {
            res_tm.tm_hour += 12;
        }

        // fix time zone
        if(tz_sign == "+") {
            res_tm.tm_hour -= tz_hr;
            res_tm.tm_min -= tz_min;
        }
        else {
            res_tm.tm_hour += tz_hr;
            res_tm.tm_min += tz_min;
        }

        time_t time = timegm(&res_tm);
        // cout << time << " ";
        e = regex("M,.+,(.+)");
        regex_search(line, m, e);
        // cout << m.str(1) << endl;;
        double data = stod(m.str(1));

        res.insert({time, data});
    }

    cout << "data file range: " << res.begin()->first << " - " << res.rbegin()->first << endl;

    return res;

};

uint64_t get_data(const std::map<std::time_t, double>& data_map, time_t q) {
    uint64_t res = (uint64_t) (get_raw_data(data_map, q) * 1577.536);
    if(res == 0) {
        return 15;
    }
    return res;
}

double get_raw_data(const std::map<std::time_t, double>& data_map, time_t q) {
    auto p = data_map.equal_range(q);
    double lux = 0;

    // if has that key, then just return
    if(p.first->first == q) {
        lux = p.first->second;
    }
    else {
        if(p.first == data_map.end()) {
            cout << "Query too big\n";
            throw 1;
        }
        else if(p.first == data_map.begin()) {
            cout << "Query too small\n";
            throw 2;
        }

        auto end = p.first;
        auto start = --p.first;


        // interpolate results
        time_t d1 = q - start->first, d2 = end->first - q;

        lux = (p.first->second * d2) / (d1 + d2) + (p.second->second * d1) / (d1 + d2);
    }

    return lux;
}

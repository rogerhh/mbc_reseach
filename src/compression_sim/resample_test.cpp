#include <iostream>
#include <fstream>
#include <string>
#include <ctime>
#include <map>
#include <regex>
#include <cstdlib>
#include <iomanip>

using namespace std;

#define EDGE_THRESHOLD 1
#define THRESHOLD_IDX_SHIFT 12
const int resample_indices[4] = {20, 28, 32, 1000};
const int interval_indices[4] = {1, 2, 8, 32};

map<time_t, double> light_measurement_map;
map<time_t, double> light_hobo_map;
map<time_t, double> light_sample_map;
map<time_t, double> temp_measurement_map;
map<time_t, double> temp_hobo_map;
map<time_t, double> temp_sample_map;
int start_time, end_time;
int resample_start_time, resample_end_time;
int tz_in_sec;
double lon, lat;

void read_file(const string& filename);
double get_raw_light_data(time_t q);


int main(int argc, char** argv) {
    if(argc != 7) {
        cerr << "Usage: ./resample_test.exe [file path name] [light hobo out] [temp hobo out] [light resampled out] [temp resampled out] [loc out]" << endl;
        exit(1);
    }

    string light_hobo_filename = string(argv[2]), temp_hobo_filename = string(argv[3]);
    string light_resampled_filename = string(argv[4]), temp_resampled_filename = string(argv[5]);
    ofstream light_hobo_fout(light_hobo_filename);
    ofstream temp_hobo_fout(temp_hobo_filename);
    ofstream light_resampled_fout(light_resampled_filename);
    ofstream temp_resampled_fout(temp_resampled_filename);


    read_file(string(argv[1]));


    // cout << (start_time % 86400) + tz_in_sec << " " << (end_time % 86400) + tz_in_sec << endl;
    // set resample start time to be next noon
    if((start_time % 86400) + tz_in_sec > 43200) {
        resample_start_time = start_time - (start_time % 86400 + tz_in_sec) + 86400 + 43200;
    }
    else {
        resample_start_time =  start_time - (start_time % 86400 + tz_in_sec) + 43200;
    }

    // set resample end time to be final noon
    if((end_time % 86400) + tz_in_sec > 43200) {
        resample_end_time = end_time - (end_time % 86400 + tz_in_sec) + 43200;
    }
    else {
        resample_end_time = end_time - (end_time % 86400 + tz_in_sec) - 86400 + 43200;
    }

    for(int t = resample_start_time; t < resample_end_time; t += 15) {
        light_hobo_fout << t << " " << get_raw_light_data(t) << endl;
    }

    // cout << resample_start_time << " " << (resample_start_time % 86400) + tz_in_sec << " "
    //      << resample_end_time << " " << (resample_end_time % 86400) + tz_in_sec << endl;

    int day_state_start_time = resample_start_time;
    bool is_dusk = true;
    while(day_state_start_time < resample_end_time) {
        int day_state_end_time = day_state_start_time + 43200;

        int start, end, interval;
        if(is_dusk) {
            start = day_state_end_time - 60;
            end = day_state_start_time - 60;
            interval = -60;
        }
        else {
            start = day_state_start_time;
            end = day_state_end_time;
            interval = 60;
        }

        int found_time = 0;
        int min_time = 0;
        double min_light = __DBL_MAX__;

        for(int t = start; t != end; t += interval) {
            double data = get_raw_light_data(t);
            light_hobo_map[t] = data;
            if(!found_time && data > EDGE_THRESHOLD) {
                found_time = t;
            }

            if(data < min_light) {
                min_light = data;
                min_time = t;
            }
        }

        if(!found_time) {
            start = min_time;
        }
        else {
            start = found_time - (THRESHOLD_IDX_SHIFT - 4) * interval;
        }

        int idx = 0;
        int next_sample_idx = 0;
        int interval_idx = 0;
        int resample_idx = 0;
        for(int t = start; t != end; t += interval) {
            if(idx == next_sample_idx) {
                double data = get_raw_light_data(t);
                light_sample_map[t] = data;
                resample_idx++;
                if(resample_idx == resample_indices[interval_idx]) {
                    interval_idx++;
                }
                next_sample_idx += interval_indices[interval_idx];
            }
            idx++;
        }

        is_dusk = !is_dusk;
        day_state_start_time += 43200;
    }

    for(auto p : light_sample_map) {
        light_resampled_fout << p.first << " " << p.second << endl;
    }

    string loc_file = string(argv[6]);
    ofstream loc_fout(loc_file);

    loc_fout << lat << " " << lon << endl;
}

void read_file(const string& filename) {
    ifstream fin(filename);
    if(!fin.is_open()) {
        cerr << "Error opening file: " << filename << endl;
        exit(1);
    }

    // read SN
    string line;
    getline(fin, line);
    regex e_sn("\"Plot Title: ([0-9]{8})");
    smatch m_sn;
    regex_search(line, m_sn, e_sn);
    int SN = stoi(m_sn.str(1));


    // read time zone
    getline(fin, line);
    regex e("GMT([+-])([0-9]{2}):([0-9]{2})");
    smatch m;
    regex_search(line, m, e);

    string tz_sign = m.str(1);
    int tz_hr = stoi(m.str(2));
    int tz_min = stoi(m.str(3));

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
            tz_in_sec = tz_hr * 3600 + tz_min * 60;
        }
        else {
            res_tm.tm_hour += tz_hr;
            res_tm.tm_min += tz_min;
            tz_in_sec = -tz_hr * 3600 - tz_min * 60;
        }

        // read light and temp
        time_t time = timegm(&res_tm);
        // cout << time << " ";
        e = regex("M,(.+),(.+)");
        regex_search(line, m, e);
        // cout << m.str(1) << endl;;
        double temp_data = stod(m.str(1));
        double light_data = stod(m.str(2));

        light_measurement_map.insert({time, light_data});
        temp_measurement_map.insert({time, temp_data});
    }

    start_time = light_measurement_map.begin()->first;
    end_time = light_measurement_map.rbegin()->first;

    // get location
    string path = getenv("PROJECT_DIR");
    // cout << path << endl;
    string cmd = "sqlite3 " + path + "/data/mbc_database.db \"select * from SENSOR_DATA where SN = " + to_string(SN) + " and seconds_after_epoch = " + to_string(start_time) + "\" 1> /tmp/run_sim_location.tmp";
    // cout << cmd << endl;
    system(cmd.c_str());

    ifstream loc_fin("/tmp/run_sim_location.tmp");
    string data;
    if(!getline(loc_fin, data)) {
        cerr << "Data not found in database for file: " << filename << endl;
        exit(1);
    }
    e = regex("(.+)\\|(.+)\\|(.+)\\|(.+)\\|(.+)\\|(.+)");
    regex_search(data, m, e);

    lat = stod(m.str(3));
    lon = stod(m.str(4));
}

double get_raw_light_data(time_t q) {
    auto p = light_measurement_map.equal_range(q);
    double res = 0;

    // if has that key, then just return
    if(p.first->first == q) {
        res = p.first->second;
    }
    else {
        if(q > light_measurement_map.rbegin()->first) {
            cout << "Query " << q << " too big\n";
            throw 1;
        }
        else if(q < light_measurement_map.begin()->first) {
            cout << "Query " << q << " too small\n";
            throw 2;
        }

        auto end = p.first;
        auto start = --p.first;


        // interpolate results
        time_t d1 = q - start->first, d2 = end->first - q;

        res = (p.first->second * d2) / (d1 + d2) + (p.second->second * d1) / (d1 + d2);
        // cout << q << " " << p.first->second << " " << p.second->second << endl;
    }

    return res;
}

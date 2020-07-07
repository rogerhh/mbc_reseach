#include "Sim.hpp"

#include "log2.hpp"

#include <iostream>
#include <fstream>
#include <cassert>
#include <regex>
#include <sstream>
#include <iomanip>
#include <cmath>

using namespace std;

Sim::Sim(const string& filename_in) {
    measurement_map = read_file(filename_in);
    regex e("(.+)\/(.+)\.csv");
    smatch m;
    regex_search(filename_in, m, e);
    filename = m.str(2);
    cout << filename;
}

void Sim::start_sim(uint32_t day_time_in, uint32_t sys_time_in, 
                    uint32_t start_hour, uint32_t duration_in_hour,
                    uint32_t cur_sunrise_in, uint32_t cur_sunset_in,
                    uint32_t epoch_time,
                    const string& sample_times_file) {

    day_time = day_time_in;
    sys_time = sys_time_in;
    cur_sunrise = cur_sunrise_in;
    cur_sunset = cur_sunset_in;
    sys_to_epoch_offset = epoch_time - sys_time;

    ofstream sample_times_fout(sample_times_file);

    if(!sample_times_fout.is_open()) {
        cout << "Error opening file: " << sample_times_file << endl;
        exit(1);
    }

    string ppath = getenv("PROJECT_DIR");
    ppath += "/data/src/compression_sim/";
    ofstream samples_1min_fout("sample_times_1min.csv");
    ofstream samples_2min_fout("sample_times_2min.csv");
    ofstream samples_8min_fout("sample_times_8min.csv");
    ofstream samples_32min_fout("sample_times_32min.csv");
    ofstream sunrise_time_diff_fout(ppath + "sunrise_time_diff.csv", ios::out | ios::app);
    ofstream sunset_time_diff_fout(ppath + "sunset_time_diff.csv", ios::out | ios::app);
    ofstream sample_data_fout(ppath + "sample_data/" + filename + ".csv");
    
    // read code difference map
    map<int, int> code_diff_map;
    ifstream code_diff_fin(ppath + "code_diff.txt");
    int diff, count;
    while(code_diff_fin >> diff >> count) {
        code_diff_map[diff] = count;
    }
    code_diff_fin.close();


    uint32_t start_hour_in_sec = start_hour * 3600;
    next_sys_time = sys_time + start_hour_in_sec - day_time_in;

    uint32_t end_time = sys_time + duration_in_hour * 3600;

    // cout << next_sys_time << " " << end_time << " " << duration_in_hour << " " << end_time + sys_to_epoch_offset << endl;

    cur_index = 0;

    // set is_morning
    if(day_time <= (43200 - 1800) || day_time > (86400 - 1800)) {
        // set 30 minute margin from noon and midnight
        is_morning = 1;
    }
    else {
        is_morning = 0;
    }

    // cout << "cur_sunrise = " << parse_day_time(cur_sunrise) 
    //      << "; cur_sunset = " << parse_day_time(cur_sunset) << endl
    //      << "next_sunrise = " << parse_day_time(next_sunrise) 
    //      << "; next_sunset = " << parse_day_time(next_sunset) << endl
    //      << "sys_time = " << sys_time << "; day_time = " << parse_day_time(day_time) << endl
    //      << "sys_to_epoch_offset = " << sys_to_epoch_offset 
    //      << "; next_sys_time = " << next_sys_time << endl
    //      << "is_morning = " << (int) is_morning << "; cur_index = " << (int) cur_index
    //      << "; interval_index = " << (int) interval_index << endl;

    uint16_t last_light_code = 0;

    while(1) {
        // find out starting index
        if(cur_index == 0) {
            // start with the very last time
            // work forward until target day time is in the half-day 
            // and the smallest possible index
            // that is greater than current day time
            interval_index = 0;
            cur_index = 0;

            uint8_t new_start = 0;

            // determine is need to compare with current day time
            // assume is_morning is reset some time before NOON or MAX_DAY_TIME
            if(is_morning && day_time > NOON) {
                new_start = 1;
            }
            else if(!is_morning && day_time <= NOON) {
                new_start = 1;
            }

            uint32_t margin1, margin2, edge;

            if(is_morning) {
                margin1 = 0 + 480;
                margin2 = NOON - 480;
                edge = cur_sunrise;
            }
            else {
                margin1 = NOON + 480;
                margin2 = MAX_DAY_TIME - 480;
                edge = cur_sunset;
            }

            uint32_t next_day_time = edge - EDGE_MARGIN;    // TODO: fix

            // cout << "edge = " << parse_day_time(edge) 
            //      << "; margin1 = " << parse_day_time(margin1)
            //      << "; margin2 = " << parse_day_time(margin2)
            //      << "; new_start = " << new_start << endl;

            while(1) {
                // FIXME: this is wrong but I'm going to bed
                // if new start, then don't need to check margin1
                if(next_day_time >= margin1 && next_day_time < margin2
                        &&(next_day_time > day_time || new_start)) {
                    break; 
                }

                next_day_time += (INTERVALS[interval_index] * 60);
                cur_index++;

                if(cur_index >= dawn_indices[interval_index]) {
                    interval_index++;
                }
            }

            if(next_day_time > day_time) {
                next_sys_time = sys_time + next_day_time - day_time;
            }
            else {
                next_sys_time = sys_time + next_day_time + MAX_DAY_TIME - day_time;
            }
        }

        // cout << "next_sys_time = " << next_sys_time << endl;
        if(next_sys_time > end_time) {
            break;
        }

        // increment sys_time and day_time to represent waking up
        day_time += (next_sys_time - sys_time);
        if(day_time >= MAX_DAY_TIME) {
            day_time -= MAX_DAY_TIME;
        }
        sys_time = next_sys_time;
        next_sys_time = 0;

        // take measurement and take log
        time_t q = sys_time + sys_to_epoch_offset;
        double lux = get_raw_data(measurement_map, q);

        if(storing_data) {
            if(INTERVALS[interval_index] == 1) {
                samples_1min_fout << q << "," << lux << endl;
            }
            else if(INTERVALS[interval_index] == 2) {
                samples_2min_fout << q << "," << lux << endl;
            }
            else if(INTERVALS[interval_index] == 8) {
                samples_8min_fout << q << "," << lux << endl;
            }
            else if(INTERVALS[interval_index] == 32) {
                samples_32min_fout << q << "," << lux << endl;
            }
        }

        uint64_t raw_light_code = get_data(measurement_map, q);
        uint16_t light_code = func_log2(raw_light_code + 1);

        // storing_data = true;
        if(storing_data) {
            sample_data_fout << q << "," << light_code << endl;
            sample_times_fout << q << "," << lux << endl;
            int diff = light_code - last_light_code;
            code_diff_map[diff]++;

            last_light_code = light_code;
        }

        if(sum == 0xFFFF) {
            // if uninitialized, initialize running avg
            for(int i = 0; i < 8; i++) {
                running_avg[i] = light_code;
                running_avg_time[i] = day_time;
            }
            sum = light_code << 3;
        }
        else {
            sum -= running_avg[rot_idx];
            sum += light_code;

            running_avg_time[rot_idx] = day_time;
            running_avg[rot_idx] = light_code;

            rot_idx = (rot_idx + 1) & 7;
        }

        if(is_morning && next_sunrise == 0 && (sum >> 3) >= EDGE_THRESHOLD 
                && day_count > 1) {
            int target = running_avg_time[(rot_idx + 3) & 7];
            if(target > cur_sunrise + MAX_EDGE_SHIFT) {
                next_sunrise = cur_sunrise + MAX_EDGE_SHIFT;
            }
            else if(target < cur_sunrise - MAX_EDGE_SHIFT) {
                next_sunrise = cur_sunrise - MAX_EDGE_SHIFT;
            }
            else {
                next_sunrise = target;
            }

            // compare center time diff
            if(cur_sunrise != 0) {
                sunrise_time_diff_fout << target - cur_sunrise << ",";
            }

        }
        else if(!is_morning && next_sunset == 0 && (sum >> 3) <= EDGE_THRESHOLD 
                && day_count > 1) {
            int target = running_avg_time[(rot_idx  + 3) & 7];
            if(target > cur_sunset + MAX_EDGE_SHIFT) {
                next_sunset = cur_sunset + MAX_EDGE_SHIFT;
            }
            else if(target < cur_sunset - MAX_EDGE_SHIFT) {
                next_sunset = cur_sunset - MAX_EDGE_SHIFT;
            }
            else {
                next_sunset = target;
            }

            // compare center time diff
            if(cur_sunset != 0) {
                sunset_time_diff_fout << target - cur_sunset << ",";
            }
        }

        // determine next wakeup time
        // if at the end of this half-day, switch to the next half-day
        if(is_morning && ((day_time >= NOON - 1920) || cur_index >= dawn_indices[7])) {
            is_morning = 0;
            storing_data = true;
            cur_index = 0;
            cur_sunset = next_sunset == 0? cur_sunset : next_sunset;
            next_sunset = 0;
            last_light_code = 0;
        }
        else if(!is_morning && ((day_time >= MAX_DAY_TIME - 1920) || cur_index >= dawn_indices[7])) {
            is_morning = 1;
            storing_data = false;
            cur_index = 0;
            cur_sunrise = next_sunrise == 0? cur_sunrise : next_sunrise;
            next_sunrise = 0;
            last_light_code = 0;
            day_count++;
        }
        else {
            next_sys_time = sys_time + (INTERVALS[interval_index] * 60);

            cur_index++;
            if(cur_index >= dawn_indices[interval_index]) {
                interval_index++;
            }

            if(is_morning) {
                if((sum >> 3) > 128) {  // 0 lux
                    storing_data = true;
                }
            }
            else {
                if((sum >> 3) <= 128) { // 0 lux
                    storing_data = false;
                }
            }
        }
    }

    sunrise_time_diff_fout << endl;
    sunset_time_diff_fout << endl;

    ofstream code_diff_fout(ppath + "code_diff.txt");
    for(auto p : code_diff_map) {
        code_diff_fout << p.first << " " << p.second << endl;
    }

}

void Sim::store_data_in_word(int len, uint32_t code) {
    uint32_t mask = 1 << (len - 1);
    for(int i = 0; i < len; i++) {
        uint8_t bit = (mask & code) == 0? 0 : 1;
        data.back() = data.back() | (bit << (word_remainder - len + i));
        word_remainder--;
        if(word_remainder == 0) {
            data.push_back(0);
            word_remainder = 32;
        }
    }
    unit_remainder -= len;
}

void Sim::store_data(int len, uint32_t code) {
    if(unit_remainder < len) {
        data.push_back(0);
        word_remainder = 32;
        unit_remainder = RADIO_UNIT_LEN;
        // store header
        store_data_in_word(7, day_count);
        store_data_in_word(17, cur_sunrise);
        store_data_in_word(7, day_count);
        store_data_in_word(7, day_count);
    }
    else {
        store_data_in_word(len, code);
    }
    return;
}

string Sim::parse_day_time(uint32_t ts) {
    string res = "";
    if(ts > MAX_DAY_TIME) {
        throw "day time is greater than max day time\n";
    }
    res += to_string(ts / 3600) + ":";
    ts = ts % 3600;
    res += to_string(ts / 60) + ":";
    ts = ts % 60;
    res += to_string(ts);
    return res;
}

map<time_t, double> Sim::read_file(const string& filename) {
    ifstream fin(filename);
    if(!fin.is_open()) {
        cout << "Error opening file: " << filename << endl;
        assert(0);
    }

    // read SN
    string line;
    getline(fin, line);
    regex e_sn("\"Plot Title: ([0-9]{8})");
    smatch m_sn;
    regex_search(line, m_sn, e_sn);
    SN = stoi(m_sn.str(1));
    // cout << "SN = " << SN << endl;

    // read time zone
    getline(fin, line);
    regex e("GMT([+-])([0-9]{2}):([0-9]{2})");
    smatch m;
    regex_search(line, m, e);

    tz_sign = m.str(1);
    tz_hr = stoi(m.str(2));
    tz_min = stoi(m.str(3));

    map<time_t, double> res;

    int count = 0;
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

        // get start time first
        if(count == 0) {
            count++;
            start_day_time = res_tm.tm_hour * 3600 + res_tm.tm_min * 60 + res_tm.tm_sec;
            start_hour_plus_one = res_tm.tm_hour + 1;
            start_tm = res_tm;
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

    // cout << "data file range: " << res.begin()->first << " - " << res.rbegin()->first << endl;

    return res;

};

uint64_t Sim::get_data(const std::map<std::time_t, double>& data_map, time_t q) {
    uint64_t res = (uint64_t) (get_raw_data(data_map, q) * 1577.536);
    if(res == 0) {
        return 15;
    }
    return res;
}

double Sim::get_raw_data(const std::map<std::time_t, double>& data_map, time_t q) {
    // cout << data_map.begin()->first << " " << q << " " << data_map.rbegin()->first << endl;
    auto p = data_map.equal_range(q);
    double lux = 0;

    // if has that key, then just return
    if(p.first->first == q) {
        lux = p.first->second;
    }
    else {
        if(q > data_map.rbegin()->first) {
            cout << "Query " << q << " too big\n";
            throw 1;
        }
        else if(q < data_map.begin()->first) {
            cout << "Query " << q << " too small\n";
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

uint32_t Sim::day_time_2_sec(std::string str) {
    regex e("([0-9]+):([0-9]+):([0-9]+) ([A|P]M)");
    smatch m;
    regex_search(str, m, e);

    int hr = stoi(m.str(1)), min = stoi(m.str(2)), sec = stoi(m.str(3));
    if(m.str(4) == "AM" && hr == 12) {
        hr = 0;
    }
    else if(m.str(4) == "PM" && hr != 12) {
        hr += 12;
    }

    // fix timezone
    if(tz_sign == "+") {
        hr += tz_hr;
        min += tz_min;
    }
    else {
        hr -= tz_hr;
        min -= tz_min;
    }

    if(hr >= 24) {
        hr -= 24;
    }
    else if(hr < 0) {
        hr += 24;
    }

    if(min >= 60) {
        min -= 60;
    }
    else if(min < 0) {
         min += 60;
    }

    // cout << hr << ":" << min << endl;
    return hr * 3600 + min * 60 + sec;
}

void Sim::start_compression_sim(uint32_t day_time_in, uint32_t sys_time_in, 
                                uint32_t start_hour, uint32_t duration_in_hour,
                                uint32_t cur_sunrise_in, uint32_t cur_sunset_in,
                                uint32_t epoch_time,
                                const string& sample_times_file) {

    day_time = day_time_in;
    sys_time = sys_time_in;
    cur_sunrise = cur_sunrise_in;
    cur_sunset = cur_sunset_in;
    sys_to_epoch_offset = epoch_time - sys_time;

    string ppath = getenv("PROJECT_DIR");
    ppath += "/data/src/compression_sim/";

    // read huffman tree
    ifstream huffman_fin(ppath + "huffman_tree.txt");
    int diff, len;
    string code;
    map<int, pair<int, string>> code_map;
    while(huffman_fin >> diff >> len >> code) {
        code_map[diff] = {len, code};
    }

    uint32_t start_hour_in_sec = start_hour * 3600;
    next_sys_time = sys_time + start_hour_in_sec - day_time_in;

    uint32_t end_time = sys_time + duration_in_hour * 3600;

    cur_index = 0;

    // set is_morning
    if(day_time <= (43200 - 1800) || day_time > (86400 - 1800)) {
        // set 30 minute margin from noon and midnight
        is_morning = 1;
    }
    else {
        is_morning = 0;
    }

    uint16_t last_light_code = 0;

    while(1) {
        // find out starting index
        if(cur_index == 0) {
            // start with the very last time
            // work forward until target day time is in the half-day 
            // and the smallest possible index
            // that is greater than current day time
            interval_index = 0;
            cur_index = 0;

            uint8_t new_start = 0;

            // determine is need to compare with current day time
            // assume is_morning is reset some time before NOON or MAX_DAY_TIME
            if(is_morning && day_time > NOON) {
                new_start = 1;
            }
            else if(!is_morning && day_time <= NOON) {
                new_start = 1;
            }

            uint32_t margin1, margin2, edge;

            if(is_morning) {
                margin1 = 0 + 480;
                margin2 = NOON - 480;
                edge = cur_sunrise;
            }
            else {
                margin1 = NOON + 480;
                margin2 = MAX_DAY_TIME - 480;
                edge = cur_sunset;
            }

            uint32_t next_day_time = edge - EDGE_MARGIN;    // TODO: fix

            // cout << "edge = " << parse_day_time(edge) 
            //      << "; margin1 = " << parse_day_time(margin1)
            //      << "; margin2 = " << parse_day_time(margin2)
            //      << "; new_start = " << new_start << endl;

            while(1) {
                // FIXME: this is wrong but I'm going to bed
                // if new start, then don't need to check margin1
                if(next_day_time >= margin1 && next_day_time < margin2
                        &&(next_day_time > day_time || new_start)) {
                    break; 
                }

                next_day_time += (INTERVALS[interval_index] * 60);
                cur_index++;

                if(cur_index >= dawn_indices[interval_index]) {
                    interval_index++;
                }
            }

            if(next_day_time > day_time) {
                next_sys_time = sys_time + next_day_time - day_time;
            }
            else {
                next_sys_time = sys_time + next_day_time + MAX_DAY_TIME - day_time;
            }
        }

        // cout << "next_sys_time = " << next_sys_time << endl;
        if(next_sys_time > end_time) {
            break;
        }

        // increment sys_time and day_time to represent waking up
        day_time += (next_sys_time - sys_time);
        if(day_time >= MAX_DAY_TIME) {
            day_time -= MAX_DAY_TIME;
        }
        sys_time = next_sys_time;
        next_sys_time = 0;

        // take measurement and take log
        time_t q = sys_time + sys_to_epoch_offset;
        double lux = get_raw_data(measurement_map, q);

        uint64_t raw_light_code = get_data(measurement_map, q);
        uint16_t light_code = func_log2(raw_light_code + 1);

        // storing_data = true;
        if(storing_data) {
            int diff = light_code - last_light_code;
            int len = 0, code = 0;
            if(diff < 32 && diff >= -32) {
                bit_count += code_map[diff].first;
                len = code_map[diff].first;
                code = stoi(code_map[diff].second, 0, 2);
                store_data(len, code);
            }
            else if(diff < 256 && diff >= -256) {
                bit_count += code_map[0x1FF].first + 9;
                len = code_map[0x1FF].first;
                code = stoi(code_map[0x1FF].second, 0, 2);
                store_data(len, code);
                store_data(9, code);
            }
            else {
                bit_count += code_map[0x7FF].first + 11;
                len = code_map[0x7FF].first;
                code = stoi(code_map[0x7FF].second, 0, 2);
                store_data(len, code);
                store_data(11, code);
            }
            last_light_code = light_code;
            data_count++;
        }

        if(sum == 0xFFFF) {
            // if uninitialized, initialize running avg
            for(int i = 0; i < 8; i++) {
                running_avg[i] = light_code;
                running_avg_time[i] = day_time;
            }
            sum = light_code << 3;
        }
        else {
            sum -= running_avg[rot_idx];
            sum += light_code;

            running_avg_time[rot_idx] = day_time;
            running_avg[rot_idx] = light_code;

            rot_idx = (rot_idx + 1) & 7;
        }

        if(is_morning && next_sunrise == 0 && (sum >> 3) >= EDGE_THRESHOLD 
                && day_count > 1) {
            int target = running_avg_time[(rot_idx + 3) & 7];
            if(target > cur_sunrise + MAX_EDGE_SHIFT) {
                next_sunrise = cur_sunrise + MAX_EDGE_SHIFT;
            }
            else if(target < cur_sunrise - MAX_EDGE_SHIFT) {
                next_sunrise = cur_sunrise - MAX_EDGE_SHIFT;
            }
            else {
                next_sunrise = target;
            }
        }
        else if(!is_morning && next_sunset == 0 && (sum >> 3) <= EDGE_THRESHOLD 
                && day_count > 1) {
            int target = running_avg_time[(rot_idx  + 3) & 7];
            if(target > cur_sunset + MAX_EDGE_SHIFT) {
                next_sunset = cur_sunset + MAX_EDGE_SHIFT;
            }
            else if(target < cur_sunset - MAX_EDGE_SHIFT) {
                next_sunset = cur_sunset - MAX_EDGE_SHIFT;
            }
            else {
                next_sunset = target;
            }

        }

        // determine next wakeup time
        // if at the end of this half-day, switch to the next half-day
        if(is_morning && ((day_time >= NOON - 1920) || cur_index >= dawn_indices[7])) {
            is_morning = 0;
            storing_data = true;
            cur_index = 0;
            cur_sunset = next_sunset == 0? cur_sunset : next_sunset;
            next_sunset = 0;
            last_light_code = 0;
            // bit_count += (7 + 17 + 7 + 7); // day_count + sunrise/sunset_time + start_idx + end_idx
        }
        else if(!is_morning && ((day_time >= MAX_DAY_TIME - 1920) || cur_index >= dawn_indices[7])) {
            is_morning = 1;
            storing_data = false;
            cur_index = 0;
            cur_sunrise = next_sunrise == 0? cur_sunrise : next_sunrise;
            next_sunrise = 0;
            last_light_code = 0;
            day_count++;
            // bit_count += (7 + 17 + 7 + 7); // day_count + sunrise/sunset_time + start_idx + end_idx
        }
        else {
            next_sys_time = sys_time + (INTERVALS[interval_index] * 60);

            cur_index++;
            if(cur_index >= dawn_indices[interval_index]) {
                interval_index++;
            }

            if(is_morning) {
                if((sum >> 3) > 128) {  // 0 lux
                    storing_data = true;
                }
            }
            else {
                if((sum >> 3) <= 128) { // 0 lux
                    storing_data = false;
                }
            }
        }

        // cout << "sys_time = " << sys_time << "; day_time = " << parse_day_time(day_time) << endl
        //      << "sys_to_epoch_offset = " << sys_to_epoch_offset
        //      << "; cur_sunrise = " << parse_day_time(cur_sunrise) 
        //      << "; cur_sunset = " << parse_day_time(cur_sunset) << endl
        //      << "next_sunrise = " << parse_day_time(next_sunrise) 
        //      << "; next_sunset = " << parse_day_time(next_sunset) << endl
        //      << "; next_sys_time = " << next_sys_time << endl
        //      << "is_morning = " << (int) is_morning << "; cur_index = " << (int) cur_index
        //      << "; interval_index = " << (int) interval_index 
        //      << "; rot_idx = " << rot_idx << endl;

        // cout << "raw light code = " << raw_light_code << endl;

        // for(int i = 0; i < 8; i++) {
        //     cout << running_avg[i] << " ";
        // }
        // cout << endl << "sum = " << (sum >> 3) << endl;

        /*
        cout << "\n\nPause. Press to continue" << endl;
        string str;
        cin >> str;
        */
    }

    cout << "Simulated data collected " << data_count << " data points and used " << bit_count << " bits in " << day_count << " days." << endl;
    cout << "Average num of bits per data point = " << bit_count / (double) data_count << endl;

    cout << "data size = " << data.size() << endl;
}


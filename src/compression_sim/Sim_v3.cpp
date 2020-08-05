#include  "Sim_v3.hpp"

#include "log2.hpp"
#include "../json11.hpp"

#include <iostream>
#include <fstream>
#include <cassert>
#include <regex>
#include <sstream>
#include <iomanip>
#include <cmath>
#include <bitset>
#include <cstdlib>

using namespace json11;
using namespace std;

uint64_t right_shift(uint64_t input, int8_t shift) {
    int8_t i;
    if(shift >= 0) {
    	for(i = 0; i < shift; i++) {
	    input = input >> 1;
	}
    }
    else {
    	for(i = 0; i > shift; i--) {
	    input = input << 1;
	}
    }
    return input;
}

// right shift an array
// + is right shift, - is left shift
// if shift_len is greater than or equal to 32, data must be 0
// if right_shift, data must be 0
// if left shift, then shift data into the array
void right_shift_arr(uint32_t* arr, uint32_t data, uint8_t arr_len, int16_t shift_len) {
    if(shift_len == 0) {
        return;
    }
    else if(shift_len >= 32) {
        data = 0;
    }

    int8_t sign = shift_len > 0? 1 : -1;

    // get abs(shift_len)
    if(sign == -1) {
        shift_len = -shift_len;
    }

    // filter data
    data &= (right_shift(1, -shift_len) - 1);

    uint8_t start, back;

    if(sign == 1) {
        start = arr_len - 1;
        back = 0;
    }
    else {
        start = 0;
        back = arr_len - 1;
    }

    uint8_t i;

    // shift word be word
    while(shift_len >= 32) {
        for(i = start; i != back; i -= sign) {
            arr[i] = arr[i - sign];
        }
        arr[back] = 0;
        shift_len -= 32;
    }

    int8_t shift_len_complement = shift_len - 32;

    if(sign == -1) {
        shift_len = -shift_len;
        shift_len_complement = -shift_len_complement;
    }

    for(i = start; i != back; i -= sign) {
        arr[i] = right_shift(arr[i], shift_len);
        arr[i] |= right_shift(arr[i - sign], shift_len_complement);
    }

    arr[back] = right_shift(arr[back], shift_len);
    if(sign == -1) {
        arr[back] |= data;
    }
}


Sim::Sim(const string& filename_in, bool train_in) : train(train_in) {
    read_file(filename_in);

    regex e("(.+)\/(.+)\.csv");
    smatch m;
    regex_search(filename_in, m, e);

    string ppath = getenv("PROJECT_DIR");
    ppath += "/data/src/compression_sim/";
    string light_filename = ppath + "sample_data/" + m.str(2) + "_light_sample_times.csv";
    light_sample_times_fout = ofstream(light_filename);
    cout << filename_in << endl;
    cout << light_filename << endl;
    if(!light_sample_times_fout.is_open()) {
        cout << "Error opening file: " << light_filename << endl;
        exit(1);
    }

    string temp_filename = ppath + "sample_data/" + m.str(2) + "_temp_sample_times.csv";
    temp_sample_times_fout = ofstream(temp_filename);

    if(!temp_sample_times_fout.is_open()) {
        cout << "Error opening file: " << temp_filename << endl;
        exit(1);
    }

    if(train) {

        // read in previously collected historgram values
    
        ifstream light_hist_fin(ppath + "light_histogram.txt");

        int code, count;
        while(light_hist_fin >> code >> count) {
            light_hist[code] = count;
        }

        light_hist_fin.close();

        ifstream temp_hist_fin(ppath + "temp_historgram.txt");
        while(temp_hist_fin >> code >> count) {
            temp_hist[code] = count;
        }

    }
    else {
        // read light code
        ifstream code_fin(ppath + "light_huffman_tree_v3.txt");
        int code;
        uint16_t len;
        uint16_t num;
        string str;
        while(code_fin >> code >> len >> num >> str) {
            // cout << code << " " << len << " " << num << " " << str << endl;
            if(code == 0x1FF) {
                light_diff_codes[64] = num;
                light_code_lengths[64] = len;
            }
            else if(code == 0x7FF) {
                light_diff_codes[65] = num;
                light_code_lengths[65] = len;
            }
            else if(code == 0x400) {
                light_diff_codes[66] = num;
                light_code_lengths[66] = len;
            }
            else {
                light_diff_codes[code + 32] = num;
                light_code_lengths[code + 32] = len;
            }
        }
        
        // read code
        code_fin = ifstream(ppath + "temp_huffman_tree_v3.txt");
        while(code_fin >> code >> len >> num >> str) {
            // cout << code << " " << len << " " << num << " " << str << endl;
            if(code == 0x7F) {
                temp_diff_codes[4] = num;
                temp_code_lengths[4] = len;
            }
            else {
                temp_diff_codes[code + 2] = num;
                temp_code_lengths[code + 2] = len;
            }
        }

    }
}

Sim::~Sim() {
    string ppath = getenv("PROJECT_DIR");
    ppath += "/data/src/compression_sim/";
    ofstream light_hist_fout(ppath + "light_histogram.txt");

    if(!light_hist_fout.is_open()) {
        cout << "Error opening light hist file" << endl;
        assert(0);
    }

    for(auto p : light_hist) {
        light_hist_fout << p.first << " " << p.second << endl;
    }

    if(!light_sample_times_fout.is_open()) {
        cout << "Error opening file" << endl;
        assert(0);
    }

    for(auto p : light_sample_times_map) {
        light_sample_times_fout << p.first << " " << p.second << endl;
    }

    ofstream temp_hist_fout(ppath + "temp_histogram.txt");

    if(!temp_hist_fout.is_open()) {
        cout << "Error opening temp hist file" << endl;
        assert(0);
    }

    for(auto p : temp_hist) {
        temp_hist_fout << p.first << " " << p.second << endl;
    }

    for(auto p : temp_sample_times_map) {
        temp_sample_times_fout << p.first << " " << p.second << endl;
    }
}

void Sim::read_file(const string& filename) {
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

    // get raw sample times
    regex f("(.+)\/(.+)\.csv");
    smatch m0;
    regex_search(filename, m0, f);

    string ppath = getenv("PROJECT_DIR");
    ppath += "/data/src/compression_sim/";
    string light_hobo_filename = ppath + "sample_data/" + m0.str(2) + "_light_HOBO.csv";

    ofstream light_hobo_fout(light_hobo_filename);
    if(!light_hobo_fout.is_open()) {
        cout << "Error opening file: " << light_hobo_filename << endl;
        assert(0);
    }

    for(auto p : light_measurement_map) {
        light_hobo_fout << p.first << "," << p.second << endl;
    }

    string temp_hobo_filename = ppath + "sample_data/" + m0.str(2) + "_temp_HOBO.csv";

    ofstream temp_hobo_fout(temp_hobo_filename);
    if(!temp_hobo_fout.is_open()) {
        cout << "Error opening file: " << temp_hobo_filename << endl;
        assert(0);
    }

    for(auto p : temp_measurement_map) {
        temp_hobo_fout << p.first << "," << p.second << endl;
    }

    raw_filename = m0.str(2);
};

uint64_t Sim::get_light_data(time_t q) {
    uint64_t res = (uint64_t) (get_raw_light_data(q) * 1577.536);
    if(res == 0) {
        return 15;
    }
    return res;
}

uint32_t Sim::get_temp_data(time_t q) {
    double data = get_raw_temp_data(q);
    uint32_t res = (uint32_t) exp(12.08 - 606 / (data + 103.3));
    cout << "temp meas: " << q << " " << data << " " << res << endl;
    return res;
}

double Sim::get_raw_light_data(time_t q) {
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
        cout << q << " " << p.first->second << " " << p.second->second << endl;
    }

    return res;

}

double Sim::get_raw_temp_data(time_t q) {
    auto p = temp_measurement_map.equal_range(q);
    double res = 0;

    // if has that key, then just return
    if(p.first->first == q) {
        res = p.first->second;
        cout << "temp first option: " << q << " " << res << endl;
    }
    else {
        if(q > temp_measurement_map.rbegin()->first) {
            cout << "Query " << q << " too big\n";
            throw 1;
        }
        else if(q < temp_measurement_map.begin()->first) {
            cout << "Query " << q << " too small\n";
            throw 2;
        }

        auto end = p.first;
        auto start = --p.first;


        // interpolate results
        time_t d1 = q - start->first, d2 = end->first - q;

        res = (p.first->second * d2) / (d1 + d2) + (p.second->second * d1) / (d1 + d2);
        cout << "temp: " << q << " " << p.first->second << " " << p.second->second << endl;
    }

    return res;

}

void Sim::start_sim(uint32_t day_time_in, uint32_t sys_time_in, 
                    uint32_t start_hour, uint32_t duration_in_hour,
                    uint32_t cur_sunrise_in, uint32_t cur_sunset_in,
                    uint32_t epoch_time,
                    const string& sample_times_file) {

    if(lat == 0xFFFF) {
        cerr << "Latitude and longitude information not set. Aborting..." << endl;
        assert(0);
    }

    xo_day_time_in_sec = day_time_in;
    xo_sys_time_in_sec = sys_time_in;
    cur_sunrise = cur_sunrise_in;
    cur_sunset = cur_sunset_in;
    sys_to_epoch_offset = epoch_time - xo_sys_time_in_sec;

    uint32_t end_time = (start_hour * 3600 - day_time_in + duration_in_hour * 3600) + xo_sys_time_in_sec; 
    
    // set initial day_state
    if(xo_day_time_in_sec < cur_sunrise - EDGE_MARGIN2 - XO_32_MIN) {
        day_state = NIGHT;
    }
    else if(xo_day_time_in_sec < cur_sunset - EDGE_MARGIN1 - XO_32_MIN) {
        day_state = NOON;
    }
    else {
        day_state = NIGHT;
    }

    set_new_state();

    // figure out store temp start time
    store_temp_index = UINT8_MAX;
    uint32_t store_temp_day_time = 0;
    while(store_temp_day_time < day_state_start_time) {
        store_temp_day_time += XO_30_MIN;
        store_temp_index++;

        if(store_temp_index > 47) {
            cerr << "Store temp index error." << endl;
            assert(0);
        }
    }

    store_temp_timestamp = store_temp_day_time + xo_sys_time_in_sec - xo_day_time_in_sec;

    set_projected_end_time();

    while(1) {          
        xo_day_time_in_sec += projected_end_time_in_sec - xo_sys_time_in_sec;

        cout << xo_day_time_in_sec << " " << projected_end_time_in_sec << endl;

        if(xo_day_time_in_sec >= MAX_DAY_TIME) {
            xo_day_time_in_sec -= MAX_DAY_TIME;
            day_count++;
        }
        xo_sys_time_in_sec = projected_end_time_in_sec;

        if(xo_sys_time_in_sec >= end_time) {
            break;
        }

        if(projected_end_time_in_sec >= store_temp_timestamp) {
            store_temp_timestamp += XO_30_MIN;
            sample_temp();
        }

        if(projected_end_time_in_sec == next_light_meas_time) {
            sample_light();
        }
        set_projected_end_time();
    }                   
}

void Sim::set_new_state() {

    // reset new state variables
    cache_addr = CACHE_START_ADDR;
    proc_cache_remainder = PROC_CACHE_MAX_REMAINDER;
    max_idx = 0;
    threshold_idx = IDX_INIT;
    min_light_idx = IDX_INIT;
    sum = 0xFFFF;

    // set day_state specific variables
    if(day_state == DAWN) {
        cur_sunrise = next_sunrise == 0? cur_sunrise : next_sunrise;
        cur_edge = cur_sunrise;
        day_state_start_time = cur_sunrise - EDGE_MARGIN2;
        day_state_end_time = cur_sunrise + EDGE_MARGIN1;
    }
    else if(day_state == DUSK) {
        cur_sunset = next_sunset == 0? cur_sunset : next_sunset;
        cur_edge = cur_sunset;
        day_state_start_time = cur_sunset - EDGE_MARGIN1;
        day_state_end_time = cur_sunset + EDGE_MARGIN2;
    }
    else if(day_state == NOON) {
        cur_edge = xo_day_time_in_sec + XO_32_MIN;
        day_state_start_time = cur_edge;
        day_state_end_time = cur_sunset - EDGE_MARGIN1 - XO_10_MIN;
    }
    else {
        cur_edge = xo_day_time_in_sec + XO_32_MIN;
        day_state_start_time = cur_edge;
        day_state_end_time = cur_sunrise - EDGE_MARGIN2 - XO_10_MIN;
    }

    // set new light measure time
    next_light_meas_time = day_state_start_time + xo_sys_time_in_sec - xo_day_time_in_sec;

}

void Sim::set_projected_end_time() {
    uint32_t temp = next_light_meas_time - projected_end_time_in_sec;
    if(temp <= XO_8_MIN) {
        projected_end_time_in_sec = next_light_meas_time;

        // if(temp <= XO_1_MIN) {
        //     lnt_counter_base = 0;
        // }
        // else if(temp <= XO_2_MIN) {
        //     lnt_counter_base = 1;
        // }
        // else {
        //     lnt_counter_base = 3;
        // }
    }
    else if(temp <= XO_10_MIN) {
        // set 8 minute buffer time to make sure wake up time is power of 2
        projected_end_time_in_sec = next_light_meas_time - XO_8_MIN;
    }
    else {
        // 32 minute interval case
        projected_end_time_in_sec += XO_8_MIN;
    }
}

void Sim::write_to_mem(uint32_t* arr, uint16_t addr, uint8_t len_minus_one) {
    uint16_t i;
    for(i = 0; i < len_minus_one + 1; i++) {
        mem[(addr >> 2) + i] = arr[i];
    }
}

void Sim::read_from_mem(uint32_t* arr, uint16_t addr, uint8_t len_minus_one) {
    uint16_t i;
    for(i = 0; i < len_minus_one + 1; i++) {
        arr[i] = mem[(addr >> 2) + i];
    }
}

void Sim::write_to_proc_cache(uint16_t data) {
    const uint8_t len = 11;
    data &= (right_shift(1, -len) - 1);

    if(len >= proc_cache_remainder) {
        // if no more cache space, store and switch to new cache
        write_to_mem(proc_cache, cache_addr, PROC_CACHE_LEN - 1);

        cache_addr += (PROC_CACHE_LEN << 2);
        proc_cache_remainder = PROC_CACHE_MAX_REMAINDER;
    }

    right_shift_arr(proc_cache, data, PROC_CACHE_LEN, -len);
    proc_cache_remainder -= len;
}

uint16_t Sim::read_next_from_proc_cache() {
    uint16_t res = 0;

    if(day_state == DUSK) {
        // start reading from bottom
        if(proc_cache_remainder < 11) {
            // decrement address before reading because we start on an incorrect address
            cache_addr -= PROC_CACHE_LEN << 2;
            read_from_mem(proc_cache, cache_addr, PROC_CACHE_LEN);
            // cout << "Reading mem from " << cache_addr << endl;
            proc_cache_remainder = PROC_CACHE_MAX_REMAINDER;
        }
        res = proc_cache[PROC_CACHE_LEN - 1] & 0x7FF;
        proc_cache_remainder -= 11;
        right_shift_arr(proc_cache, 0, PROC_CACHE_LEN, 11);
    }
    else {
        if(proc_cache_remainder < 11) {
            read_from_mem(proc_cache, cache_addr, PROC_CACHE_LEN);
            // cout << "Reading mem from " << cache_addr << endl;
            // increment address after we read from memory because we start on a correct addr
            cache_addr += PROC_CACHE_LEN << 2;
            proc_cache_remainder = PROC_CACHE_MAX_REMAINDER;
        }

        res = right_shift(proc_cache[0], 20) & 0x7FF;
        proc_cache_remainder -= 11;

        right_shift_arr(proc_cache, 0, PROC_CACHE_LEN, -11);
    }

    return res;
}

void Sim::sample_light() {
    // get light data
    uint64_t lnt_sys_light = get_light_data(xo_sys_time_in_sec + sys_to_epoch_offset);

    // store to cache
    uint16_t log_light = func_log2(lnt_sys_light);
    uint16_t last_avg_light = avg_light;
    write_to_proc_cache(log_light);

    // store to running sum
    if(sum == 0xFFFF) {
        // if uninitialized, initialize running avg
        for(int i = 0; i < 8; i++) {
            running_avg[i] = log_light;
            running_avg_time[i] = xo_day_time_in_sec;
        }
        sum = log_light << 3;
    }
    else {
        sum -= running_avg[rot_idx];
        sum += log_light;

        running_avg[rot_idx] = log_light;
        running_avg_time[rot_idx] = xo_day_time_in_sec;
        rot_idx = (rot_idx + 1) & 7;
    }

    avg_light = sum >> 3;

    uint32_t target = 0;

    // record min_light in day_state
    if(min_light_idx == IDX_INIT || avg_light < min_light
            || (day_state == DAWN && avg_light == min_light)) { // find last min_light at dawn
        min_light = avg_light;
        min_light_idx = max_idx;
        min_light_time = next_light_meas_time;
    }

    // test if crosses threshold
    if(day_state == DAWN && threshold_idx == IDX_INIT
            && avg_light >= EDGE_THRESHOLD && last_avg_light < EDGE_THRESHOLD) {
        if(max_idx >= THRESHOLD_IDX_SHIFT) {
            threshold_idx = max_idx - THRESHOLD_IDX_SHIFT;
            threshold_idx_time = next_light_meas_time - THRESHOLD_IDX_SHIFT * 60;
        }
        else {
            threshold_idx = 0;
            threshold_idx_time = next_light_meas_time - max_idx * 60;
        }

        target = running_avg_time[(rot_idx + 3) & 7];
    }
    else if(day_state == DUSK && threshold_idx == IDX_INIT
            && avg_light <= EDGE_THRESHOLD && last_avg_light > EDGE_THRESHOLD) {
        if(max_idx + THRESHOLD_IDX_SHIFT <= IDX_MAX) {
            threshold_idx = max_idx + THRESHOLD_IDX_SHIFT;
            threshold_idx_time = next_light_meas_time + THRESHOLD_IDX_SHIFT * 60;
        }
        else {
            threshold_idx = IDX_MAX;
            threshold_idx_time = next_light_meas_time + (IDX_MAX - max_idx) * 60;
        }

        target = running_avg_time[(rot_idx + 3) & 7];
    }

    // set new edge time
    if(target) {
        if(target > cur_edge + MAX_EDGE_SHIFT) {
            target = cur_edge + MAX_EDGE_SHIFT;
        }
        else if(target < cur_edge - MAX_EDGE_SHIFT) {
            target = cur_edge - MAX_EDGE_SHIFT;
        }

        // check edge invariants before setting new edge
        if(day_state == DAWN && target > 0 && target < MID_DAY_TIME 
                && (cur_sunset - target > XO_270_MIN)) {
            next_sunrise = target;
        }
        else if(day_state == DUSK && target > MID_DAY_TIME && target < MAX_DAY_TIME 
                && (target - cur_sunrise > XO_270_MIN)) {
            next_sunset = target;
        }
    }

    // set next light measure time
    if(day_state == DAWN || day_state == DUSK) {
        next_light_meas_time += XO_1_MIN;
    }
    else {
        next_light_meas_time += XO_32_MIN;
    }

    bool new_state = false;
    uint32_t temp = xo_day_time_in_sec + next_light_meas_time - xo_sys_time_in_sec;
    if(day_state != NIGHT) {
        new_state = temp >= day_state_end_time;
    }
    else {
        new_state = temp >= day_state_end_time && temp < MID_DAY_TIME;
    }

    if(new_state) {
        if(day_state != NIGHT) {
            // resample and store
            uint16_t starting_idx = 0;
            int16_t start, end, sign;
            uint32_t sample_time;

            if(day_state == DUSK) {
                // from last to first
                // manual set remainder to current data in proc_cache to start reading
                proc_cache_remainder = PROC_CACHE_MAX_REMAINDER - proc_cache_remainder;
                // if crossed threshold
                if(threshold_idx != IDX_INIT) {
                    starting_idx = threshold_idx;
                    sample_time = threshold_idx_time;
                }
                else {
                    starting_idx = min_light_idx;
                    sample_time = min_light_time;
                }
                // last to first
                start = max_idx;
                end = -1;
                sign = -1;
            }
            else {
                // going from first to last, left shift 0s into proc_cache
                right_shift_arr(proc_cache, 0, PROC_CACHE_LEN, 1 - proc_cache_remainder);
                write_to_mem(proc_cache, cache_addr, PROC_CACHE_LEN - 1);

                proc_cache_remainder = 0; // manually set to 0 to start reading
                cache_addr = CACHE_START_ADDR;

                if(day_state == NOON) {
                    starting_idx = 0;
                    sample_time = cur_edge + xo_sys_time_in_sec - xo_day_time_in_sec;
                }
                else if(threshold_idx != IDX_INIT) {
                    starting_idx = threshold_idx;
                    sample_time = threshold_idx_time;
                }
                else {
                    starting_idx = min_light_idx;
                    sample_time = min_light_time;
                }
                // first to last
                start = 0;
                end = max_idx + 1;
                sign = 1;
            }

            int16_t i;
            uint16_t last_log_light = 0;
            uint8_t next_sample_idx = starting_idx;
            uint8_t sample_idx = 0;
            uint8_t interval_idx = 0;
            for(i = start; i != end; i += sign) {
                uint16_t log_light = read_next_from_proc_cache();
                cout << log_light << " ";
                if(i == next_sample_idx) {
                    cout << "sampled ";

                    light_sample_times_map[sample_time + sys_to_epoch_offset] = (pow(2, log_light / 32.0) - 1) / 1577.0;

                    // store diff
                    uint16_t diff = log_light - last_log_light;
                    store_diff_to_code_cache(diff, sample_idx, sample_time);

                    sample_idx++;
                    last_log_light = log_light;
                    if(day_state == NOON) {
                        next_sample_idx++;
                        sample_time += XO_32_MIN;
                    }
                    else {
                        if(sample_idx >= resample_indices[interval_idx]) {
                            interval_idx++;
                        }

                        next_sample_idx += (intervals[interval_idx] * sign);
                        sample_time += (intervals[interval_idx] * sign * 60);
                    }
                }
            }
        }
    
        // reset new state variables
        day_state = (day_state + 1) & 0b11;
        set_new_state();
    }
    else {
        max_idx++;
    }

    cout << "day_state = " << (int) day_state << endl
         << "xo_day_time_in_sec = " << xo_day_time_in_sec << endl
         << "day_state_end_time = " << day_state_end_time << endl
         << "projected_end_time_in_sec = " << projected_end_time_in_sec << endl
         << "cur_edge = " << cur_edge << endl;

    cout << endl;
}

void Sim::store_diff_to_code_cache(int16_t diff, uint8_t start_idx, uint32_t edge_time) {
    if(train) {
        uint8_t len_needed = 6;
        if(!has_header) {
            len_needed += UNIT_HEADER_SIZE;
            if(code_cache_remainder < len_needed) {
                flush_code_cache();
            }

            store_code(edge_time & 0x1FFFF, 17);
            store_code(day_state, 2);
            store_code(start_idx, 7);
        }

        store_code(0b100000, 6);

        if(diff < 32 && diff >= -32) {
            light_hist[diff]++;
        }
        else if(diff < 256 && diff >= -256) {
            light_hist[0x1FF]++;
        }
        else {
            light_hist[0x3FF]++;
        }
    }
    else {
        light_sample_count++;
        uint8_t code_idx = 0;
        uint8_t len_needed = 0;
        uint16_t code = 0;
        if(diff < 32 && diff >= -32) {
            code_idx = diff + 32;
            len_needed = light_code_lengths[code_idx];
            code = light_diff_codes[code_idx];
        }
        else if(diff < 256 && diff >= -256) {
            code_idx = 64;
            len_needed = light_code_lengths[code_idx] + 9;
            code = light_diff_codes[code_idx];
        }
        else {
            code_idx = 65;
            len_needed = light_code_lengths[code_idx] + 11;
            code = light_diff_codes[code_idx];
        }

        if(!has_header) {
            len_needed += UNIT_HEADER_SIZE;

        }

        if(code_cache_remainder < len_needed) {
            flush_code_cache();
            has_header = false;
        }

        if(!has_header) {
            store_code(edge_time & 0x1FFFF, 17);
            store_code(day_state, 2);
            store_code(start_idx, 7);
            has_header = true;
        }

        store_code(code, light_code_lengths[code_idx]);

        if(code_idx == 64) {
            store_code(diff, 9);
        }
        else if(code_idx == 65) {
            store_code(diff, 11);
        }
        // cout << "code_cache_remainder = " << code_cache_remainder << endl; 
    }

}

void Sim::store_day_state_stop() {
    if(train) {
        uint8_t len_needed = 6;
        if(code_cache_remainder < len_needed) {
            flush_code_cache();
        }
        else {
            store_code(0b111111, 6);
            light_hist[0x400]++;
        }
    }
    else {
        uint8_t len_needed = light_code_lengths[66];
        if(code_cache_remainder < len_needed) {
            flush_code_cache();
        }
        else {
            store_code(light_diff_codes[66], len_needed);
        }
    }
}

void Sim::store_code(int32_t code, int8_t len) {
    assert(code_cache_remainder >= len);
    right_shift_arr(code_cache, code, CODE_CACHE_LEN, -len);
    code_cache_remainder -= len;
}

void Sim::flush_code_cache() {
    if(code_cache_remainder < CODE_CACHE_MAX_REMAINDER) {
        right_shift_arr(code_cache, 0, CODE_CACHE_LEN, -code_cache_remainder);
        // set sentinel value
        code_cache[0] |= 0x80000000;
        write_to_mem(code_cache, code_addr, CODE_CACHE_LEN);
        code_addr += CODE_CACHE_LEN << 2;
        code_cache_remainder = CODE_CACHE_MAX_REMAINDER;
        light_word_count += CODE_CACHE_LEN;
    }
}

void Sim::store_temp_code(int16_t code, int8_t len) {
    assert(temp_cache_remainder >= len);
    right_shift_arr(temp_cache, code, TEMP_CACHE_LEN, -len);
    temp_cache_remainder -= len;
}

void Sim::flush_temp_cache() {
    if(temp_cache_remainder < TEMP_CACHE_MAX_REMAINDER) {
        // shift 0s into unused space
        right_shift_arr(temp_cache, 0, TEMP_CACHE_LEN, -temp_cache_remainder);
        // add header
        // Use the space for CRC to mark temp packet
        temp_cache[0] = (CHIP_ID << 10) 
                        | ((day_count & 0x1F) << 5) 
                        | ((store_temp_index >> 1) & 0x1F);

        temp_cache[1] &= 0x7FFFFFFF;
        temp_cache[1] |= (store_temp_index << 31);

        write_to_mem(temp_cache, code_addr, TEMP_CACHE_LEN - 1);

        code_addr += TEMP_CACHE_LEN << 2;
        temp_cache_remainder = TEMP_CACHE_MAX_REMAINDER;
        temp_word_count += TEMP_CACHE_LEN;
    }
}

void Sim::sample_temp() {
    uint32_t snt_sys_temp_code = get_temp_data(xo_sys_time_in_sec + sys_to_epoch_offset);

    temp_sample_times_map[xo_sys_time_in_sec + sys_to_epoch_offset] = -103.3 + 606 / (12.08 - log(snt_sys_temp_code));

    if(train) {
        uint8_t len_needed = 4;

        if(temp_cache_remainder < len_needed) {
            temp_cache_remainder = TEMP_CACHE_MAX_REMAINDER;
            last_log_temp = 0;
        }

        // Take 3 bits above decimal point and 4 bits under
        uint8_t log_temp = func_log2(snt_sys_temp_code) >> (8 - TEMP_RES); 

        if(temp_cache_remainder == TEMP_CACHE_MAX_REMAINDER) {
            temp_cache_remainder -= TEMP_RES;
        }
        else {
            int diff = log_temp - last_log_temp;
            cout << "temp diff " << (int) log_temp << " " << (int) last_log_temp << " " << diff << endl;

            if(diff < 2 && diff >= -2) {
                temp_hist[diff]++;
            }
            else {
                temp_hist[0x7F]++;
            }
            temp_cache_remainder -= len_needed;
        }

        last_log_temp = log_temp;

        // increment temp index here to make sure we store the correct index
        store_temp_index++;

        if(store_temp_index > 47) {
            store_temp_index = 0;   // resets when taking the midnight data
        }
    }
    else {
        temp_sample_count++;

        // Take 3 bits above decimal point and 4 bits under
        uint8_t log_temp = func_log2(snt_sys_temp_code) >> (8 - TEMP_RES); 
        uint8_t len_needed = 0;
        int16_t diff = log_temp - last_log_temp;
        last_log_temp = log_temp;
        uint8_t code = 0;
        uint8_t code_idx = 0;

        if(diff < 2 && diff >= -2) {
            code_idx = diff + 2;
            len_needed = temp_code_lengths[code_idx];
            code = temp_diff_codes[code_idx];
        }
        else {
            code_idx = 4;
            len_needed = temp_code_lengths[code_idx] + TEMP_RES;
            code = temp_diff_codes[code_idx];
        }

        if(temp_cache_remainder < len_needed) {
            flush_temp_cache();
        }
    
        if(temp_cache_remainder == TEMP_CACHE_MAX_REMAINDER) {
            store_temp_code(log_temp, TEMP_RES);
        }
        else {
            store_temp_code(code, temp_code_lengths[code_idx]);

            if(code_idx == 4) {
                store_temp_code(diff, TEMP_RES);
            }
        }

        // increment temp index here to make sure we store the correct index
        store_temp_index++;

        if(store_temp_index > 47) {
            store_temp_index = 0;   // resets when taking the midnight data
        }
    }
}

void Sim::radio_full_data() {

}

void Sim::configure_sim(double lat_in, double lon_in) {
    lat = lat_in;
    lon = lon_in;

    string loc_path = getenv("LOC_DIR");
    loc_path += "/";

    ofstream loc_fout1(loc_path + "loc/" + raw_filename + "_sample_times_loc.csv");
    if(!loc_fout1.is_open()) {
        cout << "Error opening loc_fout1" << endl;
        assert(0);
    }
    loc_fout1 << lat_in << " " << lon_in << endl;

    ofstream loc_fout2(loc_path + "loc/" + raw_filename + "_HOBO_loc.csv");
    if(!loc_fout2.is_open()) {
        cout << "Error opening loc_fout2" << endl;
        assert(0);
    }
    loc_fout2 << lat_in << " " << lon_in << endl;
}

uint32_t Sim::day_time_2_sec(const string& str) {
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

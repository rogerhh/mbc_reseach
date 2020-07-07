#include "Sim_v2.hpp"

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

using namespace json11;
using namespace std;

Sim::Sim(const string& filename_in) {
    measurement_map = read_file(filename_in);
    regex e("(.+)\/(.+)\.csv");
    smatch m;
    regex_search(filename_in, m, e);
    filename = "/home/rogerhh/mbc_research/data/src/compression_sim/sample_data/" + m.str(2) + "_sample_times.csv";
    sample_times_fout = ofstream(filename);
    cout << filename << endl;
    if(!sample_times_fout.is_open()) {
        cout << "Error opening file: " << filename << endl;
        exit(1);
    }

    ifstream hist_fin("/home/rogerhh/mbc_research/data/src/compression_sim/histogram.txt");

    int code, count;
    while(hist_fin >> code >> count) {
        hist[code] = count;
    }

    hist_fin.close();
}

Sim::~Sim() {
    ofstream hist_fout("/home/rogerhh/mbc_research/data/src/compression_sim/histogram.txt");

    for(auto p : hist) {
        hist_fout << p.first << " " << p.second << endl;
    }

    for(auto p : sample_times_map) {
        sample_times_fout << p.first << " " << p.second << endl;
    }
}

void Sim::print_proc_cache() {
    cout << "proc_cache = ";
    for(int i = 0; i < PROC_CACHE_LEN; i++) {
        cout << bitset<32>(proc_cache[i]) << " ";
    }
    cout << dec << endl;
}

uint32_t right_shift(uint32_t data, int8_t len) {
    if(len > 0) {
        uint8_t i;
        for(i = 0; i < len; i++) {
            data = data >> 1;
        }
    }
    else {
        uint8_t i;
        len = -len;
        for(i = 0; i < len; i++) {
            data = data << 1;
        }
    }
    return data;
}

// + is right shift, - is left shift
// if shift_len is greater than 32, data must be 0
// if right_shift, data must be 0
void right_shift_arr(uint32_t* arr, uint32_t data, uint8_t arr_len, int16_t shift_len) {
    if(shift_len == 0) { return; }
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

    // shift word by word
    while(shift_len >= 32) {
        // use end - 1
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

void Sim::start_sim(uint32_t day_time_in, uint32_t sys_time_in, 
                    uint32_t start_hour, uint32_t duration_in_hour,
                    uint32_t cur_sunrise_in, uint32_t cur_sunset_in,
                    uint32_t epoch_time,
                    const string& sample_times_file) {

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
    max_idx = 0;
    starting_idx = 0xFF;
    projected_end_time_in_sec = xo_sys_time_in_sec + XO_8_MIN;
    cur_edge = projected_end_time_in_sec;

    cout << "end_time = " << end_time << endl
         << "max query = " << end_time + sys_to_epoch_offset << endl;


    while(1) {          
        xo_day_time_in_sec += projected_end_time_in_sec - xo_sys_time_in_sec;
        if(xo_day_time_in_sec >= MAX_DAY_TIME) {
            xo_day_time_in_sec -= MAX_DAY_TIME;
            day_count++;
        }
        xo_sys_time_in_sec = projected_end_time_in_sec;

        if(xo_sys_time_in_sec >= end_time) {
            break;
        }

        wake_up_and_run();

    }                   
}

void Sim::wake_up_and_run() {
    // wake up
    uint64_t lnt_sys_light = get_data(measurement_map, xo_sys_time_in_sec + sys_to_epoch_offset);
    // measure and store to cache
    uint16_t log_light = func_log2(lnt_sys_light);
    cout << "log_light = " << log_light << endl;
    write_to_proc_cache(log_light, 11);

    // store to running sum
    if(sum == 0xFFFF) {
        // if uninitialized, initialize running avg
        for(int i = 0; i < 8; i++) {
            running_avg[i] = log_light;
            running_avg_time[i] = log_light;
        }
        sum = log_light << 3;
    }
    else {
        sum -= running_avg[rot_idx];
        sum += log_light;

        running_avg_time[rot_idx] = xo_day_time_in_sec;
        running_avg[rot_idx] = log_light;

        rot_idx = (rot_idx + 1) & 7;
    }


    uint32_t target = 0;
    cout << "avg = " << (sum >> 3) << " " << EDGE_THRESHOLD << endl;
    if(day_state == DAWN && starting_idx == 0xFF && (sum >> 3) >= EDGE_THRESHOLD) {
        starting_idx = max_idx;
        starting_idx_time = projected_end_time_in_sec;
        target = running_avg_time[(rot_idx + 3) & 7];
        cout << "starting_idx = " << (int) starting_idx << "; starting_idx_time = " << starting_idx_time << endl;
    }
    else if(day_state == DUSK && starting_idx == 0xFF && (sum >> 3) <= EDGE_THRESHOLD) {
        starting_idx = max_idx;
        starting_idx_time = projected_end_time_in_sec;
        target = running_avg_time[(rot_idx + 3) & 7];
        cout << "starting_idx = " << (int) starting_idx << "; starting_idx_time = " << starting_idx_time << endl;
    }

    if(target) {
        if(target > cur_edge + MAX_EDGE_SHIFT) {
            target = cur_edge + MAX_EDGE_SHIFT;
        }
        else if(target < cur_edge - MAX_EDGE_SHIFT) {
            target = cur_edge - MAX_EDGE_SHIFT;
        }

        if(day_state == DAWN) {
            next_sunrise = target;
        }
        else if(day_state == DUSK) {
            next_sunset = target;
        }
    }

    // set next state
    uint32_t day_state_end_time;
    if(day_state == DAWN) {
        day_state_end_time = cur_sunrise + EDGE_MARGIN1;
    }
    else if(day_state == NOON) {
        day_state_end_time = cur_sunset - EDGE_MARGIN1;
    }
    else if(day_state == DUSK) {
        day_state_end_time = cur_sunset + EDGE_MARGIN2;
    }
    else{
        day_state_end_time = cur_sunrise - EDGE_MARGIN2;
    }

    // set next time
    if(day_state == DAWN || day_state == DUSK) {
        projected_end_time_in_sec += 60;
    }
    else {
        projected_end_time_in_sec += 1920;
    }

    bool new_state = false;
    uint32_t temp = xo_day_time_in_sec + projected_end_time_in_sec - xo_sys_time_in_sec;
    cout << "temp = " << temp << endl;
    if(day_state != NIGHT) {
        new_state = temp >= day_state_end_time;
    }
    else {
        new_state = temp >= day_state_end_time 
                    && temp < MID_DAY_TIME;
    }

    if(new_state) {
        if(day_state != NIGHT) {
            // resample and store
            // 1. Shift 0s into proc cache if going from first to last
            // 2. if dawn, go from first to last, start from starting idx and store in some pattern
            // 3. if dusk, go from last to first, start from starting idx and store in some pattern
            // 4. if noon, go from first to last, start from starting_idx and store everything
            // 5. if night, don't store
            
            // store header

            int16_t start, end, sign;
            uint32_t sample_time = starting_idx_time;
            if(day_state != DUSK) { // == DUSK or NOON
                // because we're going from first to last, left shift 0s into proc_cache
                cout << "max idx = " << (int) max_idx << endl;
                write_to_proc_cache(0, proc_cache_remainder);
                proc_cache_remainder = 0;   // manually set to 0 to start reading
                cache_addr = CACHE_START_ADDR;

                if(day_state == NOON) {
                    starting_idx = 0;
                    cout << "starting_idx_time = " << starting_idx_time << endl;
                    sample_time = starting_idx_time;
                }
                else if(starting_idx == 0xFF) {
                    starting_idx = 0;
                }

                // first to last
                start = 0;
                end = max_idx + 1;
                sign = 1;
            }
            else {
                cout << "proc_cache_remainder = " << proc_cache_remainder << endl;
                proc_cache_remainder = PROC_CACHE_MAX_REMAINDER - proc_cache_remainder;   // manually set to 0 to start reading
                starting_idx = starting_idx == 0xFF? max_idx : starting_idx;

                if(starting_idx == 0xFF) {
                    starting_idx = max_idx;
                    sample_time = projected_end_time_in_sec;
                }
                else {
                    sample_time = starting_idx_time;
                }

                print_proc_cache();
                // last to first
                start = max_idx;
                end = -1;
                sign = -1;
            }

            cout << "starting idx = " << (int) starting_idx << endl;
            cout << "sample time = " << sample_time << endl;

            // iterate through all samples
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

                    // store diff
                    uint16_t diff = log_light - last_log_light;
                    store_diff_to_code_cache(diff, sample_idx, cur_edge);
                    cout << sample_time << " " << log_light << endl;
                    sample_times_map[sample_time] = log_light / 32.0;

                    sample_idx++;
                    last_log_light = log_light;
                    if(day_state == NOON) {
                        next_sample_idx++;
                        sample_time += 1920;
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
            cout << endl;
            store_day_state_stop();
        }

        cache_addr = CACHE_START_ADDR;
        proc_cache_remainder = PROC_CACHE_MAX_REMAINDER;
        day_state = (day_state + 1) & 0b11;
        max_idx = 0;
        starting_idx = 0xFF;

        projected_end_time_in_sec = xo_sys_time_in_sec + day_state_end_time - xo_day_time_in_sec;
        if(day_state == DAWN) {
            cur_sunrise = next_sunrise == 0? cur_sunrise : next_sunrise;
            cur_edge = cur_sunrise;
            starting_idx_time = projected_end_time_in_sec;
        }
        else if(day_state == DUSK) {
            cur_sunset = next_sunset == 0? cur_sunset : next_sunset;
            cur_edge = cur_sunset;
        }
        else {
            projected_end_time_in_sec += XO_32_MIN;
            starting_idx_time = projected_end_time_in_sec;
        }
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

void Sim::write_to_proc_cache(uint16_t data, int16_t len) {
    data &= (right_shift(1, -len) - 1);

    if(len >= proc_cache_remainder) {
        // if no more cache space, store what can be stored
        uint16_t temp = right_shift(data, len - proc_cache_remainder);
        right_shift_arr(proc_cache, temp, PROC_CACHE_LEN, -proc_cache_remainder);
        print_proc_cache();
        write_to_mem(proc_cache, cache_addr, PROC_CACHE_LEN);
        cout << "flushing proc cache to " << cache_addr << endl;
        cache_addr += (PROC_CACHE_LEN << 2);
        uint16_t mask = right_shift(1, len - proc_cache_remainder) - 1;
        data &= mask;
        len -= proc_cache_remainder;
        proc_cache_remainder = PROC_CACHE_MAX_REMAINDER;
    }

    right_shift_arr(proc_cache, data, PROC_CACHE_LEN, -len);
    proc_cache_remainder -= len;
}

uint16_t Sim::read_next_from_proc_cache() {
    uint16_t res = 0;

    if(day_state == DUSK) {
        // read leftover bits
        // load new array from mem
        // read more bits
        uint16_t len = 11;
        uint16_t mask = 0x7FF;
        if(proc_cache_remainder < 11) {
            cout << "remainder = " << proc_cache_remainder << endl;
            res = proc_cache[PROC_CACHE_LEN - 1] & 0x7FF;
            mask = right_shift(mask, 11 - proc_cache_remainder);
            len -= proc_cache_remainder;

            // decrement address before reading because we start on an incorrect address
            cache_addr -= PROC_CACHE_LEN << 2;
            read_from_mem(proc_cache, cache_addr, PROC_CACHE_LEN);
            cout << "Reading mem from " << cache_addr << endl;
            proc_cache_remainder = PROC_CACHE_MAX_REMAINDER;
        }

        res |= right_shift(proc_cache[PROC_CACHE_LEN - 1] & mask, 11 - len);
        proc_cache_remainder -= len;

        right_shift_arr(proc_cache, 0, PROC_CACHE_LEN, len);
    }
    else {
        uint8_t len = 11;
        if(proc_cache_remainder < 11) {
            res = right_shift(proc_cache[0], 32 - proc_cache_remainder);
            res = right_shift(res, proc_cache_remainder - 11);
            
            len -= proc_cache_remainder;

            read_from_mem(proc_cache, cache_addr, PROC_CACHE_LEN);
            cout << "Reading mem from " << cache_addr << endl;
            cache_addr += PROC_CACHE_LEN << 2;
            proc_cache_remainder = PROC_CACHE_MAX_REMAINDER;
        }

        res |= right_shift(proc_cache[0], 32 - len);
        proc_cache_remainder -= len;

        right_shift_arr(proc_cache, 0, PROC_CACHE_LEN, -len);
    }

    return res;
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
            store_code(start_idx, 8);
        }

        store_code(0b100000, 6);

        if(diff < 32 && diff >= -32) {
            hist[diff]++;
        }
        else if(diff < 256 && diff >= -256) {
            hist[0x1FF]++;
        }
        else {
            hist[0x3FF]++;
        }
    }
    else {
        uint8_t code_idx = 0;
        uint8_t len_needed = 0;
        uint16_t code = 0;
        if(diff < 32 && diff >= -32) {
            code_idx = diff + 32;
            len_needed = code_lengths[code_idx];
            code = diff_codes[code_idx];
        }
        else if(diff < 256 && diff >= -256) {
            code_idx = 64;
            len_needed = code_lengths[code_idx] + 9;
            code = diff_codes[code_idx];
        }
        else {
            code_idx = 65;
            len_needed = code_lengths[code_idx] + 11;
            code = diff_codes[code_idx];
        }

        if(!has_header) {
            len_needed += UNIT_HEADER_SIZE;
            if(code_cache_remainder < len_needed) {
                flush_code_cache();
            }

            store_code(edge_time & 0x1FFFF, 17);
            store_code(day_state, 2);
            store_code(start_idx, 8);
        }

        store_code(code, code_lengths[code_idx]);

        if(code_idx == 64) {
            store_code(diff, 9);
        }
        else if(code_idx == 65) {
            store_code(diff, 11);
        }
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
            hist[0x400]++;
        }
    }
}

void Sim::store_code(int32_t code, uint8_t len) {
    assert(code_cache_remainder >= len);
    right_shift_arr(code_cache, code, CODE_CACHE_LEN, -len);
    code_cache_remainder -= len;
}

void Sim::flush_code_cache() {
    if(code_cache_remainder < CODE_CACHE_MAX_REMAINDER) {
        right_shift_arr(code_cache, 0, CODE_CACHE_LEN, code_cache_remainder);
        write_to_mem(code_cache, code_addr, CODE_CACHE_LEN);
        code_addr += CODE_CACHE_LEN << 2;
        code_cache_remainder = CODE_CACHE_MAX_REMAINDER;
    }
}

void Sim::write_to_mem(uint32_t* arr, uint16_t addr, uint8_t len) {
    uint16_t i;
    for(i = 0; i < len; i++) {
        mem[(addr >> 2) + i] = arr[i];
    }
}

void Sim::read_from_mem(uint32_t* arr, uint16_t addr, uint8_t len) {
    uint16_t i;
    for(i = 0; i < len; i++) {
        arr[i] = mem[(addr >> 2) + i];
    }
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


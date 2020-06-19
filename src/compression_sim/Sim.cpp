#include "Sim.hpp"

#include "read_data.hpp"
#include "log2.hpp"

#include <iostream>
#include <fstream>

using namespace std;

Sim::Sim(const string& filename) {
    measurement_map = read_file(filename);
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

    ofstream samples_1min_fout("sample_times_1min.csv");
    ofstream samples_2min_fout("sample_times_2min.csv");
    ofstream samples_8min_fout("sample_times_8min.csv");
    ofstream samples_32min_fout("sample_times_32min.csv");
    ofstream code_difference_fout("code_difference.csv");

    uint32_t start_hour_in_sec = start_hour * 3600;
    next_sys_time = sys_time + start_hour_in_sec - day_time_in;

    uint32_t end_time = next_sys_time + duration_in_hour * 3600;

    cout << next_sys_time << " " << end_time << " " << duration_in_hour << endl;

    cur_index = 0;

    // set is_morning
    if(day_time <= (43200 - 1800) || day_time > (86400 - 1800)) {
        // set 30 minute margin from noon and midnight
        is_morning = 1;
    }
    else {
        is_morning = 0;
    }

    cout << "cur_sunrise = " << parse_day_time(cur_sunrise) 
         << "; cur_sunset = " << parse_day_time(cur_sunset) << endl
         << "next_sunrise = " << parse_day_time(next_sunrise) 
         << "; next_sunset = " << parse_day_time(next_sunset) << endl
         << "sys_time = " << sys_time << "; day_time = " << parse_day_time(day_time) << endl
         << "sys_to_epoch_offset = " << sys_to_epoch_offset 
         << "; next_sys_time = " << next_sys_time << endl
         << "is_morning = " << (int) is_morning << "; cur_index = " << (int) cur_index
         << "; interval_index = " << (int) interval_index << endl;

    uint16_t last_light_code = 0;

    while(next_sys_time <= end_time) {
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

            cout << "edge = " << parse_day_time(edge) 
                 << "; margin1 = " << parse_day_time(margin1)
                 << "; margin2 = " << parse_day_time(margin2)
                 << "; new_start = " << new_start << endl;

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

        sample_times_fout << q << "," << lux << endl;
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

        code_difference_fout << q << "," << raw_light_code << "," << light_code << "," << light_code - last_light_code << endl;
        last_light_code = light_code;

        if(sum == 0xFFFF) {
            // if uninitialized, initialize running avg
            for(int i = 0; i < 8; i++) {
                running_avg[i] = light_code;
            }
            sum = light_code << 3;
        }
        else {
            sum -= running_avg[7];
            sum += light_code;

            for(int i = 7; i > 0; i--) {
                running_avg[i] = running_avg[i - 1];
            }
            running_avg[0] = light_code;
        }

        if(is_morning && next_sunrise == 0 && (sum >> 3) >= EDGE_THRESHOLD) {
            if(day_time > cur_sunrise + MAX_EDGE_SHIFT) {
                next_sunrise = cur_sunrise + MAX_EDGE_SHIFT;
            }
            else if(day_time < cur_sunrise - MAX_EDGE_SHIFT) {
                next_sunrise = cur_sunrise - MAX_EDGE_SHIFT;
            }
            else {
                next_sunrise = day_time;
            }
        }
        else if(!is_morning && next_sunset == 0 && (sum >> 3) <= EDGE_THRESHOLD) {
            if(day_time > cur_sunset + MAX_EDGE_SHIFT) {
                next_sunset = cur_sunset + MAX_EDGE_SHIFT;
            }
            else if(day_time < cur_sunset - MAX_EDGE_SHIFT) {
                next_sunset = cur_sunset - MAX_EDGE_SHIFT;
            }
            else {
                next_sunset = day_time;       
            }
        }

        // determine next wakeup time
        // if at the end of this half-day, switch to the next half-day
        if(is_morning && ((day_time >= NOON - 1920) || cur_index >= dawn_indices[7])) {
            is_morning = 0;
            cur_index = 0;
            cur_sunset = next_sunset == 0? cur_sunset : next_sunset;
            next_sunset = 0;
        }
        else if(!is_morning && ((day_time >= MAX_DAY_TIME - 1920) || cur_index >= dawn_indices[7])) {
            is_morning = 1;
            cur_index = 0;
            cur_sunrise = next_sunrise == 0? cur_sunrise : next_sunrise;
            next_sunrise = 0;
        }
        else {
            next_sys_time = sys_time + (INTERVALS[interval_index] * 60);

            cur_index++;
            if(cur_index >= dawn_indices[interval_index]) {
                interval_index++;
            }
        }

        cout << "sys_time = " << sys_time << "; day_time = " << parse_day_time(day_time) << endl
             << "sys_to_epoch_offset = " << sys_to_epoch_offset
             << "; cur_sunrise = " << parse_day_time(cur_sunrise) 
             << "; cur_sunset = " << parse_day_time(cur_sunset) << endl
             << "next_sunrise = " << parse_day_time(next_sunrise) 
             << "; next_sunset = " << parse_day_time(next_sunset) << endl
             << "; next_sys_time = " << next_sys_time << endl
             << "is_morning = " << (int) is_morning << "; cur_index = " << (int) cur_index
             << "; interval_index = " << (int) interval_index << endl;

        cout << "raw light code = " << raw_light_code << endl;

        for(int i = 0; i < 8; i++) {
            cout << running_avg[i] << " ";
        }
        cout << endl << "sum = " << (sum >> 3) << endl;

        /*
        cout << "\n\nPause. Press to continue" << endl;
        string str;
        cin >> str;
        */
    }

}

void store_data(uint16_t light_code) {
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

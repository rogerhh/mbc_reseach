#ifndef SIM_HPP
#define SIM_HPP

#include <stdint.h>
#include <vector>
#include <map>
#include <ctime>
#include <string>

#define MAX_EDGE_SHIFT 600
#define MAX_DAY_TIME 86400
#define NOON 43200
#define EDGE_MARGIN 28770   // (12 * 32 + 4 * 8 + 16 * 2 + 31 + 0.5) * 60

#define EDGE_THRESHOLD 520 // = log2(50 lux * 1577) * 32

class Sim {
public:
    uint16_t running_avg[8] = {0, 0, 0, 0, 0, 0, 0, 0};
    uint16_t sum = 0xFFFF;

    uint32_t cur_sunrise = 0, cur_sunset = 0, next_sunrise = 0, next_sunset = 0;
    uint32_t sys_time = 0, day_time = 0, sys_to_epoch_offset = 0, next_sys_time = 0;

    uint8_t is_morning = 1;
    uint8_t cur_index = 0;
    uint8_t interval_index = 0;
    uint8_t INTERVALS[8] = {32, 8, 2, 1, 1, 2, 8, 32};
    uint8_t dawn_indices[8] = {12, 16, 32, 64, 96, 112, 116, 128}; // culmulative indices to determine which interval to use

    std::vector<uint32_t> data;
    std::vector<uint32_t> cache;
    std::map<time_t, double> measurement_map;

    Sim(const std::string& filename);
    

    void start_sim(uint32_t day_time_in, uint32_t sys_time_in, 
                   uint32_t start_hour, uint32_t duration_in_hour,
                   uint32_t cur_sunrise_in, uint32_t cur_sunset_in,
                   uint32_t epoch_time,
                   const std::string& sample_times_file);

    void store_data(uint16_t light_code);

    std::string parse_day_time(uint32_t ts);
};

#endif

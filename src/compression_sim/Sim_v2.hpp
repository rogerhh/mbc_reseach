#ifndef SIM_V2_HPP
#define SIM_V2_HPP

#include <stdint.h>
#include <vector>
#include <map>
#include <ctime>
#include <string>
#include <utility>
#include <fstream>

#define MAX_EDGE_SHIFT 600
#define MAX_DAY_TIME 86400
#define MID_DAY_TIME 43200
#define EDGE_MARGIN1 10770 // 179 * 60 + 30 = 10770
#define EDGE_MARGIN2 3570 // 59 * 60 + 30 = 3570

#define EDGE_THRESHOLD 372 // = log2(2 lux * 1577) * 32

#define XO_1_MIN 60
#define XO_8_MIN 480
#define XO_32_MIN 1920

class Sim {
public:
    bool train = true;

    uint32_t start_day_time = 0;
    uint32_t start_hour_plus_one = 0;
    uint32_t SN = 0;

    std::tm start_tm;
    int tz_hr = 0, tz_min = 0;
    std::string tz_sign;
    std::string filename;
    std::map<uint32_t, double> sample_times_map;
    std::ofstream sample_times_fout;

    std::map<time_t, double> measurement_map;
    std::map<int, uint32_t> hist;

    // c variables
    uint8_t day_count = 0;
    uint8_t rot_idx = 0;
    uint16_t running_avg[8] = {0, 0, 0, 0, 0, 0, 0, 0};
    uint16_t sum = 0xFFFF;
    uint32_t running_avg_time[8] = {0, 0, 0, 0, 0, 0, 0, 0};

    uint32_t cur_sunrise = 0, cur_sunset = 0, next_sunrise = 0, next_sunset = 0, cur_edge = 0;
    uint32_t xo_sys_time_in_sec = 0, xo_day_time_in_sec = 0;
    uint32_t sys_to_epoch_offset = 0, projected_end_time_in_sec = 0;
    uint32_t starting_idx_time = 0;

    uint8_t max_idx = 0;
    uint8_t starting_idx = 0xFF;
    uint8_t intervals[4] = {1, 2, 8, 32};
    uint16_t resample_indices[4] = {32, 40, 42, 1000};

    uint16_t diff_codes[67];
    uint8_t code_lengths[67];

#define CODE_CACHE_LEN 10
#define CODE_CACHE_MAX_REMAINDER 296 // 320 - 26 = 296
    uint32_t code_cache[10];
    uint16_t code_cache_remainder = CODE_CACHE_MAX_REMAINDER;

#define UNIT_HEADER_SIZE 28 // 7 bit edge time stamp, 2 bit day state, 8 bit starting idx
    bool has_header = false;

#define DAWN 0
#define NOON 1
#define DUSK 2
#define NIGHT 3
    uint8_t day_state = DAWN;

#define CACHE_START_ADDR 16024 // (4096 - ceil(240 * 11 / 320) * 10) << 2
    uint16_t cache_addr = CACHE_START_ADDR;
    uint16_t code_addr = 0;
    uint16_t mem_addr;
    uint32_t mem[4096];
#define PROC_CACHE_LEN 10
#define PROC_CACHE_MAX_REMAINDER 320
    uint32_t proc_cache[PROC_CACHE_LEN] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    uint16_t proc_cache_remainder = PROC_CACHE_MAX_REMAINDER;
    uint16_t read_cache_start_addr = 0;
    uint16_t read_cache_end_addr = 0;

    void start_sim(uint32_t day_time_in, uint32_t sys_time_in, 
                   uint32_t start_hour, uint32_t duration_in_hour,
                   uint32_t cur_sunrise_in, uint32_t cur_sunset_in,
                   uint32_t epoch_time,
                   const std::string& sample_times_file);

    void configure_sim();

    void wake_up_and_run();

    void write_to_proc_cache(uint16_t data, int16_t len);

    uint16_t read_next_from_proc_cache();

    void store_diff_to_code_cache(int16_t diff, uint8_t starting_idx, uint32_t edge_time);

    void store_code(int32_t code, uint8_t len);

    void store_day_state_stop();

    void flush_code_cache();

    void write_to_mem(uint32_t* arr, uint16_t addr, uint8_t len);

    void read_from_mem(uint32_t* arr, uint16_t addr, uint8_t len);

    Sim(const std::string& filename_in);
    ~Sim();

    std::map<std::time_t, double> read_file(const std::string& filename);

    uint64_t get_data(const std::map<std::time_t, double>& data_map, time_t q);
    
    double get_raw_data(const std::map<std::time_t, double>& data_map, time_t q);

    uint32_t day_time_2_sec(const std::string& str);

    void print_proc_cache();

};

#endif

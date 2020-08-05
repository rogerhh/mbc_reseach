#ifndef SIM_V3_HPP
#define SIM_V3_HPP

#include <stdint.h>
#include <vector>
#include <map>
#include <ctime>
#include <string>
#include <utility>
#include <fstream>

// sampling variables
#define DAWN 0
#define NOON 1
#define DUSK 2
#define NIGHT 3

#define MAX_EDGE_SHIFT 600
#define MAX_DAY_TIME 86400
#define MID_DAY_TIME 43200
#define IDX_MAX 239         // x = 179, y = 59, x + y + 1
#define EDGE_MARGIN1 10770 // x * 60 + 30 = 10770
#define EDGE_MARGIN2 3570 // y * 60 + 30 = 3570

#define EDGE_THRESHOLD 200 // = log2(2 lux * 1577) * 32
#define THRESHOLD_IDX_SHIFT 8 // = 4 + 4

#define XO_1_MIN 60
#define XO_2_MIN 120
#define XO_8_MIN 480
#define XO_10_MIN 600
#define XO_16_MIN 960
#define XO_20_MIN 1200
#define XO_30_MIN 1800
#define XO_32_MIN 1920
#define XO_270_MIN 19600 // 4 hours and 30 minutes

#define IDX_INIT 0xFF

class Sim {
public:
#define CHIP_ID 12

    bool train = true;

    uint32_t start_day_time = 0;
    uint32_t start_hour_plus_one = 0;
    uint32_t SN = 0;
    
    double lat = 0xFFFF, lon = 0xFFFF;
    std::tm start_tm;
    int tz_hr = 0, tz_min = 0;
    std::string tz_sign;

    std::map<uint32_t, double> light_sample_times_map;
    std::map<uint32_t, double> temp_sample_times_map;
    std::ofstream light_sample_times_fout;
    std::ofstream temp_sample_times_fout;
    std::string raw_filename;

    std::map<time_t, double> light_measurement_map;
    std::map<time_t, double> temp_measurement_map;
    std::map<int, uint32_t> light_hist;
    std::map<int, uint32_t> temp_hist;
    uint32_t sys_to_epoch_offset = 0;

    uint16_t light_diff_codes[67];
    uint8_t light_code_lengths[67];
    uint8_t temp_diff_codes[5];
    uint8_t temp_code_lengths[5];

    int light_sample_count = 0;
    int light_word_count = 0;
    int temp_sample_count = 0;
    int temp_word_count = 0;

    // c variables
    uint8_t day_count = 0;
    uint8_t rot_idx = 0;
    uint16_t running_avg[8] = {0, 0, 0, 0, 0, 0, 0, 0};
    uint32_t running_avg_time[8] = {0, 0, 0, 0, 0, 0, 0, 0};
    uint16_t sum = 0xFFFF;
    uint16_t avg_light = 0;

    uint32_t cur_sunrise = 0, cur_sunset = 0, next_sunrise = 0, next_sunset = 0, cur_edge = 0;
    uint32_t xo_sys_time_in_sec = 0, xo_day_time_in_sec = 0;
    uint32_t projected_end_time_in_sec = 0;
    uint32_t next_light_meas_time = 0;
    uint32_t store_temp_timestamp = 0;
    uint8_t store_temp_index = 0;
    uint32_t threshold_idx_time = 0;
    uint32_t min_light_time = 0;
    uint32_t day_state_start_time, day_state_end_time;

    uint8_t max_idx = 0;
    const uint8_t intervals[4] = {1, 2, 8, 32};
    const uint16_t resample_indices[4] = {32, 40, 44, 1000};
    uint16_t min_light = 0xFFFF;
    uint16_t min_light_idx = IDX_INIT;
    uint16_t threshold_idx = IDX_INIT;

#define CODE_CACHE_LEN 9
#define CODE_CACHE_MAX_REMAINDER 272 // 320 - 12 * 4 = 272
    uint32_t code_cache[CODE_CACHE_LEN];
    uint16_t code_cache_remainder = CODE_CACHE_MAX_REMAINDER;

#define UNIT_HEADER_SIZE 26 // 17 bit edge time stamp, 2 bit day state, 7 bit starting idx
    bool has_header = false;

#define DAWN 0
#define NOON 1
#define DUSK 2
#define NIGHT 3
    uint8_t day_state = DAWN;

#define CACHE_START_ADDR 16024 // (4096 - ceil(240 / floor(320 / 11)) * 10) << 2 = (4096 - 90) * 4
    uint16_t cache_addr = CACHE_START_ADDR;
    uint16_t code_addr = 0;
    uint32_t mem[4096];
#define PROC_CACHE_LEN 10
#define PROC_CACHE_MAX_REMAINDER 320
    uint32_t proc_cache[PROC_CACHE_LEN];
    uint16_t proc_cache_remainder = PROC_CACHE_MAX_REMAINDER;

#define TEMP_CACHE_LEN 3
#define TEMP_CACHE_MAX_REMAINDER 64 // 96 - 16 (crc) - 1 (light or temp) - 5 (chip id) - 4 (day count) - 6 (timestamp in half hour)
#define TEMP_RES 7
    uint32_t temp_cache[TEMP_CACHE_LEN];
    uint8_t temp_cache_remainder = TEMP_CACHE_MAX_REMAINDER;
    uint8_t last_log_temp = 0;

    void start_sim(uint32_t day_time_in, uint32_t sys_time_in, 
                   uint32_t start_hour, uint32_t duration_in_hour,
                   uint32_t cur_sunrise_in, uint32_t cur_sunset_in,
                   uint32_t epoch_time,
                   const std::string& sample_times_file);

    void configure_sim(double lat_in, double lon_in);

    void sample_light();
    void sample_temp();

    void write_to_proc_cache(uint16_t data);

    uint16_t read_next_from_proc_cache();

    void store_diff_to_code_cache(int16_t diff, uint8_t starting_idx, uint32_t edge_time);

    void store_code(int32_t code, int8_t len);

    void store_day_state_stop();

    void flush_code_cache();

    void store_temp_code(int16_t code, int8_t len);

    void flush_temp_cache();

    void write_to_mem(uint32_t* arr, uint16_t addr, uint8_t len);

    void read_from_mem(uint32_t* arr, uint16_t addr, uint8_t len);

    void set_projected_end_time();
    void set_new_state();

    void radio_full_data();

    Sim(const std::string& filename_in, bool train_in);
    ~Sim();

    void read_file(const std::string& filename);

    uint64_t get_light_data(time_t q);
    double get_raw_light_data(time_t q);
    uint32_t get_temp_data(time_t q);
    double get_raw_temp_data(time_t q);
    
    double get_raw_data(const std::map<std::time_t, double>& data_map, time_t q);

    uint32_t day_time_2_sec(const std::string& str);

    void print_proc_cache();

};

#endif

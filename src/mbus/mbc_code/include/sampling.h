/********************
 * Author: Roger Hsiao
 *
 * Provides sampling interval for monarch code
 *
 *
 *******************/

#ifndef SAMPLING_H
#define SAMPLING_H


#include <stdint.h>

#define MAX_EDGE_SHIFT 600
#define MAX_DAY_TIME 86400
#define NOON 43200
#define EDGE_MARGIN 28770 // = (12 * 32 + 4 * 8 + 16 * 2 + 31 * 1 + 0.5) * 60

#define EDGE_THRESHOLD 520 // = log2(50 lux * 1577) * 32

uint16_t rot_idx = 0;
uint16_t running_avg[8] = {0, 0, 0, 0, 0, 0, 0, 0};
uint16_t sum = 0xFFFF;
uint32_t running_avg_time[8] = {0, 0, 0, 0, 0, 0, 0, 0};

uint32_t start_day_time = 0;
uint32_t cur_sunrise = 0;
uint32_t cur_sunset = 0;

uint8_t is_morning = 0;
uint8_t cur_index = 0;
uint8_t interval_idx = 0;
uint8_t INTERVALS[8] = {32, 8, 2, 1, 1, 2, 8, 32};
uint8_t SAMPLE_INDICES[8] = {12, 16, 32, 64, 96, 112, 116, 128};

uint32_t 


#endif

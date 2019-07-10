#ifndef TIMERS_H
#define TIMERS_H

#include <stdint.h>

#define TIMER_MODE 1

typedef void (*handler_t)(void);

// Clock runs at 32kHz
typedef struct Timer {
    handler_t handler;
    uint32_t time;
    uint32_t period;
    /* Control signals
     * bit0: MODE (1 = ONESHOT, 0 = CONTINUOUS)
     */
    uint32_t config;
    struct Timer* next;
} timer_t;

// function stubs
void start_timer(uint32_t time);
uint32_t get_timer_val();
// function stubs


void insert_timer(uint32_t init_time, uint32_t period, uint32_t config, handler_t handler);

void update_timers(uint32_t elapsed_time);


#endif

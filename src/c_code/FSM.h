#ifndef FSM_H
#define FSM_H

#include <stdint.h>

#define TIMER_ONESHOT 1

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

timer_t* timer_root;

timer_t light_timer;
timer_t temp_timer;
timer_t pres_timer;

void update_timers();

/* Determine next state and global parameters based on current time
 * Executes next action and goes to sleep with timer
 * Basically the timer interrupt handler
 */
void get_next_state_and_timer();

void state_init();

void operation_temp_sensor();
void read_temp();
void set_temp_sensor();

void read_light();

void read_pressure();

void store_data();

void readout_data();

#endif

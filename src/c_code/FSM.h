#ifndef FSM_H
#define FSM_H

#include <stdint.h>

#define TIMER_ONESHOT 1

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

#include "FSM.h"

void get_next_state_and_sleep() {
    while(timer_root->time == 0) {
        timer_root->handler();
        if(timer_root->config & TIMER_ONESHOT) {
            timer_root = timer_root->next;
        } else {
            update_timers();
        }
    }

}

uint32_t data[100];

// can merge all layer states together to save space later
uint8_t temp_counter = 0, temp_state = 0;
uint32_t temp_sum, temp_val;
void operation_temp_sensor() {
    // temp_state == 1 means the sensor has a new value
    if(temp_state == 1)
    {
        temp_sum += temp_val;
        temp_counter++;
    }
    if(temp_counter < 5) {
        set_temp_sensor();
        return;
    }
    
    data[0] = temp_sum / 5;
    temp_counter = 0;
}

void set_temp_sensor() {
    temp_state = 0;
}

// temp_handler
void read_temp() {
    temp_state = 1;
    operation_temp_sensor();
}

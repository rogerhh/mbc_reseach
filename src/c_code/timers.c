#include "timers.h"
#include <stdlib.h>
#include <assert.h>

timer_t* timer_root;

/***********function stubs**********/
void start_timer(uint32_t time)
{
    // reset crystal oscillator
}
/***********function stubs**********/

void insert_timer_inorder(timer_t* new_timer) {
    if(new_timer->time == 0) {
        assert(0);
    }
    if(new_timer->next != NULL) {
        assert(0);
    }


    if(!timer_root) {
        timer_root = new_timer;
        return;
    }

    timer_t* cur_timer = timer_root;
    while(cur_timer->next) {
        if(new_timer->time < cur_timer->next->time) {
            new_timer->next = cur_timer->next;
            cur_timer->next = new_timer;
            return;
        }       
    }

    cur_timer->next = cur_timer;
    return;
}

void insert_timer(uint32_t init_time, uint32_t period, uint32_t config, handler_t handler) {
    timer_t* new_timer = malloc(sizeof(timer_t));
    new_timer->time = init_time;
    new_timer->period = period;
    new_timer->config = config;
    new_timer->handler = handler;
    new_timer->next = NULL;

    if(!timer_root) {
        timer_root = new_timer;
        start_timer(new_timer->time);
        return;
    }

    // calculate elapsed time, this is the the crystals value because we reset the timer everytime
    update_timers(get_timer_val());
}

void update_timers(uint32_t elapsed_time) {
    timer_t* cur_timer = timer_root;
    while(cur_timer) {
        cur_timer->time -= elapsed_time;
        cur_timer = cur_timer->next;
    }

    while(timer_root->time == 0) {
        timer_root->handler();
        // ONESHOT
        if(timer_root->config && TIMER_MODE) {
            timer_t* deleted = timer_root;
            timer_root = timer_root->next;
            free(deleted);
            deleted = NULL;
        }
        else {
            timer_t* new_timer = timer_root;
            timer_root = timer_root->next;
            new_timer->next = NULL;
            new_timer->time = new_timer->period;
            insert_timer_inorder(new_timer);
            new_timer = NULL;
        }
    }
}

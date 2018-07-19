#include "header.h"
#include "task.h"

//test task
void task0(void *args) {
    printf("in task 0...\n");
    for (int i = 0; i < 2000; i++) {
        
    }
    task_yield(0);
}

void thing(void *args) {
    printf("doing another task...\n");
    
    task_yield(0);
}

int main(void) {
    SYSTEM_Initialize();
    printf("initializing task system... ");
    printf((!task_init(TASK_TIMER)) ? "success.\n" : "fail.\n");
    
    task_add(task0, 1, NULL);
    task_add(thing, 1, NULL);
    
    printf("system ready.\n");
    task_start();
    
    return -1;
}
#include "header.h"
#include "task.h"

//test task
void task(void *args) {
    printf("in user task 0...");
    printf(" tick is %d\n", get_system_tick());
    task_yield(0);
}

int main(void) {
    SYSTEM_Initialize();
    printf("initializing task system... ");
    printf((!task_init(TASK_TIMER)) ? "success.\n" : "fail.\n");
        
    user_task_add(task, NULL);
    
    printf("system ready.\n");
    task_start();
    
    return -1;
}
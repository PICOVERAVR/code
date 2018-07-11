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
    task_init();
    
    task_add(task0, 1);
    task_add(thing, 1);
    
    printf("system ready.\n");
    task_start();
    
    return -1;
}
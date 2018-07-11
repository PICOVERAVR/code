#include "header.h"
#include "sd.h"
#include "tft.h"

typedef struct {
    void (*func)(void *);
    int tid;
    int priority;
    struct task_buf *next;
} task_buf;

static jmp_buf state;
static task_buf *task_bufptr;
static task_buf *task_buftop;

void __attribute__((noreturn)) task_null(void *args) {
    longjmp(state, 1);
}

void __attribute__((noreturn)) task0(void *args) {
    printf("in task 0...\n");
    for (int i = 0; i < 2000; i++) {
        
    }
    longjmp(state, 1);
}
void __attribute__((noreturn)) task1(void *args) {
    printf("in task 1...\n");
    for (int i = 0; i < 2000; i++) {
        
    }
    longjmp(state, 2);
}

int task_add(void (*task_func)(void *), int priority, static task_buf *task_buftop) {
    return 0;
}

//this is called in main task after flag is set by timer1 ISR
int task_switch(void) {
    
}

int main(void) {
    SYSTEM_Initialize();
    //heap set to 16384 bytes in system properties
    volatile int *task_run = calloc(1, sizeof(int)); //the task that is currently running
    volatile int *num_tasks = calloc(1, sizeof(int)); //number of tasks that are in queue
    //queueing system is round robin to start off with...
    
    if (!task_run) {
        printf("heap not configured.\n");
        halt();
    }
    
    task_buftop = task_bufptr;
    
    task_bufptr = malloc(sizeof(task_buf));
    task_bufptr->func = task_null;
    task_bufptr->next = task_bufptr;
    task_bufptr->priority = 0;
    task_bufptr->tid = 0;
    
    printf("system ready.\n");
    
    setjmp(state);
    
    printf("in master thread, task is %d\n", *task_run);
    
    switch (*task_run) {
        case 0: 
            (*task_run)++;
            task0(NULL);
        case 1: 
            (*task_run)++;
            task1(NULL);
        case 2:
            free((void *) task_run);
            printf("hit 2\n");
            halt();
    }
    return -1;
}

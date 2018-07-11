#include "task.h"

static jmp_buf task_main; //processor state of master task to come back to
task_buf *task_bufbot; //pointer to bottom of queue
task_buf *task_buftop; //pointer to top of queue
//the difference between the two above pointers is pretty minimal
//since the buffer is circular

static volatile int *num_tasks;

//null task that does nothing
//this is to ensure that there is always at least one task running
static void task_null(void *args) {
    printf("in null task...\n");
    task_yield(0);
}

//add a task to the task pool
task_buf *task_add(void (*task_func)(void *), int priority) {
    task_buf *task_new = malloc(sizeof(task_buf));
    if (!task_new) {
        return NULL;
    }
    task_new->func = task_func;
    task_new->next = task_bufbot;
    task_buftop->next = task_new;
    task_new->priority = priority;
    task_new->tid = *num_tasks + 1;
    
    task_buftop = task_new;
    return task_new;
}

//remove a tasl from the pool
void task_remove(task_buf *buf, task_buf *prev) {
    prev->next = buf->next;
    free(buf);
}

//switch to the next task
static void task_switch(void) {
    task_buftop = task_buftop->next;
}

//called by user when task is done
void task_yield(int exit) {
    longjmp(task_main, exit);
}

//this function sets up tasks to be executed but
//does not execute them!
int task_init(void) {
    num_tasks = calloc(1, sizeof(int));
    
    if (!num_tasks) {
        printf("heap not configured.\n");
        return -1;
    }
    
    task_buf *task_null_buf = malloc(sizeof(task_buf));
    if (!task_null_buf) {
        printf("ERROR: cannot create null task!");
        return -2;
    }
    //the null task has to be created seperately from everything else
    //as there are no tasks to build off of
    task_null_buf->func = task_null;
    task_null_buf->next = task_null_buf;
    task_null_buf->priority = 0;
    task_null_buf->tid = 0;
    
    
    task_buftop = task_null_buf;
    task_bufbot = task_null_buf;
    return 0;
}

//this is to actually hand off control to a task
void task_start(void) {
    setjmp(task_main);
    task_switch();
    task_buftop->func(NULL);
}
#include "task.h"


//TODO:
    //add priority scheduling - figure out how to avoid resource starvation!
    //make sure this stuff works... none of it is tested yet
    //forcing everything through a void* is really annoying... is there a better way to do this?


static jmp_buf task_main; //processor state of master task to come back to
task_buf *task_bufbot; //pointer to bottom of queue
task_buf *task_buftop; //pointer to top of queue
//the difference between the two above pointers is pretty minimal
//since the buffer is circular

//this has to be volatile since tasks do not return, instead they yield
static volatile int *num_tasks;

//null task that does nothing
//this is to ensure that there is always at least one task running
static void task_null(void *args) {
    printf("in null task...\n");
    task_yield(0);
}

//bump the tick counter
//check against random magic number!
static void task_timer(void *timer_arg) {
    int *p = (int*) timer_arg;
    (*p > 0xFF00) ? *p = 0 : (*p)++;
}

//allocate resources for the system tick counter
static void task_timer_init(void) {
    int *p = calloc(1, sizeof(int));
    task_add(task_timer, 1, (void *)p);
}

//if the task is a system task, assume it is issued with a fixed tid
//task_null - 0
//task_timer - 1

int get_system_tick(void) {
    //find the timer task
    task_buf *timer = task_find(1);
    return *((int*) timer->args);
    return NULL;
}

//find a task by pid, returns NULL if not found
task_buf *task_find(int target) {
    task_buf *n = task_buftop;
    int start = n->tid;
    
    for (; n->tid != target; n = n->next) {
        if (n->tid == start) {
            return NULL;
        }
    }
    return n;
}

//add a task to the task pool, return that task's task_buf
task_buf *task_add(void (*task_func)(void *), int priority, void *args) {
    task_buf *task_new = malloc(sizeof(task_buf));
    if (!task_new) {
        return NULL;
    }
    task_new->func = task_func;
    task_new->next = task_bufbot;
    task_buftop->next = task_new;
    task_new->priority = priority;
    task_new->tid = *num_tasks + 1;
    task_new->args = args;
    
    task_buftop = task_new;
    return task_new;
}

//remove a task from the pool
void task_del(task_buf *buf, task_buf *prev) {
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

//no support for adding multiple extensions yet
static int task_noncrit_init(include incl) {
    switch (incl) {
        case TASK_MONITOR: break;
        case TASK_TIMER:
            task_timer_init();
            break;
        case TASK_NONE: break;
        default: break;
    }
    return 0;
}

//this function sets up tasks to be executed but does not execute them!
int task_init(include incl) {
    num_tasks = calloc(1, sizeof(int));
    
    if (!num_tasks) {
        printf("ERROR: heap not configured.\n");
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
    
    //if software timers or other stuff are needed, init them here
    task_noncrit_init(incl);
    
    return 0;
}

//this is to actually hand off control to a task
//calls a function with the argument pointer stored in the task_buf
void task_start(void) {
    setjmp(task_main);
    task_switch();
    task_buftop->func(task_buftop->args);
}